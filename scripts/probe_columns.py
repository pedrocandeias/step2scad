"""Print occupied z-intervals of a mesh along vertical (x,y) columns.

The most direct way to read INTERIOR structure (slots, cavities, bridges,
counterbores) that section outlines bridge over. z sampled 0..zmax @0.05.

Usage: probe_columns.py ref.stl x1,x2,.. y1,y2,..

⚠ On non-watertight meshes (e.g. CSG output with exactly-coincident faces)
trimesh contains() can report phantom gaps — re-probe with small offsets and
cross-check before acting on a single column.
"""
import sys, numpy as np, trimesh

ref = sys.argv[1]
xs = [float(v) for v in sys.argv[2].split(",")]
ys = [float(v) for v in sys.argv[3].split(",")]
m = trimesh.load(ref, force="mesh")
if not m.is_watertight:
    print(f"⚠ {ref} is NOT watertight — contains() may report phantoms", file=sys.stderr)
zs = np.arange(m.bounds[0][2] - 0.5, m.bounds[1][2] + 0.5, 0.05)
for y in ys:
    row = []
    for x in xs:
        pts = np.c_[np.full_like(zs, x), np.full_like(zs, y), zs]
        occ = m.contains(pts)
        ivs, start = [], None
        for i, o in enumerate(occ):
            if o and start is None: start = zs[i]
            if not o and start is not None: ivs.append((start, zs[i - 1])); start = None
        if start is not None: ivs.append((start, zs[-1]))
        row.append(f"x{x:g}:" + ("+".join(f"[{a:.2f},{b:.2f}]" for a, b in ivs) or "empty"))
    print(f"y={y:g}: " + "  ".join(row))
