"""Author output/Distals/plan.json (bodies 0,1,2 full CSG; 3,4 instances).

STRATEGY (agent decision, per unique body):
  shell  = segmented hull-loft: convex hulls of probe-measured cross sections
           at y stations (dense near hinge lobe + fingertip dome), extended
           past the back and trimmed by the EXACT back plane
  cuts   = clevis gap (exact inner-wall planes + exact tilted front wall),
           r7.5 knuckle relief, r2.25 pin bore (exact band), r2.75 pockets
           (left exact / right through skin), bottom tendon slot (exact walls,
           ceiling, r2 ceiling coves), top scoop cylinder, exact back plane
  adds   = tendon post (exact walls, r1.1 rounded corners), slot front-corner
           nooks (r2 vertical fillets), cord bar (hull of 3 exact cylinders)
All values are exact B-rep parameters from features.json except the station
outlines, which are measured from the cached high-res tessellation.
"""
import json
import numpy as np

import sys
sys.path.insert(0, "src")
from step2scad.probe import load_mesh

STEP = "models/phoenix_components/Distals.step"
feats = json.load(open("output/Distals/features.json"))
mesh = load_mesh(STEP)

R = lambda x: round(float(x), 6)


def convex_hull(pts):
    """Andrew monotone chain; pts (n,2) -> hull vertices CCW."""
    pts = sorted(set(map(tuple, np.round(pts, 5))))
    if len(pts) < 3:
        return pts
    def half(seq):
        out = []
        for p in seq:
            while len(out) >= 2 and np.cross(np.subtract(out[-1], out[-2]),
                                             np.subtract(p, out[-2])) <= 0:
                out.pop()
            out.append(p)
        return out[:-1]
    return half(pts) + half(pts[::-1])


def decimate(loop, tol=0.05):
    """Drop vertices closer than tol to the chord of their neighbours."""
    loop = [np.asarray(p, float) for p in loop]
    out = list(loop)
    changed = True
    while changed and len(out) > 8:
        changed = False
        for i in range(len(out)):
            a, b, c = out[i - 1], out[i], out[(i + 1) % len(out)]
            ab = c - a
            n = np.linalg.norm(ab)
            if n < 1e-9:
                continue
            d = abs(np.cross(ab, b - a)) / n
            if d < tol:
                out.pop(i)
                changed = True
                break
    return [[R(p[0]), R(p[1])] for p in out]


def station_profile(body, y):
    """Convex hull (x, z) of this body's cross-section at y (measured).

    Merges three nearby slices (y ± 0.06): trimesh occasionally returns a
    partial section on near-tangent geometry (one collapsed station poked a
    triangular hole through the first Distals loft), and the merge makes the
    hull robust to any single bad slice.
    """
    lo, hi = body["bbox"]["min"][0] - 0.3, body["bbox"]["max"][0] + 0.3
    pts = []
    for yy in (y - 0.06, y, y + 0.06):
        sec = mesh.section(plane_origin=[0, yy, 0], plane_normal=[0, 1, 0])
        if sec is None:
            continue
        pts.extend(d[:, [0, 2]] for d in sec.discrete
                   if lo <= d[:, 0].mean() <= hi)
    if not pts:
        return None
    return decimate(convex_hull(np.vstack(pts)))


def planes_of(body):
    out = []
    for f in body["faces"]:
        if f["type"] != "plane":
            continue
        n = np.asarray(f["params"]["normal"], float)
        n /= np.linalg.norm(n)
        out.append({"i": f["index"], "n": n, "area": f["area"],
                    "d": float(n @ np.asarray(f["params"]["origin"]))})
    return out


