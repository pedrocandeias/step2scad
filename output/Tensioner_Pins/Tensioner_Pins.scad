// Tensioner_Pins — step2scad parametric reconstruction
// source: models/phoenix_components/Tensioner_Pins.step
// rotate_extrude bodies: exact RZ profile from the B-rep coaxial faces;
// csg / instance_of bodies: agent-authored measured plan (plan.json);
// strategies without a real emitter yet use placeholder stubs (bbox).
// Every dimension below is an exact B-rep value from features.json.

// ---- body 0 (strategy: csg — agent plan) ----
// plan: chamfered bar = intersection of three measured octagonal prisms; minus tendon slot (prismatic in x, raycast-measured conic walls); minus blind tendon bore (exact cylinder+cap)
b0_xsec_profile = [[0.659863, 2.099167], [0.938279, 2.377583], [5.136614, 2.377583], [5.413925, 2.099167], [5.413925, -2.099168], [5.136614, -2.377583], [0.938279, -2.377583], [0.659863, -2.099168]];  // (z, x) points — XZ octagon: exact plane faces 0/31 (walls x=±2.377583), 15 (top z=5.413925), 24 (bottom z=0.659863), 13/25 (45° bottom chamfers), 14/30 (top chamfers); vertices = plane-pair intersections
b0_xsec_z0 = -16.559241;  // extent along y
b0_xsec_z1 = 16.559241;
b0_plan_xy_profile = [[2.377583, 16.117311], [1.935653, 16.559241], [-1.935653, 16.559241], [-2.377583, 16.117311], [-2.377583, -16.117311], [-1.935653, -16.559241], [1.935653, -16.559241], [2.377583, -16.117311]];  // (x, y) points — XY octagon: exact plane faces 0/31, 16/23 (ends y=±16.559241), 4/7/26/28 (45° corner chamfers)
b0_plan_xy_z0 = 0;  // extent along z
b0_plan_xy_z1 = 6;
b0_side_yz_profile = [[16.117311, 0.659863], [16.559241, 1.101793], [16.559241, 4.971995], [16.117311, 5.413925], [-16.117311, 5.413925], [-16.559241, 4.971995], [-16.559241, 1.101793], [-16.117311, 0.659863]];  // (y, z) points — YZ octagon: exact plane faces 16/23, 15, 24, 17/20 (top end chamfers), 18/21 (bottom end chamfers)
b0_side_yz_z0 = -2.5;  // extent along x
b0_side_yz_z1 = 2.5;
b0_slot_profile = [[-14.722041, 0.3], [-14.348953, 0.7], [-14.069137, 1], [-13.751725, 1.4], [-13.501885, 1.8], [-13.318744, 2.2], [-13.197268, 2.6], [-13.141806, 3], [-13.137367, 3.2], [-13.150415, 3.4], [-13.21782, 3.8], [-13.352434, 4.2], [-13.551634, 4.6], [-13.814756, 5], [-14.060239, 5.3], [-14.147448, 5.4], [-14.496284, 5.8], [-10.702936, 5.8], [-10.557256, 5.4], [-10.520836, 5.3], [-10.416808, 5], [-10.299863, 4.6], [-10.216109, 4.2], [-10.159263, 3.8], [-10.123424, 3.4], [-10.122524, 3.2], [-10.12681, 3], [-10.146129, 2.6], [-10.200298, 2.2], [-10.281356, 1.8], [-10.384704, 1.4], [-10.530743, 1], [-10.646316, 0.7], [-10.800413, 0.3]];  // (y, z) points — tendon slot between bspline faces 11/12: wall y(z) raycast-measured at x=0 (prismatic: <0.003mm variation across x); x span = exact plane faces 9/10 (x=±1.455185); z overshoot 0.3/5.8 extrapolates the last measured segment
b0_slot_z0 = -1.455185;  // extent along x
b0_slot_z1 = 1.455184;
b0_bore_p0 = [0, -8.770356, 3.037447];  // blind tendon bore: exact cylinder face 2 (r=1.507237, axis [0,-1,0] through x=0 z=3.037447) + planar cap face 1 at y=-8.770356; +y end overshoots the exit face 16 by ~1mm
b0_bore_p1 = [0, 17.559241, 3.037447];
b0_bore_r  = 1.507237;
b0_fn = 96;  // curve resolution

module body_0() {
    difference() {
        intersection() {
            // xsec: XZ octagon: exact plane faces 0/31 (walls x=±2.377583), 15 (top z=5.413925), 24 (bottom z=0.659863), 13/25 (45° bottom chamfers), 14/30 (top chamfers); vertices = plane-pair intersections
            rotate([0, -90, -90]) translate([0, 0, b0_xsec_z0]) linear_extrude(b0_xsec_z1 - b0_xsec_z0) polygon(b0_xsec_profile);
            // plan_xy: XY octagon: exact plane faces 0/31, 16/23 (ends y=±16.559241), 4/7/26/28 (45° corner chamfers)
            translate([0, 0, b0_plan_xy_z0]) linear_extrude(b0_plan_xy_z1 - b0_plan_xy_z0) polygon(b0_plan_xy_profile);
            // side_yz: YZ octagon: exact plane faces 16/23, 15, 24, 17/20 (top end chamfers), 18/21 (bottom end chamfers)
            rotate([90, 0, 90]) translate([0, 0, b0_side_yz_z0]) linear_extrude(b0_side_yz_z1 - b0_side_yz_z0) polygon(b0_side_yz_profile);
        }
        // slot: tendon slot between bspline faces 11/12: wall y(z) raycast-measured at x=0 (prismatic: <0.003mm variation across x); x span = exact plane faces 9/10 (x=±1.455185); z overshoot 0.3/5.8 extrapolates the last measured segment
        rotate([90, 0, 90]) translate([0, 0, b0_slot_z0]) linear_extrude(b0_slot_z1 - b0_slot_z0) polygon(b0_slot_profile);
        // bore: blind tendon bore: exact cylinder face 2 (r=1.507237, axis [0,-1,0] through x=0 z=3.037447) + planar cap face 1 at y=-8.770356; +y end overshoots the exit face 16 by ~1mm
        translate(b0_bore_p0) rotate(a=90, v=[-1, 0, 0]) cylinder(h=norm(b0_bore_p1 - b0_bore_p0), r=b0_bore_r, $fn=b0_fn);
    }
}

// ---- body 1 (strategy: instance_of body 0 — agent plan) ----
b1_offset = [5.8765, 0, 0];  // exact centroid delta body1-body0 (identical volume/faces)

module body_1() {
    translate(b1_offset) body_0();
}

// ---- body 2 (strategy: instance_of body 0 — agent plan) ----
b2_offset = [-5.8765, 0, 0];  // exact centroid delta body2-body0 (identical volume/faces)

module body_2() {
    translate(b2_offset) body_0();
}

// full part = union of all bodies
body_0();
body_1();
body_2();
