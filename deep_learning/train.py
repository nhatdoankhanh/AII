"""Chạy từ thư mục dự án: python -m deep_learning.train"""
import copy
import json
import os
from pathlib import Path
import numpy as np
import pandas as pd
import torch
from sklearn.metrics import accuracy_score, balanced_accuracy_score, f1_score, confusion_matrix, roc_curve
from torch.nn import functional as F
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from .model import ROOT, ART, FEATURES, CLASSES, JointNet, encode

SEED = 27
NUM_EPOCHS = 10

def load_data():
    pieces, labels, sources, audit = [], [], [], {}
    for number in ["01","03","04"]:
        frame = pd.read_csv(ROOT / "Data" / f"diabetes_dataset_{number}.csv")
        raw_count = len(frame)
        frame = frame.drop_duplicates().copy()
        if number == "01":
            x = frame.rename(columns={"hypertension":"bp","heart_disease":"heart","HbA1c_level":"a1c","blood_glucose_level":"glucose"}).copy()
            x["female"] = frame.gender.map({"Female":1,"Male":0})
            y = frame.diabetes
        elif number == "03":
            # Mã 1 là tiền tiểu đường: loại khỏi bài toán có/không đái tháo đường.
            x = frame.loc[frame.Diabetes_012.isin([0,2])].rename(columns={"Age":"age_band","BMI":"bmi","HighBP":"bp","HighChol":"chol","HeartDiseaseorAttack":"heart","PhysActivity":"active"}).copy()
            x["female"] = 1 - x.Sex
            y = (x.Diabetes_012 == 2).astype(int)
        else:
            x = frame.loc[frame.Target.isin(CLASSES)].rename(columns={"Age":"age","BMI":"bmi","Blood Glucose Levels":"glucose","Waist Circumference":"waist"}).copy()
            for key, col in {"auto":"Autoantibodies","gene":"Genetic Testing","steroid":"Steroid Use History","cf":"Cystic Fibrosis Diagnosis","family":"Family History","early":"Early Onset Symptoms"}.items():
                x[key] = x[col].map({"Positive":1,"Yes":1,"Negative":0,"No":0})
            y = x.Target.map({k:i for i,k in enumerate(CLASSES)})
        x = x.reindex(columns=FEATURES).astype("float32")
        pieces.append(x)
        labels.extend(y)
        sources.extend([number] * len(x))
        audit[number] = {"raw":raw_count,"used":len(x)}
    return pd.concat(pieces, ignore_index=True), np.array(labels), np.array(sources), audit

def evaluate(net, x, y, src, cuts=None):
    with torch.inference_mode():
        preds = [net(chunk) for chunk in x.split(2048)]
        prob = torch.cat([p[0] for p in preds]).sigmoid().numpy()
        types = torch.cat([p[1] for p in preds]).argmax(1).numpy()
    cuts = {} if cuts is None else cuts.copy()
    metrics, conf = {}, {}
    for s, name in [("01","lab"),("03","survey"),("04","type")]:
        mask = src == s
        gold = y[mask]
        if s == "04":
            pred = types[mask]
        else:
            if name not in cuts:
                fp,tp,th = roc_curve(gold, prob[mask])
                cuts[name] = float(th[np.argmax(tp-fp)])
            pred = (prob[mask] >= cuts[name]).astype(int)
        metrics[name] = {"accuracy":float(accuracy_score(gold,pred)),"balanced_accuracy":float(balanced_accuracy_score(gold,pred)),"macro_f1":float(f1_score(gold,pred,average="macro")),"n":int(mask.sum())}
        conf[name] = confusion_matrix(gold,pred).tolist()
    score = (metrics["lab"]["balanced_accuracy"] + metrics["survey"]["balanced_accuracy"] + metrics["type"]["macro_f1"])/3
    return float(score),metrics,cuts,conf

