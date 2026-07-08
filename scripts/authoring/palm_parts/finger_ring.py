"""Ring finger knuckle. Prongs x-17.1/-7.1, knuckle y35.1 z10.6.

Measured (features.json + ref sections): the ring hole is ROUND (r2.5 bore
#286) and the knuckle terminates ROUND (r6 crowns #462/#465) — no flat/slot
here (those are other fingers). The prong plates rise to z~22.5 (merging into
the dome/vault, hidden for now), so the projecting clevis is the round crown +
bore at the pin. Added the measured r3.25 pin-head counterbores (#249/#318).
"""
from palm_parts.common import cyl
from palm_parts.fingerlib import build_clevis

CX, KY, KN_Z, KN_HW = -12.1, 35.1, 10.62, 7.0
CB_R, CB_D = 3.25, 1.6   # pin-head counterbore (faces #249/#318)


def build():
    add = [build_clevis(CX, KY, "ring", kn_z=KN_Z, kn_r=6.0, kn_hw=KN_HW,
                        tip="round", bore="round", bore_r=2.5)]
    # r3.25 counterbores recessing the pin head on each prong's outer face
    cut = [
        cyl("ring_cbore_L", (CX - KN_HW, KY, KN_Z),
            (CX - KN_HW + CB_D, KY, KN_Z), CB_R,
            "ring pin-head counterbore L: exact r3.25 (#249/#318)"),
        cyl("ring_cbore_R", (CX + KN_HW, KY, KN_Z),
            (CX + KN_HW - CB_D, KY, KN_Z), CB_R,
            "ring pin-head counterbore R: exact r3.25 (#249/#318)"),
    ]
    return add, cut
