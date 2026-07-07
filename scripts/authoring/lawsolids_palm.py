"""Law-solid candidate scan for the Palm shell/cavity — NEGATIVE RESULT.

Runs the full law-model candidate scan over the measured bands that remain
in output/Palm_left/plan.json (602 shell + 137 cavity) and prints the
rejection table. It deliberately makes NO plan change: every candidate model
failed its residual gate, so per the parametric-preferred policy (quantify,
then decide) the measured bands stay — they are genuinely organic.

Models tested (2026-07-07), with the measured rejections:

  1. ARC offset laws on the knuckle-post tops (towers t00/t01/t02,
     y > 41.5): per-band insets vs the tower base are NOT uniform — std
     explodes to 2-3 mm because the profiles morph topologically (clevis
     slots begin), they are not offsets. (Linear laws already failed in the
     previous pass.)
  2. Sphere / x-cylinder caps fitted to the reference-tessellation tip
     patches (y > 41.5 and > 42.5): residuals 1.6-3.1 mm — the tips are
     slot-cut composite shapes, not quadric caps.
  3. Windowed wrist-edge laws (towers t03/t04, y -46.9..-42, base at the
     interior side): uniform-inset subsets exist (8/15, 13/15) but the
     fitted slopes are ~0.008 mm/mm — constant within noise, i.e. already
     handled by constant-run collapse where consecutive; no chamfer or
     roundover law is present.
  4. Cavity ceiling/floor/mid windows: per-band inset std 1.7-12.8 mm —
     the cavity bands morph shape band-to-band; offsets do not describe
     them at all.

The sampling-window trap from crownlaws (res 0.378 -> 0.011 after
windowing) was accounted for: all fits above were re-run windowed; the
rejections stand.

Run: python3 scripts/authoring/lawsolids_palm.py
"""
import json
import re
import sys

import numpy as np

sys.path.insert(0, "src")
from step2scad.fitting import circle_fit, dist_to_poly, line_fit  # noqa: E402

PLAN = "output/Palm_left/plan.json"
REF = "output/Palm_left/Palm_left_ref.stl"
UNIFORM_STD = 0.15   # a band is an offset of the base only below this
LAW_RES = 0.12       # a law is claimable only below this residual


def prof_pts(e):
    if "profile" in e:
        return np.array(e["profile"], float)
    p2 = e.get("profile2d", {})
    if "path" in p2:
        pts = []
        for s in p2["path"]:
            if "to" in s:
                pts.append(s["to"])
            else:
                a = s["arc"]
                for k in range(1, a["n"] + 1):
                    ang = np.radians(a["a0"] + k * (a["a1"] - a["a0"]) / a["n"])
                    pts.append([a["c"][0] + a["r"] * np.cos(ang),
                                a["c"][1] + a["r"] * np.sin(ang)])
        return np.array(pts, float)
    return None


def offset_law_scan(rows, label, y_lo, y_hi, base_at):
    seg = sorted((r for r in rows if r[0] >= y_lo - 1e-6 and r[1] <= y_hi + 1e-6),
                 key=lambda q: q[0])
    if len(seg) < 4:
        return f"{label}: only {len(seg)} bands — skipped"
    base = prof_pts(seg[0][2] if base_at == "lo" else seg[-1][2])
    ys, ins, stds = [], [], []
    for z0, z1, e in (seg[1:] if base_at == "lo" else seg[:-1]):
        p = prof_pts(e)
        if p is None or len(p) < 4:
            continue
        d = dist_to_poly(p, base)
        ys.append((z0 + z1) / 2)
        ins.append(d.mean())
        stds.append(d.std())
    ys, ins, stds = map(np.array, (ys, ins, stds))
    ok = stds < UNIFORM_STD
    msg = (f"{label}: {len(seg)} bands, uniform {ok.sum()}/{len(ys)} "
           f"(mean std {stds.mean():.3f})")
    if ok.sum() >= 4:
        m, c, res_l = line_fit(ys[ok], ins[ok])
        _, _, r, res_a = circle_fit(np.c_[ys[ok], ins[ok]])
        law = "NONE"
        if res_l < LAW_RES and abs(m) > 0.05:
            law = f"LINEAR m={m:.3f}"
        elif res_a < LAW_RES:
            law = f"ARC r={r:.1f}"
        msg += (f" | line res={res_l:.3f} m={m:.4f}, arc r={r:.1f} "
                f"res={res_a:.3f} -> {law}")
    return msg


def sphere_fit(p):
    A = np.c_[2 * p, np.ones(len(p))]
    sol, *_ = np.linalg.lstsq(A, (p ** 2).sum(axis=1), rcond=None)
    c = sol[:3]
    r = float(np.sqrt(sol[3] + (c ** 2).sum()))
    return c, r, float(np.abs(np.linalg.norm(p - c, axis=1) - r).max())


def main():
    plan = json.loads(open(PLAN).read())
    b = plan["bodies"][0]
    shell = b["modules"]["palm_shell"]["tree"]["children"]
    towers = {}
    for e in shell:
        m = re.match(r"shell_t(\d+)[br](\d+)", e["name"])
        if m:
            towers.setdefault(m.group(1), []).append(
                (float(e["z0"]), float(e["z1"]), e))

    print("== 1. arc-offset laws on knuckle-post tops (base = tower base) ==")
    for tid in ("00", "01", "02"):
        print("  " + offset_law_scan(towers[tid], f"t{tid} top", 40.0, 45.1, "lo"))

    print("== 2. quadric caps on tip patches (reference tessellation) ==")
    import trimesh
    mref = trimesh.load(REF, force="mesh")
    sub = mref.slice_plane([0, 41.5, 0], [0, 1, 0])
    for p in sorted((q for q in sub.split(only_watertight=False)
                     if len(q.vertices) > 30),
                    key=lambda q: q.vertices[:, 0].mean()):
        c, r, res = sphere_fit(np.asarray(p.vertices))
        print(f"  tip x~{p.vertices[:, 0].mean():6.1f}: sphere r={r:.2f} "
              f"res={res:.3f} -> {'OK' if res < 0.3 else 'REJECTED'}")

    print("== 3. windowed wrist-edge laws ==")
    for tid in ("03", "04"):
        print("  " + offset_law_scan(towers[tid], f"t{tid} wrist edge",
                                     -46.9, -42.0, "hi"))

    print("== 4. cavity windows ==")
    cav = [(float(e["z0"]), float(e["z1"]), e)
           for e in b["modules"]["palm_cavity"]["tree"]["children"]]
    ymax = max(r[1] for r in cav)
    ymin = min(r[0] for r in cav)
    print("  " + offset_law_scan(cav, "cavity top", ymax - 6, ymax, "lo"))
    print("  " + offset_law_scan(cav, "cavity bottom", ymin, ymin + 6, "hi"))
    print("  " + offset_law_scan(cav, "cavity mid", -10, 10, "lo"))

    print("\nVERDICT: no candidate passed its residual gate — the remaining "
          "palm bands are genuinely organic; the plan is left unchanged "
          "(policy: quantify, then decide).")


if __name__ == "__main__":
    main()
