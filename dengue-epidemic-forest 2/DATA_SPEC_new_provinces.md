# Data spec for adding a province (method-robustness validation)

To run the ensemble epidemic-forest pipeline on a new province, drop the following
into this folder. Match the format of the existing `South_Cotabato_General Santos.xlsx`
exactly, since the loader reads by **column position**.

## 1. Daily case workbook (one Excel file per province)

- **File:** `<Province>.xlsx` (e.g. `Sarangani.xlsx`).
- **One sheet per year**, named `"2015"`, `"2016"`, … (string year names).
- **Line-list format** — one row per reported case.
- **Row 1 is a header row** (its contents are ignored; data starts row 2).
- **Column B** = LGU name (city/municipality). *(2nd column)*
- **Column E** = onset date, formatted **`DD/MM/YYYY`**. *(5th column)*
- Columns A, C, D can hold anything (case ID, age, sex, …) — they're ignored.
- **Important:** the LGU names in column B must be spelled **consistently** and
  match the names in the metadata file below (case-insensitive is fine; I'll
  normalise, but consistent spelling avoids silent drops).

## 2. Per-LGU metadata (one small CSV per province)

- **File:** `<Province>_lgus.csv` with a header row and these columns:

```
LGU,Population,Latitude,Longitude,Type
Banga,89164,6.4235,124.7734,municipality
Koronadal City,195398,6.5003,124.8435,city
...
```

- **Population:** 2015 census (or state the census year used).
- **Latitude/Longitude:** LGU **centroid** coordinates (decimal degrees).
- One row per LGU that appears in the workbook (include every LGU in the province).

## 3. Outbreak periods (optional — I can help)

The current paper uses three manually selected period windows (day indices from
2015-01-01) chosen from clear shifts in outbreak intensity. For each new province I
can either (a) select comparable windows from its clustered heatmap, or (b) use
periods you specify. Tell me which.

---

## What I'll do once the files are in

1. **Generalise the notebook** to run per province (read the LGU list, populations,
   coordinates, and periods from these files instead of the hardcoded South Cotabato
   config) — I'll show you the plan before editing.
2. Process each province through the same pipeline (smoothing → onsets → probabilistic
   network → Monte-Carlo ensemble → per-edge stability, `SEED=0`, `M=5000`).
3. Add a **cross-province robustness** section: does the ensemble behave consistently,
   and does a source/sink pattern (e.g. inland population hub → terminal LGU) recur?

_Keeping the paper methodology-led: the extra provinces validate the method; the
South Cotabato case remains the worked example._
