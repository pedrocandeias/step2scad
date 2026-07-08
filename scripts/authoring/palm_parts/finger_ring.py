"""Ring finger knuckle. Prongs x-17.1/-7.1, knuckle y35.1, bore r2.5/r3.25.
Refine here: round vs flat termination, hole shape (round/slot), fork width."""
from palm_parts.fingerlib import build_clevis

def build():
    return [build_clevis(-12.1, 35.1, "ring", kn_r=6.0, kn_hw=7.0,
                         tip="round", bore="round", bore_r=2.5)], []
