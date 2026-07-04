"""step2scad — automated STEP -> parametric OpenSCAD reconstruction pipeline.

Stages (see ARCHITECTURE.md):
    ingest   -> exact B-rep feature extraction (features.json)
    classify -> per-body strategy selection (classification.json)
    emit     -> parametric .scad emission (placeholder emitters for now)
    export   -> render .scad -> STL via OpenSCAD
    eval     -> align + boolean IoU vs tessellated original
"""

__version__ = "0.1.0"
