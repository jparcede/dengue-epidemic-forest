# A note to my co-authors — Kamal, Nuning, and Maria

Hi Kamal, Nuning, and Maria,

I wanted to put down, in one place, the four things about the South Cotabato
dengue epidemic-forest paper that I'd most like us to agree on early, while they're
still easy to change. They are: (a) how I've positioned this paper
relative to our group's Nasution 2024 Jakarta paper; (b) that I've **harmonised the
Strength of Linkage to Nasution's exact Eq. 5**, which (c) **changed the paper's
headline finding**; and (d) a **scope/title choice** now that I've applied the
method across several Region 12 provinces. I've put a short list of the limitations I
actually ran into at the end.

## What I'm asking, in one line

Nuning and Kamal are on **both** this paper and the Nasution 2024 Jakarta paper, and
Maria is a co-author here — so how we cite and build on the Jakarta work, and how
boldly we frame the multi-province results, feel like decisions we should make together
and up front. I think both moves *strengthen* the paper, but I want your read.

## The sister paper

**Nasution, Sitorus, Sukandar, Nuraini, Apri, Salama (2024),** _Scientific Reports_
14:7619 — the region-scale epidemic forest applied to acute respiratory infection in
Jakarta.

Here's what I think it already established, so I've attributed these to it and do
**not** claim them as novel here:

- adapting Li et al.'s individual-level epidemic forest to **aggregated administrative
  units**;
- **case prevalence** as a third Strength-of-Linkage criterion (their Eq. 5);
- **Richards / logistic onset** estimation;
- **R_t and R_c**, dominant trees, and the intervention-by-case-suppression idea.

## What's genuinely new here (and I think it's a real contribution)

Nasution restricts candidate parents to a **fixed binary adjacency** matrix and reports
a **single deterministic forest** — and the Discussion there explicitly names
"inter-regional connectivity and networks" as missing future work.

That's exactly what I've built here:

1. I replace the fixed adjacency with a **probabilistic distance-decay connectivity
   network** (Eq. 4, `P_ij = exp(-λd)`);
2. I reconstruct the forest as a **Monte-Carlo ensemble** (M = 5000 realisations) with
   **per-edge stability** rather than one tree;
3. it's the **first Philippine dengue application** of the approach.

So the honest framing I've gone with is: prevalence, region-scale aggregation, **and
now the exact Strength of Linkage (their Eq. 5)** are theirs; the **connectivity layer
+ ensemble + edge stability** are ours — we build the thing they flagged as future
work. I think citing our Jakarta paper as the direct predecessor makes the lineage a
strength, not an overlap.

## I harmonised the Strength of Linkage — and it changed the headline result

The paper previously used an equivalent but re-parameterised SoL (normalised by the
candidate mean, minimised), which I'd chosen for exact reproducibility. I've now
**adopted Nasution's exact Eq. 5** (maximised, inverse min-normalised distances,
prevalence difference), so **both papers use one identical linkage definition.** I think
that's cleaner and it strengthens the "same method, new connectivity layer" story.

**But it changed a central result, and Kamal, I'd really like your read before I lock
it in:**

- **Unchanged:** **General Santos City remains the consistent terminal recipient**
  (never seeds, all periods; R_c = 0 in 100% of the 5,000 realisations), and the global
  reproduction ratios are R_t = 5 / 2 / 3.
- **Changed:** the dominant source **flips from rural Surallah to Koronadal City — the
  provincial capital** (LGU reproduction number R_c = 4 in Periods 1–2; inland
  municipalities, Banga leading, take over in Period 3). The R_c: Koronadal City
  [4,4,0], Tupi [2,2,1], Surallah [2,1,2], Banga [0,0,2].
- **Narrative impact:** the framing moved from "rural periphery → urban centre" to
  "**inland administrative/population hub → coastal centre**." I rewrote the prose to
  match the numbers, but the *interpretation* of why the capital seeds is a scientific
  judgement I'd rather we confirm together.

