"""Finger knuckles (garras) — EXACT comb reconstruction (no loft, no stairs).

Measured structure (x-normal wall planes): the finger region is 5 TINE-WALLS
alternating with 4 SLOTS — the tines are SHARED between adjacent fingers, and
each finger's proximal piece pins into one slot between two tines. So this is
one comb (5 tines + a rounded r6 crown on each tine at each pin + the r2.5 pin
bores), NOT 4 independent forks. Tine x-ranges from the exact +X/-X plane
pairs (#468/#467, #637/#673, #459/#458, #452/#451, #824/#522); crowns r6
(#623/#441/#465/#462/#337/#350...); bores r2.5 at z10.6.

The old per-finger modules (finger_pinky/ring/middle/index) are superseded by
this comb and are no longer imported.
"""
from palm_parts.common import Z_DECK, box, cyl

# 5 tine-walls (x0, x1) from the exact +X/-X wall-plane pairs
TINES = [(-35.3, -31.5), (-25.5, -17.5), (-11.5, -3.5), (2.5, 10.5), (16.5, 20.0)]
# 4 fingers: (left tine idx, right tine idx, pin y) — the slot between them
FINGERS = [(0, 1, 29.1, "pinky"), (1, 2, 35.1, "ring"),
           (2, 3, 39.1, "middle"), (3, 4, 39.1, "index")]
Y_BACK = 27.0          # tines root into the body here
Z_TOP = 15.0           # measured wall-top (planes #459 z15.1 / #452 z14.9)
KN_Z, KN_R, BORE_R = 10.62, 6.0, 2.5


def build():
    # per-tine front reach = its serving fingers' furthest pin + crown radius
    y_front = [Y_BACK] * len(TINES)
    for li, ri, py, _ in FINGERS:
        y_front[li] = max(y_front[li], py + KN_R)
        y_front[ri] = max(y_front[ri], py + KN_R)

    add = []
    for i, (x0, x1) in enumerate(TINES):
        add.append(box(f"tine{i}", (x0, Y_BACK, Z_DECK),
                       (x1 - x0, y_front[i] - Y_BACK, Z_TOP - Z_DECK),
                       f"finger tine {i}: exact wall x[{x0:.1f},{x1:.1f}] "
                       "(from the +X/-X plane pair) deck->z15"))
    # rounded r6 crowns on each flanking tine at each pin + the pin bore
    cut = []
    for li, ri, py, nm in FINGERS:
        xl0, xl1 = TINES[li]
        xr0, xr1 = TINES[ri]
        add.append(cyl(f"crown_{nm}_L", (xl0, py, KN_Z), (xl1, py, KN_Z), KN_R,
                       f"{nm} crown on left tine: exact r6 x-axis at y{py:.0f}"))
        add.append(cyl(f"crown_{nm}_R", (xr0, py, KN_Z), (xr1, py, KN_Z), KN_R,
                       f"{nm} crown on right tine: exact r6 x-axis at y{py:.0f}"))
        cut.append(cyl(f"bore_{nm}", (xl0 - 1, py, KN_Z), (xr1 + 1, py, KN_Z),
                       BORE_R, f"{nm} pin bore: exact r2.5 x-axis"))
    return add, cut
