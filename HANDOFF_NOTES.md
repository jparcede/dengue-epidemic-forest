# Project handoff notes — Dengue epidemic-forest paper

_Last updated: July 2026. This note captures the **why** behind the current state
so anyone (including Claude in Cowork, starting fresh) can pick up the work without
re-deriving the decisions. Read this first._

---

## 1. What this paper is

A city-level (LGU-scale) **epidemic forest** reconstruction of dengue transmission
in **South Cotabato and General Santos City**, Region 12 (SOCCSKSARGEN),
Philippines, 2015–2020, across **three outbreak periods**. Twelve LGUs: the eleven
municipalities/city of South Cotabato plus General Santos City.

**Status:** pre-submission draft. No journal, no reviewers yet.

**Authors & affiliations** (corrected — the original draft had Nuning and Jayrold
swapped):
- Maria Yulita Trida Tahu — ITB
- Nuning Nuraini — ITB
- Kamal Sukandar — ITB + Imperial College London (Centre for the Mathematics of Precision Healthcare)
- Jayrold P. Arcede — Caraga State University
- John Lemuel Dalisay, Alah Baby C. Vingno — IPHO South Cotabato (DOH partner)

---

## 2. The scope decision (settled)

The data and code cover **only the twelve South Cotabato / GenSan LGUs**. An
earlier draft claimed nine provinces / 121 LGUs in the abstract, intro, and
Table 1, but every result is those twelve. We committed to the **South Cotabato
case study** — honest and finishable. All nine-province apparatus was cut.

Do **not** re-expand to nine provinces without processing the other eight
provinces' data first (we don't have it).

---

## 3. The most important thing: relationship to Nasution et al. 2024

**Nasution, Sitorus, Sukandar, Nuraini, Apri, Salama (2024), _Scientific Reports_
14:7619, DOI 10.1038/s41598-024-58390-3** is the **sister paper** — the
region-scale epidemic forest applied to ARI in Jakarta. **Kamal and Nuning
co-author both it and this paper.**

What that paper already did (so these are **NOT novel** here and must be
attributed to it):
- adapting Li et al.'s individual-level forest to **aggregated administrative units**;
- **case prevalence** as a third Strength-of-Linkage criterion (their Eq. 5);
- **Richards / logistic onset** estimation;
- **R_t and R_c**, dominant trees, and the intervention-by-case-suppression idea.

**This paper's genuine delta** (and it is a real one): Nasution restricts candidate
parents to a **fixed binary adjacency** matrix and reports a single deterministic
forest, and their Discussion explicitly names "inter-regional connectivity and
networks" as missing future work. We replace the fixed adjacency with a
**probabilistic distance-decay connectivity network** (Eq. 4 in the compiled
`.tex`, `P_ij = exp(-λd)`)
and reconstruct the forest as a **Monte-Carlo ensemble** with **per-edge
stability** — i.e. we build the thing they flagged as missing, plus the first
Philippine dengue application.

**Action item:** the current `.tex` cites Nasution and positions against it
correctly, but **Kamal should be looped in early** — this is a collegial
priority-of-work / framing question about our own group's prior paper, best
handled up front, not discovered later. He will likely welcome it (citing the
group's Jakarta paper and framing this as the connectivity follow-up strengthens
both).

## Anchor references (verified by reading the full papers)
- **Li et al. 2019**, _Ann. AAG_ 109(3):812–836, DOI 10.1080/24694452.2018.1511413
  — the original epidemic forest: **individual-level** (node = patient),
  **space + time only** (no prevalence), R_t via kernel density at
  global/tree/pixel scales.
- **Haydon et al. 2003** — the original epidemic _trees_, at **farm (unit) level**;
  this is why LGU-scale reconstruction is a legitimate lineage, not a degraded Li.
- Supporting the exponential kernel choice: **Ng & Wen 2019** (Sci Rep 9:19172),
  **Routledge et al. 2021** (Sci Rep 11:14495).

---

## 4. Contribution framing (as written in the revised .tex)

1. **Probabilistic connectivity layer + ensemble reconstruction** (the delta over
   Nasution — prevalence/region-scale attributed to them; network + ensemble +
   edge stability are ours).
2. **First directional dengue transmission hierarchy among Philippine LGUs.**
3. **Translational utility at the RA 11332 response scale** (LGU is the unit of
   both surveillance and action).

---

## 5. The code — what was wrong and what is verified

The pipeline notebook (`epidemic_forest_pipeline.ipynb`) is a **corrected** Python
port of the original MATLAB workflow. Key points:

- **Smoothing (the important fix):** MATLAB `smooth(x,60)` is **not**
  `pandas.rolling(60, center=True, min_periods=1).mean()`. MATLAB drops even span
  60 → odd 59 and uses a symmetric shrinking window at the edges. The function
  `matlab_smooth` reproduces the shipped `SmoothMergedData.mat` to **7e-15
  (machine precision)** — there's a self-check cell that prints this. Trust
  `matlab_smooth`, not pandas rolling.