**One thing that reassures me about the flip:** an independent study (Ygoña, Deligero &
Ceballos, 2025, *Recoletos Multidiscip. Res. J.*) analysed South Cotabato dengue for
2020–2022 with scan statistics (SaTScan / Moran's I) and found the **dominant
spatio-temporal cluster over Polomolok and Koronadal City**, attributing the urban
centre's high incidence to drainage and water-storage conditions. My ensemble reaches
the **same conclusion (Koronadal City as leading source) by a different method on a
non-overlapping window (2015–2019)** — so I read the harmonised result as corroborated,
not a modelling artefact. I think that makes the Koronadal finding an easier sell.

## How I've framed and positioned it

I've framed the paper as **methodological** — its contribution being *quantified linkage
uncertainty* (the probabilistic connectivity network + Monte-Carlo ensemble + per-edge
stability), demonstrated on the South Cotabato case, with references led by the
epidemic-forest / transmission-reconstruction lineage and the outbreak literature
supporting the application. I've grounded the three study periods as the **2015,
2016–17, and 2019** outbreak seasons (Period 3 = the 2019 national epidemic).

## The scope/title reframe — cross-province validation

Using the DOH Region 12 (CHD12) line-list, I applied the identical pipeline to **three
further provinces — North Cotabato, Sultan Kudarat, and Sarangani** — as a
generalisability check. The same signature recurs everywhere: an **inland
population/administrative hub (the provincial capital in 3 of 4 provinces) is the
dominant source, with peripheral/coastal LGUs terminal.** I went with a **"case study +
preliminary validation"** framing rather than a full multi-province reframe: the
**title** now reads *"…a South Cotabato case study with a preliminary cross-province
transferability assessment in Region 12"* (I softened "validation" to "transferability"),
and I updated the abstract/methods/discussion/conclusion to match, with a new results §3.5
and summary table. This lifts the generalisation into
the **title/abstract**, so it's a scope decision I'd like us to make together — the
alternative is to keep the South Cotabato title and hold the reframe until the
validation is final.

I've kept the validation **explicitly preliminary** and labelled it so throughout:
the coordinates are gazetteer town-centres (not GIS centroids), the Sultan
Kudarat/Sarangani populations are provisional (not PSA), and I reused the outbreak
windows. Finalising it needs PSA populations, GIS centroids, and per-province period
selection.

## Limitations I actually hit (now a Limitations section in the paper)

I think we should be upfront about these, since I ran into several of them directly:

- **No ground truth / unsupervised** — many individual edges are weakly determined
  (stability < 40%), so I report the stable source/sink partition, not exact trees.
- **Aggregation** — links are between LGUs, not individuals; onset fits are shakier for
  low-count LGUs.
- **Model dependence** — the dominant source depends on the SoL weights/kernel
  (now probed by the fuller robustness suite in §3.4 / Table 8 — stable across weights,
  decay rates, kernel form, and a deterministic adjacency — but I still note it).
- **Surveillance data** — under-reporting and report-based onset dates.
- **(Resolved) Pipeline is now fully Python** — the whole analysis (smoothing, onset
  estimation, ensemble) runs natively in Python, so there is no longer any MATLAB
  dependency or cross-software onset caveat.
- **Preliminary metadata** for the validation provinces (as above).

## A few specifics in the current draft worth flagging

So nothing catches you by surprise when you read the paper, a few choices I've made:

- **The cross-province work is framed as a *preliminary transferability assessment*, not a
  "validation"** — including in the title — since the metadata for those provinces is still
  provisional.
- **The out-degree metric is called the "LGU reproduction number"** (most of our units are
  municipalities, not cities). The symbol R_{c,i} and the attribution to your Eq. 5
  framework are unchanged.
- **The decay rate λ = 5 is justified explicitly** — it corresponds to a decay length of
  ≈ 22 km (half-probability ≈ 15 km), which matches the short-range dispersal of
  Aedes-borne dengue.
- **The Discussion explains why General Santos is always terminal** — it onsets after the
  inland hubs (so it reads as a recipient), being terminal is about timing not burden, and
  straight-line distance can't capture its long-range road/commuter links.
- **The three outbreak windows are justified** — chosen by visual inspection corroborated by
  DOH surveillance / the known epidemic years, with algorithmic change-point detection named
  as a future refinement.
- **There is a robustness suite (Table 8 + Figure 4).** I re-ran the full ensemble while
  varying λ over an order of magnitude, swapping the exponential kernel for a Gaussian one,
  and replacing the probabilistic network with a fixed **deterministic adjacency**. The
  result is reassuring: **General Santos stays terminal (R_c = 0) in every setting, and
  Koronadal (Periods 1–2) and Banga (Period 3) stay the dominant sources in all of them** —
  λ only changes the network density, and with it the R_t magnitude. The deterministic
  adjacency (essentially the Nasution-style fixed matrix) reproduces the same R_t = 5/2/3
  but forces every edge to look certain — exactly the over-confidence our ensemble avoids.
- **It's fully reproducible** — a notebook section regenerates the robustness table and
  figure.

## What I'd like us to agree on

- That we frame the paper as the **connectivity / ensemble follow-up** to Nasution 2024,
  citing it as the direct predecessor, with the attribution split (prevalence /
  region-scale + SoL = Nasution; network + ensemble + stability = here).
- **Sign-off on the harmonised SoL** (adopting their exact Eq. 5) and on the **resulting
  change in the headline finding** (Koronadal City, not Surallah, as the dominant
  source) — which Ygoña et al. (2025) independently corroborate. The old SoL is one
  toggle away (`SOL_MODE="current"`) if we'd rather keep the Surallah result.
- The **methodological framing** (uncertainty quantification as the aim, South Cotabato
  as the demonstrating case).
- **The scope/title decision** — are we comfortable putting the preliminary
  cross-province transferability assessment in the **title and abstract**, or would you
  rather I keep it as the §3.5 subsection and hold the title until the metadata is final?
- **The R_c relabel** — I renamed "city reproduction number" to **"LGU reproduction
  number"** (most of our units are municipalities, not cities; the symbol R_{c,i} and the
  attribution to your Eq. 5 framework are unchanged). Since the term comes from the Jakarta
  paper, tell me if you'd rather keep "city reproduction number" — it's a one-word revert.
