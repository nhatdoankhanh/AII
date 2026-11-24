from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "artifacts"
# Dùng mã tuổi BRFSS ở nhánh khảo sát, tuổi theo năm ở hồ sơ xét nghiệm.
FIELDS = {
    "age": ("Tuổi (năm)", 0, 100), "age_band": ("Nhóm tuổi BRFSS (1–13)", 1, 13),
    "bmi": ("BMI (kg/m²)", 10, 90), "female": ("Giới tính nữ", 0, 1),
    "bp": ("Tiền sử tăng huyết áp", 0, 1), "heart": ("Tiền sử bệnh tim", 0, 1),
    "a1c": ("HbA1c (%)", 2, 20), "glucose": ("Đường huyết (mg/dL)", 20, 600),
    "active": ("Có vận động trong tháng qua", 0, 1),
    "chol": ("Tiền sử cholesterol cao", 0, 1),
    "auto": ("Tự kháng thể dương tính", 0, 1), "gene": ("Xét nghiệm di truyền dương tính", 0, 1),
    "steroid": ("Tiền sử dùng steroid", 0, 1), "cf": ("Đã chẩn đoán xơ nang", 0, 1),
    "family": ("Tiền sử gia đình", 0, 1), "early": ("Triệu chứng khởi phát sớm", 0, 1),
    "waist": ("Vòng eo (giá trị theo bộ 04)", 20, 54),
}
LAB = ["age","bmi","female","bp","heart","a1c","glucose"]
SURVEY = ["age_band","bmi","female","bp","heart","active","chol"]
SPECIAL = ["auto","gene","steroid","cf","family","early","waist"]
TYPE = ["age","bmi","glucose"] + SPECIAL
FEATURES = list(FIELDS)
TYPES_VI = {
    "Type 1 Diabetes":"Đái tháo đường típ 1", "Type 2 Diabetes":"Đái tháo đường típ 2",
    "Gestational Diabetes":"Đái tháo đường thai kỳ", "LADA":"Đái tháo đường tự miễn tiềm ẩn ở người lớn",
    "MODY":"Đái tháo đường đơn gen MODY", "Neonatal Diabetes Mellitus (NDM)":"Đái tháo đường sơ sinh",
    "Secondary Diabetes":"Đái tháo đường thứ phát", "Steroid-Induced Diabetes":"Đái tháo đường do steroid",
    "Type 3c Diabetes (Pancreatogenic Diabetes)":"Đái tháo đường típ 3c",
    "Cystic Fibrosis-Related Diabetes (CFRD)":"Đái tháo đường liên quan xơ nang",
    "Wolfram Syndrome":"Đái tháo đường liên quan hội chứng Wolfram",
    "Wolcott-Rallison Syndrome":"Đái tháo đường liên quan hội chứng Wolcott–Rallison",
}
CLASSES = sorted(TYPES_VI)
