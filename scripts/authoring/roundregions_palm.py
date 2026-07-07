"""Round-region surgery on the Palm plan: exact-cylinder features.

The user spotted that the palm's round features are band staircases. The
B-rep has the EXACT faces: knuckle-post walls are x-axis r6.000 cylinders
(the mating geometry of the proximal r6.000 lobes), the two rear ears are
x-axis r8.000 discs. This stage:

  1. reads the exact wall/ear geometry (center, radius, axial span) from
     features.json cylinder faces + v_range — no fitted values;
  2. DROPS every shell band whose top edge lies ON the corresponding arc
     law (|z_max - law| <= TOL_LAW at the band mid-y) and whose footprint
     stays within the wall's axial span — those bands were the staircase
     rendering of the cylinder surface (their corners poke above the true
     surface by up to ~1 mm at the steep ends);
  3. ADDS the exact solids: ear discs as cylinder prims, post walls as
     smooth arc-law sweeps (emitted as cylinder clips — no stairs).
     Pin channels / counterbores / the wrist bore are ALREADY subtracted by
     the knuckle_pins and wrist_cuts modules, so the solids carry no holes.

Chained from author_palm_left_parametric.py; reads and rewrites
output/Palm_left/plan.json (backup: plan_pre_roundregions.json).
"""
import json
import shutil
from pathlib import Path

import numpy as np

OUT = Path("output/Palm_left")
TOL_LAW = 0.3     # band top must sit on the arc law within this (mm)
TOL_X = 0.5       # band footprint must fit the wall axial span within this


def path_pts(prof):
    pts = []
    for s in prof["path"]:
        if "to" in s:
            pts.append(s["to"])
        else:
            a = s["arc"]
            for k in range(0, a["n"] + 1):
                ang = np.radians(a["a0"] + k * (a["a1"] - a["a0"]) / a["n"])
                pts.append([a["c"][0] + a["r"] * np.cos(ang),
                            a["c"][1] + a["r"] * np.sin(ang)])
    return np.array(pts)


def face_span_x(faces, fi):
    f = faces[fi]
    p = f["params"]
    v0, v1 = f["v_range"]
    a = p["axis_origin"][0] + p["axis_dir"][0] * v0
    b = p["axis_origin"][0] + p["axis_dir"][0] * v1
    return min(a, b), max(a, b), p["axis_origin"][1], p["axis_origin"][2], p["radius"]


