// Arm_Guard — step2scad parametric reconstruction
// source: models/phoenix_components/Arm_Guard.step
// rotate_extrude bodies: exact RZ profile from the B-rep coaxial faces;
// csg / instance_of bodies: agent-authored measured plan (plan.json);
// strategies without a real emitter yet use placeholder stubs (bbox).
// Every dimension below is an exact B-rep value from features.json.

// ---- body 0 (strategy: csg — semantic parametric plan) ----
// plan: semantic parametric form: named z levels, parametric strap-slot module (4 instances), plate as two exact-z layers, organic deck/ridge staircase preserved as measured profiles; hole-edge chamfers deliberately omitted (sub-1% volume)

// ======== PARAMETERS (every value measured; see source comments) ========
z_base          = 0.001317;  // exact B-rep bottom plane level
z_plate_step    = 0.901317;  // exact B-rep plane: outline steps in at this level
z_plate_top     = 1.401317;  // exact B-rep plane: top of the flat plate, deck pads start
slot_r          = 2;  // exact r2.0 slot end-cap cylinder faces #30/#32/#45/#52/#83/#128/#141/#150
z_slot_top      = 2.806317;  // highest measured band pierced by the strap slots
z_window_top    = 3.806317;  // highest measured band pierced by the mount pin windows
z_cut_lo        = -0.498683;  // cut overshoot below the base plane (declared, 0.5)
rim_cham_d0     = -0.5;  // EXACT 45-deg bottom edge chamfer: cone faces #93/#114 span r 7.495->7.995 (fitted rim insets agreed: slope res 0.000)
rim_cham_d1     = 0;  // exact: chamfer vanishes at its top level
z_rim_top       = 0.501317;  // EXACT cone faces #93/#114 upper extent (z=0.5013)
slot_len        = 20;  // distance between exact end-cap axes + 2*slot_r (faces #30/#32/#45/#52/#83/#128/#141/#150); identical for all four slots within 0.02
slot_ang        = 8.578065;  // slot line angle from +Y (exact end-cap axes); the right side mirrors the left exactly
slot_low_cx     = -40.035489;  // midpoint of the lower-left slot's exact end-cap axes
slot_low_cy     = -27.612057;  // midpoint of the lower-left slot's exact end-cap axes
slot_high_cx    = -35.041098;  // midpoint of the upper-left slot's exact end-cap axes
slot_high_cy    = 5.497538;  // midpoint of the upper-left slot's exact end-cap axes
ridge_hw        = 4.999003;  // measured ridge half-width (constant across all 16 bands)
ridge_head_cy   = 6.499411;  // stadium head-cap center: measured head apex - ridge_hw
z_ridge_top     = 4.881293;  // exact B-rep plane: ridge crest top
z_ridge_plateau = 2.881317;  // exact B-rep band level: tail plateau height
ridge_tail_m    = 0.98156;  // measured 45-deg tail ramp slope (linear fit, res 0.054)
ridge_tail_b    = 44.295174;  // measured tail ramp intercept (same fit)
ridge_arc_yc    = -19.66685;  // main ramp fitted circular arc center y (res 0.005 over 9 bands)
ridge_arc_zc    = -12.441152;  // main ramp arc center z (same fit)
ridge_arc_R     = 17.447744;  // main ramp arc radius (same fit)
ridge_head_yc   = 2.413537;  // head taper fitted arc center y (res 0.019)
ridge_head_zc   = -14.745093;  // head taper arc center z (same fit)
ridge_head_R    = 20.433983;  // head taper arc radius (same fit)
ridge_tail_y0   = -43.699683;  // derived: tail ramp meets the plate top (from the fit)
ridge_tail_y1   = -42.191879;  // derived: tail ramp reaches the plateau (from the fit)
ridge_arc_y0    = -28.012252;  // derived: main arc leaves the plateau level
ridge_arc_y1    = -21.75412;  // derived: main arc reaches the crest height
ridge_head_y0   = 8.101476;  // derived: head taper leaves the crest height
wing_x_cut      = 14.2;  // measured wing inner boundary (decimated to one straight vertical segment in the band footprint)
z_wing_top      = 1.801317;  // exact B-rep plane level: top of the wing zone
z_rail_top      = 2.801317;  // exact B-rep plane level: top of the rail strips
rail_d0         = 0.125;  // 45-deg rail edge law: offset at the wing top (uniform-shrink measurement, std 0.012)
rail_d1         = -0.875;  // 45-deg rail edge law: offset at the rail top (same measurement)
mount_y         = 35.5048;  // exact mount cylinder faces #92/#98 axis y
mountL_x        = -30.145;  // exact mount cylinder face #98 axis x
mountR_x        = 30.145;  // exact mount cylinder face #92 axis x
mount_r         = 7.995;  // exact mount cylinder faces #92/#98 radius
z_blend0        = 2.80145;  // exact: 45° cone faces #29/#105 meet the mount cylinder
mount_rb0       = 7.995;  // exact mount cylinder radius (blend tangent)
z_blend1        = 2.881317;  // exact B-rep plane level (mount top-blend band)
mount_rb1       = 7.972472;  // measured: mount top-blend circle fit at this level
z_blend2        = 3.111317;  // exact B-rep plane level (mount top-blend band)
mount_rb2       = 7.900118;  // measured: mount top-blend circle fit at this level
z_blend3        = 3.341317;  // exact B-rep plane level (mount top-blend band)
mount_rb3       = 7.778773;  // measured: mount top-blend circle fit at this level
z_blend4        = 3.571317;  // exact B-rep plane level (mount top-blend band)
mount_rb4       = 7.544214;  // measured: mount top-blend circle fit at this level
z_blend5        = 3.801317;  // exact B-rep plane: top of the knuckle mounts
mount_rb5       = 7.233536;  // measured: mount top-blend circle fit at this level
fn              = 96;  // curve resolution

