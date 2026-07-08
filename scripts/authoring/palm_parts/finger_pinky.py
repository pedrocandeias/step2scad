"""Pinky finger knuckle. Prongs x-31.1/-21.1, knuckle y29.1, bore r2.5.
Refine here: round vs flat termination, hole shape (round/slot), fork width."""
from palm_parts.fingerlib import build_clevis

def build():
    return [build_clevis(-26.1, 29.1, "pinky", kn_r=6.0, kn_hw=7.0,
                         tip="round", bore="round", bore_r=2.5)], []
