"""Middle finger knuckle. Prongs x-7.9/1.7 (r6 crowns #277/#337), knuckle
y39.1, round bore r2.5 (#228). Projects furthest forward (crown front y45.1).

MEASURED & CONFIRMED against the reference (ghost-verified):
  - termination is ROUND: the crown fronts reach exactly y39.1+6 = 45.1
    (a full r6 arc, not truncated) — the crowns are B-rep cylinder faces.
  - hole is ROUND: orthogonal gaps at the bore are Δy=4.99 == Δz=4.99
    (a true r2.5 circle, NOT a slot).
So this knuckle stays round/round; the flat-terminated and non-round-hole
knuckles the author noted are on the other fingers.
"""
from palm_parts.fingerlib import build_clevis


def build():
    return [build_clevis(-3.1, 39.1, "middle", kn_r=6.0, kn_hw=7.0,
                         tip="round", bore="round", bore_r=2.5)], []