plate_outline_pts = concat(
            [[17.209561, 23.427638]],
            [[13.517863, 22.40354]],
            [[9.056721, 21.547144]],
            [[4.540879, 21.054822]],
            [[0, 20.929808]],
            [[-4.540879, 21.054822]],
            [[-9.056721, 21.547144]],
            [[-13.517863, 22.40354]],
            [[-17.971605, 23.644558]],
            [[-22.15, 25.179808]],
            [[-22.15, 35.504807]],
            [[-22.213021, 36.494304]],
            [[-22.390125, 37.443184]],
            [[-22.680311, 38.363798]],
            [[-23.079351, 39.24272]],
            [[-23.581424, 40.067138]],
            [[-24.179207, 40.825024]],
            [[-24.863986, 41.505331]],
            [[-25.625774, 42.098137]],
            [[-26.453463, 42.594794]],
            [[-27.334982, 42.988068]],
            [[-28.257476, 43.272216]],
            [[-29.207496, 43.443097]],
            [[-30.171188, 43.498221]],
            [[-31.134496, 43.436784]],
            [[-32.083378, 43.259682]],
            [[-33.003988, 42.969495]],
            [[-33.882914, 42.570454]],
            [[-34.707328, 42.068384]],
            [[-35.465218, 41.4706]],
            [[-36.145525, 40.785821]],
            [[-36.738327, 40.024034]],
            [[-37.234988, 39.196344]],
            [[-37.628262, 38.314827]],
            [for (k = [1 : 4]) [(-30.145) + (7.995)*cos((159.418474) + k*((181.419865) - (159.418474))/4), (35.504807) + (7.995)*sin((159.418474) + k*((181.419865) - (159.418474))/4)]],
            [[-38.139999, 25.179935]],
            [[-47.463061, -36.640552]],
            [for (k = [1 : 16]) [(-41.527057) + (6)*cos((171.75982) + k*((263.296522) - (171.75982))/16), (-37.500193) + (6)*sin((171.75982) + k*((263.296522) - (171.75982))/16)]],
            [[-39.622416, -43.500195]],
            [[41.527058, -43.500195]],
            [for (k = [1 : 17]) [(41.527057) + (6)*cos((-89.999988) + k*((8.578075) - (-89.999988))/17), (-37.500193) + (6)*sin((-89.999988) + k*((8.578075) - (-89.999988))/17)]],
            [[38.139999, 25.179935]],
            [[38.138415, 35.530994]],
            [[38.076978, 36.494304]],
            [[37.899876, 37.443184]],
            [[37.609689, 38.363798]],
            [[37.210648, 39.24272]],
            [[36.708575, 40.067138]],
            [[36.110794, 40.825024]],
            [[35.426015, 41.505331]],
            [[34.664225, 42.098137]],
            [[33.836538, 42.594794]],
            [[32.955017, 42.988068]],
            [[32.032525, 43.272216]],
            [[31.082503, 43.443097]],
            [[30.118813, 43.498221]],
            [[29.155503, 43.436784]],
            [[28.206623, 43.259682]],
            [[27.286011, 42.969495]],
            [[26.407087, 42.570454]],
            [[25.582671, 42.068384]],
            [[24.824783, 41.4706]],
            [[24.144476, 40.785821]],
            [[23.551672, 40.024034]],
            [[23.055011, 39.196344]],
            [[22.661739, 38.314827]],
            [for (k = [1 : 4]) [(30.145) + (7.995)*cos((159.418471) + k*((181.419864) - (159.418471))/4), (35.504807) + (7.995)*sin((159.418471) + k*((181.419864) - (159.418471))/4)]],
            [[22.15, 25.179808]]);  // vectorized measured outline: 64 lines + 4 fitted arcs (4 snapped to exact B-rep faces), fit tol 0.06
