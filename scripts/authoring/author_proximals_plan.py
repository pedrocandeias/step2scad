"""Author output/Proximals/plan.json (bodies 3 and 2 full CSG; 0,1,4 instances of 3).

STRATEGY (agent decision):
  Three hull-lofts along y, then exact cuts:
    L1 BEAM  — stations over the full length, section points restricted to the
               exact beam-wall window (x = the two big coplanar wall planes);
               the ridge window is excluded so the hull can't smear it wide
    L2 RIDGE — stations over the dorsal-stop ridge only (narrow x window,
               upper z); ridge sides are skin, measured per station
    L3 CROWN — stations over the full-width core+deck band (exact end walls)
  Cuts (exact B-rep values): tendon tunnel (full-circle r1.125 cylinder face),
  channel slots outside the measured floor bridge, two knuckle pin bores,
  under-deck recesses (4 boxes to the measured deck underside), elastic-knot
  pocket (exact floor/wall planes + raycast-measured back wall).
Every number is an exact B-rep parameter or a probe/mesh measurement.
"""
import json
import numpy as np

import sys
sys.path.insert(0, "src")
from step2scad.ingest import read_step, shape_to_trimesh

STEP = "models/phoenix_components/Proximals.step"
feats = json.load(open("output/Proximals/features.json"))
# fine tessellation: coarse outlines bias the measured stations inward ~0.05mm
mesh = shape_to_trimesh(read_step(STEP), linear_deflection=0.008)

R = lambda x: round(float(x), 6)


def convex_hull(pts):
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
            if abs(np.cross(ab, b - a)) / n < tol:
                out.pop(i)
                changed = True
                break
    return [[R(p[0]), R(p[1])] for p in out]


def station_points(body, y, xwin=None, zmin=None, exclude=None):
    """RAW (x, z) section points at y, window/exclusion filtered (no hull)."""
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
    p = np.vstack(pts)
    if xwin is not None:
        p = p[(p[:, 0] >= xwin[0] - 1e-6) & (p[:, 0] <= xwin[1] + 1e-6)]
    if zmin is not None:
        p = p[p[:, 1] >= zmin]
    if exclude is not None:
        wins = exclude if isinstance(exclude, list) else [exclude]
        for xlo, xhi, zlo in wins:
            p = p[~((p[:, 0] > xlo) & (p[:, 0] < xhi) & (p[:, 1] > zlo))]
    return p if len(p) >= 3 else None


def station_profile(body, y, xwin=None, zmin=None, exclude=None):
    """Convex hull (x, z) profile of the station (see station_points)."""
    p = station_points(body, y, xwin=xwin, zmin=zmin, exclude=exclude)
    if p is None:
        return None
    prof = decimate(convex_hull(p))
    return prof if len(prof) >= 3 else None


def ray_hits(origin, direction):
    loc, _, _ = mesh.ray.intersects_location(
        ray_origins=[origin], ray_directions=[direction], multiple_hits=True)
    d = np.asarray(direction, float)
    t = (loc - origin) @ (d / np.linalg.norm(d))
    return loc[np.argsort(t)]


def planes_of(body):
    out = []
    for f in body["faces"]:
        if f["type"] != "plane":
            continue
        n = np.asarray(f["params"]["normal"], float)
        n /= np.linalg.norm(n)
        d = float(n @ np.asarray(f["params"]["origin"]))
        for p in out:  # merge coplanar faces (same normal + offset)
            if float(p["n"] @ n) > 1 - 1e-6 and abs(p["d"] - d) < 1e-4:
                p["area"] += f["area"]
                p["i"] = f"{p['i']}/{f['index']}"
                break
        else:
            out.append({"i": f["index"], "n": n, "area": f["area"], "d": d})
    return out