def plots(frame, y, src, runs, con):
    charts = ART / "charts"
    charts.mkdir(exist_ok=True)
    plt.rcParams.update({"font.size":9,"figure.dpi":135,"axes.spines.top":False,"axes.spines.right":False})
    def save(fig, name):
        fig.tight_layout()
        fig.savefig(charts / name, bbox_inches="tight")
        plt.close(fig)
    fig, ax = plt.subplots(1,3,figsize=(11,3))
    for a,s in zip(ax,["01","03","04"]):
        vals = np.bincount(y[src==s])
        a.bar(range(len(vals)),vals,color="#227664")
        a.set(title="Bộ "+s,xlabel="Mã nhãn",ylabel="Số mẫu")
    save(fig,"01-phan-bo.png")
    cols=["age","bmi","a1c","glucose","bp","heart"]
    names=["Tuổi","BMI","HbA1c","Glucose","THA","Bệnh tim"]
    fig,a=plt.subplots(figsize=(5.6,4))
    corr=frame.loc[src=="01",cols].corr().values
    im=a.imshow(corr,vmin=-1,vmax=1,cmap="BrBG")
    a.set(xticks=range(6),yticks=range(6),xticklabels=names,yticklabels=names,title="Tương quan Pearson · Bộ 01")
    for i,j in np.ndindex(corr.shape):
        a.text(j,i,f"{corr[i,j]:.2f}",ha="center",va="center",color="white" if abs(corr[i,j])>.65 else "black")
    fig.colorbar(im,ax=a)
    save(fig,"02-tuong-quan.png")
    fig,a=plt.subplots(figsize=(7,3.6))
    for kind,hist in runs.items():
        a.plot(range(1,len(hist)+1),hist,marker="o",label=kind)
    a.set(xlabel="Epoch",ylabel="Điểm chọn mô hình",title="So sánh trên tập validation")
    a.legend()
    save(fig,"03-so-sanh.png")
    def matrix(a, counts, labels, title, font):
        arr=np.array(counts)
        a.imshow(arr/np.maximum(arr.sum(1,keepdims=True),1),vmin=0,vmax=1,cmap="GnBu")
        a.set(xticks=range(len(labels)),yticks=range(len(labels)),xticklabels=labels,yticklabels=labels,xlabel="Dự đoán",ylabel="Nhãn thực",title=title)
        for i,j in np.ndindex(arr.shape):
            a.text(j,i,str(arr[i,j]),ha="center",va="center",fontsize=font,color="white" if arr[i,j]/max(1,arr[i].sum())>.6 else "black")
    fig,axes=plt.subplots(1,2,figsize=(7,3.4))
    for a,mode,title in zip(axes,["lab","survey"],["Xét nghiệm · 01","Bảng hỏi · 03"]):
        matrix(a,con[mode],["Âm","Dương"],title,10)
    save(fig,"04-sang-loc.png")
    fig,a=plt.subplots(figsize=(7,5.4))
    matrix(a,con["type"],list(range(len(CLASSES))),"Thể bệnh · mã lớp theo bảng kết quả",7)
    save(fig,"05-the-benh.png")

def main():
    torch.set_num_threads(min(4,os.cpu_count() or 1))
    torch.manual_seed(SEED)
    frame,y,src,audit=load_data()
    # Hồ sơ có cùng đầu vào luôn cùng một tập, kể cả khi nhãn khác nhau.
    buckets=pd.util.hash_pandas_object(frame,index=False).to_numpy() % 100
    train,val,test = buckets < 70,(buckets>=70)&(buckets<85),buckets>=85
    raw=frame.to_numpy()
    mean=np.nanmean(raw[train],axis=0)
    scale=np.nanstd(raw[train],axis=0).clip(.001)
    x=torch.from_numpy(encode(raw,mean,scale))
    ytorch=torch.from_numpy(y).long()
    for s in audit:
        audit[s]["split"]=[int(np.sum(mask & (src==s))) for mask in (train,val,test)]
    print("split",audit,flush=True)
    pools=[torch.from_numpy(np.where(train & (src==s))[0]) for s in ("01","03","04")]
    ART.mkdir(exist_ok=True)
    xv,xt=x[val],x[test]
    runs, winners = {}, {}
    best=-1
    for kind in ("MLP","ResNet","Gated"):
        torch.manual_seed(SEED)
        net=JointNet(kind)
        opt=torch.optim.AdamW(net.parameters(),lr=.0015)
        runs[kind]=[]
        generator=torch.Generator().manual_seed(SEED)
        for epoch in range(NUM_EPOCHS):
            net.train()
            # Batches mixtes équilibrés par source; chaque source est parcourue à chaque époque.
            perms=[p[torch.randperm(len(p),generator=generator)] for p in pools]
            steps=max(1,int(np.ceil(max(map(len,perms))/768)))
            for batch in range(steps):
                chunks=[p[(torch.arange(384)+batch*384)%len(p)] if len(p)<steps*384 else p[batch*len(p)//steps:(batch+1)*len(p)//steps] for p in perms]
                idx=torch.cat(chunks)
                a,b=net(x[idx])
                n1,n2=map(len,chunks[:2])
                targets=ytorch[idx]
                loss=(F.binary_cross_entropy_with_logits(a[:n1],targets[:n1].float())+F.binary_cross_entropy_with_logits(a[n1:n1+n2],targets[n1:n1+n2].float())+F.cross_entropy(b[n1+n2:],targets[n1+n2:]))/3
                opt.zero_grad(); loss.backward(); opt.step()
            net.eval()
            score,metrics,cuts,_=evaluate(net,xv,y[val],src[val])
            runs[kind].append(score)
            if score >= max(runs[kind]):
                winners[kind]={"score":score,"epoch":epoch+1,"validation":metrics}
            if score>best:
                best=score
                checkpoint={"kind":kind,"state":copy.deepcopy(net.state_dict()),"mean":mean.tolist(),"scale":scale.tolist(),"cuts":cuts}
            print(kind,epoch+1,round(score,4),flush=True)
    net=JointNet(checkpoint["kind"]);net.load_state_dict(checkpoint["state"]);net.eval()
    _,metrics,_,conf=evaluate(net,xt,y[test],src[test],checkpoint["cuts"])
    torch.save(checkpoint,ART/"model.pt")
    report=dict(winner=checkpoint["kind"],data=audit,candidates=winners,test=metrics,cuts=checkpoint["cuts"],classes=CLASSES,confusion=conf)
    (ART/"metrics.json").write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding="utf-8")
    plots(frame,y,src,runs,conf)
    print("Saved",checkpoint["kind"],metrics,flush=True)

if __name__=="__main__":
    main()