- **Onset reproduction caveat:** rebuilding onsets in Python (Sobol + L-BFGS-B)
  does **not** bit-match MATLAB (`sobolset` + `fmincon`) — it reproduced 21/36
  `NormalizedOnset` cells exactly. Because onsets are normalised by the per-period
  **column minimum**, one city's differing fit can shift a whole period. So:
  **keep `USE_SHIPPED_ONSET = True`** (loads `NormalizedOnset.mat`) to match the
  manuscript; set it False only for a fully Python-native (slightly different) run.
- **`epidemic_forest_ensemble(...)`** is the single wired-in function: one call
  returns, per period, the modal parent, **edge stability**, **R_{c,i}**, and
  global R_t. It writes `edge_stability.csv` and `city_reproduction_Rc.csv`.
- Ensemble settings (MATLAB-matched): `KMAX=5000`, `SEED=0`, `λ=5`, incubation 5
  days, SoL weights 1/3 each.

---

## 6. The real results (what the paper should claim)

Computed from the corrected pipeline on the shipped onsets:

- The "**same hierarchical structure recurs across periods**" claim from the old
  draft is **false** — only **Lake Sebu ← T'boli** is the modal parent in all
  three periods. Do not assert a fixed tree.
- What **is** stable is the **source/sink partition**: **Surallah** is the dominant
  source in Periods 1–2 (R_c = 3 each), **Banga** the Period-3 hub (R_c = 4), and
  **General Santos City never seeds anyone (R_c = 0 in all periods)** — the
  large urban coastal LGU is a consistent terminal recipient. This supports the
  **rural-periphery → urban-centre** tendency (defensible), not an identical tree.
- Global R_t (definition-dependent; report R_{c,i} as primary) = **5.0 / 2.0 / 5.0**
  for Periods 1–3.
- **The Discussion must NOT mention Libungan (R_t = 2).** Libungan is a *North
  Cotabato* LGU, not in this dataset — it's a leftover from the North Cotabato
  study this pipeline was forked from. Replaced with Surallah / Banga / GenSan +
  R_{c,i}.

Numbers live in `edge_stability.csv` and `city_reproduction_Rc.csv`; regenerate
them with a single Run All if the pipeline changes.

---

## 7. Files in this folder

**Folder was decluttered (July 2026).** The **root now holds only the active
pipeline files**; everything else was sorted into subfolders. `DATA_DIR` still
points at the root and all pipeline inputs/outputs stayed there, so nothing about
the run changed — verified with a full Run All after the move (smoothing self-check
7.11e-15, shipped-onset path, 0 errors). **Nothing was deleted**; superseded/junk
images were moved (not removed) to `figures/_old/`.

**Root (active pipeline — do not move these):**

| File | What it is |
|---|---|
| `epidemic_forest_pipeline.ipynb` | Corrected pipeline + `epidemic_forest_ensemble`; Run All regenerates the CSVs |
| `dengue_forest_revised.tex` / `.pdf` | Revised manuscript (South Cotabato scope), compiles clean |
| `South_Cotabato_General Santos.xlsx` | DOH daily case workbook (sheets 2015–2020) |
| `SmoothMergedData.mat`, `NormalizedOnset.mat` | MATLAB outputs — **must be present** for the manuscript-matching path |
| `DailyMat2015.mat` … `DailyMat2020.mat` | Per-year daily matrices (MATLAB) |
| `edge_stability.csv`, `city_reproduction_Rc.csv` | Generated result tables |
| `HANDOFF_NOTES.md` | This file |

**Subfolders:**

| Folder | Contents |
|---|---|
| `references/` | Anchor-reference PDFs: Li et al. (Annals19…), Nasution/sister paper (s41598-024-58390-3), Haydon 2003 |
| `matlab_legacy/` | Original MATLAB workflow (12 `.m` scripts: `Step_1`…`Step_6`, `Coba`, etc.). Superseded by the notebook; kept for provenance. Not called by the pipeline |
| `figures/` | Current figure candidates for the `.tex`: `RCperiode*`, `R0periode*`, `onset*`, `Epi1–3`, `time-series`, `clusternew`, `periodenew` |
| `figures/_old/` | Superseded/duplicate/junk images: `Cluster`, `epidemic1–3`, `period1/3/4`, `periode`, `untitled`, `South.gif`. Kept, not deleted |
| `archive/` | `SimulationData.xlsx` — simulation output, not a pipeline input |

**Config:** set `DATA_DIR` in the notebook to this folder (the root). Keep the
`.xlsx` **and** the `.mat` files together at the root, or the notebook silently
falls back to recomputing onsets (off the manuscript path). Kernel: `pinnsir_arm`
(Python 3.10). Stack: numpy, pandas, scipy, openpyxl, matplotlib; `pdflatex` to
compile the `.tex`.

---

## 8. Open items / TODO