def x_cyls(body, along):
    """Cylinder faces with axis along the given world axis index."""
    out = []
    for f in body["faces"]:
        if f["type"] != "cylinder":
            continue
        p = f["params"]
        d = np.asarray(p["axis_dir"], float)
        if abs(abs(d[along]) - 1.0) > 1e-3:
            continue
        base = p["axis_origin"][along]
        sgn = np.sign(d[along]) or 1.0
        ext = sorted(base + sgn * v for v in f["v_range"])
        du = abs(f["u_range"][1] - f["u_range"][0])
        out.append({"i": f["index"], "r": p["radius"], "o": p["axis_origin"],
                    "ext": ext, "arc": np.degrees(du),
                    "bore": f["orientation"] == "reversed"})
    return out


def build_body(body):
    bid = body["id"]
    bb = body["bbox"]
    P = planes_of(body)
    CX = x_cyls(body, 0)   # axis along x
    CY = x_cyls(body, 1)   # axis along y
    CZ = x_cyls(body, 2)   # axis along z

    def one(cands, what):
        assert len(cands) == 1, f"body {bid}: {what}: {len(cands)} candidates"
        return cands[0]

    # ---- exact reference planes -------------------------------------------
    zbot_p = one([p for p in P if p["n"][2] < -0.9999 and p["area"] > 50], "bottom")
    z_bot = -zbot_p["d"]
    gap_lo_p = one([p for p in P if p["n"][0] > 0.9999 and p["area"] > 100], "gap lo")
    gap_hi_p = one([p for p in P if p["n"][0] < -0.9999 and p["area"] > 100], "gap hi")
    x_gap = (gap_lo_p["d"], -gap_hi_p["d"])
    # tilted -y-facing planes: back = farthest back, gapwall = farthest forward
    tilted = [p for p in P if p["n"][1] < -0.9 and 0.02 < p["n"][2] < 0.2]
    y_at = lambda p, z: (p["d"] - p["n"][2] * z) / p["n"][1]
    back_p = min(tilted, key=lambda p: y_at(p, 5))
    gapw_p = max(tilted, key=lambda p: y_at(p, 5))
    slotf_p = one([p for p in P if p["n"][1] < -0.999 and abs(p["n"][2]) < 0.02
                   and p["area"] > 3 and abs(p["d"]) < 5], "slot front")
    y_slot_end = -slotf_p["d"]

    # ---- hinge system ------------------------------------------------------
    relief = one([c for c in CX if c["bore"] and 6 < c["r"] < 9], "relief")
    hy, hz = relief["o"][1], relief["o"][2]
    pin_faces = [c for c in CX if c["bore"] and 2.0 < c["r"] < 2.5
                 and abs(c["o"][1] - hy) < 0.01 and abs(c["o"][2] - hz) < 0.01]
    assert pin_faces, f"body {bid}: no pin bore faces"
    r_pin = pin_faces[0]["r"]
    pin_lo = min(c["ext"][0] for c in pin_faces)
    pin_hi = max(c["ext"][1] for c in pin_faces)
    pocket = one([c for c in CX if c["bore"] and 2.5 < c["r"] < 3.0
                  and c["arc"] > 350], "pocket")

    # ---- slot + coves + post + nooks ---------------------------------------
    coves = [c for c in CY if c["bore"] and abs(c["r"] - 2.0) < 0.2]
    assert len(coves) == 2, f"body {bid}: coves: {len(coves)}"
    z_ceil = coves[0]["o"][2] + coves[0]["r"]
    y_slot0 = min(c["ext"][0] for c in coves)
    vfil = [c for c in CZ if c["bore"] and abs(c["r"] - 2.0) < 0.2]
    assert len(vfil) == 2, f"body {bid}: vertical fillets: {len(vfil)}"
    posts = [c for c in CZ if not c["bore"] and 0.9 < c["r"] < 1.25
             and c["ext"][1] - c["ext"][0] > 1.0]
    assert len(posts) == 4, f"body {bid}: post corners: {len(posts)}"
    r_post = posts[0]["r"]
    pxs = sorted({R(c["o"][0]) for c in posts})
    pys = sorted({R(c["o"][1]) for c in posts})
    post_x = (min(pxs) - r_post, max(pxs) + r_post)
    post_y = (min(pys) - r_post, max(pys) + r_post)

    # ---- scoop + bar --------------------------------------------------------
    scoop = one([c for c in CX if c["bore"] and 3.0 < c["r"] < 4.0], "scoop")
    bar_big = one([c for c in CX if not c["bore"] and 1.2 < c["r"] < 1.7], "bar big")
    bar_rods = [c for c in CX if not c["bore"] and 0.5 < c["r"] < 0.8]
    assert len(bar_rods) == 2, f"body {bid}: bar rods: {len(bar_rods)}"

    print(f"body {bid}: z_bot={R(z_bot)} gap={R(x_gap[0])},{R(x_gap[1])} "
          f"hinge=({R(hy)},{R(hz)}) pin r={R(r_pin)} x=[{R(pin_lo)},{R(pin_hi)}] "
          f"pocket=[{R(pocket['ext'][0])},{R(pocket['ext'][1])}] r={R(pocket['r'])}")
    print(f"   slot y=[{R(y_slot0)},{R(y_slot_end)}] ceil={R(z_ceil)} "
          f"post x=[{R(post_x[0])},{R(post_x[1])}] y=[{R(post_y[0])},{R(post_y[1])}] "
          f"scoop=({R(scoop['o'][1])},{R(scoop['o'][2])}) r={R(scoop['r'])}")
    print(f"   back plane n={[R(v) for v in back_p['n']]} d={R(back_p['d'])} "
          f"gapwall n={[R(v) for v in gapw_p['n']]} d={R(gapw_p['d'])}")

    # ---- shell stations -----------------------------------------------------
    # true y extent from the mesh (the OCC bbox overestimates bspline extents)
    vlo, vhi = bb["min"][0] - 0.3, bb["max"][0] + 0.3
    v = mesh.vertices[(mesh.vertices[:, 0] >= vlo) & (mesh.vertices[:, 0] <= vhi)]
    y0 = float(v[:, 1].min()) + 0.12   # stations cover the FULL back — the
    y1 = float(v[:, 1].max())          # rounded knuckle lobes ARE the back
    ys = set()
    y = y0
    while y < y0 + 2.4:                # fine over the lobe-back curvature
        ys.add(R(y)); y += 0.4
    while y < y1 - 6:
        ys.add(R(y)); y += 2.0
    while y < y1 - 2:
        ys.add(R(y)); y += 1.0
    while y < y1 - 0.6:
        ys.add(R(y)); y += 0.5
    ys |= {R(y1 - 0.35), R(y1 - 0.15), R(y1 - 0.05)}
    for fy in np.arange(hy - 3.0, hy + 3.1, 0.5):   # dense over the hinge lobe
        if fy > y0:
            ys.add(R(fy))
    ys = sorted(ys)
    profiles = {y: station_profile(body, y) for y in ys}
    ys = [y for y in ys if profiles[y] is not None]

    # repair pass: trimesh.section sometimes returns a PARTIAL section (its
    # hull collapses); detect interior stations whose z-span collapses vs both
    # neighbors, re-sample at shifted y, else drop the station (neighbors span it)
    def zspan(prof):
        zs = [p[1] for p in prof]
        return max(zs) - min(zs)

    repaired = []
    for i, y in enumerate(ys):
        if 0 < i < len(ys) - 1:
            nb = min(zspan(profiles[ys[i - 1]]), zspan(profiles[ys[i + 1]]))
            if zspan(profiles[y]) < 0.6 * nb:
                fixed = None
                for dy in (0.15, -0.15, 0.25, -0.25, 0.35):
                    alt = station_profile(body, R(y + dy))
                    if alt is not None and zspan(alt) >= 0.8 * nb:
                        fixed = (R(y + dy), alt)
                        break
                if fixed:
                    print(f"   station y={y}: partial section, resampled at {fixed[0]}")
                    profiles[fixed[0]] = fixed[1]
                    repaired.append(fixed[0])
                else:
                    print(f"   station y={y}: partial section, DROPPED")
                continue
        repaired.append(y)
    ys = sorted(set(repaired))
    print(f"   {len(ys)} stations, "
          f"{sum(len(profiles[y]) for y in ys)} hull pts")

    pre = f"b{bid}_"
    eps = 0.02

    def slab(y, tag):
        return {"prim": "extrude", "axis": "y", "name": f"st{tag}",
                "source": f"measured section convex hull at y={y} "
                          "(high-res tessellation of the STEP)",
                "profile": [[p[1], p[0]] for p in profiles[y]],  # (z, x)
                "z0": R(y), "z1": R(y + eps)}

    segs = [{"op": "hull", "children": [slab(ys[i], f"{i:02d}a"),
                                        slab(ys[i + 1], f"{i:02d}b")]}
            for i in range(len(ys) - 1)]
    shell = {"op": "union", "children": segs}

    # ---- cuts ---------------------------------------------------------------
    zlo, zhi = z_bot - 1.0, bb["max"][2] + 1.5
    gap_cut = {
        "prim": "extrude", "axis": "x", "name": "gap",
        "source": f"clevis gap between exact inner-wall planes #{gap_lo_p['i']}/"
                  f"#{gap_hi_p['i']}; front wall = exact tilted plane #{gapw_p['i']}",
        "profile": [[R(bb["min"][1] - 2), R(zlo)], [R(y_at(gapw_p, zlo)), R(zlo)],
                    [R(y_at(gapw_p, zhi)), R(zhi)], [R(bb["min"][1] - 2), R(zhi)]],
        "z0": R(x_gap[0]), "z1": R(x_gap[1])}
    relief_cut = {
        "prim": "cylinder", "name": "relief",
        "source": f"knuckle relief: exact cylinder face #{relief['i']}",
        "p0": [R(x_gap[0]), R(hy), R(hz)], "p1": [R(x_gap[1]), R(hy), R(hz)],
        "r": R(relief["r"])}
    pin_cut = {
        "prim": "cylinder", "name": "pin_bore",
        "source": "hinge pin bore: exact cylinder faces "
                  + "/".join(f"#{c['i']}" for c in pin_faces)
                  + " between the exact annulus planes",
        "p0": [R(pin_lo), R(hy), R(hz)], "p1": [R(pin_hi), R(hy), R(hz)],
        "r": R(r_pin)}
    pocketL_cut = {
        "prim": "cylinder", "name": "pocketL",
        "source": f"snap-pin pocket: exact full-circle cylinder face #{pocket['i']}",
        "p0": [R(pocket["ext"][0]), R(hy), R(hz)],
        "p1": [R(pocket["ext"][1]), R(hy), R(hz)], "r": R(pocket["r"])}
    pocketR_cut = {
        "prim": "cylinder", "name": "pocketR",
        "source": "right pocket: same radius as face-measured left pocket; "
                  "breaks out through the skin (annulus plane at the bore band end)",
        "p0": [R(pin_hi), R(hy), R(hz)],
        "p1": [R(bb["max"][0] + 1.5), R(hy), R(hz)], "r": R(pocket["r"])}
    # slot cross-section (z, x): walls at gap planes, ceiling z_ceil, r2 coves
    cove_cx = (x_gap[0] + coves[0]["r"], x_gap[1] - coves[0]["r"])
    arc = lambda cx, cz, r, a0, a1: [
        [R(cz + r * np.sin(a)), R(cx + r * np.cos(a))]
        for a in np.linspace(a0, a1, 7)]
    slot_prof = ([[R(zlo), R(x_gap[0])], [R(coves[0]["o"][2]), R(x_gap[0])]]
                 + arc(cove_cx[0], coves[0]["o"][2], coves[0]["r"], np.pi, np.pi / 2)
                 + arc(cove_cx[1], coves[0]["o"][2], coves[0]["r"], np.pi / 2, 0)
                 + [[R(coves[0]["o"][2]), R(x_gap[1])], [R(zlo), R(x_gap[1])]])
    slot_cut = {
        "prim": "extrude", "axis": "y", "name": "slot",
        "source": f"tendon slot: exact wall planes #{gap_lo_p['i']}/#{gap_hi_p['i']}, "
                  f"ceiling plane z={R(z_ceil)}, r2 ceiling coves (faces "
                  + "/".join(f"#{c['i']}" for c in coves)
                  + f"), front wall plane #{slotf_p['i']}; rear overshoots into the gap",
        "profile": slot_prof, "z0": R(y_slot0 - 3), "z1": R(y_slot_end)}
    scoop_cut = {
        "prim": "cylinder", "name": "scoop",
        "source": f"top cord scoop: exact cylinder face #{scoop['i']}",
        "p0": [R(scoop["ext"][0]), R(scoop["o"][1]), R(scoop["o"][2])],
        "p1": [R(scoop["ext"][1]), R(scoop["o"][1]), R(scoop["o"][2])],
        "r": R(scoop["r"])}
    # top channel: the flat between the inner walls, behind the scoop — the
    # exact tilted plane the hull-loft would otherwise bridge over
    chans = [p for p in P if p["n"][2] > 0.9 and 0.02 < p["n"][1] < 0.2
             and p["area"] > 5]
    chan_p = max(chans, key=lambda p: p["d"])
    z_chan = lambda y: (chan_p["d"] - chan_p["n"][1] * y) / chan_p["n"][2]
    yc0, yc1 = bb["min"][1] - 2, scoop["o"][1] + 0.3
    chan_cut = {
        "prim": "extrude", "axis": "x", "name": "channel",
        "source": f"top channel floor: exact tilted plane #{chan_p['i']} "
                  f"(n={[R(v) for v in chan_p['n']]}, d={R(chan_p['d'])}) between "
                  "the inner walls, from the gap to scoop tangency",
        "profile": [[R(yc0), R(z_chan(yc0))], [R(yc1), R(z_chan(yc1))],
                    [R(yc1), R(zhi)], [R(yc0), R(zhi)]],
        "z0": R(x_gap[0]), "z1": R(x_gap[1])}

    # ---- add-backs ----------------------------------------------------------
    rr = lambda cx, cy, r, a0, a1: [
        [R(cx + r * np.cos(a)), R(cy + r * np.sin(a))]
        for a in np.linspace(a0, a1, 6)]
    post_prof = (rr(pxs[1], pys[1], r_post, 0, np.pi / 2)
                 + rr(pxs[0], pys[1], r_post, np.pi / 2, np.pi)
                 + rr(pxs[0], pys[0], r_post, np.pi, 1.5 * np.pi)
                 + rr(pxs[1], pys[0], r_post, 1.5 * np.pi, 2 * np.pi))
    post = {
        "prim": "extrude", "axis": "z", "name": "post",
        "source": f"tendon post: exact wall planes x=[{R(post_x[0])},{R(post_x[1])}], "
                  f"r{R(r_post)} corner cylinders (faces "
                  + "/".join(f"#{c['i']}" for c in posts) + ")",
        "profile": post_prof, "z0": R(z_bot), "z1": R(z_ceil)}
    nooks = []
    for k, c in enumerate(sorted(vfil, key=lambda c: c["o"][0])):
        cx, cy = c["o"][0], c["o"][1]
        wall = x_gap[0] if cx < (x_gap[0] + x_gap[1]) / 2 else x_gap[1]
        nooks.append({"op": "difference", "children": [
            {"prim": "box", "name": f"nook{k}",
             "source": f"slot front-corner nook: bounded by wall x={R(wall)}, "
                       f"front plane y={R(y_slot_end)}, r2 vertical fillet face #{c['i']}",
             "min": [R(min(wall, cx)), R(cy), R(z_bot)],
             "size": [R(abs(cx - wall)), R(y_slot_end - cy), R(z_ceil - z_bot)]},
            {"prim": "cylinder", "name": f"nook{k}_f",
             "source": f"r2 vertical fillet: exact cylinder face #{c['i']}",
             "p0": [R(cx), R(cy), R(z_bot - 0.5)],
             "p1": [R(cx), R(cy), R(z_ceil + 0.5)], "r": R(c["r"])}]})
    bar_cyls = []
    for k, c in enumerate([bar_big] + bar_rods):
        bar_cyls.append({
            "prim": "cylinder", "name": f"bar{k}",
            "source": f"cord bar: exact boss cylinder face #{c['i']} "
                      f"(r={R(c['r'])} at y={R(c['o'][1])}, z={R(c['o'][2])}); "
                      "ends extended to the inner walls (the B-rep blends the "
                      "bar into the walls via small bspline webs)",
            "p0": [R(x_gap[0]), R(c["o"][1]), R(c["o"][2])],
            "p1": [R(x_gap[1]), R(c["o"][1]), R(c["o"][2])], "r": R(c["r"])})
    # The rods are internally tangent to the big cylinder, so union == big
    # cylinder — but the ORIGINAL bar's top is trimmed at the web tangent to
    # the two rod tops (ruled bspline f21-analog): cut everything above the
    # measured tangent line through (rod_y, rod_z + rod_r), extended across x.
    (ry0, rz0), (ry1, rz1) = [(c["o"][1], c["o"][2] + c["r"]) for c in bar_rods]
    if ry0 > ry1:
        (ry0, rz0), (ry1, rz1) = (ry1, rz1), (ry0, rz0)
    slope = (rz1 - rz0) / (ry1 - ry0)
    ya, yb = ry0 - 4, ry1 + 4
    za, zb = rz0 + slope * (ya - ry0), rz0 + slope * (yb - ry0)
    bar_top_cut = {
        "prim": "extrude", "axis": "x", "name": "bar_topcut",
        "source": "bar top web: tangent line through the two rod-top points "
                  f"({R(ry0)},{R(rz0)})-({R(ry1)},{R(rz1)}) measured from exact "
                  "rod faces; everything above is void in the original",
        "profile": [[R(ya), R(za)], [R(yb), R(zb)],
                    [R(yb), R(zb + 6)], [R(ya), R(za + 6)]],
        "z0": R(x_gap[0] - 0.5), "z1": R(x_gap[1] + 0.5)}
    bar = {"op": "difference",
           "children": [{"op": "union", "children": bar_cyls}, bar_top_cut]}

    tree = {"op": "union", "children": [
        {"op": "difference", "children": [
            shell, gap_cut, relief_cut, pin_cut, pocketL_cut, pocketR_cut,
            slot_cut, scoop_cut, chan_cut]},
        post] + nooks + [bar]}
    return {
        "body_id": bid, "strategy": "csg",
        "notes": "hull-loft shell from measured sections (full-back stations); "
                 "exact-plane/cylinder cuts (gap, hinge, slot, scoop, top "
                 "channel); post/nooks/bar re-added",
        "csg": tree}


bodies_out = []
for uid in (0, 1, 2):
    bodies_out.append(build_body(feats["bodies"][uid]))
for iid, of in ((3, 2), (4, 1)):
    off = (np.asarray(feats["bodies"][iid]["centroid"])
           - np.asarray(feats["bodies"][of]["centroid"]))
    bodies_out.append({
        "body_id": iid, "strategy": "instance_of", "of": of,
        "translate": [R(v) for v in off],
        "source": f"exact centroid delta body{iid}-body{of} "
                  "(identical volumes, same-side hinge pockets)",
        "notes": f"translated instance of body {of}"})

plan = {"version": 1, "source": feats["source"], "bodies": bodies_out}
json.dump(plan, open("output/Distals/plan.json", "w"), indent=1)
print("wrote output/Distals/plan.json")
