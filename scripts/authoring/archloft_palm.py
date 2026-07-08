"""ARCH-LOFT re-architecture of the Palm_left dorsal shell (V2-template style).

STATUS: EXPERIMENT — NOT chained into author_palm_left_parametric.py.
  Measured result: one continuous canonical-arch skin (31 stations, 72-pt
  outer / 56-pt cavity arches) eliminates the fragment-boundary CREASES of
  the control-loft, but scores boolean IoU 0.9413 — BELOW the project's 0.95
  spec. The error is a spatially UNIFORM ~0.25mm-RMS sheet over the whole
  dorsal surface (FP 1080 + FN 1542 mm3, net -317): a single smooth arch per
  station cannot carry the surface's real ±0.25mm detail (mounds/dimples).
  This is exactly why the hand template accepts "~1.25mm silhouette" error.
  The shipped palm keeps the control-loft (0.9641, passes spec) with creases.
  Fidelity vs smoothness is a genuine tradeoff here; lifting the arch >=0.95
  would need per-station detail add-backs. Kept as an auditable finding.

The hand-built template (Palm_left_V2_shell.scad) lofts ONE continuous skin
through ~30 y-stations whose arch polygons share a CANONICAL FIXED FORMAT
(feet anchored on the plate, fixed vertex budget by normalized arc position).
That regularized correspondence is what kills the fragment creases: a single
ruled loft, never self-intersecting.

This stage does the same, measured:
  1. slice the reference tessellation at ~30 y-stations across the dome span
     (span DETECTED: closed-silhouette area > 1200 mm^2, contiguous run);
  2. close the open-bottom stations (vent slots) with an exact plate strip
     before taking the silhouette (a C-loop's exterior is NOT the silhouette);
  3. resample outer silhouette and cavity hole to canonical arches
     (N_OUT/N_CAV points, feet exact at the bottom edge, arc-length budget
     in between — monotone correspondence by construction);
  4. decimate stations with fitting.decimate_sections_ruled (selector only;
     the kept stations keep their canonical outlines);
  5. REPLACE palm_shell / palm_cavity children inside the window with one
     outer skin + one cavity skin per decimated segment; clip stradlers.

Wall thickness is MEASURED (outer-vs-cavity ring distance) and reported —
the hand template guessed 4.6/5.0.

Reads plan_pre_archloft.json (backed up from plan.json on first run).
Run: python3 scripts/authoring/archloft_palm.py [tol]
"""
import json
import shutil
import sys
from pathlib import Path

import numpy as np
import trimesh
from shapely.geometry import MultiPolygon, Polygon, box
from shapely.ops import unary_union

sys.path.insert(0, "src")
from step2scad.fitting import dist_to_poly  # noqa: E402
from step2scad.plan import validate_plan  # noqa: E402


def decimate_canonical(secs, tol):
    """Greedy station decimation for CANONICAL sections (same N, same
    roles): index-wise lerp IS the loft; no correspondence breaks ever —
    one continuous chain. -> (kept_indices, worst_dropped_err)"""
    S = [s for s, _ in secs]
    P = [np.asarray(p, float) for _, p in secs]
    kept = list(range(len(secs)))
    worst = 0.0
    while len(kept) > 2:
        errs = []
        for m in range(1, len(kept) - 1):
            i, k, j = kept[m - 1], kept[m], kept[m + 1]
            t_ = (S[k] - S[i]) / max(S[j] - S[i], 1e-12)
            ring = P[i] * (1 - t_) + P[j] * t_
            e = max(dist_to_poly(ring, P[k]).max(),
                    dist_to_poly(P[k], ring).max())
            errs.append((float(e), m))
        e, m = min(errs)
        if e >= tol:
            break
        worst = max(worst, e)
        kept.pop(m)
    return kept, worst

OUT = Path("output/Palm_left")
TOL = float(sys.argv[1]) if len(sys.argv) > 1 else 0.30
STATION_STEP = 1.75      # y sampling step (template used ~1.83)
N_OUT = 72               # canonical outer-arch point count
N_CAV = 56               # canonical cavity-arch point count
AREA_MIN = 1200.0        # closed-silhouette area that marks the dome span
OV = 0.30                # overlap into the kept neighbours at window edges