1. **Figures — DONE (July 2026).** All three `\figph{...}` placeholders replaced
   with real `figure` environments; added `\graphicspath{{figures/}}`; compiles
   clean via `pdflatex` (12 pp), figures number 1/2/3.
   - **Fig 1** — two-panel: `time-series.jpg` (raw heatmap) + `clusternew.jpg`
     (hierarchically clustered). **Notebook §9 now reproduces both panels** in
     green (`Greens`): a faithful Python port of the MATLAB agglomerative
     clustering (`matlab_cluster_order`) reproduces `clusternew.jpg`'s exact leaf
     order (GenSan, Polomolok, Tampakan, T'boli, Santo Niño, Lake Sebu, Tantangan,
     Norala, Surallah, Banga, Tupi, Koronadal); writes `figures/heatmap_two_panel.png`.
     **Paper Fig 1 SWAPPED to `heatmap_two_panel.png`** (July 2026) — now
     pipeline-generated and green, consistent with Fig 3. (The MATLAB
     `time-series.jpg`/`clusternew.jpg` remain in `figures/` if ever needed.)
   - **Fig 2** — `onset_vs_cases.png`, onset vs **per-capita incidence**, pooled
     Pearson $r=-0.67$ (see 1a). **Now reproduced in notebook §12**
     (`plot_onset_vs_incidence`); also still available as standalone
     `make_onset_scatter.py`. The notebook now generates all of Figs 1–3.
   - **Fig 3** — `Epi1/2/3.jpg` (per-period forest maps). Caption corrected from
     "edges coloured by stability" to "arrows show modal parent-to-child
     direction" — the static images draw directional red arrows, not
     stability-coloured edges. **Notebook Section 10 (`plot_modal_forest`) now
     reproduces these maps in Python** (nodes at LGU coords sized/coloured by
     burden; arrows = modal parent→child, width ∝ stability; writes
     `figures/forest_period{1,2,3}.png`). Optional shaded-relief terrain basemap
     via contextily (`Esri.WorldShadedRelief`) when online, clean fallback
     otherwise. **Paper Fig. 3 now SWAPPED to `forest_period{1,2,3}.png`** (Jayrold's
     call) — this fixes a real inconsistency: the old MATLAB `Epi*.jpg` were the
     deterministic forest and **disagreed with the paper's own Tables 3/4** (e.g.
     Period 1: `Epi1.jpg` showed T'boli←Tampakan and Koronadal←Banga, but the
     ensemble modal parents are T'boli←Banga and Koronadal←Surallah). The Python maps
     are derived from the same `results` as Tables 3/4, so they are consistent.
     **DONE:** Jayrold re-ran §10 locally so the three PNGs now carry the
     shaded-relief terrain basemap (≈1.75 MB each); paper recompiled — Fig 3 shows
     the terrain-mapped ensemble forests for all three periods. (If §10 is ever
     re-run offline, the PNGs revert to the clean no-basemap fallback; re-run with
     internet to restore terrain.)

1a. **Figure 2 / onset claim — RESOLVED (Jayrold chose per-capita; still worth a
   heads-up to Kamal).** The old §3.2 line *"Total cases decrease consistently as
   onset time increases"* is **false for raw counts** (pooled standardised Pearson
   **r = +0.28**, later onset → *more* cases — General Santos City, ~697k pop, has
   both the latest onset and the most cases and dominates). It holds only for
   **per-capita incidence** (per 100k: pooled **r = −0.67**; per period
   −0.77 / −0.44 / −0.80). **Decision taken:** plot & describe incidence per 100k.
   §3.2 sentence rewritten to "Per-capita dengue incidence … decreases consistently
   as onset time increases … (pooled standardised Pearson $r=-0.67$)" with a clause
   noting raw counts are weaker/population-dominated; Fig 2 caption matches.
   Generator: `make_onset_scatter.py` (in this folder; reads only shipped `.mat`,
   notebook untouched) → writes `figures/onset_vs_cases.png`. Rerun with
   `python3 make_onset_scatter.py`.
2. **Lock Table 3/4 to the CSVs — DONE (July 2026).** Programmatically diffed both
   `.tex` tables against `edge_stability.csv` / `city_reproduction_Rc.csv`. The
   R_{c,i} table (`tab:rc`) already matched exactly. The stability table
   (`tab:stability`) had **two** stale cells vs the current run — Banga P3
   Tampakan 47→**46%** and General Santos City P3 Polomolok 49→**48%** — now
   corrected; no prose referenced those numbers. Re-diff reports 0 mismatches in
   both tables; verify script logic lives in the git history of this session /
   reproducible from the two CSVs.