- **Renamed both R_t and R_c** — to pre-empt a predictable reviewer objection (our
  quantities are not classical effective reproduction numbers), I renamed **R_t to the
  "LGU branching ratio (LBR)"** and **R_c to the "LGU out-degree index (LOI)"**, changing
  both names and symbols (R_t becomes LBR; R_c becomes LOI). These are shared with the
  Jakarta paper, so I'd like your read — both are clean find-and-replace reverts if the
  group prefers Nasution's original notation.
  This is shared terminology with the Jakarta paper, so I'd like your read — it's a
  clean find-and-replace to revert if you'd prefer we keep Nasution's $R_t$.
- A sanity-check that the **limitations list** reads fairly — whether any should be
  softened or added.
- Whether there's anything **in progress on your side** this should coordinate with
  (e.g. a planned extension of the Jakarta work).

## Anchor references for context

- **Nasution et al. 2024**, _Sci Rep_ 14:7619 — sister paper (DOI 10.1038/s41598-024-58390-3).
- **Li et al. 2019**, _Ann. AAG_ 109(3):812–836 — original epidemic forest,
  individual-level, space + time only (DOI 10.1080/24694452.2018.1511413).
- **Haydon et al. 2003** — original epidemic _trees_ at farm (unit) level; why LGU-scale
  reconstruction is a legitimate lineage, not a degraded Li.

Thanks for reading — happy to hop on a call if that's easier.

Jayrold