backup = OUT / "plan_pre_archloft.json"
if not backup.exists():
    shutil.copy(OUT / "plan.json", backup)
plan = json.load(open(backup))
body = plan["bodies"][0]
mesh = trimesh.load(OUT / "Palm_left_ref.stl", force="mesh")

Z_BOT = float(mesh.bounds[0][2])          # plate underside (measured 4.6)

# --------------------------------------------------------------- sections
def material_polys(y):
    """Filled MATERIAL region polygons at station y (even-odd containment:
    a ring inside an odd number of bigger rings is a HOLE — filling every
    ring and unioning would erase the cavity)."""
    s = mesh.section(plane_origin=[0, y, 0], plane_normal=[0, 1, 0])
    if s is None:
        return []
    rings = []
    for L in s.discrete:
        a = np.array(L)[:, [2, 0]]        # (z, x) — axis-y profile frame
        if len(a) >= 4:
            p = Polygon(a)
            if p.is_valid and p.area > 0.4:
                rings.append(p)
    rings.sort(key=lambda p: -p.area)
    depth = []
    for i, p in enumerate(rings):
        pt = p.representative_point()
        depth.append(sum(1 for j, q in enumerate(rings)
                         if j != i and q.area > p.area and q.contains(pt)))
    solid = unary_union([p for p, d in zip(rings, depth) if d % 2 == 0])
    holes = [p for p, d in zip(rings, depth) if d % 2 == 1]
    if holes:
        solid = solid.difference(unary_union(holes))
    if solid.is_empty:
        return []
    return list(solid.geoms) if hasattr(solid, "geoms") else [solid]


def closed_silhouette(y):
    """(outer exterior ring polygon, cavity polygon or None) at station y.
    Open-bottom stations (vent slots) are closed with an exact plate strip
    spanning the material's own x-extent at plate level."""
    polys = material_polys(y)
    if not polys:
        return None, None
    u = unary_union(polys)
    geoms = list(u.geoms) if isinstance(u, MultiPolygon) else [u]
    big = max(geoms, key=lambda g: g.area)
    # exact closing strip at plate level (z: bottom .. bottom+2.2)
    zx = np.array(big.exterior.coords)
    at_plate = zx[zx[:, 0] < Z_BOT + 0.6]
    if len(at_plate) >= 2:
        x0, x1 = at_plate[:, 1].min(), at_plate[:, 1].max()
        closed = unary_union([big, box(Z_BOT, x0, Z_BOT + 2.2, x1)])
        if isinstance(closed, MultiPolygon):
            closed = max(closed.geoms, key=lambda g: g.area)
    else:
        closed = big
    outer = Polygon(closed.exterior)
    # cavity = filled outer minus material, largest chunk above the floor
    cav_region = outer.difference(unary_union(polys + [box(Z_BOT, -60, Z_BOT + 2.2, 60)]))
    cav = None
    if not cav_region.is_empty:
        parts = (list(cav_region.geoms)
                 if hasattr(cav_region, "geoms") else [cav_region])
        parts = [p for p in parts if p.area > 60.0]
        if parts:
            cav = max(parts, key=lambda p: p.area)
    return outer, cav


