"""Author output/Palm_right/plan.json by mirroring the proven Palm_left plan.

MEASUREMENT BASIS: Palm_right is the exact x-mirror of Palm_left (volumes
47731.01 vs 47731.38 mm³ — 8 ppm; centroids (−4.900, 2.187, 18.432) vs
(4.900, 2.186, 18.432); identical bboxes). Every value in the mirrored plan
is therefore a measured value of Palm_right (the mirror of a measurement of
the mirror part). Any deviation from true mirroring will surface in eval.
"""
import json

L = json.load(open("output/Palm_left/plan.json"))


def mirror_node(n):
    if "op" in n:
        return {**n, "children": [mirror_node(c) for c in n["children"]]}
    p = dict(n)
    p["source"] = "x-mirrored from the Palm_left plan: " + p.get("source", "")
    prim = p["prim"]
    if prim == "box":
        if "min" in p:
            mn, sz = p["min"], p["size"]
            p["min"] = [round(-(mn[0] + sz[0]), 6), mn[1], mn[2]]
        else:
            c = p["center"]
            p["center"] = [round(-c[0], 6), c[1], c[2]]
            if "rotate_deg" in p:
                rx, ry, rz = p["rotate_deg"]
                # box is centrally symmetric: mirror of rot(z=t) == rot(z=-t)
                p["rotate_deg"] = [rx, ry, round(-rz, 6)]
    elif prim == "cylinder":
        p["p0"] = [round(-p["p0"][0], 6), p["p0"][1], p["p0"][2]]
        p["p1"] = [round(-p["p1"][0], 6), p["p1"][1], p["p1"][2]]
    elif prim == "sphere":
        c = p["center"]
        p["center"] = [round(-c[0], 6), c[1], c[2]]
    elif prim == "extrude":
        ax = p.get("axis", "z")
        if ax == "y":    # profile (z, x): negate x
            p["profile"] = [[q[0], round(-q[1], 6)] for q in p["profile"]]
        elif ax == "z":  # profile (x, y): negate x
            p["profile"] = [[round(-q[0], 6), q[1]] for q in p["profile"]]
        else:            # axis x: extent along x flips; profile (y, z) unchanged
            p["z0"], p["z1"] = round(-p["z1"], 6), round(-p["z0"], 6)
    return p


body = L["bodies"][0]

if body.get("params") or body.get("modules"):
    # v2/v3 semantic plan: field-level negation is fragile with expressions
    # and shared modules — mirror the WHOLE tree with one transform instead
    # (exactly how a human writes the mirrored part; mirror relationship
    # proven: volume delta 8 ppm, centroids x-negated).
    plan = {"version": 1,
            "source": "models/phoenix_components/Palm_right.step",
            "bodies": [{
                "body_id": 0, "strategy": "csg",
                "notes": "x-mirror of the semantic Palm_left plan (single "
                         "mirror transform; params/modules shared verbatim); "
                         + body.get("notes", ""),
                "params": body.get("params", []),
                "profiles": body.get("profiles", {}),
                "modules": body.get("modules", {}),
                "csg": {"transform": {"mirror": [1, 0, 0]},
                        "name": "mirrored_left_palm",
                        "child": body["csg"]},
            }]}
    json.dump(plan, open("output/Palm_right/plan.json", "w"), indent=1)
    print("wrote output/Palm_right/plan.json (semantic mirror-wrap mode)")
    raise SystemExit(0)
plan = {"version": 1, "source": "models/phoenix_components/Palm_right.step",
        "bodies": [{
            "body_id": 0, "strategy": "csg",
            "notes": "x-mirror of the measured Palm_left plan (exact mirror "
                     "part: volume delta 8 ppm, centroids x-negated); "
                     + body["notes"],
            "csg": mirror_node(body["csg"])}]}
json.dump(plan, open("output/Palm_right/plan.json", "w"), indent=1)
print("wrote output/Palm_right/plan.json")