plate_upper_outline_pts = concat(
            [[-22.15, 35.504807]],
            [for (k = [1 : 29]) [(-30.145) + (7.995)*cos((-0.000001) + k*((173.076922) - (-0.000001))/29), (35.504807) + (7.995)*sin((-0.000001) + k*((173.076922) - (-0.000001))/29)]],
            [[-38.139999, 33.840197]],
            [[-38.139999, 25.179935]],
            [[-47.524899, -37.339291]],
            [[-47.383793, -38.80352]],
            [[-46.890648, -40.189411]],
            [[-46.075111, -41.413658]],
            [[-44.986198, -42.402676]],
            [for (k = [1 : 6]) [(-41.527057) + (6)*cos((-125.206397) + k*((-90.000012) - (-125.206397))/6), (-37.500193) + (6)*sin((-125.206397) + k*((-90.000012) - (-125.206397))/6)]],
            [[42.262566, -43.454941]],
            [for (k = [1 : 16]) [(41.527057) + (6)*cos((-82.958693) + k*((8.578075) - (-82.958693))/16), (-37.500193) + (6)*sin((-82.958693) + k*((8.578075) - (-82.958693))/16)]],
            [[38.139999, 25.179935]],
            [[38.126693, 35.72478]],
            [[38.041983, 36.685264]],
            [[37.842118, 37.628534]],
            [[37.530011, 38.540835]],
            [[37.110211, 39.408862]],
            [[36.588845, 40.219962]],
            [[35.973515, 40.962302]],
            [[35.27319, 41.625061]],
            [[34.498083, 42.198573]],
            [[33.6595, 42.674472]],
            [[32.769667, 43.045825]],
            [[31.841563, 43.30721]],
            [[30.888716, 43.454819]],
            [[29.925025, 43.486499]],
            [[28.964541, 43.401789]],
            [[28.021272, 43.201924]],
            [[27.108972, 42.889816]],
            [[26.240944, 42.470017]],
            [[25.429845, 41.948653]],
            [[24.687503, 41.33332]],
            [[24.024745, 40.632995]],
            [[23.451234, 39.85789]],
            [[22.975333, 39.019306]],
            [for (k = [1 : 6]) [(31.770443) + (9.685566)*cos((155.300148) + k*((186.721709) - (155.300148))/6), (34.974035) + (9.685566)*sin((155.300148) + k*((186.721709) - (155.300148))/6)]],
            [[22.15, 25.179808]],
            [[18.595729, 23.856697]],
            [[17.565132, 23.51495]],
            [[13.687762, 22.443694]],
            [[13.140935, 20.781752]],
            [[12.393351, 19.199631]],
            [[11.456145, 17.721958]],
            [[10.343673, 16.371352]],
            [[9.072973, 15.168483]],
            [[7.663508, 14.131758]],
            [[6.136863, 13.277036]],
            [[4.098018, 12.486921]],
            [[2.395911, 12.083802]],
            [[0.656692, 11.893937]],
            [[-1.092893, 11.920339]],
            [[-2.825631, 12.162575]],
            [[-4.51526, 12.616954]],
            [[-6.135906, 13.276534]],
            [[-7.662745, 14.131232]],
            [[-9.072396, 15.167971]],
            [[-10.343263, 16.37089]],
            [[-11.455882, 17.721577]],
            [[-12.393208, 19.199357]],
            [[-13.140881, 20.781608]],
            [[-13.687762, 22.443694]],
            [[-17.565132, 23.51495]],
            [[-22.15, 25.179808]]);  // vectorized measured outline: 60 lines + 4 fitted arcs (3 snapped to exact B-rep faces), fit tol 0.06