def canonical_arch(poly, n, floor_lift=0.0):
    """Resample a silhouette ring to the canonical arch: cut at the bottom
    edge, feet exact, n-2 points by arc length over the top. Returns (n,2)
    array in (z, x), CCW in the (z, x) plane."""
    ring = np.array(poly.exterior.coords[:-1], float)
    zfloor = ring[:, 0].min() + floor_lift
    bottom = ring[:, 0] < zfloor + 0.25
    if not bottom.any():
        bottom = ring[:, 0] < ring[:, 0].min() + 0.25
    # rotate the ring so it STARTS just after the bottom run (foot L) and
    # ENDS at the other foot: walk from a bottom vertex to the first
    # non-bottom, that's the start of the over-the-top path
    nring = len(ring)
    start = None
    for i in range(nring):
        if bottom[i] and not bottom[(i + 1) % nring]:
            start = (i + 1) % nring
            break
    if start is None:
        start = int(np.argmin(ring[:, 0]))
    order = [(start + k) % nring for k in range(nring)]
    path = [ring[order[0]]]
    for k in order[1:]:
        path.append(ring[k])
        if bottom[k]:
            break
    path = np.array(path)
    # arc-length resample to n points, endpoints exact
    seg = np.linalg.norm(np.diff(path, axis=0), axis=1)
    cum = np.concatenate([[0], np.cumsum(seg)])
    t = np.linspace(0, cum[-1], n)
    out = np.empty((n, 2))
    for j, tv in enumerate(t):
        i = min(np.searchsorted(cum, tv, side="right") - 1, len(seg) - 1)
        f = (tv - cum[i]) / max(seg[i], 1e-12)
        out[j] = path[i] * (1 - f) + path[i + 1] * f
    # CORNER SNAP: uniform resampling cuts corners (measured trap) — pull
    # the nearest sample onto every sharp true vertex, preserving order
    v1 = np.diff(path[:-1], axis=0) if len(path) > 2 else None
    if v1 is not None:
        last = 1
        for i in range(1, len(path) - 1):
            a = path[i] - path[i - 1]
            b = path[i + 1] - path[i]
            na, nb = np.linalg.norm(a), np.linalg.norm(b)
            if na < 1e-9 or nb < 1e-9:
                continue
            cosang = np.clip(np.dot(a, b) / (na * nb), -1, 1)
            if np.degrees(np.arccos(cosang)) > 25.0:
                j = last + int(np.argmin(
                    np.linalg.norm(out[last:n - 1] - path[i], axis=1)))
                out[j] = path[i]
                last = min(j + 1, n - 2)
    # feet EXACTLY on the flat bottom plane (an undulating closing chord
    # makes the ruled floor oscillate around the true plate: measured as
    # FN sheets at z~5 — the plate is one exact plane)
    zb = ring[:, 0].min()
    out[0, 0] = zb
    out[-1, 0] = zb
    # CCW in (z, x)
    a2 = np.sum(out[:, 0] * np.roll(out[:, 1], -1)
                - np.roll(out[:, 0], -1) * out[:, 1])
    if a2 < 0:
        out = out[::-1]
    return out


# ------------------------------------------------- detect the dome window
ys = np.arange(-34.0, 26.0, 0.5)
ok = []
for y in ys:
    outer, _ = closed_silhouette(float(y))
    ok.append(outer is not None and outer.area > AREA_MIN)
ok = np.array(ok)
runs = []
i = 0
while i < len(ok):
    if ok[i]:
        j = i
        while j < len(ok) and ok[j]:
            j += 1
        runs.append((float(ys[i]), float(ys[j - 1])))
        i = j
    else:
        i += 1
w0, w1 = max(runs, key=lambda r: r[1] - r[0])
print(f"janela do arco (medida): y [{w0}, {w1}]")

# ---------------------------------------------------- canonical stations
stations = list(np.arange(w0, w1 + 1e-6, STATION_STEP))
if stations[-1] < w1 - 0.4:
    stations.append(w1)
out_secs, cav_secs = [], []
wall_samples = []
for y in stations:
    outer, cav = closed_silhouette(float(y))
    if outer is None:
        continue
    oarch = canonical_arch(outer, N_OUT)
    oarch[0, 0] = Z_BOT
    oarch[-1, 0] = Z_BOT
    out_secs.append((float(y), oarch.tolist()))
    if cav is not None:
        carch = canonical_arch(cav, N_CAV)
        cav_secs.append((float(y), carch.tolist()))
        # wall thickness sample: cavity crest to outer crest (top of arch)
        oc = oarch[np.argmax(oarch[:, 0])]
        cc = carch[np.argmax(carch[:, 0])]
        wall_samples.append(oc[0] - cc[0])
wall = float(np.median(wall_samples))
wall_res = float(np.percentile(np.abs(np.array(wall_samples) - wall), 90))
print(f"estações: {len(out_secs)} outer / {len(cav_secs)} cavity; "
      f"parede medida (crista): {wall:.2f} mm (p90 desvio {wall_res:.2f}; "
      "template à mão: 4.6 medido / 5.0 escolhido)")

# ------------------------------------------------------------- decimation
okept, oerr = decimate_canonical(out_secs, TOL)
ckept, cerr = decimate_canonical(cav_secs, TOL)
osegs, csegs = [okept], [ckept]
n_out_kept, n_cav_kept = len(okept), len(ckept)
print(f"decimação (tol {TOL}): outer {len(out_secs)}->{n_out_kept} "
      f"(err {oerr:.3f}), cavity {len(cav_secs)}->{n_cav_kept} "
      f"(err {cerr:.3f})")