def main():
    plan = json.loads((OUT / "plan.json").read_text())
    feats = json.loads((OUT / "features.json").read_text())
    faces = {f["index"]: f for f in feats["bodies"][0]["faces"]}
    body = plan["bodies"][0]
    shell = body["modules"]["palm_shell"]["tree"]

    # ---- exact regions from the B-rep faces --------------------------------
    # ears: full discs (top AND bottom on the r8 circle — verified med err
    # 0.03 at the tips); walls: r6 arc TOPS (crest z = zc + r)
    ear_ids = (534, 535)
    ears = [face_span_x(faces, fi) for fi in ear_ids]
    wall_faces = [277, 337, 350, 462, 465, 623, (292, 441)]
    walls = []
    for fi in wall_faces:
        if isinstance(fi, tuple):                      # split face, one wall
            spans = [face_span_x(faces, f) for f in fi]
            x0 = min(s[0] for s in spans); x1 = max(s[1] for s in spans)
            walls.append((x0, x1, spans[0][2], spans[0][3], spans[0][4]))
        else:
            walls.append(face_span_x(faces, fi))

    regions = [("ear", *e) for e in ears] + [("wall", *w) for w in walls]

    # ---- drop staircase bands ---------------------------------------------
    kept, dropped = [], {}
    drop_zmin = {}
    drop_bands = {}
    for band in shell["children"]:
        if band.get("prim") != "extrude":
            kept.append(band)
            continue
        ym = (band["z0"] + band["z1"]) / 2
        pts = path_pts(band["profile2d"])              # (z, x)
        zmax, zmin = pts[:, 0].max(), pts[:, 0].min()
        xmin, xmax = pts[:, 1].min(), pts[:, 1].max()
        hit = None
        for kind, x0, x1, yc, zc, r in regions:
            dy = ym - yc
            if abs(dy) >= r:
                continue
            if not (xmin >= x0 - TOL_X and xmax <= x1 + TOL_X):
                continue
            law_hi = zc + np.sqrt(r * r - dy * dy)
            if abs(zmax - law_hi) <= TOL_LAW:
                hit = (kind, x0, x1, yc, zc, r)
                break
        if hit:
            key = hit[1:]
            dropped[key] = dropped.get(key, 0) + 1
            drop_zmin[key] = min(drop_zmin.get(key, 1e9), float(zmin))
            drop_bands.setdefault(key, []).append(
                (float(band["z0"]), float(band["z1"]), float(zmin)))
        else:
            kept.append(band)

    # ---- add the exact solids ----------------------------------------------
    # Each exact solid is CLIPPED to the envelope of the bands it replaced
    # (merged y-runs, local measured floor): the arc law only exists where
    # the staircase did — beyond that the wall/ear emerges from the deck and
    # the kept bands own the geometry. Without this clip the law overshoots
    # at the y-ends and below the rising underside (measured: 1054 mm3 FP,
    # pokes up to 4 mm).
    def envelope_boxes(key, x0, x1, tag):
        runs = []
        for y0, y1, zmin in sorted(drop_bands.get(key, [])):
            if runs and abs(runs[-1][2] - zmin) < 0.35 and y0 - runs[-1][1] < 0.2:
                runs[-1][1] = y1
            else:
                runs.append([y0, y1, zmin])
        return [{"prim": "box", "name": f"{tag}_clip{j}",
                 "source": "replaced-band envelope (merged run, measured "
                           "local floor)",
                 "min": [round(x0 - 0.05, 6), round(r0, 6), round(zm, 6)],
                 "size": [round(x1 - x0 + 0.1, 6), round(r1 - r0, 6), 40]}
                for j, (r0, r1, zm) in enumerate(runs)]

    added = []
    for (fi, (x0, x1, yc, zc, r)) in zip(ear_ids, ears):
        side = "R" if x0 > 0 else "L"
        boxes = envelope_boxes((x0, x1, yc, zc, r), x0, x1, f"ear{side}")
        disc = {
            "prim": "cylinder", "name": f"wrist_ear_{side}",
            "source": f"EXACT x-axis cylinder face #{fi} (r={r}, full disc: "
                      f"band tips matched top+bottom arcs within 0.03) — "
                      "wrist pin ear; the r3 bore is cut by wrist_cuts",
            "p0": [round(x0, 6), round(yc, 6), round(zc, 6)],
            "p1": [round(x1, 6), round(yc, 6), round(zc, 6)], "r": r}
        added.append({"op": "intersection", "children": [
            disc, {"op": "union", "children": boxes}]} if boxes else disc)
    for i, (fi, (x0, x1, yc, zc, r)) in enumerate(zip(wall_faces, walls)):
        fid = "#" + "/#".join(str(q) for q in (fi if isinstance(fi, tuple) else (fi,)))
        key = (x0, x1, yc, zc, r)
        z0 = drop_zmin.get(key, zc - r + 0.5)
        key = (x0, x1, yc, zc, r)
        boxes = envelope_boxes(key, x0, x1, f"wall{i}")
        if not boxes:
            continue                      # no bands matched -> nothing to fix
        sweep = {
            "prim": "sweep", "axis": "y", "name": f"knuckle_wall_{i}",
            "source": f"EXACT x-axis r{r} cylinder face {fid} crowns this "
                      f"clevis wall (the mating geometry of the proximal "
                      f"r6.000 lobes); wall base z from the replaced bands; "
                      "pin channel/counterbore cut by knuckle_pins",
            "u0": round(x0, 6), "u1": round(x1, 6),
            "s0": round(yc - r, 6), "s1": round(yc + r, 6),
            "z0": round(z0, 6), "h_max": round(zc + r, 6), "steps": 1,
            "law": {"kind": "arc", "sc": round(yc, 6), "zc": round(zc, 6),
                    "R": r}}
        added.append({"op": "intersection", "children": [
            sweep, {"op": "union", "children": boxes}]})
    shell["children"] = kept + added

    n_drop = sum(dropped.values())
    note = (f"round-region surgery: {n_drop} staircase bands replaced by "
            f"{len(added)} exact solids (2 wrist-ear r8 discs, "
            f"{len(walls)} knuckle-wall r6 arc sweeps) — exact faces cited "
            "per prim")
    body["notes"] = body.get("notes", "") + " | " + note

    shutil.copy(OUT / "plan.json", OUT / "plan_pre_roundregions.json")
    (OUT / "plan.json").write_text(json.dumps(plan, indent=1))
    print(f"roundregions: {n_drop} bandas -> {len(added)} sólidos exatos "
          f"({len(kept)} bandas mantidas)")
    for key, n in sorted(dropped.items()):
        print(f"   região x[{key[0]:.2f},{key[1]:.2f}] y={key[2]:.2f} "
              f"r={key[4]}: {n} bandas, z0={drop_zmin[key]:.2f}")


if __name__ == "__main__":
    main()
