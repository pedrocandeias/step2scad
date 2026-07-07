// ====================================================================
// Proximals — step2scad parametric reconstruction
// source: models/phoenix_components/Proximals.step
// Every dimension is measured from the STEP B-rep (exact faces) or a
// fitted law with its residual cited — see the source comment on each
// parameter. Edit named parameters; geometry follows.
// ====================================================================

// --- Display options ---
show_colors   = true;    // tint top-level features (preview aid)
show_original = false;   // ghost the original tessellation overlay
original_stl  = "Proximals_ref.stl";
module tint(c) { if (show_colors) color(c) children(); else children(); }

// ---- body 0 (strategy: instance_of body 3 — agent plan) ----
b0_offset = [13.747466, 0.001308, 0.000444];  // exact centroid delta body0-body3 (volumes match within 0.31 mm³ = 0.012%)

module body_0() {
    translate(b0_offset) body_3();
}

// ---- body 1 (strategy: instance_of body 3 — agent plan) ----
b1_offset = [-13.747333, -0.000015, -0.000004];  // exact centroid delta body1-body3 (volumes match within 0.31 mm³ = 0.012%)

module body_1() {
    translate(b1_offset) body_3();
}

// --------------------------------------------------------------------
// BODY 2 — semantic parametric plan
//   semantic laws: beam = exact wall window × envelope laws (top res
//   0.090, bottom res 0.092; knuckle lobes are r6 arcs concentric with
//   the exact pin bores); ridge stem/cap = window × fitted laws; crown
//   kept as measured loft (no clean law); recess/web profiles
//   vectorized | crown REPLACED by law-solids (template-style): hull
//   of vectorized control slabs INTERSECT measured ceiling arc MINUS
//   measured underside scoops — every law fitted with residual cited
// --------------------------------------------------------------------

// ======== PARAMETERS (every value measured; sources cited) ========
// --- b2 ---
b2_beam_wall_x0     = -30.00011;  // beam side-wall plane (median of 230 station footprints; end roundings in x are absorbed)
b2_beam_wall_x1     = -24.80011;  // beam side-wall plane (median of 230 station footprints)
b2_knuckle_palm_y   = -11.42562;  // exact pin-bore axis y, face #61 (lobe arc fit agrees within 0.1)
b2_knuckle_palm_z   = 6.008731;  // exact pin-bore axis z, face #61
b2_knuckle_lobe_r   = 6;  // outer radius of both knuckle lobes (arc fits r=6.000 / r=5.997, res 0.002/0.003 -> nominal 6.0)
b2_knuckle_distal_y = 11.57438;  // exact pin-bore axis y, face #23
b2_knuckle_distal_z = 6.008731;  // exact pin-bore axis z, face #23
b2_tendon_tunnel_r  = 1.125;  // exact tendon-tunnel bore radius — tendon tunnel: exact full-circle cylinder face #26
b2_pin_palm_r       = 2.3;  // exact palm pin-bore radius — knuckle pin bore: exact cylinder face #61
b2_pin_distal_r     = 2.375;  // exact distal pin-bore radius — knuckle pin bore: exact cylinder face #23
b2_dome_r           = 36.2208;  // lengthwise ceiling arc radius (fit over 60 stations, res 0.267)
b2_dome_cy          = 4.903342;  // ceiling arc center y (same fit)
b2_dome_cz          = 50.225417;  // ceiling arc center z — ABOVE the part: the ceiling is the circle's lower branch
b2_scoop_rear_r     = 8.43581;  // rear underside scoop cylinder (x-axis) radius: circle fit to the wing shelf heights, res 0.011
b2_scoop_rear_cy    = -12.520848;  // rear scoop center y (same fit)
b2_scoop_rear_cz    = 5.819099;  // rear scoop center z (same fit)
b2_scoop_front_r    = 7.422916;  // front underside scoop radius, res 0.017 — nearly exact circle
b2_scoop_front_cy   = 11.778239;  // front scoop center y (same fit)
b2_scoop_front_cz   = 5.886084;  // front scoop center z (same fit)
b2_fn               = 96;  // curve resolution

