"""Index finger knuckle. Prongs x6.5/16.2, knuckle y39.1, bore r2.5.
Refine here: round vs flat termination, hole shape (round/slot), fork width."""
from palm_parts.fingerlib import build_clevis

def build():
    return [build_clevis(11.3, 39.1, "index", kn_r=6.0, kn_hw=7.0,
                         tip="round", bore="round", bore_r=2.5)], []
