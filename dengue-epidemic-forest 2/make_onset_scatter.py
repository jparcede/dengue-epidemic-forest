# Standalone generator for Figure 2: standardised onset vs per-capita dengue
# incidence across the 3 outbreak periods. Reads ONLY the shipped MATLAB outputs
# (SmoothMergedData.mat, NormalizedOnset.mat) — the manuscript path. Does not
# touch epidemic_forest_pipeline.ipynb. Writes figures/onset_vs_cases.png.
# Run:  python3 make_onset_scatter.py     (run from this folder)
from pathlib import Path
import numpy as np
from scipy.io import loadmat
import matplotlib; matplotlib.use("Agg")
import matplotlib.pyplot as plt

DATA = Path(__file__).resolve().parent
CITIES=["BANGA","KORONADAL CITY","LAKE SEBU","NORALA","POLOMOLOK","SANTO NINO",
        "SURALLAH","TBOLI","TAMPAKAN","TANTANGAN","TUPI","GENERAL SANTOS CITY"]
POP=np.array([89164,195398,87442,44642,152589,39796,89340,91453,41018,45744,73459,697315],float)
PERIODS=[(115,319),(509,800),(1549,1796)]
sm=loadmat(str(DATA/"SmoothMergedData.mat"))["SmoothMergedData"].astype(float)
NO=loadmat(str(DATA/"NormalizedOnset.mat"))["NormalizedOnset"].astype(float)

def z(x):
    x=np.asarray(x,float);m=np.isfinite(x);o=np.full_like(x,np.nan)
    o[m]=(x[m]-x[m].mean())/x[m].std(ddof=0);return o

fig,ax=plt.subplots(figsize=(7,5))
colors=["#1b9e77","#d95f02","#7570b3"]; markers=["o","s","^"]; zx_all=[];zy_all=[]
for K,(a,b) in enumerate(PERIODS):
    incidence=sm[a:b,:].sum(0)/POP*1e5
    zx,zy=z(NO[:,K]),z(incidence)
    ax.scatter(zx,zy,c=colors[K],marker=markers[K],s=55,edgecolor="k",
               linewidth=0.4,alpha=0.85,label=f"Period {K+1}")
    zx_all+=list(zx);zy_all+=list(zy)
zx_all=np.array(zx_all);zy_all=np.array(zy_all);m=np.isfinite(zx_all)&np.isfinite(zy_all)
r=np.corrcoef(zx_all[m],zy_all[m])[0,1]; b1,b0=np.polyfit(zx_all[m],zy_all[m],1)
xs=np.linspace(zx_all[m].min(),zx_all[m].max(),100)
ax.plot(xs,b0+b1*xs,"k--",lw=1.5,label=f"OLS (r = {r:.2f})")
ax.set_xlabel("Standardised onset time (within period)")
ax.set_ylabel("Standardised incidence per 100,000 (within period)")
ax.set_title("Onset time vs per-capita incidence across outbreak periods")
ax.legend(frameon=False,fontsize=9); ax.grid(alpha=0.25); fig.tight_layout()
(DATA/"figures").mkdir(exist_ok=True)
fig.savefig(str(DATA/"figures"/"onset_vs_cases.png"),dpi=200)
print(f"saved figures/onset_vs_cases.png; pooled per-capita Pearson r = {r:.3f}, n = {m.sum()}")