module body_2() {
    difference() {
        union() {
            difference() {
                intersection() {
                    // b2_beam_bar: beam bar between the side-wall planes; z spans are generous — the envelope laws below do the shaping
                    translate([b2_beam_wall_x0, -17.316, -0.2]) cube([b2_beam_wall_x1 - b2_beam_wall_x0, 34.85, 17.69761]);
                    union() {
                        // b2_beam_top_00: knuckle lobe: r6 arc CONCENTRIC with the exact pin bore face #61 (fit res 0.002)
                        intersection() {
                            translate([-30.50011, -17.366, -0.5]) cube([6.2, 5.9, (17.49761) - (-0.5)]);
                            union() {
                                translate([(-30.50011) - 1, b2_knuckle_palm_y, b2_knuckle_palm_z]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = b2_knuckle_lobe_r, $fn = 4*b2_fn);
                                translate([-500, -500, (b2_knuckle_palm_z) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b2_beam_top_01: fitted arc law (upper branch, res 0.090)
                        intersection() {
                            translate([-30.50011, -11.566, -0.5]) cube([6.2, 1.9, (17.49761) - (-0.5)]);
                            union() {
                                translate([(-30.50011) - 1, -10.013501, 14.381364]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 2.800437, $fn = 4*b2_fn);
                                translate([-500, -500, (14.381364) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b2_beam_top_02: fitted arc law (upper branch, res 0.026)
                        intersection() {
                            translate([-30.50011, -9.766, -0.5]) cube([6.2, 2.2, (17.49761) - (-0.5)]);
                            union() {
                                translate([(-30.50011) - 1, -13.413162, 3.661088]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 13.902212, $fn = 4*b2_fn);
                                translate([-500, -500, (3.661088) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b2_beam_top_03: fitted line law m=-0.3946 (res 0.086)
                        intersection() {
                            translate([-30.50011, -7.666, -0.5]) cube([6.2, 3.55, (17.49761) - (-0.5)]);
                            translate([0, 0, 13.348022]) rotate([atan(-0.394585), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        difference() {
                            // b2_beam_top_04_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.057)
                            translate([-30.80011, -4.216, -1.5]) cube([6.8, 5.5, 51.515964]);
                            // b2_beam_top_04_lobe: fitted arc law (lower branch, res 0.057)
                            translate([-30.90011, 2.744606, 50.015964]) rotate(a=90, v=[0, 1, 0]) cylinder(h=7, r=35.727038, $fn=b2_fn);
                        }
                        difference() {
                            // b2_beam_top_05_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.062)
                            translate([-30.80011, 1.184, -1.5]) cube([6.8, 2.5, 20.971026]);
                            // b2_beam_top_05_lobe: fitted arc law (lower branch, res 0.062)
                            translate([-30.90011, 2.715539, 19.471026]) rotate(a=90, v=[0, 1, 0]) cylinder(h=7, r=5.379894, $fn=b2_fn);
                        }
                        // b2_beam_top_06: fitted arc law (upper branch, res 0.070)
                        intersection() {
                            translate([-30.50011, 3.584, -0.5]) cube([6.2, 3.7, (17.49761) - (-0.5)]);
                            union() {
                                translate([(-30.50011) - 1, 4.466576, 5.044184]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 9.046042, $fn = 4*b2_fn);
                                translate([-500, -500, (5.044184) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b2_beam_top_07: fitted line law m=-3.7143 (res 0.000)
                        intersection() {
                            translate([-30.50011, 7.184, -0.5]) cube([6.2, 0.45, (17.49761) - (-0.5)]);
                            translate([0, 0, 40.527873]) rotate([atan(-3.714286), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        difference() {
                            // b2_beam_top_08_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.088)
                            translate([-30.80011, 7.534, -1.5]) cube([6.8, 1.6, 13.128971]);
                            // b2_beam_top_08_lobe: fitted arc law (lower branch, res 0.088)
                            translate([-30.90011, 8.564225, 11.628971]) rotate(a=90, v=[0, 1, 0]) cylinder(h=7, r=1.223838, $fn=b2_fn);
                        }
                        // b2_beam_top_09: fitted line law m=-0.1284 (res 0.049)
                        intersection() {
                            translate([-30.50011, 9.034, -0.5]) cube([6.2, 4.9, (17.49761) - (-0.5)]);
                            translate([0, 0, 11.589005]) rotate([atan(-0.128367), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        // b2_beam_top_10: fitted arc law (upper branch, res 0.072)
                        intersection() {
                            translate([-30.50011, 13.834, -0.5]) cube([6.2, 1, (17.49761) - (-0.5)]);
                            union() {
                                translate([(-30.50011) - 1, 14.293655, 9.460186]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 0.529849, $fn = 4*b2_fn);
                                translate([-500, -500, (9.460186) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b2_beam_top_11: fitted arc law (upper branch, res 0.079)
                        intersection() {
                            translate([-30.50011, 14.734, -0.5]) cube([6.2, 2.85, (17.49761) - (-0.5)]);
                            union() {
                                translate([(-30.50011) - 1, 15.530461, 7.866499]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 2.03039, $fn = 4*b2_fn);
                                translate([-500, -500, (7.866499) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                    }
                }
                difference() {
                    // b2_beam_under_00_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.092)
                    translate([-30.30011, -17.366, -0.99127]) cube([5.8, 7.4, 7.202864]);
                    // b2_beam_under_00_lobe: fitted arc law (lower branch, res 0.092)
                    translate([-30.40011, -11.308106, 6.211594]) rotate(a=90, v=[0, 1, 0]) cylinder(h=6, r=6.244125, $fn=b2_fn);
                }
                // b2_beam_under_01: underside carve: fitted arc law (upper branch, res 0.068)
                intersection() {
                    translate([-30.30011, -10.066, -0.99127]) cube([5.8, 1.3, (17.49761) - (-0.99127)]);
                    union() {
                        translate([(-30.30011) - 1, -9.398225, -1.538928]) rotate([0, 90, 0]) cylinder(h = (5.8) + 2, r = 1.598359, $fn = 4*b2_fn);
                        translate([-500, -500, (-1.538928) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b2_beam_under_02: underside carve: fitted arc law (upper branch, res 0.086)
                intersection() {
                    translate([-30.30011, -8.866, -0.99127]) cube([5.8, 1.3, (17.49761) - (-0.99127)]);
                    union() {
                        translate([(-30.30011) - 1, -8.198225, -1.170359]) rotate([0, 90, 0]) cylinder(h = (5.8) + 2, r = 1.244893, $fn = 4*b2_fn);
                        translate([-500, -500, (-1.170359) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b2_beam_under_03: underside carve: fitted line law m=0.0010 (res 0.082)
                intersection() {
                    translate([-30.30011, -7.666, -0.99127]) cube([5.8, 20.4, (17.49761) - (-0.99127)]);
                    translate([0, 0, 0.008802]) rotate([atan(0.000975), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                difference() {
                    // b2_beam_under_04_below: region below the lower-branch arc envelope — knuckle lobe: r6 arc CONCENTRIC with the exact pin bore face #23 (fit res 0.003)
                    translate([-30.30011, 12.634, -0.99127]) cube([5.8, 4.95, 7.001566]);
                    // b2_beam_under_04_lobe: knuckle lobe: r6 arc CONCENTRIC with the exact pin bore face #23 (fit res 0.003)
                    translate([-30.40011, b2_knuckle_distal_y, b2_knuckle_distal_z]) rotate([0, 90, 0]) cylinder(h=6, r=b2_knuckle_lobe_r, $fn=b2_fn);
                }
            }
            difference() {
                intersection() {
                    // b2_ridge_stem_bar: ridge_stem wall window x=[-28.72011,-26.08011] (median of 46 stations)
                    translate([-28.72011, 8.789, 7.73864]) cube([2.64, 9.2, 6.93795]);
                    union() {
                        // b2_ridge_stem_top_00: fitted line law m=-0.1288 (res 0.000)
                        intersection() {
                            translate([-29.02011, 8.739, 7.53864]) cube([3.24, 0.5, (14.67659) - (7.53864)]);
                            translate([0, 0, 11.641863]) rotate([atan(-0.128825), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        // b2_ridge_stem_top_01: fitted line law m=8.7785 (res 0.000)
                        intersection() {
                            translate([-29.02011, 9.139, 7.53864]) cube([3.24, 0.5, (14.67659) - (7.53864)]);
                            translate([0, 0, -70.207776]) rotate([atan(8.778525), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        // b2_ridge_stem_top_02: fitted arc law (upper branch, res 0.097)
                        intersection() {
                            translate([-29.02011, 9.539, 7.53864]) cube([3.24, 1.7, (14.67659) - (7.53864)]);
                            union() {
                                translate([(-29.02011) - 1, 10.408173, 13.567255]) rotate([0, 90, 0]) cylinder(h = (3.24) + 2, r = 0.91479, $fn = 4*b2_fn);
                                translate([-500, -500, (13.567255) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b2_ridge_stem_top_03: fitted line law m=-0.2501 (res 0.000)
                        intersection() {
                            translate([-29.02011, 11.139, 7.53864]) cube([3.24, 6.9, (14.67659) - (7.53864)]);
                            translate([0, 0, 16.989738]) rotate([atan(-0.25009), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                    }
                }
                // b2_ridge_stem_under_00: underside carve: fitted line law m=-0.1336 (res 0.071)
                intersection() {
                    translate([-29.02011, 8.739, 6.73864]) cube([3.24, 6.9, (14.67659) - (6.73864)]);
                    translate([0, 0, 11.666489]) rotate([atan(-0.133627), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b2_ridge_stem_under_01: underside carve: fitted arc law (upper branch, res 0.001)
                intersection() {
                    translate([-29.02011, 15.539, 6.73864]) cube([3.24, 1.7, (14.67659) - (6.73864)]);
                    union() {
                        translate([(-29.02011) - 1, 14.500238, 6.725418]) rotate([0, 90, 0]) cylinder(h = (3.24) + 2, r = 2.99217, $fn = 4*b2_fn);
                        translate([-500, -500, (6.725418) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b2_ridge_stem_under_02: underside carve: fitted line law m=5.9809 (res 0.000)
                intersection() {
                    translate([-29.02011, 17.139, 6.73864]) cube([3.24, 0.5, (14.67659) - (6.73864)]);
                    translate([0, 0, -94.76662]) rotate([atan(5.980875), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b2_ridge_stem_under_03: underside carve: fitted line law m=2.9212 (res 0.000)
                intersection() {
                    translate([-29.02011, 17.539, 6.73864]) cube([3.24, 0.5, (14.67659) - (6.73864)]);
                    translate([0, 0, -40.949557]) rotate([atan(2.921175), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
            }
            difference() {
                intersection() {
                    // b2_ridge_cap_bar: ridge_cap wall window x=[-28.90011,-25.90013] (median of 42 stations)
                    translate([-28.90011, 7.589, 10.19416]) cube([2.99998, 9.6, 4.39739]);
                    union() {
                        difference() {
                            // b2_ridge_cap_top_00_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.043)
                            translate([-29.50011, 7.539, 8.99416]) cube([4.19998, 1.7, 3.385833]);
                            // b2_ridge_cap_top_00_lobe: fitted arc law (lower branch, res 0.043)
                            translate([-29.60011, 8.826614, 12.379993]) rotate(a=90, v=[0, 1, 0]) cylinder(h=4.39998, r=1.913733, $fn=b2_fn);
                        }
                        // b2_ridge_cap_top_01: fitted arc law (upper branch, res 0.078)
                        intersection() {
                            translate([-29.20011, 9.139, 9.99416]) cube([3.59998, 2.9, (14.59155) - (9.99416)]);
                            union() {
                                translate([(-29.20011) - 1, 10.669215, 12.113069]) rotate([0, 90, 0]) cylinder(h = (3.59998) + 2, r = 2.220359, $fn = 4*b2_fn);
                                translate([-500, -500, (12.113069) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b2_ridge_cap_top_02: fitted line law m=-0.2501 (res 0.000)
                        intersection() {
                            translate([-29.20011, 11.939, 9.99416]) cube([3.59998, 5.3, (14.59155) - (9.99416)]);
                            translate([0, 0, 16.989739]) rotate([atan(-0.25009), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                    }
                }
                difference() {
                    // b2_ridge_cap_under_00_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.062)
                    translate([-29.20011, 7.539, 9.19416]) cube([3.59998, 1.7, 2.467206]);
                    // b2_ridge_cap_under_00_lobe: fitted arc law (lower branch, res 0.062)
                    translate([-29.30011, 8.692543, 11.661366]) rotate(a=90, v=[0, 1, 0]) cylinder(h=3.79998, r=1.218668, $fn=b2_fn);
                }
                // b2_ridge_cap_under_01: underside carve: fitted arc law (upper branch, res 0.097)
                intersection() {
                    translate([-29.20011, 9.139, 9.19416]) cube([3.59998, 2.9, (14.59155) - (9.19416)]);
                    union() {
                        translate([(-29.20011) - 1, 10.777553, 11.437284]) rotate([0, 90, 0]) cylinder(h = (3.59998) + 2, r = 1.846088, $fn = 4*b2_fn);
                        translate([-500, -500, (11.437284) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b2_ridge_cap_under_02: underside carve: fitted line law m=-0.2336 (res 0.085)
                intersection() {
                    translate([-29.20011, 11.939, 9.19416]) cube([3.59998, 5.3, (14.59155) - (9.19416)]);
                    translate([0, 0, 15.746556]) rotate([atan(-0.233604), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
            }
            union() {
                difference() {
                    intersection() {
                        hull() {
                            // b2_crown_ctrl_0: parametric CONTROL section at y=-7.342 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -7.342]) linear_extrude(0.02) polygon(concat(
            [[12.484854, -19.675002]],
            [for (k = [1 : 10]) [(11.531863) + (3.304442)*cos((73.230136) + k*((18.636063) - (73.230136))/10), (-22.837472) + (3.304442)*sin((73.230136) + k*((18.636063) - (73.230136))/10)]],
            [[16.193878, -26.079349]],
            [[16.195059, -26.555189]],
            [[16.200423, -28.717221]],
            [[14.705251, -32.694211]],
            [for (k = [1 : 9]) [(11.138146) + (3.674411)*cos((-14.944106) + k*((-68.450559) - (-14.944106))/9), (-31.742136) + (3.674411)*sin((-14.944106) + k*((-68.450559) - (-14.944106))/9)]],
            [[0.008731, -30.000107]],
            [[0.008731, -24.800108]]));
                            // b2_crown_ctrl_1: parametric CONTROL section at y=-6.542 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -6.542]) linear_extrude(0.02) polygon(concat(
            [[11.774502, -19.561359]],
            [for (k = [1 : 12]) [(11.206703) + (3.604558)*cos((80.96635) + k*((13.332834) - (80.96635))/12), (-23.132722) + (3.604558)*sin((80.96635) + k*((13.332834) - (80.96635))/12)]],
            [[15.902784, -26.079126]],
            [[15.906295, -27.494015]],
            [[15.90933, -28.717185]],
            [[14.654956, -32.47854]],
            [for (k = [1 : 11]) [(10.907793) + (3.847313)*cos((-13.997703) + k*((-76.988914) - (-13.997703))/11), (-31.544427) + (3.847313)*sin((-13.997703) + k*((-76.988914) - (-13.997703))/11)]],
            [[0.008731, -30.000107]],
            [[0.008731, -24.800108]]));
                            // b2_crown_ctrl_2: parametric CONTROL section at y=-5.342 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -5.342]) linear_extrude(0.02) polygon(concat(
            [[10.255542, -19.404869]],
            [[10.310864, -19.410407]],
            [[11.458337, -19.594475]],
            [for (k = [1 : 13]) [(10.918066) + (3.768969)*cos((81.800817) + k*((9.735263) - (81.800817))/13), (-23.344075) + (3.768969)*sin((81.800817) + k*((9.735263) - (81.800817))/13)]],
            [[14.843613, -23.4623]],
            [[14.847116, -23.476724]],
            [for (k = [1 : 5]) [(3.939716) + (11.600873)*cos((19.911076) + k*((-6.235221) - (19.911076))/5), (-27.427532) + (11.600873)*sin((19.911076) + k*((-6.235221) - (19.911076))/5)]],
            [[14.595231, -32.079622]],
            [for (k = [1 : 14]) [(10.424482) + (4.256861)*cos((-12.311525) + k*((-92.360771) - (-12.311525))/14), (-31.169373) + (4.256861)*sin((-12.311525) + k*((-92.360771) - (-12.311525))/14)]],
            [[0.008731, -30.000107]],
            [[0.008731, -24.800108]]));
                            // b2_crown_ctrl_3: parametric CONTROL section at y=-4.542 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -4.542]) linear_extrude(0.02) polygon(concat(
            [[8.563751, -19.284379]],
            [for (k = [1 : 3]) [(8.325009) + (12.171059)*cos((88.876485) + k*((71.29637) - (88.876485))/3), (-31.457903) + (12.171059)*sin((88.876485) + k*((71.29637) - (88.876485))/3)]],
            [for (k = [1 : 11]) [(10.823982) + (3.769931)*cos((68.078606) + k*((7.6967) - (68.078606))/11), (-23.418935) + (3.769931)*sin((68.078606) + k*((7.6967) - (68.078606))/11)]],
            [for (k = [1 : 3]) [(-3.594839) + (18.720212)*cos((13.596167) + k*((0.559471) - (13.596167))/3), (-27.308487) + (18.720212)*sin((13.596167) + k*((0.559471) - (13.596167))/3)]],
            [[15.134073, -27.536711]],
            [[15.134073, -27.625199]],
            [[14.882213, -30.000107]],
            [[14.879679, -30.019105]],
            [for (k = [1 : 8]) [(8.433055) + (6.400777)*cos((-0.153239) + k*((-44.394742) - (-0.153239))/8), (-30.001863) + (6.400777)*sin((-0.153239) + k*((-44.394742) - (-0.153239))/8)]],
            [for (k = [1 : 6]) [(9.601353) + (6.230176)*cos((-57.120656) + k*((-91.400404) - (-57.120656))/6), (-29.229184) + (6.230176)*sin((-57.120656) + k*((-91.400404) - (-57.120656))/6)]],
            [[8.780253, -35.526663]],
            [[8.562229, -35.526177]],
            [[0.008731, -30.000107]],
            [[0.008731, -24.800108]]));
                            // b2_crown_ctrl_4: parametric CONTROL section at y=-4.142 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -4.142]) linear_extrude(0.02) polygon(concat(
            [[0.008731, -24.800108]],
            [[6.743132, -19.296661]],
            [for (k = [1 : 5]) [(7.974732) + (12.538046)*cos((95.625535) + k*((67.834223) - (95.625535))/5), (-31.800113) + (12.538046)*sin((95.625535) + k*((67.834223) - (95.625535))/5)]],
            [for (k = [1 : 9]) [(9.72974) + (5.035127)*cos((53.508023) + k*((1.541029) - (53.508023))/9), (-24.218792) + (5.035127)*sin((53.508023) + k*((1.541029) - (53.508023))/9)]],
            [[14.870431, -24.652056]],
            [[14.895007, -24.847565]],
            [[14.834205, -29.952688]],
            [for (k = [1 : 8]) [(8.51349) + (6.275819)*cos((0.292613) + k*((-46.501948) - (0.292613))/8), (-29.984968) + (6.275819)*sin((0.292613) + k*((-46.501948) - (0.292613))/8)]],
            [for (k = [1 : 5]) [(9.351625) + (6.821419)*cos((-59.54928) + k*((-89.111187) - (-59.54928))/5), (-28.633851) + (6.821419)*sin((-59.54928) + k*((-89.111187) - (-59.54928))/5)]],
            [for (k = [1 : 3]) [(8.376286) + (13.30187)*cos((-85.336207) + k*((-96.740711) - (-85.336207))/3), (-22.214725) + (13.30187)*sin((-85.336207) + k*((-96.740711) - (-85.336207))/3)]],
            [[0.008731, -30.000107]]));
                            // b2_crown_ctrl_5: parametric CONTROL section at y=-3.742 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -3.742]) linear_extrude(0.02) polygon(concat(
            [for (k = [1 : 3]) [(5.969654) + (10.315122)*cos((108.352478) + k*((95.428662) - (108.352478))/3), (-29.705685) + (10.315122)*sin((108.352478) + k*((95.428662) - (108.352478))/3)]],
            [for (k = [1 : 4]) [(7.493853) + (17.332928)*cos((98.282071) + k*((79.79887) - (98.282071))/4), (-36.611335) + (17.332928)*sin((98.282071) + k*((79.79887) - (98.282071))/4)]],
            [for (k = [1 : 10]) [(10.453334) + (4.150835)*cos((88.553921) + k*((32.176466) - (88.553921))/10), (-23.767629) + (4.150835)*sin((88.553921) + k*((32.176466) - (88.553921))/10)]],
            [for (k = [1 : 3]) [(7.495557) + (7.271864)*cos((27.405487) + k*((9.60775) - (27.405487))/3), (-24.91402) + (7.271864)*sin((27.405487) + k*((9.60775) - (27.405487))/3)]],
            [for (k = [1 : 3]) [(2.613651) + (12.281687)*cos((11.011858) + k*((4.854995) - (11.011858))/3), (-26.045641) + (12.281687)*sin((11.011858) + k*((4.854995) - (11.011858))/3)]],
            [[14.794323, -29.794239]],
            [[14.788242, -29.843619]],
            [for (k = [1 : 4]) [(6.779436) + (8.008519)*cos((-2.746276) + k*((-26.650798) - (-2.746276))/4), (-29.459451) + (8.008519)*sin((-2.746276) + k*((-26.650798) - (-2.746276))/4)]],
            [for (k = [1 : 11]) [(10.192262) + (4.276039)*cos((-28.491363) + k*((-90.075206) - (-28.491363))/11), (-31.01932) + (4.276039)*sin((-28.491363) + k*((-90.075206) - (-28.491363))/11)]],
            [for (k = [1 : 4]) [(8.188477) + (14.238785)*cos((-81.924572) + k*((-100.892414) - (-81.924572))/4), (-21.261083) + (14.238785)*sin((-81.924572) + k*((-100.892414) - (-81.924572))/4)]],
            [for (k = [1 : 3]) [(7.354121) + (13.65748)*cos((-97.824538) + k*((-108.115647) - (-97.824538))/3), (-21.728799) + (13.65748)*sin((-97.824538) + k*((-108.115647) - (-97.824538))/3)]],
            [[2.732038, -34.560102]],
            [[0.008731, -30.000107]],
            [[0.008731, -24.800108]],
            [[2.722458, -19.917154]]));
                            // b2_crown_ctrl_6: parametric CONTROL section at y=-3.342 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -3.342]) linear_extrude(0.02) polygon(concat(
            [[0.008731, -29.979177]],
            [[0.008731, -21.995393]],
            [for (k = [1 : 9]) [(4.520437) + (5.529717)*cos((145.198262) + k*((94.613381) - (145.198262))/9), (-25.131314) + (5.529717)*sin((145.198262) + k*((94.613381) - (145.198262))/9)]],
            [for (k = [1 : 3]) [(7.112903) + (18.154395)*cos((99.639586) + k*((91.90249) - (99.639586))/3), (-37.484198) + (18.154395)*sin((99.639586) + k*((91.90249) - (99.639586))/3)]],
            [for (k = [1 : 6]) [(7.893142) + (11.626298)*cos((96.811281) + k*((64.353812) - (96.811281))/6), (-30.917119) + (11.626298)*sin((96.811281) + k*((64.353812) - (96.811281))/6)]],
            [for (k = [1 : 8]) [(8.92326) + (5.793895)*cos((46.172833) + k*((-1.649168) - (46.172833))/8), (-24.622592) + (5.793895)*sin((46.172833) + k*((-1.649168) - (46.172833))/8)]],
            [[14.791873, -25.073562]],
            [[14.820724, -25.32487]],
            [[14.763027, -29.474347]],
            [[14.73059, -29.743461]],
            [[14.682674, -30.131842]],
            [for (k = [1 : 10]) [(9.225778) + (5.411365)*cos((1.451799) + k*((-55.214469) - (1.451799))/10), (-30.270142) + (5.411365)*sin((1.451799) + k*((-55.214469) - (1.451799))/10)]],
            [for (k = [1 : 6]) [(8.077262) + (11.603041)*cos((-68.672378) + k*((-103.22059) - (-68.672378))/6), (-23.897009) + (11.603041)*sin((-68.672378) + k*((-103.22059) - (-68.672378))/6)]],
            [for (k = [1 : 3]) [(7.480083) + (14.38764)*cos((-98.250149) + k*((-107.828123) - (-98.250149))/3), (-20.988339) + (14.38764)*sin((-98.250149) + k*((-107.828123) - (-98.250149))/3)]],
            [for (k = [1 : 4]) [(5.046679) + (6.552619)*cos((-107.506028) + k*((-127.210823) - (-107.506028))/4), (-28.434396) + (6.552619)*sin((-107.506028) + k*((-127.210823) - (-107.506028))/4)]],
            [for (k = [1 : 4]) [(3.779471) + (4.380864)*cos((-127.952854) + k*((-149.374112) - (-127.952854))/4), (-30.197064) + (4.380864)*sin((-127.952854) + k*((-149.374112) - (-127.952854))/4)]]));
                            // b2_crown_ctrl_7: parametric CONTROL section at y=4.258 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, 4.258]) linear_extrude(0.02) polygon(concat(
            [for (k = [1 : 10]) [(5.067908) + (6.451406)*cos((142.10104) + k*((84.782499) - (142.10104))/10), (-26.483831) + (6.451406)*sin((142.10104) + k*((84.782499) - (142.10104))/10)]],
            [for (k = [1 : 4]) [(6.881472) + (14.681453)*cos((94.783525) + k*((71.4408) - (94.783525))/4), (-34.693833) + (14.681453)*sin((94.783525) + k*((71.4408) - (94.783525))/4)]],
            [for (k = [1 : 10]) [(9.324017) + (4.516082)*cos((60.360672) + k*((1.034195) - (60.360672))/10), (-24.709697) + (4.516082)*sin((60.360672) + k*((1.034195) - (60.360672))/10)]],
            [[14.07226, -27.342516]],
            [for (k = [1 : 3]) [(13.679649) + (0.395751)*cos((7.221585) + k*((-2.118003) - (7.221585))/3), (-27.392265) + (0.395751)*sin((7.221585) + k*((-2.118003) - (7.221585))/3)]],
            [for (k = [1 : 3]) [(0.286647) + (13.788927)*cos((0.459731) + k*((-9.891851) - (0.459731))/3), (-27.51753) + (13.788927)*sin((0.459731) + k*((-9.891851) - (0.459731))/3)]],
            [for (k = [1 : 8]) [(8.094322) + (5.758195)*cos((-3.831815) + k*((-47.213803) - (-3.831815))/8), (-29.499435) + (5.758195)*sin((-3.831815) + k*((-47.213803) - (-3.831815))/8)]],
            [[10.966709, -34.199063]],
            [[10.933646, -34.214489]],
            [[10.869585, -34.238753]],
            [for (k = [1 : 3]) [(7.881446) + (9.809367)*cos((-72.26471) + k*((-86.701026) - (-72.26471))/3), (-24.895549) + (9.809367)*sin((-72.26471) + k*((-86.701026) - (-72.26471))/3)]],
            [for (k = [1 : 5]) [(7.357684) + (14.043124)*cos((-85.556292) + k*((-111.241685) - (-85.556292))/5), (-20.685186) + (14.043124)*sin((-85.556292) + k*((-111.241685) - (-85.556292))/5)]],
            [for (k = [1 : 6]) [(4.243328) + (5.081119)*cos((-112.843934) + k*((-146.504693) - (-112.843934))/6), (-29.08948) + (5.081119)*sin((-112.843934) + k*((-146.504693) - (-112.843934))/6)]],
            [[0.008731, -24.731938]],
            [[0.008731, -22.545517]]));
                            // b2_crown_ctrl_8: parametric CONTROL section at y=4.658 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, 4.658]) linear_extrude(0.02) polygon(concat(
            [[0.008731, -24.800108]],
            [[7.95858, -20.118689]],
            [[8.240675, -20.135131]],
            [[8.276518, -20.139388]],
            [for (k = [1 : 7]) [(8.532585) + (6.608175)*cos((92.207764) + k*((52.44962) - (92.207764))/7), (-26.78153) + (6.608175)*sin((92.207764) + k*((52.44962) - (92.207764))/7)]],
            [for (k = [1 : 7]) [(8.758475) + (5.069915)*cos((41.606405) + k*((3.442522) - (41.606405))/7), (-24.925384) + (5.069915)*sin((41.606405) + k*((3.442522) - (41.606405))/7)]],
            [[14.039144, -27.212274]],
            [[14.046587, -27.381377]],
            [for (k = [1 : 5]) [(3.188736) + (10.85012)*cos((2.445869) + k*((-26.347998) - (2.445869))/5), (-27.845163) + (10.85012)*sin((2.445869) + k*((-26.347998) - (2.445869))/5)]],
            [for (k = [1 : 9]) [(9.435689) + (4.223828)*cos((-34.639963) + k*((-86.558313) - (-34.639963))/9), (-30.262557) + (4.223828)*sin((-34.639963) + k*((-86.558313) - (-34.639963))/9)]],
            [for (k = [1 : 3]) [(7.516338) + (12.950434)*cos((-80.334027) + k*((-87.995149) - (-80.334027))/3), (-21.740034) + (12.950434)*sin((-80.334027) + k*((-87.995149) - (-80.334027))/3)]],
            [[0.008731, -30.000107]]));
                            // b2_crown_ctrl_9: parametric CONTROL section at y=5.458 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, 5.458]) linear_extrude(0.02) polygon(concat(
            [[9.792414, -20.382327]],
            [for (k = [1 : 4]) [(9.025086) + (5.500389)*cos((81.983736) + k*((59.849306) - (81.983736))/4), (-25.830924) + (5.500389)*sin((81.983736) + k*((59.849306) - (81.983736))/4)]],
            [for (k = [1 : 10]) [(9.251307) + (4.510298)*cos((55.625579) + k*((1.574875) - (55.625579))/10), (-24.782832) + (4.510298)*sin((55.625579) + k*((1.574875) - (55.625579))/10)]],
            [for (k = [1 : 6]) [(0.751804) + (13.257322)*cos((11.50761) + k*((-22.396897) - (11.50761))/6), (-27.309419) + (13.257322)*sin((11.50761) + k*((-22.396897) - (11.50761))/6)]],
            [for (k = [1 : 10]) [(9.444055) + (4.075945)*cos((-29.489882) + k*((-85.110173) - (-29.489882))/10), (-30.347683) + (4.075945)*sin((-29.489882) + k*((-85.110173) - (-29.489882))/10)]],
            [[0.008731, -30.000107]],
            [[0.008731, -24.800108]]));
                            // b2_crown_ctrl_10: parametric CONTROL section at y=6.258 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, 6.258]) linear_extrude(0.02) polygon(concat(
            [[0.008731, -24.800108]],
            [[10.86967, -20.708384]],
            [for (k = [1 : 12]) [(9.425525) + (4.249047)*cos((70.08045) + k*((1.012767) - (70.08045))/12), (-24.693542) + (4.249047)*sin((70.08045) + k*((1.012767) - (70.08045))/12)]],
            [for (k = [1 : 6]) [(0.655006) + (13.300615)*cos((11.535801) + k*((-22.171824) - (11.535801))/6), (-27.284182) + (13.300615)*sin((11.535801) + k*((-22.171824) - (11.535801))/6)]],
            [[12.946267, -32.303781]],
            [for (k = [1 : 8]) [(9.634842) + (3.760514)*cos((-28.265209) + k*((-70.804786) - (-28.265209))/8), (-30.523356) + (3.760514)*sin((-28.265209) + k*((-70.804786) - (-28.265209))/8)]],
            [[0.008731, -30.000107]]));
                            // b2_crown_ctrl_11: parametric CONTROL section at y=7.458 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, 7.458]) linear_extrude(0.02) polygon(concat(
            [[0.008731, -24.800108]],
            [[11.953159, -21.382498]],
            [for (k = [1 : 9]) [(9.210688) + (4.40937)*cos((51.373637) + k*((2.646286) - (51.373637))/9), (-24.814691) + (4.40937)*sin((51.373637) + k*((2.646286) - (51.373637))/9)]],
            [for (k = [1 : 3]) [(-3.336653) + (17.183143)*cos((8.735231) + k*((-0.173591) - (8.735231))/3), (-27.219221) + (17.183143)*sin((8.735231) + k*((-0.173591) - (8.735231))/3)]],
            [for (k = [1 : 3]) [(-0.097048) + (13.942287)*cos((0.938641) + k*((-15.50481) - (0.938641))/3), (-27.49972) + (13.942287)*sin((0.938641) + k*((-15.50481) - (0.938641))/3)]],
            [for (k = [1 : 6]) [(9.215132) + (4.283027)*cos((-15.995607) + k*((-50.186436) - (-15.995607))/6), (-30.044971) + (4.283027)*sin((-15.995607) + k*((-50.186436) - (-15.995607))/6)]],
            [[0.008731, -30.000107]]));
                        }
                        difference() {
                            // b2_dome_below: everything below the ceiling-arc center plane
                            translate([-36, -12, -1]) cube([18, 24, b2_dome_cz + 1]);
                            // b2_dome_arc: lengthwise ceiling: x-axis cylinder, LOWER branch (center above the part) — residual in dome_r param
                            translate([-36, b2_dome_cy, b2_dome_cz]) rotate([0, 90, 0]) cylinder(h=17, r=b2_dome_r, $fn=b2_fn);
                        }
                    }
                    // b2_scoop_rear: rear underside scoop: measured x-axis cylinder (see scoop_rear_* params)
                    translate([-36, b2_scoop_rear_cy, b2_scoop_rear_cz]) rotate([0, 90, 0]) cylinder(h=17, r=b2_scoop_rear_r, $fn=b2_fn);
                    // b2_scoop_front: front underside scoop: measured x-axis cylinder (see scoop_front_* params)
                    translate([-36, b2_scoop_front_cy, b2_scoop_front_cz]) rotate([0, 90, 0]) cylinder(h=17, r=b2_scoop_front_r, $fn=b2_fn);
                }
            }
        }
        // b2_tendon_tunnel: tendon tunnel: exact full-circle cylinder face #26
        translate([-27.400107, -17.92562, 2.158731]) rotate(a=90, v=[-1, 0, 0]) cylinder(h=34.8455, r=b2_tendon_tunnel_r, $fn=b2_fn);
        // b2_slot_palm: tendon slot (palm side): walls tangent to the tunnel (x=-28.525107/-26.275107), up to tunnel center, back overshoot; front = exact bridge back wall #33
        translate([-28.525107, -17.92562, -0.991269]) cube([2.25, 13.86, 3.15]);
        // b2_slot_dist: tendon slot (distal side): bridge front wall #42 to the exact tunnel end
        translate([-28.525107, 4.32438, -0.991269]) cube([2.25, 12.5955, 3.15]);
        // b2_pin_bore_palm: knuckle pin bore: exact cylinder face #61
        translate([-31.500107, -11.42562, 6.008731]) rotate(a=90, v=[0, 1, 0]) cylinder(h=8.2, r=b2_pin_palm_r, $fn=b2_fn);
        // b2_pin_bore_distal: knuckle pin bore: exact cylinder face #23
        translate([-31.500107, 11.57438, 6.008731]) rotate(a=90, v=[0, 1, 0]) cylinder(h=8.2, r=b2_pin_distal_r, $fn=b2_fn);
        // b2_pocket: elastic pocket: full beam width (exact inward walls at the beam planes), front wall #33, floor #21 z=13.038731; back wall raycast-measured
        translate([-30.000107, -4.579671, 13.038731]) cube([5.2, 1.654051, 6.162285]);
        // b2_shl: palm shoulder (deck band + knuckle, beside the center fin): flat at the exact plane #21; fin/crest flare raycast-measured (x=[-28.900121,-25.900093])
        translate([-30.000107, -18.428818, 13.038731]) cube([1.069986, 15.503198, 6.162285]);
        // b2_shr: palm shoulder (deck band + knuckle, beside the center fin): flat at the exact plane #21; fin/crest flare raycast-measured (x=[-28.900121,-25.900093])
        translate([-25.870093, -18.428818, 13.038731]) cube([1.069986, 15.503198, 6.162285]);
        // b2_fork: palm clevis fork: full-height gap between the exact channel-wall planes, behind the exact end wall (= the tunnel start plane); raycast-verified ears-only at y=-16.68
        translate([-28.525107, -18.928818, -0.991269]) cube([2.25, 3.003198, 20.192285]);
        // b2_recess_left: vectorized measured profile (4 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=-31.500107 (0.5 steps, -0.05 margin), scan from the exact deck wall y=7.528651 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, -37.587818]) linear_extrude(7.587711) polygon(concat(
            [[4.408651, -0.991269]],
            [[4.408651, 6.855302]],
            [for (k = [1 : 5]) [(12.051474) + (7.727705)*cos((171.485968) + k*((142.654711) - (171.485968))/5), (5.711161) + (7.727705)*sin((171.485968) + k*((142.654711) - (171.485968))/5)]],
            [for (k = [1 : 3]) [(11.660964) + (7.219058)*cos((142.82582) + k*((126.090272) - (142.82582))/3), (6.036257) + (7.219058)*sin((142.82582) + k*((126.090272) - (142.82582))/3)]],
            [[8.608651, 11.869714]],
            [[8.608651, -0.991269]]));
        // b2_recess_right: vectorized measured profile (4 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=-23.300107 (0.5 steps, -0.05 margin), scan from the exact deck wall y=7.528651 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, -24.800107]) linear_extrude(7.582904) polygon(concat(
            [[4.408651, -0.991269]],
            [[4.408651, 6.857074]],
            [for (k = [1 : 5]) [(12.065941) + (7.743104)*cos((171.455455) + k*((142.677639) - (171.455455))/5), (5.706598) + (7.743104)*sin((171.455455) + k*((142.677639) - (171.455455))/5)]],
            [for (k = [1 : 3]) [(11.76663) + (7.377998)*cos((142.557921) + k*((126.205482) - (142.557921))/3), (5.91541) + (7.377998)*sin((142.557921) + k*((126.205482) - (142.557921))/3)]],
            [[8.608651, 11.868638]],
            [[8.608651, -0.991269]]));
        // b2_palm_web_left: vectorized measured profile (5 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=-31.500107 (0.5 steps, -0.05 margin), scan from the exact deck wall y=-7.382351 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, -37.587818]) linear_extrude(7.587711) polygon(concat(
            [[-8.462351, 12.374687]],
            [for (k = [1 : 14]) [(-7.924913) + (1.804437)*cos((107.351318) + k*((25.069132) - (107.351318))/14), (10.6546) + (1.804437)*sin((107.351318) + k*((25.069132) - (107.351318))/14)]],
            [for (k = [1 : 4]) [(-12.617368) + (8.563033)*cos((42.082538) + k*((23.467037) - (42.082538))/4), (5.693628) + (8.563033)*sin((42.082538) + k*((23.467037) - (42.082538))/4)]],
            [[-4.262351, 7.494128]],
            [[-3.762351, 2.864457]],
            [[-3.762351, -0.991269]],
            [[-8.462351, -0.991269]]));
        // b2_palm_web_right: vectorized measured profile (5 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=-23.300107 (0.5 steps, -0.05 margin), scan from the exact deck wall y=-7.382351 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, -24.800107]) linear_extrude(7.582904) polygon(concat(
            [[-8.462351, 12.372169]],
            [for (k = [1 : 14]) [(-7.92451) + (1.810652)*cos((107.30203) + k*((25.514685) - (107.30203))/14), (10.645577) + (1.810652)*sin((107.30203) + k*((25.514685) - (107.30203))/14)]],
            [for (k = [1 : 3]) [(-12.906839) + (8.890547)*cos((41.638075) + k*((23.638946) - (41.638075))/3), (5.531756) + (8.890547)*sin((41.638075) + k*((23.638946) - (41.638075))/3)]],
            [[-4.262351, 7.500749]],
            [[-3.762351, 2.841145]],
            [[-3.762351, -0.991269]],
            [[-8.462351, -0.991269]]));
    }
}

// --------------------------------------------------------------------
// BODY 3 — semantic parametric plan
//   semantic laws: beam = exact wall window × envelope laws (top res
//   0.099, bottom res 0.093; knuckle lobes are r6 arcs concentric with
//   the exact pin bores); ridge stem/cap = window × fitted laws; crown
//   kept as measured loft (no clean law); recess/web profiles
//   vectorized | crown REPLACED by law-solids (template-style): hull
//   of vectorized control slabs INTERSECT measured ceiling arc MINUS
//   measured underside scoops PLUS sloped fin lip — every law fitted
//   with residual cited
// --------------------------------------------------------------------

// ======== PARAMETERS (every value measured; sources cited) ========
// --- b3 ---
b3_beam_wall_x0     = -0.74943;  // beam side-wall plane (median of 230 station footprints; end roundings in x are absorbed)
b3_beam_wall_x1     = 4.45057;  // beam side-wall plane (median of 230 station footprints)
b3_knuckle_palm_y   = -12.094042;  // exact pin-bore axis y, face #4 (lobe arc fit agrees within 0.1)
b3_knuckle_palm_z   = 6.008731;  // exact pin-bore axis z, face #4
b3_knuckle_lobe_r   = 6;  // outer radius of both knuckle lobes (arc fits r=6.000 / r=5.997, res 0.002/0.003 -> nominal 6.0)
b3_knuckle_distal_y = 10.905958;  // exact pin-bore axis y, face #27
b3_knuckle_distal_z = 6.008731;  // exact pin-bore axis z, face #27
b3_tendon_tunnel_r  = 1.125;  // exact tendon-tunnel bore radius — tendon tunnel: exact full-circle cylinder face #16
b3_pin_palm_r       = 2.3;  // exact palm pin-bore radius — knuckle pin bore: exact cylinder face #4
b3_pin_distal_r     = 2.375;  // exact distal pin-bore radius — knuckle pin bore: exact cylinder face #27
b3_dome_r           = 54.112284;  // lengthwise ceiling arc radius (fit over 60 stations, res 0.247)
b3_dome_cy          = 5.575018;  // ceiling arc center y (same fit)
b3_dome_cz          = 68.129323;  // ceiling arc center z — ABOVE the part: the ceiling is the circle's lower branch
b3_scoop_rear_r     = 11.763629;  // rear underside scoop cylinder (x-axis) radius: circle fit to the wing shelf heights, res 0.263
b3_scoop_rear_cy    = -16.089836;  // rear scoop center y (same fit)
b3_scoop_rear_cz    = 4.056398;  // rear scoop center z (same fit)
b3_scoop_front_r    = 7.570562;  // front underside scoop radius, res 0.009 — nearly exact circle
b3_scoop_front_cy   = 11.237027;  // front scoop center y (same fit)
b3_scoop_front_cz   = 5.824541;  // front scoop center z (same fit)
b3_fin_top_m        = -0.112916;  // rear clip-lip top slope (linear fit res 0.104)
b3_fin_top_b        = 14.925157;  // rear clip-lip top intercept (same fit)
b3_fn               = 96;  // curve resolution

module body_3() {
    difference() {
        union() {
            difference() {
                intersection() {
                    // b3_beam_bar: beam bar between the side-wall planes; z spans are generous — the envelope laws below do the shaping
                    translate([b3_beam_wall_x0, -17.984, -0.2]) cube([b3_beam_wall_x1 - b3_beam_wall_x0, 34.85, 16.66251]);
                    union() {
                        // b3_beam_top_00: knuckle lobe: r6 arc CONCENTRIC with the exact pin bore face #4 (fit res 0.002)
                        intersection() {
                            translate([-1.24943, -18.034, -0.5]) cube([6.2, 5.9, (16.46251) - (-0.5)]);
                            union() {
                                translate([(-1.24943) - 1, b3_knuckle_palm_y, b3_knuckle_palm_z]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = b3_knuckle_lobe_r, $fn = 4*b3_fn);
                                translate([-500, -500, (b3_knuckle_palm_z) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b3_beam_top_01: fitted arc law (upper branch, res 0.077)
                        intersection() {
                            translate([-1.24943, -12.234, -0.5]) cube([6.2, 1, (16.46251) - (-0.5)]);
                            union() {
                                translate([(-1.24943) - 1, -10.713323, 13.880735]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 2.376033, $fn = 4*b3_fn);
                                translate([-500, -500, (13.880735) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b3_beam_top_02: fitted line law m=-0.0977 (res 0.000)
                        intersection() {
                            translate([-1.24943, -11.334, -0.5]) cube([6.2, 6.55, (16.46251) - (-0.5)]);
                            translate([0, 0, 15.031089]) rotate([atan(-0.097671), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        // b3_beam_top_03: fitted line law m=-1.1460 (res 0.000)
                        intersection() {
                            translate([-1.24943, -4.884, -0.5]) cube([6.2, 0.7, (16.46251) - (-0.5)]);
                            translate([0, 0, 9.963547]) rotate([atan(-1.145983), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        // b3_beam_top_04: fitted arc law (upper branch, res 0.097)
                        intersection() {
                            translate([-1.24943, -4.284, -0.5]) cube([6.2, 5.5, (16.46251) - (-0.5)]);
                            union() {
                                translate([(-1.24943) - 1, -3.097221, -2.077513]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 16.94157, $fn = 4*b3_fn);
                                translate([-500, -500, (-2.077513) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        difference() {
                            // b3_beam_top_05_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.044)
                            translate([-1.54943, 1.116, -1.5]) cube([6.8, 4.9, 52.397246]);
                            // b3_beam_top_05_lobe: fitted arc law (lower branch, res 0.044)
                            translate([-1.64943, 6.87079, 50.897246]) rotate(a=90, v=[0, 1, 0]) cylinder(h=7, r=36.877864, $fn=b3_fn);
                        }
                        // b3_beam_top_06: fitted arc law (upper branch, res 0.052)
                        intersection() {
                            translate([-1.24943, 5.916, -0.5]) cube([6.2, 1.35, (16.46251) - (-0.5)]);
                            union() {
                                translate([(-1.24943) - 1, 5.775765, 11.975501]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 2.002451, $fn = 4*b3_fn);
                                translate([-500, -500, (11.975501) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b3_beam_top_07: fitted line law m=-0.1251 (res 0.090)
                        intersection() {
                            translate([-1.24943, 7.166, -0.5]) cube([6.2, 3.4, (16.46251) - (-0.5)]);
                            translate([0, 0, 11.471647]) rotate([atan(-0.125111), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        difference() {
                            // b3_beam_top_08_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.088)
                            translate([-1.54943, 10.466, -1.5]) cube([6.8, 1, 12.320668]);
                            // b3_beam_top_08_lobe: fitted arc law (lower branch, res 0.088)
                            translate([-1.64943, 11.058201, 10.820668]) rotate(a=90, v=[0, 1, 0]) cylinder(h=7, r=0.793005, $fn=b3_fn);
                        }
                        difference() {
                            // b3_beam_top_09_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.011)
                            translate([-1.54943, 11.366, -1.5]) cube([6.8, 1.6, 16.087301]);
                            // b3_beam_top_09_lobe: fitted arc law (lower branch, res 0.011)
                            translate([-1.64943, 12.766146, 14.587301]) rotate(a=90, v=[0, 1, 0]) cylinder(h=7, r=4.703839, $fn=b3_fn);
                        }
                        // b3_beam_top_10: fitted line law m=0.1900 (res 0.099)
                        intersection() {
                            translate([-1.24943, 12.866, -0.5]) cube([6.2, 0.95, (16.46251) - (-0.5)]);
                            translate([0, 0, 7.356149]) rotate([atan(0.189975), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        difference() {
                            // b3_beam_top_11_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.038)
                            translate([-1.54943, 13.716, -1.5]) cube([6.8, 1.05, 11.950984]);
                            // b3_beam_top_11_lobe: fitted arc law (lower branch, res 0.038)
                            translate([-1.64943, 14.202909, 10.450984]) rotate(a=90, v=[0, 1, 0]) cylinder(h=7, r=0.678026, $fn=b3_fn);
                        }
                        // b3_beam_top_12: fitted arc law (upper branch, res 0.068)
                        intersection() {
                            translate([-1.24943, 14.666, -0.5]) cube([6.2, 2.25, (16.46251) - (-0.5)]);
                            union() {
                                translate([(-1.24943) - 1, 14.780961, 7.779825]) rotate([0, 90, 0]) cylinder(h = (6.2) + 2, r = 2.137645, $fn = 4*b3_fn);
                                translate([-500, -500, (7.779825) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                    }
                }
                difference() {
                    // b3_beam_under_00_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.092)
                    translate([-1.04943, -18.034, -0.99127]) cube([5.8, 7.4, 7.202864]);
                    // b3_beam_under_00_lobe: fitted arc law (lower branch, res 0.092)
                    translate([-1.14943, -11.976106, 6.211594]) rotate(a=90, v=[0, 1, 0]) cylinder(h=6, r=6.244125, $fn=b3_fn);
                }
                // b3_beam_under_01: underside carve: fitted arc law (upper branch, res 0.093)
                intersection() {
                    translate([-1.04943, -10.734, -0.99127]) cube([5.8, 1.6, (16.46251) - (-0.99127)]);
                    union() {
                        translate([(-1.04943) - 1, -9.934, -1.718673]) rotate([0, 90, 0]) cylinder(h = (5.8) + 2, r = 1.789776, $fn = 4*b3_fn);
                        translate([-500, -500, (-1.718673) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b3_beam_under_02: underside carve: fitted arc law (upper branch, res 0.035)
                intersection() {
                    translate([-1.04943, -9.234, -0.99127]) cube([5.8, 1, (16.46251) - (-0.99127)]);
                    union() {
                        translate([(-1.04943) - 1, -8.734, -1.329657]) rotate([0, 90, 0]) cylinder(h = (5.8) + 2, r = 1.377055, $fn = 4*b3_fn);
                        translate([-500, -500, (-1.329657) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b3_beam_under_03: underside carve: fitted line law m=0.0000 (res 0.000)
                intersection() {
                    translate([-1.04943, -8.334, -0.99127]) cube([5.8, 5.95, (16.46251) - (-0.99127)]);
                    translate([0, 0, 0.00873]) rotate([atan(0), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_04: underside carve: fitted line law m=1.7220 (res 0.000)
                intersection() {
                    translate([-1.04943, -2.484, -0.99127]) cube([5.8, 0.7, (16.46251) - (-0.99127)]);
                    translate([0, 0, 4.200078]) rotate([atan(1.722), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_05: underside carve: fitted line law m=0.1082 (res 0.000)
                intersection() {
                    translate([-1.04943, -1.884, -0.99127]) cube([5.8, 0.7, (16.46251) - (-0.99127)]);
                    translate([0, 0, 1.240338]) rotate([atan(0.108183), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_06: underside carve: fitted line law m=-1.8302 (res 0.000)
                intersection() {
                    translate([-1.04943, -1.284, -0.99127]) cube([5.8, 0.7, (16.46251) - (-0.99127)]);
                    translate([0, 0, -1.151606]) rotate([atan(-1.830183), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_07: underside carve: fitted line law m=1.7220 (res 0.000)
                intersection() {
                    translate([-1.04943, -0.684, -0.99127]) cube([5.8, 0.7, (16.46251) - (-0.99127)]);
                    translate([0, 0, 1.100478]) rotate([atan(1.722), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_08: underside carve: fitted line law m=-1.7220 (res 0.000)
                intersection() {
                    translate([-1.04943, -0.084, -0.99127]) cube([5.8, 0.7, (16.46251) - (-0.99127)]);
                    translate([0, 0, 0.983382]) rotate([atan(-1.722), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_09: underside carve: fitted line law m=1.7083 (res 0.000)
                intersection() {
                    translate([-1.04943, 0.516, -0.99127]) cube([5.8, 0.7, (16.46251) - (-0.99127)]);
                    translate([0, 0, -0.958187]) rotate([atan(1.708333), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_10: underside carve: fitted line law m=-1.7083 (res 0.000)
                intersection() {
                    translate([-1.04943, 1.116, -0.99127]) cube([5.8, 0.7, (16.46251) - (-0.99127)]);
                    translate([0, 0, 3.025647]) rotate([atan(-1.708333), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_beam_under_11: underside carve: fitted line law m=0.0035 (res 0.074)
                intersection() {
                    translate([-1.04943, 1.716, -0.99127]) cube([5.8, 10.35, (16.46251) - (-0.99127)]);
                    translate([0, 0, -0.012521]) rotate([atan(0.003503), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                difference() {
                    // b3_beam_under_12_below: region below the lower-branch arc envelope — knuckle lobe: r6 arc CONCENTRIC with the exact pin bore face #27 (fit res 0.003)
                    translate([-1.04943, 11.966, -0.99127]) cube([5.8, 4.95, 7.001571]);
                    // b3_beam_under_12_lobe: knuckle lobe: r6 arc CONCENTRIC with the exact pin bore face #27 (fit res 0.003)
                    translate([-1.14943, b3_knuckle_distal_y, b3_knuckle_distal_z]) rotate([0, 90, 0]) cylinder(h=6, r=b3_knuckle_lobe_r, $fn=b3_fn);
                }
            }
            difference() {
                intersection() {
                    // b3_ridge_stem_bar: ridge_stem wall window x=[0.53057,3.17057] (median of 46 stations)
                    translate([0.53057, 8.12, 7.73859]) cube([2.64, 9.2, 6.938]);
                    union() {
                        // b3_ridge_stem_top_00: fitted line law m=-0.1288 (res 0.000)
                        intersection() {
                            translate([0.23057, 8.07, 7.53859]) cube([3.24, 0.5, (14.67659) - (7.53859)]);
                            translate([0, 0, 11.555679]) rotate([atan(-0.128825), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        // b3_ridge_stem_top_01: fitted line law m=8.7601 (res 0.000)
                        intersection() {
                            translate([0.23057, 8.47, 7.53859]) cube([3.24, 0.5, (14.67659) - (7.53859)]);
                            translate([0, 0, -64.178175]) rotate([atan(8.760125), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                        // b3_ridge_stem_top_02: fitted arc law (upper branch, res 0.097)
                        intersection() {
                            translate([0.23057, 8.87, 7.53859]) cube([3.24, 1.7, (14.67659) - (7.53859)]);
                            union() {
                                translate([(0.23057) - 1, 9.740306, 13.572124]) rotate([0, 90, 0]) cylinder(h = (3.24) + 2, r = 0.910475, $fn = 4*b3_fn);
                                translate([-500, -500, (13.572124) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b3_ridge_stem_top_03: fitted line law m=-0.2501 (res 0.000)
                        intersection() {
                            translate([0.23057, 10.47, 7.53859]) cube([3.24, 6.9, (14.67659) - (7.53859)]);
                            translate([0, 0, 16.822428]) rotate([atan(-0.25009), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                    }
                }
                // b3_ridge_stem_under_00: underside carve: fitted line law m=-0.1336 (res 0.071)
                intersection() {
                    translate([0.23057, 8.07, 6.73859]) cube([3.24, 6.9, (14.67659) - (6.73859)]);
                    translate([0, 0, 11.577093]) rotate([atan(-0.133627), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_ridge_stem_under_01: underside carve: fitted arc law (upper branch, res 0.001)
                intersection() {
                    translate([0.23057, 14.87, 6.73859]) cube([3.24, 1.7, (14.67659) - (6.73859)]);
                    union() {
                        translate([(0.23057) - 1, 13.829633, 6.723983]) rotate([0, 90, 0]) cylinder(h = (3.24) + 2, r = 2.994155, $fn = 4*b3_fn);
                        translate([-500, -500, (6.723983) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b3_ridge_stem_under_02: underside carve: fitted line law m=5.9759 (res 0.000)
                intersection() {
                    translate([0.23057, 16.47, 6.73859]) cube([3.24, 0.5, (14.67659) - (6.73859)]);
                    translate([0, 0, -90.682452]) rotate([atan(5.97585), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
                // b3_ridge_stem_under_03: underside carve: fitted line law m=2.9263 (res 0.000)
                intersection() {
                    translate([0.23057, 16.87, 6.73859]) cube([3.24, 0.5, (14.67659) - (6.73859)]);
                    translate([0, 0, -39.084489]) rotate([atan(2.926325), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
            }
            difference() {
                intersection() {
                    // b3_ridge_cap_bar: ridge_cap wall window x=[0.35056,3.35057] (median of 42 stations)
                    translate([0.35056, 6.92, 10.19416]) cube([3.00001, 9.6, 4.39739]);
                    union() {
                        difference() {
                            // b3_ridge_cap_top_00_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.042)
                            translate([-0.24944, 6.87, 8.99416]) cube([4.20001, 1.7, 3.42862]);
                            // b3_ridge_cap_top_00_lobe: fitted arc law (lower branch, res 0.042)
                            translate([-0.34944, 8.163125, 12.42278]) rotate(a=90, v=[0, 1, 0]) cylinder(h=4.40001, r=1.955686, $fn=b3_fn);
                        }
                        // b3_ridge_cap_top_01: fitted arc law (upper branch, res 0.078)
                        intersection() {
                            translate([0.05056, 8.47, 9.99416]) cube([3.60001, 2.9, (14.59155) - (9.99416)]);
                            union() {
                                translate([(0.05056) - 1, 10.000215, 12.113069]) rotate([0, 90, 0]) cylinder(h = (3.60001) + 2, r = 2.220359, $fn = 4*b3_fn);
                                translate([-500, -500, (12.113069) - 1000]) cube([1000, 1000, 1000]);
                            }
                        }
                        // b3_ridge_cap_top_02: fitted line law m=-0.2501 (res 0.000)
                        intersection() {
                            translate([0.05056, 11.27, 9.99416]) cube([3.60001, 5.3, (14.59155) - (9.99416)]);
                            translate([0, 0, 16.822429]) rotate([atan(-0.25009), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                        }
                    }
                }
                difference() {
                    // b3_ridge_cap_under_00_below: region below the lower-branch arc envelope — fitted arc law (lower branch, res 0.062)
                    translate([0.05056, 6.87, 9.19416]) cube([3.60001, 1.7, 2.480613]);
                    // b3_ridge_cap_under_00_lobe: fitted arc law (lower branch, res 0.062)
                    translate([-0.04944, 8.024678, 11.674773]) rotate(a=90, v=[0, 1, 0]) cylinder(h=3.80001, r=1.231202, $fn=b3_fn);
                }
                // b3_ridge_cap_under_01: underside carve: fitted arc law (upper branch, res 0.047)
                intersection() {
                    translate([0.05056, 8.47, 9.19416]) cube([3.60001, 2.5, (14.59155) - (9.19416)]);
                    union() {
                        translate([(0.05056) - 1, 9.953475, 11.545682]) rotate([0, 90, 0]) cylinder(h = (3.60001) + 2, r = 1.773538, $fn = 4*b3_fn);
                        translate([-500, -500, (11.545682) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b3_ridge_cap_under_02: underside carve: fitted arc law (upper branch, res 0.089)
                intersection() {
                    translate([0.05056, 10.87, 9.19416]) cube([3.60001, 3.7, (14.59155) - (9.19416)]);
                    union() {
                        translate([(0.05056) - 1, 10.855779, 1.884652]) rotate([0, 90, 0]) cylinder(h = (3.60001) + 2, r = 11.023888, $fn = 4*b3_fn);
                        translate([-500, -500, (1.884652) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b3_ridge_cap_under_03: underside carve: fitted arc law (upper branch, res 0.085)
                intersection() {
                    translate([0.05056, 14.47, 9.19416]) cube([3.60001, 1.7, (14.59155) - (9.19416)]);
                    union() {
                        translate([(0.05056) - 1, 14.684744, 10.413883]) rotate([0, 90, 0]) cylinder(h = (3.60001) + 2, r = 1.938367, $fn = 4*b3_fn);
                        translate([-500, -500, (10.413883) - 1000]) cube([1000, 1000, 1000]);
                    }
                }
                // b3_ridge_cap_under_04: underside carve: fitted line law m=-0.0474 (res 0.000)
                intersection() {
                    translate([0.05056, 16.07, 9.19416]) cube([3.60001, 0.5, (14.59155) - (9.19416)]);
                    translate([0, 0, 12.569694]) rotate([atan(-0.047363), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
            }
            union() {
                difference() {
                    intersection() {
                        hull() {
                            // b3_crown_ctrl_0: parametric CONTROL section at y=-8.0 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -8]) linear_extrude(0.02) polygon(concat(
            [[12.477797, 7.853539]],
            [for (k = [1 : 12]) [(12.027379) + (3.01177)*cos((81.414945) + k*((12.071273) - (81.414945))/12), (4.870026) + (3.01177)*sin((81.414945) + k*((12.071273) - (81.414945))/12)]],
            [[15.55425, 3.347975]],
            [for (k = [1 : 8]) [(6.77702) + (8.920207)*cos((10.342521) + k*((-32.756923) - (10.342521))/8), (1.746152) + (8.920207)*sin((10.342521) + k*((-32.756923) - (10.342521))/8)]],
            [for (k = [1 : 7]) [(11.800714) + (3.185182)*cos((-39.209671) + k*((-77.778312) - (-39.209671))/7), (-1.060617) + (3.185182)*sin((-39.209671) + k*((-77.778312) - (-39.209671))/7)]],
            [[0.008731, -0.749434]],
            [[0.008731, 4.450566]]));
                            // b3_crown_ctrl_1: parametric CONTROL section at y=-3.4 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, -3.4]) linear_extrude(0.02) polygon(concat(
            [[0.008731, 4.711702]],
            [[0.008731, 5.097289]],
            [for (k = [1 : 15]) [(1.283499) + (1.350537)*cos((-161.312786) + k*((-248.719564) - (-161.312786))/15), (5.528458) + (1.350537)*sin((-161.312786) + k*((-248.719564) - (-161.312786))/15)]],
            [for (k = [1 : 6]) [(5.372304) + (10.493874)*cos((116.010164) + k*((85.273332) - (116.010164))/6), (-2.591686) + (10.493874)*sin((116.010164) + k*((85.273332) - (116.010164))/6)]],
            [for (k = [1 : 3]) [(7.336851) + (30.400903)*cos((92.065992) + k*((83.524717) - (92.065992))/3), (-22.470657) + (30.400903)*sin((92.065992) + k*((83.524717) - (92.065992))/3)]],
            [for (k = [1 : 11]) [(11.173392) + (3.607896)*cos((96.420556) + k*((32.578354) - (96.420556))/11), (4.116601) + (3.607896)*sin((96.420556) + k*((32.578354) - (96.420556))/11)]],
            [for (k = [1 : 5]) [(3.041474) + (11.863867)*cos((19.624624) + k*((-8.670212) - (19.624624))/5), (2.071006) + (11.863867)*sin((19.624624) + k*((-8.670212) - (19.624624))/5)]],
            [[14.733696, -0.012036]],
            [for (k = [1 : 9]) [(10.439206) + (4.252326)*cos((2.238202) + k*((-51.358384) - (2.238202))/9), (-0.179881) + (4.252326)*sin((2.238202) + k*((-51.358384) - (2.238202))/9)]],
            [for (k = [1 : 5]) [(8.715375) + (13.796994)*cos((-71.500759) + k*((-96.508331) - (-71.500759))/5), (9.559522) + (13.796994)*sin((-71.500759) + k*((-96.508331) - (-71.500759))/5)]],
            [for (k = [1 : 3]) [(8.435818) + (30.764442)*cos((-92.400205) + k*((-98.100702) - (-92.400205))/3), (26.553928) + (30.764442)*sin((-92.400205) + k*((-98.100702) - (-92.400205))/3)]],
            [for (k = [1 : 5]) [(4.737717) + (7.716688)*cos((-94.725553) + k*((-122.808955) - (-94.725553))/5), (3.802364) + (7.716688)*sin((-94.725553) + k*((-122.808955) - (-94.725553))/5)]],
            [for (k = [1 : 3]) [(3.085309) + (3.896229)*cos((-130.295535) + k*((-142.13174) - (-130.295535))/3), (0.302463) + (3.896229)*sin((-130.295535) + k*((-142.13174) - (-130.295535))/3)]]));
                            // b3_crown_ctrl_2: parametric CONTROL section at y=3.4 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, 3.4]) linear_extrude(0.02) polygon(concat(
            [[0.008731, 5.700535]],
            [for (k = [1 : 7]) [(3.143097) + (4.70958)*cos((131.958609) + k*((93.898747) - (131.958609))/7), (2.214408) + (4.70958)*sin((131.958609) + k*((93.898747) - (131.958609))/7)]],
            [for (k = [1 : 3]) [(7.344215) + (30.162211)*cos((98.624124) + k*((92.568097) - (98.624124))/3), (-22.885558) + (30.162211)*sin((98.624124) + k*((92.568097) - (98.624124))/3)]],
            [[7.077763, 7.277996]],
            [for (k = [1 : 3]) [(7.489899) + (16.401591)*cos((91.439859) + k*((88.176) - (91.439859))/3), (-9.118522) + (16.401591)*sin((91.439859) + k*((88.176) - (91.439859))/3)]],
            [for (k = [1 : 4]) [(8.963215) + (13.3082)*cos((94.092413) + k*((75.020205) - (94.092413))/4), (-6.020917) + (13.3082)*sin((94.092413) + k*((75.020205) - (94.092413))/4)]],
            [for (k = [1 : 11]) [(11.025299) + (2.911355)*cos((61.677) + k*((-0.385598) - (61.677))/11), (4.268292) + (2.911355)*sin((61.677) + k*((-0.385598) - (61.677))/11)]],
            [[14.041203, 3.799355]],
            [[14.029447, 0.086372]],
            [for (k = [1 : 9]) [(10.052009) + (3.948339)*cos((0.960841) + k*((-47.724484) - (0.960841))/9), (0.019665) + (3.948339)*sin((0.960841) + k*((-47.724484) - (0.960841))/9)]],
            [for (k = [1 : 6]) [(9.851607) + (6.432394)*cos((-63.650559) + k*((-97.166515) - (-63.650559))/6), (2.84869) + (6.432394)*sin((-63.650559) + k*((-97.166515) - (-63.650559))/6)]],
            [for (k = [1 : 4]) [(8.011468) + (23.345063)*cos((-87.471165) + k*((-107.681558) - (-87.471165))/4), (19.785274) + (23.345063)*sin((-87.471165) + k*((-107.681558) - (-87.471165))/4)]],
            [for (k = [1 : 4]) [(2.333963) + (3.148395)*cos((-116.410401) + k*((-137.588007) - (-116.410401))/4), (0.402796) + (3.148395)*sin((-116.410401) + k*((-137.588007) - (-116.410401))/4)]]));
                            // b3_crown_ctrl_3: parametric CONTROL section at y=6.82 (convex hull of the measured section, vectorized lines+arcs tol 0.05)
                            rotate([0, -90, -90]) translate([0, 0, 6.82]) linear_extrude(0.02) polygon(concat(
            [[0.008731, -0.108508]],
            [[0.008731, 4.450566]],
            [[11.979029, 6.838315]],
            [for (k = [1 : 12]) [(11.091686) + (2.594655)*cos((69.901663) + k*((0.411576) - (69.901663))/12), (4.413318) + (2.594655)*sin((69.901663) + k*((0.411576) - (69.901663))/12)]],
            [for (k = [1 : 6]) [(1.758568) + (12.195428)*cos((11.485874) + k*((-18.90301) - (11.485874))/6), (2.000519) + (12.195428)*sin((11.485874) + k*((-18.90301) - (11.485874))/6)]],
            [for (k = [1 : 7]) [(11.091598) + (2.449423)*cos((-27.449039) + k*((-68.789876) - (-27.449039))/7), (-0.810648) + (2.449423)*sin((-27.449039) + k*((-68.789876) - (-27.449039))/7)]],
            [[0.008731, -0.749434]]));
                        }
                        difference() {
                            // b3_dome_below: everything below the ceiling-arc center plane
                            translate([-10, -12, -1]) cube([22, 24, b3_dome_cz + 1]);
                            // b3_dome_arc: lengthwise ceiling: x-axis cylinder, LOWER branch (center above the part) — residual in dome_r param
                            translate([-10, b3_dome_cy, b3_dome_cz]) rotate([0, 90, 0]) cylinder(h=22, r=b3_dome_r, $fn=b3_fn);
                        }
                    }
                    // b3_scoop_rear: rear underside scoop: measured x-axis cylinder (see scoop_rear_* params)
                    translate([-10, b3_scoop_rear_cy, b3_scoop_rear_cz]) rotate([0, 90, 0]) cylinder(h=22, r=b3_scoop_rear_r, $fn=b3_fn);
                    // b3_scoop_front: front underside scoop: measured x-axis cylinder (see scoop_front_* params)
                    translate([-10, b3_scoop_front_cy, b3_scoop_front_cz]) rotate([0, 90, 0]) cylinder(h=22, r=b3_scoop_front_r, $fn=b3_fn);
                }
                // b3_fin_lip: rear clip lip: measured x-window, sloped top law (fin_top_* params)
                intersection() {
                    translate([0.351, -8.040772, 13.4]) cube([2.991, 3.490772, (15.9) - (13.4)]);
                    translate([0, 0, b3_fin_top_b]) rotate([atan(b3_fin_top_m), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
                }
            }
        }
        // b3_tendon_tunnel: tendon tunnel: exact full-circle cylinder face #16
        translate([1.850566, -18.594042, 2.158731]) rotate(a=90, v=[-1, 0, 0]) cylinder(h=34.846078, r=b3_tendon_tunnel_r, $fn=b3_fn);
        // b3_slot_palm: tendon slot (palm side): walls tangent to the tunnel (x=0.725566/2.975566), up to tunnel center, back overshoot; front = exact bridge back wall #7
        translate([0.725566, -18.594042, -0.991269]) cube([2.25, 13.86, 3.15]);
        // b3_slot_dist: tendon slot (distal side): bridge front wall #32 to the exact tunnel end
        translate([0.725566, 3.655958, -0.991269]) cube([2.25, 12.596078, 3.15]);
        // b3_pin_bore_palm: knuckle pin bore: exact cylinder face #4
        translate([-2.249434, -12.094042, 6.008731]) rotate(a=90, v=[0, 1, 0]) cylinder(h=8.2, r=b3_pin_palm_r, $fn=b3_fn);
        // b3_pin_bore_distal: knuckle pin bore: exact cylinder face #27
        translate([-2.249434, 10.905958, 6.008731]) rotate(a=90, v=[0, 1, 0]) cylinder(h=8.2, r=b3_pin_distal_r, $fn=b3_fn);
        // b3_pocket: elastic pocket: full beam width (exact inward walls at the beam planes), front wall #22, floor #28 z=12.008731; back wall raycast-measured
        translate([-0.749434, -5.090361, 12.008731]) cube([5.2, 1.489589, 6.158476]);
        // b3_shl: palm shoulder (deck band + knuckle, beside the center fin): flat at the exact plane #28; fin/crest flare raycast-measured (x=[0.526375,3.173138])
        translate([-0.749434, -19.09724, 12.008731]) cube([1.245809, 15.496468, 6.158476]);
        // b3_shr: palm shoulder (deck band + knuckle, beside the center fin): flat at the exact plane #28; fin/crest flare raycast-measured (x=[0.526375,3.173138])
        translate([3.203138, -19.09724, 12.008731]) cube([1.247428, 15.496468, 6.158476]);
        // b3_fork: palm clevis fork: full-height gap between the exact channel-wall planes, behind the exact end wall (= the tunnel start plane); raycast-verified ears-only at y=-16.68
        translate([0.725566, -19.59724, -0.991269]) cube([2.25, 3.003198, 19.158476]);
        // b3_recess_left: vectorized measured profile (4 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=-2.249434 (0.5 steps, -0.05 margin), scan from the exact deck wall y=6.860229 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, -6.414395]) linear_extrude(5.664961) polygon(concat(
            [[3.740229, -0.991269]],
            [[3.740229, 6.860934]],
            [for (k = [1 : 5]) [(11.422587) + (7.769579)*cos((171.392686) + k*((142.730795) - (171.392686))/5), (5.698083) + (7.769579)*sin((171.392686) + k*((142.730795) - (171.392686))/5)]],
            [for (k = [1 : 3]) [(11.099232) + (7.383719)*cos((142.513993) + k*((126.182145) - (142.513993))/3), (5.909031) + (7.383719)*sin((142.513993) + k*((126.182145) - (142.513993))/3)]],
            [[7.940229, 11.868749]],
            [[7.940229, -0.991269]]));
        // b3_recess_right: vectorized measured profile (4 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=5.950566 (0.5 steps, -0.05 margin), scan from the exact deck wall y=6.860229 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, 4.450566]) linear_extrude(5.642586) polygon(concat(
            [[3.740229, -0.991269]],
            [[3.740229, 6.8676]],
            [for (k = [1 : 5]) [(11.459456) + (7.809942)*cos((171.247562) + k*((142.786834) - (171.247562))/5), (5.679161) + (7.809942)*sin((171.247562) + k*((142.786834) - (171.247562))/5)]],
            [for (k = [1 : 3]) [(11.018947) + (7.268206)*cos((142.661807) + k*((126.063995) - (142.661807))/3), (5.99377) + (7.268206)*sin((142.661807) + k*((126.063995) - (142.661807))/3)]],
            [[7.940229, 11.869109]],
            [[7.940229, -0.991269]]));
        // b3_palm_web_left: vectorized measured profile (5 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=-2.249434 (0.5 steps, -0.05 margin), scan from the exact deck wall y=-8.050772 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, -6.414395]) linear_extrude(5.664961) polygon(concat(
            [[-9.130772, 12.374541]],
            [for (k = [1 : 14]) [(-8.592521) + (1.808294)*cos((107.341062) + k*((25.31641) - (107.341062))/14), (10.650767) + (1.808294)*sin((107.341062) + k*((25.31641) - (107.341062))/14)]],
            [for (k = [1 : 4]) [(-13.40108) + (8.693303)*cos((41.901698) + k*((23.533164) - (41.901698))/4), (5.631032) + (8.693303)*sin((41.901698) + k*((23.533164) - (41.901698))/4)]],
            [[-4.930772, 7.493457]],
            [[-4.430772, 2.859386]],
            [[-4.430772, -0.991269]],
            [[-9.130772, -0.991269]]));
        // b3_palm_web_right: vectorized measured profile (5 lines + 2 arcs) — under-deck recess: raycast-measured deck underside polyline at x=5.950566 (0.5 steps, -0.05 margin), scan from the exact deck wall y=-8.050772 toward the core until closure
        rotate([90, 0, 90]) translate([0, 0, 4.450566]) linear_extrude(5.642586) polygon(concat(
            [[-9.130772, 12.374522]],
            [for (k = [1 : 14]) [(-8.59254) + (1.807291)*cos((107.350642) + k*((25.242796) - (107.350642))/14), (10.651823) + (1.807291)*sin((107.350642) + k*((25.242796) - (107.350642))/14)]],
            [for (k = [1 : 4]) [(-13.449735) + (8.752759)*cos((41.854616) + k*((23.634497) - (41.854616))/4), (5.595491) + (8.752759)*sin((41.854616) + k*((23.634497) - (41.854616))/4)]],
            [[-4.930772, 7.49527]],
            [[-4.430772, 2.841348]],
            [[-4.430772, -0.991269]],
            [[-9.130772, -0.991269]]));
    }
}

// ---- body 4 (strategy: instance_of body 3 — agent plan) ----
b4_offset = [27.494799, 0.001293, 0.00044];  // exact centroid delta body4-body3 (volumes match within 0.31 mm³ = 0.012%)

module body_4() {
    translate(b4_offset) body_3();
}

// full part = union of all bodies
body_0();
body_1();
body_2();
body_3();
body_4();
if (show_original) %import(original_stl);
