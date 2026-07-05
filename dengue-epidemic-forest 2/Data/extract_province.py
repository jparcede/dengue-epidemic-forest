"""
Extract a Region-12 province from the CHD12 DOH line-list into the same per-LGU
daily-count structure the epidemic-forest pipeline uses.

Run from VS Code (or a terminal), from inside this Data/ folder:

    pip install pandas openpyxl
    python extract_province.py "NORTH COTABATO"

Writes <Province>_daily.csv (rows = dates 2015-01-01..2020-12-31, columns = LGUs).
No coordinates needed for this step.
"""
import sys
from pathlib import Path
import numpy as np
import pandas as pd
import warnings
warnings.filterwarnings("ignore")

HERE = Path(__file__).resolve().parent
DB = HERE / "CHD12 DENGUE MDB 2015-2021.xlsx"      # the line-list, in this folder
YEARS = ["2015", "2016", "2017", "2018", "2019", "2020"]

def norm(s):
    """Normalise an LGU name: strip, upper-case, fix known spelling variants."""
    s = str(s).strip().upper().replace("Ñ", "N")
    fix = {"BANG": "BANGA", "PIGKAWAYAN": "PIGCAWAYAN"}
    return fix.get(s, s)

def load_province(province, db=DB, years=YEARS):
    prov = norm(province)
    frames = []
    for y in years:
        d = pd.read_excel(db, sheet_name=y, usecols=["Province", "Muncity", "DOnset"],
                          engine="openpyxl")
        d["P"] = d["Province"].map(norm)
        d["M"] = d["Muncity"].map(norm)
        d = d[d["P"] == prov].copy()
        d["DOnset"] = pd.to_datetime(d["DOnset"], errors="coerce")
        frames.append(d.dropna(subset=["DOnset"]))
    df = pd.concat(frames, ignore_index=True)
    df = df[(df["DOnset"] >= "2015-01-01") & (df["DOnset"] <= "2020-12-31")]
    lgus = sorted(df["M"].unique())
    ref = pd.date_range("2015-01-01", "2020-12-31", freq="D")
    daily = (df.groupby(["DOnset", "M"]).size().rename("n").reset_index()
               .pivot(index="DOnset", columns="M", values="n")
               .reindex(index=ref, columns=lgus).fillna(0).astype(int))
    return lgus, daily

if __name__ == "__main__":
    province = sys.argv[1] if len(sys.argv) > 1 else "NORTH COTABATO"
    lgus, daily = load_province(province)
    print(f"{province}: {len(lgus)} LGUs, daily matrix {daily.shape}, "
          f"{int(daily.values.sum())} cases 2015-2020")
    print("LGUs:", lgus)
    print("\ntotal cases per LGU:")
    print(daily.sum().sort_values(ascending=False).to_string())
    out = HERE / f"{province.title().replace(' ', '_')}_daily.csv"
    daily.to_csv(out)
    print(f"\nsaved {out.name}")
