// e_nable_phoenix_hand_v3 — step2scad parametric reconstruction
// source: models/e_nable_phoenix_hand_v3.step
// rotate_extrude bodies: exact RZ profile from the B-rep coaxial faces;
// other strategies still use placeholder stubs (bbox) until their
// real emitters (section linear_extrude, CSG, loft) land.
// Every dimension below is an exact B-rep value from features.json.

// ---- body 0 (strategy: csg — placeholder bbox) ----
b0_min  = [-124.178496, -93.100225, -0.171648];  // exact B-rep bbox corner
b0_size = [95.056748, 87.003021, 6.067741];

module body_0() {
    translate(b0_min) cube(b0_size);
}

// ---- body 1 (strategy: freeform — placeholder bbox) ----
b1_min  = [-22.101853, -97.062851, -6.794532];  // exact B-rep bbox corner
b1_size = [83.678643, 94.136839, 35.402993];

module body_1() {
    translate(b1_min) cube(b1_size);
}

// ---- body 2 (strategy: freeform — placeholder bbox) ----
b2_min  = [77.291363, -97.062851, -4.794532];  // exact B-rep bbox corner
b2_size = [83.678643, 94.136839, 35.402993];

module body_2() {
    translate(b2_min) cube(b2_size);
}

// ---- body 3 (strategy: csg — placeholder bbox) ----
b3_min  = [-19.351525, 33.239495, -0.55037];  // exact B-rep bbox corner
b3_size = [6.75, 13.75, 4.860235];

module body_3() {
    translate(b3_min) cube(b3_size);
}

// ---- body 4 (strategy: csg — placeholder bbox) ----
b4_min  = [-52.43152, 52.900656, -0.618345];  // exact B-rep bbox corner
b4_size = [10.471107, 5.158869, 4.157756];

module body_4() {
    translate(b4_min) cube(b4_size);
}

// ---- body 5 (strategy: csg — placeholder bbox) ----
b5_min  = [-52.43152, 38.867791, -0.618345];  // exact B-rep bbox corner
b5_size = [10.471107, 5.158869, 4.157756];

module body_5() {
    translate(b5_min) cube(b5_size);
}

// ---- body 6 (strategy: csg — placeholder bbox) ----
b6_min  = [-19.351525, 51.668197, -0.55037];  // exact B-rep bbox corner
b6_size = [6.75, 13.75, 4.860235];

module body_6() {
    translate(b6_min) cube(b6_size);
}

// ---- body 7 (strategy: csg — placeholder bbox) ----
b7_min  = [-52.43152, 45.968759, -0.618345];  // exact B-rep bbox corner
b7_size = [10.471107, 5.158869, 4.157756];

module body_7() {
    translate(b7_min) cube(b7_size);
}

// ---- body 8 (strategy: csg — placeholder bbox) ----
b8_min  = [-53.366665, 63.350602, -0.621717];  // exact B-rep bbox corner
b8_size = [13.302543, 5.17941, 4.302773];

module body_8() {
    translate(b8_min) cube(b8_size);
}

// ---- body 9 (strategy: csg — placeholder bbox) ----
b9_min  = [-73.382035, 30.618759, -0.178952];  // exact B-rep bbox corner
b9_size = [5.517243, 13.017243, 3.317243];

module body_9() {
    translate(b9_min) cube(b9_size);
}

// ---- body 10 (strategy: csg — placeholder bbox) ----
b10_min  = [-52.43152, 32.104965, -0.618345];  // exact B-rep bbox corner
b10_size = [10.471107, 5.158869, 4.157756];

module body_10() {
    translate(b10_min) cube(b10_size);
}

// ---- body 11 (strategy: csg — placeholder bbox) ----
b11_min  = [-73.38205, 45.835103, -0.178968];  // exact B-rep bbox corner
b11_size = [5.517273, 13.017273, 3.317273];

module body_11() {
    translate(b11_min) cube(b11_size);
}

// ---- body 12 (strategy: rotate_extrude — exact RZ profile) ----
// revolution axis: through [-29.343531, 40.689707, -0.170331] along [0, 0, 1]; profile z measured from the axis low end
// Pappus check: profile revolves to 528.51 mm³ vs exact B-rep volume 531.63 mm³
b12_bore_r        = 2.7;  // exact B-rep: cylinder face(s) #2 radius (reversed -> bore)
b12_cbore_r       = 4.7;  // exact B-rep: cylinder face(s) #0 radius (reversed -> bore)
b12_total_h       = 3.75;  // exact B-rep: axial extent of the coaxial faces #0/#2/#3/#6/#7 (v-ranges)
b12_z_step1       = 2;  // exact B-rep: plane face(s) #1 height above the base
b12_cham1         = 0.5;  // exact B-rep: cone face(s) #7 (45° half-angle) radial width = axial height (45°)
b12_bore_bot_cham = 0.5;  // exact B-rep: cone face(s) #3 (45° half-angle) radial width = axial height (45°)
b12_fn            = 128;  // rotate_extrude curve resolution

