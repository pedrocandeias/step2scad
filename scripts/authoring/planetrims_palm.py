"""Trim staircase overshoot with EXACT tilted plane faces (coverage audit).

Scope extension of the author-spotted class: large unclaimed planes hiding
under band lofts. Measurement classified the unclaimed planes: 93% of the
area is horizontal/vertical — exact by construction in the y-band
representation (straight profile/footprint edges), claimed by provenance.
The remaining TILTED-in-z planes (dorsal socket ramps family (0,0.41,0.91),
wrist-back ramps (0,-0.4,0.92), knuckle-front ramp, cavity-ceiling facets,
thumb facets) DO get staircased along y.

Safe surgery (FP-only direction): for each exact tilted face, subtract a
half-space wedge bounded tightly to the face's measured extent (+0.15
in-plane margin, 2.0 outward depth, 0.02 embed) — this shaves the band
corners that poke ABOVE the true surface and cannot remove correct
material elsewhere (the wedge lives outside the exact face). The
under-shoot half of the staircase error stays (bounded by band pitch);
removing it would require re-banding (future anatomical re-segmentation).

Face extents are measured from the reference tessellation (vertices within
0.08 of the plane), NOT from OCC u/v ranges (plane frames are arbitrary).
The OUTWARD direction is measured too — features.json normals are the
surface's NATURAL normals, not orientation-corrected (documented trap: the
first run trusted them and half the wedges pointed INWARD, gutting
11000 mm3): probe containment on both sides of the face centroid region
and take the emptier side.

Chained from author_palm_left_parametric.py after knuckleblock_palm.
"""
import json
import shutil
from pathlib import Path

import numpy as np
import trimesh

OUT = Path("output/Palm_left")
MIN_AREA = 14.0     # work the area-ranked tilted list down to here
NZ_LO, NZ_HI = 0.10, 0.98   # tilted-in-z band (vertical/horizontal excluded)
DEPTH = 2.0         # wedge depth outward along the normal
EMBED = 0.02        # embed below the plane to catch coincident overshoot
MARGIN = 0.15       # in-plane margin around the measured face extent


