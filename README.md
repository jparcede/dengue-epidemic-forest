# Ensemble epidemic forest for city-level dengue surveillance — South Cotabato & General Santos City

Reproducible code for the manuscript *"Adapting the region-scale epidemic forest
for city-level dengue surveillance with quantified linkage uncertainty: a case
study in South Cotabato and General Santos City, Philippines."*

The method reconstructs directional dengue transmission among the twelve LGUs of
the study area (2015–2020) as a **Monte-Carlo ensemble** of epidemic forests over a
**probabilistic distance-decay connectivity network**, reporting per-edge stability,
city reproduction numbers $R_{c,i}$, and period reproduction ratios $R_t$. The
Strength of Linkage follows Nasution et al. (2024), *Sci. Rep.* 14:7619.

## Contents

| File | What it is |
|---|---|
| `epidemic_forest_pipeline.ipynb` | Full pipeline; a single Run All reproduces every figure and table |
| `make_onset_scatter.py` | Standalone generator for Figure 2 (also reproduced in notebook §12) |
| `SmoothMergedData.mat`, `NormalizedOnset.mat` | MATLAB intermediates the manuscript path loads (so results reproduce without MATLAB) |
| `requirements.txt` | Python dependencies |

## Reproduce

```bash
pip install -r requirements.txt
jupyter notebook epidemic_forest_pipeline.ipynb   # then Run All
```

Set `DATA_DIR` at the top of the notebook to this folder. Outputs written:
`edge_stability.csv` (Table 4), `city_reproduction_Rc.csv` (Table 5),
`weight_sensitivity.csv` (Table 6), and the figures under `figures/`.

## What each notebook section produces

- §2–4 smoothing (reproduces MATLAB `smooth(x,60)` to ~1e-15) → underlies **Fig. 1**
- §5 Richards-curve onset estimation → Eqs. 1–3
- §6 ensemble reconstruction → Eqs. 4–8; **Tables 4–5**
- §9 two-panel heatmap → **Fig. 1**
- §10 modal epidemic forest maps → **Fig. 3** (terrain basemap needs internet)
- §11 weight-sensitivity analysis → **Table 6**
- §12 onset vs per-capita incidence → **Fig. 2**

## Reproducibility notes

- Fixed RNG seed (`SEED = 0`), `M = 5000` network realisations.
- `SOL_MODE = "nasution"` uses the harmonised Strength of Linkage (manuscript);
  `"current"` toggles the earlier mean-normalised/minimised variant.
- The Figure 3 terrain basemap uses `contextily`; without internet it falls back to
  a clean lon/lat plot.

## Data availability

This repository includes only the **aggregated intermediates** required to
reproduce the analysis (`SmoothMergedData.mat`, `NormalizedOnset.mat`). The
underlying LGU-level dengue counts were obtained from the Integrated Provincial
Health Office of South Cotabato (Department of Health) and are **available from the
corresponding author on reasonable request**, subject to applicable restrictions.
Population figures are from the Philippine Statistics Authority (2015 Census).

## License

Code is released under the **MIT License** (see `LICENSE`).

## Repository

<https://github.com/jparcede/dengue-epidemic-forest>

## Citation

If you use this code, please cite the paper (full citation to be added on
acceptance) and this repository. <!-- TODO: add the Zenodo DOI once a release is archived. -->