rail_strip_base_pts = concat(
            [[27.969382, 15.371081]],
            [[28.366122, 16.456177]],
            [[29.007538, 17.417408]],
            [[29.857544, 18.200528]],
            [for (k = [1 : 6]) [(34.301538) + (8.808323)*cos((120.340034) + k*((87.649283) - (120.340034))/6), (10.607728) + (8.808323)*sin((120.340034) + k*((87.649283) - (120.340034))/6)]],
            [[35.810878, 19.286508]],
            [[36.895974, 18.889768]],
            [[37.857206, 18.248352]],
            [[38.640323, 17.398346]],
            [[39.201129, 16.387627]],
            [[39.507967, 15.273156]],
            [[47.343068, -36.699068]],
            [for (k = [1 : 30]) [(41.526803) + (5.871506)*cos((7.849692) + k*((-171.429306) - (7.849692))/30), (-37.500937) + (5.871506)*sin((7.849692) + k*((-171.429306) - (7.849692))/30)]],
            [[27.839572, 14.22334]]);  // vectorized measured outline: 12 lines + 2 fitted arcs (0 snapped to exact B-rep faces), fit tol 0.06
ridge_xsec_profile = [[1.401317, 4.997073], [1.481318, 4.997073], [2.881317, 3.597073], [2.881423, 3.388492], [4.893784, 4.804987], [4.883905, -4.792342], [2.881317, -3.381528], [2.881317, -3.580863], [1.470912, -4.980864], [1.401317, -4.980864]];  // (z, x) points — measured constant (x,z) cross-section (hourglass: ±5.0 base, ±3.60 waist at z=2.9, ±4.81 crest) — verified identical at y=-5/0/+4 on the reference tessellation

// strap slot at the origin, long axis +Y: capsule = hull of the two end-cap cylinders; slot_r sets width (4 = 2*slot_r), slot_len the length, z_slot_top the depth. Instances are placed by translate+rotate and the right side by mirror.
module strap_slot() {
    hull() {
        // cap0: slot end cap (exact r2.0 cylinder faces)
        translate([0, slot_len/2 - slot_r, z_cut_lo]) cylinder(h=(z_slot_top) - (z_cut_lo), r=slot_r, $fn=fn);
        // cap1: slot end cap (exact r2.0 cylinder faces)
        translate([0, -(slot_len/2 - slot_r), z_cut_lo]) cylinder(h=(z_slot_top) - (z_cut_lo), r=slot_r, $fn=fn);
    }
}

