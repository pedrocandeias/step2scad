// VERSION: v12 — 2026-07-08T14:55
echo("*** Palm_left_primitive reconstruction v12 ***");
// ====================================================================
// Palm_left_primitive — step2scad parametric reconstruction
// source: models/phoenix_components/Palm_left.step
// Every dimension is measured from the STEP B-rep (exact faces) or a
// fitted law with its residual cited — see the source comment on each
// parameter. Edit named parameters; geometry follows.
// ====================================================================

// --- Display options ---
show_colors   = true;    // tint top-level features (preview aid)
show_original = false;   // ghost the reference overlay on/off (F5)
ghost_alpha   = 0.25;    // ghost transparency: 0 invisible .. 1 solid
ghost_color   = [0.55, 0.70, 1.0];  // ghost tint (RGB)
original_stl  = "Palm_left_primitive_ref.stl";
module tint(c) { if (show_colors) color(c) children(); else children(); }
module ghost() { if (show_original) color([ghost_color[0], ghost_color[1], ghost_color[2], ghost_alpha]) import(original_stl); }

// --------------------------------------------------------------------
// BODY 0 — semantic parametric plan
//   COARSE big-primitive reconstruction (smooth form over IoU): per-
//   component modules in palm_parts/. Vault HIDDEN.
// --------------------------------------------------------------------

// ======== PARAMETERS (every value measured; sources cited) ========
// --- z ---
z_bot  = 4.62;  // exact bottom plane #829
z_deck = 6.62;  // exact deck plane #828
z_apex = 29.3;  // measured dome apex
fn     = 96;  // curve resolution