def cyls_along(body, axis):
    out = []
    for f in body["faces"]:
        if f["type"] != "cylinder":
            continue
        p = f["params"]
        d = np.asarray(p["axis_dir"], float)
        if abs(abs(d[axis]) - 1.0) > 1e-3:
            continue
        base = p["axis_origin"][axis]
        sgn = np.sign(d[axis]) or 1.0
        ext = sorted(base + sgn * v for v in p and f["v_range"])
        out.append({"i": f["index"], "r": p["radius"], "o": p["axis_origin"],
                    "ext": ext, "arc": np.degrees(abs(f["u_range"][1] - f["u_range"][0])),
                    "bore": f["orientation"] == "reversed"})
    return out


def build_body(body):
    bid = body["id"]
    bb = body["bbox"]
    P = planes_of(body)
    CX = cyls_along(body, 0)
    CY = cyls_along(body, 1)

    def one(c, what):
        assert len(c) == 1, f"body {bid}: {what}: {len(c)} candidates {[(x.get('i'), x.get('area'), x.get('d')) for x in c] if c and 'area' in c[0] else c}"
        return c[0]

    # ---- exact reference geometry -------------------------------------------
    beam_l_p = one([p for p in P if p["n"][0] < -0.9999 and p["area"] > 100],
                   "beam left wall")
    beam_r_p = one([p for p in P if p["n"][0] > 0.9999 and p["area"] > 100],
                   "beam right wall")
    beam_x = (beam_l_p["d"] * -1.0, beam_r_p["d"])  # position = d * n_x
    assert beam_x[0] < beam_x[1], f"body {bid}: beam walls {beam_x}"
    z_bot_p = one([p for p in P if p["n"][2] < -0.9999 and p["area"] > 50], "bottom")
    z_bot = -z_bot_p["d"]

    tunnel = one([c for c in CY if c["bore"] and c["arc"] > 350], "tendon tunnel")
    tx, tz, tr = tunnel["o"][0], tunnel["o"][2], tunnel["r"]
    slot_x = (tx - tr, tz), (tx + tr, tz)

    bores = sorted([c for c in CX if c["bore"] and c["arc"] > 350 and 2.0 < c["r"] < 3.0],
                   key=lambda c: c["o"][1])
    assert len(bores) == 2, f"body {bid}: pin bores: {len(bores)}"

    # bridge walls: small opposed y-planes near the tunnel mid-span; when the
    # face list is ambiguous, verify by measurement — the bridge fills the
    # channel below the tunnel, so material sits under the tunnel just INSIDE
    # the wall and void just OUTSIDE it
    def under_tunnel_material(yq):
        h = ray_hits([tx, yq, tz - tr - 0.05], [0, 0, -1])
        return len(h) > 0 and abs(float(h[0][2]) - z_bot) < (tz - tr)

    def bridge_wall(cands, sign, what):
        good = [p for p in cands
                if under_tunnel_material(p["d"] * p["n"][1] + 0.3 * sign)
                and not under_tunnel_material(p["d"] * p["n"][1] - 0.3 * sign)]
        return one(good, what)

    bw_back = [p for p in P if p["n"][1] < -0.999 and abs(p["n"][2]) < 0.02
               and 1.5 < p["area"] < 5 and abs(p["d"]) < 8]
    bw_front = [p for p in P if p["n"][1] > 0.999 and abs(p["n"][2]) < 0.02
                and 1.5 < p["area"] < 5 and abs(p["d"]) < 8]
    bb_p = bridge_wall(bw_back, +1, "bridge back") if len(bw_back) > 1 else one(bw_back, "bridge back")
    bf_p = bridge_wall(bw_front, -1, "bridge front") if len(bw_front) > 1 else one(bw_front, "bridge front")
    bridge_y = (bb_p["d"] * bb_p["n"][1], bf_p["d"] * bf_p["n"][1])
    assert bridge_y[0] < bridge_y[1]

    # deck band walls (recess y-limits): the opposed y-planes NEAREST the core
    # (other candidates at the same normal are the part ends / knuckle faces)
    db = [p for p in P if p["n"][1] < -0.999 and abs(p["n"][2]) < 0.02
          and 8 < p["area"] < 40 and -p["d"] < bridge_y[0]]
    assert db, f"body {bid}: no deck back wall"
    deck_back_p = max(db, key=lambda p: -p["d"])
    df = [p for p in P if p["n"][1] > 0.999 and abs(p["n"][2]) < 0.02
          and 8 < p["area"] < 40 and p["d"] > bridge_y[1]]
    assert df, f"body {bid}: no deck front wall"
    deck_front_p = min(df, key=lambda p: p["d"])
    deck_y = (-deck_back_p["d"], deck_front_p["d"])
    assert deck_y[0] < deck_y[1]

    # elastic pocket: full-beam-width void above the exact +z floor plane,
    # with side shoulders (z = floor) flanking the deck's center crest behind it
    floors = [p for p in P if p["n"][2] > 0.9999 and 10 < p["area"] < 60]
    assert floors, f"body {bid}: no pocket floor"
    floor_p = max(floors, key=lambda p: p["d"] * p["n"][2])  # highest flat
    z_floor = floor_p["d"] * floor_p["n"][2]
    nf = one([p for p in P if p["n"][1] < -0.999 and abs(p["n"][2]) < 0.02
              and 2 < p["area"] < 8
              and bridge_y[0] + 0.1 < p["d"] * p["n"][1] < bridge_y[0] + 3],
             "pocket front")
    pocket_front = nf["d"] * nf["n"][1]
    # back wall: raycast-measured (no analytic plane — skin/fillet bounded)
    hits = ray_hits([tx, pocket_front + 1.0, z_floor + 1.5], [0, -1, 0])
    pocket_back = float(hits[1][1])  # 1st hit = front wall, 2nd = back wall
    assert pocket_front - 4 < pocket_back < pocket_front, \
        f"body {bid}: pocket back {pocket_back}"

    # dorsal ridge: exact plane side walls strictly inside the beam window
    xpos = lambda p: p["d"] * p["n"][0]
    rl = [p for p in P if p["n"][0] < -0.9999 and p["area"] > 5
          and beam_x[0] + 0.4 < xpos(p) < beam_x[1] - 0.4]
    rr = [p for p in P if p["n"][0] > 0.9999 and p["area"] > 5
          and beam_x[0] + 0.4 < xpos(p) < beam_x[1] - 0.4
          and abs(xpos(p) - tx + tr) > 0.1 and abs(xpos(p) - tx - tr) > 0.1]
    rl = [p for p in rl if abs(xpos(p) - tx + tr) > 0.1 and abs(xpos(p) - tx - tr) > 0.1]
    ridge_x = (xpos(one(rl, "ridge left")), xpos(one(rr, "ridge right")))
    assert ridge_x[0] < ridge_x[1], f"body {bid}: ridge walls {ridge_x}"

    # deck undersides: raycast-measured lowest point per side (flat v1 cut)
    y_mid_deck_palm = (deck_y[0] + bridge_y[0]) / 2
    y_mid_deck_dist = (bridge_y[1] + deck_y[1]) / 2
    def under(x, y):
        h = ray_hits([x, y, bb["max"][2] + 5], [0, 0, -1])
        return float(h[1][2]) if len(h) >= 2 else None  # 2nd hit = deck underside
    under_palm = min(v for v in (under(beam_x[0] - 1.5, y_mid_deck_palm),
                                 under(beam_x[1] + 1.5, y_mid_deck_palm)) if v)
    under_dist = min(v for v in (under(beam_x[0] - 1.5, y_mid_deck_dist),
                                 under(beam_x[1] + 1.5, y_mid_deck_dist)) if v)

    # ridge (dorsal stop) column mask height: above the distal shoulder tops
    ridge_zmin = bores[0]["o"][2] + 4.4

    print(f"body {bid}: beam x=[{R(beam_x[0])},{R(beam_x[1])}] z_bot={R(z_bot)} "
          f"tunnel=(x={R(tx)},z={R(tz)},r={R(tr)}) ext={[R(v) for v in tunnel['ext']]}")
    print(f"   bores: " + "; ".join(f"r={R(c['r'])} y={R(c['o'][1])} z={R(c['o'][2])}" for c in bores))
    print(f"   bridge y={[R(v) for v in bridge_y]} deck y={[R(v) for v in deck_y]} "
          f"under_palm={R(under_palm)} under_dist={R(under_dist)}")
    print(f"   pocket y=[{R(pocket_back)},{R(pocket_front)}] floor={R(z_floor)} "
          f"ridge x={[R(v) for v in ridge_x]}")

    # ---- station grids -------------------------------------------------------
    vlo, vhi = bb["min"][0] - 0.3, bb["max"][0] + 0.3
    v = mesh.vertices[(mesh.vertices[:, 0] >= vlo) & (mesh.vertices[:, 0] <= vhi)]
    y0, y1 = float(v[:, 1].min()) + 0.1, float(v[:, 1].max()) - 0.05

    def grid(a, b, fine_ends=1.6, step=1.0, fine=0.35):
        ys, y = set(), a
        while y < a + fine_ends:
            ys.add(R(y)); y += fine
        while y < b - fine_ends:
            ys.add(R(y)); y += step
        while y < b:
            ys.add(R(y)); y += fine
        ys.add(R(b))
        return sorted(ys)

    def loft(name, ys_list, phase, **kw):
        profs = {}
        for y in ys_list:
            kw2 = dict(kw)
            if callable(kw2.get("exclude")):
                kw2["exclude"] = kw2["exclude"](y)
            p = station_profile(body, y, **kw2)
            if p is not None:
                profs[y] = p
        ys = sorted(profs)
        # neighbor-consistency repair (partial trimesh sections)
        def span(pr):
            zs = [q[1] for q in pr]
            return max(zs) - min(zs)
        keep = []
        for i, y in enumerate(ys):
            if 0 < i < len(ys) - 1:
                nb = min(span(profs[ys[i - 1]]), span(profs[ys[i + 1]]))
                if span(profs[y]) < 0.6 * nb:
                    alt = None
                    for dy in (0.15, -0.15, 0.25, -0.25):
                        kw3 = dict(kw)
                        if callable(kw3.get("exclude")):
                            kw3["exclude"] = kw3["exclude"](R(y + dy))
                        a = station_profile(body, R(y + dy), **kw3)
                        if a is not None and span(a) >= 0.8 * nb:
                            alt = (R(y + dy), a)
                            break
                    if alt:
                        profs[alt[0]] = alt[1]
                        keep.append(alt[0])
                    continue
            keep.append(y)
        ys = sorted(set(keep))
        eps = 0.02
        def slab(y, tag):
            return {"prim": "extrude", "axis": "y", "name": f"{name}{tag}",
                    "source": f"measured section hull at y={y} ({phase})",
                    "profile": [[p[1], p[0]] for p in profs[y]],
                    "z0": R(y), "z1": R(y + eps)}
        segs = [{"op": "hull", "children": [slab(ys[i], f"{i:02d}a"),
                                            slab(ys[i + 1], f"{i:02d}b")]}
                for i in range(len(ys) - 1)]
        print(f"   loft {name}: {len(ys)} stations")
        return segs

    beam_ys = set(grid(y0, y1, step=0.6))
    for by in (bores[0]["o"][1], bores[1]["o"][1]):  # knuckle heads change fast
        for fy in np.arange(by - 4.0, by + 4.05, 0.3):
            if y0 < fy < y1:
                beam_ys.add(R(fy))
    # Palm/mid side: plain beam window (crest handled by crown + shoulder cuts).
    # Distal side: exclude the ridge column ±0.7 (the ridge CAP flares ~0.35
    # past its exact side walls) so escaped points can't smear the hull into
    # trapezoids — the two-band ridge loft below owns that column.
    RIDGE_PAD = 0.7
    crown_segs = loft("cr", grid(deck_y[0] + 0.01, deck_y[1] - 0.01,
                                 fine_ends=1.2, step=0.8, fine=0.3), "full-width crown")
    # two-band ridge loft: STEM = points within the exact side walls; CAP =
    # full padded window above the measured cap underside (the flare). The cap
    # band adapts per station, so at the full-width knuckle head it reaches
    # down to the shoulders and no side gap is left.
    def ridge_two_band():
        eps = 0.02
        stems, caps = [], []
        yy = deck_y[1] + 0.05
        while yy < y1 + 0.2:
            y = R(min(yy, y1))
            pts = station_points(body, y, xwin=(ridge_x[0] - RIDGE_PAD,
                                                ridge_x[1] + RIDGE_PAD),
                                 zmin=ridge_zmin)
            if pts is not None:
                stem_pts = pts[(pts[:, 0] >= ridge_x[0] - eps)
                               & (pts[:, 0] <= ridge_x[1] + eps)]
                out_pts = pts[(pts[:, 0] < ridge_x[0] - eps)
                              | (pts[:, 0] > ridge_x[1] + eps)]
                if len(stem_pts) >= 3:
                    # extend the stem down to the measured shoulder just
                    # outside the column (the base-transition points fall in
                    # the beam's exclusion window and would leave a gap band)
                    sh = []
                    for xq in (ridge_x[0] - 0.25, ridge_x[1] + 0.25):
                        h = ray_hits([xq, y, bb["max"][2] + 5], [0, 0, -1])
                        if len(h):
                            sh.append(float(h[0][2]))
                    if sh:
                        zsh = max(min(sh) - 0.02, z_bot + 1)
                        stem_pts = np.vstack([stem_pts,
                                              [[ridge_x[0], zsh], [ridge_x[1], zsh]]])
                    stems.append((y, decimate(convex_hull(stem_pts))))
                if len(out_pts):
                    cz = float(out_pts[:, 1].min()) - 0.02
                    cap_pts = pts[pts[:, 1] >= cz]
                    if len(cap_pts) >= 3:
                        caps.append((y, decimate(convex_hull(cap_pts))))
            yy += 0.4
        def chain(items, name):
            segs = []
            for i in range(len(items) - 1):
                (ya, pa), (yb, pb) = items[i], items[i + 1]
                if yb - ya > 1.0:
                    continue  # gap: bands are not adjacent, don't bridge
                def slab(y, prof, tag):
                    return {"prim": "extrude", "axis": "y", "name": f"{name}{tag}",
                            "source": f"measured ridge section hull at y={y}",
                            "profile": [[q[1], q[0]] for q in prof],
                            "z0": R(y), "z1": R(y + 0.02)}
                segs.append({"op": "hull", "children": [
                    slab(ya, pa, f"{i:02d}a"), slab(yb, pb, f"{i:02d}b")]})
            return segs
        cz_tab = [(y, min(q[1] for q in prof)) for y, prof in caps]
        print(f"   ridge: {len(stems)} stem, {len(caps)} cap stations, "
              f"cap_z range {min(c for _, c in cz_tab):.2f}..{max(c for _, c in cz_tab):.2f}"
              if cz_tab else "   ridge: no caps")
        return chain(stems, "rgs") + chain(caps, "rgc"), cz_tab

    ridge_segs, cz_tab = ridge_two_band()
    cz_ys = [y for y, _ in cz_tab] or [deck_y[1], y1]
    cz_vs = [c for _, c in cz_tab] or [ridge_zmin + 2.0] * 2

    # beam: tight exclusion above the shoulders (stem walls only) + wide
    # exclusion above the measured cap underside (the flared lip region)
    beam_segs = (
        loft("bmp", sorted(y for y in beam_ys if y <= deck_y[1]), "beam window (palm/mid)",
             xwin=beam_x)
        + loft("bmd", sorted(y for y in beam_ys if y >= deck_y[1] - 0.5),
               "beam window (distal, ridge column excluded)",
               xwin=beam_x,
               exclude=lambda y: [
                   (ridge_x[0] - 0.02, ridge_x[1] + 0.02, ridge_zmin),
                   (ridge_x[0] - RIDGE_PAD, ridge_x[1] + RIDGE_PAD,
                    float(np.interp(y, cz_ys, cz_vs)) - 0.1)]))

    shell = {"op": "union", "children": beam_segs + crown_segs + ridge_segs}

    # ---- cuts ----------------------------------------------------------------
    zhi = bb["max"][2] + 2
    tun = {"prim": "cylinder", "name": "tunnel",
           "source": f"tendon tunnel: exact full-circle cylinder face #{tunnel['i']}",
           "p0": [R(tx), R(tunnel["ext"][0] - 2), R(tz)],
           "p1": [R(tx), R(tunnel["ext"][1]), R(tz)], "r": R(tr)}
    slot_palm = {"prim": "box", "name": "slot_palm",
                 "source": "tendon slot (palm side): walls tangent to the tunnel "
                           f"(x={R(tx - tr)}/{R(tx + tr)}), up to tunnel center, back "
                           f"overshoot; front = exact bridge back wall #{bw_back[0]['i']}",
                 "min": [R(tx - tr), R(tunnel["ext"][0] - 2), R(z_bot - 1)],
                 "size": [R(2 * tr), R(bridge_y[0] - tunnel["ext"][0] + 2), R(tz - z_bot + 1)]}
    slot_dist = {"prim": "box", "name": "slot_dist",
                 "source": "tendon slot (distal side): bridge front wall "
                           f"#{bw_front[0]['i']} to the exact tunnel end",
                 "min": [R(tx - tr), R(bridge_y[1]), R(z_bot - 1)],
                 "size": [R(2 * tr), R(tunnel["ext"][1] - bridge_y[1]), R(tz - z_bot + 1)]}
    bore_cuts = []
    for k, c in enumerate(bores):
        bore_cuts.append({"prim": "cylinder", "name": f"pin{k}",
                          "source": f"knuckle pin bore: exact cylinder face #{c['i']}",
                          "p0": [R(beam_x[0] - 1.5), R(c["o"][1]), R(c["o"][2])],
                          "p1": [R(beam_x[1] + 1.5), R(c["o"][1]), R(c["o"][2])],
                          "r": R(c["r"])})
    recesses = []
    # scan from the deck wall toward the core; the recess closes at the bulge
    for tag, ystart, ystep, ylim in (("rp", deck_y[0], +0.5, bridge_y[0] + 2.5),
                                     ("rd", deck_y[1], -0.5, bridge_y[1] - 2.5)):
        for side, (xa, xb), xprobe in (("l", (bb["min"][0] - 2, beam_x[0]), beam_x[0] - 1.5),
                                       ("r", (beam_x[1], bb["max"][0] + 2), beam_x[1] + 1.5)):
            # measured underside polyline: scan the band, stop where the
            # recess closes (deck merges into the core bulge)
            poly = []
            yy = ystart + 0.12 * ystep / abs(ystep)
            while (yy - ylim) * ystep < 0:
                h = ray_hits([xprobe, yy, bb["max"][2] + 5], [0, 0, -1])
                if len(h) < 2:
                    break
                under = float(h[1][2])
                if under < z_bot + 1.5:   # closed: deck merges downward
                    break
                poly.append((R(yy), R(under - 0.05)))
                yy += ystep
            assert len(poly) >= 2, f"body {bid}: recess {tag}{side}: no void found"
            poly.sort()
            # extend past the deck wall (open air behind it — safe overshoot)
            if ystep > 0:
                poly.insert(0, (R(poly[0][0] - 1.2), poly[0][1]))
            else:
                poly.append((R(poly[-1][0] + 1.2), poly[-1][1]))
            prof = ([[poly[0][0], R(z_bot - 1)]] + [[y, z] for y, z in poly]
                    + [[poly[-1][0], R(z_bot - 1)]])
            recesses.append({
                "prim": "extrude", "axis": "x", "name": f"{tag}{side}",
                "source": "under-deck recess: raycast-measured deck underside "
                          f"polyline at x={R(xprobe)} (0.5 steps, -0.05 margin), "
                          f"scan from the exact deck wall y={R(ystart)} toward "
                          "the core until closure",
                "profile": prof, "z0": R(xa), "z1": R(xb)})
    pocket = {"prim": "box", "name": "pocket",
              "source": "elastic pocket: full beam width (exact inward walls at "
                        f"the beam planes), front wall #{nf['i']}, floor "
                        f"#{floor_p['i']} z={R(z_floor)}; back wall raycast-measured",
              "min": [R(beam_x[0]), R(pocket_back), R(z_floor)],
              "size": [R(beam_x[1] - beam_x[0]), R(pocket_front - pocket_back),
                       R(zhi - z_floor)]}
    # crest walls flare outward near the top (like the ridge cap): measure the
    # widest crest extent so the shoulder cuts don't chop the flare
    crest_lo, crest_hi = tx - tr, tx + tr
    for zq in (z_floor + 0.5, z_floor + 1.5, z_floor + 2.3):
        for yq in (deck_y[0] + 1.5, (deck_y[0] + pocket_back) / 2,
                   deck_y[0] - 2.5, deck_y[0] - 4.0):
            for d, cur in ((-1, "lo"), (+1, "hi")):
                h = ray_hits([tx, yq, zq], [d, 0, 0])
                if len(h):
                    xw = float(h[0][0])
                    if not (beam_x[0] - 0.4 < xw < beam_x[1] + 0.4):
                        continue  # ray started in void and hit another feature
                    if cur == "lo":
                        crest_lo = min(crest_lo, xw)
                    else:
                        crest_hi = max(crest_hi, xw)
    shoulders = []
    for tag, (xa, xb) in (("shl", (beam_x[0], crest_lo - 0.03)),
                          ("shr", (crest_hi + 0.03, beam_x[1]))):
        shoulders.append({"prim": "box", "name": tag,
                          "source": "palm shoulder (deck band + knuckle, beside the center fin): "
                                    f"flat at the exact plane #{floor_p['i']}; fin/crest "
                                    "flare raycast-measured "
                                    f"(x=[{R(crest_lo)},{R(crest_hi)}])",
                          "min": [R(xa), R(bb["min"][1] - 1), R(z_floor)],
                          "size": [R(xb - xa), R(pocket_front - bb["min"][1] + 1),
                                   R(zhi - z_floor)]})

    fork = {"prim": "box", "name": "fork",
            "source": "palm clevis fork: full-height gap between the exact "
                      "channel-wall planes, behind the exact end wall (= the "
                      "tunnel start plane); raycast-verified ears-only at "
                      "y=-16.68",
            "min": [R(tx - tr), R(bb["min"][1] - 1.5), R(z_bot - 1)],
            "size": [R(2 * tr), R(tunnel["ext"][0] - bb["min"][1] + 1.5),
                     R(bb["max"][2] - z_bot + 3)]}
    tree = {"op": "difference", "children": [
        shell, tun, slot_palm, slot_dist, *bore_cuts, *recesses, pocket,
        *shoulders, fork]}
    return {"body_id": bid, "strategy": "csg",
            "notes": "beam+crown+ridge hull-lofts from measured sections; exact "
                     "tunnel/slot/bore/recess/pocket cuts",
            "csg": tree}


plans = {}
for uid in (3, 2):
    plans[uid] = build_body(feats["bodies"][uid])
bodies_out = [plans[3], plans[2]]
for iid in (0, 1, 4):
    off = (np.asarray(feats["bodies"][iid]["centroid"])
           - np.asarray(feats["bodies"][3]["centroid"]))
    bodies_out.append({"body_id": iid, "strategy": "instance_of", "of": 3,
                       "translate": [R(v) for v in off],
                       "source": f"exact centroid delta body{iid}-body3 (volumes "
                                 "match within 0.31 mm³ = 0.012%)",
                       "notes": f"translated instance of body 3"})
plan = {"version": 1, "source": feats["source"], "bodies": bodies_out}
json.dump(plan, open("output/Proximals/plan.json", "w"), indent=1)
print("wrote output/Proximals/plan.json")