// base plate: measured outline in two layers between exact z levels (the outline includes the two r7.995 knuckle-mount lobes at (±30.145, 35.505))
module plate() {
    union() {
        // plate_rim_chamfer: bottom edge 45-deg chamfer: linear offset law fitted to the measured rim band insets (residual in params)
        minkowski() {
            translate([0, 0, z_base]) linear_extrude(0.001) offset(delta = min(rim_cham_d0, rim_cham_d1)) polygon(plate_outline_pts);
            cylinder(h = (z_rim_top) - (z_base), r1 = (rim_cham_d0) - (min(rim_cham_d0, rim_cham_d1)) + 0.0005, r2 = (rim_cham_d1) - (min(rim_cham_d0, rim_cham_d1)) + 0.0005, $fn = fn);
        }
        // plate_main: plate main body: shared measured outline — measured section loops at z=0.563817 for the band between exact B-rep plane levels z=0.451317 and z=0.676317
        translate([0, 0, 0.451317]) linear_extrude((z_plate_step) - (0.451317)) polygon(plate_outline_pts);
        // plate_upper: plate upper layer (outline after the step) — measured section loops at z=1.026317 for the band between exact B-rep plane levels z=0.901317 and z=1.151317
        translate([0, 0, z_plate_step]) linear_extrude((z_plate_top) - (z_plate_step)) polygon(plate_upper_outline_pts);
    }
}

// knuckle-mount post: exact r7.995 cylinder up to the exact blend-start level, then the convex top blend as measured frustum segments between exact B-rep plane levels (the true face is a torus fillet; radii are band circle-fit values)
module knuckle_mount(cx) {
    union() {
        // post: exact cylinder faces #92/#98 (r=7.995) at y=35.5048
        translate([cx, mount_y, z_plate_top]) cylinder(h=(z_blend0) - (z_plate_top), r=mount_r, $fn=fn);
        // skirt: EXACT 45-deg skirt: cone faces #29/#105 span r 8.995@z1.8013 -> 7.995@z2.8014 (skirt band circles matched the cone law to 0.005)
        translate([cx, mount_y, z_wing_top]) cylinder(h=(z_blend0) - (z_wing_top), r1=mount_r + 1.0, r2=mount_r, $fn=fn);
        // blend0: mount top blend segment (measured frustum between exact plane levels; true face is a torus fillet)
        translate([cx, mount_y, z_blend0]) cylinder(h=(z_blend1) - (z_blend0), r1=mount_rb0, r2=mount_rb1, $fn=fn);
        // blend1: mount top blend segment (measured frustum between exact plane levels; true face is a torus fillet)
        translate([cx, mount_y, z_blend1]) cylinder(h=(z_blend2) - (z_blend1), r1=mount_rb1, r2=mount_rb2, $fn=fn);
        // blend2: mount top blend segment (measured frustum between exact plane levels; true face is a torus fillet)
        translate([cx, mount_y, z_blend2]) cylinder(h=(z_blend3) - (z_blend2), r1=mount_rb2, r2=mount_rb3, $fn=fn);
        // blend3: mount top blend segment (measured frustum between exact plane levels; true face is a torus fillet)
        translate([cx, mount_y, z_blend3]) cylinder(h=(z_blend4) - (z_blend3), r1=mount_rb3, r2=mount_rb4, $fn=fn);
        // blend4: mount top blend segment (measured frustum between exact plane levels; true face is a torus fillet)
        translate([cx, mount_y, z_blend4]) cylinder(h=(z_blend5) - (z_blend4), r1=mount_rb4, r2=mount_rb5, $fn=fn);
    }
}