3. **Kamal / Nasution conversation** (see §3) — do early.
4. **Harmonise SoL to Nasution's Eq. 5 — DONE (July 2026, Jayrold's call).** Code +
   Eq. 2 now use Nasution's exact Strength of Linkage: **maximise**
   $\alpha/\tilde d + \beta/\widetilde{\Delta o} + (1-\alpha-\beta)\tilde p$, with
   distances **min-normalised** and prevalence as a normalised **difference**
   $\tilde p=(p_j-p_c)/\max|p_k-p_c|$ (was: mean-normalised, inverse-prevalence,
   **minimised**). Notebook: `SOL_MODE="nasution"` (default; `"current"` still
   available as fallback). Both papers now share one SoL — the paper's *delta* over
   Nasution is now cleanly just the connectivity network + ensemble + edge stability.

   **Results changed — narrative rewritten.** Global $R_t$ = 5/2/5 unchanged and
   **General Santos City stays terminal** ($R_c=0$ all periods), but the dominant
   source **flips from rural Surallah to Koronadal City (the provincial capital)**:
   new $R_c$ — Koronadal City [4,4,1], Tupi [2,2,1], Banga [0,0,4], Surallah [2,1,1];
   recurrent-in-all-3 edges are now Lake Sebu←T'boli **and** Polomolok←Tupi. Rewrote
   abstract, §3.3 (heading "stable **inland** sources and a consistently terminal
   **coastal** centre"), Discussion, Conclusion, contributions ("inland-to-coastal
   source–sink tendency"); the "rural periphery → urban centre" framing is gone.
   Tables 3/4 regenerated from the new CSVs (0 mismatches); paper compiles clean, 12 pp.

   **TWO THINGS TO CLOSE:**
   - **Loop Kamal in on the science** — this both unifies the SoL across the group's
     two papers *and* changes the paper's headline finding (capital as hub, not rural
     source). The interpretation was drafted to fit the numbers; the causal story is
     for Jayrold + Kamal to validate. (Kamal brief in `KAMAL_BRIEF_*` should be
     updated to mention the SoL is now harmonised.)
   - **Re-run notebook §10 locally (internet on)** to restore the terrain basemap on
     the new-structure `forest_period*.png` (Fig 3); the shipped ones are the plain
     sandbox fallback. Then recompile.
5. **Heatmap colour — DONE (July 2026).** §9 notebook heatmap `cmap` changed from
   `"hot"` (red) to `"Greens"` per Jayrold's preference for green. Easy to swap to
   another green variant (`"YlGn"`, `"GnBu"`) if wanted. (The forest-map nodes in
   §10 still use `"YlOrRd"` for burden — left reddish unless asked to green it too.)

6. **SoL weights α, β — sensitivity analysis added, NOT "optimized" (July 2026).**
   Jayrold asked whether α=β=1/3 should be optimized. Key point: this is an
   **unsupervised** reconstruction (no ground-truth network), so weights can't be
   fit/optimized in a supervised sense — and Nasution themselves don't use 1/3; they
   run a sensitivity analysis and **select** prevalence-heavy weights per period
   (their Table 2: P1 0.15/0.15/0.70, P2–3 0.25/0.25/0.50). Decision: **add a
   weight-sensitivity analysis** (new §3.4 + Table 5, notebook §11,
   `weight_sensitivity.csv`) over Nasution's 8 weight combinations, and **keep
   α=β=1/3 as the transparent equal-weight baseline**. Findings are robust: global
   $R_t$ = 5/2/5 (7/8 combos; 5/2/3 in the most prevalence-heavy), **GenSan terminal
   ($R_c=0$) in all 8 combos & all periods**, Koronadal City dominant P1–2 in 7/8,
   Banga P3 hub in 5/8; mean stability 0.48–0.56. So the 1/3 choice does not drive
   the conclusions. Notebook §11 reproduces Table 5 (slowest cell, ~1–2 min at
   KMAX=5000). Also a **Kamal-relevant method choice** (same SoL family as the sister
   paper) — noted in the updated Kamal brief only implicitly; mention if it comes up.

