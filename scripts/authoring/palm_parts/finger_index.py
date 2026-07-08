"""Index finger knuckle (the most +X finger, near the thumb).

MEASURED (features.json): ROUND r6 crown #350 at (x16.2, y39.1, z10.6) with a
ROUND r2.5 pin bore #338 (x6.5) / #219,#220 (x17). Front-view render + ghost
confirm a semicircular crown (not a flat termination) and a round hole — so
the index keeps tip="round", bore="round" (the author's flat/non-round
knuckles are the other fingers). Fork centre x11.35 = midpoint of the two
prong faces (bore x6.5 <-> crown x16.2); half-width 6.5 spans that pair.
"""
from palm_parts.fingerlib import build_clevis


def build():
    return [build_clevis(11.35, 39.1, "index", kn_z=10.62, kn_r=6.0,
                         kn_hw=6.5, tip="round", bore="round", bore_r=2.5)], []