// center ridge: stadium footprint INTERSECTED with (45-deg tail ramp + plateau + fitted-arc main ramp + full section + fitted-arc head taper) — the v13 rib-transition construction, laws fitted to the 16 measured bands (residuals in the param sources)
module center_ridge() {
    intersection() {
        // ridge_xsec: measured constant (x,z) cross-section (hourglass: ±5.0 base, ±3.60 waist at z=2.9, ±4.81 crest) — verified identical at y=-5/0/+4 on the reference tessellation
        rotate([0, -90, -90]) translate([0, 0, ridge_tail_y0]) linear_extrude((ridge_head_cy + ridge_hw + 0.2) - (ridge_tail_y0)) polygon(ridge_xsec_profile);
        hull() {
            // ridge_cap: stadium head cap (measured half-width radius)
            translate([0, ridge_head_cy, z_plate_top]) cylinder(h=(z_ridge_top) - (z_plate_top), r=ridge_hw, $fn=fn);
            // ridge_bar: stadium bar to the measured tail end
            translate([-ridge_hw, ridge_tail_y0, z_plate_top]) cube([2*ridge_hw, ridge_head_cy - ridge_tail_y0, z_ridge_top - z_plate_top]);
        }
        union() {
            // ridge_tail45: 45-deg tail ramp: measured linear law (res in params)
            intersection() {
                translate([-ridge_hw, ridge_tail_y0, z_plate_top]) cube([(ridge_hw) - (-ridge_hw), (ridge_tail_y1) - (ridge_tail_y0), (z_ridge_plateau) - (z_plate_top)]);
                translate([0, 0, ridge_tail_b]) rotate([atan(ridge_tail_m), 0, 0]) translate([-500, -500, -1000]) cube([1000, 1000, 1000]);
            }
            // ridge_plateau: tail plateau at the exact band level
            translate([-ridge_hw, ridge_tail_y1, z_plate_top]) cube([2*ridge_hw, ridge_arc_y0 - ridge_tail_y1, z_ridge_plateau - z_plate_top]);
            // ridge_main_arc: main ramp: fitted circular arc (residual in params)
            intersection() {
                translate([-ridge_hw, ridge_arc_y0, z_plate_top]) cube([(ridge_hw) - (-ridge_hw), (ridge_arc_y1) - (ridge_arc_y0), (z_ridge_top) - (z_plate_top)]);
                union() {
                    translate([(-ridge_hw) - 1, ridge_arc_yc, ridge_arc_zc]) rotate([0, 90, 0]) cylinder(h = ((ridge_hw) - (-ridge_hw)) + 2, r = ridge_arc_R, $fn = 4*fn);
                    translate([-500, -500, (ridge_arc_zc) - 1000]) cube([1000, 1000, 1000]);
                }
            }
            // ridge_full: full-height section between the two fitted arcs
            translate([-ridge_hw, ridge_arc_y1, z_plate_top]) cube([2*ridge_hw, ridge_head_y0 - ridge_arc_y1, z_ridge_top - z_plate_top]);
            // ridge_head_arc: head taper: fitted circular arc (residual in params)
            intersection() {
                translate([-ridge_hw, ridge_head_y0, z_plate_top]) cube([(ridge_hw) - (-ridge_hw), (ridge_head_cy + ridge_hw + 0.2) - (ridge_head_y0), (z_ridge_top) - (z_plate_top)]);
                union() {
                    translate([(-ridge_hw) - 1, ridge_head_yc, ridge_head_zc]) rotate([0, 90, 0]) cylinder(h = ((ridge_hw) - (-ridge_hw)) + 2, r = ridge_head_R, $fn = 4*fn);
                    translate([-500, -500, (ridge_head_zc) - 1000]) cube([1000, 1000, 1000]);
                }
            }
        }
    }
}

