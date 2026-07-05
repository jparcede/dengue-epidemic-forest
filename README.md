# Ensemble epidemic forest for city-level dengue surveillance — South Cotabato & General Santos City

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21203290.svg)](https://doi.org/10.5281/zenodo.21203290)

Reproducible code for the manuscript *"Adapting the region-scale epidemic forest
for city-level dengue surveillance with quantified linkage uncertainty: a South
Cotabato case study with a preliminary cross-province transferability assessment in
Region 12, Philippines."*

The method reconstructs directional dengue transmission among the twelve LGUs of
the study area (2015–2020) as a **Monte-Carlo ensemble** of epidemic forests over a
**probabilistic distance-decay connectivity network**, reporting per-edge stability,
per-LGU out-degree indices (LOI), and per-period LGU branching ratios (LBR). The
Strength of Linkage follows Nasution et al. (2024), *Sci. Rep.* 14:7619.

## Contents

| File | What it is |
|---|---|
| `epidemic_forest_pipeline.ipynb` | Full pipeline; a single Run All reproduces every figure and table |
| `make_onset_scatter.py` | Standalone generator for Figure 2 (also reproduced in notebook §12) |
| `DailyMat*.mat`, `SmoothMergedData.mat` | Cached daily/smoothed case matrices (data; read with `scipy.io.loadmat`). Optional — the pipeline recomputes them |
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

- §2–4 centred moving-average smoothing (span 60) → underlies **Fig. 1**
- §5 Richards-curve onset estimation → Eqs. 1–3
- §6 ensemble reconstruction → Eqs. 4–8; **Tables 4–5**
- §9 two-panel heatmap → **Fig. 1**
- §10 modal epidemic forest maps → **Fig. 3** (terrain basemap needs internet)
- §11 weight-sensitivity analysis → **Table 6**
- §12 onset vs per-capita incidence → **Fig. 2**

## Reproducibility notes

- Fixed RNG seed (`SEED = 0`), `M = 5000` network realisations. The Monte-Carlo
  ensemble is deterministic given the onsets.
- **Onset cache (`normalized_onset.csv`).** The onset estimator (SciPy Sobol +
  L-BFGS-B) is not bit-identical across SciPy versions, so the onsets are cached: the
  first run writes `normalized_onset.csv`, and every subsequent run — on any machine —
  loads it and reproduces the exact tables and figures in the manuscript. This file is
  committed to the repository; delete it to recompute onsets from scratch.
- `SOL_MODE = "nasution"` uses the harmonised Strength of Linkage (manuscript);
  `"current"` toggles the earlier mean-normalised/minimised variant.
- The Figure 3 terrain basemap uses `contextily`; without internet it falls back to
  a clean lon/lat plot.

## Data availability

This repository includes only the **aggregated daily case matrices** required to
reproduce the analysis (`DailyMat*.mat`, read in Python with `scipy.io.loadmat`);
smoothing and onset estimation are then computed natively in Python. The
underlying LGU-level dengue counts were obtained from the Integrated Provincial
Health Office of South Cotabato (Department of Health) and are **available from the
corresponding author on reasonable request**, subject to applicable restrictions.
Population figures are from the Philippine Statistics Authority (2015 Census).

## License

Code is released under the **MIT License** (see `LICENSE`).

## Repository

<https://github.com/jparcede/dengue-epidemic-forest>

## Citation

If you use this code, please cite both the paper and the archived software:

- **Paper:** full citation to be added on acceptance.
- **Software archive:** *Ensemble epidemic forest for city-level dengue surveillance*
  (v1.0.0). Zenodo. https://doi.org/10.5281/zenodo.21203290

BibTeX for the software archive:

```bibtex
@software{arcede_dengue_epidemic_forest_2026,
  author    = {Tahu, Maria Yulita Trida and
               Nuraini, Nuning and
               Sukandar, Kamal and
               Arcede, Jayrold P. and
               Dalisay, John Lemuel and
               Vingno, Alah Baby C.},
  title     = {{Ensemble epidemic forest for city-level dengue
               surveillance --- South Cotabato \& General Santos City}},
  year      = {2026},
  publisher = {Zenodo},
  version   = {v1.0.0},
  doi       = {10.5281/zenodo.21203290},
  url       = {https://doi.org/10.5281/zenodo.21203290}
}
```
