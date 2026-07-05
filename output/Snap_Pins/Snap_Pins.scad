// Snap_Pins — step2scad parametric reconstruction
// source: models/phoenix_components/Snap_Pins.step
// rotate_extrude bodies: exact RZ profile from the B-rep coaxial faces;
// csg / instance_of bodies: agent-authored measured plan (plan.json);
// strategies without a real emitter yet use placeholder stubs (bbox).
// Every dimension below is an exact B-rep value from features.json.

// ---- body 0 (strategy: csg — agent plan) ----
// plan: hull-loft along y from measured sections; plan-view concavity cutters (fork slot/barb notches); engraved label grooves (<0.3 mm³) intentionally omitted
b0_st00a_profile = [[0.5303, 26.00402], [1.36492, 25.41051], [2.48827, 25.18374], [3.6004, 25.46019], [4.35584, 26.03224], [4.5805, 26.31482], [4.57923, 29.27319], [3.88769, 29.95723], [2.81966, 30.37274], [1.67663, 30.29053], [0.63049, 29.68166], [0.5303, 29.581]];  // (z, x) points — measured section convex hull at y=-16.535 (high-res tessellation)
b0_st00a_z0 = -16.535;  // extent along y
b0_st00a_z1 = -16.515;
b0_st00b_profile = [[0.5303, 25.73755], [0.95941, 25.41259], [1.70992, 25.08921], [2.52181, 24.99652], [3.32577, 25.14239], [4.05323, 25.51433], [4.5805, 26.00106], [4.5805, 29.58401], [3.95638, 30.1371], [3.21372, 30.47779], [2.40437, 30.58933], [1.59739, 30.46223], [0.86163, 30.1074], [0.5303, 29.84748]];  // (z, x) points — measured section convex hull at y=-16.345 (high-res tessellation)
b0_st00b_z0 = -16.345;  // extent along y
b0_st00b_z1 = -16.325;
b0_st01a_profile = [[0.5303, 25.73755], [0.95941, 25.41259], [1.70992, 25.08921], [2.52181, 24.99652], [3.32577, 25.14239], [4.05323, 25.51433], [4.5805, 26.00106], [4.5805, 29.58401], [3.95638, 30.1371], [3.21372, 30.47779], [2.40437, 30.58933], [1.59739, 30.46223], [0.86163, 30.1074], [0.5303, 29.84748]];  // (z, x) points — measured section convex hull at y=-16.345 (high-res tessellation)
b0_st01a_z0 = -16.345;  // extent along y
b0_st01a_z1 = -16.325;
b0_st01b_profile = [[0.5303, 25.47103], [1.29285, 25.01658], [2.15501, 24.80519], [3.04129, 24.85535], [3.94136, 25.20405], [4.5805, 25.70026], [4.5805, 29.88476], [3.87409, 30.42235], [3.00238, 30.73578], [2.15501, 30.77984], [1.25719, 30.55172], [0.5303, 30.11399]];  // (z, x) points — measured section convex hull at y=-15.945 (high-res tessellation)
b0_st01b_z0 = -15.945;  // extent along y
b0_st01b_z1 = -15.925;
b0_st02a_profile = [[0.5303, 25.47103], [1.29285, 25.01658], [2.15501, 24.80519], [3.04129, 24.85535], [3.94136, 25.20405], [4.5805, 25.70026], [4.5805, 29.88476], [3.87409, 30.42235], [3.00238, 30.73578], [2.15501, 30.77984], [1.25719, 30.55172], [0.5303, 30.11399]];  // (z, x) points — measured section convex hull at y=-15.945 (high-res tessellation)
b0_st02a_z0 = -15.945;  // extent along y
b0_st02a_z1 = -15.925;
b0_st02b_profile = [[0.5303, 25.47103], [1.29285, 25.01658], [2.2343, 24.80182], [3.3286, 24.9301], [4.12695, 25.31823], [4.5805, 25.70026], [4.5805, 29.88476], [3.87409, 30.42235], [3.04129, 30.72967], [2.15501, 30.77984], [1.29285, 30.56844], [0.5303, 30.11399]];  // (z, x) points — measured section convex hull at y=-15.545 (high-res tessellation)
b0_st02b_z0 = -15.545;  // extent along y
b0_st02b_z1 = -15.525;
b0_st03a_profile = [[0.5303, 25.47103], [1.29285, 25.01658], [2.2343, 24.80182], [3.3286, 24.9301], [4.12695, 25.31823], [4.5805, 25.70026], [4.5805, 29.88476], [3.87409, 30.42235], [3.04129, 30.72967], [2.15501, 30.77984], [1.29285, 30.56844], [0.5303, 30.11399]];  // (z, x) points — measured section convex hull at y=-15.545 (high-res tessellation)
b0_st03a_z0 = -15.545;  // extent along y
b0_st03a_z1 = -15.525;
b0_st03b_profile = [[0.5303, 26.16793], [0.94071, 25.78516], [1.42364, 25.50454], [1.95681, 25.33816], [2.50567, 25.29364], [3.06242, 25.37399], [3.57791, 25.57137], [4.04433, 25.88346], [4.42713, 26.28839], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.81375, 29.87462], [3.3232, 30.1277], [2.77844, 30.26789], [2.22669, 30.28419], [1.67607, 30.17573], [1.16687, 29.9494], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-15.145 (high-res tessellation)
b0_st03b_z0 = -15.145;  // extent along y
b0_st03b_z1 = -15.125;
b0_st04a_profile = [[0.5303, 26.16793], [0.94071, 25.78516], [1.42364, 25.50454], [1.95681, 25.33816], [2.50567, 25.29364], [3.06242, 25.37399], [3.57791, 25.57137], [4.04433, 25.88346], [4.42713, 26.28839], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.81375, 29.87462], [3.3232, 30.1277], [2.77844, 30.26789], [2.22669, 30.28419], [1.67607, 30.17573], [1.16687, 29.9494], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-15.145 (high-res tessellation)
b0_st04a_z0 = -15.145;  // extent along y
b0_st04a_z1 = -15.125;
b0_st04b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.57791, 25.57137], [4.25564, 26.08536], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.56458, 30.01962], [2.76917, 30.26869], [1.93609, 30.24235], [1.15579, 29.94207], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-14.745 (high-res tessellation)
b0_st04b_z0 = -14.745;  // extent along y
b0_st04b_z1 = -14.725;
b0_st05a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.57791, 25.57137], [4.25564, 26.08536], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.56458, 30.01962], [2.76917, 30.26869], [1.93609, 30.24235], [1.15579, 29.94207], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-14.745 (high-res tessellation)
b0_st05a_z0 = -14.745;  // extent along y
b0_st05a_z1 = -14.725;
b0_st05b_profile = [[0.5303, 26.16793], [1.19384, 25.62134], [1.97656, 25.33543], [2.80977, 25.3228], [3.57791, 25.57137], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.55366, 30.02451], [2.75593, 30.26983], [1.92579, 30.23973], [1.14803, 29.93694], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-14.345 (high-res tessellation)
b0_st05b_z0 = -14.345;  // extent along y
b0_st05b_z1 = -14.325;
b0_st06a_profile = [[0.5303, 26.16793], [1.19384, 25.62134], [1.97656, 25.33543], [2.80977, 25.3228], [3.57791, 25.57137], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.55366, 30.02451], [2.75593, 30.26983], [1.92579, 30.23973], [1.14803, 29.93694], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-14.345 (high-res tessellation)
b0_st06a_z0 = -14.345;  // extent along y
b0_st06a_z1 = -14.325;
b0_st06b_profile = [[0.55693, 26.14009], [1.20331, 25.6165], [1.98841, 25.33379], [2.8215, 25.32515], [3.57791, 25.57137], [4.26853, 26.10057], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.54517, 30.02831], [2.74534, 30.27074], [1.9142, 30.23678], [1.13805, 29.93034], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-13.945 (high-res tessellation)
b0_st06b_z0 = -13.945;  // extent along y
b0_st06b_z1 = -13.925;
b0_st07a_profile = [[0.55693, 26.14009], [1.20331, 25.6165], [1.98841, 25.33379], [2.8215, 25.32515], [3.57791, 25.57137], [4.26853, 26.10057], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.54517, 30.02831], [2.74534, 30.27074], [1.9142, 30.23678], [1.13805, 29.93034], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-13.945 (high-res tessellation)
b0_st07a_z0 = -13.945;  // extent along y
b0_st07a_z1 = -13.925;
b0_st07b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.83192, 25.32724], [3.57791, 25.57137], [4.2754, 26.10868], [4.5805, 26.51678], [4.5805, 29.06825], [4.0032, 29.73302], [3.3232, 30.1277], [2.45786, 30.29015], [1.63628, 30.16072], [0.90171, 29.76786], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-13.545 (high-res tessellation)
b0_st07b_z0 = -13.545;  // extent along y
b0_st07b_z1 = -13.525;
b0_st08a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.83192, 25.32724], [3.57791, 25.57137], [4.2754, 26.10868], [4.5805, 26.51678], [4.5805, 29.06825], [4.0032, 29.73302], [3.3232, 30.1277], [2.45786, 30.29015], [1.63628, 30.16072], [0.90171, 29.76786], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-13.545 (high-res tessellation)
b0_st08a_z0 = -13.545;  // extent along y
b0_st08a_z1 = -13.525;
b0_st08b_profile = [[0.5303, 26.16793], [1.22342, 25.60622], [2.00684, 25.33124], [2.78372, 25.31759], [3.57791, 25.57137], [4.28142, 26.11578], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.57791, 30.01365], [2.72547, 30.27245], [1.8923, 30.23121], [1.12253, 29.92008], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-13.145 (high-res tessellation)
b0_st08b_z0 = -13.145;  // extent along y
b0_st08b_z1 = -13.125;
b0_st09a_profile = [[0.5303, 26.16793], [1.22342, 25.60622], [2.00684, 25.33124], [2.78372, 25.31759], [3.57791, 25.57137], [4.28142, 26.11578], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.57791, 30.01365], [2.72547, 30.27245], [1.8923, 30.23121], [1.12253, 29.92008], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-13.145 (high-res tessellation)
b0_st09a_z0 = -13.145;  // extent along y
b0_st09a_z1 = -13.125;
b0_st09b_profile = [[0.5303, 26.16793], [1.23052, 25.60259], [2.02, 25.32942], [2.85277, 25.33141], [3.57791, 25.57137], [4.28915, 26.1249], [4.5805, 26.51678], [4.5805, 29.06825], [3.9862, 29.74579], [3.3232, 30.1277], [2.43528, 30.28957], [1.61514, 30.15274], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-12.745 (high-res tessellation)
b0_st09b_z0 = -12.745;  // extent along y
b0_st09b_z1 = -12.725;
b0_st10a_profile = [[0.5303, 26.16793], [1.23052, 25.60259], [2.02, 25.32942], [2.85277, 25.33141], [3.57791, 25.57137], [4.28915, 26.1249], [4.5805, 26.51678], [4.5805, 29.06825], [3.9862, 29.74579], [3.3232, 30.1277], [2.43528, 30.28957], [1.61514, 30.15274], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-12.745 (high-res tessellation)
b0_st10a_z0 = -12.745;  // extent along y
b0_st10a_z1 = -12.725;
b0_st10b_profile = [[0.5303, 26.16793], [1.23999, 25.59775], [1.95025, 25.33907], [2.86319, 25.3335], [3.57791, 25.57137], [4.29602, 26.13301], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.50636, 30.04569], [2.70297, 30.27439], [1.87427, 30.22662], [1.17019, 29.95159], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-12.345 (high-res tessellation)
b0_st10b_z0 = -12.345;  // extent along y
b0_st10b_z1 = -12.325;
b0_st11a_profile = [[0.5303, 26.16793], [1.23999, 25.59775], [1.95025, 25.33907], [2.86319, 25.3335], [3.57791, 25.57137], [4.29602, 26.13301], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.50636, 30.04569], [2.70297, 30.27439], [1.87427, 30.22662], [1.17019, 29.95159], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-12.345 (high-res tessellation)
b0_st11a_z0 = -12.345;  // extent along y
b0_st11a_z1 = -12.325;
b0_st11b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [2.03843, 25.32687], [3.14343, 25.39988], [4.10814, 25.94363], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.49423, 30.05112], [2.41668, 30.28909], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-11.945 (high-res tessellation)
b0_st11b_z0 = -11.945;  // extent along y
b0_st11b_z1 = -11.925;
b0_st12a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [2.03843, 25.32687], [3.14343, 25.39988], [4.10814, 25.94363], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.49423, 30.05112], [2.41668, 30.28909], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-11.945 (high-res tessellation)
b0_st12a_z0 = -11.945;  // extent along y
b0_st12a_z1 = -11.925;
b0_st12b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [2.32631, 25.29826], [3.41537, 25.49859], [4.30977, 26.14923], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.22574, 30.15884], [2.22669, 30.28419], [1.41868, 30.07861], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-11.545 (high-res tessellation)
b0_st12b_z0 = -11.545;  // extent along y
b0_st12b_z1 = -11.525;
b0_st13a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [2.32631, 25.29826], [3.41537, 25.49859], [4.30977, 26.14923], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.22574, 30.15884], [2.22669, 30.28419], [1.41868, 30.07861], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-11.545 (high-res tessellation)
b0_st13a_z0 = -11.545;  // extent along y
b0_st13a_z1 = -11.525;
b0_st13b_profile = [[0.5303, 26.16793], [1.52311, 25.46701], [2.50567, 25.29364], [3.57791, 25.57137], [4.4864, 26.37665], [4.5805, 26.51678], [4.5805, 29.06825], [3.72216, 29.92861], [2.67384, 30.2769], [1.5766, 30.1382], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-11.145 (high-res tessellation)
b0_st13b_z0 = -11.145;  // extent along y
b0_st13b_z1 = -11.125;
b0_st14a_profile = [[0.5303, 26.16793], [1.52311, 25.46701], [2.50567, 25.29364], [3.57791, 25.57137], [4.4864, 26.37665], [4.5805, 26.51678], [4.5805, 29.06825], [3.72216, 29.92861], [2.67384, 30.2769], [1.5766, 30.1382], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-11.145 (high-res tessellation)
b0_st14a_z0 = -11.145;  // extent along y
b0_st14a_z1 = -11.125;
b0_st14b_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [2.50567, 25.29364], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [3.81832, 29.87192], [2.78372, 30.26743], [1.67979, 30.17713], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-10.745 (high-res tessellation)
b0_st14b_z0 = -10.745;  // extent along y
b0_st14b_z1 = -10.725;
b0_st15a_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [2.50567, 25.29364], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [3.81832, 29.87192], [2.78372, 30.26743], [1.67979, 30.17713], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-10.745 (high-res tessellation)
b0_st15a_z0 = -10.745;  // extent along y
b0_st15a_z1 = -10.725;
b0_st15b_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [2.50567, 25.29364], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [3.81832, 29.87192], [2.78372, 30.26743], [2.22669, 30.28419], [1.41868, 30.07861], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-10.345 (high-res tessellation)
b0_st15b_z0 = -10.345;  // extent along y
b0_st15b_z1 = -10.325;
b0_st16a_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [2.50567, 25.29364], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [3.81832, 29.87192], [2.78372, 30.26743], [2.22669, 30.28419], [1.41868, 30.07861], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-10.345 (high-res tessellation)
b0_st16a_z0 = -10.345;  // extent along y
b0_st16a_z1 = -10.325;
b0_st16b_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [1.95025, 25.33907], [3.05736, 25.37238], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.81832, 29.87192], [2.78372, 30.26743], [1.67979, 30.17713], [1.17019, 29.95159], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-9.945 (high-res tessellation)
b0_st16b_z0 = -9.945;  // extent along y
b0_st16b_z1 = -9.925;
b0_st17a_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [1.95025, 25.33907], [3.05736, 25.37238], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.81832, 29.87192], [2.78372, 30.26743], [1.67979, 30.17713], [1.17019, 29.95159], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-9.945 (high-res tessellation)
b0_st17a_z0 = -9.945;  // extent along y
b0_st17a_z1 = -9.925;
b0_st17b_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [2.50567, 25.29364], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [3.81832, 29.87192], [2.78372, 30.26743], [1.67979, 30.17713], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-9.545 (high-res tessellation)
b0_st17b_z0 = -9.545;  // extent along y
b0_st17b_z1 = -9.525;
b0_st18a_profile = [[0.5303, 26.16793], [1.41868, 25.50642], [2.50567, 25.29364], [3.57791, 25.57137], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [3.81832, 29.87192], [2.78372, 30.26743], [1.67979, 30.17713], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-9.545 (high-res tessellation)
b0_st18a_z0 = -9.545;  // extent along y
b0_st18a_z1 = -9.525;
b0_st18b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.81832, 25.7131], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-9.145 (high-res tessellation)
b0_st18b_z0 = -9.145;  // extent along y
b0_st18b_z1 = -9.125;
b0_st19a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.81832, 25.7131], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-9.145 (high-res tessellation)
b0_st19a_z0 = -9.145;  // extent along y
b0_st19a_z1 = -9.125;
b0_st19b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.81832, 25.7131], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-8.745 (high-res tessellation)
b0_st19b_z0 = -8.745;  // extent along y
b0_st19b_z1 = -8.725;
b0_st20a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.81832, 25.7131], [4.42491, 26.28509], [4.5805, 26.51678], [4.5805, 29.06825], [4.24448, 29.51283], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-8.745 (high-res tessellation)
b0_st20a_z0 = -8.745;  // extent along y
b0_st20a_z1 = -8.725;
b0_st20b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.65806, 25.61862], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-8.345 (high-res tessellation)
b0_st20b_z0 = -8.345;  // extent along y
b0_st20b_z1 = -8.325;
b0_st21a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.65806, 25.61862], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-8.345 (high-res tessellation)
b0_st21a_z0 = -8.345;  // extent along y
b0_st21a_z1 = -8.325;
b0_st21b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.6489, 25.61322], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-7.945 (high-res tessellation)
b0_st21b_z0 = -7.945;  // extent along y
b0_st21b_z1 = -7.925;
b0_st22a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.6489, 25.61322], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-7.945 (high-res tessellation)
b0_st22a_z0 = -7.945;  // extent along y
b0_st22a_z1 = -7.925;
b0_st22b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.63974, 25.60782], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-7.545 (high-res tessellation)
b0_st22b_z0 = -7.545;  // extent along y
b0_st22b_z1 = -7.525;
b0_st23a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.63974, 25.60782], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-7.545 (high-res tessellation)
b0_st23a_z0 = -7.545;  // extent along y
b0_st23a_z1 = -7.525;
b0_st23b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.63058, 25.60242], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.3232, 30.1277], [2.50567, 30.29138], [1.67979, 30.17713], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-7.145 (high-res tessellation)
b0_st23b_z0 = -7.145;  // extent along y
b0_st23b_z1 = -7.125;
b0_st24a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.63058, 25.60242], [4.24448, 26.0722], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.3232, 30.1277], [2.50567, 30.29138], [1.67979, 30.17713], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-7.145 (high-res tessellation)
b0_st24a_z0 = -7.145;  // extent along y
b0_st24a_z1 = -7.125;
b0_st24b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.67979, 25.40789], [2.55467, 25.29786], [3.3232, 25.45733], [4.04143, 25.88073], [4.5805, 26.51678], [4.55308, 29.10908], [4.04143, 29.70429], [3.3232, 30.1277], [2.50567, 30.29138], [1.67979, 30.17713], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-6.745 (high-res tessellation)
b0_st24b_z0 = -6.745;  // extent along y
b0_st24b_z1 = -6.725;
b0_st25a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.67979, 25.40789], [2.55467, 25.29786], [3.3232, 25.45733], [4.04143, 25.88073], [4.5805, 26.51678], [4.55308, 29.10908], [4.04143, 29.70429], [3.3232, 30.1277], [2.50567, 30.29138], [1.67979, 30.17713], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-6.745 (high-res tessellation)
b0_st25a_z0 = -6.745;  // extent along y
b0_st25a_z1 = -6.725;
b0_st25b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.57791, 25.57137], [4.24448, 26.0722], [4.5805, 26.51678], [4.55753, 29.10246], [4.04143, 29.70429], [3.3232, 30.1277], [2.50567, 30.29138], [1.67979, 30.17713], [1.17019, 29.95159], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-6.345 (high-res tessellation)
b0_st25b_z0 = -6.345;  // extent along y
b0_st25b_z1 = -6.325;
b0_st26a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.78372, 25.31759], [3.57791, 25.57137], [4.24448, 26.0722], [4.5805, 26.51678], [4.55753, 29.10246], [4.04143, 29.70429], [3.3232, 30.1277], [2.50567, 30.29138], [1.67979, 30.17713], [1.17019, 29.95159], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-6.345 (high-res tessellation)
b0_st26a_z0 = -6.345;  // extent along y
b0_st26a_z1 = -6.325;
b0_st26b_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.50567, 25.29364], [3.3232, 25.45733], [4.04143, 25.88073], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-5.945 (high-res tessellation)
b0_st26b_z0 = -5.945;  // extent along y
b0_st26b_z1 = -5.925;
b0_st27a_profile = [[0.5303, 26.16793], [1.17019, 25.63343], [1.95025, 25.33907], [2.50567, 25.29364], [3.3232, 25.45733], [4.04143, 25.88073], [4.5805, 26.51678], [4.5805, 29.06825], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-5.945 (high-res tessellation)
b0_st27a_z0 = -5.945;  // extent along y
b0_st27a_z1 = -5.925;
b0_st27b_profile = [[0.5303, 26.16793], [0.9374, 25.78736], [1.67979, 25.40789], [2.22669, 25.30083], [3.05736, 25.37238], [3.57791, 25.57137], [4.24448, 26.0722], [4.5805, 26.51678], [4.56938, 29.08481], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-5.545 (high-res tessellation)
b0_st27b_z0 = -5.545;  // extent along y
b0_st27b_z1 = -5.525;
b0_st28a_profile = [[0.5303, 26.16793], [0.9374, 25.78736], [1.67979, 25.40789], [2.22669, 25.30083], [3.05736, 25.37238], [3.57791, 25.57137], [4.24448, 26.0722], [4.5805, 26.51678], [4.56938, 29.08481], [4.04143, 29.70429], [3.57791, 30.01365], [2.78372, 30.26743], [1.95025, 30.24595], [1.41868, 30.07861], [0.9374, 29.79767], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-5.545 (high-res tessellation)
b0_st28a_z0 = -5.545;  // extent along y
b0_st28a_z1 = -5.525;
b0_st28b_profile = [[0.5303, 26.16793], [0.9374, 25.78736], [1.41868, 25.50642], [1.95025, 25.33907], [2.51231, 25.29421], [3.05736, 25.37238], [3.57791, 25.57137], [4.04143, 25.88073], [4.42491, 26.28509], [4.5805, 26.51678], [4.57605, 29.07488], [4.24448, 29.51283], [3.81832, 29.87192], [3.3232, 30.1277], [2.78372, 30.26743], [2.22669, 30.28419], [1.67979, 30.17713], [1.17019, 29.95159], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-5.145 (high-res tessellation)
b0_st28b_z0 = -5.145;  // extent along y
b0_st28b_z1 = -5.125;
b0_st29a_profile = [[0.5303, 26.16793], [0.9374, 25.78736], [1.41868, 25.50642], [1.95025, 25.33907], [2.51231, 25.29421], [3.05736, 25.37238], [3.57791, 25.57137], [4.04143, 25.88073], [4.42491, 26.28509], [4.5805, 26.51678], [4.57605, 29.07488], [4.24448, 29.51283], [3.81832, 29.87192], [3.3232, 30.1277], [2.78372, 30.26743], [2.22669, 30.28419], [1.67979, 30.17713], [1.17019, 29.95159], [0.72321, 29.61876], [0.5303, 29.41709]];  // (z, x) points — measured section convex hull at y=-5.145 (high-res tessellation)
b0_st29a_z0 = -5.145;  // extent along y
b0_st29a_z1 = -5.125;
b0_st29b_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-4.745 (high-res tessellation)
b0_st29b_z0 = -4.745;  // extent along y
b0_st29b_z1 = -4.725;
b0_st30a_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-4.745 (high-res tessellation)
b0_st30a_z0 = -4.745;  // extent along y
b0_st30a_z1 = -4.725;
b0_st30b_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-4.345 (high-res tessellation)
b0_st30b_z0 = -4.345;  // extent along y
b0_st30b_z1 = -4.325;
b0_st31a_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-4.345 (high-res tessellation)
b0_st31a_z0 = -4.345;  // extent along y
b0_st31a_z1 = -4.325;
b0_st31b_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-3.945 (high-res tessellation)
b0_st31b_z0 = -3.945;  // extent along y
b0_st31b_z1 = -3.925;
b0_st32a_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-3.945 (high-res tessellation)
b0_st32a_z0 = -3.945;  // extent along y
b0_st32a_z1 = -3.925;
b0_st32b_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-3.545 (high-res tessellation)
b0_st32b_z0 = -3.545;  // extent along y
b0_st32b_z1 = -3.525;
b0_st33a_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-3.545 (high-res tessellation)
b0_st33a_z0 = -3.545;  // extent along y
b0_st33a_z1 = -3.525;
b0_st33b_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-3.145 (high-res tessellation)
b0_st33b_z0 = -3.145;  // extent along y
b0_st33b_z1 = -3.125;
b0_st34a_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-3.145 (high-res tessellation)
b0_st34a_z0 = -3.145;  // extent along y
b0_st34a_z1 = -3.125;
b0_st34b_profile = [[0.5303, 24.41751], [4.9305, 24.41751], [4.9305, 31.16751], [0.5303, 31.16751]];  // (z, x) points — measured section convex hull at y=-2.905 (high-res tessellation)
b0_st34b_z0 = -2.905;  // extent along y
b0_st34b_z1 = -2.885;
b0_pocket0_profile = [[24.40252, -4.845029], [25.327997, -4.844508], [25.327997, -15.344508], [24.823364, -15.359508], [24.808624, -16.109506]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.730402): fork slot / barb notch, vertical walls
b0_pocket0_z0 = 0.030304;  // extent along z
b0_pocket0_z1 = 5.4305;
b0_pocket1_profile = [[30.791649, -16.095029], [30.761658, -16.094508], [30.761658, -15.359508], [30.257024, -15.344508], [30.272024, -4.829508], [31.182479, -4.843524]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.730402): fork slot / barb notch, vertical walls
b0_pocket1_z0 = 0.030304;  // extent along z
b0_pocket1_z1 = 5.4305;
b0_pocket2_profile = [[25.358402, -16.609508], [25.358402, -16.579508], [27.027511, -16.579508], [27.027799, -9.591582], [28.548251, -9.58065], [28.557511, -16.579508], [30.272024, -16.579508], [30.285883, -16.600248]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.730402): fork slot / barb notch, vertical walls
b0_pocket2_z0 = 0.030304;  // extent along z
b0_pocket2_z1 = 5.4305;
b0_fn = 96;  // curve resolution

module body_0() {
    difference() {
        union() {
            hull() {
                // st00a: measured section convex hull at y=-16.535 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st00a_z0]) linear_extrude(b0_st00a_z1 - b0_st00a_z0) polygon(b0_st00a_profile);
                // st00b: measured section convex hull at y=-16.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st00b_z0]) linear_extrude(b0_st00b_z1 - b0_st00b_z0) polygon(b0_st00b_profile);
            }
            hull() {
                // st01a: measured section convex hull at y=-16.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st01a_z0]) linear_extrude(b0_st01a_z1 - b0_st01a_z0) polygon(b0_st01a_profile);
                // st01b: measured section convex hull at y=-15.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st01b_z0]) linear_extrude(b0_st01b_z1 - b0_st01b_z0) polygon(b0_st01b_profile);
            }
            hull() {
                // st02a: measured section convex hull at y=-15.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st02a_z0]) linear_extrude(b0_st02a_z1 - b0_st02a_z0) polygon(b0_st02a_profile);
                // st02b: measured section convex hull at y=-15.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st02b_z0]) linear_extrude(b0_st02b_z1 - b0_st02b_z0) polygon(b0_st02b_profile);
            }
            hull() {
                // st03a: measured section convex hull at y=-15.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st03a_z0]) linear_extrude(b0_st03a_z1 - b0_st03a_z0) polygon(b0_st03a_profile);
                // st03b: measured section convex hull at y=-15.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st03b_z0]) linear_extrude(b0_st03b_z1 - b0_st03b_z0) polygon(b0_st03b_profile);
            }
            hull() {
                // st04a: measured section convex hull at y=-15.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st04a_z0]) linear_extrude(b0_st04a_z1 - b0_st04a_z0) polygon(b0_st04a_profile);
                // st04b: measured section convex hull at y=-14.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st04b_z0]) linear_extrude(b0_st04b_z1 - b0_st04b_z0) polygon(b0_st04b_profile);
            }
            hull() {
                // st05a: measured section convex hull at y=-14.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st05a_z0]) linear_extrude(b0_st05a_z1 - b0_st05a_z0) polygon(b0_st05a_profile);
                // st05b: measured section convex hull at y=-14.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st05b_z0]) linear_extrude(b0_st05b_z1 - b0_st05b_z0) polygon(b0_st05b_profile);
            }
            hull() {
                // st06a: measured section convex hull at y=-14.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st06a_z0]) linear_extrude(b0_st06a_z1 - b0_st06a_z0) polygon(b0_st06a_profile);
                // st06b: measured section convex hull at y=-13.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st06b_z0]) linear_extrude(b0_st06b_z1 - b0_st06b_z0) polygon(b0_st06b_profile);
            }
            hull() {
                // st07a: measured section convex hull at y=-13.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st07a_z0]) linear_extrude(b0_st07a_z1 - b0_st07a_z0) polygon(b0_st07a_profile);
                // st07b: measured section convex hull at y=-13.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st07b_z0]) linear_extrude(b0_st07b_z1 - b0_st07b_z0) polygon(b0_st07b_profile);
            }
            hull() {
                // st08a: measured section convex hull at y=-13.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st08a_z0]) linear_extrude(b0_st08a_z1 - b0_st08a_z0) polygon(b0_st08a_profile);
                // st08b: measured section convex hull at y=-13.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st08b_z0]) linear_extrude(b0_st08b_z1 - b0_st08b_z0) polygon(b0_st08b_profile);
            }
            hull() {
                // st09a: measured section convex hull at y=-13.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st09a_z0]) linear_extrude(b0_st09a_z1 - b0_st09a_z0) polygon(b0_st09a_profile);
                // st09b: measured section convex hull at y=-12.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st09b_z0]) linear_extrude(b0_st09b_z1 - b0_st09b_z0) polygon(b0_st09b_profile);
            }
            hull() {
                // st10a: measured section convex hull at y=-12.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st10a_z0]) linear_extrude(b0_st10a_z1 - b0_st10a_z0) polygon(b0_st10a_profile);
                // st10b: measured section convex hull at y=-12.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st10b_z0]) linear_extrude(b0_st10b_z1 - b0_st10b_z0) polygon(b0_st10b_profile);
            }
            hull() {
                // st11a: measured section convex hull at y=-12.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st11a_z0]) linear_extrude(b0_st11a_z1 - b0_st11a_z0) polygon(b0_st11a_profile);
                // st11b: measured section convex hull at y=-11.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st11b_z0]) linear_extrude(b0_st11b_z1 - b0_st11b_z0) polygon(b0_st11b_profile);
            }
            hull() {
                // st12a: measured section convex hull at y=-11.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st12a_z0]) linear_extrude(b0_st12a_z1 - b0_st12a_z0) polygon(b0_st12a_profile);
                // st12b: measured section convex hull at y=-11.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st12b_z0]) linear_extrude(b0_st12b_z1 - b0_st12b_z0) polygon(b0_st12b_profile);
            }
            hull() {
                // st13a: measured section convex hull at y=-11.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st13a_z0]) linear_extrude(b0_st13a_z1 - b0_st13a_z0) polygon(b0_st13a_profile);
                // st13b: measured section convex hull at y=-11.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st13b_z0]) linear_extrude(b0_st13b_z1 - b0_st13b_z0) polygon(b0_st13b_profile);
            }
            hull() {
                // st14a: measured section convex hull at y=-11.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st14a_z0]) linear_extrude(b0_st14a_z1 - b0_st14a_z0) polygon(b0_st14a_profile);
                // st14b: measured section convex hull at y=-10.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st14b_z0]) linear_extrude(b0_st14b_z1 - b0_st14b_z0) polygon(b0_st14b_profile);
            }
            hull() {
                // st15a: measured section convex hull at y=-10.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st15a_z0]) linear_extrude(b0_st15a_z1 - b0_st15a_z0) polygon(b0_st15a_profile);
                // st15b: measured section convex hull at y=-10.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st15b_z0]) linear_extrude(b0_st15b_z1 - b0_st15b_z0) polygon(b0_st15b_profile);
            }
            hull() {
                // st16a: measured section convex hull at y=-10.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st16a_z0]) linear_extrude(b0_st16a_z1 - b0_st16a_z0) polygon(b0_st16a_profile);
                // st16b: measured section convex hull at y=-9.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st16b_z0]) linear_extrude(b0_st16b_z1 - b0_st16b_z0) polygon(b0_st16b_profile);
            }
            hull() {
                // st17a: measured section convex hull at y=-9.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st17a_z0]) linear_extrude(b0_st17a_z1 - b0_st17a_z0) polygon(b0_st17a_profile);
                // st17b: measured section convex hull at y=-9.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st17b_z0]) linear_extrude(b0_st17b_z1 - b0_st17b_z0) polygon(b0_st17b_profile);
            }
            hull() {
                // st18a: measured section convex hull at y=-9.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st18a_z0]) linear_extrude(b0_st18a_z1 - b0_st18a_z0) polygon(b0_st18a_profile);
                // st18b: measured section convex hull at y=-9.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st18b_z0]) linear_extrude(b0_st18b_z1 - b0_st18b_z0) polygon(b0_st18b_profile);
            }
            hull() {
                // st19a: measured section convex hull at y=-9.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st19a_z0]) linear_extrude(b0_st19a_z1 - b0_st19a_z0) polygon(b0_st19a_profile);
                // st19b: measured section convex hull at y=-8.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st19b_z0]) linear_extrude(b0_st19b_z1 - b0_st19b_z0) polygon(b0_st19b_profile);
            }
            hull() {
                // st20a: measured section convex hull at y=-8.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st20a_z0]) linear_extrude(b0_st20a_z1 - b0_st20a_z0) polygon(b0_st20a_profile);
                // st20b: measured section convex hull at y=-8.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st20b_z0]) linear_extrude(b0_st20b_z1 - b0_st20b_z0) polygon(b0_st20b_profile);
            }
            hull() {
                // st21a: measured section convex hull at y=-8.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st21a_z0]) linear_extrude(b0_st21a_z1 - b0_st21a_z0) polygon(b0_st21a_profile);
                // st21b: measured section convex hull at y=-7.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st21b_z0]) linear_extrude(b0_st21b_z1 - b0_st21b_z0) polygon(b0_st21b_profile);
            }
            hull() {
                // st22a: measured section convex hull at y=-7.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st22a_z0]) linear_extrude(b0_st22a_z1 - b0_st22a_z0) polygon(b0_st22a_profile);
                // st22b: measured section convex hull at y=-7.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st22b_z0]) linear_extrude(b0_st22b_z1 - b0_st22b_z0) polygon(b0_st22b_profile);
            }
            hull() {
                // st23a: measured section convex hull at y=-7.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st23a_z0]) linear_extrude(b0_st23a_z1 - b0_st23a_z0) polygon(b0_st23a_profile);
                // st23b: measured section convex hull at y=-7.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st23b_z0]) linear_extrude(b0_st23b_z1 - b0_st23b_z0) polygon(b0_st23b_profile);
            }
            hull() {
                // st24a: measured section convex hull at y=-7.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st24a_z0]) linear_extrude(b0_st24a_z1 - b0_st24a_z0) polygon(b0_st24a_profile);
                // st24b: measured section convex hull at y=-6.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st24b_z0]) linear_extrude(b0_st24b_z1 - b0_st24b_z0) polygon(b0_st24b_profile);
            }
            hull() {
                // st25a: measured section convex hull at y=-6.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st25a_z0]) linear_extrude(b0_st25a_z1 - b0_st25a_z0) polygon(b0_st25a_profile);
                // st25b: measured section convex hull at y=-6.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st25b_z0]) linear_extrude(b0_st25b_z1 - b0_st25b_z0) polygon(b0_st25b_profile);
            }
            hull() {
                // st26a: measured section convex hull at y=-6.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st26a_z0]) linear_extrude(b0_st26a_z1 - b0_st26a_z0) polygon(b0_st26a_profile);
                // st26b: measured section convex hull at y=-5.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st26b_z0]) linear_extrude(b0_st26b_z1 - b0_st26b_z0) polygon(b0_st26b_profile);
            }
            hull() {
                // st27a: measured section convex hull at y=-5.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st27a_z0]) linear_extrude(b0_st27a_z1 - b0_st27a_z0) polygon(b0_st27a_profile);
                // st27b: measured section convex hull at y=-5.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st27b_z0]) linear_extrude(b0_st27b_z1 - b0_st27b_z0) polygon(b0_st27b_profile);
            }
            hull() {
                // st28a: measured section convex hull at y=-5.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st28a_z0]) linear_extrude(b0_st28a_z1 - b0_st28a_z0) polygon(b0_st28a_profile);
                // st28b: measured section convex hull at y=-5.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st28b_z0]) linear_extrude(b0_st28b_z1 - b0_st28b_z0) polygon(b0_st28b_profile);
            }
            hull() {
                // st29a: measured section convex hull at y=-5.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st29a_z0]) linear_extrude(b0_st29a_z1 - b0_st29a_z0) polygon(b0_st29a_profile);
                // st29b: measured section convex hull at y=-4.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st29b_z0]) linear_extrude(b0_st29b_z1 - b0_st29b_z0) polygon(b0_st29b_profile);
            }
            hull() {
                // st30a: measured section convex hull at y=-4.745 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st30a_z0]) linear_extrude(b0_st30a_z1 - b0_st30a_z0) polygon(b0_st30a_profile);
                // st30b: measured section convex hull at y=-4.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st30b_z0]) linear_extrude(b0_st30b_z1 - b0_st30b_z0) polygon(b0_st30b_profile);
            }
            hull() {
                // st31a: measured section convex hull at y=-4.345 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st31a_z0]) linear_extrude(b0_st31a_z1 - b0_st31a_z0) polygon(b0_st31a_profile);
                // st31b: measured section convex hull at y=-3.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st31b_z0]) linear_extrude(b0_st31b_z1 - b0_st31b_z0) polygon(b0_st31b_profile);
            }
            hull() {
                // st32a: measured section convex hull at y=-3.945 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st32a_z0]) linear_extrude(b0_st32a_z1 - b0_st32a_z0) polygon(b0_st32a_profile);
                // st32b: measured section convex hull at y=-3.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st32b_z0]) linear_extrude(b0_st32b_z1 - b0_st32b_z0) polygon(b0_st32b_profile);
            }
            hull() {
                // st33a: measured section convex hull at y=-3.545 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st33a_z0]) linear_extrude(b0_st33a_z1 - b0_st33a_z0) polygon(b0_st33a_profile);
                // st33b: measured section convex hull at y=-3.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st33b_z0]) linear_extrude(b0_st33b_z1 - b0_st33b_z0) polygon(b0_st33b_profile);
            }
            hull() {
                // st34a: measured section convex hull at y=-3.145 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st34a_z0]) linear_extrude(b0_st34a_z1 - b0_st34a_z0) polygon(b0_st34a_profile);
                // st34b: measured section convex hull at y=-2.905 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b0_st34b_z0]) linear_extrude(b0_st34b_z1 - b0_st34b_z0) polygon(b0_st34b_profile);
            }
        }
        // pocket0: plan-view concavity (silhouette hull minus measured outline at z=2.730402): fork slot / barb notch, vertical walls
        translate([0, 0, b0_pocket0_z0]) linear_extrude(b0_pocket0_z1 - b0_pocket0_z0) polygon(b0_pocket0_profile);
        // pocket1: plan-view concavity (silhouette hull minus measured outline at z=2.730402): fork slot / barb notch, vertical walls
        translate([0, 0, b0_pocket1_z0]) linear_extrude(b0_pocket1_z1 - b0_pocket1_z0) polygon(b0_pocket1_profile);
        // pocket2: plan-view concavity (silhouette hull minus measured outline at z=2.730402): fork slot / barb notch, vertical walls
        translate([0, 0, b0_pocket2_z0]) linear_extrude(b0_pocket2_z1 - b0_pocket2_z0) polygon(b0_pocket2_profile);
    }
}

// ---- body 1 (strategy: csg — agent plan) ----
// plan: hull-loft along x from measured sections; plan-view concavity cutters (fork slot/barb notches); engraved label grooves (<0.3 mm³) intentionally omitted
b1_st00a_profile = [[3.21116, 0.99081], [3.55482, 0.5303], [7.74646, 0.5303], [8.09012, 0.99081], [8.15064, 1.33342], [8.12158, 2.97274], [7.81376, 3.48193], [7.27118, 3.72613], [3.91132, 3.70437], [3.40213, 3.39655], [3.1571, 2.8403]];  // (y, z) points — measured section convex hull at x=-8.602 (high-res tessellation)
b1_st00a_z0 = -8.602;  // extent along x
b1_st00a_z1 = -8.582;
b1_st00b_profile = [[3.21116, 0.99081], [3.55482, 0.5303], [7.74646, 0.5303], [8.09012, 0.99081], [8.15064, 1.33342], [8.12158, 2.97274], [7.7187, 3.55641], [7.15064, 3.73342], [3.91132, 3.70437], [3.40213, 3.39655], [3.15064, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.412 (high-res tessellation)
b1_st00b_z0 = -8.412;  // extent along x
b1_st00b_z1 = -8.392;
b1_st01a_profile = [[3.21116, 0.99081], [3.55482, 0.5303], [7.74646, 0.5303], [8.09012, 0.99081], [8.15064, 1.33342], [8.12158, 2.97274], [7.7187, 3.55641], [7.15064, 3.73342], [3.91132, 3.70437], [3.40213, 3.39655], [3.15064, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.412 (high-res tessellation)
b1_st01a_z0 = -8.412;  // extent along x
b1_st01a_z1 = -8.392;
b1_st01b_profile = [[3.27663, 0.85061], [3.55482, 0.5303], [7.77134, 0.55111], [8.14385, 1.21712], [8.07186, 3.11869], [7.35688, 3.71043], [3.68592, 3.61888], [3.26518, 3.19815], [3.15064, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.012 (high-res tessellation)
b1_st01b_z0 = -8.012;  // extent along x
b1_st01b_z1 = -7.992;
b1_st02a_profile = [[3.27663, 0.85061], [3.55482, 0.5303], [7.77134, 0.55111], [8.14385, 1.21712], [8.07186, 3.11869], [7.35688, 3.71043], [3.68592, 3.61888], [3.26518, 3.19815], [3.15064, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.012 (high-res tessellation)
b1_st02a_z0 = -8.012;  // extent along x
b1_st02a_z1 = -7.992;
b1_st02b_profile = [[3.7026, 1.5805], [3.87597, 1.11165], [4.15582, 0.70473], [4.33131, 0.5303], [6.97197, 0.53221], [7.29966, 0.90172], [7.5286, 1.34609], [7.64004, 1.82944], [7.62908, 2.32536], [7.49639, 2.80334], [7.25017, 3.23391], [6.90676, 3.58975], [6.7042, 3.73342], [4.59449, 3.73164], [4.20956, 3.42017], [3.91264, 3.02298], [3.72253, 2.56478], [3.65106, 2.0744]];  // (y, z) points — measured section convex hull at x=-7.612 (high-res tessellation)
b1_st02b_z0 = -7.612;  // extent along x
b1_st02b_z1 = -7.592;
b1_st03a_profile = [[3.7026, 1.5805], [3.87597, 1.11165], [4.15582, 0.70473], [4.33131, 0.5303], [6.97197, 0.53221], [7.29966, 0.90172], [7.5286, 1.34609], [7.64004, 1.82944], [7.62908, 2.32536], [7.49639, 2.80334], [7.25017, 3.23391], [6.90676, 3.58975], [6.7042, 3.73342], [4.59449, 3.73164], [4.20956, 3.42017], [3.91264, 3.02298], [3.72253, 2.56478], [3.65106, 2.0744]];  // (y, z) points — measured section convex hull at x=-7.612 (high-res tessellation)
b1_st03a_z0 = -7.612;  // extent along x
b1_st03a_z1 = -7.592;
b1_st03b_profile = [[3.77396, 1.34199], [4.15848, 0.70185], [4.33131, 0.5303], [6.97812, 0.53809], [7.4331, 1.12811], [7.64058, 1.83981], [7.57491, 2.57681], [7.2458, 3.23935], [6.7042, 3.73342], [4.58654, 3.72617], [4.04602, 3.227], [3.72174, 2.56174], [3.65104, 2.07234]];  // (y, z) points — measured section convex hull at x=-7.212 (high-res tessellation)
b1_st03b_z0 = -7.212;  // extent along x
b1_st03b_z1 = -7.192;
b1_st04a_profile = [[3.77396, 1.34199], [4.15848, 0.70185], [4.33131, 0.5303], [6.97812, 0.53809], [7.4331, 1.12811], [7.64058, 1.83981], [7.57491, 2.57681], [7.2458, 3.23935], [6.7042, 3.73342], [4.58654, 3.72617], [4.04602, 3.227], [3.72174, 2.56174], [3.65104, 2.07234]];  // (y, z) points — measured section convex hull at x=-7.212 (high-res tessellation)
b1_st04a_z0 = -7.212;  // extent along x
b1_st04a_z1 = -7.192;
b1_st04b_profile = [[3.77411, 1.34159], [4.16113, 0.69898], [4.33131, 0.5303], [6.98427, 0.54398], [7.43857, 1.14045], [7.64111, 1.85018], [7.57222, 2.58514], [7.24142, 3.24479], [6.7042, 3.73342], [4.57858, 3.72069], [4.04326, 3.22312], [3.72096, 2.55871], [3.65102, 2.07029]];  // (y, z) points — measured section convex hull at x=-6.812 (high-res tessellation)
b1_st04b_z0 = -6.812;  // extent along x
b1_st04b_z1 = -6.792;
b1_st05a_profile = [[3.77411, 1.34159], [4.16113, 0.69898], [4.33131, 0.5303], [6.98427, 0.54398], [7.43857, 1.14045], [7.64111, 1.85018], [7.57222, 2.58514], [7.24142, 3.24479], [6.7042, 3.73342], [4.57858, 3.72069], [4.04326, 3.22312], [3.72096, 2.55871], [3.65102, 2.07029]];  // (y, z) points — measured section convex hull at x=-6.812 (high-res tessellation)
b1_st05a_z0 = -6.812;  // extent along x
b1_st05a_z1 = -6.792;
b1_st05b_profile = [[3.77426, 1.34119], [4.16379, 0.6961], [4.33131, 0.5303], [6.99042, 0.54986], [7.44343, 1.15143], [7.64165, 1.86055], [7.56952, 2.59347], [7.23704, 3.25023], [6.7042, 3.73342], [4.57063, 3.71521], [4.04049, 3.21924], [3.72017, 2.55567], [3.65099, 2.06797]];  // (y, z) points — measured section convex hull at x=-6.412 (high-res tessellation)
b1_st05b_z0 = -6.412;  // extent along x
b1_st05b_z1 = -6.392;
b1_st06a_profile = [[3.77426, 1.34119], [4.16379, 0.6961], [4.33131, 0.5303], [6.99042, 0.54986], [7.44343, 1.15143], [7.64165, 1.86055], [7.56952, 2.59347], [7.23704, 3.25023], [6.7042, 3.73342], [4.57063, 3.71521], [4.04049, 3.21924], [3.72017, 2.55567], [3.65099, 2.06797]];  // (y, z) points — measured section convex hull at x=-6.412 (high-res tessellation)
b1_st06a_z0 = -6.412;  // extent along x
b1_st06a_z1 = -6.392;
b1_st06b_profile = [[3.77441, 1.34078], [4.16645, 0.69323], [4.33131, 0.5303], [6.99657, 0.55574], [7.44708, 1.15966], [7.64219, 1.87091], [7.56682, 2.6018], [7.23267, 3.25567], [6.7042, 3.73342], [4.56268, 3.70973], [4.03773, 3.21536], [3.71938, 2.55263], [3.65097, 2.06592]];  // (y, z) points — measured section convex hull at x=-6.012 (high-res tessellation)
b1_st06b_z0 = -6.012;  // extent along x
b1_st06b_z1 = -5.992;
b1_st07a_profile = [[3.77441, 1.34078], [4.16645, 0.69323], [4.33131, 0.5303], [6.99657, 0.55574], [7.44708, 1.15966], [7.64219, 1.87091], [7.56682, 2.6018], [7.23267, 3.25567], [6.7042, 3.73342], [4.56268, 3.70973], [4.03773, 3.21536], [3.71938, 2.55263], [3.65097, 2.06592]];  // (y, z) points — measured section convex hull at x=-6.012 (high-res tessellation)
b1_st07a_z0 = -6.012;  // extent along x
b1_st07a_z1 = -5.992;
b1_st07b_profile = [[3.77456, 1.34038], [4.1691, 0.69035], [4.33131, 0.5303], [6.96997, 0.5303], [7.45316, 1.17338], [7.64273, 1.88128], [7.56412, 2.61014], [7.22829, 3.26111], [6.7042, 3.73342], [4.55472, 3.70425], [4.03496, 3.21148], [3.71859, 2.54959], [3.65095, 2.06412]];  // (y, z) points — measured section convex hull at x=-5.612 (high-res tessellation)
b1_st07b_z0 = -5.612;  // extent along x
b1_st07b_z1 = -5.592;
b1_st08a_profile = [[3.77456, 1.34038], [4.1691, 0.69035], [4.33131, 0.5303], [6.96997, 0.5303], [7.45316, 1.17338], [7.64273, 1.88128], [7.56412, 2.61014], [7.22829, 3.26111], [6.7042, 3.73342], [4.55472, 3.70425], [4.03496, 3.21148], [3.71859, 2.54959], [3.65095, 2.06412]];  // (y, z) points — measured section convex hull at x=-5.612 (high-res tessellation)
b1_st08a_z0 = -5.612;  // extent along x
b1_st08a_z1 = -5.592;
b1_st08b_profile = [[3.77471, 1.33997], [4.17176, 0.68748], [4.33131, 0.5303], [6.96997, 0.5303], [7.45802, 1.18436], [7.64588, 2.13664], [7.47562, 2.84804], [7.08065, 3.43151], [6.7042, 3.73342], [4.59707, 3.73342], [4.0322, 3.2076], [3.7178, 2.54655], [3.65093, 2.06206]];  // (y, z) points — measured section convex hull at x=-5.212 (high-res tessellation)
b1_st08b_z0 = -5.212;  // extent along x
b1_st08b_z1 = -5.192;
b1_st09a_profile = [[3.77471, 1.33997], [4.17176, 0.68748], [4.33131, 0.5303], [6.96997, 0.5303], [7.45802, 1.18436], [7.64588, 2.13664], [7.47562, 2.84804], [7.08065, 3.43151], [6.7042, 3.73342], [4.59707, 3.73342], [4.0322, 3.2076], [3.7178, 2.54655], [3.65093, 2.06206]];  // (y, z) points — measured section convex hull at x=-5.212 (high-res tessellation)
b1_st09a_z0 = -5.212;  // extent along x
b1_st09a_z1 = -5.192;
b1_st09b_profile = [[3.77486, 1.33957], [4.17441, 0.6846], [4.33131, 0.5303], [6.96997, 0.5303], [7.55196, 1.42286], [7.61669, 2.38927], [7.21953, 3.27199], [6.7042, 3.73342], [4.59707, 3.73342], [4.02943, 3.20372], [3.71702, 2.54351], [3.65091, 2.06001]];  // (y, z) points — measured section convex hull at x=-4.812 (high-res tessellation)
b1_st09b_z0 = -4.812;  // extent along x
b1_st09b_z1 = -4.792;
b1_st10a_profile = [[3.77486, 1.33957], [4.17441, 0.6846], [4.33131, 0.5303], [6.96997, 0.5303], [7.55196, 1.42286], [7.61669, 2.38927], [7.21953, 3.27199], [6.7042, 3.73342], [4.59707, 3.73342], [4.02943, 3.20372], [3.71702, 2.54351], [3.65091, 2.06001]];  // (y, z) points — measured section convex hull at x=-4.812 (high-res tessellation)
b1_st10a_z0 = -4.812;  // extent along x
b1_st10a_z1 = -4.792;
b1_st10b_profile = [[3.92412, 1.03061], [4.33131, 0.5303], [6.96997, 0.5303], [7.55529, 1.43383], [7.61492, 2.39839], [7.21516, 3.27743], [6.7042, 3.73342], [4.59707, 3.73342], [3.89652, 2.99329], [3.65089, 2.05795]];  // (y, z) points — measured section convex hull at x=-4.412 (high-res tessellation)
b1_st10b_z0 = -4.412;  // extent along x
b1_st10b_z1 = -4.392;
b1_st11a_profile = [[3.92412, 1.03061], [4.33131, 0.5303], [6.96997, 0.5303], [7.55529, 1.43383], [7.61492, 2.39839], [7.21516, 3.27743], [6.7042, 3.73342], [4.59707, 3.73342], [3.89652, 2.99329], [3.65089, 2.05795]];  // (y, z) points — measured section convex hull at x=-4.412 (high-res tessellation)
b1_st11a_z0 = -4.412;  // extent along x
b1_st11a_z1 = -4.392;
b1_st11b_profile = [[3.93014, 1.02048], [4.33131, 0.5303], [6.96997, 0.5303], [7.55863, 1.4448], [7.61315, 2.40752], [7.21078, 3.28287], [6.7042, 3.73342], [4.59707, 3.73342], [3.89451, 2.98957], [3.65087, 2.05589]];  // (y, z) points — measured section convex hull at x=-4.012 (high-res tessellation)
b1_st11b_z0 = -4.012;  // extent along x
b1_st11b_z1 = -3.992;
b1_st12a_profile = [[3.93014, 1.02048], [4.33131, 0.5303], [6.96997, 0.5303], [7.55863, 1.4448], [7.61315, 2.40752], [7.21078, 3.28287], [6.7042, 3.73342], [4.59707, 3.73342], [3.89451, 2.98957], [3.65087, 2.05589]];  // (y, z) points — measured section convex hull at x=-4.012 (high-res tessellation)
b1_st12a_z0 = -4.012;  // extent along x
b1_st12a_z1 = -3.992;
b1_st12b_profile = [[3.87349, 1.11595], [4.33131, 0.5303], [6.96997, 0.5303], [7.52601, 1.33846], [7.6331, 2.29645], [7.2064, 3.28831], [6.7042, 3.73342], [4.59707, 3.73342], [3.89249, 2.98586], [3.65085, 2.05384]];  // (y, z) points — measured section convex hull at x=-3.612 (high-res tessellation)
b1_st12b_z0 = -3.612;  // extent along x
b1_st12b_z1 = -3.592;
b1_st13a_profile = [[3.87349, 1.11595], [4.33131, 0.5303], [6.96997, 0.5303], [7.52601, 1.33846], [7.6331, 2.29645], [7.2064, 3.28831], [6.7042, 3.73342], [4.59707, 3.73342], [3.89249, 2.98586], [3.65085, 2.05384]];  // (y, z) points — measured section convex hull at x=-3.612 (high-res tessellation)
b1_st13a_z0 = -3.612;  // extent along x
b1_st13a_z1 = -3.592;
b1_st13b_profile = [[3.87345, 1.11603], [4.33131, 0.5303], [6.96997, 0.5303], [7.52586, 1.33805], [7.63344, 2.29387], [7.07291, 3.43937], [6.7042, 3.73342], [4.59707, 3.73342], [3.8421, 2.88344], [3.65082, 2.05152]];  // (y, z) points — measured section convex hull at x=-3.212 (high-res tessellation)
b1_st13b_z0 = -3.212;  // extent along x
b1_st13b_z1 = -3.192;
b1_st14a_profile = [[3.87345, 1.11603], [4.33131, 0.5303], [6.96997, 0.5303], [7.52586, 1.33805], [7.63344, 2.29387], [7.07291, 3.43937], [6.7042, 3.73342], [4.59707, 3.73342], [3.8421, 2.88344], [3.65082, 2.05152]];  // (y, z) points — measured section convex hull at x=-3.212 (high-res tessellation)
b1_st14a_z0 = -3.212;  // extent along x
b1_st14a_z1 = -3.192;
b1_st14b_profile = [[3.8734, 1.11613], [4.33131, 0.5303], [6.96997, 0.5303], [7.52571, 1.33765], [7.63378, 2.29129], [7.07136, 3.44094], [6.7042, 3.73342], [4.59707, 3.73342], [3.96225, 3.10287], [3.65935, 2.19308], [3.6508, 2.04947]];  // (y, z) points — measured section convex hull at x=-2.812 (high-res tessellation)
b1_st14b_z0 = -2.812;  // extent along x
b1_st14b_z1 = -2.792;
b1_st15a_profile = [[3.8734, 1.11613], [4.33131, 0.5303], [6.96997, 0.5303], [7.52571, 1.33765], [7.63378, 2.29129], [7.07136, 3.44094], [6.7042, 3.73342], [4.59707, 3.73342], [3.96225, 3.10287], [3.65935, 2.19308], [3.6508, 2.04947]];  // (y, z) points — measured section convex hull at x=-2.812 (high-res tessellation)
b1_st15a_z0 = -2.812;  // extent along x
b1_st15a_z1 = -2.792;
b1_st15b_profile = [[3.87335, 1.11622], [4.33131, 0.5303], [6.96997, 0.5303], [7.42794, 1.11625], [7.65049, 2.04767], [7.41433, 2.97565], [6.82762, 3.6469], [6.7042, 3.73342], [4.59707, 3.73342], [3.96631, 3.10939], [3.66003, 2.2029], [3.65078, 2.04741]];  // (y, z) points — measured section convex hull at x=-2.412 (high-res tessellation)
b1_st15b_z0 = -2.412;  // extent along x
b1_st15b_z1 = -2.392;
b1_st16a_profile = [[3.87335, 1.11622], [4.33131, 0.5303], [6.96997, 0.5303], [7.42794, 1.11625], [7.65049, 2.04767], [7.41433, 2.97565], [6.82762, 3.6469], [6.7042, 3.73342], [4.59707, 3.73342], [3.96631, 3.10939], [3.66003, 2.2029], [3.65078, 2.04741]];  // (y, z) points — measured section convex hull at x=-2.412 (high-res tessellation)
b1_st16a_z0 = -2.412;  // extent along x
b1_st16a_z1 = -2.392;
b1_st16b_profile = [[3.80557, 1.26941], [4.33131, 0.5303], [6.96997, 0.5303], [7.42798, 1.11632], [7.63749, 1.80489], [7.58958, 2.52299], [7.01427, 3.49349], [6.7042, 3.73342], [4.59707, 3.73342], [3.97037, 3.11591], [3.66072, 2.21272], [3.65076, 2.04561]];  // (y, z) points — measured section convex hull at x=-2.012 (high-res tessellation)
b1_st16b_z0 = -2.012;  // extent along x
b1_st16b_z1 = -1.992;
b1_st17a_profile = [[3.80557, 1.26941], [4.33131, 0.5303], [6.96997, 0.5303], [7.42798, 1.11632], [7.63749, 1.80489], [7.58958, 2.52299], [7.01427, 3.49349], [6.7042, 3.73342], [4.59707, 3.73342], [3.97037, 3.11591], [3.66072, 2.21272], [3.65076, 2.04561]];  // (y, z) points — measured section convex hull at x=-2.012 (high-res tessellation)
b1_st17a_z0 = -2.012;  // extent along x
b1_st17a_z1 = -1.992;
b1_st17b_profile = [[3.79949, 1.28313], [4.33131, 0.5303], [6.96997, 0.5303], [7.42803, 1.11642], [7.63732, 1.80338], [7.59037, 2.51995], [7.02189, 3.48666], [6.7042, 3.73342], [4.59707, 3.73342], [3.97442, 3.12242], [3.69831, 2.46002], [3.65074, 2.04355]];  // (y, z) points — measured section convex hull at x=-1.612 (high-res tessellation)
b1_st17b_z0 = -1.612;  // extent along x
b1_st17b_z1 = -1.592;
b1_st18a_profile = [[3.79949, 1.28313], [4.33131, 0.5303], [6.96997, 0.5303], [7.42803, 1.11642], [7.63732, 1.80338], [7.59037, 2.51995], [7.02189, 3.48666], [6.7042, 3.73342], [4.59707, 3.73342], [3.97442, 3.12242], [3.69831, 2.46002], [3.65074, 2.04355]];  // (y, z) points — measured section convex hull at x=-1.612 (high-res tessellation)
b1_st18a_z0 = -1.612;  // extent along x
b1_st18a_z1 = -1.592;
b1_st18b_profile = [[3.79463, 1.29411], [4.33131, 0.5303], [6.96997, 0.5303], [7.42809, 1.11654], [7.63715, 1.80188], [7.59116, 2.51691], [7.02951, 3.47984], [6.7042, 3.73342], [4.59707, 3.73342], [3.97848, 3.12894], [3.70008, 2.46914], [3.65072, 2.0415]];  // (y, z) points — measured section convex hull at x=-1.212 (high-res tessellation)
b1_st18b_z0 = -1.212;  // extent along x
b1_st18b_z1 = -1.192;
b1_st19a_profile = [[3.79463, 1.29411], [4.33131, 0.5303], [6.96997, 0.5303], [7.42809, 1.11654], [7.63715, 1.80188], [7.59116, 2.51691], [7.02951, 3.47984], [6.7042, 3.73342], [4.59707, 3.73342], [3.97848, 3.12894], [3.70008, 2.46914], [3.65072, 2.0415]];  // (y, z) points — measured section convex hull at x=-1.212 (high-res tessellation)
b1_st19a_z0 = -1.212;  // extent along x
b1_st19a_z1 = -1.192;
b1_st19b_profile = [[3.79098, 1.30234], [4.33131, 0.5303], [6.96997, 0.5303], [7.42814, 1.11664], [7.63699, 1.80037], [7.59195, 2.51387], [7.15327, 3.35274], [6.7042, 3.73342], [4.59707, 3.73342], [4.12042, 3.32037], [3.76887, 2.70803], [3.6507, 2.03944]];  // (y, z) points — measured section convex hull at x=-0.812 (high-res tessellation)
b1_st19b_z0 = -0.812;  // extent along x
b1_st19b_z1 = -0.792;
b1_st20a_profile = [[3.79098, 1.30234], [4.33131, 0.5303], [6.96997, 0.5303], [7.42814, 1.11664], [7.63699, 1.80037], [7.59195, 2.51387], [7.15327, 3.35274], [6.7042, 3.73342], [4.59707, 3.73342], [4.12042, 3.32037], [3.76887, 2.70803], [3.6507, 2.03944]];  // (y, z) points — measured section convex hull at x=-0.812 (high-res tessellation)
b1_st20a_z0 = -0.812;  // extent along x
b1_st20a_z1 = -0.792;
b1_st20b_profile = [[3.78612, 1.31331], [4.21996, 0.63677], [4.33131, 0.5303], [6.96997, 0.5303], [7.42819, 1.11674], [7.63682, 1.79887], [7.59274, 2.51083], [7.15695, 3.34871], [6.7042, 3.73342], [4.59707, 3.73342], [4.12456, 3.32554], [3.77156, 2.71636], [3.65068, 2.03738]];  // (y, z) points — measured section convex hull at x=-0.412 (high-res tessellation)
b1_st20b_z0 = -0.412;  // extent along x
b1_st20b_z1 = -0.392;
b1_st21a_profile = [[3.78612, 1.31331], [4.21996, 0.63677], [4.33131, 0.5303], [6.96997, 0.5303], [7.42819, 1.11674], [7.63682, 1.79887], [7.59274, 2.51083], [7.15695, 3.34871], [6.7042, 3.73342], [4.59707, 3.73342], [4.12456, 3.32554], [3.77156, 2.71636], [3.65068, 2.03738]];  // (y, z) points — measured section convex hull at x=-0.412 (high-res tessellation)
b1_st21a_z0 = -0.412;  // extent along x
b1_st21a_z1 = -0.392;
b1_st21b_profile = [[3.78004, 1.32703], [4.2138, 0.64266], [4.33131, 0.5303], [6.96997, 0.5303], [7.42824, 1.11683], [7.63665, 1.79736], [7.59352, 2.50779], [7.16063, 3.34468], [6.7042, 3.73342], [4.59707, 3.73342], [4.12871, 3.33071], [3.77426, 2.7247], [3.65066, 2.03533]];  // (y, z) points — measured section convex hull at x=-0.012 (high-res tessellation)
b1_st21b_z0 = -0.012;  // extent along x
b1_st21b_z1 = 0.008;
b1_st22a_profile = [[3.78004, 1.32703], [4.2138, 0.64266], [4.33131, 0.5303], [6.96997, 0.5303], [7.42824, 1.11683], [7.63665, 1.79736], [7.59352, 2.50779], [7.16063, 3.34468], [6.7042, 3.73342], [4.59707, 3.73342], [4.12871, 3.33071], [3.77426, 2.7247], [3.65066, 2.03533]];  // (y, z) points — measured section convex hull at x=-0.012 (high-res tessellation)
b1_st22a_z0 = -0.012;  // extent along x
b1_st22a_z1 = 0.008;
b1_st22b_profile = [[3.37291, 1.56982], [3.64665, 0.92763], [3.98445, 0.5303], [7.32947, 0.5415], [7.78213, 1.1554], [7.97137, 1.82862], [7.92105, 2.52612], [7.29551, 3.55349], [7.06211, 3.73342], [4.1478, 3.67034], [3.64665, 3.13922], [3.33275, 2.26677]];  // (y, z) points — measured section convex hull at x=0.388 (high-res tessellation)
b1_st22b_z0 = 0.388;  // extent along x
b1_st22b_z1 = 0.408;
b1_st23a_profile = [[3.37291, 1.56982], [3.64665, 0.92763], [3.98445, 0.5303], [7.32947, 0.5415], [7.78213, 1.1554], [7.97137, 1.82862], [7.92105, 2.52612], [7.29551, 3.55349], [7.06211, 3.73342], [4.1478, 3.67034], [3.64665, 3.13922], [3.33275, 2.26677]];  // (y, z) points — measured section convex hull at x=0.388 (high-res tessellation)
b1_st23a_z0 = 0.388;  // extent along x
b1_st23a_z1 = 0.408;
b1_st23b_profile = [[3.305, 1.5279], [3.56593, 0.90857], [3.8704, 0.5303], [7.45738, 0.55959], [7.85295, 1.12145], [8.05056, 1.84497], [7.99725, 2.54517], [7.67851, 3.24045], [7.19983, 3.73342], [4.05931, 3.69855], [3.58655, 3.18805], [3.29384, 2.49143], [3.25589, 2.26684]];  // (y, z) points — measured section convex hull at x=0.788 (high-res tessellation)
b1_st23b_z0 = 0.788;  // extent along x
b1_st23b_z1 = 0.808;
b1_st24a_profile = [[3.305, 1.5279], [3.56593, 0.90857], [3.8704, 0.5303], [7.45738, 0.55959], [7.85295, 1.12145], [8.05056, 1.84497], [7.99725, 2.54517], [7.67851, 3.24045], [7.19983, 3.73342], [4.05931, 3.69855], [3.58655, 3.18805], [3.29384, 2.49143], [3.25589, 2.26684]];  // (y, z) points — measured section convex hull at x=0.788 (high-res tessellation)
b1_st24a_z0 = 0.788;  // extent along x
b1_st24a_z1 = 0.808;
b1_st24b_profile = [[3.2902, 1.58056], [3.70724, 0.71065], [3.8704, 0.5303], [7.43088, 0.5303], [7.85295, 1.12145], [8.0495, 1.8207], [7.88525, 2.86623], [7.33564, 3.62102], [7.19983, 3.73342], [4.10145, 3.73342], [3.59891, 3.20898], [3.25874, 2.30623]];  // (y, z) points — measured section convex hull at x=1.188 (high-res tessellation)
b1_st24b_z0 = 1.188;  // extent along x
b1_st24b_z1 = 1.208;
b1_st25a_profile = [[3.2902, 1.58056], [3.70724, 0.71065], [3.8704, 0.5303], [7.43088, 0.5303], [7.85295, 1.12145], [8.0495, 1.8207], [7.88525, 2.86623], [7.33564, 3.62102], [7.19983, 3.73342], [4.10145, 3.73342], [3.59891, 3.20898], [3.25874, 2.30623]];  // (y, z) points — measured section convex hull at x=1.188 (high-res tessellation)
b1_st25a_z0 = 1.188;  // extent along x
b1_st25a_z1 = 1.208;
b1_st25b_profile = [[3.36479, 1.34946], [3.71447, 0.71647], [3.88416, 0.5303], [7.44577, 0.55905], [8.00149, 1.58266], [7.98773, 2.54279], [7.69422, 3.20351], [7.18361, 3.73342], [4.10299, 3.72266], [3.73825, 3.37939], [3.36166, 2.70823], [3.25712, 2.20134]];  // (y, z) points — measured section convex hull at x=1.588 (high-res tessellation)
b1_st25b_z0 = 1.588;  // extent along x
b1_st25b_z1 = 1.608;
b1_st26a_profile = [[3.36479, 1.34946], [3.71447, 0.71647], [3.88416, 0.5303], [7.44577, 0.55905], [8.00149, 1.58266], [7.98773, 2.54279], [7.69422, 3.20351], [7.18361, 3.73342], [4.10299, 3.72266], [3.73825, 3.37939], [3.36166, 2.70823], [3.25712, 2.20134]];  // (y, z) points — measured section convex hull at x=1.588 (high-res tessellation)
b1_st26a_z0 = 1.588;  // extent along x
b1_st26a_z1 = 1.608;
b1_st26b_profile = [[3.44629, 1.37753], [4.01012, 0.5303], [7.38443, 0.61954], [7.88189, 1.46326], [7.94739, 2.29382], [7.74072, 2.95562], [7.32184, 3.50809], [7.02944, 3.73342], [4.15798, 3.65648], [3.65793, 3.12498], [3.34317, 2.19724]];  // (y, z) points — measured section convex hull at x=1.748 (high-res tessellation)
b1_st26b_z0 = 1.748;  // extent along x
b1_st26b_z1 = 1.768;
b1_pocket0_profile = [[1.458226, 8.070119], [1.459535, 8.040192], [0.547485, 8.0213], [0.380415, 7.892338], [0.308066, 7.629774], [-7.70693, 7.645461], [-7.693254, 8.16558]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
b1_pocket0_z0 = 0.030304;  // extent along z
b1_pocket0_z1 = 4.233424;
b1_pocket1_profile = [[1.82307, 3.595957], [1.79307, 3.595957], [1.79307, 5.135639], [-3.694856, 5.135927], [-3.705788, 6.156379], [1.79307, 6.165639], [1.79307, 7.70532], [1.81381, 7.719178]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
b1_pocket1_z0 = 0.030304;  // extent along z
b1_pocket1_z1 = 4.233424;
b1_pocket2_profile = [[-7.691774, 3.13564], [-7.691925, 3.670817], [0.308066, 3.671503], [0.361983, 3.440027], [0.431931, 3.349568], [0.537851, 3.284034], [1.495926, 3.246103]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
b1_pocket2_z0 = 0.030304;  // extent along z
b1_pocket2_z1 = 4.233424;
b1_fn = 96;  // curve resolution

module body_1() {
    difference() {
        union() {
            hull() {
                // st00a: measured section convex hull at x=-8.602 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st00a_z0]) linear_extrude(b1_st00a_z1 - b1_st00a_z0) polygon(b1_st00a_profile);
                // st00b: measured section convex hull at x=-8.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st00b_z0]) linear_extrude(b1_st00b_z1 - b1_st00b_z0) polygon(b1_st00b_profile);
            }
            hull() {
                // st01a: measured section convex hull at x=-8.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st01a_z0]) linear_extrude(b1_st01a_z1 - b1_st01a_z0) polygon(b1_st01a_profile);
                // st01b: measured section convex hull at x=-8.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st01b_z0]) linear_extrude(b1_st01b_z1 - b1_st01b_z0) polygon(b1_st01b_profile);
            }
            hull() {
                // st02a: measured section convex hull at x=-8.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st02a_z0]) linear_extrude(b1_st02a_z1 - b1_st02a_z0) polygon(b1_st02a_profile);
                // st02b: measured section convex hull at x=-7.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st02b_z0]) linear_extrude(b1_st02b_z1 - b1_st02b_z0) polygon(b1_st02b_profile);
            }
            hull() {
                // st03a: measured section convex hull at x=-7.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st03a_z0]) linear_extrude(b1_st03a_z1 - b1_st03a_z0) polygon(b1_st03a_profile);
                // st03b: measured section convex hull at x=-7.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st03b_z0]) linear_extrude(b1_st03b_z1 - b1_st03b_z0) polygon(b1_st03b_profile);
            }
            hull() {
                // st04a: measured section convex hull at x=-7.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st04a_z0]) linear_extrude(b1_st04a_z1 - b1_st04a_z0) polygon(b1_st04a_profile);
                // st04b: measured section convex hull at x=-6.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st04b_z0]) linear_extrude(b1_st04b_z1 - b1_st04b_z0) polygon(b1_st04b_profile);
            }
            hull() {
                // st05a: measured section convex hull at x=-6.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st05a_z0]) linear_extrude(b1_st05a_z1 - b1_st05a_z0) polygon(b1_st05a_profile);
                // st05b: measured section convex hull at x=-6.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st05b_z0]) linear_extrude(b1_st05b_z1 - b1_st05b_z0) polygon(b1_st05b_profile);
            }
            hull() {
                // st06a: measured section convex hull at x=-6.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st06a_z0]) linear_extrude(b1_st06a_z1 - b1_st06a_z0) polygon(b1_st06a_profile);
                // st06b: measured section convex hull at x=-6.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st06b_z0]) linear_extrude(b1_st06b_z1 - b1_st06b_z0) polygon(b1_st06b_profile);
            }
            hull() {
                // st07a: measured section convex hull at x=-6.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st07a_z0]) linear_extrude(b1_st07a_z1 - b1_st07a_z0) polygon(b1_st07a_profile);
                // st07b: measured section convex hull at x=-5.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st07b_z0]) linear_extrude(b1_st07b_z1 - b1_st07b_z0) polygon(b1_st07b_profile);
            }
            hull() {
                // st08a: measured section convex hull at x=-5.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st08a_z0]) linear_extrude(b1_st08a_z1 - b1_st08a_z0) polygon(b1_st08a_profile);
                // st08b: measured section convex hull at x=-5.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st08b_z0]) linear_extrude(b1_st08b_z1 - b1_st08b_z0) polygon(b1_st08b_profile);
            }
            hull() {
                // st09a: measured section convex hull at x=-5.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st09a_z0]) linear_extrude(b1_st09a_z1 - b1_st09a_z0) polygon(b1_st09a_profile);
                // st09b: measured section convex hull at x=-4.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st09b_z0]) linear_extrude(b1_st09b_z1 - b1_st09b_z0) polygon(b1_st09b_profile);
            }
            hull() {
                // st10a: measured section convex hull at x=-4.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st10a_z0]) linear_extrude(b1_st10a_z1 - b1_st10a_z0) polygon(b1_st10a_profile);
                // st10b: measured section convex hull at x=-4.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st10b_z0]) linear_extrude(b1_st10b_z1 - b1_st10b_z0) polygon(b1_st10b_profile);
            }
            hull() {
                // st11a: measured section convex hull at x=-4.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st11a_z0]) linear_extrude(b1_st11a_z1 - b1_st11a_z0) polygon(b1_st11a_profile);
                // st11b: measured section convex hull at x=-4.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st11b_z0]) linear_extrude(b1_st11b_z1 - b1_st11b_z0) polygon(b1_st11b_profile);
            }
            hull() {
                // st12a: measured section convex hull at x=-4.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st12a_z0]) linear_extrude(b1_st12a_z1 - b1_st12a_z0) polygon(b1_st12a_profile);
                // st12b: measured section convex hull at x=-3.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st12b_z0]) linear_extrude(b1_st12b_z1 - b1_st12b_z0) polygon(b1_st12b_profile);
            }
            hull() {
                // st13a: measured section convex hull at x=-3.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st13a_z0]) linear_extrude(b1_st13a_z1 - b1_st13a_z0) polygon(b1_st13a_profile);
                // st13b: measured section convex hull at x=-3.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st13b_z0]) linear_extrude(b1_st13b_z1 - b1_st13b_z0) polygon(b1_st13b_profile);
            }
            hull() {
                // st14a: measured section convex hull at x=-3.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st14a_z0]) linear_extrude(b1_st14a_z1 - b1_st14a_z0) polygon(b1_st14a_profile);
                // st14b: measured section convex hull at x=-2.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st14b_z0]) linear_extrude(b1_st14b_z1 - b1_st14b_z0) polygon(b1_st14b_profile);
            }
            hull() {
                // st15a: measured section convex hull at x=-2.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st15a_z0]) linear_extrude(b1_st15a_z1 - b1_st15a_z0) polygon(b1_st15a_profile);
                // st15b: measured section convex hull at x=-2.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st15b_z0]) linear_extrude(b1_st15b_z1 - b1_st15b_z0) polygon(b1_st15b_profile);
            }
            hull() {
                // st16a: measured section convex hull at x=-2.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st16a_z0]) linear_extrude(b1_st16a_z1 - b1_st16a_z0) polygon(b1_st16a_profile);
                // st16b: measured section convex hull at x=-2.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st16b_z0]) linear_extrude(b1_st16b_z1 - b1_st16b_z0) polygon(b1_st16b_profile);
            }
            hull() {
                // st17a: measured section convex hull at x=-2.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st17a_z0]) linear_extrude(b1_st17a_z1 - b1_st17a_z0) polygon(b1_st17a_profile);
                // st17b: measured section convex hull at x=-1.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st17b_z0]) linear_extrude(b1_st17b_z1 - b1_st17b_z0) polygon(b1_st17b_profile);
            }
            hull() {
                // st18a: measured section convex hull at x=-1.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st18a_z0]) linear_extrude(b1_st18a_z1 - b1_st18a_z0) polygon(b1_st18a_profile);
                // st18b: measured section convex hull at x=-1.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st18b_z0]) linear_extrude(b1_st18b_z1 - b1_st18b_z0) polygon(b1_st18b_profile);
            }
            hull() {
                // st19a: measured section convex hull at x=-1.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st19a_z0]) linear_extrude(b1_st19a_z1 - b1_st19a_z0) polygon(b1_st19a_profile);
                // st19b: measured section convex hull at x=-0.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st19b_z0]) linear_extrude(b1_st19b_z1 - b1_st19b_z0) polygon(b1_st19b_profile);
            }
            hull() {
                // st20a: measured section convex hull at x=-0.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st20a_z0]) linear_extrude(b1_st20a_z1 - b1_st20a_z0) polygon(b1_st20a_profile);
                // st20b: measured section convex hull at x=-0.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st20b_z0]) linear_extrude(b1_st20b_z1 - b1_st20b_z0) polygon(b1_st20b_profile);
            }
            hull() {
                // st21a: measured section convex hull at x=-0.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st21a_z0]) linear_extrude(b1_st21a_z1 - b1_st21a_z0) polygon(b1_st21a_profile);
                // st21b: measured section convex hull at x=-0.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st21b_z0]) linear_extrude(b1_st21b_z1 - b1_st21b_z0) polygon(b1_st21b_profile);
            }
            hull() {
                // st22a: measured section convex hull at x=-0.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st22a_z0]) linear_extrude(b1_st22a_z1 - b1_st22a_z0) polygon(b1_st22a_profile);
                // st22b: measured section convex hull at x=0.388 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st22b_z0]) linear_extrude(b1_st22b_z1 - b1_st22b_z0) polygon(b1_st22b_profile);
            }
            hull() {
                // st23a: measured section convex hull at x=0.388 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st23a_z0]) linear_extrude(b1_st23a_z1 - b1_st23a_z0) polygon(b1_st23a_profile);
                // st23b: measured section convex hull at x=0.788 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st23b_z0]) linear_extrude(b1_st23b_z1 - b1_st23b_z0) polygon(b1_st23b_profile);
            }
            hull() {
                // st24a: measured section convex hull at x=0.788 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st24a_z0]) linear_extrude(b1_st24a_z1 - b1_st24a_z0) polygon(b1_st24a_profile);
                // st24b: measured section convex hull at x=1.188 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st24b_z0]) linear_extrude(b1_st24b_z1 - b1_st24b_z0) polygon(b1_st24b_profile);
            }
            hull() {
                // st25a: measured section convex hull at x=1.188 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st25a_z0]) linear_extrude(b1_st25a_z1 - b1_st25a_z0) polygon(b1_st25a_profile);
                // st25b: measured section convex hull at x=1.588 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st25b_z0]) linear_extrude(b1_st25b_z1 - b1_st25b_z0) polygon(b1_st25b_profile);
            }
            hull() {
                // st26a: measured section convex hull at x=1.588 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st26a_z0]) linear_extrude(b1_st26a_z1 - b1_st26a_z0) polygon(b1_st26a_profile);
                // st26b: measured section convex hull at x=1.748 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b1_st26b_z0]) linear_extrude(b1_st26b_z1 - b1_st26b_z0) polygon(b1_st26b_profile);
            }
        }
        // pocket0: plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
        translate([0, 0, b1_pocket0_z0]) linear_extrude(b1_pocket0_z1 - b1_pocket0_z0) polygon(b1_pocket0_profile);
        // pocket1: plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
        translate([0, 0, b1_pocket1_z0]) linear_extrude(b1_pocket1_z1 - b1_pocket1_z0) polygon(b1_pocket1_profile);
        // pocket2: plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
        translate([0, 0, b1_pocket2_z0]) linear_extrude(b1_pocket2_z1 - b1_pocket2_z0) polygon(b1_pocket2_profile);
    }
}

// ---- body 2 (strategy: instance_of body 1 — agent plan) ----
b2_offset = [0, -14.032569, -0.000063];  // centroid delta body2-body1; canonical-anchor face signature matches except the engraved digit (<2.2 mm² faces)

module body_2() {
    translate(b2_offset) body_1();
}

// ---- body 3 (strategy: instance_of body 0 — agent plan) ----
b3_offset = [0.000014, 18.428702, 0.000238];  // centroid delta body3-body0; canonical-anchor face signature matches except the engraved digit (<2.2 mm² faces)

module body_3() {
    translate(b3_offset) body_0();
}

// ---- body 4 (strategy: instance_of body 1 — agent plan) ----
b4_offset = [0, -6.932079, -0.00012];  // centroid delta body4-body1; canonical-anchor face signature matches except the engraved digit (<2.2 mm² faces)

module body_4() {
    translate(b4_offset) body_1();
}

// ---- body 5 (strategy: csg — agent plan) ----
// plan: hull-loft along x from measured sections; plan-view concavity cutters (fork slot/barb notches); engraved label grooves (<0.3 mm³) intentionally omitted
b5_st00a_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-9.531 (high-res tessellation)
b5_st00a_z0 = -9.531;  // extent along x
b5_st00a_z1 = -9.511;
b5_st00b_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-9.341 (high-res tessellation)
b5_st00b_z0 = -9.341;  // extent along x
b5_st00b_z1 = -9.321;
b5_st01a_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-9.341 (high-res tessellation)
b5_st01a_z0 = -9.341;  // extent along x
b5_st01a_z1 = -9.321;
b5_st01b_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-8.941 (high-res tessellation)
b5_st01b_z0 = -8.941;  // extent along x
b5_st01b_z1 = -8.921;
b5_st02a_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-8.941 (high-res tessellation)
b5_st02a_z0 = -8.941;  // extent along x
b5_st02a_z1 = -8.921;
b5_st02b_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-8.541 (high-res tessellation)
b5_st02b_z0 = -8.541;  // extent along x
b5_st02b_z1 = -8.521;
b5_st03a_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-8.541 (high-res tessellation)
b5_st03a_z0 = -8.541;  // extent along x
b5_st03a_z1 = -8.521;
b5_st03b_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-8.141 (high-res tessellation)
b5_st03b_z0 = -8.141;  // extent along x
b5_st03b_z1 = -8.121;
b5_st04a_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-8.141 (high-res tessellation)
b5_st04a_z0 = -8.141;  // extent along x
b5_st04a_z1 = -8.121;
b5_st04b_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-7.741 (high-res tessellation)
b5_st04b_z0 = -7.741;  // extent along x
b5_st04b_z1 = -7.721;
b5_st05a_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-7.741 (high-res tessellation)
b5_st05a_z0 = -7.741;  // extent along x
b5_st05a_z1 = -7.721;
b5_st05b_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-7.341 (high-res tessellation)
b5_st05b_z0 = -7.341;  // extent along x
b5_st05b_z1 = -7.321;
b5_st06a_profile = [[13.6063, 0.5303], [18.6063, 0.5303], [18.6063, 3.9303], [13.6063, 3.9303]];  // (y, z) points — measured section convex hull at x=-7.341 (high-res tessellation)
b5_st06a_z0 = -7.341;  // extent along x
b5_st06a_z1 = -7.321;
b5_st06b_profile = [[14.19628, 1.63753], [14.52552, 1.00524], [15.05274, 0.5303], [17.16333, 0.53258], [17.69259, 1.01252], [18.01897, 1.64627], [18.10233, 2.35424], [17.93208, 3.04648], [17.52983, 3.63503], [17.15987, 3.9303], [15.04929, 3.92804], [14.52002, 3.44809], [14.19363, 2.81434], [14.10974, 2.34513]];  // (y, z) points — measured section convex hull at x=-6.941 (high-res tessellation)
b5_st06b_z0 = -6.941;  // extent along x
b5_st06b_z1 = -6.921;
b5_st07a_profile = [[14.19628, 1.63753], [14.52552, 1.00524], [15.05274, 0.5303], [17.16333, 0.53258], [17.69259, 1.01252], [18.01897, 1.64627], [18.10233, 2.35424], [17.93208, 3.04648], [17.52983, 3.63503], [17.15987, 3.9303], [15.04929, 3.92804], [14.52002, 3.44809], [14.19363, 2.81434], [14.10974, 2.34513]];  // (y, z) points — measured section convex hull at x=-6.941 (high-res tessellation)
b5_st07a_z0 = -6.941;  // extent along x
b5_st07a_z1 = -6.921;
b5_st07b_profile = [[14.19802, 1.63239], [14.52859, 1.00146], [15.05274, 0.5303], [17.16778, 0.53551], [17.69661, 1.01812], [18.02065, 1.65238], [18.10182, 2.36001], [17.92982, 3.05121], [17.52646, 3.63829], [17.15987, 3.9303], [15.04484, 3.92511], [14.516, 3.44249], [14.19196, 2.80822], [14.10956, 2.33915]];  // (y, z) points — measured section convex hull at x=-6.541 (high-res tessellation)
b5_st07b_z0 = -6.541;  // extent along x
b5_st07b_z1 = -6.521;
b5_st08a_profile = [[14.19802, 1.63239], [14.52859, 1.00146], [15.05274, 0.5303], [17.16778, 0.53551], [17.69661, 1.01812], [18.02065, 1.65238], [18.10182, 2.36001], [17.92982, 3.05121], [17.52646, 3.63829], [17.15987, 3.9303], [15.04484, 3.92511], [14.516, 3.44249], [14.19196, 2.80822], [14.10956, 2.33915]];  // (y, z) points — measured section convex hull at x=-6.541 (high-res tessellation)
b5_st08a_z0 = -6.541;  // extent along x
b5_st08a_z1 = -6.521;
b5_st08b_profile = [[14.19976, 1.62725], [14.53167, 0.99767], [15.05274, 0.5303], [17.17224, 0.53844], [17.70063, 1.02372], [18.02232, 1.6585], [18.10131, 2.36577], [17.92757, 3.05594], [17.5231, 3.64156], [17.15987, 3.9303], [15.04039, 3.92219], [14.51198, 3.43689], [14.19029, 2.80211], [14.10938, 2.33318]];  // (y, z) points — measured section convex hull at x=-6.141 (high-res tessellation)
b5_st08b_z0 = -6.141;  // extent along x
b5_st08b_z1 = -6.121;
b5_st09a_profile = [[14.19976, 1.62725], [14.53167, 0.99767], [15.05274, 0.5303], [17.17224, 0.53844], [17.70063, 1.02372], [18.02232, 1.6585], [18.10131, 2.36577], [17.92757, 3.05594], [17.5231, 3.64156], [17.15987, 3.9303], [15.04039, 3.92219], [14.51198, 3.43689], [14.19029, 2.80211], [14.10938, 2.33318]];  // (y, z) points — measured section convex hull at x=-6.141 (high-res tessellation)
b5_st09a_z0 = -6.141;  // extent along x
b5_st09a_z1 = -6.121;
b5_st09b_profile = [[14.20149, 1.62211], [14.53474, 0.99389], [15.05274, 0.5303], [17.1767, 0.54137], [17.70465, 1.02932], [18.02399, 1.66462], [18.10079, 2.37154], [17.92532, 3.06067], [17.51973, 3.64483], [17.15987, 3.9303], [15.03594, 3.91926], [14.50795, 3.43129], [14.18861, 2.79599], [14.1092, 2.32721]];  // (y, z) points — measured section convex hull at x=-5.741 (high-res tessellation)
b5_st09b_z0 = -5.741;  // extent along x
b5_st09b_z1 = -5.721;
b5_st10a_profile = [[14.20149, 1.62211], [14.53474, 0.99389], [15.05274, 0.5303], [17.1767, 0.54137], [17.70465, 1.02932], [18.02399, 1.66462], [18.10079, 2.37154], [17.92532, 3.06067], [17.51973, 3.64483], [17.15987, 3.9303], [15.03594, 3.91926], [14.50795, 3.43129], [14.18861, 2.79599], [14.1092, 2.32721]];  // (y, z) points — measured section convex hull at x=-5.741 (high-res tessellation)
b5_st10a_z0 = -5.741;  // extent along x
b5_st10a_z1 = -5.721;
b5_st10b_profile = [[14.20323, 1.61697], [14.53781, 0.9901], [15.05274, 0.5303], [17.18115, 0.54429], [17.70867, 1.03491], [18.02567, 1.67074], [18.10028, 2.37731], [17.92306, 3.0654], [17.51636, 3.64809], [17.15987, 3.9303], [15.03149, 3.91634], [14.50393, 3.42569], [14.18694, 2.78987], [14.10902, 2.32123]];  // (y, z) points — measured section convex hull at x=-5.341 (high-res tessellation)
b5_st10b_z0 = -5.341;  // extent along x
b5_st10b_z1 = -5.321;
b5_st11a_profile = [[14.20323, 1.61697], [14.53781, 0.9901], [15.05274, 0.5303], [17.18115, 0.54429], [17.70867, 1.03491], [18.02567, 1.67074], [18.10028, 2.37731], [17.92306, 3.0654], [17.51636, 3.64809], [17.15987, 3.9303], [15.03149, 3.91634], [14.50393, 3.42569], [14.18694, 2.78987], [14.10902, 2.32123]];  // (y, z) points — measured section convex hull at x=-5.341 (high-res tessellation)
b5_st11a_z0 = -5.341;  // extent along x
b5_st11a_z1 = -5.321;
b5_st11b_profile = [[14.20497, 1.61184], [14.54088, 0.98632], [15.05274, 0.5303], [17.18561, 0.54722], [17.71269, 1.04051], [18.02734, 1.67685], [18.09977, 2.38308], [17.92081, 3.07014], [17.513, 3.65136], [17.15987, 3.9303], [15.02704, 3.91342], [14.49991, 3.42009], [14.18526, 2.78375], [14.10884, 2.31526]];  // (y, z) points — measured section convex hull at x=-4.941 (high-res tessellation)
b5_st11b_z0 = -4.941;  // extent along x
b5_st11b_z1 = -4.921;
b5_st12a_profile = [[14.20497, 1.61184], [14.54088, 0.98632], [15.05274, 0.5303], [17.18561, 0.54722], [17.71269, 1.04051], [18.02734, 1.67685], [18.09977, 2.38308], [17.92081, 3.07014], [17.513, 3.65136], [17.15987, 3.9303], [15.02704, 3.91342], [14.49991, 3.42009], [14.18526, 2.78375], [14.10884, 2.31526]];  // (y, z) points — measured section convex hull at x=-4.941 (high-res tessellation)
b5_st12a_z0 = -4.941;  // extent along x
b5_st12a_z1 = -4.921;
b5_st12b_profile = [[14.29405, 1.38574], [14.87581, 0.65397], [15.05274, 0.5303], [17.19007, 0.55015], [17.84587, 1.24548], [18.10394, 2.15132], [17.91855, 3.07487], [17.3367, 3.80671], [17.15987, 3.9303], [15.0226, 3.91049], [14.36674, 3.21513], [14.10866, 2.30929]];  // (y, z) points — measured section convex hull at x=-4.541 (high-res tessellation)
b5_st12b_z0 = -4.541;  // extent along x
b5_st12b_z1 = -4.521;
b5_st13a_profile = [[14.29405, 1.38574], [14.87581, 0.65397], [15.05274, 0.5303], [17.19007, 0.55015], [17.84587, 1.24548], [18.10394, 2.15132], [17.91855, 3.07487], [17.3367, 3.80671], [17.15987, 3.9303], [15.0226, 3.91049], [14.36674, 3.21513], [14.10866, 2.30929]];  // (y, z) points — measured section convex hull at x=-4.541 (high-res tessellation)
b5_st13a_z0 = -4.541;  // extent along x
b5_st13a_z1 = -4.521;
b5_st13b_profile = [[14.29631, 1.38101], [14.8785, 0.65188], [15.05274, 0.5303], [17.19452, 0.55308], [17.84911, 1.25136], [18.10412, 2.15729], [17.9163, 3.0796], [17.33399, 3.80881], [17.15987, 3.9303], [15.01815, 3.90757], [14.36349, 3.20925], [14.10849, 2.30332]];  // (y, z) points — measured section convex hull at x=-4.141 (high-res tessellation)
b5_st13b_z0 = -4.141;  // extent along x
b5_st13b_z1 = -4.121;
b5_st14a_profile = [[14.29631, 1.38101], [14.8785, 0.65188], [15.05274, 0.5303], [17.19452, 0.55308], [17.84911, 1.25136], [18.10412, 2.15729], [17.9163, 3.0796], [17.33399, 3.80881], [17.15987, 3.9303], [15.01815, 3.90757], [14.36349, 3.20925], [14.10849, 2.30332]];  // (y, z) points — measured section convex hull at x=-4.141 (high-res tessellation)
b5_st14a_z0 = -4.141;  // extent along x
b5_st14a_z1 = -4.121;
b5_st14b_profile = [[14.29856, 1.37627], [14.8812, 0.6498], [15.05274, 0.5303], [17.19898, 0.55601], [17.85235, 1.25723], [18.1043, 2.16326], [17.91404, 3.08433], [17.33128, 3.8109], [17.15987, 3.9303], [15.0137, 3.90465], [14.36025, 3.20338], [14.10831, 2.29734]];  // (y, z) points — measured section convex hull at x=-3.741 (high-res tessellation)
b5_st14b_z0 = -3.741;  // extent along x
b5_st14b_z1 = -3.721;
b5_st15a_profile = [[14.29856, 1.37627], [14.8812, 0.6498], [15.05274, 0.5303], [17.19898, 0.55601], [17.85235, 1.25723], [18.1043, 2.16326], [17.91404, 3.08433], [17.33128, 3.8109], [17.15987, 3.9303], [15.0137, 3.90465], [14.36025, 3.20338], [14.10831, 2.29734]];  // (y, z) points — measured section convex hull at x=-3.741 (high-res tessellation)
b5_st15a_z0 = -3.741;  // extent along x
b5_st15a_z1 = -3.721;
b5_st15b_profile = [[14.4151, 1.16387], [15.05274, 0.5303], [17.20344, 0.55894], [17.91235, 1.37273], [18.09772, 2.40616], [17.65944, 3.48943], [17.15987, 3.9303], [15.00925, 3.90172], [14.30025, 3.08788], [14.10813, 2.29137]];  // (y, z) points — measured section convex hull at x=-3.341 (high-res tessellation)
b5_st15b_z0 = -3.341;  // extent along x
b5_st15b_z1 = -3.321;
b5_st16a_profile = [[14.4151, 1.16387], [15.05274, 0.5303], [17.20344, 0.55894], [17.91235, 1.37273], [18.09772, 2.40616], [17.65944, 3.48943], [17.15987, 3.9303], [15.00925, 3.90172], [14.30025, 3.08788], [14.10813, 2.29137]];  // (y, z) points — measured section convex hull at x=-3.341 (high-res tessellation)
b5_st16a_z0 = -3.341;  // extent along x
b5_st16a_z1 = -3.321;
b5_st16b_profile = [[14.35458, 1.26751], [15.05274, 0.5303], [17.15987, 0.5303], [17.9101, 1.36799], [18.08383, 2.52285], [17.58275, 3.57756], [17.15987, 3.9303], [15.05274, 3.9303], [14.30251, 3.09261], [14.10795, 2.2854]];  // (y, z) points — measured section convex hull at x=-2.941 (high-res tessellation)
b5_st16b_z0 = -2.941;  // extent along x
b5_st16b_z1 = -2.921;
b5_st17a_profile = [[14.35458, 1.26751], [15.05274, 0.5303], [17.15987, 0.5303], [17.9101, 1.36799], [18.08383, 2.52285], [17.58275, 3.57756], [17.15987, 3.9303], [15.05274, 3.9303], [14.30251, 3.09261], [14.10795, 2.2854]];  // (y, z) points — measured section convex hull at x=-2.941 (high-res tessellation)
b5_st17a_z0 = -2.941;  // extent along x
b5_st17a_z1 = -2.921;
b5_st17b_profile = [[14.35134, 1.27338], [15.05274, 0.5303], [17.15987, 0.5303], [17.79278, 1.15638], [18.09682, 2.04435], [17.96212, 2.97311], [17.15987, 3.9303], [15.05274, 3.9303], [14.41983, 3.30422], [14.11579, 2.41626], [14.10777, 2.27942]];  // (y, z) points — measured section convex hull at x=-2.541 (high-res tessellation)
b5_st17b_z0 = -2.541;  // extent along x
b5_st17b_z1 = -2.521;
b5_st18a_profile = [[14.35134, 1.27338], [15.05274, 0.5303], [17.15987, 0.5303], [17.79278, 1.15638], [18.09682, 2.04435], [17.96212, 2.97311], [17.15987, 3.9303], [15.05274, 3.9303], [14.41983, 3.30422], [14.11579, 2.41626], [14.10777, 2.27942]];  // (y, z) points — measured section convex hull at x=-2.541 (high-res tessellation)
b5_st18a_z0 = -2.541;  // extent along x
b5_st18a_z1 = -2.521;
b5_st18b_profile = [[14.34809, 1.27926], [15.05274, 0.5303], [17.15987, 0.5303], [17.79008, 1.15211], [18.0963, 2.03858], [17.96458, 2.96707], [17.15987, 3.9303], [15.05274, 3.9303], [14.42253, 3.3085], [14.1163, 2.42202], [14.10759, 2.27345]];  // (y, z) points — measured section convex hull at x=-2.141 (high-res tessellation)
b5_st18b_z0 = -2.141;  // extent along x
b5_st18b_z1 = -2.121;
b5_st19a_profile = [[14.34809, 1.27926], [15.05274, 0.5303], [17.15987, 0.5303], [17.79008, 1.15211], [18.0963, 2.03858], [17.96458, 2.96707], [17.15987, 3.9303], [15.05274, 3.9303], [14.42253, 3.3085], [14.1163, 2.42202], [14.10759, 2.27345]];  // (y, z) points — measured section convex hull at x=-2.141 (high-res tessellation)
b5_st19a_z0 = -2.141;  // extent along x
b5_st19a_z1 = -2.121;
b5_st19b_profile = [[14.24557, 1.49959], [14.95721, 0.59531], [15.05274, 0.5303], [17.15987, 0.5303], [17.78738, 1.14783], [18.09579, 2.03281], [17.96704, 2.96102], [17.2552, 3.86544], [17.15987, 3.9303], [15.05274, 3.9303], [14.42523, 3.31278], [14.11682, 2.42779], [14.10741, 2.26748]];  // (y, z) points — measured section convex hull at x=-1.741 (high-res tessellation)
b5_st19b_z0 = -1.741;  // extent along x
b5_st19b_z1 = -1.721;
b5_st20a_profile = [[14.24557, 1.49959], [14.95721, 0.59531], [15.05274, 0.5303], [17.15987, 0.5303], [17.78738, 1.14783], [18.09579, 2.03281], [17.96704, 2.96102], [17.2552, 3.86544], [17.15987, 3.9303], [15.05274, 3.9303], [14.42523, 3.31278], [14.11682, 2.42779], [14.10741, 2.26748]];  // (y, z) points — measured section convex hull at x=-1.741 (high-res tessellation)
b5_st20a_z0 = -1.741;  // extent along x
b5_st20a_z1 = -1.721;
b5_st20b_profile = [[14.24312, 1.50563], [14.94838, 0.60132], [15.05274, 0.5303], [17.15987, 0.5303], [17.78468, 1.14355], [18.05747, 1.79391], [18.08748, 2.49849], [17.74788, 3.37111], [17.15987, 3.9303], [15.05274, 3.9303], [14.42793, 3.31705], [14.15513, 2.66669], [14.10724, 2.26151]];  // (y, z) points — measured section convex hull at x=-1.341 (high-res tessellation)
b5_st20b_z0 = -1.341;  // extent along x
b5_st20b_z1 = -1.321;
b5_st21a_profile = [[14.24312, 1.50563], [14.94838, 0.60132], [15.05274, 0.5303], [17.15987, 0.5303], [17.78468, 1.14355], [18.05747, 1.79391], [18.08748, 2.49849], [17.74788, 3.37111], [17.15987, 3.9303], [15.05274, 3.9303], [14.42793, 3.31705], [14.15513, 2.66669], [14.10724, 2.26151]];  // (y, z) points — measured section convex hull at x=-1.341 (high-res tessellation)
b5_st21a_z0 = -1.341;  // extent along x
b5_st21a_z1 = -1.321;
b5_st21b_profile = [[14.24066, 1.51168], [14.60596, 0.90913], [15.05274, 0.5303], [17.15987, 0.5303], [17.78198, 1.13928], [18.05632, 1.78843], [18.08839, 2.4924], [17.87424, 3.16373], [17.15987, 3.9303], [15.05274, 3.9303], [14.43063, 3.32133], [14.15629, 2.67218], [14.10706, 2.25553]];  // (y, z) points — measured section convex hull at x=-0.941 (high-res tessellation)
b5_st21b_z0 = -0.941;  // extent along x
b5_st21b_z1 = -0.921;
b5_st22a_profile = [[14.24066, 1.51168], [14.60596, 0.90913], [15.05274, 0.5303], [17.15987, 0.5303], [17.78198, 1.13928], [18.05632, 1.78843], [18.08839, 2.4924], [17.87424, 3.16373], [17.15987, 3.9303], [15.05274, 3.9303], [14.43063, 3.32133], [14.15629, 2.67218], [14.10706, 2.25553]];  // (y, z) points — measured section convex hull at x=-0.941 (high-res tessellation)
b5_st22a_z0 = -0.941;  // extent along x
b5_st22a_z1 = -0.921;
b5_st22b_profile = [[14.23821, 1.51773], [14.60118, 0.91435], [15.05274, 0.5303], [17.15987, 0.5303], [17.6387, 0.94563], [17.98896, 1.55659], [18.10568, 2.25105], [17.9744, 2.94288], [17.61143, 3.54625], [17.15987, 3.9303], [15.05274, 3.9303], [14.5739, 3.51498], [14.22364, 2.90402], [14.10688, 2.24956]];  // (y, z) points — measured section convex hull at x=-0.541 (high-res tessellation)
b5_st22b_z0 = -0.541;  // extent along x
b5_st22b_z1 = -0.521;
b5_st23a_profile = [[14.23821, 1.51773], [14.60118, 0.91435], [15.05274, 0.5303], [17.15987, 0.5303], [17.6387, 0.94563], [17.98896, 1.55659], [18.10568, 2.25105], [17.9744, 2.94288], [17.61143, 3.54625], [17.15987, 3.9303], [15.05274, 3.9303], [14.5739, 3.51498], [14.22364, 2.90402], [14.10688, 2.24956]];  // (y, z) points — measured section convex hull at x=-0.541 (high-res tessellation)
b5_st23a_z0 = -0.541;  // extent along x
b5_st23a_z1 = -0.521;
b5_st23b_profile = [[14.23575, 1.52377], [14.5964, 0.91957], [15.05274, 0.5303], [17.15987, 0.5303], [17.63563, 0.94185], [17.98723, 1.55145], [18.10586, 2.24508], [17.97686, 2.93684], [17.61621, 3.54104], [17.15987, 3.9303], [15.05274, 3.9303], [14.57697, 3.51876], [14.22538, 2.90916], [14.1067, 2.24359]];  // (y, z) points — measured section convex hull at x=-0.141 (high-res tessellation)
b5_st23b_z0 = -0.141;  // extent along x
b5_st23b_z1 = -0.121;
b5_st24a_profile = [[14.23575, 1.52377], [14.5964, 0.91957], [15.05274, 0.5303], [17.15987, 0.5303], [17.63563, 0.94185], [17.98723, 1.55145], [18.10586, 2.24508], [17.97686, 2.93684], [17.61621, 3.54104], [17.15987, 3.9303], [15.05274, 3.9303], [14.57697, 3.51876], [14.22538, 2.90916], [14.1067, 2.24359]];  // (y, z) points — measured section convex hull at x=-0.141 (high-res tessellation)
b5_st24a_z0 = -0.141;  // extent along x
b5_st24a_z1 = -0.121;
b5_st24b_profile = [[14.2333, 1.52982], [14.59162, 0.92479], [15.05274, 0.5303], [17.15987, 0.5303], [17.63256, 0.93806], [17.98549, 1.54631], [18.10604, 2.23911], [17.97931, 2.93079], [17.62099, 3.53582], [17.15987, 3.9303], [15.05274, 3.9303], [14.58005, 3.52255], [14.22712, 2.9143], [14.10652, 2.23762]];  // (y, z) points — measured section convex hull at x=0.259 (high-res tessellation)
b5_st24b_z0 = 0.259;  // extent along x
b5_st24b_z1 = 0.279;
b5_st25a_profile = [[14.2333, 1.52982], [14.59162, 0.92479], [15.05274, 0.5303], [17.15987, 0.5303], [17.63256, 0.93806], [17.98549, 1.54631], [18.10604, 2.23911], [17.97931, 2.93079], [17.62099, 3.53582], [17.15987, 3.9303], [15.05274, 3.9303], [14.58005, 3.52255], [14.22712, 2.9143], [14.10652, 2.23762]];  // (y, z) points — measured section convex hull at x=0.259 (high-res tessellation)
b5_st25a_z0 = 0.259;  // extent along x
b5_st25a_z1 = 0.279;
b5_st25b_profile = [[14.23084, 1.53587], [14.58684, 0.93001], [15.05274, 0.5303], [17.15987, 0.5303], [17.62949, 0.93428], [17.98375, 1.54117], [18.10622, 2.23314], [17.98177, 2.92474], [17.62577, 3.5306], [17.15987, 3.9303], [15.05274, 3.9303], [14.58312, 3.52633], [14.22885, 2.91944], [14.10634, 2.23164]];  // (y, z) points — measured section convex hull at x=0.659 (high-res tessellation)
b5_st25b_z0 = 0.659;  // extent along x
b5_st25b_z1 = 0.679;
b5_st26a_profile = [[14.23084, 1.53587], [14.58684, 0.93001], [15.05274, 0.5303], [17.15987, 0.5303], [17.62949, 0.93428], [17.98375, 1.54117], [18.10622, 2.23314], [17.98177, 2.92474], [17.62577, 3.5306], [17.15987, 3.9303], [15.05274, 3.9303], [14.58312, 3.52633], [14.22885, 2.91944], [14.10634, 2.23164]];  // (y, z) points — measured section convex hull at x=0.659 (high-res tessellation)
b5_st26a_z0 = 0.659;  // extent along x
b5_st26a_z1 = 0.679;
b5_st26b_profile = [[13.75431, 1.74059], [14.04828, 1.06419], [14.55711, 0.5303], [17.6555, 0.5303], [18.16489, 1.06515], [18.45849, 1.74169], [18.50127, 2.47794], [18.288, 3.18394], [17.84476, 3.77337], [17.6555, 3.9303], [14.55625, 3.92959], [14.04772, 3.39546], [13.75431, 2.72002], [13.71114, 2.47685]];  // (y, z) points — measured section convex hull at x=1.059 (high-res tessellation)
b5_st26b_z0 = 1.059;  // extent along x
b5_st26b_z1 = 1.079;
b5_st27a_profile = [[13.75431, 1.74059], [14.04828, 1.06419], [14.55711, 0.5303], [17.6555, 0.5303], [18.16489, 1.06515], [18.45849, 1.74169], [18.50127, 2.47794], [18.288, 3.18394], [17.84476, 3.77337], [17.6555, 3.9303], [14.55625, 3.92959], [14.04772, 3.39546], [13.75431, 2.72002], [13.71114, 2.47685]];  // (y, z) points — measured section convex hull at x=1.059 (high-res tessellation)
b5_st27a_z0 = 1.059;  // extent along x
b5_st27a_z1 = 1.079;
b5_st27b_profile = [[13.76393, 1.70868], [14.07474, 1.02895], [14.55711, 0.5303], [17.6555, 0.5303], [18.16433, 1.06419], [18.466, 1.78398], [18.49564, 2.50966], [18.2664, 3.22106], [17.81996, 3.79394], [17.6555, 3.9303], [14.52732, 3.90561], [14.03151, 3.36762], [13.75431, 2.72002], [13.70856, 2.43286]];  // (y, z) points — measured section convex hull at x=1.459 (high-res tessellation)
b5_st27b_z0 = 1.459;  // extent along x
b5_st27b_z1 = 1.479;
b5_st28a_profile = [[13.76393, 1.70868], [14.07474, 1.02895], [14.55711, 0.5303], [17.6555, 0.5303], [18.16433, 1.06419], [18.466, 1.78398], [18.49564, 2.50966], [18.2664, 3.22106], [17.81996, 3.79394], [17.6555, 3.9303], [14.52732, 3.90561], [14.03151, 3.36762], [13.75431, 2.72002], [13.70856, 2.43286]];  // (y, z) points — measured section convex hull at x=1.459 (high-res tessellation)
b5_st28a_z0 = 1.459;  // extent along x
b5_st28a_z1 = 1.479;
b5_st28b_profile = [[13.86029, 1.42433], [14.367, 0.68794], [14.55711, 0.5303], [17.6555, 0.5303], [18.32111, 1.35251], [18.51146, 2.30645], [18.24479, 3.25818], [17.6555, 3.9303], [14.55711, 3.9303], [13.8915, 3.1081], [13.70636, 2.39534]];  // (y, z) points — measured section convex hull at x=1.859 (high-res tessellation)
b5_st28b_z0 = 1.859;  // extent along x
b5_st28b_z1 = 1.879;
b5_st29a_profile = [[13.86029, 1.42433], [14.367, 0.68794], [14.55711, 0.5303], [17.6555, 0.5303], [18.32111, 1.35251], [18.51146, 2.30645], [18.24479, 3.25818], [17.6555, 3.9303], [14.55711, 3.9303], [13.8915, 3.1081], [13.70636, 2.39534]];  // (y, z) points — measured section convex hull at x=1.859 (high-res tessellation)
b5_st29a_z0 = 1.859;  // extent along x
b5_st29a_z1 = 1.879;
b5_st29b_profile = [[13.92404, 1.27763], [14.55711, 0.5303], [17.6555, 0.5303], [18.28856, 1.27763], [18.51592, 2.2303], [18.28856, 3.18297], [17.6555, 3.9303], [14.55711, 3.9303], [13.92404, 3.18297], [13.70353, 2.34711]];  // (y, z) points — measured section convex hull at x=2.259 (high-res tessellation)
b5_st29b_z0 = 2.259;  // extent along x
b5_st29b_z1 = 2.279;
b5_st30a_profile = [[13.92404, 1.27763], [14.55711, 0.5303], [17.6555, 0.5303], [18.28856, 1.27763], [18.51592, 2.2303], [18.28856, 3.18297], [17.6555, 3.9303], [14.55711, 3.9303], [13.92404, 3.18297], [13.70353, 2.34711]];  // (y, z) points — measured section convex hull at x=2.259 (high-res tessellation)
b5_st30a_z0 = 2.259;  // extent along x
b5_st30a_z1 = 2.279;
b5_st30b_profile = [[13.82561, 1.50414], [14.19661, 0.86672], [14.55711, 0.5303], [17.6555, 0.5303], [18.16433, 1.06419], [18.45829, 1.74059], [18.50146, 2.47685], [18.28856, 3.18297], [17.84561, 3.77266], [17.6555, 3.9303], [14.55711, 3.9303], [14.04828, 3.39642], [13.75431, 2.72002], [13.70133, 2.30959]];  // (y, z) points — measured section convex hull at x=2.659 (high-res tessellation)
b5_st30b_z0 = 2.659;  // extent along x
b5_st30b_z1 = 2.679;
b5_st31a_profile = [[13.82561, 1.50414], [14.19661, 0.86672], [14.55711, 0.5303], [17.6555, 0.5303], [18.16433, 1.06419], [18.45829, 1.74059], [18.50146, 2.47685], [18.28856, 3.18297], [17.84561, 3.77266], [17.6555, 3.9303], [14.55711, 3.9303], [14.04828, 3.39642], [13.75431, 2.72002], [13.70133, 2.30959]];  // (y, z) points — measured section convex hull at x=2.659 (high-res tessellation)
b5_st31a_z0 = 2.659;  // extent along x
b5_st31a_z1 = 2.679;
b5_st31b_profile = [[13.82561, 1.50414], [14.19661, 0.86672], [14.55711, 0.5303], [17.6555, 0.5303], [18.16433, 1.06419], [18.45829, 1.74059], [18.50146, 2.47685], [18.28856, 3.18297], [17.84561, 3.77266], [17.6555, 3.9303], [14.55711, 3.9303], [14.04828, 3.39642], [13.75431, 2.72002], [13.69882, 2.26671]];  // (y, z) points — measured section convex hull at x=3.059 (high-res tessellation)
b5_st31b_z0 = 3.059;  // extent along x
b5_st31b_z1 = 3.079;
b5_st32a_profile = [[13.82561, 1.50414], [14.19661, 0.86672], [14.55711, 0.5303], [17.6555, 0.5303], [18.16433, 1.06419], [18.45829, 1.74059], [18.50146, 2.47685], [18.28856, 3.18297], [17.84561, 3.77266], [17.6555, 3.9303], [14.55711, 3.9303], [14.04828, 3.39642], [13.75431, 2.72002], [13.69882, 2.26671]];  // (y, z) points — measured section convex hull at x=3.059 (high-res tessellation)
b5_st32a_z0 = 3.059;  // extent along x
b5_st32a_z1 = 3.079;
b5_st32b_profile = [[13.75638, 1.73467], [14.05756, 1.05163], [14.55757, 0.5303], [17.65508, 0.5303], [18.28819, 1.27782], [18.50105, 1.98381], [18.38187, 2.96898], [18.01568, 3.59362], [17.65483, 3.9303], [14.5577, 3.9303], [14.04878, 3.39609], [13.7549, 2.71988], [13.70743, 2.40327]];  // (y, z) points — measured section convex hull at x=3.459 (high-res tessellation)
b5_st32b_z0 = 3.459;  // extent along x
b5_st32b_z1 = 3.479;
b5_st33a_profile = [[13.75638, 1.73467], [14.05756, 1.05163], [14.55757, 0.5303], [17.65508, 0.5303], [18.28819, 1.27782], [18.50105, 1.98381], [18.38187, 2.96898], [18.01568, 3.59362], [17.65483, 3.9303], [14.5577, 3.9303], [14.04878, 3.39609], [13.7549, 2.71988], [13.70743, 2.40327]];  // (y, z) points — measured section convex hull at x=3.459 (high-res tessellation)
b5_st33a_z0 = 3.459;  // extent along x
b5_st33a_z1 = 3.479;
b5_st33b_profile = [[13.82636, 1.73698], [14.46679, 0.69107], [14.67691, 0.5303], [17.61493, 0.58551], [18.10723, 1.10206], [18.40272, 1.81884], [18.42019, 2.54379], [18.20879, 3.18798], [17.74623, 3.77001], [17.53559, 3.9303], [14.66561, 3.92303], [14.24936, 3.5492], [13.82156, 2.70397], [13.77385, 2.36711]];  // (y, z) points — measured section convex hull at x=3.639 (high-res tessellation)
b5_st33b_z0 = 3.639;  // extent along x
b5_st33b_z1 = 3.659;
b5_pocket0_profile = [[3.39877, 18.53092], [3.398642, 18.50092], [1.065662, 18.498981], [0.9464, 18.456828], [0.866169, 18.380747], [0.823618, 18.290584], [0.798649, 18.091303], [-7.216358, 18.102733], [-7.20123, 18.621303]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.230304): fork slot / barb notch, vertical walls
b5_pocket0_z0 = 0.030304;  // extent along z
b5_pocket0_z1 = 4.430304;
b5_pocket1_profile = [[3.713642, 15.606303], [-3.232828, 15.591375], [-3.246285, 16.607773], [3.683642, 16.621303], [3.700113, 18.230848]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.230304): fork slot / barb notch, vertical walls
b5_pocket1_z0 = 0.030304;  // extent along z
b5_pocket1_z1 = 4.430304;
b5_pocket2_profile = [[-7.20123, 13.591304], [-7.201351, 14.124874], [0.798649, 14.121303], [0.823618, 13.922022], [0.866169, 13.831859], [0.9464, 13.755778], [1.065662, 13.713626], [3.413642, 13.69675]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.230304): fork slot / barb notch, vertical walls
b5_pocket2_z0 = 0.030304;  // extent along z
b5_pocket2_z1 = 4.430304;
b5_fn = 96;  // curve resolution

module body_5() {
    difference() {
        union() {
            hull() {
                // st00a: measured section convex hull at x=-9.531 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st00a_z0]) linear_extrude(b5_st00a_z1 - b5_st00a_z0) polygon(b5_st00a_profile);
                // st00b: measured section convex hull at x=-9.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st00b_z0]) linear_extrude(b5_st00b_z1 - b5_st00b_z0) polygon(b5_st00b_profile);
            }
            hull() {
                // st01a: measured section convex hull at x=-9.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st01a_z0]) linear_extrude(b5_st01a_z1 - b5_st01a_z0) polygon(b5_st01a_profile);
                // st01b: measured section convex hull at x=-8.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st01b_z0]) linear_extrude(b5_st01b_z1 - b5_st01b_z0) polygon(b5_st01b_profile);
            }
            hull() {
                // st02a: measured section convex hull at x=-8.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st02a_z0]) linear_extrude(b5_st02a_z1 - b5_st02a_z0) polygon(b5_st02a_profile);
                // st02b: measured section convex hull at x=-8.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st02b_z0]) linear_extrude(b5_st02b_z1 - b5_st02b_z0) polygon(b5_st02b_profile);
            }
            hull() {
                // st03a: measured section convex hull at x=-8.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st03a_z0]) linear_extrude(b5_st03a_z1 - b5_st03a_z0) polygon(b5_st03a_profile);
                // st03b: measured section convex hull at x=-8.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st03b_z0]) linear_extrude(b5_st03b_z1 - b5_st03b_z0) polygon(b5_st03b_profile);
            }
            hull() {
                // st04a: measured section convex hull at x=-8.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st04a_z0]) linear_extrude(b5_st04a_z1 - b5_st04a_z0) polygon(b5_st04a_profile);
                // st04b: measured section convex hull at x=-7.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st04b_z0]) linear_extrude(b5_st04b_z1 - b5_st04b_z0) polygon(b5_st04b_profile);
            }
            hull() {
                // st05a: measured section convex hull at x=-7.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st05a_z0]) linear_extrude(b5_st05a_z1 - b5_st05a_z0) polygon(b5_st05a_profile);
                // st05b: measured section convex hull at x=-7.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st05b_z0]) linear_extrude(b5_st05b_z1 - b5_st05b_z0) polygon(b5_st05b_profile);
            }
            hull() {
                // st06a: measured section convex hull at x=-7.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st06a_z0]) linear_extrude(b5_st06a_z1 - b5_st06a_z0) polygon(b5_st06a_profile);
                // st06b: measured section convex hull at x=-6.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st06b_z0]) linear_extrude(b5_st06b_z1 - b5_st06b_z0) polygon(b5_st06b_profile);
            }
            hull() {
                // st07a: measured section convex hull at x=-6.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st07a_z0]) linear_extrude(b5_st07a_z1 - b5_st07a_z0) polygon(b5_st07a_profile);
                // st07b: measured section convex hull at x=-6.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st07b_z0]) linear_extrude(b5_st07b_z1 - b5_st07b_z0) polygon(b5_st07b_profile);
            }
            hull() {
                // st08a: measured section convex hull at x=-6.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st08a_z0]) linear_extrude(b5_st08a_z1 - b5_st08a_z0) polygon(b5_st08a_profile);
                // st08b: measured section convex hull at x=-6.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st08b_z0]) linear_extrude(b5_st08b_z1 - b5_st08b_z0) polygon(b5_st08b_profile);
            }
            hull() {
                // st09a: measured section convex hull at x=-6.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st09a_z0]) linear_extrude(b5_st09a_z1 - b5_st09a_z0) polygon(b5_st09a_profile);
                // st09b: measured section convex hull at x=-5.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st09b_z0]) linear_extrude(b5_st09b_z1 - b5_st09b_z0) polygon(b5_st09b_profile);
            }
            hull() {
                // st10a: measured section convex hull at x=-5.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st10a_z0]) linear_extrude(b5_st10a_z1 - b5_st10a_z0) polygon(b5_st10a_profile);
                // st10b: measured section convex hull at x=-5.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st10b_z0]) linear_extrude(b5_st10b_z1 - b5_st10b_z0) polygon(b5_st10b_profile);
            }
            hull() {
                // st11a: measured section convex hull at x=-5.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st11a_z0]) linear_extrude(b5_st11a_z1 - b5_st11a_z0) polygon(b5_st11a_profile);
                // st11b: measured section convex hull at x=-4.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st11b_z0]) linear_extrude(b5_st11b_z1 - b5_st11b_z0) polygon(b5_st11b_profile);
            }
            hull() {
                // st12a: measured section convex hull at x=-4.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st12a_z0]) linear_extrude(b5_st12a_z1 - b5_st12a_z0) polygon(b5_st12a_profile);
                // st12b: measured section convex hull at x=-4.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st12b_z0]) linear_extrude(b5_st12b_z1 - b5_st12b_z0) polygon(b5_st12b_profile);
            }
            hull() {
                // st13a: measured section convex hull at x=-4.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st13a_z0]) linear_extrude(b5_st13a_z1 - b5_st13a_z0) polygon(b5_st13a_profile);
                // st13b: measured section convex hull at x=-4.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st13b_z0]) linear_extrude(b5_st13b_z1 - b5_st13b_z0) polygon(b5_st13b_profile);
            }
            hull() {
                // st14a: measured section convex hull at x=-4.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st14a_z0]) linear_extrude(b5_st14a_z1 - b5_st14a_z0) polygon(b5_st14a_profile);
                // st14b: measured section convex hull at x=-3.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st14b_z0]) linear_extrude(b5_st14b_z1 - b5_st14b_z0) polygon(b5_st14b_profile);
            }
            hull() {
                // st15a: measured section convex hull at x=-3.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st15a_z0]) linear_extrude(b5_st15a_z1 - b5_st15a_z0) polygon(b5_st15a_profile);
                // st15b: measured section convex hull at x=-3.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st15b_z0]) linear_extrude(b5_st15b_z1 - b5_st15b_z0) polygon(b5_st15b_profile);
            }
            hull() {
                // st16a: measured section convex hull at x=-3.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st16a_z0]) linear_extrude(b5_st16a_z1 - b5_st16a_z0) polygon(b5_st16a_profile);
                // st16b: measured section convex hull at x=-2.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st16b_z0]) linear_extrude(b5_st16b_z1 - b5_st16b_z0) polygon(b5_st16b_profile);
            }
            hull() {
                // st17a: measured section convex hull at x=-2.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st17a_z0]) linear_extrude(b5_st17a_z1 - b5_st17a_z0) polygon(b5_st17a_profile);
                // st17b: measured section convex hull at x=-2.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st17b_z0]) linear_extrude(b5_st17b_z1 - b5_st17b_z0) polygon(b5_st17b_profile);
            }
            hull() {
                // st18a: measured section convex hull at x=-2.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st18a_z0]) linear_extrude(b5_st18a_z1 - b5_st18a_z0) polygon(b5_st18a_profile);
                // st18b: measured section convex hull at x=-2.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st18b_z0]) linear_extrude(b5_st18b_z1 - b5_st18b_z0) polygon(b5_st18b_profile);
            }
            hull() {
                // st19a: measured section convex hull at x=-2.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st19a_z0]) linear_extrude(b5_st19a_z1 - b5_st19a_z0) polygon(b5_st19a_profile);
                // st19b: measured section convex hull at x=-1.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st19b_z0]) linear_extrude(b5_st19b_z1 - b5_st19b_z0) polygon(b5_st19b_profile);
            }
            hull() {
                // st20a: measured section convex hull at x=-1.741 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st20a_z0]) linear_extrude(b5_st20a_z1 - b5_st20a_z0) polygon(b5_st20a_profile);
                // st20b: measured section convex hull at x=-1.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st20b_z0]) linear_extrude(b5_st20b_z1 - b5_st20b_z0) polygon(b5_st20b_profile);
            }
            hull() {
                // st21a: measured section convex hull at x=-1.341 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st21a_z0]) linear_extrude(b5_st21a_z1 - b5_st21a_z0) polygon(b5_st21a_profile);
                // st21b: measured section convex hull at x=-0.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st21b_z0]) linear_extrude(b5_st21b_z1 - b5_st21b_z0) polygon(b5_st21b_profile);
            }
            hull() {
                // st22a: measured section convex hull at x=-0.941 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st22a_z0]) linear_extrude(b5_st22a_z1 - b5_st22a_z0) polygon(b5_st22a_profile);
                // st22b: measured section convex hull at x=-0.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st22b_z0]) linear_extrude(b5_st22b_z1 - b5_st22b_z0) polygon(b5_st22b_profile);
            }
            hull() {
                // st23a: measured section convex hull at x=-0.541 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st23a_z0]) linear_extrude(b5_st23a_z1 - b5_st23a_z0) polygon(b5_st23a_profile);
                // st23b: measured section convex hull at x=-0.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st23b_z0]) linear_extrude(b5_st23b_z1 - b5_st23b_z0) polygon(b5_st23b_profile);
            }
            hull() {
                // st24a: measured section convex hull at x=-0.141 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st24a_z0]) linear_extrude(b5_st24a_z1 - b5_st24a_z0) polygon(b5_st24a_profile);
                // st24b: measured section convex hull at x=0.259 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st24b_z0]) linear_extrude(b5_st24b_z1 - b5_st24b_z0) polygon(b5_st24b_profile);
            }
            hull() {
                // st25a: measured section convex hull at x=0.259 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st25a_z0]) linear_extrude(b5_st25a_z1 - b5_st25a_z0) polygon(b5_st25a_profile);
                // st25b: measured section convex hull at x=0.659 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st25b_z0]) linear_extrude(b5_st25b_z1 - b5_st25b_z0) polygon(b5_st25b_profile);
            }
            hull() {
                // st26a: measured section convex hull at x=0.659 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st26a_z0]) linear_extrude(b5_st26a_z1 - b5_st26a_z0) polygon(b5_st26a_profile);
                // st26b: measured section convex hull at x=1.059 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st26b_z0]) linear_extrude(b5_st26b_z1 - b5_st26b_z0) polygon(b5_st26b_profile);
            }
            hull() {
                // st27a: measured section convex hull at x=1.059 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st27a_z0]) linear_extrude(b5_st27a_z1 - b5_st27a_z0) polygon(b5_st27a_profile);
                // st27b: measured section convex hull at x=1.459 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st27b_z0]) linear_extrude(b5_st27b_z1 - b5_st27b_z0) polygon(b5_st27b_profile);
            }
            hull() {
                // st28a: measured section convex hull at x=1.459 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st28a_z0]) linear_extrude(b5_st28a_z1 - b5_st28a_z0) polygon(b5_st28a_profile);
                // st28b: measured section convex hull at x=1.859 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st28b_z0]) linear_extrude(b5_st28b_z1 - b5_st28b_z0) polygon(b5_st28b_profile);
            }
            hull() {
                // st29a: measured section convex hull at x=1.859 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st29a_z0]) linear_extrude(b5_st29a_z1 - b5_st29a_z0) polygon(b5_st29a_profile);
                // st29b: measured section convex hull at x=2.259 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st29b_z0]) linear_extrude(b5_st29b_z1 - b5_st29b_z0) polygon(b5_st29b_profile);
            }
            hull() {
                // st30a: measured section convex hull at x=2.259 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st30a_z0]) linear_extrude(b5_st30a_z1 - b5_st30a_z0) polygon(b5_st30a_profile);
                // st30b: measured section convex hull at x=2.659 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st30b_z0]) linear_extrude(b5_st30b_z1 - b5_st30b_z0) polygon(b5_st30b_profile);
            }
            hull() {
                // st31a: measured section convex hull at x=2.659 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st31a_z0]) linear_extrude(b5_st31a_z1 - b5_st31a_z0) polygon(b5_st31a_profile);
                // st31b: measured section convex hull at x=3.059 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st31b_z0]) linear_extrude(b5_st31b_z1 - b5_st31b_z0) polygon(b5_st31b_profile);
            }
            hull() {
                // st32a: measured section convex hull at x=3.059 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st32a_z0]) linear_extrude(b5_st32a_z1 - b5_st32a_z0) polygon(b5_st32a_profile);
                // st32b: measured section convex hull at x=3.459 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st32b_z0]) linear_extrude(b5_st32b_z1 - b5_st32b_z0) polygon(b5_st32b_profile);
            }
            hull() {
                // st33a: measured section convex hull at x=3.459 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st33a_z0]) linear_extrude(b5_st33a_z1 - b5_st33a_z0) polygon(b5_st33a_profile);
                // st33b: measured section convex hull at x=3.639 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b5_st33b_z0]) linear_extrude(b5_st33b_z1 - b5_st33b_z0) polygon(b5_st33b_profile);
            }
        }
        // pocket0: plan-view concavity (silhouette hull minus measured outline at z=2.230304): fork slot / barb notch, vertical walls
        translate([0, 0, b5_pocket0_z0]) linear_extrude(b5_pocket0_z1 - b5_pocket0_z0) polygon(b5_pocket0_profile);
        // pocket1: plan-view concavity (silhouette hull minus measured outline at z=2.230304): fork slot / barb notch, vertical walls
        translate([0, 0, b5_pocket1_z0]) linear_extrude(b5_pocket1_z1 - b5_pocket1_z0) polygon(b5_pocket1_profile);
        // pocket2: plan-view concavity (silhouette hull minus measured outline at z=2.230304): fork slot / barb notch, vertical walls
        translate([0, 0, b5_pocket2_z0]) linear_extrude(b5_pocket2_z1 - b5_pocket2_z0) polygon(b5_pocket2_profile);
    }
}

// ---- body 6 (strategy: csg — agent plan) ----
// plan: hull-loft along y from measured sections; plan-view concavity cutters (fork slot/barb notches); engraved label grooves (<0.3 mm³) intentionally omitted
b6_st00a_profile = [[0.92068, -28.41919], [1.84976, -28.83646], [2.77249, -28.77475], [3.43993, -28.41919], [3.43993, -25.28956], [2.51085, -24.87229], [1.58812, -24.934], [0.92068, -25.28956]];  // (z, x) points — measured section convex hull at y=-19.147 (high-res tessellation)
b6_st00a_z0 = -19.147;  // extent along y
b6_st00a_z1 = -19.127;
b6_st00b_profile = [[0.73068, -28.50804], [1.22332, -28.83481], [1.86856, -29.03144], [2.54293, -29.0231], [3.18285, -28.81067], [3.62993, -28.50804], [3.62993, -25.20071], [3.08939, -24.85486], [2.49205, -24.67731], [1.81767, -24.68565], [1.17776, -24.89808], [0.73068, -25.20071]];  // (z, x) points — measured section convex hull at y=-18.957 (high-res tessellation)
b6_st00b_z0 = -18.957;  // extent along y
b6_st00b_z1 = -18.937;
b6_st01a_profile = [[0.73068, -28.50804], [1.22332, -28.83481], [1.86856, -29.03144], [2.54293, -29.0231], [3.18285, -28.81067], [3.62993, -28.50804], [3.62993, -25.20071], [3.08939, -24.85486], [2.49205, -24.67731], [1.81767, -24.68565], [1.17776, -24.89808], [0.73068, -25.20071]];  // (z, x) points — measured section convex hull at y=-18.957 (high-res tessellation)
b6_st01a_z0 = -18.957;  // extent along y
b6_st01a_z1 = -18.937;
b6_st01b_profile = [[0.5303, -28.59722], [1.24173, -29.06013], [2.21722, -29.25238], [2.98071, -29.11516], [3.66046, -28.74142], [3.8303, -28.59722], [3.8303, -25.11153], [3.13611, -24.65549], [2.40278, -24.46643], [1.62893, -24.52033], [0.91277, -24.81842], [0.5303, -25.11153]];  // (z, x) points — measured section convex hull at y=-18.557 (high-res tessellation)
b6_st01b_z0 = -18.557;  // extent along y
b6_st01b_z1 = -18.537;
b6_st02a_profile = [[0.5303, -28.59722], [1.24173, -29.06013], [2.21722, -29.25238], [2.98071, -29.11516], [3.66046, -28.74142], [3.8303, -28.59722], [3.8303, -25.11153], [3.13611, -24.65549], [2.40278, -24.46643], [1.62893, -24.52033], [0.91277, -24.81842], [0.5303, -25.11153]];  // (z, x) points — measured section convex hull at y=-18.557 (high-res tessellation)
b6_st02a_z0 = -18.557;  // extent along y
b6_st02a_z1 = -18.537;
b6_st02b_profile = [[0.5303, -28.59722], [1.17291, -29.03272], [1.92091, -29.24032], [2.69605, -29.19831], [3.41723, -28.91108], [3.8303, -28.59722], [3.8303, -25.11153], [3.1877, -24.67604], [2.4397, -24.46844], [1.66456, -24.51045], [0.94338, -24.79768], [0.5303, -25.11153]];  // (z, x) points — measured section convex hull at y=-18.157 (high-res tessellation)
b6_st02b_z0 = -18.157;  // extent along y
b6_st02b_z1 = -18.137;
b6_st03a_profile = [[0.5303, -28.59722], [1.17291, -29.03272], [1.92091, -29.24032], [2.69605, -29.19831], [3.41723, -28.91108], [3.8303, -28.59722], [3.8303, -25.11153], [3.1877, -24.67604], [2.4397, -24.46844], [1.66456, -24.51045], [0.94338, -24.79768], [0.5303, -25.11153]];  // (z, x) points — measured section convex hull at y=-18.157 (high-res tessellation)
b6_st03a_z0 = -18.157;  // extent along y
b6_st03a_z1 = -18.137;
b6_st03b_profile = [[0.5303, -27.79645], [0.99071, -28.33531], [1.60664, -28.66539], [2.30532, -28.74981], [2.98229, -28.57649], [3.55328, -28.1672], [3.8303, -27.79645], [3.8303, -25.9123], [3.37195, -25.37491], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-17.757 (high-res tessellation)
b6_st03b_z0 = -17.757;  // extent along y
b6_st03b_z1 = -17.737;
b6_st04a_profile = [[0.5303, -27.79645], [0.99071, -28.33531], [1.60664, -28.66539], [2.30532, -28.74981], [2.98229, -28.57649], [3.55328, -28.1672], [3.8303, -27.79645], [3.8303, -25.9123], [3.37195, -25.37491], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-17.757 (high-res tessellation)
b6_st04a_z0 = -17.757;  // extent along y
b6_st04a_z1 = -17.737;
b6_st04b_profile = [[0.5303, -27.79645], [0.99792, -28.34044], [1.60175, -28.66415], [2.31535, -28.74856], [2.99118, -28.57169], [3.55901, -28.16046], [3.8303, -27.79645], [3.8303, -25.9123], [3.36166, -25.36758], [2.75886, -25.0446], [2.04777, -24.95988], [1.3672, -25.13827], [0.79996, -25.55022], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-17.357 (high-res tessellation)
b6_st04b_z0 = -17.357;  // extent along y
b6_st04b_z1 = -17.337;
b6_st05a_profile = [[0.5303, -27.79645], [0.99792, -28.34044], [1.60175, -28.66415], [2.31535, -28.74856], [2.99118, -28.57169], [3.55901, -28.16046], [3.8303, -27.79645], [3.8303, -25.9123], [3.36166, -25.36758], [2.75886, -25.0446], [2.04777, -24.95988], [1.3672, -25.13827], [0.79996, -25.55022], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-17.357 (high-res tessellation)
b6_st05a_z0 = -17.357;  // extent along y
b6_st05a_z1 = -17.337;
b6_st05b_profile = [[0.5303, -27.79645], [1.00512, -28.34557], [1.62869, -28.67096], [2.32413, -28.74747], [3.00119, -28.56628], [3.56555, -28.15276], [3.8303, -27.79645], [3.8303, -25.9123], [3.35446, -25.36245], [2.75886, -25.0446], [2.03523, -24.96144], [1.36053, -25.14187], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-16.957 (high-res tessellation)
b6_st05b_z0 = -16.957;  // extent along y
b6_st05b_z1 = -16.937;
b6_st06a_profile = [[0.5303, -27.79645], [1.00512, -28.34557], [1.62869, -28.67096], [2.32413, -28.74747], [3.00119, -28.56628], [3.56555, -28.15276], [3.8303, -27.79645], [3.8303, -25.9123], [3.35446, -25.36245], [2.75886, -25.0446], [2.03523, -24.96144], [1.36053, -25.14187], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-16.957 (high-res tessellation)
b6_st06a_z0 = -16.957;  // extent along y
b6_st06a_z1 = -16.937;
b6_st06b_profile = [[0.5303, -27.79645], [1.01541, -28.3529], [1.63604, -28.67282], [2.33416, -28.74622], [3.00897, -28.56208], [3.57292, -28.14409], [3.8303, -27.79645], [3.8303, -25.9123], [3.34725, -25.35732], [2.75886, -25.0446], [2.0628, -24.95801], [1.35164, -25.14667], [0.78687, -25.56562], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-16.557 (high-res tessellation)
b6_st06b_z0 = -16.557;  // extent along y
b6_st06b_z1 = -16.537;
b6_st07a_profile = [[0.5303, -27.79645], [1.01541, -28.3529], [1.63604, -28.67282], [2.33416, -28.74622], [3.00897, -28.56208], [3.57292, -28.14409], [3.8303, -27.79645], [3.8303, -25.9123], [3.34725, -25.35732], [2.75886, -25.0446], [2.0628, -24.95801], [1.35164, -25.14667], [0.78687, -25.56562], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-16.557 (high-res tessellation)
b6_st07a_z0 = -16.557;  // extent along y
b6_st07a_z1 = -16.537;
b6_st07b_profile = [[0.5303, -27.79645], [1.02262, -28.35803], [1.60175, -28.66415], [2.34293, -28.74513], [3.02009, -28.55608], [3.58028, -28.13543], [3.8303, -27.79645], [3.8303, -25.9123], [3.33696, -25.34999], [2.71232, -25.03284], [2.01642, -24.96378], [1.34163, -25.15207], [0.78196, -25.5714], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-16.157 (high-res tessellation)
b6_st07b_z0 = -16.157;  // extent along y
b6_st07b_z1 = -16.137;
b6_st08a_profile = [[0.5303, -27.79645], [1.02262, -28.35803], [1.60175, -28.66415], [2.34293, -28.74513], [3.02009, -28.55608], [3.58028, -28.13543], [3.8303, -27.79645], [3.8303, -25.9123], [3.33696, -25.34999], [2.71232, -25.03284], [2.01642, -24.96378], [1.34163, -25.15207], [0.78196, -25.5714], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-16.157 (high-res tessellation)
b6_st08a_z0 = -16.157;  // extent along y
b6_st08a_z1 = -16.137;
b6_st08b_profile = [[0.5303, -27.79645], [1.02982, -28.36316], [1.65809, -28.67839], [2.35547, -28.74357], [3.02676, -28.55248], [3.58683, -28.12773], [3.8303, -27.79645], [3.8303, -25.9123], [3.32976, -25.34486], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-15.757 (high-res tessellation)
b6_st08b_z0 = -15.757;  // extent along y
b6_st08b_z1 = -15.737;
b6_st09a_profile = [[0.5303, -27.79645], [1.02982, -28.36316], [1.65809, -28.67839], [2.35547, -28.74357], [3.02676, -28.55248], [3.58683, -28.12773], [3.8303, -27.79645], [3.8303, -25.9123], [3.32976, -25.34486], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-15.757 (high-res tessellation)
b6_st09a_z0 = -15.757;  // extent along y
b6_st09a_z1 = -15.737;
b6_st09b_profile = [[0.5303, -27.79645], [1.04011, -28.37049], [1.60175, -28.66415], [2.3655, -28.74232], [3.23815, -28.42913], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.32255, -25.33973], [2.75886, -25.0446], [1.99761, -24.96612], [1.12246, -25.27962], [0.65922, -25.71582], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-15.357 (high-res tessellation)
b6_st09b_z0 = -15.357;  // extent along y
b6_st09b_z1 = -15.337;
b6_st10a_profile = [[0.5303, -27.79645], [1.04011, -28.37049], [1.60175, -28.66415], [2.3655, -28.74232], [3.23815, -28.42913], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.32255, -25.33973], [2.75886, -25.0446], [1.99761, -24.96612], [1.12246, -25.27962], [0.65922, -25.71582], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-15.357 (high-res tessellation)
b6_st10a_z0 = -15.357;  // extent along y
b6_st10a_z1 = -15.337;
b6_st10b_profile = [[0.5303, -27.79645], [1.24489, -28.50445], [2.0628, -28.75074], [2.97785, -28.57888], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.31606, -25.16588], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-14.957 (high-res tessellation)
b6_st10b_z0 = -14.957;  // extent along y
b6_st10b_z1 = -14.937;
b6_st11a_profile = [[0.5303, -27.79645], [1.24489, -28.50445], [2.0628, -28.75074], [2.97785, -28.57888], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.31606, -25.16588], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-14.957 (high-res tessellation)
b6_st11a_z0 = -14.957;  // extent along y
b6_st11a_z1 = -14.937;
b6_st11b_profile = [[0.5303, -27.79645], [1.25156, -28.50805], [2.0628, -28.75074], [2.75886, -28.66415], [3.60483, -28.10655], [3.8303, -27.79645], [3.8303, -25.9123], [3.10682, -25.1995], [2.29781, -24.95801], [1.60175, -25.0446], [0.75414, -25.60413], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-14.557 (high-res tessellation)
b6_st11b_z0 = -14.557;  // extent along y
b6_st11b_z1 = -14.537;
b6_st12a_profile = [[0.5303, -27.79645], [1.25156, -28.50805], [2.0628, -28.75074], [2.75886, -28.66415], [3.60483, -28.10655], [3.8303, -27.79645], [3.8303, -25.9123], [3.10682, -25.1995], [2.29781, -24.95801], [1.60175, -25.0446], [0.75414, -25.60413], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-14.557 (high-res tessellation)
b6_st12a_z0 = -14.557;  // extent along y
b6_st12a_z1 = -14.537;
b6_st12b_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [3.06456, -28.53207], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.09793, -25.1947], [2.29781, -24.95801], [1.60175, -25.0446], [0.74923, -25.60991], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-14.157 (high-res tessellation)
b6_st12b_z0 = -14.157;  // extent along y
b6_st12b_z1 = -14.137;
b6_st13a_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [3.06456, -28.53207], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.09793, -25.1947], [2.29781, -24.95801], [1.60175, -25.0446], [0.74923, -25.60991], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-14.157 (high-res tessellation)
b6_st13a_z0 = -14.157;  // extent along y
b6_st13a_z1 = -14.137;
b6_st13b_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [3.07123, -28.52847], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.09126, -25.1911], [2.29781, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-13.757 (high-res tessellation)
b6_st13b_z0 = -13.757;  // extent along y
b6_st13b_z1 = -13.737;
b6_st14a_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [3.07123, -28.52847], [3.70138, -27.99294], [3.8303, -27.79645], [3.8303, -25.9123], [3.09126, -25.1911], [2.29781, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-13.757 (high-res tessellation)
b6_st14a_z0 = -13.757;  // extent along y
b6_st14a_z1 = -13.737;
b6_st14b_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [2.75886, -28.66415], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.38276, -25.12987], [0.65922, -25.71582], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-13.357 (high-res tessellation)
b6_st14b_z0 = -13.357;  // extent along y
b6_st14b_z1 = -13.337;
b6_st15a_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [2.75886, -28.66415], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.38276, -25.12987], [0.65922, -25.71582], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-13.357 (high-res tessellation)
b6_st15a_z0 = -13.357;  // extent along y
b6_st15a_z1 = -13.337;
b6_st15b_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [2.75886, -28.66415], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-12.957 (high-res tessellation)
b6_st15b_z0 = -12.957;  // extent along y
b6_st15b_z1 = -12.937;
b6_st16a_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [2.75886, -28.66415], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-12.957 (high-res tessellation)
b6_st16a_z0 = -12.957;  // extent along y
b6_st16a_z1 = -12.937;
b6_st16b_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [2.97785, -28.57888], [3.75476, -27.91159], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.60175, -25.0446], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-12.557 (high-res tessellation)
b6_st16b_z0 = -12.557;  // extent along y
b6_st16b_z1 = -12.537;
b6_st17a_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [2.0628, -28.75074], [2.97785, -28.57888], [3.75476, -27.91159], [3.8303, -27.79645], [3.8303, -25.9123], [3.18464, -25.24152], [2.29781, -24.95801], [1.60175, -25.0446], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-12.557 (high-res tessellation)
b6_st17a_z0 = -12.557;  // extent along y
b6_st17a_z1 = -12.537;
b6_st17b_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [1.82959, -28.72173], [2.75886, -28.66415], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.17597, -25.24152], [0.65922, -25.71582], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-12.157 (high-res tessellation)
b6_st17b_z0 = -12.157;  // extent along y
b6_st17b_z1 = -12.137;
b6_st18a_profile = [[0.5303, -27.79645], [1.17597, -28.46724], [1.82959, -28.72173], [2.75886, -28.66415], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.17597, -25.24152], [0.65922, -25.71582], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-12.157 (high-res tessellation)
b6_st18a_z0 = -12.157;  // extent along y
b6_st18a_z1 = -12.137;
b6_st18b_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-11.757 (high-res tessellation)
b6_st18b_z0 = -11.757;  // extent along y
b6_st18b_z1 = -11.737;
b6_st19a_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-11.757 (high-res tessellation)
b6_st19a_z0 = -11.757;  // extent along y
b6_st19a_z1 = -11.737;
b6_st19b_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-11.357 (high-res tessellation)
b6_st19b_z0 = -11.357;  // extent along y
b6_st19b_z1 = -11.337;
b6_st20a_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-11.357 (high-res tessellation)
b6_st20a_z0 = -11.357;  // extent along y
b6_st20a_z1 = -11.337;
b6_st20b_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-10.957 (high-res tessellation)
b6_st20b_z0 = -10.957;  // extent along y
b6_st20b_z1 = -10.937;
b6_st21a_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8303, -25.9123], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-10.957 (high-res tessellation)
b6_st21a_z0 = -10.957;  // extent along y
b6_st21a_z1 = -10.937;
b6_st21b_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.80396, -25.87215], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-10.557 (high-res tessellation)
b6_st21b_z0 = -10.557;  // extent along y
b6_st21b_z1 = -10.537;
b6_st22a_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.80396, -25.87215], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-10.557 (high-res tessellation)
b6_st22a_z0 = -10.557;  // extent along y
b6_st22a_z1 = -10.537;
b6_st22b_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8102, -25.88166], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-10.157 (high-res tessellation)
b6_st22b_z0 = -10.157;  // extent along y
b6_st22b_z1 = -10.137;
b6_st23a_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.8102, -25.88166], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-10.157 (high-res tessellation)
b6_st23a_z0 = -10.157;  // extent along y
b6_st23a_z1 = -10.137;
b6_st23b_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.81644, -25.89117], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-9.757 (high-res tessellation)
b6_st23b_z0 = -9.757;  // extent along y
b6_st23b_z1 = -9.737;
b6_st24a_profile = [[0.5303, -27.79645], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.81644, -25.89117], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-9.757 (high-res tessellation)
b6_st24a_z0 = -9.757;  // extent along y
b6_st24a_z1 = -9.737;
b6_st24b_profile = [[0.54001, -27.81125], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.82129, -25.89856], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-9.357 (high-res tessellation)
b6_st24b_z0 = -9.357;  // extent along y
b6_st24b_z1 = -9.337;
b6_st25a_profile = [[0.54001, -27.81125], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.82129, -25.89856], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-9.357 (high-res tessellation)
b6_st25a_z0 = -9.357;  // extent along y
b6_st25a_z1 = -9.337;
b6_st25b_profile = [[0.53377, -27.80174], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.82753, -25.90807], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-8.957 (high-res tessellation)
b6_st25b_z0 = -8.957;  // extent along y
b6_st25b_z1 = -8.937;
b6_st26a_profile = [[0.53377, -27.80174], [0.98455, -28.33091], [1.60175, -28.66415], [2.29781, -28.75074], [2.97785, -28.57888], [3.54919, -28.172], [3.8303, -27.79645], [3.82753, -25.90807], [3.37606, -25.37784], [2.75886, -25.0446], [2.0628, -24.95801], [1.38276, -25.12987], [0.81141, -25.53675], [0.5303, -25.9123]];  // (z, x) points — measured section convex hull at y=-8.957 (high-res tessellation)
b6_st26a_z0 = -8.957;  // extent along y
b6_st26a_z1 = -8.937;
b6_st26b_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-8.557 (high-res tessellation)
b6_st26b_z0 = -8.557;  // extent along y
b6_st26b_z1 = -8.537;
b6_st27a_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-8.557 (high-res tessellation)
b6_st27a_z0 = -8.557;  // extent along y
b6_st27a_z1 = -8.537;
b6_st27b_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-8.157 (high-res tessellation)
b6_st27b_z0 = -8.157;  // extent along y
b6_st27b_z1 = -8.137;
b6_st28a_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-8.157 (high-res tessellation)
b6_st28a_z0 = -8.157;  // extent along y
b6_st28a_z1 = -8.137;
b6_st28b_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-7.757 (high-res tessellation)
b6_st28b_z0 = -7.757;  // extent along y
b6_st28b_z1 = -7.737;
b6_st29a_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-7.757 (high-res tessellation)
b6_st29a_z0 = -7.757;  // extent along y
b6_st29a_z1 = -7.737;
b6_st29b_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-7.357 (high-res tessellation)
b6_st29b_z0 = -7.357;  // extent along y
b6_st29b_z1 = -7.337;
b6_st30a_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-7.357 (high-res tessellation)
b6_st30a_z0 = -7.357;  // extent along y
b6_st30a_z1 = -7.337;
b6_st30b_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-6.957 (high-res tessellation)
b6_st30b_z0 = -6.957;  // extent along y
b6_st30b_z1 = -6.937;
b6_st31a_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-6.957 (high-res tessellation)
b6_st31a_z0 = -6.957;  // extent along y
b6_st31a_z1 = -6.937;
b6_st31b_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-6.557 (high-res tessellation)
b6_st31b_z0 = -6.557;  // extent along y
b6_st31b_z1 = -6.537;
b6_st32a_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-6.557 (high-res tessellation)
b6_st32a_z0 = -6.557;  // extent along y
b6_st32a_z1 = -6.537;
b6_st32b_profile = [[0.5303, -29.60438], [3.8303, -29.60438], [3.8303, -24.10438], [0.5303, -24.10438]];  // (z, x) points — measured section convex hull at y=-6.267 (high-res tessellation)
b6_st32b_z0 = -6.267;  // extent along y
b6_st32b_z1 = -6.247;
b6_pocket0_profile = [[-29.619368, -8.707148], [-28.73574, -8.706623], [-28.735812, -18.008093], [-29.239377, -18.021623], [-29.254115, -18.721621]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b6_pocket0_z0 = 0.030304;  // extent along z
b6_pocket0_z1 = 4.330304;
b6_pocket1_profile = [[-24.439386, -18.707148], [-24.469377, -18.706623], [-24.469377, -18.021623], [-24.972942, -18.008093], [-24.959484, -8.691695], [-24.089409, -8.705643]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b6_pocket1_z0 = 0.030304;  // extent along z
b6_pocket1_z1 = 4.330304;
b6_pocket2_profile = [[-27.354377, -19.221623], [-27.369305, -11.305153], [-26.352907, -11.291695], [-26.339449, -19.208093]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b6_pocket2_z0 = 0.030304;  // extent along z
b6_pocket2_z1 = 4.330304;
b6_fn = 96;  // curve resolution

module body_6() {
    difference() {
        union() {
            hull() {
                // st00a: measured section convex hull at y=-19.147 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st00a_z0]) linear_extrude(b6_st00a_z1 - b6_st00a_z0) polygon(b6_st00a_profile);
                // st00b: measured section convex hull at y=-18.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st00b_z0]) linear_extrude(b6_st00b_z1 - b6_st00b_z0) polygon(b6_st00b_profile);
            }
            hull() {
                // st01a: measured section convex hull at y=-18.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st01a_z0]) linear_extrude(b6_st01a_z1 - b6_st01a_z0) polygon(b6_st01a_profile);
                // st01b: measured section convex hull at y=-18.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st01b_z0]) linear_extrude(b6_st01b_z1 - b6_st01b_z0) polygon(b6_st01b_profile);
            }
            hull() {
                // st02a: measured section convex hull at y=-18.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st02a_z0]) linear_extrude(b6_st02a_z1 - b6_st02a_z0) polygon(b6_st02a_profile);
                // st02b: measured section convex hull at y=-18.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st02b_z0]) linear_extrude(b6_st02b_z1 - b6_st02b_z0) polygon(b6_st02b_profile);
            }
            hull() {
                // st03a: measured section convex hull at y=-18.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st03a_z0]) linear_extrude(b6_st03a_z1 - b6_st03a_z0) polygon(b6_st03a_profile);
                // st03b: measured section convex hull at y=-17.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st03b_z0]) linear_extrude(b6_st03b_z1 - b6_st03b_z0) polygon(b6_st03b_profile);
            }
            hull() {
                // st04a: measured section convex hull at y=-17.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st04a_z0]) linear_extrude(b6_st04a_z1 - b6_st04a_z0) polygon(b6_st04a_profile);
                // st04b: measured section convex hull at y=-17.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st04b_z0]) linear_extrude(b6_st04b_z1 - b6_st04b_z0) polygon(b6_st04b_profile);
            }
            hull() {
                // st05a: measured section convex hull at y=-17.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st05a_z0]) linear_extrude(b6_st05a_z1 - b6_st05a_z0) polygon(b6_st05a_profile);
                // st05b: measured section convex hull at y=-16.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st05b_z0]) linear_extrude(b6_st05b_z1 - b6_st05b_z0) polygon(b6_st05b_profile);
            }
            hull() {
                // st06a: measured section convex hull at y=-16.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st06a_z0]) linear_extrude(b6_st06a_z1 - b6_st06a_z0) polygon(b6_st06a_profile);
                // st06b: measured section convex hull at y=-16.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st06b_z0]) linear_extrude(b6_st06b_z1 - b6_st06b_z0) polygon(b6_st06b_profile);
            }
            hull() {
                // st07a: measured section convex hull at y=-16.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st07a_z0]) linear_extrude(b6_st07a_z1 - b6_st07a_z0) polygon(b6_st07a_profile);
                // st07b: measured section convex hull at y=-16.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st07b_z0]) linear_extrude(b6_st07b_z1 - b6_st07b_z0) polygon(b6_st07b_profile);
            }
            hull() {
                // st08a: measured section convex hull at y=-16.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st08a_z0]) linear_extrude(b6_st08a_z1 - b6_st08a_z0) polygon(b6_st08a_profile);
                // st08b: measured section convex hull at y=-15.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st08b_z0]) linear_extrude(b6_st08b_z1 - b6_st08b_z0) polygon(b6_st08b_profile);
            }
            hull() {
                // st09a: measured section convex hull at y=-15.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st09a_z0]) linear_extrude(b6_st09a_z1 - b6_st09a_z0) polygon(b6_st09a_profile);
                // st09b: measured section convex hull at y=-15.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st09b_z0]) linear_extrude(b6_st09b_z1 - b6_st09b_z0) polygon(b6_st09b_profile);
            }
            hull() {
                // st10a: measured section convex hull at y=-15.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st10a_z0]) linear_extrude(b6_st10a_z1 - b6_st10a_z0) polygon(b6_st10a_profile);
                // st10b: measured section convex hull at y=-14.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st10b_z0]) linear_extrude(b6_st10b_z1 - b6_st10b_z0) polygon(b6_st10b_profile);
            }
            hull() {
                // st11a: measured section convex hull at y=-14.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st11a_z0]) linear_extrude(b6_st11a_z1 - b6_st11a_z0) polygon(b6_st11a_profile);
                // st11b: measured section convex hull at y=-14.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st11b_z0]) linear_extrude(b6_st11b_z1 - b6_st11b_z0) polygon(b6_st11b_profile);
            }
            hull() {
                // st12a: measured section convex hull at y=-14.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st12a_z0]) linear_extrude(b6_st12a_z1 - b6_st12a_z0) polygon(b6_st12a_profile);
                // st12b: measured section convex hull at y=-14.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st12b_z0]) linear_extrude(b6_st12b_z1 - b6_st12b_z0) polygon(b6_st12b_profile);
            }
            hull() {
                // st13a: measured section convex hull at y=-14.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st13a_z0]) linear_extrude(b6_st13a_z1 - b6_st13a_z0) polygon(b6_st13a_profile);
                // st13b: measured section convex hull at y=-13.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st13b_z0]) linear_extrude(b6_st13b_z1 - b6_st13b_z0) polygon(b6_st13b_profile);
            }
            hull() {
                // st14a: measured section convex hull at y=-13.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st14a_z0]) linear_extrude(b6_st14a_z1 - b6_st14a_z0) polygon(b6_st14a_profile);
                // st14b: measured section convex hull at y=-13.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st14b_z0]) linear_extrude(b6_st14b_z1 - b6_st14b_z0) polygon(b6_st14b_profile);
            }
            hull() {
                // st15a: measured section convex hull at y=-13.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st15a_z0]) linear_extrude(b6_st15a_z1 - b6_st15a_z0) polygon(b6_st15a_profile);
                // st15b: measured section convex hull at y=-12.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st15b_z0]) linear_extrude(b6_st15b_z1 - b6_st15b_z0) polygon(b6_st15b_profile);
            }
            hull() {
                // st16a: measured section convex hull at y=-12.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st16a_z0]) linear_extrude(b6_st16a_z1 - b6_st16a_z0) polygon(b6_st16a_profile);
                // st16b: measured section convex hull at y=-12.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st16b_z0]) linear_extrude(b6_st16b_z1 - b6_st16b_z0) polygon(b6_st16b_profile);
            }
            hull() {
                // st17a: measured section convex hull at y=-12.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st17a_z0]) linear_extrude(b6_st17a_z1 - b6_st17a_z0) polygon(b6_st17a_profile);
                // st17b: measured section convex hull at y=-12.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st17b_z0]) linear_extrude(b6_st17b_z1 - b6_st17b_z0) polygon(b6_st17b_profile);
            }
            hull() {
                // st18a: measured section convex hull at y=-12.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st18a_z0]) linear_extrude(b6_st18a_z1 - b6_st18a_z0) polygon(b6_st18a_profile);
                // st18b: measured section convex hull at y=-11.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st18b_z0]) linear_extrude(b6_st18b_z1 - b6_st18b_z0) polygon(b6_st18b_profile);
            }
            hull() {
                // st19a: measured section convex hull at y=-11.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st19a_z0]) linear_extrude(b6_st19a_z1 - b6_st19a_z0) polygon(b6_st19a_profile);
                // st19b: measured section convex hull at y=-11.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st19b_z0]) linear_extrude(b6_st19b_z1 - b6_st19b_z0) polygon(b6_st19b_profile);
            }
            hull() {
                // st20a: measured section convex hull at y=-11.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st20a_z0]) linear_extrude(b6_st20a_z1 - b6_st20a_z0) polygon(b6_st20a_profile);
                // st20b: measured section convex hull at y=-10.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st20b_z0]) linear_extrude(b6_st20b_z1 - b6_st20b_z0) polygon(b6_st20b_profile);
            }
            hull() {
                // st21a: measured section convex hull at y=-10.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st21a_z0]) linear_extrude(b6_st21a_z1 - b6_st21a_z0) polygon(b6_st21a_profile);
                // st21b: measured section convex hull at y=-10.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st21b_z0]) linear_extrude(b6_st21b_z1 - b6_st21b_z0) polygon(b6_st21b_profile);
            }
            hull() {
                // st22a: measured section convex hull at y=-10.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st22a_z0]) linear_extrude(b6_st22a_z1 - b6_st22a_z0) polygon(b6_st22a_profile);
                // st22b: measured section convex hull at y=-10.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st22b_z0]) linear_extrude(b6_st22b_z1 - b6_st22b_z0) polygon(b6_st22b_profile);
            }
            hull() {
                // st23a: measured section convex hull at y=-10.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st23a_z0]) linear_extrude(b6_st23a_z1 - b6_st23a_z0) polygon(b6_st23a_profile);
                // st23b: measured section convex hull at y=-9.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st23b_z0]) linear_extrude(b6_st23b_z1 - b6_st23b_z0) polygon(b6_st23b_profile);
            }
            hull() {
                // st24a: measured section convex hull at y=-9.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st24a_z0]) linear_extrude(b6_st24a_z1 - b6_st24a_z0) polygon(b6_st24a_profile);
                // st24b: measured section convex hull at y=-9.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st24b_z0]) linear_extrude(b6_st24b_z1 - b6_st24b_z0) polygon(b6_st24b_profile);
            }
            hull() {
                // st25a: measured section convex hull at y=-9.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st25a_z0]) linear_extrude(b6_st25a_z1 - b6_st25a_z0) polygon(b6_st25a_profile);
                // st25b: measured section convex hull at y=-8.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st25b_z0]) linear_extrude(b6_st25b_z1 - b6_st25b_z0) polygon(b6_st25b_profile);
            }
            hull() {
                // st26a: measured section convex hull at y=-8.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st26a_z0]) linear_extrude(b6_st26a_z1 - b6_st26a_z0) polygon(b6_st26a_profile);
                // st26b: measured section convex hull at y=-8.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st26b_z0]) linear_extrude(b6_st26b_z1 - b6_st26b_z0) polygon(b6_st26b_profile);
            }
            hull() {
                // st27a: measured section convex hull at y=-8.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st27a_z0]) linear_extrude(b6_st27a_z1 - b6_st27a_z0) polygon(b6_st27a_profile);
                // st27b: measured section convex hull at y=-8.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st27b_z0]) linear_extrude(b6_st27b_z1 - b6_st27b_z0) polygon(b6_st27b_profile);
            }
            hull() {
                // st28a: measured section convex hull at y=-8.157 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st28a_z0]) linear_extrude(b6_st28a_z1 - b6_st28a_z0) polygon(b6_st28a_profile);
                // st28b: measured section convex hull at y=-7.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st28b_z0]) linear_extrude(b6_st28b_z1 - b6_st28b_z0) polygon(b6_st28b_profile);
            }
            hull() {
                // st29a: measured section convex hull at y=-7.757 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st29a_z0]) linear_extrude(b6_st29a_z1 - b6_st29a_z0) polygon(b6_st29a_profile);
                // st29b: measured section convex hull at y=-7.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st29b_z0]) linear_extrude(b6_st29b_z1 - b6_st29b_z0) polygon(b6_st29b_profile);
            }
            hull() {
                // st30a: measured section convex hull at y=-7.357 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st30a_z0]) linear_extrude(b6_st30a_z1 - b6_st30a_z0) polygon(b6_st30a_profile);
                // st30b: measured section convex hull at y=-6.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st30b_z0]) linear_extrude(b6_st30b_z1 - b6_st30b_z0) polygon(b6_st30b_profile);
            }
            hull() {
                // st31a: measured section convex hull at y=-6.957 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st31a_z0]) linear_extrude(b6_st31a_z1 - b6_st31a_z0) polygon(b6_st31a_profile);
                // st31b: measured section convex hull at y=-6.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st31b_z0]) linear_extrude(b6_st31b_z1 - b6_st31b_z0) polygon(b6_st31b_profile);
            }
            hull() {
                // st32a: measured section convex hull at y=-6.557 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st32a_z0]) linear_extrude(b6_st32a_z1 - b6_st32a_z0) polygon(b6_st32a_profile);
                // st32b: measured section convex hull at y=-6.267 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b6_st32b_z0]) linear_extrude(b6_st32b_z1 - b6_st32b_z0) polygon(b6_st32b_profile);
            }
        }
        // pocket0: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b6_pocket0_z0]) linear_extrude(b6_pocket0_z1 - b6_pocket0_z0) polygon(b6_pocket0_profile);
        // pocket1: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b6_pocket1_z0]) linear_extrude(b6_pocket1_z1 - b6_pocket1_z0) polygon(b6_pocket1_profile);
        // pocket2: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b6_pocket2_z0]) linear_extrude(b6_pocket2_z1 - b6_pocket2_z0) polygon(b6_pocket2_profile);
    }
}

// ---- body 7 (strategy: csg — agent plan) ----
// plan: hull-loft along x from measured sections; plan-view concavity cutters (fork slot/barb notches); engraved label grooves (<0.3 mm³) intentionally omitted
b7_st00a_profile = [[-17.58453, 0.99081], [-17.24087, 0.5303], [-13.04924, 0.5303], [-12.70557, 0.99081], [-12.64505, 1.33342], [-12.71004, 3.08803], [-13.07699, 3.55641], [-13.64505, 3.73342], [-16.88437, 3.70437], [-17.39433, 3.39557], [-17.63784, 2.85273]];  // (y, z) points — measured section convex hull at x=-8.602 (high-res tessellation)
b7_st00a_z0 = -8.602;  // extent along x
b7_st00a_z1 = -8.582;
b7_st00b_profile = [[-17.58453, 0.99081], [-17.24087, 0.5303], [-13.04924, 0.5303], [-12.70557, 0.99081], [-12.64505, 1.33342], [-12.71004, 3.08803], [-13.07699, 3.55641], [-13.64505, 3.73342], [-17.03371, 3.65312], [-17.46804, 3.30149], [-17.64505, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.412 (high-res tessellation)
b7_st00b_z0 = -8.412;  // extent along x
b7_st00b_z1 = -8.392;
b7_st01a_profile = [[-17.58453, 0.99081], [-17.24087, 0.5303], [-13.04924, 0.5303], [-12.70557, 0.99081], [-12.64505, 1.33342], [-12.71004, 3.08803], [-13.07699, 3.55641], [-13.64505, 3.73342], [-17.03371, 3.65312], [-17.46804, 3.30149], [-17.64505, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.412 (high-res tessellation)
b7_st01a_z0 = -8.412;  // extent along x
b7_st01a_z1 = -8.392;
b7_st01b_profile = [[-17.52207, 0.8558], [-17.24087, 0.5303], [-13.01514, 0.55882], [-12.70557, 0.99081], [-12.64505, 1.33342], [-12.72383, 3.11869], [-13.43881, 3.71043], [-16.99966, 3.66844], [-17.46804, 3.30149], [-17.64505, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.012 (high-res tessellation)
b7_st01b_z0 = -8.012;  // extent along x
b7_st01b_z1 = -7.992;
b7_st02a_profile = [[-17.52207, 0.8558], [-17.24087, 0.5303], [-13.01514, 0.55882], [-12.70557, 0.99081], [-12.64505, 1.33342], [-12.72383, 3.11869], [-13.43881, 3.71043], [-16.99966, 3.66844], [-17.46804, 3.30149], [-17.64505, 2.73342]];  // (y, z) points — measured section convex hull at x=-8.012 (high-res tessellation)
b7_st02a_z0 = -8.012;  // extent along x
b7_st02a_z1 = -7.992;
b7_st02b_profile = [[-17.09309, 1.5805], [-16.91972, 1.11165], [-16.63987, 0.70473], [-16.46438, 0.5303], [-13.82372, 0.53221], [-13.49604, 0.90172], [-13.26709, 1.34609], [-13.15565, 1.82944], [-13.16661, 2.32536], [-13.2993, 2.80334], [-13.54552, 3.23391], [-13.88893, 3.58975], [-14.09149, 3.73342], [-16.2012, 3.73164], [-16.58613, 3.42017], [-16.88306, 3.02298], [-17.07316, 2.56478], [-17.14463, 2.0744]];  // (y, z) points — measured section convex hull at x=-7.612 (high-res tessellation)
b7_st02b_z0 = -7.612;  // extent along x
b7_st02b_z1 = -7.592;
b7_st03a_profile = [[-17.09309, 1.5805], [-16.91972, 1.11165], [-16.63987, 0.70473], [-16.46438, 0.5303], [-13.82372, 0.53221], [-13.49604, 0.90172], [-13.26709, 1.34609], [-13.15565, 1.82944], [-13.16661, 2.32536], [-13.2993, 2.80334], [-13.54552, 3.23391], [-13.88893, 3.58975], [-14.09149, 3.73342], [-16.2012, 3.73164], [-16.58613, 3.42017], [-16.88306, 3.02298], [-17.07316, 2.56478], [-17.14463, 2.0744]];  // (y, z) points — measured section convex hull at x=-7.612 (high-res tessellation)
b7_st03a_z0 = -7.612;  // extent along x
b7_st03a_z1 = -7.592;
b7_st03b_profile = [[-17.02173, 1.34199], [-16.63721, 0.70185], [-16.46438, 0.5303], [-13.81757, 0.53809], [-13.36199, 1.12948], [-13.15512, 1.83981], [-13.22078, 2.57681], [-13.54989, 3.23935], [-14.09149, 3.73342], [-16.20915, 3.72617], [-16.74967, 3.227], [-17.07395, 2.56174], [-17.14465, 2.07234]];  // (y, z) points — measured section convex hull at x=-7.212 (high-res tessellation)
b7_st03b_z0 = -7.212;  // extent along x
b7_st03b_z1 = -7.192;
b7_st04a_profile = [[-17.02173, 1.34199], [-16.63721, 0.70185], [-16.46438, 0.5303], [-13.81757, 0.53809], [-13.36199, 1.12948], [-13.15512, 1.83981], [-13.22078, 2.57681], [-13.54989, 3.23935], [-14.09149, 3.73342], [-16.20915, 3.72617], [-16.74967, 3.227], [-17.07395, 2.56174], [-17.14465, 2.07234]];  // (y, z) points — measured section convex hull at x=-7.212 (high-res tessellation)
b7_st04a_z0 = -7.212;  // extent along x
b7_st04a_z1 = -7.192;
b7_st04b_profile = [[-17.02158, 1.34159], [-16.63456, 0.69898], [-16.46438, 0.5303], [-13.81142, 0.54398], [-13.35712, 1.14045], [-13.15458, 1.85018], [-13.22348, 2.58514], [-13.55427, 3.24479], [-14.09149, 3.73342], [-16.21711, 3.72069], [-16.75244, 3.22312], [-17.07473, 2.55871], [-17.14468, 2.07003]];  // (y, z) points — measured section convex hull at x=-6.812 (high-res tessellation)
b7_st04b_z0 = -6.812;  // extent along x
b7_st04b_z1 = -6.792;
b7_st05a_profile = [[-17.02158, 1.34159], [-16.63456, 0.69898], [-16.46438, 0.5303], [-13.81142, 0.54398], [-13.35712, 1.14045], [-13.15458, 1.85018], [-13.22348, 2.58514], [-13.55427, 3.24479], [-14.09149, 3.73342], [-16.21711, 3.72069], [-16.75244, 3.22312], [-17.07473, 2.55871], [-17.14468, 2.07003]];  // (y, z) points — measured section convex hull at x=-6.812 (high-res tessellation)
b7_st05a_z0 = -6.812;  // extent along x
b7_st05a_z1 = -6.792;
b7_st05b_profile = [[-17.02143, 1.34119], [-16.6319, 0.6961], [-16.46438, 0.5303], [-13.80527, 0.54986], [-13.35226, 1.15143], [-13.15404, 1.86055], [-13.22617, 2.59347], [-13.55865, 3.25023], [-14.09149, 3.73342], [-16.22506, 3.71521], [-16.7552, 3.21924], [-17.07552, 2.55567], [-17.1447, 2.06797]];  // (y, z) points — measured section convex hull at x=-6.412 (high-res tessellation)
b7_st05b_z0 = -6.412;  // extent along x
b7_st05b_z1 = -6.392;
b7_st06a_profile = [[-17.02143, 1.34119], [-16.6319, 0.6961], [-16.46438, 0.5303], [-13.80527, 0.54986], [-13.35226, 1.15143], [-13.15404, 1.86055], [-13.22617, 2.59347], [-13.55865, 3.25023], [-14.09149, 3.73342], [-16.22506, 3.71521], [-16.7552, 3.21924], [-17.07552, 2.55567], [-17.1447, 2.06797]];  // (y, z) points — measured section convex hull at x=-6.412 (high-res tessellation)
b7_st06a_z0 = -6.412;  // extent along x
b7_st06a_z1 = -6.392;
b7_st06b_profile = [[-17.02128, 1.34078], [-16.62925, 0.69323], [-16.46438, 0.5303], [-13.79912, 0.55574], [-13.34861, 1.15966], [-13.1535, 1.87091], [-13.22887, 2.6018], [-13.56303, 3.25567], [-14.09149, 3.73342], [-16.23302, 3.70973], [-16.75796, 3.21536], [-17.07631, 2.55263], [-17.14472, 2.06617]];  // (y, z) points — measured section convex hull at x=-6.012 (high-res tessellation)
b7_st06b_z0 = -6.012;  // extent along x
b7_st06b_z1 = -5.992;
b7_st07a_profile = [[-17.02128, 1.34078], [-16.62925, 0.69323], [-16.46438, 0.5303], [-13.79912, 0.55574], [-13.34861, 1.15966], [-13.1535, 1.87091], [-13.22887, 2.6018], [-13.56303, 3.25567], [-14.09149, 3.73342], [-16.23302, 3.70973], [-16.75796, 3.21536], [-17.07631, 2.55263], [-17.14472, 2.06617]];  // (y, z) points — measured section convex hull at x=-6.012 (high-res tessellation)
b7_st07a_z0 = -6.012;  // extent along x
b7_st07a_z1 = -5.992;
b7_st07b_profile = [[-17.02113, 1.34038], [-16.62659, 0.69035], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.34314, 1.17201], [-13.15296, 1.88128], [-13.23157, 2.61014], [-13.5674, 3.26111], [-14.09149, 3.73342], [-16.24097, 3.70425], [-16.76073, 3.21148], [-17.0771, 2.54959], [-17.14474, 2.06412]];  // (y, z) points — measured section convex hull at x=-5.612 (high-res tessellation)
b7_st07b_z0 = -5.612;  // extent along x
b7_st07b_z1 = -5.592;
b7_st08a_profile = [[-17.02113, 1.34038], [-16.62659, 0.69035], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.34314, 1.17201], [-13.15296, 1.88128], [-13.23157, 2.61014], [-13.5674, 3.26111], [-14.09149, 3.73342], [-16.24097, 3.70425], [-16.76073, 3.21148], [-17.0771, 2.54959], [-17.14474, 2.06412]];  // (y, z) points — measured section convex hull at x=-5.612 (high-res tessellation)
b7_st08a_z0 = -5.612;  // extent along x
b7_st08a_z1 = -5.592;
b7_st08b_profile = [[-17.02098, 1.33997], [-16.62394, 0.68748], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.33767, 1.18436], [-13.14982, 2.13664], [-13.32007, 2.84804], [-13.71504, 3.43151], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.76349, 3.2076], [-17.07789, 2.54655], [-17.14476, 2.06206]];  // (y, z) points — measured section convex hull at x=-5.212 (high-res tessellation)
b7_st08b_z0 = -5.212;  // extent along x
b7_st08b_z1 = -5.192;
b7_st09a_profile = [[-17.02098, 1.33997], [-16.62394, 0.68748], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.33767, 1.18436], [-13.14982, 2.13664], [-13.32007, 2.84804], [-13.71504, 3.43151], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.76349, 3.2076], [-17.07789, 2.54655], [-17.14476, 2.06206]];  // (y, z) points — measured section convex hull at x=-5.212 (high-res tessellation)
b7_st09a_z0 = -5.212;  // extent along x
b7_st09a_z1 = -5.192;
b7_st09b_profile = [[-17.02083, 1.33957], [-16.62128, 0.6846], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.24373, 1.42286], [-13.179, 2.38927], [-13.57616, 3.27199], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.76626, 3.20372], [-17.07868, 2.54351], [-17.14478, 2.06001]];  // (y, z) points — measured section convex hull at x=-4.812 (high-res tessellation)
b7_st09b_z0 = -4.812;  // extent along x
b7_st09b_z1 = -4.792;
b7_st10a_profile = [[-17.02083, 1.33957], [-16.62128, 0.6846], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.24373, 1.42286], [-13.179, 2.38927], [-13.57616, 3.27199], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.76626, 3.20372], [-17.07868, 2.54351], [-17.14478, 2.06001]];  // (y, z) points — measured section convex hull at x=-4.812 (high-res tessellation)
b7_st10a_z0 = -4.812;  // extent along x
b7_st10a_z1 = -4.792;
b7_st10b_profile = [[-16.87157, 1.03061], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.2404, 1.43383], [-13.18077, 2.39839], [-13.58053, 3.27743], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.89917, 2.99329], [-17.1448, 2.05795]];  // (y, z) points — measured section convex hull at x=-4.412 (high-res tessellation)
b7_st10b_z0 = -4.412;  // extent along x
b7_st10b_z1 = -4.392;
b7_st11a_profile = [[-16.87157, 1.03061], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.2404, 1.43383], [-13.18077, 2.39839], [-13.58053, 3.27743], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.89917, 2.99329], [-17.1448, 2.05795]];  // (y, z) points — measured section convex hull at x=-4.412 (high-res tessellation)
b7_st11a_z0 = -4.412;  // extent along x
b7_st11a_z1 = -4.392;
b7_st11b_profile = [[-16.86555, 1.02048], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.23706, 1.4448], [-13.18254, 2.40752], [-13.58491, 3.28287], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.90118, 2.98957], [-17.14482, 2.05589]];  // (y, z) points — measured section convex hull at x=-4.012 (high-res tessellation)
b7_st11b_z0 = -4.012;  // extent along x
b7_st11b_z1 = -3.992;
b7_st12a_profile = [[-16.86555, 1.02048], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.23706, 1.4448], [-13.18254, 2.40752], [-13.58491, 3.28287], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.90118, 2.98957], [-17.14482, 2.05589]];  // (y, z) points — measured section convex hull at x=-4.012 (high-res tessellation)
b7_st12a_z0 = -4.012;  // extent along x
b7_st12a_z1 = -3.992;
b7_st12b_profile = [[-16.92219, 1.11593], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.2697, 1.33841], [-13.16259, 2.29645], [-13.58929, 3.28831], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.9032, 2.98586], [-17.14484, 2.05384]];  // (y, z) points — measured section convex hull at x=-3.612 (high-res tessellation)
b7_st12b_z0 = -3.612;  // extent along x
b7_st12b_z1 = -3.592;
b7_st13a_profile = [[-16.92219, 1.11593], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.2697, 1.33841], [-13.16259, 2.29645], [-13.58929, 3.28831], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.9032, 2.98586], [-17.14484, 2.05384]];  // (y, z) points — measured section convex hull at x=-3.612 (high-res tessellation)
b7_st13a_z0 = -3.612;  // extent along x
b7_st13a_z1 = -3.592;
b7_st13b_profile = [[-16.92224, 1.11603], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.26983, 1.33805], [-13.16225, 2.29387], [-13.72279, 3.43937], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.95359, 2.88344], [-17.14487, 2.05152]];  // (y, z) points — measured section convex hull at x=-3.212 (high-res tessellation)
b7_st13b_z0 = -3.212;  // extent along x
b7_st13b_z1 = -3.192;
b7_st14a_profile = [[-16.92224, 1.11603], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.26983, 1.33805], [-13.16225, 2.29387], [-13.72279, 3.43937], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.95359, 2.88344], [-17.14487, 2.05152]];  // (y, z) points — measured section convex hull at x=-3.212 (high-res tessellation)
b7_st14a_z0 = -3.212;  // extent along x
b7_st14a_z1 = -3.192;
b7_st14b_profile = [[-16.92229, 1.11613], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.26998, 1.33765], [-13.16191, 2.29129], [-13.72433, 3.44094], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.83344, 3.10287], [-17.13634, 2.19308], [-17.14489, 2.04947]];  // (y, z) points — measured section convex hull at x=-2.812 (high-res tessellation)
b7_st14b_z0 = -2.812;  // extent along x
b7_st14b_z1 = -2.792;
b7_st15a_profile = [[-16.92229, 1.11613], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.26998, 1.33765], [-13.16191, 2.29129], [-13.72433, 3.44094], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.83344, 3.10287], [-17.13634, 2.19308], [-17.14489, 2.04947]];  // (y, z) points — measured section convex hull at x=-2.812 (high-res tessellation)
b7_st15a_z0 = -2.812;  // extent along x
b7_st15a_z1 = -2.792;
b7_st15b_profile = [[-16.92234, 1.11622], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36775, 1.11625], [-13.1452, 2.04767], [-13.38137, 2.97565], [-13.96807, 3.6469], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.82938, 3.10939], [-17.13566, 2.2029], [-17.14491, 2.04767]];  // (y, z) points — measured section convex hull at x=-2.412 (high-res tessellation)
b7_st15b_z0 = -2.412;  // extent along x
b7_st15b_z1 = -2.392;
b7_st16a_profile = [[-16.92234, 1.11622], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36775, 1.11625], [-13.1452, 2.04767], [-13.38137, 2.97565], [-13.96807, 3.6469], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.82938, 3.10939], [-17.13566, 2.2029], [-17.14491, 2.04767]];  // (y, z) points — measured section convex hull at x=-2.412 (high-res tessellation)
b7_st16a_z0 = -2.412;  // extent along x
b7_st16a_z1 = -2.392;
b7_st16b_profile = [[-16.99012, 1.26941], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.3677, 1.11635], [-13.1582, 1.80489], [-13.20611, 2.52299], [-13.78142, 3.49349], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.82533, 3.11591], [-17.13497, 2.21272], [-17.14493, 2.04561]];  // (y, z) points — measured section convex hull at x=-2.012 (high-res tessellation)
b7_st16b_z0 = -2.012;  // extent along x
b7_st16b_z1 = -1.992;
b7_st17a_profile = [[-16.99012, 1.26941], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.3677, 1.11635], [-13.1582, 1.80489], [-13.20611, 2.52299], [-13.78142, 3.49349], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.82533, 3.11591], [-17.13497, 2.21272], [-17.14493, 2.04561]];  // (y, z) points — measured section convex hull at x=-2.012 (high-res tessellation)
b7_st17a_z0 = -2.012;  // extent along x
b7_st17a_z1 = -1.992;
b7_st17b_profile = [[-16.9962, 1.28313], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36765, 1.11645], [-13.15837, 1.80338], [-13.20532, 2.51995], [-13.7738, 3.48666], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.82127, 3.12242], [-17.09738, 2.46002], [-17.14495, 2.04355]];  // (y, z) points — measured section convex hull at x=-1.612 (high-res tessellation)
b7_st17b_z0 = -1.612;  // extent along x
b7_st17b_z1 = -1.592;
b7_st18a_profile = [[-16.9962, 1.28313], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36765, 1.11645], [-13.15837, 1.80338], [-13.20532, 2.51995], [-13.7738, 3.48666], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.82127, 3.12242], [-17.09738, 2.46002], [-17.14495, 2.04355]];  // (y, z) points — measured section convex hull at x=-1.612 (high-res tessellation)
b7_st18a_z0 = -1.612;  // extent along x
b7_st18a_z1 = -1.592;
b7_st18b_profile = [[-17.00106, 1.29411], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.3676, 1.11654], [-13.15854, 1.80188], [-13.20453, 2.51691], [-13.76523, 3.47899], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.81722, 3.12894], [-17.09561, 2.46914], [-17.14497, 2.0415]];  // (y, z) points — measured section convex hull at x=-1.212 (high-res tessellation)
b7_st18b_z0 = -1.212;  // extent along x
b7_st18b_z1 = -1.192;
b7_st19a_profile = [[-17.00106, 1.29411], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.3676, 1.11654], [-13.15854, 1.80188], [-13.20453, 2.51691], [-13.76523, 3.47899], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.81722, 3.12894], [-17.09561, 2.46914], [-17.14497, 2.0415]];  // (y, z) points — measured section convex hull at x=-1.212 (high-res tessellation)
b7_st19a_z0 = -1.212;  // extent along x
b7_st19a_z1 = -1.192;
b7_st19b_profile = [[-17.00532, 1.30371], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36755, 1.11664], [-13.15871, 1.80037], [-13.20374, 2.51387], [-13.64242, 3.35274], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.67527, 3.32037], [-17.02683, 2.70803], [-17.14499, 2.03944]];  // (y, z) points — measured section convex hull at x=-0.812 (high-res tessellation)
b7_st19b_z0 = -0.812;  // extent along x
b7_st19b_z1 = -0.792;
b7_st20a_profile = [[-17.00532, 1.30371], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36755, 1.11664], [-13.15871, 1.80037], [-13.20374, 2.51387], [-13.64242, 3.35274], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.67527, 3.32037], [-17.02683, 2.70803], [-17.14499, 2.03944]];  // (y, z) points — measured section convex hull at x=-0.812 (high-res tessellation)
b7_st20a_z0 = -0.812;  // extent along x
b7_st20a_z1 = -0.792;
b7_st20b_profile = [[-17.01079, 1.31606], [-16.57573, 0.63677], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.3675, 1.11674], [-13.15887, 1.79887], [-13.20296, 2.51083], [-13.63874, 3.34871], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.67113, 3.32554], [-17.02413, 2.71636], [-17.14501, 2.03738]];  // (y, z) points — measured section convex hull at x=-0.412 (high-res tessellation)
b7_st20b_z0 = -0.412;  // extent along x
b7_st20b_z1 = -0.392;
b7_st21a_profile = [[-17.01079, 1.31606], [-16.57573, 0.63677], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.3675, 1.11674], [-13.15887, 1.79887], [-13.20296, 2.51083], [-13.63874, 3.34871], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.67113, 3.32554], [-17.02413, 2.71636], [-17.14501, 2.03738]];  // (y, z) points — measured section convex hull at x=-0.412 (high-res tessellation)
b7_st21a_z0 = -0.412;  // extent along x
b7_st21a_z1 = -0.392;
b7_st21b_profile = [[-17.01565, 1.32703], [-16.58189, 0.64266], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36746, 1.11681], [-13.15904, 1.79736], [-13.20217, 2.50779], [-13.63506, 3.34468], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.66698, 3.33071], [-17.02143, 2.7247], [-17.14504, 2.03507]];  // (y, z) points — measured section convex hull at x=-0.012 (high-res tessellation)
b7_st21b_z0 = -0.012;  // extent along x
b7_st21b_z1 = 0.008;
b7_st22a_profile = [[-17.01565, 1.32703], [-16.58189, 0.64266], [-16.46438, 0.5303], [-13.82572, 0.5303], [-13.36746, 1.11681], [-13.15904, 1.79736], [-13.20217, 2.50779], [-13.63506, 3.34468], [-14.09149, 3.73342], [-16.19862, 3.73342], [-16.66698, 3.33071], [-17.02143, 2.7247], [-17.14504, 2.03507]];  // (y, z) points — measured section convex hull at x=-0.012 (high-res tessellation)
b7_st22a_z0 = -0.012;  // extent along x
b7_st22a_z1 = 0.008;
b7_st22b_profile = [[-17.35643, 1.34571], [-16.81124, 0.5303], [-13.46622, 0.5415], [-13.12678, 0.95045], [-12.86132, 1.59742], [-12.87464, 2.52612], [-13.50018, 3.55349], [-13.73358, 3.73342], [-16.64789, 3.67034], [-17.14904, 3.13922], [-17.46294, 2.26677]];  // (y, z) points — measured section convex hull at x=0.388 (high-res tessellation)
b7_st22b_z0 = 0.388;  // extent along x
b7_st22b_z1 = 0.408;
b7_st23a_profile = [[-17.35643, 1.34571], [-16.81124, 0.5303], [-13.46622, 0.5415], [-13.12678, 0.95045], [-12.86132, 1.59742], [-12.87464, 2.52612], [-13.50018, 3.55349], [-13.73358, 3.73342], [-16.64789, 3.67034], [-17.14904, 3.13922], [-17.46294, 2.26677]];  // (y, z) points — measured section convex hull at x=0.388 (high-res tessellation)
b7_st23a_z0 = 0.388;  // extent along x
b7_st23a_z1 = 0.408;
b7_st23b_profile = [[-17.49069, 1.5279], [-17.22976, 0.90857], [-16.92529, 0.5303], [-13.33831, 0.55959], [-12.93352, 1.14392], [-12.74619, 1.8207], [-12.79845, 2.54517], [-13.11718, 3.24045], [-13.59586, 3.73342], [-16.69425, 3.73342], [-17.21687, 3.17496], [-17.49902, 2.50636], [-17.53696, 2.30623]];  // (y, z) points — measured section convex hull at x=0.788 (high-res tessellation)
b7_st23b_z0 = 0.788;  // extent along x
b7_st23b_z1 = 0.808;
b7_st24a_profile = [[-17.49069, 1.5279], [-17.22976, 0.90857], [-16.92529, 0.5303], [-13.33831, 0.55959], [-12.93352, 1.14392], [-12.74619, 1.8207], [-12.79845, 2.54517], [-13.11718, 3.24045], [-13.59586, 3.73342], [-16.69425, 3.73342], [-17.21687, 3.17496], [-17.49902, 2.50636], [-17.53696, 2.30623]];  // (y, z) points — measured section convex hull at x=0.788 (high-res tessellation)
b7_st24a_z0 = 0.788;  // extent along x
b7_st24a_z1 = 0.808;
b7_st24b_profile = [[-17.50549, 1.58056], [-17.08845, 0.71065], [-16.92529, 0.5303], [-13.36481, 0.5303], [-12.94274, 1.12145], [-12.73565, 2.06367], [-12.87094, 2.77731], [-13.46005, 3.62102], [-13.59586, 3.73342], [-16.69425, 3.73342], [-17.19678, 3.20898], [-17.49166, 2.54517], [-17.54855, 2.14555]];  // (y, z) points — measured section convex hull at x=1.188 (high-res tessellation)
b7_st24b_z0 = 1.188;  // extent along x
b7_st24b_z1 = 1.208;
b7_st25a_profile = [[-17.50549, 1.58056], [-17.08845, 0.71065], [-16.92529, 0.5303], [-13.36481, 0.5303], [-12.94274, 1.12145], [-12.73565, 2.06367], [-12.87094, 2.77731], [-13.46005, 3.62102], [-13.59586, 3.73342], [-16.69425, 3.73342], [-17.19678, 3.20898], [-17.49166, 2.54517], [-17.54855, 2.14555]];  // (y, z) points — measured section convex hull at x=1.188 (high-res tessellation)
b7_st25a_z0 = 1.188;  // extent along x
b7_st25a_z1 = 1.208;
b7_st25b_profile = [[-17.4309, 1.34946], [-17.08122, 0.71647], [-16.91153, 0.5303], [-13.34992, 0.55905], [-12.9192, 1.1966], [-12.82985, 2.61722], [-13.10147, 3.20351], [-13.61209, 3.73342], [-16.6927, 3.72266], [-17.05744, 3.37939], [-17.43403, 2.70823], [-17.53843, 2.20425]];  // (y, z) points — measured section convex hull at x=1.588 (high-res tessellation)
b7_st25b_z0 = 1.588;  // extent along x
b7_st25b_z1 = 1.608;
b7_st26a_profile = [[-17.4309, 1.34946], [-17.08122, 0.71647], [-16.91153, 0.5303], [-13.34992, 0.55905], [-12.9192, 1.1966], [-12.82985, 2.61722], [-13.10147, 3.20351], [-13.61209, 3.73342], [-16.6927, 3.72266], [-17.05744, 3.37939], [-17.43403, 2.70823], [-17.53843, 2.20425]];  // (y, z) points — measured section convex hull at x=1.588 (high-res tessellation)
b7_st26a_z0 = 1.588;  // extent along x
b7_st26a_z1 = 1.608;
b7_st26b_profile = [[-17.26126, 1.16272], [-16.78557, 0.5303], [-13.41126, 0.61954], [-12.9138, 1.46326], [-12.8483, 2.29382], [-13.05497, 2.95562], [-13.47385, 3.50809], [-13.76625, 3.73342], [-16.63771, 3.65648], [-17.13776, 3.12498], [-17.45365, 2.17364]];  // (y, z) points — measured section convex hull at x=1.748 (high-res tessellation)
b7_st26b_z0 = 1.748;  // extent along x
b7_st26b_z1 = 1.768;
b7_pocket0_profile = [[1.458226, -12.725572], [1.459535, -12.755499], [0.547485, -12.774392], [0.380415, -12.903353], [0.308066, -13.165917], [-7.70693, -13.15023], [-7.693254, -12.630111]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
b7_pocket0_z0 = 0.030304;  // extent along z
b7_pocket0_z1 = 4.233424;
b7_pocket1_profile = [[1.82307, -17.199734], [1.79307, -17.199734], [1.79307, -15.660052], [-3.694856, -15.659764], [-3.705788, -14.639312], [1.79307, -14.630052], [1.79307, -13.090371], [1.81381, -13.076513]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
b7_pocket1_z0 = 0.030304;  // extent along z
b7_pocket1_z1 = 4.233424;
b7_pocket2_profile = [[-7.691774, -17.660051], [-7.691925, -17.124874], [0.308066, -17.124188], [0.361983, -17.355664], [0.431931, -17.446123], [0.537851, -17.511657], [1.495926, -17.549588]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
b7_pocket2_z0 = 0.030304;  // extent along z
b7_pocket2_z1 = 4.233424;
b7_fn = 96;  // curve resolution

module body_7() {
    difference() {
        union() {
            hull() {
                // st00a: measured section convex hull at x=-8.602 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st00a_z0]) linear_extrude(b7_st00a_z1 - b7_st00a_z0) polygon(b7_st00a_profile);
                // st00b: measured section convex hull at x=-8.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st00b_z0]) linear_extrude(b7_st00b_z1 - b7_st00b_z0) polygon(b7_st00b_profile);
            }
            hull() {
                // st01a: measured section convex hull at x=-8.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st01a_z0]) linear_extrude(b7_st01a_z1 - b7_st01a_z0) polygon(b7_st01a_profile);
                // st01b: measured section convex hull at x=-8.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st01b_z0]) linear_extrude(b7_st01b_z1 - b7_st01b_z0) polygon(b7_st01b_profile);
            }
            hull() {
                // st02a: measured section convex hull at x=-8.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st02a_z0]) linear_extrude(b7_st02a_z1 - b7_st02a_z0) polygon(b7_st02a_profile);
                // st02b: measured section convex hull at x=-7.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st02b_z0]) linear_extrude(b7_st02b_z1 - b7_st02b_z0) polygon(b7_st02b_profile);
            }
            hull() {
                // st03a: measured section convex hull at x=-7.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st03a_z0]) linear_extrude(b7_st03a_z1 - b7_st03a_z0) polygon(b7_st03a_profile);
                // st03b: measured section convex hull at x=-7.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st03b_z0]) linear_extrude(b7_st03b_z1 - b7_st03b_z0) polygon(b7_st03b_profile);
            }
            hull() {
                // st04a: measured section convex hull at x=-7.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st04a_z0]) linear_extrude(b7_st04a_z1 - b7_st04a_z0) polygon(b7_st04a_profile);
                // st04b: measured section convex hull at x=-6.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st04b_z0]) linear_extrude(b7_st04b_z1 - b7_st04b_z0) polygon(b7_st04b_profile);
            }
            hull() {
                // st05a: measured section convex hull at x=-6.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st05a_z0]) linear_extrude(b7_st05a_z1 - b7_st05a_z0) polygon(b7_st05a_profile);
                // st05b: measured section convex hull at x=-6.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st05b_z0]) linear_extrude(b7_st05b_z1 - b7_st05b_z0) polygon(b7_st05b_profile);
            }
            hull() {
                // st06a: measured section convex hull at x=-6.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st06a_z0]) linear_extrude(b7_st06a_z1 - b7_st06a_z0) polygon(b7_st06a_profile);
                // st06b: measured section convex hull at x=-6.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st06b_z0]) linear_extrude(b7_st06b_z1 - b7_st06b_z0) polygon(b7_st06b_profile);
            }
            hull() {
                // st07a: measured section convex hull at x=-6.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st07a_z0]) linear_extrude(b7_st07a_z1 - b7_st07a_z0) polygon(b7_st07a_profile);
                // st07b: measured section convex hull at x=-5.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st07b_z0]) linear_extrude(b7_st07b_z1 - b7_st07b_z0) polygon(b7_st07b_profile);
            }
            hull() {
                // st08a: measured section convex hull at x=-5.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st08a_z0]) linear_extrude(b7_st08a_z1 - b7_st08a_z0) polygon(b7_st08a_profile);
                // st08b: measured section convex hull at x=-5.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st08b_z0]) linear_extrude(b7_st08b_z1 - b7_st08b_z0) polygon(b7_st08b_profile);
            }
            hull() {
                // st09a: measured section convex hull at x=-5.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st09a_z0]) linear_extrude(b7_st09a_z1 - b7_st09a_z0) polygon(b7_st09a_profile);
                // st09b: measured section convex hull at x=-4.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st09b_z0]) linear_extrude(b7_st09b_z1 - b7_st09b_z0) polygon(b7_st09b_profile);
            }
            hull() {
                // st10a: measured section convex hull at x=-4.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st10a_z0]) linear_extrude(b7_st10a_z1 - b7_st10a_z0) polygon(b7_st10a_profile);
                // st10b: measured section convex hull at x=-4.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st10b_z0]) linear_extrude(b7_st10b_z1 - b7_st10b_z0) polygon(b7_st10b_profile);
            }
            hull() {
                // st11a: measured section convex hull at x=-4.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st11a_z0]) linear_extrude(b7_st11a_z1 - b7_st11a_z0) polygon(b7_st11a_profile);
                // st11b: measured section convex hull at x=-4.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st11b_z0]) linear_extrude(b7_st11b_z1 - b7_st11b_z0) polygon(b7_st11b_profile);
            }
            hull() {
                // st12a: measured section convex hull at x=-4.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st12a_z0]) linear_extrude(b7_st12a_z1 - b7_st12a_z0) polygon(b7_st12a_profile);
                // st12b: measured section convex hull at x=-3.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st12b_z0]) linear_extrude(b7_st12b_z1 - b7_st12b_z0) polygon(b7_st12b_profile);
            }
            hull() {
                // st13a: measured section convex hull at x=-3.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st13a_z0]) linear_extrude(b7_st13a_z1 - b7_st13a_z0) polygon(b7_st13a_profile);
                // st13b: measured section convex hull at x=-3.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st13b_z0]) linear_extrude(b7_st13b_z1 - b7_st13b_z0) polygon(b7_st13b_profile);
            }
            hull() {
                // st14a: measured section convex hull at x=-3.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st14a_z0]) linear_extrude(b7_st14a_z1 - b7_st14a_z0) polygon(b7_st14a_profile);
                // st14b: measured section convex hull at x=-2.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st14b_z0]) linear_extrude(b7_st14b_z1 - b7_st14b_z0) polygon(b7_st14b_profile);
            }
            hull() {
                // st15a: measured section convex hull at x=-2.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st15a_z0]) linear_extrude(b7_st15a_z1 - b7_st15a_z0) polygon(b7_st15a_profile);
                // st15b: measured section convex hull at x=-2.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st15b_z0]) linear_extrude(b7_st15b_z1 - b7_st15b_z0) polygon(b7_st15b_profile);
            }
            hull() {
                // st16a: measured section convex hull at x=-2.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st16a_z0]) linear_extrude(b7_st16a_z1 - b7_st16a_z0) polygon(b7_st16a_profile);
                // st16b: measured section convex hull at x=-2.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st16b_z0]) linear_extrude(b7_st16b_z1 - b7_st16b_z0) polygon(b7_st16b_profile);
            }
            hull() {
                // st17a: measured section convex hull at x=-2.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st17a_z0]) linear_extrude(b7_st17a_z1 - b7_st17a_z0) polygon(b7_st17a_profile);
                // st17b: measured section convex hull at x=-1.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st17b_z0]) linear_extrude(b7_st17b_z1 - b7_st17b_z0) polygon(b7_st17b_profile);
            }
            hull() {
                // st18a: measured section convex hull at x=-1.612 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st18a_z0]) linear_extrude(b7_st18a_z1 - b7_st18a_z0) polygon(b7_st18a_profile);
                // st18b: measured section convex hull at x=-1.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st18b_z0]) linear_extrude(b7_st18b_z1 - b7_st18b_z0) polygon(b7_st18b_profile);
            }
            hull() {
                // st19a: measured section convex hull at x=-1.212 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st19a_z0]) linear_extrude(b7_st19a_z1 - b7_st19a_z0) polygon(b7_st19a_profile);
                // st19b: measured section convex hull at x=-0.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st19b_z0]) linear_extrude(b7_st19b_z1 - b7_st19b_z0) polygon(b7_st19b_profile);
            }
            hull() {
                // st20a: measured section convex hull at x=-0.812 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st20a_z0]) linear_extrude(b7_st20a_z1 - b7_st20a_z0) polygon(b7_st20a_profile);
                // st20b: measured section convex hull at x=-0.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st20b_z0]) linear_extrude(b7_st20b_z1 - b7_st20b_z0) polygon(b7_st20b_profile);
            }
            hull() {
                // st21a: measured section convex hull at x=-0.412 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st21a_z0]) linear_extrude(b7_st21a_z1 - b7_st21a_z0) polygon(b7_st21a_profile);
                // st21b: measured section convex hull at x=-0.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st21b_z0]) linear_extrude(b7_st21b_z1 - b7_st21b_z0) polygon(b7_st21b_profile);
            }
            hull() {
                // st22a: measured section convex hull at x=-0.012 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st22a_z0]) linear_extrude(b7_st22a_z1 - b7_st22a_z0) polygon(b7_st22a_profile);
                // st22b: measured section convex hull at x=0.388 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st22b_z0]) linear_extrude(b7_st22b_z1 - b7_st22b_z0) polygon(b7_st22b_profile);
            }
            hull() {
                // st23a: measured section convex hull at x=0.388 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st23a_z0]) linear_extrude(b7_st23a_z1 - b7_st23a_z0) polygon(b7_st23a_profile);
                // st23b: measured section convex hull at x=0.788 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st23b_z0]) linear_extrude(b7_st23b_z1 - b7_st23b_z0) polygon(b7_st23b_profile);
            }
            hull() {
                // st24a: measured section convex hull at x=0.788 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st24a_z0]) linear_extrude(b7_st24a_z1 - b7_st24a_z0) polygon(b7_st24a_profile);
                // st24b: measured section convex hull at x=1.188 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st24b_z0]) linear_extrude(b7_st24b_z1 - b7_st24b_z0) polygon(b7_st24b_profile);
            }
            hull() {
                // st25a: measured section convex hull at x=1.188 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st25a_z0]) linear_extrude(b7_st25a_z1 - b7_st25a_z0) polygon(b7_st25a_profile);
                // st25b: measured section convex hull at x=1.588 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st25b_z0]) linear_extrude(b7_st25b_z1 - b7_st25b_z0) polygon(b7_st25b_profile);
            }
            hull() {
                // st26a: measured section convex hull at x=1.588 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st26a_z0]) linear_extrude(b7_st26a_z1 - b7_st26a_z0) polygon(b7_st26a_profile);
                // st26b: measured section convex hull at x=1.748 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b7_st26b_z0]) linear_extrude(b7_st26b_z1 - b7_st26b_z0) polygon(b7_st26b_profile);
            }
        }
        // pocket0: plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
        translate([0, 0, b7_pocket0_z0]) linear_extrude(b7_pocket0_z1 - b7_pocket0_z0) polygon(b7_pocket0_profile);
        // pocket1: plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
        translate([0, 0, b7_pocket1_z0]) linear_extrude(b7_pocket1_z1 - b7_pocket1_z0) polygon(b7_pocket1_profile);
        // pocket2: plan-view concavity (silhouette hull minus measured outline at z=2.131864): fork slot / barb notch, vertical walls
        translate([0, 0, b7_pocket2_z0]) linear_extrude(b7_pocket2_z1 - b7_pocket2_z0) polygon(b7_pocket2_profile);
    }
}

// ---- body 8 (strategy: instance_of body 6 — agent plan) ----
b8_offset = [0.000013, 15.21636, -0.000248];  // centroid delta body8-body6; canonical-anchor face signature matches except the engraved digit (<2.2 mm² faces)

module body_8() {
    translate(b8_offset) body_6();
}

// ---- body 9 (strategy: rotate_extrude — exact RZ profile) ----
// revolution axis: through [14.425505, -9.144297, 0.530304] along [0, 0, 1]; profile z measured from the axis low end
// Pappus check: profile revolves to 528.51 mm³ vs exact B-rep volume 531.63 mm³
b9_bore_r        = 2.7;  // exact B-rep: cylinder face(s) #2 radius (reversed -> bore)
b9_cbore_r       = 4.7;  // exact B-rep: cylinder face(s) #0 radius (reversed -> bore)
b9_total_h       = 3.75;  // exact B-rep: axial extent of the coaxial faces #0/#2/#3/#6/#7 (v-ranges)
b9_z_step1       = 2;  // exact B-rep: plane face(s) #1 height above the base
b9_cham1         = 0.5;  // exact B-rep: cone face(s) #7 (45° half-angle) radial width = axial height (45°)
b9_bore_bot_cham = 0.5;  // exact B-rep: cone face(s) #3 (45° half-angle) radial width = axial height (45°)
b9_fn            = 128;  // rotate_extrude curve resolution

module body_9() {
    // closed RZ boundary loop: up the bore, across the top,
    // down the outside, across the bottom (ring -> through-bore)
    translate([14.425505, -9.144297, 0.530304]) rotate_extrude($fn = b9_fn)
        polygon(points = [
            [b9_bore_r + b9_bore_bot_cham, 0],     // cone face(s) #3
            [b9_bore_r, b9_bore_bot_cham],         // cone face(s) #3
            [b9_bore_r, b9_z_step1],               // cyl face(s) #2
            [b9_cbore_r, b9_z_step1],              // cyl face(s) #0
            [b9_cbore_r, b9_total_h],              // cyl face(s) #0
            [b9_cbore_r + b9_cham1, b9_total_h],   // arc face(s) #6
            [5.907046, 3.667087],                  // arc face(s) #6
            [6.575728, 3.422848],                  // arc face(s) #6
            [7.169764, 3.030533],                  // arc face(s) #6
            [7.656921, 2.511432],                  // arc face(s) #6
            [8.010766, 1.893709],                  // arc face(s) #6
            [8.212101, 1.210881],                  // arc face(s) #6
            [8.25, b9_cham1],                      // cone face(s) #7
            [7.75, 0]                              // cone face(s) #7
        ]);
}

// ---- body 10 (strategy: csg — agent plan) ----
// plan: hull-loft along x from measured sections; plan-view concavity cutters (fork slot/barb notches); engraved label grooves (<0.3 mm³) intentionally omitted
b10_st00a_profile = [[14.69193, 1.22486], [15.11959, 0.68214], [15.31103, 0.5303], [17.60222, 0.5303], [18.13463, 1.07555], [18.45153, 1.95498], [18.33518, 2.88159], [17.79366, 3.67846], [17.60222, 3.8303], [15.31103, 3.8303], [14.77861, 3.28506], [14.46172, 2.40563], [14.44876, 2.23347]];  // (y, z) points — measured section convex hull at x=-31.108 (high-res tessellation)
b10_st00a_z0 = -31.108;  // extent along x
b10_st00a_z1 = -31.088;
b10_st00b_profile = [[14.2819, 1.85099], [14.4769, 1.22189], [15.0034, 0.5303], [17.90985, 0.5303], [18.43634, 1.22189], [18.63134, 1.85099], [18.63134, 2.50962], [18.43634, 3.13872], [17.90985, 3.8303], [15.0034, 3.8303], [14.4769, 3.13872], [14.2819, 2.50962]];  // (y, z) points — measured section convex hull at x=-30.918 (high-res tessellation)
b10_st00b_z0 = -30.918;  // extent along x
b10_st00b_z1 = -30.898;
b10_st01a_profile = [[14.2819, 1.85099], [14.4769, 1.22189], [15.0034, 0.5303], [17.90985, 0.5303], [18.43634, 1.22189], [18.63134, 1.85099], [18.63134, 2.50962], [18.43634, 3.13872], [17.90985, 3.8303], [15.0034, 3.8303], [14.4769, 3.13872], [14.2819, 2.50962]];  // (y, z) points — measured section convex hull at x=-30.918 (high-res tessellation)
b10_st01a_z0 = -30.918;  // extent along x
b10_st01a_z1 = -30.898;
b10_st01b_profile = [[14.05209, 1.49605], [14.40739, 0.74829], [14.57846, 0.5303], [18.33479, 0.5303], [18.65174, 0.98387], [18.9243, 1.78594], [18.92212, 2.59425], [18.77067, 3.12646], [18.33479, 3.8303], [14.57846, 3.8303], [14.14258, 3.12646], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-30.518 (high-res tessellation)
b10_st01b_z0 = -30.518;  // extent along x
b10_st01b_z1 = -30.498;
b10_st02a_profile = [[14.05209, 1.49605], [14.40739, 0.74829], [14.57846, 0.5303], [18.33479, 0.5303], [18.65174, 0.98387], [18.9243, 1.78594], [18.92212, 2.59425], [18.77067, 3.12646], [18.33479, 3.8303], [14.57846, 3.8303], [14.14258, 3.12646], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-30.518 (high-res tessellation)
b10_st02a_z0 = -30.518;  // extent along x
b10_st02a_z1 = -30.498;
b10_st02b_profile = [[14.05209, 1.49605], [14.2615, 0.98387], [14.57846, 0.5303], [18.33479, 0.5303], [18.77067, 1.23415], [18.95278, 2.04176], [18.92212, 2.59425], [18.77067, 3.12646], [18.50585, 3.61232], [18.33479, 3.8303], [14.57846, 3.8303], [14.14258, 3.12646], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-30.118 (high-res tessellation)
b10_st02b_z0 = -30.118;  // extent along x
b10_st02b_z1 = -30.098;
b10_st03a_profile = [[14.05209, 1.49605], [14.2615, 0.98387], [14.57846, 0.5303], [18.33479, 0.5303], [18.77067, 1.23415], [18.95278, 2.04176], [18.92212, 2.59425], [18.77067, 3.12646], [18.50585, 3.61232], [18.33479, 3.8303], [14.57846, 3.8303], [14.14258, 3.12646], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-30.118 (high-res tessellation)
b10_st03a_z0 = -30.118;  // extent along x
b10_st03a_z1 = -30.098;
b10_st03b_profile = [[14.18509, 1.14468], [14.57846, 0.5303], [18.33479, 0.5303], [18.77067, 1.23415], [18.95278, 2.04176], [18.86116, 2.86455], [18.33479, 3.8303], [14.57846, 3.8303], [14.03029, 2.76792], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-29.718 (high-res tessellation)
b10_st03b_z0 = -29.718;  // extent along x
b10_st03b_z1 = -29.698;
b10_st04a_profile = [[14.18509, 1.14468], [14.57846, 0.5303], [18.33479, 0.5303], [18.77067, 1.23415], [18.95278, 2.04176], [18.86116, 2.86455], [18.33479, 3.8303], [14.57846, 3.8303], [14.03029, 2.76792], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-29.718 (high-res tessellation)
b10_st04a_z0 = -29.718;  // extent along x
b10_st04a_z1 = -29.698;
b10_st04b_profile = [[14.06504, 1.45855], [14.41967, 0.73264], [14.57846, 0.5303], [18.33479, 0.5303], [18.77067, 1.23415], [18.95278, 2.04176], [18.86116, 2.86455], [18.50585, 3.61232], [18.33479, 3.8303], [14.55396, 3.79909], [14.13608, 3.10766], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-29.318 (high-res tessellation)
b10_st04b_z0 = -29.318;  // extent along x
b10_st04b_z1 = -29.298;
b10_st05a_profile = [[14.06504, 1.45855], [14.41967, 0.73264], [14.57846, 0.5303], [18.33479, 0.5303], [18.77067, 1.23415], [18.95278, 2.04176], [18.86116, 2.86455], [18.50585, 3.61232], [18.33479, 3.8303], [14.55396, 3.79909], [14.13608, 3.10766], [13.96047, 2.31885]];  // (y, z) points — measured section convex hull at x=-29.318 (high-res tessellation)
b10_st05a_z0 = -29.318;  // extent along x
b10_st05a_z1 = -29.298;
b10_st05b_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.97356, 0.69406], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.46203, 1.55714], [18.55281, 2.05384], [18.5224, 2.55786], [18.37257, 3.04004], [17.94461, 3.66216], [17.75566, 3.8303], [15.15431, 3.82739], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-28.918 (high-res tessellation)
b10_st05b_z0 = -28.918;  // extent along x
b10_st05b_z1 = -28.898;
b10_st06a_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.97356, 0.69406], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.46203, 1.55714], [18.55281, 2.05384], [18.5224, 2.55786], [18.37257, 3.04004], [17.94461, 3.66216], [17.75566, 3.8303], [15.15431, 3.82739], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-28.918 (high-res tessellation)
b10_st06a_z0 = -28.918;  // extent along x
b10_st06a_z1 = -28.898;
b10_st06b_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52399, 1.81584], [18.5224, 2.55786], [18.24722, 3.27592], [17.75566, 3.8303], [15.14691, 3.82081], [14.65793, 3.26415], [14.38912, 2.54368], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-28.518 (high-res tessellation)
b10_st06b_z0 = -28.518;  // extent along x
b10_st06b_z1 = -28.498;
b10_st07a_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52399, 1.81584], [18.5224, 2.55786], [18.24722, 3.27592], [17.75566, 3.8303], [15.14691, 3.82081], [14.65793, 3.26415], [14.38912, 2.54368], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-28.518 (high-res tessellation)
b10_st07a_z0 = -28.518;  // extent along x
b10_st07a_z1 = -28.498;
b10_st07b_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52505, 1.82457], [18.5224, 2.55786], [18.24161, 3.28407], [17.75566, 3.8303], [15.14116, 3.81569], [14.64723, 3.2437], [14.38793, 2.53385], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-28.118 (high-res tessellation)
b10_st07b_z0 = -28.118;  // extent along x
b10_st07b_z1 = -28.098;
b10_st08a_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52505, 1.82457], [18.5224, 2.55786], [18.24161, 3.28407], [17.75566, 3.8303], [15.14116, 3.81569], [14.64723, 3.2437], [14.38793, 2.53385], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-28.118 (high-res tessellation)
b10_st08a_z0 = -28.118;  // extent along x
b10_st08a_z1 = -28.098;
b10_st08b_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52611, 1.83331], [18.5224, 2.55786], [18.23787, 3.28951], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.4436, 2.77251], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-27.718 (high-res tessellation)
b10_st08b_z0 = -27.718;  // extent along x
b10_st08b_z1 = -27.698;
b10_st09a_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52611, 1.83331], [18.5224, 2.55786], [18.23787, 3.28951], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.4436, 2.77251], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-27.718 (high-res tessellation)
b10_st09a_z0 = -27.718;  // extent along x
b10_st09a_z1 = -27.698;
b10_st09b_profile = [[14.46521, 1.52012], [14.82892, 0.85676], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52743, 1.84422], [18.5224, 2.55786], [18.23164, 3.29857], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.38608, 2.51857], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-27.318 (high-res tessellation)
b10_st09b_z0 = -27.318;  // extent along x
b10_st09b_z1 = -27.298;
b10_st10a_profile = [[14.46521, 1.52012], [14.82892, 0.85676], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52743, 1.84422], [18.5224, 2.55786], [18.23164, 3.29857], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.38608, 2.51857], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-27.318 (high-res tessellation)
b10_st10a_z0 = -27.318;  // extent along x
b10_st10a_z1 = -27.298;
b10_st10b_profile = [[14.46871, 1.51086], [14.83402, 0.85098], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52822, 1.85077], [18.5224, 2.55786], [18.2279, 3.304], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.38489, 2.50874], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-26.918 (high-res tessellation)
b10_st10b_z0 = -26.918;  // extent along x
b10_st10b_z1 = -26.898;
b10_st11a_profile = [[14.46871, 1.51086], [14.83402, 0.85098], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52822, 1.85077], [18.5224, 2.55786], [18.2279, 3.304], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.38489, 2.50874], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-26.918 (high-res tessellation)
b10_st11a_z0 = -26.918;  // extent along x
b10_st11a_z1 = -26.898;
b10_st11b_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [15.01299, 0.65897], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52928, 1.85951], [18.5224, 2.55786], [18.22229, 3.31216], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-26.518 (high-res tessellation)
b10_st11b_z0 = -26.518;  // extent along x
b10_st11b_z1 = -26.498;
b10_st12a_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [15.01299, 0.65897], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.52928, 1.85951], [18.5224, 2.55786], [18.22229, 3.31216], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-26.518 (high-res tessellation)
b10_st12a_z0 = -26.518;  // extent along x
b10_st12a_z1 = -26.498;
b10_st12b_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.53034, 1.86824], [18.5224, 2.55786], [18.21668, 3.32031], [17.75566, 3.8303], [15.15758, 3.8303], [14.62735, 3.2057], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-26.118 (high-res tessellation)
b10_st12b_z0 = -26.118;  // extent along x
b10_st12b_z1 = -26.098;
b10_st13a_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.53034, 1.86824], [18.5224, 2.55786], [18.21668, 3.32031], [17.75566, 3.8303], [15.15758, 3.8303], [14.62735, 3.2057], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-26.118 (high-res tessellation)
b10_st13a_z0 = -26.118;  // extent along x
b10_st13a_z1 = -26.098;
b10_st13b_profile = [[14.39084, 1.80275], [14.70093, 1.03395], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.53153, 1.87807], [18.5224, 2.55786], [18.37257, 3.04004], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-25.718 (high-res tessellation)
b10_st13b_z0 = -25.718;  // extent along x
b10_st13b_z1 = -25.698;
b10_st14a_profile = [[14.39084, 1.80275], [14.70093, 1.03395], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.53153, 1.87807], [18.5224, 2.55786], [18.37257, 3.04004], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-25.718 (high-res tessellation)
b10_st14a_z0 = -25.718;  // extent along x
b10_st14a_z1 = -25.698;
b10_st14b_profile = [[14.48077, 1.47897], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.53272, 1.88789], [18.5224, 2.55786], [18.20671, 3.33481], [17.75566, 3.8303], [15.15758, 3.8303], [14.61919, 3.19011], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-25.318 (high-res tessellation)
b10_st14b_z0 = -25.318;  // extent along x
b10_st14b_z1 = -25.298;
b10_st15a_profile = [[14.48077, 1.47897], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.53272, 1.88789], [18.5224, 2.55786], [18.20671, 3.33481], [17.75566, 3.8303], [15.15758, 3.8303], [14.61919, 3.19011], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-25.318 (high-res tessellation)
b10_st15a_z0 = -25.318;  // extent along x
b10_st15a_z1 = -25.298;
b10_st15b_profile = [[14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.46203, 2.80347], [18.11196, 3.47253], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-24.918 (high-res tessellation)
b10_st15b_z0 = -24.918;  // extent along x
b10_st15b_z1 = -24.898;
b10_st16a_profile = [[14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.46203, 2.80347], [18.11196, 3.47253], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-24.918 (high-res tessellation)
b10_st16a_z0 = -24.918;  // extent along x
b10_st16a_z1 = -24.898;
b10_st16b_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.37257, 3.04004], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-24.518 (high-res tessellation)
b10_st16b_z0 = -24.518;  // extent along x
b10_st16b_z1 = -24.498;
b10_st17a_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.37257, 3.04004], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-24.518 (high-res tessellation)
b10_st17a_z0 = -24.518;  // extent along x
b10_st17a_z1 = -24.498;
b10_st17b_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-24.118 (high-res tessellation)
b10_st17b_z0 = -24.118;  // extent along x
b10_st17b_z1 = -24.098;
b10_st18a_profile = [[14.45121, 1.55714], [14.65793, 1.09646], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-24.118 (high-res tessellation)
b10_st18a_z0 = -24.118;  // extent along x
b10_st18a_z1 = -24.098;
b10_st18b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-23.718 (high-res tessellation)
b10_st18b_z0 = -23.718;  // extent along x
b10_st18b_z1 = -23.698;
b10_st19a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-23.718 (high-res tessellation)
b10_st19a_z0 = -23.718;  // extent along x
b10_st19a_z1 = -23.698;
b10_st19b_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.54068, 3.04004], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-23.318 (high-res tessellation)
b10_st19b_z0 = -23.318;  // extent along x
b10_st19b_z1 = -23.298;
b10_st20a_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.54068, 3.04004], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-23.318 (high-res tessellation)
b10_st20a_z0 = -23.318;  // extent along x
b10_st20a_z1 = -23.298;
b10_st20b_profile = [[14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-22.918 (high-res tessellation)
b10_st20b_z0 = -22.918;  // extent along x
b10_st20b_z1 = -22.898;
b10_st21a_profile = [[14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.37257, 3.04004], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-22.918 (high-res tessellation)
b10_st21a_z0 = -22.918;  // extent along x
b10_st21a_z1 = -22.898;
b10_st21b_profile = [[14.58962, 1.22701], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.46203, 2.80347], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-22.518 (high-res tessellation)
b10_st21b_z0 = -22.518;  // extent along x
b10_st21b_z1 = -22.498;
b10_st22a_profile = [[14.58962, 1.22701], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.46203, 2.80347], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-22.518 (high-res tessellation)
b10_st22a_z0 = -22.518;  // extent along x
b10_st22a_z1 = -22.498;
b10_st22b_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.46203, 2.80347], [17.87231, 3.7265], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-22.118 (high-res tessellation)
b10_st22b_z0 = -22.118;  // extent along x
b10_st22b_z1 = -22.098;
b10_st23a_profile = [[14.39084, 1.80275], [14.54068, 1.32056], [14.96864, 0.69844], [15.15758, 0.5303], [17.75566, 0.5303], [18.37257, 1.32056], [18.55281, 2.05384], [18.46203, 2.80347], [17.87231, 3.7265], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-22.118 (high-res tessellation)
b10_st23a_z0 = -22.118;  // extent along x
b10_st23a_z1 = -22.098;
b10_st23b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.5224, 1.80275], [18.46203, 2.80347], [17.87806, 3.72139], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-21.718 (high-res tessellation)
b10_st23b_z0 = -21.718;  // extent along x
b10_st23b_z1 = -21.698;
b10_st24a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.5224, 1.80275], [18.46203, 2.80347], [17.87806, 3.72139], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-21.718 (high-res tessellation)
b10_st24a_z0 = -21.718;  // extent along x
b10_st24a_z1 = -21.698;
b10_st24b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.5224, 1.80275], [18.50298, 2.63689], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-21.318 (high-res tessellation)
b10_st24b_z0 = -21.318;  // extent along x
b10_st24b_z1 = -21.298;
b10_st25a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.25531, 1.09646], [18.5224, 1.80275], [18.50298, 2.63689], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.65793, 3.26415], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-21.318 (high-res tessellation)
b10_st25a_z0 = -21.318;  // extent along x
b10_st25a_z1 = -21.298;
b10_st25b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.28795, 1.15883], [18.5224, 1.80275], [18.50508, 2.62835], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-20.918 (high-res tessellation)
b10_st25b_z0 = -20.918;  // extent along x
b10_st25b_z1 = -20.898;
b10_st26a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.28795, 1.15883], [18.5224, 1.80275], [18.50508, 2.62835], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-20.918 (high-res tessellation)
b10_st26a_z0 = -20.918;  // extent along x
b10_st26a_z1 = -20.898;
b10_st26b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.28387, 1.15103], [18.5224, 1.80275], [18.50718, 2.6198], [18.25531, 3.26415], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-20.518 (high-res tessellation)
b10_st26b_z0 = -20.518;  // extent along x
b10_st26b_z1 = -20.498;
b10_st27a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.28387, 1.15103], [18.5224, 1.80275], [18.50718, 2.6198], [18.25531, 3.26415], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-20.518 (high-res tessellation)
b10_st27a_z0 = -20.518;  // extent along x
b10_st27a_z1 = -20.498;
b10_st27b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.2803, 1.14421], [18.5224, 1.80275], [18.50928, 2.61126], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-20.118 (high-res tessellation)
b10_st27b_z0 = -20.118;  // extent along x
b10_st27b_z1 = -20.098;
b10_st28a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.2803, 1.14421], [18.5224, 1.80275], [18.50928, 2.61126], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-20.118 (high-res tessellation)
b10_st28a_z0 = -20.118;  // extent along x
b10_st28a_z1 = -20.098;
b10_st28b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.27571, 1.13544], [18.5224, 1.80275], [18.51138, 2.60272], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-19.718 (high-res tessellation)
b10_st28b_z0 = -19.718;  // extent along x
b10_st28b_z1 = -19.698;
b10_st29a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.27571, 1.13544], [18.5224, 1.80275], [18.51138, 2.60272], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-19.718 (high-res tessellation)
b10_st29a_z0 = -19.718;  // extent along x
b10_st29a_z1 = -19.698;
b10_st29b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.78196, 0.5537], [18.27214, 1.12862], [18.5224, 1.80275], [18.51348, 2.59418], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-19.318 (high-res tessellation)
b10_st29b_z0 = -19.318;  // extent along x
b10_st29b_z1 = -19.298;
b10_st30a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.78196, 0.5537], [18.27214, 1.12862], [18.5224, 1.80275], [18.51348, 2.59418], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-19.318 (high-res tessellation)
b10_st30a_z0 = -19.318;  // extent along x
b10_st30a_z1 = -19.298;
b10_st30b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.26755, 1.11985], [18.5224, 1.80275], [18.51558, 2.58563], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-18.918 (high-res tessellation)
b10_st30b_z0 = -18.918;  // extent along x
b10_st30b_z1 = -18.898;
b10_st31a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.26755, 1.11985], [18.5224, 1.80275], [18.51558, 2.58563], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.45121, 2.80347], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-18.918 (high-res tessellation)
b10_st31a_z0 = -18.918;  // extent along x
b10_st31a_z1 = -18.898;
b10_st31b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.77046, 0.54347], [18.25531, 1.09646], [18.5224, 1.80275], [18.51768, 2.57709], [18.25531, 3.26415], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-18.518 (high-res tessellation)
b10_st31b_z0 = -18.518;  // extent along x
b10_st31b_z1 = -18.498;
b10_st32a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.77046, 0.54347], [18.25531, 1.09646], [18.5224, 1.80275], [18.51768, 2.57709], [18.25531, 3.26415], [17.94461, 3.66216], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-18.518 (high-res tessellation)
b10_st32a_z0 = -18.518;  // extent along x
b10_st32a_z1 = -18.498;
b10_st32b_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.2594, 1.10426], [18.5224, 1.80275], [18.51978, 2.56855], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-18.118 (high-res tessellation)
b10_st32b_z0 = -18.118;  // extent along x
b10_st32b_z1 = -18.098;
b10_st33a_profile = [[14.45121, 1.55714], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.2594, 1.10426], [18.5224, 1.80275], [18.51978, 2.56855], [18.25531, 3.26415], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04004], [14.39084, 2.55786], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-18.118 (high-res tessellation)
b10_st33a_z0 = -18.118;  // extent along x
b10_st33a_z1 = -18.098;
b10_st33b_profile = [[14.39084, 1.80274], [14.5417, 1.3186], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.11196, 0.88807], [18.37257, 1.32056], [18.5224, 1.80275], [18.55281, 2.30677], [18.46203, 2.80347], [18.25531, 3.26415], [17.94378, 3.6629], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04005], [14.39084, 2.55787], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-17.718 (high-res tessellation)
b10_st33b_z0 = -17.718;  // extent along x
b10_st33b_z1 = -17.698;
b10_st34a_profile = [[14.39084, 1.80274], [14.5417, 1.3186], [14.80128, 0.88808], [15.15758, 0.5303], [17.75566, 0.5303], [18.11196, 0.88807], [18.37257, 1.32056], [18.5224, 1.80275], [18.55281, 2.30677], [18.46203, 2.80347], [18.25531, 3.26415], [17.94378, 3.6629], [17.75566, 3.8303], [15.15758, 3.8303], [14.80128, 3.47253], [14.54068, 3.04005], [14.39084, 2.55787], [14.36043, 2.30677]];  // (y, z) points — measured section convex hull at x=-17.718 (high-res tessellation)
b10_st34a_z0 = -17.718;  // extent along x
b10_st34a_z1 = -17.698;
b10_st34b_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-17.318 (high-res tessellation)
b10_st34b_z0 = -17.318;  // extent along x
b10_st34b_z1 = -17.298;
b10_st35a_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-17.318 (high-res tessellation)
b10_st35a_z0 = -17.318;  // extent along x
b10_st35a_z1 = -17.298;
b10_st35b_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-16.918 (high-res tessellation)
b10_st35b_z0 = -16.918;  // extent along x
b10_st35b_z1 = -16.898;
b10_st36a_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-16.918 (high-res tessellation)
b10_st36a_z0 = -16.918;  // extent along x
b10_st36a_z1 = -16.898;
b10_st36b_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-16.518 (high-res tessellation)
b10_st36b_z0 = -16.518;  // extent along x
b10_st36b_z1 = -16.498;
b10_st37a_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-16.518 (high-res tessellation)
b10_st37a_z0 = -16.518;  // extent along x
b10_st37a_z1 = -16.498;
b10_st37b_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-16.118 (high-res tessellation)
b10_st37b_z0 = -16.118;  // extent along x
b10_st37b_z1 = -16.098;
b10_st38a_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-16.118 (high-res tessellation)
b10_st38a_z0 = -16.118;  // extent along x
b10_st38a_z1 = -16.098;
b10_st38b_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-15.718 (high-res tessellation)
b10_st38b_z0 = -15.718;  // extent along x
b10_st38b_z1 = -15.698;
b10_st39a_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-15.718 (high-res tessellation)
b10_st39a_z0 = -15.718;  // extent along x
b10_st39a_z1 = -15.698;
b10_st39b_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-15.318 (high-res tessellation)
b10_st39b_z0 = -15.318;  // extent along x
b10_st39b_z1 = -15.298;
b10_st40a_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-15.318 (high-res tessellation)
b10_st40a_z0 = -15.318;  // extent along x
b10_st40a_z1 = -15.298;
b10_st40b_profile = [[13.70662, 0.5303], [19.20662, 0.5303], [19.20662, 3.8303], [13.70662, 3.8303]];  // (y, z) points — measured section convex hull at x=-15.228 (high-res tessellation)
b10_st40b_z0 = -15.228;  // extent along x
b10_st40b_z1 = -15.208;
b10_pocket0_profile = [[-30.567806, 13.945468], [-30.567511, 13.975465], [-29.182511, 13.975465], [-29.167511, 14.375434], [-17.652511, 14.360434], [-17.666316, 13.691671]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b10_pocket0_z0 = 0.030304;  // extent along z
b10_pocket0_z1 = 4.330304;
b10_pocket1_profile = [[-31.182511, 18.280101], [-31.152511, 18.280101], [-31.152511, 17.271623], [-24.161771, 17.270481], [-24.153653, 15.650883], [-31.152511, 15.641623], [-31.152511, 14.56026], [-31.173251, 14.546402]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b10_pocket1_z0 = 0.030304;  // extent along z
b10_pocket1_z1 = 4.330304;
b10_pocket2_profile = [[-17.667806, 19.22162], [-17.667511, 18.537812], [-29.167511, 18.537812], [-29.182511, 18.937781], [-30.58251, 18.952633]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b10_pocket2_z0 = 0.030304;  // extent along z
b10_pocket2_z1 = 4.330304;
b10_fn = 96;  // curve resolution

module body_10() {
    difference() {
        union() {
            hull() {
                // st00a: measured section convex hull at x=-31.108 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st00a_z0]) linear_extrude(b10_st00a_z1 - b10_st00a_z0) polygon(b10_st00a_profile);
                // st00b: measured section convex hull at x=-30.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st00b_z0]) linear_extrude(b10_st00b_z1 - b10_st00b_z0) polygon(b10_st00b_profile);
            }
            hull() {
                // st01a: measured section convex hull at x=-30.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st01a_z0]) linear_extrude(b10_st01a_z1 - b10_st01a_z0) polygon(b10_st01a_profile);
                // st01b: measured section convex hull at x=-30.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st01b_z0]) linear_extrude(b10_st01b_z1 - b10_st01b_z0) polygon(b10_st01b_profile);
            }
            hull() {
                // st02a: measured section convex hull at x=-30.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st02a_z0]) linear_extrude(b10_st02a_z1 - b10_st02a_z0) polygon(b10_st02a_profile);
                // st02b: measured section convex hull at x=-30.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st02b_z0]) linear_extrude(b10_st02b_z1 - b10_st02b_z0) polygon(b10_st02b_profile);
            }
            hull() {
                // st03a: measured section convex hull at x=-30.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st03a_z0]) linear_extrude(b10_st03a_z1 - b10_st03a_z0) polygon(b10_st03a_profile);
                // st03b: measured section convex hull at x=-29.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st03b_z0]) linear_extrude(b10_st03b_z1 - b10_st03b_z0) polygon(b10_st03b_profile);
            }
            hull() {
                // st04a: measured section convex hull at x=-29.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st04a_z0]) linear_extrude(b10_st04a_z1 - b10_st04a_z0) polygon(b10_st04a_profile);
                // st04b: measured section convex hull at x=-29.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st04b_z0]) linear_extrude(b10_st04b_z1 - b10_st04b_z0) polygon(b10_st04b_profile);
            }
            hull() {
                // st05a: measured section convex hull at x=-29.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st05a_z0]) linear_extrude(b10_st05a_z1 - b10_st05a_z0) polygon(b10_st05a_profile);
                // st05b: measured section convex hull at x=-28.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st05b_z0]) linear_extrude(b10_st05b_z1 - b10_st05b_z0) polygon(b10_st05b_profile);
            }
            hull() {
                // st06a: measured section convex hull at x=-28.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st06a_z0]) linear_extrude(b10_st06a_z1 - b10_st06a_z0) polygon(b10_st06a_profile);
                // st06b: measured section convex hull at x=-28.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st06b_z0]) linear_extrude(b10_st06b_z1 - b10_st06b_z0) polygon(b10_st06b_profile);
            }
            hull() {
                // st07a: measured section convex hull at x=-28.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st07a_z0]) linear_extrude(b10_st07a_z1 - b10_st07a_z0) polygon(b10_st07a_profile);
                // st07b: measured section convex hull at x=-28.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st07b_z0]) linear_extrude(b10_st07b_z1 - b10_st07b_z0) polygon(b10_st07b_profile);
            }
            hull() {
                // st08a: measured section convex hull at x=-28.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st08a_z0]) linear_extrude(b10_st08a_z1 - b10_st08a_z0) polygon(b10_st08a_profile);
                // st08b: measured section convex hull at x=-27.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st08b_z0]) linear_extrude(b10_st08b_z1 - b10_st08b_z0) polygon(b10_st08b_profile);
            }
            hull() {
                // st09a: measured section convex hull at x=-27.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st09a_z0]) linear_extrude(b10_st09a_z1 - b10_st09a_z0) polygon(b10_st09a_profile);
                // st09b: measured section convex hull at x=-27.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st09b_z0]) linear_extrude(b10_st09b_z1 - b10_st09b_z0) polygon(b10_st09b_profile);
            }
            hull() {
                // st10a: measured section convex hull at x=-27.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st10a_z0]) linear_extrude(b10_st10a_z1 - b10_st10a_z0) polygon(b10_st10a_profile);
                // st10b: measured section convex hull at x=-26.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st10b_z0]) linear_extrude(b10_st10b_z1 - b10_st10b_z0) polygon(b10_st10b_profile);
            }
            hull() {
                // st11a: measured section convex hull at x=-26.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st11a_z0]) linear_extrude(b10_st11a_z1 - b10_st11a_z0) polygon(b10_st11a_profile);
                // st11b: measured section convex hull at x=-26.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st11b_z0]) linear_extrude(b10_st11b_z1 - b10_st11b_z0) polygon(b10_st11b_profile);
            }
            hull() {
                // st12a: measured section convex hull at x=-26.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st12a_z0]) linear_extrude(b10_st12a_z1 - b10_st12a_z0) polygon(b10_st12a_profile);
                // st12b: measured section convex hull at x=-26.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st12b_z0]) linear_extrude(b10_st12b_z1 - b10_st12b_z0) polygon(b10_st12b_profile);
            }
            hull() {
                // st13a: measured section convex hull at x=-26.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st13a_z0]) linear_extrude(b10_st13a_z1 - b10_st13a_z0) polygon(b10_st13a_profile);
                // st13b: measured section convex hull at x=-25.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st13b_z0]) linear_extrude(b10_st13b_z1 - b10_st13b_z0) polygon(b10_st13b_profile);
            }
            hull() {
                // st14a: measured section convex hull at x=-25.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st14a_z0]) linear_extrude(b10_st14a_z1 - b10_st14a_z0) polygon(b10_st14a_profile);
                // st14b: measured section convex hull at x=-25.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st14b_z0]) linear_extrude(b10_st14b_z1 - b10_st14b_z0) polygon(b10_st14b_profile);
            }
            hull() {
                // st15a: measured section convex hull at x=-25.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st15a_z0]) linear_extrude(b10_st15a_z1 - b10_st15a_z0) polygon(b10_st15a_profile);
                // st15b: measured section convex hull at x=-24.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st15b_z0]) linear_extrude(b10_st15b_z1 - b10_st15b_z0) polygon(b10_st15b_profile);
            }
            hull() {
                // st16a: measured section convex hull at x=-24.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st16a_z0]) linear_extrude(b10_st16a_z1 - b10_st16a_z0) polygon(b10_st16a_profile);
                // st16b: measured section convex hull at x=-24.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st16b_z0]) linear_extrude(b10_st16b_z1 - b10_st16b_z0) polygon(b10_st16b_profile);
            }
            hull() {
                // st17a: measured section convex hull at x=-24.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st17a_z0]) linear_extrude(b10_st17a_z1 - b10_st17a_z0) polygon(b10_st17a_profile);
                // st17b: measured section convex hull at x=-24.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st17b_z0]) linear_extrude(b10_st17b_z1 - b10_st17b_z0) polygon(b10_st17b_profile);
            }
            hull() {
                // st18a: measured section convex hull at x=-24.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st18a_z0]) linear_extrude(b10_st18a_z1 - b10_st18a_z0) polygon(b10_st18a_profile);
                // st18b: measured section convex hull at x=-23.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st18b_z0]) linear_extrude(b10_st18b_z1 - b10_st18b_z0) polygon(b10_st18b_profile);
            }
            hull() {
                // st19a: measured section convex hull at x=-23.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st19a_z0]) linear_extrude(b10_st19a_z1 - b10_st19a_z0) polygon(b10_st19a_profile);
                // st19b: measured section convex hull at x=-23.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st19b_z0]) linear_extrude(b10_st19b_z1 - b10_st19b_z0) polygon(b10_st19b_profile);
            }
            hull() {
                // st20a: measured section convex hull at x=-23.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st20a_z0]) linear_extrude(b10_st20a_z1 - b10_st20a_z0) polygon(b10_st20a_profile);
                // st20b: measured section convex hull at x=-22.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st20b_z0]) linear_extrude(b10_st20b_z1 - b10_st20b_z0) polygon(b10_st20b_profile);
            }
            hull() {
                // st21a: measured section convex hull at x=-22.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st21a_z0]) linear_extrude(b10_st21a_z1 - b10_st21a_z0) polygon(b10_st21a_profile);
                // st21b: measured section convex hull at x=-22.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st21b_z0]) linear_extrude(b10_st21b_z1 - b10_st21b_z0) polygon(b10_st21b_profile);
            }
            hull() {
                // st22a: measured section convex hull at x=-22.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st22a_z0]) linear_extrude(b10_st22a_z1 - b10_st22a_z0) polygon(b10_st22a_profile);
                // st22b: measured section convex hull at x=-22.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st22b_z0]) linear_extrude(b10_st22b_z1 - b10_st22b_z0) polygon(b10_st22b_profile);
            }
            hull() {
                // st23a: measured section convex hull at x=-22.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st23a_z0]) linear_extrude(b10_st23a_z1 - b10_st23a_z0) polygon(b10_st23a_profile);
                // st23b: measured section convex hull at x=-21.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st23b_z0]) linear_extrude(b10_st23b_z1 - b10_st23b_z0) polygon(b10_st23b_profile);
            }
            hull() {
                // st24a: measured section convex hull at x=-21.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st24a_z0]) linear_extrude(b10_st24a_z1 - b10_st24a_z0) polygon(b10_st24a_profile);
                // st24b: measured section convex hull at x=-21.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st24b_z0]) linear_extrude(b10_st24b_z1 - b10_st24b_z0) polygon(b10_st24b_profile);
            }
            hull() {
                // st25a: measured section convex hull at x=-21.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st25a_z0]) linear_extrude(b10_st25a_z1 - b10_st25a_z0) polygon(b10_st25a_profile);
                // st25b: measured section convex hull at x=-20.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st25b_z0]) linear_extrude(b10_st25b_z1 - b10_st25b_z0) polygon(b10_st25b_profile);
            }
            hull() {
                // st26a: measured section convex hull at x=-20.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st26a_z0]) linear_extrude(b10_st26a_z1 - b10_st26a_z0) polygon(b10_st26a_profile);
                // st26b: measured section convex hull at x=-20.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st26b_z0]) linear_extrude(b10_st26b_z1 - b10_st26b_z0) polygon(b10_st26b_profile);
            }
            hull() {
                // st27a: measured section convex hull at x=-20.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st27a_z0]) linear_extrude(b10_st27a_z1 - b10_st27a_z0) polygon(b10_st27a_profile);
                // st27b: measured section convex hull at x=-20.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st27b_z0]) linear_extrude(b10_st27b_z1 - b10_st27b_z0) polygon(b10_st27b_profile);
            }
            hull() {
                // st28a: measured section convex hull at x=-20.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st28a_z0]) linear_extrude(b10_st28a_z1 - b10_st28a_z0) polygon(b10_st28a_profile);
                // st28b: measured section convex hull at x=-19.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st28b_z0]) linear_extrude(b10_st28b_z1 - b10_st28b_z0) polygon(b10_st28b_profile);
            }
            hull() {
                // st29a: measured section convex hull at x=-19.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st29a_z0]) linear_extrude(b10_st29a_z1 - b10_st29a_z0) polygon(b10_st29a_profile);
                // st29b: measured section convex hull at x=-19.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st29b_z0]) linear_extrude(b10_st29b_z1 - b10_st29b_z0) polygon(b10_st29b_profile);
            }
            hull() {
                // st30a: measured section convex hull at x=-19.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st30a_z0]) linear_extrude(b10_st30a_z1 - b10_st30a_z0) polygon(b10_st30a_profile);
                // st30b: measured section convex hull at x=-18.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st30b_z0]) linear_extrude(b10_st30b_z1 - b10_st30b_z0) polygon(b10_st30b_profile);
            }
            hull() {
                // st31a: measured section convex hull at x=-18.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st31a_z0]) linear_extrude(b10_st31a_z1 - b10_st31a_z0) polygon(b10_st31a_profile);
                // st31b: measured section convex hull at x=-18.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st31b_z0]) linear_extrude(b10_st31b_z1 - b10_st31b_z0) polygon(b10_st31b_profile);
            }
            hull() {
                // st32a: measured section convex hull at x=-18.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st32a_z0]) linear_extrude(b10_st32a_z1 - b10_st32a_z0) polygon(b10_st32a_profile);
                // st32b: measured section convex hull at x=-18.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st32b_z0]) linear_extrude(b10_st32b_z1 - b10_st32b_z0) polygon(b10_st32b_profile);
            }
            hull() {
                // st33a: measured section convex hull at x=-18.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st33a_z0]) linear_extrude(b10_st33a_z1 - b10_st33a_z0) polygon(b10_st33a_profile);
                // st33b: measured section convex hull at x=-17.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st33b_z0]) linear_extrude(b10_st33b_z1 - b10_st33b_z0) polygon(b10_st33b_profile);
            }
            hull() {
                // st34a: measured section convex hull at x=-17.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st34a_z0]) linear_extrude(b10_st34a_z1 - b10_st34a_z0) polygon(b10_st34a_profile);
                // st34b: measured section convex hull at x=-17.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st34b_z0]) linear_extrude(b10_st34b_z1 - b10_st34b_z0) polygon(b10_st34b_profile);
            }
            hull() {
                // st35a: measured section convex hull at x=-17.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st35a_z0]) linear_extrude(b10_st35a_z1 - b10_st35a_z0) polygon(b10_st35a_profile);
                // st35b: measured section convex hull at x=-16.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st35b_z0]) linear_extrude(b10_st35b_z1 - b10_st35b_z0) polygon(b10_st35b_profile);
            }
            hull() {
                // st36a: measured section convex hull at x=-16.918 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st36a_z0]) linear_extrude(b10_st36a_z1 - b10_st36a_z0) polygon(b10_st36a_profile);
                // st36b: measured section convex hull at x=-16.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st36b_z0]) linear_extrude(b10_st36b_z1 - b10_st36b_z0) polygon(b10_st36b_profile);
            }
            hull() {
                // st37a: measured section convex hull at x=-16.518 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st37a_z0]) linear_extrude(b10_st37a_z1 - b10_st37a_z0) polygon(b10_st37a_profile);
                // st37b: measured section convex hull at x=-16.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st37b_z0]) linear_extrude(b10_st37b_z1 - b10_st37b_z0) polygon(b10_st37b_profile);
            }
            hull() {
                // st38a: measured section convex hull at x=-16.118 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st38a_z0]) linear_extrude(b10_st38a_z1 - b10_st38a_z0) polygon(b10_st38a_profile);
                // st38b: measured section convex hull at x=-15.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st38b_z0]) linear_extrude(b10_st38b_z1 - b10_st38b_z0) polygon(b10_st38b_profile);
            }
            hull() {
                // st39a: measured section convex hull at x=-15.718 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st39a_z0]) linear_extrude(b10_st39a_z1 - b10_st39a_z0) polygon(b10_st39a_profile);
                // st39b: measured section convex hull at x=-15.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st39b_z0]) linear_extrude(b10_st39b_z1 - b10_st39b_z0) polygon(b10_st39b_profile);
            }
            hull() {
                // st40a: measured section convex hull at x=-15.318 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st40a_z0]) linear_extrude(b10_st40a_z1 - b10_st40a_z0) polygon(b10_st40a_profile);
                // st40b: measured section convex hull at x=-15.228 (high-res tessellation)
                rotate([90, 0, 90]) translate([0, 0, b10_st40b_z0]) linear_extrude(b10_st40b_z1 - b10_st40b_z0) polygon(b10_st40b_profile);
            }
        }
        // pocket0: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b10_pocket0_z0]) linear_extrude(b10_pocket0_z1 - b10_pocket0_z0) polygon(b10_pocket0_profile);
        // pocket1: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b10_pocket1_z0]) linear_extrude(b10_pocket1_z1 - b10_pocket1_z0) polygon(b10_pocket1_profile);
        // pocket2: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b10_pocket2_z0]) linear_extrude(b10_pocket2_z1 - b10_pocket2_z0) polygon(b10_pocket2_profile);
    }
}

// ---- body 11 (strategy: rotate_extrude — exact RZ profile) ----
// revolution axis: through [14.425505, 8.269981, 0.530304] along [0, 0, 1]; profile z measured from the axis low end
// Pappus check: profile revolves to 528.51 mm³ vs exact B-rep volume 531.63 mm³
b11_bore_r        = 2.7;  // exact B-rep: cylinder face(s) #2 radius (reversed -> bore)
b11_cbore_r       = 4.7;  // exact B-rep: cylinder face(s) #0 radius (reversed -> bore)
b11_total_h       = 3.75;  // exact B-rep: axial extent of the coaxial faces #0/#2/#3/#6/#7 (v-ranges)
b11_z_step1       = 2;  // exact B-rep: plane face(s) #1 height above the base
b11_cham1         = 0.5;  // exact B-rep: cone face(s) #7 (45° half-angle) radial width = axial height (45°)
b11_bore_bot_cham = 0.5;  // exact B-rep: cone face(s) #3 (45° half-angle) radial width = axial height (45°)
b11_fn            = 128;  // rotate_extrude curve resolution

module body_11() {
    // closed RZ boundary loop: up the bore, across the top,
    // down the outside, across the bottom (ring -> through-bore)
    translate([14.425505, 8.269981, 0.530304]) rotate_extrude($fn = b11_fn)
        polygon(points = [
            [b11_bore_r + b11_bore_bot_cham, 0],      // cone face(s) #3
            [b11_bore_r, b11_bore_bot_cham],          // cone face(s) #3
            [b11_bore_r, b11_z_step1],                // cyl face(s) #2
            [b11_cbore_r, b11_z_step1],               // cyl face(s) #0
            [b11_cbore_r, b11_total_h],               // cyl face(s) #0
            [b11_cbore_r + b11_cham1, b11_total_h],   // arc face(s) #6
            [5.907046, 3.667087],                     // arc face(s) #6
            [6.575728, 3.422848],                     // arc face(s) #6
            [7.169764, 3.030533],                     // arc face(s) #6
            [7.656921, 2.511432],                     // arc face(s) #6
            [8.010766, 1.893709],                     // arc face(s) #6
            [8.212101, 1.210881],                     // arc face(s) #6
            [8.25, b11_cham1],                        // cone face(s) #7
            [7.75, 0]                                 // cone face(s) #7
        ]);
}

// ---- body 12 (strategy: csg — agent plan) ----
// plan: hull-loft along y from measured sections; plan-view concavity cutters (fork slot/barb notches); engraved label grooves (<0.3 mm³) intentionally omitted
b12_st00a_profile = [[0.9207, -20.10496], [1.84976, -20.52222], [2.77249, -20.46051], [3.43991, -20.10496], [3.43991, -16.97535], [2.51085, -16.55809], [1.58812, -16.6198], [0.9207, -16.97535]];  // (z, x) points — measured section convex hull at y=-18.854 (high-res tessellation)
b12_st00a_z0 = -18.854;  // extent along y
b12_st00a_z1 = -18.834;
b12_st00b_profile = [[0.7307, -20.19382], [1.22332, -20.52058], [1.86855, -20.7172], [2.54292, -20.70887], [3.18283, -20.49644], [3.62991, -20.19382], [3.62991, -16.8865], [3.13729, -16.55973], [2.49205, -16.36311], [1.81769, -16.37144], [1.17777, -16.58387], [0.7307, -16.8865]];  // (z, x) points — measured section convex hull at y=-18.664 (high-res tessellation)
b12_st00b_z0 = -18.664;  // extent along y
b12_st00b_z1 = -18.644;
b12_st01a_profile = [[0.7307, -20.19382], [1.22332, -20.52058], [1.86855, -20.7172], [2.54292, -20.70887], [3.18283, -20.49644], [3.62991, -20.19382], [3.62991, -16.8865], [3.13729, -16.55973], [2.49205, -16.36311], [1.81769, -16.37144], [1.17777, -16.58387], [0.7307, -16.8865]];  // (z, x) points — measured section convex hull at y=-18.664 (high-res tessellation)
b12_st01a_z0 = -18.664;  // extent along y
b12_st01a_z1 = -18.644;
b12_st01b_profile = [[0.5303, -20.283], [1.17291, -20.71849], [1.92091, -20.9261], [2.69605, -20.88409], [3.41723, -20.59686], [3.8303, -20.283], [3.8303, -16.79731], [3.1877, -16.36182], [2.4397, -16.15421], [1.66456, -16.19623], [0.94338, -16.48346], [0.5303, -16.79731]];  // (z, x) points — measured section convex hull at y=-18.264 (high-res tessellation)
b12_st01b_z0 = -18.264;  // extent along y
b12_st01b_z1 = -18.244;
b12_st02a_profile = [[0.5303, -20.283], [1.17291, -20.71849], [1.92091, -20.9261], [2.69605, -20.88409], [3.41723, -20.59686], [3.8303, -20.283], [3.8303, -16.79731], [3.1877, -16.36182], [2.4397, -16.15421], [1.66456, -16.19623], [0.94338, -16.48346], [0.5303, -16.79731]];  // (z, x) points — measured section convex hull at y=-18.264 (high-res tessellation)
b12_st02a_z0 = -18.264;  // extent along y
b12_st02a_z1 = -18.244;
b12_st02b_profile = [[0.5303, -20.283], [1.22476, -20.73915], [1.92091, -20.9261], [3.01545, -20.7871], [3.67482, -20.415], [3.8303, -20.283], [3.8303, -16.79731], [2.91046, -16.25573], [2.1431, -16.14217], [1.13999, -16.37926], [0.5303, -16.79731]];  // (z, x) points — measured section convex hull at y=-17.864 (high-res tessellation)
b12_st02b_z0 = -17.864;  // extent along y
b12_st02b_z1 = -17.844;
b12_st03a_profile = [[0.5303, -20.283], [1.22476, -20.73915], [1.92091, -20.9261], [3.01545, -20.7871], [3.67482, -20.415], [3.8303, -20.283], [3.8303, -16.79731], [2.91046, -16.25573], [2.1431, -16.14217], [1.13999, -16.37926], [0.5303, -16.79731]];  // (z, x) points — measured section convex hull at y=-17.864 (high-res tessellation)
b12_st03a_z0 = -17.864;  // extent along y
b12_st03a_z1 = -17.844;
b12_st03b_profile = [[0.5303, -19.48223], [0.98701, -20.01845], [1.60419, -20.35055], [2.3008, -20.43615], [2.98051, -20.26323], [3.5505, -19.85625], [3.8303, -19.48223], [3.82865, -17.59556], [3.3736, -17.06186], [2.75886, -16.73038], [2.0603, -16.6441], [1.3801, -16.81708], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-17.464 (high-res tessellation)
b12_st03b_z0 = -17.464;  // extent along y
b12_st03b_z1 = -17.444;
b12_st04a_profile = [[0.5303, -19.48223], [0.98701, -20.01845], [1.60419, -20.35055], [2.3008, -20.43615], [2.98051, -20.26323], [3.5505, -19.85625], [3.8303, -19.48223], [3.82865, -17.59556], [3.3736, -17.06186], [2.75886, -16.73038], [2.0603, -16.6441], [1.3801, -16.81708], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-17.464 (high-res tessellation)
b12_st04a_z0 = -17.464;  // extent along y
b12_st04a_z1 = -17.444;
b12_st04b_profile = [[0.53417, -19.48813], [0.99029, -20.02079], [1.60859, -20.35166], [2.30481, -20.43565], [2.98406, -20.26131], [3.55344, -19.85279], [3.8303, -19.48223], [3.82699, -17.59303], [3.37114, -17.06011], [2.75886, -16.73038], [2.0558, -16.64466], [1.37655, -16.819], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-17.064 (high-res tessellation)
b12_st04b_z0 = -17.064;  // extent along y
b12_st04b_z1 = -17.044;
b12_st05a_profile = [[0.53417, -19.48813], [0.99029, -20.02079], [1.60859, -20.35166], [2.30481, -20.43565], [2.98406, -20.26131], [3.55344, -19.85279], [3.8303, -19.48223], [3.82699, -17.59303], [3.37114, -17.06011], [2.75886, -16.73038], [2.0558, -16.64466], [1.37655, -16.819], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-17.064 (high-res tessellation)
b12_st05a_z0 = -17.064;  // extent along y
b12_st05a_z1 = -17.044;
b12_st05b_profile = [[0.53583, -19.49066], [0.99358, -20.02313], [1.6125, -20.35265], [2.29781, -20.43652], [2.97785, -20.26466], [3.55605, -19.84972], [3.8303, -19.48223], [3.8245, -17.58923], [3.36703, -17.05718], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.80488, -17.23021], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-16.664 (high-res tessellation)
b12_st05b_z0 = -16.664;  // extent along y
b12_st05b_z1 = -16.644;
b12_st06a_profile = [[0.53583, -19.49066], [0.99358, -20.02313], [1.6125, -20.35265], [2.29781, -20.43652], [2.97785, -20.26466], [3.55605, -19.84972], [3.8303, -19.48223], [3.8245, -17.58923], [3.36703, -17.05718], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.80488, -17.23021], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-16.664 (high-res tessellation)
b12_st06a_z0 = -16.664;  // extent along y
b12_st06a_z1 = -16.644;
b12_st06b_profile = [[0.5303, -19.48223], [0.99604, -20.02488], [1.61544, -20.35339], [2.31181, -20.43478], [2.99116, -20.25748], [3.55834, -19.84703], [3.8303, -19.48223], [3.82201, -17.58544], [3.36374, -17.05484], [2.74517, -16.72692], [2.04879, -16.64553], [1.36945, -16.82283], [0.80227, -17.23328], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-16.264 (high-res tessellation)
b12_st06b_z0 = -16.264;  // extent along y
b12_st06b_z1 = -16.244;
b12_st07a_profile = [[0.5303, -19.48223], [0.99604, -20.02488], [1.61544, -20.35339], [2.31181, -20.43478], [2.99116, -20.25748], [3.55834, -19.84703], [3.8303, -19.48223], [3.82201, -17.58544], [3.36374, -17.05484], [2.74517, -16.72692], [2.04879, -16.64553], [1.36945, -16.82283], [0.80227, -17.23328], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-16.264 (high-res tessellation)
b12_st07a_z0 = -16.264;  // extent along y
b12_st07a_z1 = -16.244;
b12_st07b_profile = [[0.54081, -19.49825], [1.00015, -20.02781], [1.61935, -20.35438], [2.31632, -20.43422], [2.99471, -20.25556], [3.56095, -19.84395], [3.8303, -19.48223], [3.82035, -17.58291], [3.36128, -17.05309], [2.75886, -16.73038], [2.04479, -16.64603], [1.3659, -16.82475], [0.79933, -17.23674], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-15.864 (high-res tessellation)
b12_st07b_z0 = -15.864;  // extent along y
b12_st07b_z1 = -15.844;
b12_st08a_profile = [[0.54081, -19.49825], [1.00015, -20.02781], [1.61935, -20.35438], [2.31632, -20.43422], [2.99471, -20.25556], [3.56095, -19.84395], [3.8303, -19.48223], [3.82035, -17.58291], [3.36128, -17.05309], [2.75886, -16.73038], [2.04479, -16.64603], [1.3659, -16.82475], [0.79933, -17.23674], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-15.864 (high-res tessellation)
b12_st08a_z0 = -15.864;  // extent along y
b12_st08a_z1 = -15.844;
b12_st08b_profile = [[0.54247, -19.50078], [1.00344, -20.03015], [1.62375, -20.35549], [2.32082, -20.43366], [2.97785, -20.26466], [3.56356, -19.84088], [3.8303, -19.48223], [3.81786, -17.57911], [3.35717, -17.05016], [2.73686, -16.72482], [2.04029, -16.64659], [1.38276, -16.81565], [0.79639, -17.2402], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-15.464 (high-res tessellation)
b12_st08b_z0 = -15.464;  // extent along y
b12_st08b_z1 = -15.444;
b12_st09a_profile = [[0.54247, -19.50078], [1.00344, -20.03015], [1.62375, -20.35549], [2.32082, -20.43366], [2.97785, -20.26466], [3.56356, -19.84088], [3.8303, -19.48223], [3.81786, -17.57911], [3.35717, -17.05016], [2.73686, -16.72482], [2.04029, -16.64659], [1.38276, -16.81565], [0.79639, -17.2402], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-15.464 (high-res tessellation)
b12_st09a_z0 = -15.464;  // extent along y
b12_st09a_z1 = -15.444;
b12_st09b_profile = [[0.5303, -19.48223], [1.00631, -20.0322], [1.62766, -20.35648], [2.32483, -20.43316], [3.00181, -20.25173], [3.5665, -19.83742], [3.8303, -19.48223], [3.81537, -17.57532], [3.35388, -17.04782], [2.73295, -16.72383], [2.03578, -16.64715], [1.3588, -16.82858], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-15.064 (high-res tessellation)
b12_st09b_z0 = -15.064;  // extent along y
b12_st09b_z1 = -15.044;
b12_st10a_profile = [[0.5303, -19.48223], [1.00631, -20.0322], [1.62766, -20.35648], [2.32483, -20.43316], [3.00181, -20.25173], [3.5665, -19.83742], [3.8303, -19.48223], [3.81537, -17.57532], [3.35388, -17.04782], [2.73295, -16.72383], [2.03578, -16.64715], [1.3588, -16.82858], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-15.064 (high-res tessellation)
b12_st10a_z0 = -15.064;  // extent along y
b12_st10a_z1 = -15.044;
b12_st10b_profile = [[0.54745, -19.50837], [1.0096, -20.03454], [1.63206, -20.35759], [2.29781, -20.43652], [3.00536, -20.24981], [3.56879, -19.83473], [3.8303, -19.48223], [3.81371, -17.57279], [3.3506, -17.04548], [2.72855, -16.72272], [2.0628, -16.64379], [1.35525, -16.8305], [0.79182, -17.24558], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-14.664 (high-res tessellation)
b12_st10b_z0 = -14.664;  // extent along y
b12_st10b_z1 = -14.644;
b12_st11a_profile = [[0.54745, -19.50837], [1.0096, -20.03454], [1.63206, -20.35759], [2.29781, -20.43652], [3.00536, -20.24981], [3.56879, -19.83473], [3.8303, -19.48223], [3.81371, -17.57279], [3.3506, -17.04548], [2.72855, -16.72272], [2.0628, -16.64379], [1.35525, -16.8305], [0.79182, -17.24558], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-14.664 (high-res tessellation)
b12_st11a_z0 = -14.664;  // extent along y
b12_st11a_z1 = -14.644;
b12_st11b_profile = [[0.54911, -19.5109], [1.01289, -20.03688], [1.63597, -20.35858], [2.33183, -20.43229], [2.97785, -20.26466], [3.5714, -19.83166], [3.8303, -19.48223], [3.81122, -17.56899], [3.34731, -17.04314], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-14.264 (high-res tessellation)
b12_st11b_z0 = -14.264;  // extent along y
b12_st11b_z1 = -14.244;
b12_st12a_profile = [[0.54911, -19.5109], [1.01289, -20.03688], [1.63597, -20.35858], [2.33183, -20.43229], [2.97785, -20.26466], [3.5714, -19.83166], [3.8303, -19.48223], [3.81122, -17.56899], [3.34731, -17.04314], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-14.264 (high-res tessellation)
b12_st12a_z0 = -14.264;  // extent along y
b12_st12a_z1 = -14.244;
b12_st12b_profile = [[0.5303, -19.48223], [1.01617, -20.03922], [1.63988, -20.35957], [2.33634, -20.43173], [3.01246, -20.24598], [3.57434, -19.8282], [3.8303, -19.48223], [3.80873, -17.5652], [3.34443, -17.04109], [2.75886, -16.73038], [2.02477, -16.64852], [1.34815, -16.83433], [0.78627, -17.25211], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-13.864 (high-res tessellation)
b12_st12b_z0 = -13.864;  // extent along y
b12_st12b_z1 = -13.844;
b12_st13a_profile = [[0.5303, -19.48223], [1.01617, -20.03922], [1.63988, -20.35957], [2.33634, -20.43173], [3.01246, -20.24598], [3.57434, -19.8282], [3.8303, -19.48223], [3.80873, -17.5652], [3.34443, -17.04109], [2.75886, -16.73038], [2.02477, -16.64852], [1.34815, -16.83433], [0.78627, -17.25211], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-13.864 (high-res tessellation)
b12_st13a_z0 = -13.864;  // extent along y
b12_st13a_z1 = -13.844;
b12_st13b_profile = [[0.55409, -19.51849], [1.01946, -20.04156], [1.64282, -20.36031], [2.34084, -20.43117], [3.01601, -20.24406], [3.57728, -19.82474], [3.8303, -19.48223], [3.80707, -17.56267], [3.34115, -17.03875], [2.71779, -16.72], [2.02027, -16.64908], [1.3446, -16.83625], [0.78398, -17.2548], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-13.464 (high-res tessellation)
b12_st13b_z0 = -13.464;  // extent along y
b12_st13b_z1 = -13.444;
b12_st14a_profile = [[0.55409, -19.51849], [1.01946, -20.04156], [1.64282, -20.36031], [2.34084, -20.43117], [3.01601, -20.24406], [3.57728, -19.82474], [3.8303, -19.48223], [3.80707, -17.56267], [3.34115, -17.03875], [2.71779, -16.72], [2.02027, -16.64908], [1.3446, -16.83625], [0.78398, -17.2548], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-13.464 (high-res tessellation)
b12_st14a_z0 = -13.464;  // extent along y
b12_st14a_z1 = -13.444;
b12_st14b_profile = [[0.55575, -19.52102], [1.02275, -20.0439], [1.60175, -20.34993], [2.34484, -20.43067], [2.97785, -20.26466], [3.57924, -19.82243], [3.8303, -19.48223], [3.80458, -17.55887], [3.33786, -17.03641], [2.75886, -16.73038], [2.01576, -16.64964], [1.34105, -16.83817], [0.78104, -17.25826], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-13.064 (high-res tessellation)
b12_st14b_z0 = -13.064;  // extent along y
b12_st14b_z1 = -13.044;
b12_st15a_profile = [[0.55575, -19.52102], [1.02275, -20.0439], [1.60175, -20.34993], [2.34484, -20.43067], [2.97785, -20.26466], [3.57924, -19.82243], [3.8303, -19.48223], [3.80458, -17.55887], [3.33786, -17.03641], [2.75886, -16.73038], [2.01576, -16.64964], [1.34105, -16.83817], [0.78104, -17.25826], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-13.064 (high-res tessellation)
b12_st15a_z0 = -13.064;  // extent along y
b12_st15a_z1 = -13.044;
b12_st15b_profile = [[0.5303, -19.48223], [1.02603, -20.04624], [1.65113, -20.36241], [2.29781, -20.43652], [3.02311, -20.24023], [3.58185, -19.81936], [3.8303, -19.48223], [3.80209, -17.55508], [3.33458, -17.03407], [2.70948, -16.7179], [2.0628, -16.64379], [1.3375, -16.84008], [0.7781, -17.26172], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-12.664 (high-res tessellation)
b12_st15b_z0 = -12.664;  // extent along y
b12_st15b_z1 = -12.644;
b12_st16a_profile = [[0.5303, -19.48223], [1.02603, -20.04624], [1.65113, -20.36241], [2.29781, -20.43652], [3.02311, -20.24023], [3.58185, -19.81936], [3.8303, -19.48223], [3.80209, -17.55508], [3.33458, -17.03407], [2.70948, -16.7179], [2.0628, -16.64379], [1.3375, -16.84008], [0.7781, -17.26172], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-12.664 (high-res tessellation)
b12_st16a_z0 = -12.664;  // extent along y
b12_st16a_z1 = -12.644;
b12_st16b_profile = [[0.56073, -19.52861], [1.02932, -20.04858], [1.65504, -20.3634], [2.35185, -20.4298], [3.02666, -20.23831], [3.58512, -19.81552], [3.8303, -19.48223], [3.80043, -17.55255], [3.33129, -17.03173], [2.75886, -16.73038], [2.0628, -16.64379], [1.33395, -16.842], [0.77549, -17.26479], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-12.264 (high-res tessellation)
b12_st16b_z0 = -12.264;  // extent along y
b12_st16b_z1 = -12.244;
b12_st17a_profile = [[0.56073, -19.52861], [1.02932, -20.04858], [1.65504, -20.3634], [2.35185, -20.4298], [3.02666, -20.23831], [3.58512, -19.81552], [3.8303, -19.48223], [3.80043, -17.55255], [3.33129, -17.03173], [2.75886, -16.73038], [2.0628, -16.64379], [1.33395, -16.842], [0.77549, -17.26479], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-12.264 (high-res tessellation)
b12_st17a_z0 = -12.264;  // extent along y
b12_st17a_z1 = -12.244;
b12_st17b_profile = [[0.5303, -19.48223], [1.0326, -20.05092], [1.65944, -20.36451], [2.35635, -20.42924], [2.97785, -20.26466], [3.58708, -19.81321], [3.8303, -19.48223], [3.8303, -17.59808], [3.328, -17.02939], [2.70117, -16.7158], [2.00475, -16.65101], [1.3304, -16.84392], [0.77353, -17.2671], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-11.864 (high-res tessellation)
b12_st17b_z0 = -11.864;  // extent along y
b12_st17b_z1 = -11.844;
b12_st18a_profile = [[0.5303, -19.48223], [1.0326, -20.05092], [1.65944, -20.36451], [2.35635, -20.42924], [2.97785, -20.26466], [3.58708, -19.81321], [3.8303, -19.48223], [3.8303, -17.59808], [3.328, -17.02939], [2.70117, -16.7158], [2.00475, -16.65101], [1.3304, -16.84392], [0.77353, -17.2671], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-11.864 (high-res tessellation)
b12_st18a_z0 = -11.864;  // extent along y
b12_st18a_z1 = -11.844;
b12_st18b_profile = [[0.5303, -19.48223], [1.03548, -20.05297], [1.89165, -20.41523], [2.81806, -20.32688], [3.58969, -19.81014], [3.8303, -19.48223], [3.8303, -17.59808], [3.32472, -17.02705], [2.46896, -16.66508], [1.82959, -16.6728], [1.12422, -16.96415], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-11.464 (high-res tessellation)
b12_st18b_z0 = -11.464;  // extent along y
b12_st18b_z1 = -11.444;
b12_st19a_profile = [[0.5303, -19.48223], [1.03548, -20.05297], [1.89165, -20.41523], [2.81806, -20.32688], [3.58969, -19.81014], [3.8303, -19.48223], [3.8303, -17.59808], [3.32472, -17.02705], [2.46896, -16.66508], [1.82959, -16.6728], [1.12422, -16.96415], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-11.464 (high-res tessellation)
b12_st19a_z0 = -11.464;  // extent along y
b12_st19a_z1 = -11.444;
b12_st19b_profile = [[0.5303, -19.48223], [1.03877, -20.05531], [1.60175, -20.34993], [2.36486, -20.42818], [3.18464, -20.15302], [3.73818, -19.62264], [3.8303, -19.48223], [3.8303, -17.59808], [3.32143, -17.02471], [2.46446, -16.66452], [1.82959, -16.6728], [1.12093, -16.96649], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-11.064 (high-res tessellation)
b12_st19b_z0 = -11.064;  // extent along y
b12_st19b_z1 = -11.044;
b12_st20a_profile = [[0.5303, -19.48223], [1.03877, -20.05531], [1.60175, -20.34993], [2.36486, -20.42818], [3.18464, -20.15302], [3.73818, -19.62264], [3.8303, -19.48223], [3.8303, -17.59808], [3.32143, -17.02471], [2.46446, -16.66452], [1.82959, -16.6728], [1.12093, -16.96649], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-11.064 (high-res tessellation)
b12_st20a_z0 = -11.064;  // extent along y
b12_st20a_z1 = -11.044;
b12_st20b_profile = [[0.5303, -19.48223], [1.04205, -20.05765], [1.90065, -20.41635], [2.75886, -20.34993], [3.42882, -19.96827], [3.8303, -19.48223], [3.8303, -17.59808], [3.31814, -17.02237], [2.75886, -16.73038], [2.0628, -16.64379], [1.32019, -16.84943], [0.62049, -17.46062], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-10.664 (high-res tessellation)
b12_st20b_z0 = -10.664;  // extent along y
b12_st20b_z1 = -10.644;
b12_st21a_profile = [[0.5303, -19.48223], [1.04205, -20.05765], [1.90065, -20.41635], [2.75886, -20.34993], [3.42882, -19.96827], [3.8303, -19.48223], [3.8303, -17.59808], [3.31814, -17.02237], [2.75886, -16.73038], [2.0628, -16.64379], [1.32019, -16.84943], [0.62049, -17.46062], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-10.664 (high-res tessellation)
b12_st21a_z0 = -10.664;  // extent along y
b12_st21a_z1 = -10.644;
b12_st21b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [3.04441, -20.22873], [3.74233, -19.61631], [3.8303, -19.48223], [3.8303, -17.59808], [3.11808, -16.89136], [2.53101, -16.6728], [1.82959, -16.6728], [0.92956, -17.11408], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-10.264 (high-res tessellation)
b12_st21b_z0 = -10.264;  // extent along y
b12_st21b_z1 = -10.244;
b12_st22a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [3.04441, -20.22873], [3.74233, -19.61631], [3.8303, -19.48223], [3.8303, -17.59808], [3.11808, -16.89136], [2.53101, -16.6728], [1.82959, -16.6728], [0.92956, -17.11408], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-10.264 (high-res tessellation)
b12_st22a_z0 = -10.264;  // extent along y
b12_st22a_z1 = -10.244;
b12_st22b_profile = [[0.5303, -19.48223], [1.24519, -20.19039], [1.82959, -20.40751], [2.83216, -20.32139], [3.60047, -19.79746], [3.8303, -19.48223], [3.8303, -17.59808], [3.11453, -16.88944], [2.53101, -16.6728], [1.82959, -16.6728], [0.92659, -17.11681], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-9.864 (high-res tessellation)
b12_st22b_z0 = -9.864;  // extent along y
b12_st22b_z1 = -9.844;
b12_st23a_profile = [[0.5303, -19.48223], [1.24519, -20.19039], [1.82959, -20.40751], [2.83216, -20.32139], [3.60047, -19.79746], [3.8303, -19.48223], [3.8303, -17.59808], [3.11453, -16.88944], [2.53101, -16.6728], [1.82959, -16.6728], [0.92659, -17.11681], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-9.864 (high-res tessellation)
b12_st23a_z0 = -9.864;  // extent along y
b12_st23a_z1 = -9.844;
b12_st23b_profile = [[0.5303, -19.48223], [1.24874, -20.19231], [2.0628, -20.43652], [2.97785, -20.26466], [3.74703, -19.60915], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.30954, -16.85518], [0.61385, -17.47074], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-9.464 (high-res tessellation)
b12_st23b_z0 = -9.464;  // extent along y
b12_st23b_z1 = -9.444;
b12_st24a_profile = [[0.5303, -19.48223], [1.24874, -20.19231], [2.0628, -20.43652], [2.97785, -20.26466], [3.74703, -19.60915], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.30954, -16.85518], [0.61385, -17.47074], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-9.464 (high-res tessellation)
b12_st24a_z0 = -9.464;  // extent along y
b12_st24a_z1 = -9.444;
b12_st24b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.84015, -20.31828], [3.60569, -19.79131], [3.8303, -19.48223], [3.8303, -17.59808], [3.10743, -16.88561], [2.29781, -16.64379], [1.60175, -16.73038], [0.75524, -17.28862], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-9.064 (high-res tessellation)
b12_st24b_z0 = -9.064;  // extent along y
b12_st24b_z1 = -9.044;
b12_st25a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.84015, -20.31828], [3.60569, -19.79131], [3.8303, -19.48223], [3.8303, -17.59808], [3.10743, -16.88561], [2.29781, -16.64379], [1.60175, -16.73038], [0.75524, -17.28862], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-9.064 (high-res tessellation)
b12_st25a_z0 = -9.064;  // extent along y
b12_st25a_z1 = -9.044;
b12_st25b_profile = [[0.5303, -19.48223], [1.25584, -20.19614], [2.0628, -20.43652], [2.75886, -20.34993], [3.60798, -19.78862], [3.8303, -19.48223], [3.8303, -17.59808], [3.10388, -16.88369], [2.29781, -16.64379], [1.60175, -16.73038], [0.75263, -17.29169], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-8.664 (high-res tessellation)
b12_st25b_z0 = -8.664;  // extent along y
b12_st25b_z1 = -8.644;
b12_st26a_profile = [[0.5303, -19.48223], [1.25584, -20.19614], [2.0628, -20.43652], [2.75886, -20.34993], [3.60798, -19.78862], [3.8303, -19.48223], [3.8303, -17.59808], [3.10388, -16.88369], [2.29781, -16.64379], [1.60175, -16.73038], [0.75263, -17.29169], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-8.664 (high-res tessellation)
b12_st26a_z0 = -8.664;  // extent along y
b12_st26a_z1 = -8.644;
b12_st26b_profile = [[0.5303, -19.48223], [1.25939, -20.19806], [2.0628, -20.43652], [2.97785, -20.26466], [3.75367, -19.59903], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-8.264 (high-res tessellation)
b12_st26b_z0 = -8.264;  // extent along y
b12_st26b_z1 = -8.244;
b12_st27a_profile = [[0.5303, -19.48223], [1.25939, -20.19806], [2.0628, -20.43652], [2.97785, -20.26466], [3.75367, -19.59903], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-8.264 (high-res tessellation)
b12_st27a_z0 = -8.264;  // extent along y
b12_st27a_z1 = -8.244;
b12_st27b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.85096, -20.31407], [3.61386, -19.7817], [3.8303, -19.48223], [3.8303, -17.59808], [3.09678, -16.87986], [2.53101, -16.6728], [1.82959, -16.6728], [0.91173, -17.13045], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-7.864 (high-res tessellation)
b12_st27b_z0 = -7.864;  // extent along y
b12_st27b_z1 = -7.844;
b12_st28a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.85096, -20.31407], [3.61386, -19.7817], [3.8303, -19.48223], [3.8303, -17.59808], [3.09678, -16.87986], [2.53101, -16.6728], [1.82959, -16.6728], [0.91173, -17.13045], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-7.864 (high-res tessellation)
b12_st28a_z0 = -7.864;  // extent along y
b12_st28a_z1 = -7.844;
b12_st28b_profile = [[0.5303, -19.48223], [1.26649, -20.20189], [2.0628, -20.43652], [2.97785, -20.26466], [3.7581, -19.59228], [3.8303, -19.48223], [3.8303, -17.59808], [3.09323, -16.87794], [2.29781, -16.64379], [1.29179, -16.86476], [0.65922, -17.4016], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-7.464 (high-res tessellation)
b12_st28b_z0 = -7.464;  // extent along y
b12_st28b_z1 = -7.444;
b12_st29a_profile = [[0.5303, -19.48223], [1.26649, -20.20189], [2.0628, -20.43652], [2.97785, -20.26466], [3.7581, -19.59228], [3.8303, -19.48223], [3.8303, -17.59808], [3.09323, -16.87794], [2.29781, -16.64379], [1.29179, -16.86476], [0.65922, -17.4016], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-7.464 (high-res tessellation)
b12_st29a_z0 = -7.464;  // extent along y
b12_st29a_z1 = -7.444;
b12_st29b_profile = [[0.5303, -19.48223], [1.27004, -20.20381], [2.0628, -20.43652], [2.97785, -20.26466], [3.76059, -19.58849], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.28824, -16.86668], [0.65922, -17.4016], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-7.064 (high-res tessellation)
b12_st29b_z0 = -7.064;  // extent along y
b12_st29b_z1 = -7.044;
b12_st30a_profile = [[0.5303, -19.48223], [1.27004, -20.20381], [2.0628, -20.43652], [2.97785, -20.26466], [3.76059, -19.58849], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.28824, -16.86668], [0.65922, -17.4016], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-7.064 (high-res tessellation)
b12_st30a_z0 = -7.064;  // extent along y
b12_st30a_z1 = -7.044;
b12_st30b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [3.18464, -20.15302], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.60175, -16.73038], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-6.664 (high-res tessellation)
b12_st30b_z0 = -6.664;  // extent along y
b12_st30b_z1 = -6.644;
b12_st31a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [3.18464, -20.15302], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.60175, -16.73038], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-6.664 (high-res tessellation)
b12_st31a_z0 = -6.664;  // extent along y
b12_st31a_z1 = -6.644;
b12_st31b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.60175, -16.73038], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-6.264 (high-res tessellation)
b12_st31b_z0 = -6.264;  // extent along y
b12_st31b_z1 = -6.244;
b12_st32a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.60175, -16.73038], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-6.264 (high-res tessellation)
b12_st32a_z0 = -6.264;  // extent along y
b12_st32a_z1 = -6.244;
b12_st32b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.53101, -20.40751], [3.37606, -20.01669], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-5.864 (high-res tessellation)
b12_st32b_z0 = -5.864;  // extent along y
b12_st32b_z1 = -5.844;
b12_st33a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.53101, -20.40751], [3.37606, -20.01669], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-5.864 (high-res tessellation)
b12_st33a_z0 = -5.864;  // extent along y
b12_st33a_z1 = -5.844;
b12_st33b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.38276, -16.81565], [0.65922, -17.4016], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-5.464 (high-res tessellation)
b12_st33b_z0 = -5.464;  // extent along y
b12_st33b_z1 = -5.444;
b12_st34a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.38276, -16.81565], [0.65922, -17.4016], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-5.464 (high-res tessellation)
b12_st34a_z0 = -5.464;  // extent along y
b12_st34a_z1 = -5.444;
b12_st34b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.53101, -20.40751], [3.37606, -20.01669], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-5.064 (high-res tessellation)
b12_st34b_z0 = -5.064;  // extent along y
b12_st34b_z1 = -5.044;
b12_st35a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.53101, -20.40751], [3.37606, -20.01669], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-5.064 (high-res tessellation)
b12_st35a_z0 = -5.064;  // extent along y
b12_st35a_z1 = -5.044;
b12_st35b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-4.664 (high-res tessellation)
b12_st35b_z0 = -4.664;  // extent along y
b12_st35b_z1 = -4.644;
b12_st36a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-4.664 (high-res tessellation)
b12_st36a_z0 = -4.664;  // extent along y
b12_st36a_z1 = -4.644;
b12_st36b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.17597, -16.9273], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-4.264 (high-res tessellation)
b12_st36b_z0 = -4.264;  // extent along y
b12_st36b_z1 = -4.244;
b12_st37a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [2.0628, -20.43652], [2.97785, -20.26466], [3.70138, -19.67871], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.17597, -16.9273], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-4.264 (high-res tessellation)
b12_st37a_z0 = -4.264;  // extent along y
b12_st37a_z1 = -4.244;
b12_st37b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.75886, -20.34993], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-3.864 (high-res tessellation)
b12_st37b_z0 = -3.864;  // extent along y
b12_st37b_z1 = -3.844;
b12_st38a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.75886, -20.34993], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [0.98455, -17.06362], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-3.864 (high-res tessellation)
b12_st38a_z0 = -3.864;  // extent along y
b12_st38a_z1 = -3.844;
b12_st38b_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.75886, -20.34993], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-3.464 (high-res tessellation)
b12_st38b_z0 = -3.464;  // extent along y
b12_st38b_z1 = -3.444;
b12_st39a_profile = [[0.5303, -19.48223], [1.17597, -20.15302], [1.82959, -20.40751], [2.75886, -20.34993], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.29781, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-3.464 (high-res tessellation)
b12_st39a_z0 = -3.464;  // extent along y
b12_st39a_z1 = -3.444;
b12_st39b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [1.17597, -16.9273], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-3.064 (high-res tessellation)
b12_st39b_z0 = -3.064;  // extent along y
b12_st39b_z1 = -3.044;
b12_st40a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.18464, -16.9273], [2.53101, -16.6728], [1.82959, -16.6728], [1.17597, -16.9273], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-3.064 (high-res tessellation)
b12_st40a_z0 = -3.064;  // extent along y
b12_st40a_z1 = -3.044;
b12_st40b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-2.664 (high-res tessellation)
b12_st40b_z0 = -2.664;  // extent along y
b12_st40b_z1 = -2.644;
b12_st41a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-2.664 (high-res tessellation)
b12_st41a_z0 = -2.664;  // extent along y
b12_st41a_z1 = -2.644;
b12_st41b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-2.264 (high-res tessellation)
b12_st41b_z0 = -2.264;  // extent along y
b12_st41b_z1 = -2.244;
b12_st42a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-2.264 (high-res tessellation)
b12_st42a_z0 = -2.264;  // extent along y
b12_st42a_z1 = -2.244;
b12_st42b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-1.864 (high-res tessellation)
b12_st42b_z0 = -1.864;  // extent along y
b12_st42b_z1 = -1.844;
b12_st43a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-1.864 (high-res tessellation)
b12_st43a_z0 = -1.864;  // extent along y
b12_st43a_z1 = -1.844;
b12_st43b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-1.464 (high-res tessellation)
b12_st43b_z0 = -1.464;  // extent along y
b12_st43b_z1 = -1.444;
b12_st44a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-1.464 (high-res tessellation)
b12_st44a_z0 = -1.464;  // extent along y
b12_st44a_z1 = -1.444;
b12_st44b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-1.064 (high-res tessellation)
b12_st44b_z0 = -1.064;  // extent along y
b12_st44b_z1 = -1.044;
b12_st45a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-1.064 (high-res tessellation)
b12_st45a_z0 = -1.064;  // extent along y
b12_st45a_z1 = -1.044;
b12_st45b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-0.664 (high-res tessellation)
b12_st45b_z0 = -0.664;  // extent along y
b12_st45b_z1 = -0.644;
b12_st46a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-0.664 (high-res tessellation)
b12_st46a_z0 = -0.664;  // extent along y
b12_st46a_z1 = -0.644;
b12_st46b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-0.264 (high-res tessellation)
b12_st46b_z0 = -0.264;  // extent along y
b12_st46b_z1 = -0.244;
b12_st47a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=-0.264 (high-res tessellation)
b12_st47a_z0 = -0.264;  // extent along y
b12_st47a_z1 = -0.244;
b12_st47b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=0.136 (high-res tessellation)
b12_st47b_z0 = 0.136;  // extent along y
b12_st47b_z1 = 0.156;
b12_st48a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=0.136 (high-res tessellation)
b12_st48a_z0 = 0.136;  // extent along y
b12_st48a_z1 = 0.156;
b12_st48b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=0.536 (high-res tessellation)
b12_st48b_z0 = 0.536;  // extent along y
b12_st48b_z1 = 0.556;
b12_st49a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=0.536 (high-res tessellation)
b12_st49a_z0 = 0.536;  // extent along y
b12_st49a_z1 = 0.556;
b12_st49b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=0.936 (high-res tessellation)
b12_st49b_z0 = 0.936;  // extent along y
b12_st49b_z1 = 0.956;
b12_st50a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=0.936 (high-res tessellation)
b12_st50a_z0 = 0.936;  // extent along y
b12_st50a_z1 = 0.956;
b12_st50b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=1.336 (high-res tessellation)
b12_st50b_z0 = 1.336;  // extent along y
b12_st50b_z1 = 1.356;
b12_st51a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=1.336 (high-res tessellation)
b12_st51a_z0 = 1.336;  // extent along y
b12_st51a_z1 = 1.356;
b12_st51b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=1.736 (high-res tessellation)
b12_st51b_z0 = 1.736;  // extent along y
b12_st51b_z1 = 1.756;
b12_st52a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=1.736 (high-res tessellation)
b12_st52a_z0 = 1.736;  // extent along y
b12_st52a_z1 = 1.756;
b12_st52b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=2.136 (high-res tessellation)
b12_st52b_z0 = 2.136;  // extent along y
b12_st52b_z1 = 2.156;
b12_st53a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=2.136 (high-res tessellation)
b12_st53a_z0 = 2.136;  // extent along y
b12_st53a_z1 = 2.156;
b12_st53b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=2.536 (high-res tessellation)
b12_st53b_z0 = 2.536;  // extent along y
b12_st53b_z1 = 2.556;
b12_st54a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=2.536 (high-res tessellation)
b12_st54a_z0 = 2.536;  // extent along y
b12_st54a_z1 = 2.556;
b12_st54b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=2.936 (high-res tessellation)
b12_st54b_z0 = 2.936;  // extent along y
b12_st54b_z1 = 2.956;
b12_st55a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=2.936 (high-res tessellation)
b12_st55a_z0 = 2.936;  // extent along y
b12_st55a_z1 = 2.956;
b12_st55b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=3.336 (high-res tessellation)
b12_st55b_z0 = 3.336;  // extent along y
b12_st55b_z1 = 3.356;
b12_st56a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=3.336 (high-res tessellation)
b12_st56a_z0 = 3.336;  // extent along y
b12_st56a_z1 = 3.356;
b12_st56b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=3.736 (high-res tessellation)
b12_st56b_z0 = 3.736;  // extent along y
b12_st56b_z1 = 3.756;
b12_st57a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=3.736 (high-res tessellation)
b12_st57a_z0 = 3.736;  // extent along y
b12_st57a_z1 = 3.756;
b12_st57b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=4.136 (high-res tessellation)
b12_st57b_z0 = 4.136;  // extent along y
b12_st57b_z1 = 4.156;
b12_st58a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=4.136 (high-res tessellation)
b12_st58a_z0 = 4.136;  // extent along y
b12_st58a_z1 = 4.156;
b12_st58b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=4.536 (high-res tessellation)
b12_st58b_z0 = 4.536;  // extent along y
b12_st58b_z1 = 4.556;
b12_st59a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=4.536 (high-res tessellation)
b12_st59a_z0 = 4.536;  // extent along y
b12_st59a_z1 = 4.556;
b12_st59b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=4.936 (high-res tessellation)
b12_st59b_z0 = 4.936;  // extent along y
b12_st59b_z1 = 4.956;
b12_st60a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=4.936 (high-res tessellation)
b12_st60a_z0 = 4.936;  // extent along y
b12_st60a_z1 = 4.956;
b12_st60b_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=5.336 (high-res tessellation)
b12_st60b_z0 = 5.336;  // extent along y
b12_st60b_z1 = 5.356;
b12_st61a_profile = [[0.5303, -19.48223], [0.98455, -20.01669], [1.60175, -20.34993], [2.29781, -20.43652], [2.97785, -20.26466], [3.54919, -19.85778], [3.8303, -19.48223], [3.8303, -17.59808], [3.37606, -17.06362], [2.75886, -16.73038], [2.0628, -16.64379], [1.38276, -16.81565], [0.81141, -17.22253], [0.5303, -17.59808]];  // (z, x) points — measured section convex hull at y=5.336 (high-res tessellation)
b12_st61a_z0 = 5.336;  // extent along y
b12_st61a_z1 = 5.356;
b12_st61b_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=5.736 (high-res tessellation)
b12_st61b_z0 = 5.736;  // extent along y
b12_st61b_z1 = 5.756;
b12_st62a_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=5.736 (high-res tessellation)
b12_st62a_z0 = 5.736;  // extent along y
b12_st62a_z1 = 5.756;
b12_st62b_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=6.136 (high-res tessellation)
b12_st62b_z0 = 6.136;  // extent along y
b12_st62b_z1 = 6.156;
b12_st63a_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=6.136 (high-res tessellation)
b12_st63a_z0 = 6.136;  // extent along y
b12_st63a_z1 = 6.156;
b12_st63b_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=6.536 (high-res tessellation)
b12_st63b_z0 = 6.536;  // extent along y
b12_st63b_z1 = 6.556;
b12_st64a_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=6.536 (high-res tessellation)
b12_st64a_z0 = 6.536;  // extent along y
b12_st64a_z1 = 6.556;
b12_st64b_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=6.936 (high-res tessellation)
b12_st64b_z0 = 6.936;  // extent along y
b12_st64b_z1 = 6.956;
b12_st65a_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=6.936 (high-res tessellation)
b12_st65a_z0 = 6.936;  // extent along y
b12_st65a_z1 = 6.956;
b12_st65b_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=7.336 (high-res tessellation)
b12_st65b_z0 = 7.336;  // extent along y
b12_st65b_z1 = 7.356;
b12_st66a_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=7.336 (high-res tessellation)
b12_st66a_z0 = 7.336;  // extent along y
b12_st66a_z1 = 7.356;
b12_st66b_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=7.736 (high-res tessellation)
b12_st66b_z0 = 7.736;  // extent along y
b12_st66b_z1 = 7.756;
b12_st67a_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=7.736 (high-res tessellation)
b12_st67a_z0 = 7.736;  // extent along y
b12_st67a_z1 = 7.756;
b12_st67b_profile = [[0.5303, -21.29016], [3.8303, -21.29016], [3.8303, -15.79016], [0.5303, -15.79016]];  // (z, x) points — measured section convex hull at y=8.026 (high-res tessellation)
b12_st67b_z0 = 8.026;  // extent along y
b12_st67b_z1 = 8.046;
b12_pocket0_profile = [[-21.305154, 5.586174], [-20.421519, 5.586393], [-20.421519, -17.713607], [-20.925155, -17.728607], [-20.940046, -18.428607]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b12_pocket0_z0 = 0.030304;  // extent along z
b12_pocket0_z1 = 4.330304;
b12_pocket1_profile = [[-16.125157, -18.413826], [-16.155155, -18.413607], [-16.155155, -17.728607], [-16.658792, -17.713607], [-16.643792, 5.601393], [-15.775157, 5.586174]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b12_pocket1_z0 = 0.030304;  // extent along z
b12_pocket1_z1 = 4.330304;
b12_pocket2_profile = [[-19.095155, -18.928607], [-19.109867, -11.710681], [-17.982229, -11.698895], [-17.970444, -18.916533]];  // (x, y) points — plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
b12_pocket2_z0 = 0.030304;  // extent along z
b12_pocket2_z1 = 4.330304;
b12_fn = 96;  // curve resolution

module body_12() {
    difference() {
        union() {
            hull() {
                // st00a: measured section convex hull at y=-18.854 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st00a_z0]) linear_extrude(b12_st00a_z1 - b12_st00a_z0) polygon(b12_st00a_profile);
                // st00b: measured section convex hull at y=-18.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st00b_z0]) linear_extrude(b12_st00b_z1 - b12_st00b_z0) polygon(b12_st00b_profile);
            }
            hull() {
                // st01a: measured section convex hull at y=-18.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st01a_z0]) linear_extrude(b12_st01a_z1 - b12_st01a_z0) polygon(b12_st01a_profile);
                // st01b: measured section convex hull at y=-18.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st01b_z0]) linear_extrude(b12_st01b_z1 - b12_st01b_z0) polygon(b12_st01b_profile);
            }
            hull() {
                // st02a: measured section convex hull at y=-18.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st02a_z0]) linear_extrude(b12_st02a_z1 - b12_st02a_z0) polygon(b12_st02a_profile);
                // st02b: measured section convex hull at y=-17.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st02b_z0]) linear_extrude(b12_st02b_z1 - b12_st02b_z0) polygon(b12_st02b_profile);
            }
            hull() {
                // st03a: measured section convex hull at y=-17.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st03a_z0]) linear_extrude(b12_st03a_z1 - b12_st03a_z0) polygon(b12_st03a_profile);
                // st03b: measured section convex hull at y=-17.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st03b_z0]) linear_extrude(b12_st03b_z1 - b12_st03b_z0) polygon(b12_st03b_profile);
            }
            hull() {
                // st04a: measured section convex hull at y=-17.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st04a_z0]) linear_extrude(b12_st04a_z1 - b12_st04a_z0) polygon(b12_st04a_profile);
                // st04b: measured section convex hull at y=-17.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st04b_z0]) linear_extrude(b12_st04b_z1 - b12_st04b_z0) polygon(b12_st04b_profile);
            }
            hull() {
                // st05a: measured section convex hull at y=-17.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st05a_z0]) linear_extrude(b12_st05a_z1 - b12_st05a_z0) polygon(b12_st05a_profile);
                // st05b: measured section convex hull at y=-16.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st05b_z0]) linear_extrude(b12_st05b_z1 - b12_st05b_z0) polygon(b12_st05b_profile);
            }
            hull() {
                // st06a: measured section convex hull at y=-16.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st06a_z0]) linear_extrude(b12_st06a_z1 - b12_st06a_z0) polygon(b12_st06a_profile);
                // st06b: measured section convex hull at y=-16.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st06b_z0]) linear_extrude(b12_st06b_z1 - b12_st06b_z0) polygon(b12_st06b_profile);
            }
            hull() {
                // st07a: measured section convex hull at y=-16.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st07a_z0]) linear_extrude(b12_st07a_z1 - b12_st07a_z0) polygon(b12_st07a_profile);
                // st07b: measured section convex hull at y=-15.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st07b_z0]) linear_extrude(b12_st07b_z1 - b12_st07b_z0) polygon(b12_st07b_profile);
            }
            hull() {
                // st08a: measured section convex hull at y=-15.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st08a_z0]) linear_extrude(b12_st08a_z1 - b12_st08a_z0) polygon(b12_st08a_profile);
                // st08b: measured section convex hull at y=-15.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st08b_z0]) linear_extrude(b12_st08b_z1 - b12_st08b_z0) polygon(b12_st08b_profile);
            }
            hull() {
                // st09a: measured section convex hull at y=-15.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st09a_z0]) linear_extrude(b12_st09a_z1 - b12_st09a_z0) polygon(b12_st09a_profile);
                // st09b: measured section convex hull at y=-15.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st09b_z0]) linear_extrude(b12_st09b_z1 - b12_st09b_z0) polygon(b12_st09b_profile);
            }
            hull() {
                // st10a: measured section convex hull at y=-15.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st10a_z0]) linear_extrude(b12_st10a_z1 - b12_st10a_z0) polygon(b12_st10a_profile);
                // st10b: measured section convex hull at y=-14.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st10b_z0]) linear_extrude(b12_st10b_z1 - b12_st10b_z0) polygon(b12_st10b_profile);
            }
            hull() {
                // st11a: measured section convex hull at y=-14.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st11a_z0]) linear_extrude(b12_st11a_z1 - b12_st11a_z0) polygon(b12_st11a_profile);
                // st11b: measured section convex hull at y=-14.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st11b_z0]) linear_extrude(b12_st11b_z1 - b12_st11b_z0) polygon(b12_st11b_profile);
            }
            hull() {
                // st12a: measured section convex hull at y=-14.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st12a_z0]) linear_extrude(b12_st12a_z1 - b12_st12a_z0) polygon(b12_st12a_profile);
                // st12b: measured section convex hull at y=-13.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st12b_z0]) linear_extrude(b12_st12b_z1 - b12_st12b_z0) polygon(b12_st12b_profile);
            }
            hull() {
                // st13a: measured section convex hull at y=-13.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st13a_z0]) linear_extrude(b12_st13a_z1 - b12_st13a_z0) polygon(b12_st13a_profile);
                // st13b: measured section convex hull at y=-13.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st13b_z0]) linear_extrude(b12_st13b_z1 - b12_st13b_z0) polygon(b12_st13b_profile);
            }
            hull() {
                // st14a: measured section convex hull at y=-13.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st14a_z0]) linear_extrude(b12_st14a_z1 - b12_st14a_z0) polygon(b12_st14a_profile);
                // st14b: measured section convex hull at y=-13.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st14b_z0]) linear_extrude(b12_st14b_z1 - b12_st14b_z0) polygon(b12_st14b_profile);
            }
            hull() {
                // st15a: measured section convex hull at y=-13.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st15a_z0]) linear_extrude(b12_st15a_z1 - b12_st15a_z0) polygon(b12_st15a_profile);
                // st15b: measured section convex hull at y=-12.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st15b_z0]) linear_extrude(b12_st15b_z1 - b12_st15b_z0) polygon(b12_st15b_profile);
            }
            hull() {
                // st16a: measured section convex hull at y=-12.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st16a_z0]) linear_extrude(b12_st16a_z1 - b12_st16a_z0) polygon(b12_st16a_profile);
                // st16b: measured section convex hull at y=-12.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st16b_z0]) linear_extrude(b12_st16b_z1 - b12_st16b_z0) polygon(b12_st16b_profile);
            }
            hull() {
                // st17a: measured section convex hull at y=-12.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st17a_z0]) linear_extrude(b12_st17a_z1 - b12_st17a_z0) polygon(b12_st17a_profile);
                // st17b: measured section convex hull at y=-11.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st17b_z0]) linear_extrude(b12_st17b_z1 - b12_st17b_z0) polygon(b12_st17b_profile);
            }
            hull() {
                // st18a: measured section convex hull at y=-11.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st18a_z0]) linear_extrude(b12_st18a_z1 - b12_st18a_z0) polygon(b12_st18a_profile);
                // st18b: measured section convex hull at y=-11.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st18b_z0]) linear_extrude(b12_st18b_z1 - b12_st18b_z0) polygon(b12_st18b_profile);
            }
            hull() {
                // st19a: measured section convex hull at y=-11.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st19a_z0]) linear_extrude(b12_st19a_z1 - b12_st19a_z0) polygon(b12_st19a_profile);
                // st19b: measured section convex hull at y=-11.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st19b_z0]) linear_extrude(b12_st19b_z1 - b12_st19b_z0) polygon(b12_st19b_profile);
            }
            hull() {
                // st20a: measured section convex hull at y=-11.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st20a_z0]) linear_extrude(b12_st20a_z1 - b12_st20a_z0) polygon(b12_st20a_profile);
                // st20b: measured section convex hull at y=-10.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st20b_z0]) linear_extrude(b12_st20b_z1 - b12_st20b_z0) polygon(b12_st20b_profile);
            }
            hull() {
                // st21a: measured section convex hull at y=-10.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st21a_z0]) linear_extrude(b12_st21a_z1 - b12_st21a_z0) polygon(b12_st21a_profile);
                // st21b: measured section convex hull at y=-10.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st21b_z0]) linear_extrude(b12_st21b_z1 - b12_st21b_z0) polygon(b12_st21b_profile);
            }
            hull() {
                // st22a: measured section convex hull at y=-10.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st22a_z0]) linear_extrude(b12_st22a_z1 - b12_st22a_z0) polygon(b12_st22a_profile);
                // st22b: measured section convex hull at y=-9.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st22b_z0]) linear_extrude(b12_st22b_z1 - b12_st22b_z0) polygon(b12_st22b_profile);
            }
            hull() {
                // st23a: measured section convex hull at y=-9.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st23a_z0]) linear_extrude(b12_st23a_z1 - b12_st23a_z0) polygon(b12_st23a_profile);
                // st23b: measured section convex hull at y=-9.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st23b_z0]) linear_extrude(b12_st23b_z1 - b12_st23b_z0) polygon(b12_st23b_profile);
            }
            hull() {
                // st24a: measured section convex hull at y=-9.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st24a_z0]) linear_extrude(b12_st24a_z1 - b12_st24a_z0) polygon(b12_st24a_profile);
                // st24b: measured section convex hull at y=-9.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st24b_z0]) linear_extrude(b12_st24b_z1 - b12_st24b_z0) polygon(b12_st24b_profile);
            }
            hull() {
                // st25a: measured section convex hull at y=-9.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st25a_z0]) linear_extrude(b12_st25a_z1 - b12_st25a_z0) polygon(b12_st25a_profile);
                // st25b: measured section convex hull at y=-8.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st25b_z0]) linear_extrude(b12_st25b_z1 - b12_st25b_z0) polygon(b12_st25b_profile);
            }
            hull() {
                // st26a: measured section convex hull at y=-8.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st26a_z0]) linear_extrude(b12_st26a_z1 - b12_st26a_z0) polygon(b12_st26a_profile);
                // st26b: measured section convex hull at y=-8.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st26b_z0]) linear_extrude(b12_st26b_z1 - b12_st26b_z0) polygon(b12_st26b_profile);
            }
            hull() {
                // st27a: measured section convex hull at y=-8.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st27a_z0]) linear_extrude(b12_st27a_z1 - b12_st27a_z0) polygon(b12_st27a_profile);
                // st27b: measured section convex hull at y=-7.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st27b_z0]) linear_extrude(b12_st27b_z1 - b12_st27b_z0) polygon(b12_st27b_profile);
            }
            hull() {
                // st28a: measured section convex hull at y=-7.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st28a_z0]) linear_extrude(b12_st28a_z1 - b12_st28a_z0) polygon(b12_st28a_profile);
                // st28b: measured section convex hull at y=-7.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st28b_z0]) linear_extrude(b12_st28b_z1 - b12_st28b_z0) polygon(b12_st28b_profile);
            }
            hull() {
                // st29a: measured section convex hull at y=-7.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st29a_z0]) linear_extrude(b12_st29a_z1 - b12_st29a_z0) polygon(b12_st29a_profile);
                // st29b: measured section convex hull at y=-7.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st29b_z0]) linear_extrude(b12_st29b_z1 - b12_st29b_z0) polygon(b12_st29b_profile);
            }
            hull() {
                // st30a: measured section convex hull at y=-7.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st30a_z0]) linear_extrude(b12_st30a_z1 - b12_st30a_z0) polygon(b12_st30a_profile);
                // st30b: measured section convex hull at y=-6.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st30b_z0]) linear_extrude(b12_st30b_z1 - b12_st30b_z0) polygon(b12_st30b_profile);
            }
            hull() {
                // st31a: measured section convex hull at y=-6.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st31a_z0]) linear_extrude(b12_st31a_z1 - b12_st31a_z0) polygon(b12_st31a_profile);
                // st31b: measured section convex hull at y=-6.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st31b_z0]) linear_extrude(b12_st31b_z1 - b12_st31b_z0) polygon(b12_st31b_profile);
            }
            hull() {
                // st32a: measured section convex hull at y=-6.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st32a_z0]) linear_extrude(b12_st32a_z1 - b12_st32a_z0) polygon(b12_st32a_profile);
                // st32b: measured section convex hull at y=-5.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st32b_z0]) linear_extrude(b12_st32b_z1 - b12_st32b_z0) polygon(b12_st32b_profile);
            }
            hull() {
                // st33a: measured section convex hull at y=-5.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st33a_z0]) linear_extrude(b12_st33a_z1 - b12_st33a_z0) polygon(b12_st33a_profile);
                // st33b: measured section convex hull at y=-5.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st33b_z0]) linear_extrude(b12_st33b_z1 - b12_st33b_z0) polygon(b12_st33b_profile);
            }
            hull() {
                // st34a: measured section convex hull at y=-5.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st34a_z0]) linear_extrude(b12_st34a_z1 - b12_st34a_z0) polygon(b12_st34a_profile);
                // st34b: measured section convex hull at y=-5.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st34b_z0]) linear_extrude(b12_st34b_z1 - b12_st34b_z0) polygon(b12_st34b_profile);
            }
            hull() {
                // st35a: measured section convex hull at y=-5.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st35a_z0]) linear_extrude(b12_st35a_z1 - b12_st35a_z0) polygon(b12_st35a_profile);
                // st35b: measured section convex hull at y=-4.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st35b_z0]) linear_extrude(b12_st35b_z1 - b12_st35b_z0) polygon(b12_st35b_profile);
            }
            hull() {
                // st36a: measured section convex hull at y=-4.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st36a_z0]) linear_extrude(b12_st36a_z1 - b12_st36a_z0) polygon(b12_st36a_profile);
                // st36b: measured section convex hull at y=-4.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st36b_z0]) linear_extrude(b12_st36b_z1 - b12_st36b_z0) polygon(b12_st36b_profile);
            }
            hull() {
                // st37a: measured section convex hull at y=-4.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st37a_z0]) linear_extrude(b12_st37a_z1 - b12_st37a_z0) polygon(b12_st37a_profile);
                // st37b: measured section convex hull at y=-3.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st37b_z0]) linear_extrude(b12_st37b_z1 - b12_st37b_z0) polygon(b12_st37b_profile);
            }
            hull() {
                // st38a: measured section convex hull at y=-3.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st38a_z0]) linear_extrude(b12_st38a_z1 - b12_st38a_z0) polygon(b12_st38a_profile);
                // st38b: measured section convex hull at y=-3.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st38b_z0]) linear_extrude(b12_st38b_z1 - b12_st38b_z0) polygon(b12_st38b_profile);
            }
            hull() {
                // st39a: measured section convex hull at y=-3.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st39a_z0]) linear_extrude(b12_st39a_z1 - b12_st39a_z0) polygon(b12_st39a_profile);
                // st39b: measured section convex hull at y=-3.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st39b_z0]) linear_extrude(b12_st39b_z1 - b12_st39b_z0) polygon(b12_st39b_profile);
            }
            hull() {
                // st40a: measured section convex hull at y=-3.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st40a_z0]) linear_extrude(b12_st40a_z1 - b12_st40a_z0) polygon(b12_st40a_profile);
                // st40b: measured section convex hull at y=-2.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st40b_z0]) linear_extrude(b12_st40b_z1 - b12_st40b_z0) polygon(b12_st40b_profile);
            }
            hull() {
                // st41a: measured section convex hull at y=-2.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st41a_z0]) linear_extrude(b12_st41a_z1 - b12_st41a_z0) polygon(b12_st41a_profile);
                // st41b: measured section convex hull at y=-2.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st41b_z0]) linear_extrude(b12_st41b_z1 - b12_st41b_z0) polygon(b12_st41b_profile);
            }
            hull() {
                // st42a: measured section convex hull at y=-2.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st42a_z0]) linear_extrude(b12_st42a_z1 - b12_st42a_z0) polygon(b12_st42a_profile);
                // st42b: measured section convex hull at y=-1.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st42b_z0]) linear_extrude(b12_st42b_z1 - b12_st42b_z0) polygon(b12_st42b_profile);
            }
            hull() {
                // st43a: measured section convex hull at y=-1.864 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st43a_z0]) linear_extrude(b12_st43a_z1 - b12_st43a_z0) polygon(b12_st43a_profile);
                // st43b: measured section convex hull at y=-1.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st43b_z0]) linear_extrude(b12_st43b_z1 - b12_st43b_z0) polygon(b12_st43b_profile);
            }
            hull() {
                // st44a: measured section convex hull at y=-1.464 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st44a_z0]) linear_extrude(b12_st44a_z1 - b12_st44a_z0) polygon(b12_st44a_profile);
                // st44b: measured section convex hull at y=-1.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st44b_z0]) linear_extrude(b12_st44b_z1 - b12_st44b_z0) polygon(b12_st44b_profile);
            }
            hull() {
                // st45a: measured section convex hull at y=-1.064 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st45a_z0]) linear_extrude(b12_st45a_z1 - b12_st45a_z0) polygon(b12_st45a_profile);
                // st45b: measured section convex hull at y=-0.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st45b_z0]) linear_extrude(b12_st45b_z1 - b12_st45b_z0) polygon(b12_st45b_profile);
            }
            hull() {
                // st46a: measured section convex hull at y=-0.664 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st46a_z0]) linear_extrude(b12_st46a_z1 - b12_st46a_z0) polygon(b12_st46a_profile);
                // st46b: measured section convex hull at y=-0.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st46b_z0]) linear_extrude(b12_st46b_z1 - b12_st46b_z0) polygon(b12_st46b_profile);
            }
            hull() {
                // st47a: measured section convex hull at y=-0.264 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st47a_z0]) linear_extrude(b12_st47a_z1 - b12_st47a_z0) polygon(b12_st47a_profile);
                // st47b: measured section convex hull at y=0.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st47b_z0]) linear_extrude(b12_st47b_z1 - b12_st47b_z0) polygon(b12_st47b_profile);
            }
            hull() {
                // st48a: measured section convex hull at y=0.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st48a_z0]) linear_extrude(b12_st48a_z1 - b12_st48a_z0) polygon(b12_st48a_profile);
                // st48b: measured section convex hull at y=0.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st48b_z0]) linear_extrude(b12_st48b_z1 - b12_st48b_z0) polygon(b12_st48b_profile);
            }
            hull() {
                // st49a: measured section convex hull at y=0.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st49a_z0]) linear_extrude(b12_st49a_z1 - b12_st49a_z0) polygon(b12_st49a_profile);
                // st49b: measured section convex hull at y=0.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st49b_z0]) linear_extrude(b12_st49b_z1 - b12_st49b_z0) polygon(b12_st49b_profile);
            }
            hull() {
                // st50a: measured section convex hull at y=0.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st50a_z0]) linear_extrude(b12_st50a_z1 - b12_st50a_z0) polygon(b12_st50a_profile);
                // st50b: measured section convex hull at y=1.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st50b_z0]) linear_extrude(b12_st50b_z1 - b12_st50b_z0) polygon(b12_st50b_profile);
            }
            hull() {
                // st51a: measured section convex hull at y=1.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st51a_z0]) linear_extrude(b12_st51a_z1 - b12_st51a_z0) polygon(b12_st51a_profile);
                // st51b: measured section convex hull at y=1.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st51b_z0]) linear_extrude(b12_st51b_z1 - b12_st51b_z0) polygon(b12_st51b_profile);
            }
            hull() {
                // st52a: measured section convex hull at y=1.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st52a_z0]) linear_extrude(b12_st52a_z1 - b12_st52a_z0) polygon(b12_st52a_profile);
                // st52b: measured section convex hull at y=2.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st52b_z0]) linear_extrude(b12_st52b_z1 - b12_st52b_z0) polygon(b12_st52b_profile);
            }
            hull() {
                // st53a: measured section convex hull at y=2.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st53a_z0]) linear_extrude(b12_st53a_z1 - b12_st53a_z0) polygon(b12_st53a_profile);
                // st53b: measured section convex hull at y=2.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st53b_z0]) linear_extrude(b12_st53b_z1 - b12_st53b_z0) polygon(b12_st53b_profile);
            }
            hull() {
                // st54a: measured section convex hull at y=2.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st54a_z0]) linear_extrude(b12_st54a_z1 - b12_st54a_z0) polygon(b12_st54a_profile);
                // st54b: measured section convex hull at y=2.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st54b_z0]) linear_extrude(b12_st54b_z1 - b12_st54b_z0) polygon(b12_st54b_profile);
            }
            hull() {
                // st55a: measured section convex hull at y=2.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st55a_z0]) linear_extrude(b12_st55a_z1 - b12_st55a_z0) polygon(b12_st55a_profile);
                // st55b: measured section convex hull at y=3.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st55b_z0]) linear_extrude(b12_st55b_z1 - b12_st55b_z0) polygon(b12_st55b_profile);
            }
            hull() {
                // st56a: measured section convex hull at y=3.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st56a_z0]) linear_extrude(b12_st56a_z1 - b12_st56a_z0) polygon(b12_st56a_profile);
                // st56b: measured section convex hull at y=3.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st56b_z0]) linear_extrude(b12_st56b_z1 - b12_st56b_z0) polygon(b12_st56b_profile);
            }
            hull() {
                // st57a: measured section convex hull at y=3.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st57a_z0]) linear_extrude(b12_st57a_z1 - b12_st57a_z0) polygon(b12_st57a_profile);
                // st57b: measured section convex hull at y=4.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st57b_z0]) linear_extrude(b12_st57b_z1 - b12_st57b_z0) polygon(b12_st57b_profile);
            }
            hull() {
                // st58a: measured section convex hull at y=4.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st58a_z0]) linear_extrude(b12_st58a_z1 - b12_st58a_z0) polygon(b12_st58a_profile);
                // st58b: measured section convex hull at y=4.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st58b_z0]) linear_extrude(b12_st58b_z1 - b12_st58b_z0) polygon(b12_st58b_profile);
            }
            hull() {
                // st59a: measured section convex hull at y=4.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st59a_z0]) linear_extrude(b12_st59a_z1 - b12_st59a_z0) polygon(b12_st59a_profile);
                // st59b: measured section convex hull at y=4.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st59b_z0]) linear_extrude(b12_st59b_z1 - b12_st59b_z0) polygon(b12_st59b_profile);
            }
            hull() {
                // st60a: measured section convex hull at y=4.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st60a_z0]) linear_extrude(b12_st60a_z1 - b12_st60a_z0) polygon(b12_st60a_profile);
                // st60b: measured section convex hull at y=5.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st60b_z0]) linear_extrude(b12_st60b_z1 - b12_st60b_z0) polygon(b12_st60b_profile);
            }
            hull() {
                // st61a: measured section convex hull at y=5.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st61a_z0]) linear_extrude(b12_st61a_z1 - b12_st61a_z0) polygon(b12_st61a_profile);
                // st61b: measured section convex hull at y=5.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st61b_z0]) linear_extrude(b12_st61b_z1 - b12_st61b_z0) polygon(b12_st61b_profile);
            }
            hull() {
                // st62a: measured section convex hull at y=5.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st62a_z0]) linear_extrude(b12_st62a_z1 - b12_st62a_z0) polygon(b12_st62a_profile);
                // st62b: measured section convex hull at y=6.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st62b_z0]) linear_extrude(b12_st62b_z1 - b12_st62b_z0) polygon(b12_st62b_profile);
            }
            hull() {
                // st63a: measured section convex hull at y=6.136 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st63a_z0]) linear_extrude(b12_st63a_z1 - b12_st63a_z0) polygon(b12_st63a_profile);
                // st63b: measured section convex hull at y=6.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st63b_z0]) linear_extrude(b12_st63b_z1 - b12_st63b_z0) polygon(b12_st63b_profile);
            }
            hull() {
                // st64a: measured section convex hull at y=6.536 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st64a_z0]) linear_extrude(b12_st64a_z1 - b12_st64a_z0) polygon(b12_st64a_profile);
                // st64b: measured section convex hull at y=6.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st64b_z0]) linear_extrude(b12_st64b_z1 - b12_st64b_z0) polygon(b12_st64b_profile);
            }
            hull() {
                // st65a: measured section convex hull at y=6.936 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st65a_z0]) linear_extrude(b12_st65a_z1 - b12_st65a_z0) polygon(b12_st65a_profile);
                // st65b: measured section convex hull at y=7.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st65b_z0]) linear_extrude(b12_st65b_z1 - b12_st65b_z0) polygon(b12_st65b_profile);
            }
            hull() {
                // st66a: measured section convex hull at y=7.336 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st66a_z0]) linear_extrude(b12_st66a_z1 - b12_st66a_z0) polygon(b12_st66a_profile);
                // st66b: measured section convex hull at y=7.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st66b_z0]) linear_extrude(b12_st66b_z1 - b12_st66b_z0) polygon(b12_st66b_profile);
            }
            hull() {
                // st67a: measured section convex hull at y=7.736 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st67a_z0]) linear_extrude(b12_st67a_z1 - b12_st67a_z0) polygon(b12_st67a_profile);
                // st67b: measured section convex hull at y=8.026 (high-res tessellation)
                rotate([0, -90, -90]) translate([0, 0, b12_st67b_z0]) linear_extrude(b12_st67b_z1 - b12_st67b_z0) polygon(b12_st67b_profile);
            }
        }
        // pocket0: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b12_pocket0_z0]) linear_extrude(b12_pocket0_z1 - b12_pocket0_z0) polygon(b12_pocket0_profile);
        // pocket1: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b12_pocket1_z0]) linear_extrude(b12_pocket1_z1 - b12_pocket1_z0) polygon(b12_pocket1_profile);
        // pocket2: plan-view concavity (silhouette hull minus measured outline at z=2.180304): fork slot / barb notch, vertical walls
        translate([0, 0, b12_pocket2_z0]) linear_extrude(b12_pocket2_z1 - b12_pocket2_z0) polygon(b12_pocket2_profile);
    }
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