**Already fixed in `dengue_forest_revised.tex`** (don't redo): affiliations,
abstract, contributions, related-work positioning, positioning table, γ overload,
Eq. 4 index, `p_ij` definition, orphaned Notes, Li 2019 DOI, the four new refs.

**Also fixed (July 2026, this session):** all three figures wired (§ item 1);
Tables 3/4 locked to CSVs (item 2); Fig 2 = per-capita incidence (item 1a);
**Table 1 (`tab:positioning`) overflow** — the three yes/no columns were plain
`c` columns whose headers ran off the right margin; converted to centered wrapping
`p{}` columns at `\footnotesize` with rebalanced widths and shortened header
"Needs individual data?"→"Individual data?"; now fits (largest remaining overfull
<4pt, invisible). **Sentence fixes:** abstract "eleven municipalities"→"twelve
LGUs"; methods "the eleven municipalities and city of South Cotabato"→"the eleven
LGUs of South Cotabato—ten municipalities and the component city of Koronadal—…";
smoothing rationale "raw series do not exhibit a clear pattern"→"raw daily counts
are noisy"; loosened non-breaking ties in "Lake~Sebu $\leftarrow$ T'boli" to clear
a 45pt line overflow. Compiles clean, 12 pp.

7. **Detailed reproducible methodology + SoL appendix — DONE (July 2026).** Added,
   for reproducibility: an explicit **reconstruction algorithm** (step-by-step
   ensemble loop) in §2.3.4; a consolidated **parameters table** (now Table 3 —
   smoothing span, period bounds, threshold, incubation, λ, weights, M, seed,
   Euclidean centroid distance, Python 3.10 stack) in a new §2.3.6; a **Code and
   data availability** section pointing to `epidemic_forest_pipeline.ipynb`; and an
   expanded clustering description for Fig 1. Added **Appendix A — "Strength of
   Linkage: construction and normalisation"**: full derivation of the adopted
   Nasution Eq. 5 form (min-normalised distances D̃s/D̃t, prevalence difference P̃,
   inverse-distance + maximise), with a transparency note that the code also carries
   the earlier mean-normalised/minimised variant (`SOL_MODE`), which gives a related
   but not identical partition. **Table renumbering:** parameters=Table 3,
   stability=Table 4, R_c=Table 5, sensitivity=Table 6 (all via `\ref`, auto-updated).
   Compiles clean, **15 pp**.

8. **Framing + grounded application (July 2026).** Positioned the paper as
   **methodological (quantified linkage uncertainty via the probabilistic network +
   ensemble + edge stability) demonstrated on the South Cotabato case** (Jayrold's
   call). Sharpened the intro gap ("uncertainty ... left unquantified ... the central
   methodological aim"); fixed a lingering "eleven municipalities" → "twelve LGUs".
   **Grounded the application via a news/literature scan:** the three periods are the
   **2015, 2016–17, and 2019** outbreak seasons (Period 3 = the 2019 national
   epidemic; SOCCSKSARGEN ~200% rise; South Cotabato state of calamity) — added to
   §2.1 and §2.2. **Added corroboration in the Discussion:** Ygoña, Deligero &
   Ceballos (2025, *Recoletos Multidiscip. Res. J.* 13(1):33–43) independently found
   the dominant dengue cluster over **Polomolok + Koronadal City** (SaTScan/Moran's I,
   2020–2022), supporting our Koronadal-as-source finding by a different method on a
   non-overlapping period. **New refs:** `Ygona2025`, `DOH2019epi`, `DOH12_2019`
   (the two DOH refs are placeholder-style — replace with exact WHO/DOH report
   citations + URLs before submission). Compiles clean, **15 pp**, no undefined cites.

9. **Post-rerun verification + bibliography audit (July 2026).** After Jayrold
   re-ran the notebook: figures/CSVs regenerated (deterministic seed → **Tables 4/5
   still match the CSVs, 0 mismatches**; forest maps keep the terrain basemap; onset
   scatter now from notebook §12). **Bibliography audited:** of 31 refs only
   `LiShi2020` was uncited — now cited in the Discussion's multi-scale sentence (its
   natural home), so **all 31 are used, 0 undefined**. Verified every quantitative
   claim in the narrative against the tables; strengthened the abstract and
   conclusion with the two supporting facts (robustness to weights + independent
   RMRJ corroboration). Compiles clean, **16 pp**.

10. **Multi-province generalisation — pipeline refactored (July 2026).** The
   notebook now uses a **province registry** (`PROVINCES` dict + `ACTIVE_PROVINCE`
   selector) instead of hardcoded constants; `CITIES/POPULATION/COORDINATES/PERIODS`
   come from the active province. Data path branches on `source`: `"shipped"` =
   South Cotabato's exact manuscript path (workbook + `.mat`); `"chd12"` = extract
   from `Data/CHD12 DENGUE MDB 2015-2021.xlsx` via `load_province_daily`, then
   `matlab_smooth` + Python-native onsets. **Backward compatibility verified twice:
   default (`south_cotabato`) reproduces Tables 4/5 byte-identical.** North Cotabato
   config is in (18 LGUs, 2015 pops from citypopulation.de); data branch tested
   (2192×18, 21,471 cases). **Blocked on:** centroid coordinates (Jayrold, from GIS)
   + PSA population check + per-province outbreak-period selection from the heatmap.
   Then: run N. Cotabato ensemble, add a "Cross-province validation" paper section.
   Goal stays **method-robustness validation** (methodology-led; SC = worked example).
   Standalone loader also at `Data/extract_province.py`. See memory
   `dengue-multiprovince-data`. Pre-refactor notebook backed up in outputs.

   **DONE (July 2026): paper section + notebook integration for cross-province.**
   Paper: new **§3.5 "Preliminary cross-province validation" + Table 7** (dominant
   source per province: Koronadal City / Kidapawan City / Isulan capitals + Glan;
   clearly marked PRELIMINARY — GeoNames town-centre coords, provisional SK/Sarangani
   pops, reused windows). Compiles clean, **16 pp**. Notebook: config now reads
   validation-province metadata from `Data/<Province>_lgus.csv`; added `geonames_coords`
   helper (reproducible offline coord sourcing) and **§13 "Cross-province validation"**
   with `run_validation_province` + a `RUN_VALIDATION` flag (default False; ~1–2 min;
   writes `cross_province_summary.csv` + per-province folders). SC backward-compat
   re-verified byte-identical; §13 verified (Sarangani→Glan). Coords finalised from
   GeoNames (~81%); **still need PSA pops (SK/Sarangani) + optional GIS centroids +
   per-province period selection** before this is submission-final.

11. **Paper reframed for cross-province validation (July 2026, Jayrold's call).**
   Chosen framing: **"case study + preliminary validation"** (not a full multi-province
   reframe). **Title** now "...a South Cotabato case study with preliminary
   cross-province validation in Region 12, Philippines." **Abstract** adds the
   cross-province sentence; **intro** contributions preamble notes the generalisability
   check; **Methods §2.1 rewritten** — data source named as the DOH CHD12 Region-12
   line-list, pipeline described as province-agnostic, validation provinces introduced;
   **Discussion** adds a generalisation paragraph (explicitly PRELIMINARY); **Conclusion**
   adds a cross-province sentence. §3.5 + Table 7 unchanged. Compiles clean, 16 pp,
   bibliography 31/31 used. **Kamal-relevant** (scope/framing) — this elevates the
   generalisation into the title/abstract, so flag it in the Kamal conversation. The
   cross-province results remain PRELIMINARY (need PSA pops for SK/Sarangani + GIS
   centroids + per-province periods) — the paper says so throughout. Added a
   **\section{Limitations}** (unsupervised/weak edges, aggregation, model dependence,
   surveillance under-reporting, onset non-bit-reproducibility, preliminary metadata)
   — 17 pp. **Kamal brief + cover email updated** to address all ITB co-authors
   (Kamal, Nuning, Maria) and cover the reframe + limitations.

12. **Mathematics audited (July 2026).** Traced every equation (Eqs. 1–8 + appendix)
    against the code and checked internal consistency numerically: Σ R_c = children
    per period, R_t = children/primaries = 5/2/5, SoL ranges (D̃≥1, 1/D̃∈(0,1],
    p̃∈[−1,1]), no div-by-zero (candidates have Δo>incubation>0, distinct-LGU dist>0).
    **Math is correct and the code matches it.** Two clarity fixes applied (not bugs):
    (a) **Eq. 7** reworded — $P_t$ = **primary/index** LGUs (was ambiguous "parent LGUs"),
    $C_{pt}$ = descendants (= non-primaries), and $R_{c,i}$ = **direct** children;
    (b) **Eq. 2** footnote-style note added mapping the fitted 4-param Richards form
    $C_1[1+C_2 e^{-C_3(t-C_4)}]^{-1/C_2}$ to $(K,\mu,r)$ with $\tau_i=C_4+\ln C_2/C_3$.
    Noted (not fixed, declared in text): distances are Euclidean on lon/lat degrees
    (negligible anisotropy at 6°N). Compiles clean, 17 pp.

13. **Fig 3 caption was being cut off — FIXED (July 2026).** Root cause: three
    stacked maps at `0.8\textwidth` were taller than the A4 text block, so the caption
    overflowed the page bottom and its end was clipped. Fix: shrank the three images
    to **`0.62\textwidth`** (and `\\[3pt]` spacing); the full caption now fits on the
    page. Node encoding is **colour = burden** (kept as-is per Jayrold; an
    onset-colour variant was tried then reverted). **Note:** SC forest PNGs were
    regenerated in-sandbox (no basemap) during this — **re-run §10 locally to restore
    the terrain basemap** (colour=burden).

14. **Revisions from a ChatGPT self-critique of the current PDF (July 2026, Jayrold
    ran the model as a mock reviewer — these are NOT real journal reviewers).** The mock
    review moved from "Major revision" (on an OLD text-only PDF that lacked the figures)
    to **"Minor revision / borderline accept"** on the current draft. Its five actionable
    asks were addressed:
    - **"validation" → "transferability/generalisability" (incl. title)** — Jayrold's
      call to change everywhere. Title now "…a South Cotabato case study with a
      preliminary cross-province **transferability assessment** in Region 12"; §3.5
      heading, Table 7 caption, and abstract/methods/discussion wording updated.
      ("validate/validation" kept only where it means ground-truth validation.)
    - **"city reproduction number" → "LGU reproduction number"** — Jayrold's call to
      rename now. **Symbol $R_{c,i}$ and the Nasution attribution are unchanged; only the
      English label changed.** *FLAG FOR KAMAL:* this is Nasution-inherited terminology —
      mention it in the ITB conversation (fully reversible if the group prefers the original).
    - **λ = 5 justification** — new paragraph in §2.3.3: decay length $1/\lambda = 0.2^{\circ}
      \approx 22$ km (half-prob $\approx 15$ km), matched to short-range Aedes dispersal;
      forward-references the new robustness section.
    - **General Santos "always terminal" paradox** — new Discussion paragraph: it onsets
      *after* the inland hubs (so it is assigned as recipient), terminal concerns *timing*
      not burden, and Euclidean distance cannot see its long-range road/commuter links;
      flagged as the result most sensitive to the distance assumption and a priority for
      the mobility extension.
    - **Outbreak-window rationale** — §2.2 now states the windows were chosen by visual
      inspection corroborated by DOH surveillance / known epidemic years, with an
      algorithmic change-point procedure (PELT / binary segmentation) named as future work
      (the reviewer said merely mentioning it suffices).

    **NEW robustness suite (Jayrold chose the fuller version) — reviewer point #1, the
    strongest.** New **§3.4 subsubsection "Decay rate, kernel form, and network type" +
    Table 8 + Fig. 4** (`kernel_robustness.csv`, `figures/kernel_robustness.png`). Re-ran
    the full $M=5000$ ensemble under $\lambda\in\{1,2,3,5,8,12\}$, a Gaussian kernel
    matched at its half-probability distance, and a deterministic adjacency matched to the
    $\lambda=5$ mean degree (Nasution-style fixed matrix). **Result: GenSan $R_c=0$ in
    EVERY setting and period; Koronadal (P1–2) and Banga (P3) are dominant in ALL 8
    settings.** $\lambda$ only tunes network density → $R_t$ magnitude (small $\lambda\to
    R_t\approx11$; large $\lambda\to0$; baseline $\lambda=5\to5/2/5$). The deterministic
    adjacency reproduces the baseline $R_t=5/2/5$ but with stability $\equiv1.0$ — exactly
    the over-confidence the ensemble avoids (true mean modal stability $\approx0.53$).
    Baseline $\lambda=5$ reproduces the manuscript numbers exactly (RNG stream preserved).
    **Notebook: new §14** (`epidemic_forest_kernel` + `_adj_from_prob`; runs the suite,
    writes the CSV + Fig 4; cells compile and were verified against the shipped `.mat`).
    Limitations kernel sentence updated accordingly. Compiles clean, **19 pp**.
    **DROPPED (not needed at Minor revision; kept in back pocket):** Richards-fit CIs/GoF,
    smoothing-window comparison, actually implementing change-point, and $R_c$ ensemble
    distributions.

15. **Second ChatGPT self-critique pass — "Accept after Minor Revisions" (July 2026).**
    Another Jayrold-run mock review of the current PDF (NOT a journal). Five minor items,
    all addressed:
    - **Proof-of-concept wording (abstract):** added a sentence that the cross-province
      exercise is a *proof-of-concept of portability, not a formal validation* (coords /
      some pops still provisional).
    - **60-day smoothing — justified + sensitivity run.** Added a rationale in §2.2 (noisy
      low-count LGU series; matches outbreak-season timescale; reproduces the MATLAB
      pipeline) and a new **§3.4 subsubsection "Smoothing window"**: re-estimated onsets at
      14/30/60-day spans — onset *ordering* stable across 30–60 d (Spearman ρ vs 60-d
      baseline = 0.98/0.86/0.96 at span 30, mean 0.93; earliest-onset LGUs Tupi P1 & Banga
      P2 invariant), while a 14-d window degrades ordering (P2 ρ=0.65) → confirms the longer
      window. Reproducible in **notebook §15** (`smoothing_sensitivity.csv`; Python-native
      onsets, n_starts=512, labelled as an ordering check).
    - **Outbreak windows (§2.2):** reworded so PELT / binary segmentation / **Bayesian**
      change-point are "considered but not adopted, to preserve comparability with the
      health office's reporting periods" + future work.
    - **General Santos (Discussion):** strengthened to state the terminal result is
      *conditional on the assumed connectivity + aggregation*; transport/commuter/mobile
      data could alter it; cautioned against reading it as an intrinsic property.
    - **R_t / R_c terminology (Jayrold's call — FLAG FOR KAMAL, it is Nasution-shared).**
      Renamed **R_t "case reproduction ratio" → "forest reproduction ratio"** and added a
      sentence at Eq. 7 clarifying both R_t and R_{c,i} are structural forest summaries
      (branching ratio / out-degree, counting *units seeded*), **not** the classical
      effective reproduction number, despite the shared symbol. **R_c kept as "LGU
      reproduction number"** (Jayrold affirmed it; it is a reproduction number in the forest
      sense) — offered to rename to "out-degree index" too if wanted. Nomenclature table
      updated. Compiles clean, **20 pp**. Symbols R_t / R_{c,i} unchanged.

16. **Switched to a FULLY PYTHON-NATIVE pipeline (July 2026, Jayrold's call — "use
    python only, not matlab").** Dropped the shipped MATLAB onsets (`NormalizedOnset.mat`)
    as the source of truth; onsets are now computed in Python (`extract_onsets`,
    Sobol + L-BFGS-B, n_starts=2048) and are the definitive results. **All MATLAB
    references removed** from the paper, notebook, and README (smoothing relabelled a
    "centred moving-average"; `matlab_smooth`→`moving_average`; notebook default
    `USE_SHIPPED_ONSET=False`; Limitation 5 / the bit-match caveat deleted).
    **Headline numbers shifted (regenerated everything):** global **R_t = 5/2/3** (was
    5/2/5); **General Santos still terminal, R_c=0 in 100% of the 5,000 realisations**;
    Koronadal City still dominant P1–2 (top source in 67%/55% of realisations); Period-3
    hub is now a weaker inland lead (**Banga R_c=2**, top in 55%, vs Surallah/Tantangan),
    not a clear R_c=4. New recurrent-all-3 edges: Lake Sebu←T'boli, Polomolok←Tupi,
    **Santo Niño←Surallah** (three, was two). Regenerated Tables 4/5/6/8, Figs 2/3
    (`onset_vs_cases.png` pooled r=−0.70; plain forest maps — re-run §10 for terrain),
    and CSVs. **Added** ensemble-frequency statements (#3) and an **onset-threshold
    robustness** subsection (§3.4): θ∈{10,25,50,100}/100k — Koronadal dominant P1–2 at
    every θ, GenSan terminal (out-degree ≤1, and =0 at θ≤50). Compiles clean, **21 pp**.
    **Kamal-relevant** (moves the harmonised-SoL headline R_t); brief + HANDOFF updated.

17. **Tables/numbers reconciled to Jayrold's actual notebook run (July 2026) + ENV-
    DEPENDENCE flagged.** Jayrold ran the Python-only notebook on his Mac; the resulting
    CSVs differ slightly from the sandbox reproduction because the onset optimiser
    (SciPy `qmc.Sobol` + `L-BFGS-B`) is **not bit-identical across environments/library
    versions**. Jayrold's run is the source of truth; Tables 4/5/6/8 and all inline
    numbers were transcribed from his CSVs. Headline now: **R_t = 5.0 / 1.4 / 5.0**
    (P2≈1.4, P3 back to 5.0); **Koronadal City dominant P1–2 (R_c 4/3/0)**; **Banga leads
    P3 (R_c=3)**; **General Santos terminal (R_c=0) in every period and every weight/
    kernel/network setting** (verified from Tables 6 & 8). Recurrent-all-3 edges:
    Lake Sebu←T'boli, Polomolok←Tupi, Santo Niño←Surallah. Smoothing subsection rewritten
    honestly (P1 ρ≈0.97–0.99, P2 ρ≈0.87–0.89, **P3 ρ≈0.60–0.71 — sensitive**). Ensemble-
    frequency percentages **removed** (env-dependent, unverifiable); replaced with the
    verifiable "GenSan terminal + Koronadal dominant across every robustness setting."
    Onset-threshold subsection made qualitative + reproducible via **notebook §16**
    (`onset_threshold.csv`). Forest maps = Jayrold's terrain-basemap run. Compiles clean,
    **21 pp**.
    **OPEN — reproducibility fix worth doing:** to make results bit-reproducible for
    reviewers, ship Jayrold's Python-computed onsets as a fixed intermediate and have the
    notebook load them by default (a cell can save `normalized_onset.csv`); otherwise a
    reviewer re-running may get slightly different R_c/R_t (same qualitative conclusions).

18. **R_t renamed to LGU branching ratio (LBR) (July 2026, Jayrold's call — FLAG FOR
    KAMAL).** After earlier keeping R_t, Jayrold chose to rename it to pre-empt the
    reviewer objection that our period-level ratio is not the classical effective
    reproduction number. Changed **both name and symbol: $R_t \to \mathrm{LBR}$**
    (defining eq $\mathrm{LBR}_t=C_{pt}/P_t$) throughout the paper, notebook (display
    labels; code var `global_Rt` kept), README, and CITATION. Nasution-shared
    terminology, so flagged in the Kamal brief; trivially reversible. Compiles clean, 20 pp.

18a. **R_c also renamed to LGU out-degree index (LOI) (July 2026, Jayrold's call, next
    review round).** $R_{c,i} \to \mathrm{LOI}_i$ throughout paper/notebook/README/
    CITATION (name "LGU reproduction number" → "LGU out-degree index (LOI)"). Code
    identifiers kept: `build_rc_table`, and the output filename `city_reproduction_Rc.csv`
    (internal artifact — not renamed to avoid breaking the notebook/README/zips). Also
    added a Conclusion future-work sentence (province-specific windows, authoritative
    coordinates, mobility-informed network). Compiles clean, 20 pp. Both R_t→LBR and
    R_c→LOI flagged for Kamal.

**Not applicable yet:** response-to-reviewers letter — there are no reviewers
(pre-submission; the July-2026 mock reviews above were Jayrold's own ChatGPT critiques, not
a journal). Don't draft one until the journal responds.