module body_12() {
    // closed RZ boundary loop: up the bore, across the top,
    // down the outside, across the bottom (ring -> through-bore)
    translate([-29.343531, 40.689707, -0.170331]) rotate_extrude($fn = b12_fn)
        polygon(points = [
            [b12_bore_r + b12_bore_bot_cham, 0],      // cone face(s) #3
            [b12_bore_r, b12_bore_bot_cham],          // cone face(s) #3
            [b12_bore_r, b12_z_step1],                // cyl face(s) #2
            [b12_cbore_r, b12_z_step1],               // cyl face(s) #0
            [b12_cbore_r, b12_total_h],               // cyl face(s) #0
            [b12_cbore_r + b12_cham1, b12_total_h],   // arc face(s) #6
            [5.907046, 3.667087],                     // arc face(s) #6
            [6.575728, 3.422848],                     // arc face(s) #6
            [7.169764, 3.030533],                     // arc face(s) #6
            [7.656921, 2.511432],                     // arc face(s) #6
            [8.010766, 1.893709],                     // arc face(s) #6
            [8.212101, 1.210881],                     // arc face(s) #6
            [8.25, b12_cham1],                        // cone face(s) #7
            [7.75, 0]                                 // cone face(s) #7
        ]);
}

// ---- body 13 (strategy: csg — placeholder bbox) ----
b13_min  = [-74.936547, 63.540627, -0.691384];  // exact B-rep bbox corner
b13_size = [16, 5.5, 4.342105];

module body_13() {
    translate(b13_min) cube(b13_size);
}

// ---- body 14 (strategy: rotate_extrude — exact RZ profile) ----
// revolution axis: through [-29.343531, 58.103984, -0.170331] along [0, 0, 1]; profile z measured from the axis low end
// Pappus check: profile revolves to 528.51 mm³ vs exact B-rep volume 531.63 mm³
b14_bore_r        = 2.7;  // exact B-rep: cylinder face(s) #2 radius (reversed -> bore)
b14_cbore_r       = 4.7;  // exact B-rep: cylinder face(s) #0 radius (reversed -> bore)
b14_total_h       = 3.75;  // exact B-rep: axial extent of the coaxial faces #0/#2/#3/#6/#7 (v-ranges)
b14_z_step1       = 2;  // exact B-rep: plane face(s) #1 height above the base
b14_cham1         = 0.5;  // exact B-rep: cone face(s) #7 (45° half-angle) radial width = axial height (45°)
b14_bore_bot_cham = 0.5;  // exact B-rep: cone face(s) #3 (45° half-angle) radial width = axial height (45°)
b14_fn            = 128;  // rotate_extrude curve resolution

module body_14() {
    // closed RZ boundary loop: up the bore, across the top,
    // down the outside, across the bottom (ring -> through-bore)
    translate([-29.343531, 58.103984, -0.170331]) rotate_extrude($fn = b14_fn)
        polygon(points = [
            [b14_bore_r + b14_bore_bot_cham, 0],      // cone face(s) #3
            [b14_bore_r, b14_bore_bot_cham],          // cone face(s) #3
            [b14_bore_r, b14_z_step1],                // cyl face(s) #2
            [b14_cbore_r, b14_z_step1],               // cyl face(s) #0
            [b14_cbore_r, b14_total_h],               // cyl face(s) #0
            [b14_cbore_r + b14_cham1, b14_total_h],   // arc face(s) #6
            [5.907046, 3.667087],                     // arc face(s) #6
            [6.575728, 3.422848],                     // arc face(s) #6
            [7.169764, 3.030533],                     // arc face(s) #6
            [7.656921, 2.511432],                     // arc face(s) #6
            [8.010766, 1.893709],                     // arc face(s) #6
            [8.212101, 1.210881],                     // arc face(s) #6
            [8.25, b14_cham1],                        // cone face(s) #7
            [7.75, 0]                                 // cone face(s) #7
        ]);
}

// ---- body 15 (strategy: csg — placeholder bbox) ----
b15_min  = [-65.068443, 30.911146, -0.179582];  // exact B-rep bbox corner
b15_size = [5.518502, 27.018502, 3.318502];

module body_15() {
    translate(b15_min) cube(b15_size);
}

// ---- body 16 (strategy: freeform — placeholder bbox) ----
b16_min  = [120.416651, 42.875679, -0.171185];  // exact B-rep bbox corner
b16_size = [23.279483, 11.03386, 28.000708];

module body_16() {
    translate(b16_min) cube(b16_size);
}