// outer wing + strap rail (right side; the left side is mirrored): wing = outline clipped at wing_x_cut; rail strip = measured base footprint shrinking at the measured 45-deg edge law on all sides
module rail_hump() {
    union() {
        // wing: wing zone: shared outline INTERSECT x >= wing_x_cut (inner edge measured straight; largest wing band footprint)
        translate([0, 0, z_plate_top]) linear_extrude((z_wing_top) - (z_plate_top)) intersection() { polygon(plate_upper_outline_pts); translate([wing_x_cut, -50]) square([(50) - (wing_x_cut), 100]); };
        // rail_strip: strap rail: measured base footprint with the uniform 45-deg shrink law (dist-to-base = dz, std 0.012)
        minkowski() {
            translate([0, 0, z_wing_top]) linear_extrude(0.001) offset(delta = min(rail_d0, rail_d1)) polygon(rail_strip_base_pts);
            cylinder(h = (z_rail_top) - (z_wing_top), r1 = (rail_d0) - (min(rail_d0, rail_d1)) + 0.0005, r2 = (rail_d1) - (min(rail_d0, rail_d1)) + 0.0005, $fn = fn);
        }
    }
}

module body_0() {
    difference() {
        union() {
            plate();  // plate_i
            center_ridge();  // ridge_i
            rail_hump();  // rail_right
            mirror([1, 0, 0]) {  // rail_left
                rail_hump();  // rail_left_i
            }
            knuckle_mount(mountL_x);  // mount_left
            knuckle_mount(mountR_x);  // mount_right
            // crest_dome: exact B-rep sphere face #1 (tactile dome on the ridge crest)
            translate([-0.046925, -19.195918, 4.881424]) sphere(r=1.185, $fn=fn);
        }
        union() {
            translate([slot_low_cx, slot_low_cy, 0]) rotate([0, 0, -slot_ang]) {  // slotL_low
                strap_slot();  // slotL_low_i
            }
            translate([slot_high_cx, slot_high_cy, 0]) rotate([0, 0, -slot_ang]) {  // slotL_high
                strap_slot();  // slotL_high_i
            }
        }
        mirror([1, 0, 0]) {  // slots_right
            union() {
                translate([slot_low_cx, slot_low_cy, 0]) rotate([0, 0, -slot_ang]) {  // slotR_low
                    strap_slot();  // slotR_low_i
                }
                translate([slot_high_cx, slot_high_cy, 0]) rotate([0, 0, -slot_ang]) {  // slotR_high
                    strap_slot();  // slotR_high_i
                }
            }
        }
        // pin_window_L: knuckle-mount pin window: measured wall loop, vectorized (a rotated ~5x5 square with one small chamfered corner) — measured section loops at z=3.686317 for the band between exact B-rep plane levels z=3.571317 and z=3.801317 (hole loop)
        translate([0, 0, z_cut_lo]) linear_extrude((z_window_top) - (z_cut_lo)) polygon(concat(
            [[-27.872402, 38.213184]],
            [[-32.853374, 37.777405]],
            [[-32.451008, 33.178309]],
            [[-32.417599, 32.796432]],
            [[-32.035723, 32.829842]],
            [[-27.436625, 33.232208]]));
        // pin_window_R: knuckle-mount pin window: measured wall loop, vectorized (a rotated ~5x5 square with one small chamfered corner) — measured section loops at z=2.426317 for the band between exact B-rep plane levels z=2.301317 and z=2.551317 (hole loop)
        translate([0, 0, z_cut_lo]) linear_extrude((z_window_top) - (z_cut_lo)) polygon(concat(
            [[32.002519, 32.832747]],
            [[32.417599, 32.796432]],
            [[32.853374, 37.777405]],
            [[27.872402, 38.213184]],
            [[27.836088, 37.798105]],
            [[27.436625, 33.232208]]));
    }
}

// full part = union of all bodies
body_0();
