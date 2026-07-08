"""Generate EXACT occupancy boxes for the finger clevis (no loft, no stairs
where mergeable). Samples the reference tessellation's interior on a fine grid
in the finger region, then greedily merges occupied cells into maximal
axis-aligned boxes — few big boxes on the solid tine bases, more where the
geometry curves. The r2.5 pin bores are kept as exact cylinders (round holes)
by fingers.py, so they are EXCLUDED here (drilled after).

Writes output/Palm_left/finger_boxes.json (list of [min, size]).
Run: python3 scripts/authoring/gen_finger_boxes.py
"""
import json
from pathlib import Path

import numpy as np
import trimesh

OUT = Path("output/Palm_left")
RES = 0.5                                  # grid resolution (mm)
X0, X1 = -40.0, 22.0                       # finger region
Y0, Y1 = 27.0, 46.0
Z0, Z1 = 6.62, 16.6                        # deck top -> crown top (below dome apex)
# exact pin bores (r2.5 x-axis) — carve a clearance so boxes don't fill them
BORES = [(29.1,), (35.1,), (39.1,)]        # pin y-lines (bore drilled by fingers.py)
BORE_R = 2.5

ref = trimesh.load(str(OUT / "Palm_left_ref.stl"), force="mesh")

xs = np.arange(X0, X1, RES)
ys = np.arange(Y0, Y1, RES)
zs = np.arange(Z0, Z1, RES)
gx, gy, gz = np.meshgrid(xs, ys, zs, indexing="ij")
pts = np.c_[gx.ravel(), gy.ravel(), gz.ravel()]
occ = ref.contains(pts).reshape(len(xs), len(ys), len(zs))
# the real pin bores are already hollow in the reference -> occ is False inside
# them, so the boxes leave them open for free (no manual clearing needed).
print(f"grelha {occ.shape}  ocupadas {occ.sum()} / {occ.size}")

# greedy maximal-box cover
boxes = []
filled = np.zeros_like(occ)
nx, ny, nz = occ.shape
for i in range(nx):
    for j in range(ny):
        for k in range(nz):
            if not occ[i, j, k] or filled[i, j, k]:
                continue
            # grow in x, then y, then z while fully occupied & unfilled
            i1 = i
            while i1 + 1 < nx and occ[i1 + 1, j, k] and not filled[i1 + 1, j, k]:
                i1 += 1
            j1 = j
            while (j1 + 1 < ny and occ[i:i1+1, j1+1, k].all()
                   and not filled[i:i1+1, j1+1, k].any()):
                j1 += 1
            k1 = k
            while (k1 + 1 < nz and occ[i:i1+1, j:j1+1, k1+1].all()
                   and not filled[i:i1+1, j:j1+1, k1+1].any()):
                k1 += 1
            filled[i:i1+1, j:j1+1, k:k1+1] = True
            mn = [round(float(xs[i]), 3), round(float(ys[j]), 3), round(float(zs[k]), 3)]
            sz = [round(float(xs[i1] - xs[i] + RES), 3),
                  round(float(ys[j1] - ys[j] + RES), 3),
                  round(float(zs[k1] - zs[k] + RES), 3)]
            boxes.append([mn, sz])
json.dump(boxes, open(OUT / "finger_boxes.json", "w"))
print(f"{len(boxes)} caixas escritas -> finger_boxes.json")
