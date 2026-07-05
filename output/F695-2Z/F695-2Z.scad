// F695-2Z — step2scad parametric reconstruction
// source: models/F695-2Z.step
// rotate_extrude bodies: exact RZ profile from the B-rep coaxial faces;
// csg / instance_of bodies: agent-authored measured plan (plan.json);
// strategies without a real emitter yet use placeholder stubs (bbox).
// Every dimension below is an exact B-rep value from features.json.

// ---- body 0 (strategy: rotate_extrude — exact RZ profile) ----
// revolution axis: through [0, 0, 0] along [0, 0, 1]; profile z measured from the axis low end
// Pappus check: profile revolves to 495.39 mm³ vs exact B-rep volume 495.39 mm³
bore_r         = 2.5;  // exact B-rep: cylinder face(s) #5/#10 radius (reversed -> bore)
od_r           = 6.5;  // exact B-rep: cylinder face(s) #4/#11 radius
flange_r       = 7.5;  // exact B-rep: cylinder face(s) #6/#7 radius
total_h        = 4;  // exact B-rep: axial extent of the coaxial faces #0/#1/#2/#3/#4/#5/#6/#7/#10/#11/#13/#14/#15/#16 (v-ranges)
flange_h       = 1;  // exact B-rep: flange band height, cylinder face(s) #6/#7 axial extent (plane face(s) #8 step)
flange_od_cham = 0.25;  // exact B-rep: cone face(s) #0/#16 (45° half-angle) radial width = axial height (45°)
od_top_cham    = 0.25;  // exact B-rep: cone face(s) #1/#15 (45° half-angle) radial width = axial height (45°)
bore_bot_cham  = 0.25;  // exact B-rep: cone face(s) #3/#13 (45° half-angle) radial width = axial height (45°)
bore_top_cham  = 0.25;  // exact B-rep: cone face(s) #2/#14 (45° half-angle) radial width = axial height (45°)
fn             = 128;  // rotate_extrude curve resolution

module body_0() {
    // closed RZ boundary loop: up the bore, across the top,
    // down the outside, across the bottom (ring -> through-bore)
    rotate_extrude($fn = fn)
        polygon(points = [
            [bore_r + bore_bot_cham, 0],         // cone face(s) #3/#13
            [bore_r, bore_bot_cham],             // cone face(s) #3/#13
            [bore_r, total_h - bore_top_cham],   // cyl face(s) #5/#10
            [bore_r + bore_top_cham, total_h],   // cone face(s) #2/#14
            [od_r - od_top_cham, total_h],       // cone face(s) #1/#15
            [od_r, total_h - od_top_cham],       // cyl face(s) #4/#11
            [od_r, flange_h + flange_od_cham],   // cone face(s) #0/#16
            [od_r + flange_od_cham, flange_h],   // cone face(s) #0/#16
            [flange_r, flange_h],                // cyl face(s) #6/#7
            [flange_r, 0]                        // cyl face(s) #6/#7
        ]);
}

// full part = union of all bodies
body_0();