def skin_node(name, secs, idxs, what):
    return {"prim": "skin", "axis": "y", "name": name,
            "source": f"canonical arch loft ({what}): measured reference "
                      f"sections resampled to a fixed-role arch (feet on the "
                      f"plate, arc-length budget) and decimated by ruled "
                      f"interpolation error <= {TOL} — single continuous "
                      "loft, V2-template architecture",
            "sections": [{"at": round(secs[i][0], 6),
                          "outline": [[round(v, 5) for v in q]
                                      for q in secs[i][1]]}
                         for i in idxs]}


# --------------------------------------- window-clip the existing modules
def clip_children(children, w0, w1, keep_prims=("extrude", "skin")):
    kept = []
    n_drop = 0
    for c in children:
        prim = c.get("prim")
        if prim == "extrude":
            z0, z1 = float(c["z0"]), float(c["z1"])
            if z0 >= w0 - OV and z1 <= w1 + OV:
                n_drop += 1
                continue
            if z0 < w0 <= z1:
                c = dict(c)
                c["z1"] = round(w0 + OV, 6)
            elif z0 <= w1 < z1:
                c = dict(c)
                c["z0"] = round(w1 - OV, 6)
            kept.append(c)
        elif prim == "skin":
            ats = [s["at"] for s in c["sections"]]
            if min(ats) >= w0 - OV and max(ats) <= w1 + OV:
                n_drop += 1
                continue
            lo = [s for s in c["sections"] if s["at"] <= w0 + OV]
            hi = [s for s in c["sections"] if s["at"] >= w1 - OV]
            if min(ats) < w0 and max(ats) > w0 and len(lo) >= 2:
                cc = dict(c)
                cc["sections"] = lo
                cc["name"] = c["name"] + "_lo"
                kept.append(cc)
                if len(hi) >= 2 and max(ats) > w1:
                    cc2 = dict(c)
                    cc2["sections"] = hi
                    cc2["name"] = c["name"] + "_hi"
                    kept.append(cc2)
            elif min(ats) < w1 < max(ats) and len(hi) >= 2:
                cc = dict(c)
                cc["sections"] = hi
                kept.append(cc)
            else:
                kept.append(c)
        else:
            kept.append(c)
    return kept, n_drop


mods = body["modules"]
shell_kids, nd1 = clip_children(mods["palm_shell"]["tree"]["children"], w0, w1)
cav_kids, nd2 = clip_children(mods["palm_cavity"]["tree"]["children"], w0, w1)
for si, idxs in enumerate(o for o in osegs if len(o) >= 2):
    shell_kids.append(skin_node(f"arch_dome_s{si}", out_secs, idxs, "outer"))
for si, idxs in enumerate(c for c in csegs if len(c) >= 2):
    cav_kids.append(skin_node(f"arch_cavity_s{si}", cav_secs, idxs, "cavity"))
mods["palm_shell"]["tree"]["children"] = shell_kids
mods["palm_cavity"]["tree"]["children"] = cav_kids
mods["palm_shell"]["doc"] = (
    "dorsal shell: ONE canonical arch loft across the dome (V2-template "
    "architecture — fixed-role sections, single continuous skin) + kept "
    "front/back features; wall measured "
    f"{wall:.2f} mm at the crest")
print(f"substituição: {nd1} filhos shell e {nd2} cavity dentro da janela "
      f"-> {sum(1 for o in osegs if len(o) >= 2)} + "
      f"{sum(1 for c in csegs if len(c) >= 2)} lofts canónicos")

body.setdefault("notes", "")
body["notes"] += (
    f" | archloft: dome y[{w0},{w1}] as canonical arch lofts "
    f"({n_out_kept}+{n_cav_kept} control stations, ruled tol {TOL}, "
    f"errs {oerr:.3f}/{cerr:.3f}); wall measured {wall:.2f}mm "
    f"(p90 {wall_res:.2f})")

validate_plan(plan)
json.dump(plan, open(OUT / "plan.json", "w"), indent=1)
print("wrote plan.json (archloft)")