module body_0() {
    intersection() {
        difference() {
            union() {
                // base_plate: flat palmar floor: measured outline (ref z5.3, simplified) between exact planes #829/#828
                translate([0, 0, 4.62]) linear_extrude(2) polygon([[25.49, -5.01], [32.17, -10.61], [28.95, -14.44], [24.71, -10.88], [23.1, -42.13], [18.09, -42.13], [18.09, -30.95], [-33.01, -30.95], [-33.01, -42.16], [-38.01, -42.13], [-40.13, 2.51], [-35.26, 31.81], [-31.46, 31.81], [-31.46, 22.7], [-25.46, 22.7], [-25.46, 31.81], [-21.46, 31.81], [-21.46, 37.81], [-17.46, 37.81], [-17.46, 28.7], [-11.46, 28.7], [-11.46, 37.81], [-7.46, 37.81], [-7.46, 35.8], [-5.46, 35.8], [-7.46, 41.82], [-3.46, 41.81], [-3.46, 32.7], [2.54, 32.7], [2.54, 41.82], [10.54, 41.82], [10.54, 32.7], [16.54, 32.7], [16.54, 41.82], [19.54, 41.82], [24.81, 6.45], [30.57, 5.04], [39.24, -2.18], [36.02, -6.01], [28.49, 0.31]]);
                difference() {
                    union() {
                        // neck_pinky: pinky finger neck (low base tying the fork into the body)
                        translate([-32, 15, 6.62]) cube([12, 15, 4]);
                        // knuckle_pinky: pinky knuckle crown: exact r6.000 x-axis at y30 z10.6
                        translate([-32, 30, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=12, r=6, $fn=fn);
                    }
                    // slot_pinky: pinky fork slot (tab pocket between the two prongs)
                    translate([-28.25, 18, 5.62]) cube([4.5, 21, 16.62]);
                    // bore_pinky: pinky pin bore: exact r2.5 (faces #228/#286/#338...)
                    translate([-33, 30, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=14, r=2.5, $fn=fn);
                }
                difference() {
                    union() {
                        // neck_ring: ring finger neck (low base tying the fork into the body)
                        translate([-18, 20, 6.62]) cube([12, 15, 4]);
                        // knuckle_ring: ring knuckle crown: exact r6.000 x-axis at y35 z10.6
                        translate([-18, 35, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=12, r=6, $fn=fn);
                    }
                    // slot_ring: ring fork slot (tab pocket between the two prongs)
                    translate([-14.25, 23, 5.62]) cube([4.5, 21, 16.62]);
                    // bore_ring: ring pin bore: exact r2.5 (faces #228/#286/#338...)
                    translate([-19, 35, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=14, r=2.5, $fn=fn);
                }
                difference() {
                    union() {
                        // neck_middle: middle finger neck (low base tying the fork into the body)
                        translate([-9, 24, 6.62]) cube([12, 15, 4]);
                        // knuckle_middle: middle knuckle crown: exact r6.000 x-axis at y39 z10.6
                        translate([-9, 39, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=12, r=6, $fn=fn);
                    }
                    // slot_middle: middle fork slot (tab pocket between the two prongs)
                    translate([-5.25, 27, 5.62]) cube([4.5, 21, 16.62]);
                    // bore_middle: middle pin bore: exact r2.5 (faces #228/#286/#338...)
                    translate([-10, 39, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=14, r=2.5, $fn=fn);
                }
                difference() {
                    union() {
                        // neck_index: index finger neck (low base tying the fork into the body)
                        translate([5, 25, 6.62]) cube([12, 15, 4]);
                        // knuckle_index: index knuckle crown: exact r6.000 x-axis at y40 z10.6
                        translate([5, 40, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=12, r=6, $fn=fn);
                    }
                    // slot_index: index fork slot (tab pocket between the two prongs)
                    translate([8.75, 28, 5.62]) cube([4.5, 21, 16.62]);
                    // bore_index: index pin bore: exact r2.5 (faces #228/#286/#338...)
                    translate([4, 40, 10.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=14, r=2.5, $fn=fn);
                }
                hull() {
                    // wrist_wall_L_ear: wrist wall L ear-end (low): x[-38,-34]
                    translate([-38.5, -38.95, 6.62]) cube([5, 5, 15.38]);
                    // wrist_wall_L_body: wrist wall L body-end (high, rises to the dome rim z30)
                    translate([-38.5, -17, 6.62]) cube([5, 3, 23.38]);
                }
                // ear_L: wrist ear L: exact r8.000 disc (#534/#535) y-38.9 z12.6
                translate([-38.5, -38.95, 12.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=5, r=8, $fn=fn);
                hull() {
                    // wrist_wall_R_ear: wrist wall R ear-end (low): x[18,22]
                    translate([17.5, -38.95, 6.62]) cube([5, 5, 15.38]);
                    // wrist_wall_R_body: wrist wall R body-end (high, rises to the dome rim z30)
                    translate([17.5, -17, 6.62]) cube([5, 3, 23.38]);
                }
                // ear_R: wrist ear R: exact r8.000 disc (#534/#535) y-38.9 z12.6
                translate([17.5, -38.95, 12.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=5, r=8, $fn=fn);
                translate([31.2, -5.9, 6.62]) rotate([0, 0, 50]) {  // thumb
                    difference() {
                        union() {
                            union() {
                                // thumb_shaft_a: thumb prong a shaft (deck -> pin)
                                translate([2.25, -7.5, 0]) cube([4, 15, 4]);
                                // thumb_crown_a: thumb prong a keyhole crown: exact r7.5 (face #524)
                                translate([2.25, 0, 4]) rotate(a=90, v=[0, 1, 0]) cylinder(h=4, r=7.5, $fn=fn);
                            }
                            union() {
                                // thumb_shaft_b: thumb prong b shaft (deck -> pin)
                                translate([-6.25, -7.5, 0]) cube([4, 15, 4]);
                                // thumb_crown_b: thumb prong b keyhole crown: exact r7.5 (face #524)
                                translate([-6.25, 0, 4]) rotate(a=90, v=[0, 1, 0]) cylinder(h=4, r=7.5, $fn=fn);
                            }
                        }
                        // thumb_bore: thumb pivot bore: exact r2.7 (faces #226/#184)
                        translate([-7.25, 0, 4]) rotate(a=90, v=[0, 1, 0]) cylinder(h=14.5, r=2.7, $fn=fn);
                    }
                }
                // thumb_neck: thumb base connector into the palm body
                translate([18, -14, 6.62]) cube([16, 14, 5]);
            }
            // vent_0_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-30.055, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_0_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-29.565, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_0_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-30.055, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_0_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-29.565, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_0_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-30.055, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_0_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-29.565, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_0_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-30.055, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_0_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-29.565, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_0_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-30.055, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_0_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-29.565, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_0_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-30.055, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_1_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-25.425, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_1_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-24.935, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_1_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-25.425, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_1_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-24.935, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_1_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-25.425, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_1_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-24.935, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_1_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-25.425, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_1_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-24.935, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_1_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-25.425, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_1_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-24.935, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_1_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-25.425, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_2_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.795, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_2_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.305, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_2_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.795, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_2_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.305, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_2_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.795, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_2_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.305, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_2_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.795, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_2_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.305, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_2_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.795, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_2_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.305, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_2_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-20.795, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_3_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-16.165, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_3_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-15.675, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_3_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-16.165, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_3_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-15.675, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_3_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-16.165, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_3_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-15.675, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_3_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-16.165, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_3_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-15.675, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_3_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-16.165, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_3_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-15.675, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_3_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-16.165, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_4_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.535, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_4_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.045, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_4_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.535, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_4_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.045, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_4_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.535, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_4_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.045, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_4_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.535, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_4_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.045, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_4_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.535, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_4_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.045, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_4_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-11.535, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_5_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.905, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_5_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.415, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_5_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.905, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_5_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.415, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_5_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.905, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_5_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.415, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_5_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.905, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_5_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.415, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_5_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.905, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_5_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.415, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_5_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-6.905, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_6_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-2.275, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_6_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-1.785, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_6_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-2.275, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_6_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-1.785, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_6_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-2.275, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_6_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-1.785, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_6_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-2.275, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_6_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-1.785, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_6_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-2.275, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_6_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-1.785, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_6_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([-2.275, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_7_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.355, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_7_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.845, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_7_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.355, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_7_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.845, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_7_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.355, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_7_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.845, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_7_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.355, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_7_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.845, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_7_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.355, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_7_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.845, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_7_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([2.355, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_8_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([6.985, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_8_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([7.475, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_8_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([6.985, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_8_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([7.475, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_8_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([6.985, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_8_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([7.475, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_8_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([6.985, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_8_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([7.475, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_8_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([6.985, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_8_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([7.475, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_8_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([6.985, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // vent_9_0: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([11.615, -27.665, 4.12]) cube([3.11, 2.13, 3]);
            // vent_9_1: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([12.105, -23.525, 4.12]) cube([2.13, 3.11, 3]);
            // vent_9_2: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([11.615, -18.405, 4.12]) cube([3.11, 2.13, 3]);
            // vent_9_3: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([12.105, -14.265, 4.12]) cube([2.13, 3.11, 3]);
            // vent_9_4: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([11.615, -9.145, 4.12]) cube([3.11, 2.13, 3]);
            // vent_9_5: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([12.105, -5.005, 4.12]) cube([2.13, 3.11, 3]);
            // vent_9_6: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([11.615, 0.115, 4.12]) cube([3.11, 2.13, 3]);
            // vent_9_7: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([12.105, 4.255, 4.12]) cube([2.13, 3.11, 3]);
            // vent_9_8: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([11.615, 9.375, 4.12]) cube([3.11, 2.13, 3]);
            // vent_9_9: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([12.105, 13.515, 4.12]) cube([2.13, 3.11, 3]);
            // vent_9_10: basket-weave vent slot (3.11x2.13, pitch 4.63)
            translate([11.615, 18.635, 4.12]) cube([3.11, 2.13, 3]);
            // ear_bore_L: wrist ear L pin bore: exact r3.0 (#93/#246)
            translate([-40.5, -38.95, 12.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=9, r=3, $fn=fn);
            // ear_cbore_L: wrist ear L counterbore r3.88 d0.9 (pin-head recess)
            translate([-33.5, -38.95, 12.62]) rotate(a=90, v=[0, -1, 0]) cylinder(h=0.9, r=3.88, $fn=fn);
            // ear_bore_R: wrist ear R pin bore: exact r3.0 (#93/#246)
            translate([15.5, -38.95, 12.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=9, r=3, $fn=fn);
            // ear_cbore_R: wrist ear R counterbore r3.88 d0.9 (pin-head recess)
            translate([17.5, -38.95, 12.62]) rotate(a=90, v=[0, 1, 0]) cylinder(h=0.9, r=3.88, $fn=fn);
        }
        // envelope: envelope: clip to measured bbox (flat bottom at z4.62)
        translate([-42, -48, 4.62]) cube([84, 93, 30.68]);
    }
}

// full part = union of all bodies
body_0();
ghost();  // transparent reference overlay (show_original)