// ---- body 17 (strategy: csg — placeholder bbox) ----
b17_min  = [129.512023, 56.820404, -0.830194];  // exact B-rep bbox corner
b17_size = [4.774776, 33.138091, 6.307427];

module body_17() {
    translate(b17_min) cube(b17_size);
}

// ---- body 18 (strategy: csg — placeholder bbox) ----
b18_min  = [135.388523, 56.820404, -0.830194];  // exact B-rep bbox corner
b18_size = [4.774776, 33.138091, 6.307427];

module body_18() {
    translate(b18_min) cube(b18_size);
}

// ---- body 19 (strategy: csg — placeholder bbox) ----
b19_min  = [123.635523, 56.820404, -0.830194];  // exact B-rep bbox corner
b19_size = [4.774776, 33.138091, 6.307427];

module body_19() {
    translate(b19_min) cube(b19_size);
}

// ---- body 20 (strategy: csg — placeholder bbox) ----
b20_min  = [135.388523, 56.820404, -0.830194];  // exact B-rep bbox corner
b20_size = [4.774776, 33.138091, 6.307427];

module body_20() {
    translate(b20_min) cube(b20_size);
}

// ---- body 21 (strategy: csg — placeholder bbox) ----
b21_min  = [123.635523, 56.820404, -0.830194];  // exact B-rep bbox corner
b21_size = [4.774776, 33.138091, 6.307427];

module body_21() {
    translate(b21_min) cube(b21_size);
}

// ---- body 22 (strategy: freeform — placeholder bbox) ----
b22_min  = [75.428431, 54.832391, -0.174253];  // exact B-rep bbox corner
b22_size = [12.508699, 35.527209, 16.162975];

module body_22() {
    translate(b22_min) cube(b22_size);
}

// ---- body 23 (strategy: freeform — placeholder bbox) ----
b23_min  = [47.933764, 54.832391, -0.174253];  // exact B-rep bbox corner
b23_size = [12.508699, 35.527209, 16.162975];

module body_23() {
    translate(b23_min) cube(b23_size);
}

// ---- body 24 (strategy: freeform — placeholder bbox) ----
b24_min  = [30.502865, 55.496004, -0.179055];  // exact B-rep bbox corner
b24_size = [16.381386, 35.536829, 17.206394];

module body_24() {
    translate(b24_min) cube(b24_size);
}

// ---- body 25 (strategy: freeform — placeholder bbox) ----
b25_min  = [61.681098, 54.832391, -0.174253];  // exact B-rep bbox corner
b25_size = [12.508699, 35.527209, 16.162975];

module body_25() {
    translate(b25_min) cube(b25_size);
}

// ---- body 26 (strategy: freeform — placeholder bbox) ----
b26_min  = [89.175764, 54.832391, -0.174253];  // exact B-rep bbox corner
b26_size = [12.508699, 35.527209, 16.162975];

module body_26() {
    translate(b26_min) cube(b26_size);
}

// ---- body 27 (strategy: freeform — placeholder bbox) ----
b27_min  = [32.578675, 5.479219, -1.200157];  // exact B-rep bbox corner
b27_size = [16.376185, 44.145275, 16.268011];

module body_27() {
    translate(b27_min) cube(b27_size);
}

// ---- body 28 (strategy: freeform — placeholder bbox) ----
b28_min  = [49.662157, 4.978203, -1.282171];  // exact B-rep bbox corner
b28_size = [11.493112, 44.132592, 16.462427];

module body_28() {
    translate(b28_min) cube(b28_size);
}

// ---- body 29 (strategy: freeform — placeholder bbox) ----
b29_min  = [87.623785, 5.49091, -1.019067];  // exact B-rep bbox corner
b29_size = [11.460791, 40.209091, 15.156517];

module body_29() {
    translate(b29_min) cube(b29_size);
}

// ---- body 30 (strategy: freeform — placeholder bbox) ----
b30_min  = [75.292924, 5.49091, -1.019067];  // exact B-rep bbox corner
b30_size = [11.460791, 40.209091, 15.156517];

module body_30() {
    translate(b30_min) cube(b30_size);
}

// ---- body 31 (strategy: freeform — placeholder bbox) ----
b31_min  = [62.76934, 4.978203, -1.282171];  // exact B-rep bbox corner
b31_size = [11.493112, 44.132592, 16.462427];

module body_31() {
    translate(b31_min) cube(b31_size);
}

// full part = union of all bodies
body_0();
body_1();
body_2();
body_3();
body_4();
body_5();
body_6();
body_7();
body_8();
body_9();
body_10();
body_11();
body_12();
body_13();
body_14();
body_15();
body_16();
body_17();
body_18();
body_19();
body_20();
body_21();
body_22();
body_23();
body_24();
body_25();
body_26();
body_27();
body_28();
body_29();
body_30();
body_31();
