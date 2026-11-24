import math
import numpy as np
import torch
from torch import nn

from .schema import ART, ROOT, FIELDS, FEATURES, LAB, SURVEY, SPECIAL, TYPE, CLASSES, TYPES_VI


def encode(raw, mean, scale):
    missing = ~np.isfinite(raw)
    values = np.where(missing, 0, (raw - mean) / scale)
    return np.concatenate([np.clip(values, -8, 8), (~missing).astype("float32")], axis=1).astype("float32")

class Block(nn.Module):
    def __init__(self, size, kind):
        super().__init__()
        self.kind = kind
        self.path = nn.Sequential(nn.Linear(size, size), nn.LayerNorm(size), nn.SiLU(), nn.Linear(size, size))
        if kind == "Gated":
            self.gate = nn.Linear(size, size)

    def forward(self, x):
        proposal = self.path(x)
        if self.kind == "Gated":
            proposal = torch.sigmoid(self.gate(x)) * proposal
        return torch.nn.functional.silu(x + proposal)

class JointNet(nn.Module):
    def __init__(self, kind):
        super().__init__()
        size = 64
        layers = [nn.Linear(2 * len(FEATURES), size), nn.SiLU()]
        if kind == "MLP":
            layers += [nn.Linear(size, size), nn.SiLU(), nn.Linear(size, size), nn.SiLU()]
        else:
            layers += [Block(size, kind), Block(size, kind)]
        self.shared = nn.Sequential(*layers)
        self.screen = nn.Linear(size, 1)
        self.subtype = nn.Linear(size, len(CLASSES))

    def forward(self, x):
        z = self.shared(x)
        return self.screen(z).flatten(), self.subtype(z)

class Predictor:
    def __init__(self):
        p = torch.load(ART / "model.pt", map_location="cpu", weights_only=True)
        self.net = JointNet(p["kind"])
        self.net.load_state_dict(p["state"])
        self.net.eval()
        self.mean, self.scale = np.array(p["mean"]), np.array(p["scale"])
        self.cuts = p["cuts"]

    @torch.inference_mode()
    def score(self, data, keys):
        row = np.array([[data.get(k, np.nan) if k in keys else np.nan for k in FEATURES]], dtype=float)
        return self.net(torch.from_numpy(encode(row, self.mean, self.scale)))

    def predict(self, values):
        mode = values.get("mode", "lab")
        if mode not in ("lab","survey"):
            raise ValueError("Chọn hồ sơ xét nghiệm hoặc bảng hỏi.")
        data = {}
        for k, (_, low, high) in FIELDS.items():
            if values.get(k) in ("", None):
                continue
            v = float(values[k])
            if not math.isfinite(v) or not low <= v <= high or (k in ["age_band","female","bp","heart","active","chol",*SPECIAL[:-1]] and not v.is_integer()):
                raise ValueError(f"Giá trị không hợp lệ cho {FIELDS[k][0]}.")
            data[k] = v
        if mode == "survey" and "age" in data:
            if data["age"] < 18:
                raise ValueError("Bảng hỏi BRFSS dành cho người từ 18 tuổi.")
            data["age_band"] = min(13, max(1, int((data["age"] - 25) // 5) + 2))
        keys = LAB if mode == "lab" else SURVEY
        required = set(keys) - ({"female"} if mode == "lab" else set())
        if required - data.keys():
            raise ValueError("Cần nhập " + ", ".join(FIELDS[k][0] for k in keys if k in required - data.keys()))
        logit, _ = self.score(data, keys)
        prob = float(torch.sigmoid(logit)[0])
        result = dict(mode=mode, score=prob, threshold=self.cuts[mode], positive=prob >= self.cuts[mode], subtype=None, reason="")
        if not result["positive"]:
            return result
        if any(k not in data for k in TYPE):
            result["reason"] = "Chưa đủ dữ liệu phân loại. Các mục còn thiếu: " + ", ".join(FIELDS[k][0] for k in TYPE if k not in data) + "."
            return result
        _, logits = self.score(data, TYPE)
        conf, idx = torch.softmax(logits[0], 0).max(0)
        label = CLASSES[int(idx)]
        unsuitable = (label == "Gestational Diabetes" and values.get("pregnant") != "yes") or (label == "Neonatal Diabetes Mellitus (NDM)" and data["age"] >= 1)
        if float(conf) < 0.55 or unsuitable:
            result["reason"] = "Chưa đủ căn cứ để gợi ý thể bệnh từ hồ sơ này."
        else:
            result["subtype"] = TYPES_VI[label]
        return result