def main():
    plan = json.loads((OUT / "plan.json").read_text())
    feats = json.loads((OUT / "features.json").read_text())
    body = plan["bodies"][0]

    ref = trimesh.load(str(OUT / "Palm_left_ref.stl"), force="mesh")
    V = np.asarray(ref.vertices)

    wedges = []
    for f in feats["bodies"][0]["faces"]:
        if f["type"] != "plane" or float(f.get("area", 0.0)) < MIN_AREA:
            continue
        n = np.asarray(f["params"].get("normal",
                                       f["params"].get("axis_dir")), float)
        n = n / np.linalg.norm(n)
        if not (NZ_LO < abs(n[2]) < NZ_HI):
            continue
        o = np.asarray(f["params"].get("origin",
                                       f["params"].get("axis_origin")), float)
        # face triangles: normal aligned within ~2 deg AND centroid on the
        # plane — this is the face's own triangulation (vertex-only selection
        # picked sparse flat-face corners + distant coincidental points)
        tn = ref.face_normals
        tc = V[ref.faces].mean(axis=1)
        align = np.abs(tn @ n) > 0.999
        ond = np.abs((tc - o) @ n) < 0.08
        tri_idx = np.where(align & ond)[0]
        if len(tri_idx) < 2:
            continue
        # cluster triangle centroids around the one nearest the face origin
        C = tc[tri_idx]
        seed = int(np.argmin(np.linalg.norm(C - o, axis=1)))
        keep = np.zeros(len(C), bool)
        keep[seed] = True
        grew = True
        while grew:
            grew = False
            rest = np.where(~keep)[0]
            if not len(rest):
                break
            kept_pts = C[keep]
            for ri in rest:
                if np.linalg.norm(kept_pts - C[ri], axis=1).min() < 4.0:
                    keep[ri] = True
                    grew = True
        on = V[ref.faces[tri_idx[keep]]].reshape(-1, 3)
        # measure the outward side: probe containment at +-0.35 along n from
        # a spread of on-face points; outward = the side with less material
        probes = on[:: max(1, len(on) // 24)][:24]
        inside_pos = ref.contains(probes + 0.35 * n).sum()
        inside_neg = ref.contains(probes - 0.35 * n).sum()
        if inside_pos > inside_neg:
            n = -n          # natural normal pointed into the material
        # box local frame matching the emitter's rotate([0, polar, azimuth]):
        # local +z -> n, local +x -> e1, local +y -> e2
        b = np.degrees(np.arctan2(np.hypot(n[0], n[1]), n[2]))   # polar
        c = np.degrees(np.arctan2(n[1], n[0]))                   # azimuth
        rb, rc = np.radians(b), np.radians(c)
        e1 = np.array([np.cos(rb) * np.cos(rc), np.cos(rb) * np.sin(rc),
                       -np.sin(rb)])
        e2 = np.array([-np.sin(rc), np.cos(rc), 0.0])
        q = on - o
        u1, u2 = q @ e1, q @ e2
        c1, c2 = (u1.min() + u1.max()) / 2, (u2.min() + u2.max()) / 2
        s1 = u1.max() - u1.min() + 2 * MARGIN
        s2 = u2.max() - u2.min() + 2 * MARGIN
        if s1 * s2 > 8 * float(f["area"]):     # extent inconsistent with face
            print(f"  aviso: face #{f['index']} extensão {s1:.0f}x{s2:.0f} "
                  f">> área {f['area']:.0f} — cunha descartada")
            continue
        center = o + c1 * e1 + c2 * e2 + (DEPTH / 2 - EMBED) * n
        # ENFORCE FP-only by measurement: sample the wedge volume against the
        # reference — a wedge that would cut true material is rejected
        # (rectangular bboxes of L-shaped faces can cover neighboring tabs)
        rng = np.random.default_rng(f["index"])
        S = rng.random((240, 3)) - 0.5
        pts = (center + np.outer(S[:, 0] * s1, e1)
               + np.outer(S[:, 1] * s2, e2)
               + np.outer((S[:, 2] + 0.5) * DEPTH - EMBED, n))
        frac = float(ref.contains(pts).mean())
        cut_vol = frac * s1 * s2 * DEPTH
        if cut_vol > 1.5:
            print(f"  aviso: cunha #{f['index']} cortaria {cut_vol:.1f} mm3 "
                  "de material verdadeiro — rejeitada (FP-only)")
            continue
        wedges.append({
            "prim": "box", "name": f"trim_f{f['index']}",
            "source": f"EXACT plane face #{f['index']} (normal "
                      f"{[round(v, 3) for v in n.tolist()]}, area "
                      f"{f['area']:.0f}): half-space wedge bounded to the "
                      "measured face extent — shaves band-staircase "
                      "overshoot above the true surface (FP-only)",
            "center": [round(v, 6) for v in center.tolist()],
            "size": [round(s1, 6), round(s2, 6), DEPTH],
            "rotate_deg": [0, round(b, 6), round(c, 6)]})

    # idempotent: strip any previous run's module + call before re-adding
    body["modules"].pop("tilt_face_trims", None)
    body["csg"]["children"] = [
        c for c in body["csg"]["children"]
        if c.get("call") != "tilt_face_trims"]
    body["notes"] = " | ".join(
        s for s in body.get("notes", "").split(" | ")
        if not s.startswith("tilt-face trims:"))
    body["modules"]["tilt_face_trims"] = {
        "args": [],
        "doc": "exact tilted plane faces as bounded half-space trims: shave "
               "the y-band staircase overshoot on ramp faces (dorsal socket "
               "ramps, wrist-back ramps, cavity facets) — faces cited per "
               "wedge; measured extent bounds prevent cutting neighbors",
        "tree": {"op": "union", "children": wedges}}
    body["csg"]["children"].append(
        {"call": "tilt_face_trims", "name": "trims_i", "args": {}})
    note = (f"tilt-face trims: {len(wedges)} exact tilted planes shave the "
            "band staircase (FP-only, extent-bounded)")
    body["notes"] = body.get("notes", "") + " | " + note

    shutil.copy(OUT / "plan.json", OUT / "plan_pre_planetrims.json")
    (OUT / "plan.json").write_text(json.dumps(plan, indent=1))
    print(f"planetrims: {len(wedges)} aparos por face exata")


if __name__ == "__main__":
    main()
