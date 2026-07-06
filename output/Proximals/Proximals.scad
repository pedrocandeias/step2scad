// Proximals — step2scad parametric reconstruction
// source: models/phoenix_components/Proximals.step
// rotate_extrude bodies: exact RZ profile from the B-rep coaxial faces;
// csg / instance_of bodies: agent-authored measured plan (plan.json);
// strategies without a real emitter yet use placeholder stubs (bbox).
// Every dimension below is an exact B-rep value from features.json.

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

// ---- body 2 (strategy: csg — semantic parametric plan) ----
// plan: semantic laws: beam = exact wall window × envelope laws (top res 0.090, bottom res 0.092; knuckle lobes are r6 arcs concentric with the exact pin bores); ridge stem/cap = window × fitted laws; crown kept as measured loft (no clean law); recess/web profiles vectorized

// ======== PARAMETERS (every value measured; see source comments) ========
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
b2_fn               = 96;  // curve resolution

b2_crown_cr00a_profile = [[0.00873, -30.00011], [0.00873, -24.80011], [12.5277, -19.68475], [13.67096, -20.3074], [14.44365, -21.28328], [16.22675, -26.07933], [16.23331, -28.72132], [14.31903, -33.56473], [13.26455, -34.75388], [12.51068, -35.14596]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.372351 (full-width crown)
b2_crown_cr00b_profile = [[0.00873, -30.00011], [0.00873, -24.80011], [12.22, -19.6318], [14.00921, -20.70515], [14.69314, -21.93249], [16.11759, -26.07924], [16.12415, -28.72177], [14.13005, -33.79898], [12.49329, -35.12644], [12.26927, -35.1974]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.072351 (full-width crown)
b2_crown_cr01a_profile = [[0.00873, -30.00011], [0.00873, -24.80011], [12.22, -19.6318], [14.00921, -20.70515], [14.69314, -21.93249], [16.11759, -26.07924], [16.12415, -28.72177], [14.13005, -33.79898], [12.49329, -35.12644], [12.26927, -35.1974]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.072351 (full-width crown)
b2_crown_cr01b_profile = [[11.94803, -35.25842], [0.00873, -30.00011], [0.00873, -24.80011], [11.94712, -19.58774], [13.20581, -20.06869], [13.98036, -20.74678], [14.66284, -21.98386], [16.00843, -26.07914], [16.01499, -28.72222], [13.9347, -33.99136], [12.71251, -34.99388]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.772351 (full-width crown)
b2_crown_cr02a_profile = [[11.94803, -35.25842], [0.00873, -30.00011], [0.00873, -24.80011], [11.94712, -19.58774], [13.20581, -20.06869], [13.98036, -20.74678], [14.66284, -21.98386], [16.00843, -26.07914], [16.01499, -28.72222], [13.9347, -33.99136], [12.71251, -34.99388]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.772351 (full-width crown)
b2_crown_cr02b_profile = [[11.64649, -35.30793], [0.00873, -30.00011], [0.00873, -24.80011], [11.64666, -19.54136], [12.74241, -19.87632], [14.08334, -20.9534], [14.69049, -22.20697], [15.89927, -26.07905], [15.90583, -28.72267], [14.10175, -33.66765], [13.15428, -34.68543]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.472351 (full-width crown)
b2_crown_cr03a_profile = [[11.64649, -35.30793], [0.00873, -30.00011], [0.00873, -24.80011], [11.64666, -19.54136], [12.74241, -19.87632], [14.08334, -20.9534], [14.69049, -22.20697], [15.89927, -26.07905], [15.90583, -28.72267], [14.10175, -33.66765], [13.15428, -34.68543]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.472351 (full-width crown)
b2_crown_cr03b_profile = [[11.31223, -35.35539], [0.00873, -30.00011], [0.00873, -24.80011], [11.45461, -19.51286], [13.12445, -20.11904], [13.77899, -20.65294], [14.68322, -22.32441], [15.79011, -26.07895], [15.79667, -28.72311], [14.26096, -33.2955], [12.67895, -34.92384]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.172351 (full-width crown)
b2_crown_cr04a_profile = [[11.31223, -35.35539], [0.00873, -30.00011], [0.00873, -24.80011], [11.45461, -19.51286], [13.12445, -20.11904], [13.77899, -20.65294], [14.68322, -22.32441], [15.79011, -26.07895], [15.79667, -28.72311], [14.26096, -33.2955], [12.67895, -34.92384]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.172351 (full-width crown)
b2_crown_cr04b_profile = [[0.00873, -30.00011], [0.00873, -24.80011], [11.09849, -19.47026], [13.54146, -20.48231], [14.4232, -21.7501], [15.68095, -26.07885], [15.68752, -28.72356], [14.20493, -33.30039], [13.22483, -34.52277], [11.85879, -35.21457], [11.01788, -35.3907]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.872351 (full-width crown)
b2_crown_cr05a_profile = [[0.00873, -30.00011], [0.00873, -24.80011], [11.09849, -19.47026], [13.54146, -20.48231], [14.4232, -21.7501], [15.68095, -26.07885], [15.68752, -28.72356], [14.20493, -33.30039], [13.22483, -34.52277], [11.85879, -35.21457], [11.01788, -35.3907]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.872351 (full-width crown)
b2_crown_cr05b_profile = [[9.67279, -35.49245], [0.00873, -30.00011], [0.00873, -24.80011], [9.67407, -19.35821], [12.17218, -19.83521], [13.24854, -20.3947], [14.41626, -22.05227], [14.82946, -23.53047], [15.39015, -26.19658], [15.39613, -28.6065], [14.35, -32.70036], [13.50933, -34.08732], [12.54041, -34.8274], [10.93427, -35.34594]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.072351 (full-width crown)
b2_crown_cr06a_profile = [[9.67279, -35.49245], [0.00873, -30.00011], [0.00873, -24.80011], [9.67407, -19.35821], [12.17218, -19.83521], [13.24854, -20.3947], [14.41626, -22.05227], [14.82946, -23.53047], [15.39015, -26.19658], [15.39613, -28.6065], [14.35, -32.70036], [13.50933, -34.08732], [12.54041, -34.8274], [10.93427, -35.34594]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.072351 (full-width crown)
b2_crown_cr06b_profile = [[7.29083, -35.47194], [0.00873, -30.00011], [0.00873, -24.80011], [7.2772, -19.27689], [11.32771, -19.68517], [13.19229, -20.50168], [14.10082, -21.64399], [14.57647, -22.94281], [14.91713, -24.81217], [14.66724, -31.25061], [13.97022, -33.20296], [13.15326, -34.26706], [11.44795, -35.14452], [8.83775, -35.52001]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.272351 (full-width crown)
b2_crown_cr07a_profile = [[7.29083, -35.47194], [0.00873, -30.00011], [0.00873, -24.80011], [7.2772, -19.27689], [11.32771, -19.68517], [13.19229, -20.50168], [14.10082, -21.64399], [14.57647, -22.94281], [14.91713, -24.81217], [14.66724, -31.25061], [13.97022, -33.20296], [13.15326, -34.26706], [11.44795, -35.14452], [8.83775, -35.52001]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.272351 (full-width crown)
b2_crown_cr07b_profile = [[4.25031, -35.02463], [1.84106, -34.15967], [0.41805, -33.01604], [0.00873, -32.43328], [0.01407, -21.98261], [1.16054, -20.71733], [3.37336, -19.72659], [7.04155, -19.30378], [9.91603, -19.45807], [12.79438, -20.36272], [13.45974, -20.92717], [14.30864, -22.46375], [14.83617, -25.14709], [14.67385, -30.58392], [14.08114, -32.70342], [12.66099, -34.49399], [11.40831, -35.0602], [8.78763, -35.49692]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.472351 (full-width crown)
b2_crown_cr08a_profile = [[4.25031, -35.02463], [1.84106, -34.15967], [0.41805, -33.01604], [0.00873, -32.43328], [0.01407, -21.98261], [1.16054, -20.71733], [3.37336, -19.72659], [7.04155, -19.30378], [9.91603, -19.45807], [12.79438, -20.36272], [13.45974, -20.92717], [14.30864, -22.46375], [14.83617, -25.14709], [14.67385, -30.58392], [14.08114, -32.70342], [12.66099, -34.49399], [11.40831, -35.0602], [8.78763, -35.49692]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.472351 (full-width crown)
b2_crown_cr08b_profile = [[4.05383, -34.94786], [1.70744, -34.05343], [0.12579, -32.59347], [0.00873, -32.40623], [0.00873, -22.02328], [0.95614, -20.90574], [2.09031, -20.20053], [4.97573, -19.46587], [9.55563, -19.45671], [12.61273, -20.38075], [13.72739, -21.49364], [14.36121, -23.03587], [14.73128, -25.22409], [14.4758, -31.05278], [13.733, -33.10512], [12.29292, -34.5848], [8.95858, -35.43443], [8.49704, -35.46278]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.672351 (full-width crown)
b2_crown_cr09a_profile = [[4.05383, -34.94786], [1.70744, -34.05343], [0.12579, -32.59347], [0.00873, -32.40623], [0.00873, -22.02328], [0.95614, -20.90574], [2.09031, -20.20053], [4.97573, -19.46587], [9.55563, -19.45671], [12.61273, -20.38075], [13.72739, -21.49364], [14.36121, -23.03587], [14.73128, -25.22409], [14.4758, -31.05278], [13.733, -33.10512], [12.29292, -34.5848], [8.95858, -35.43443], [8.49704, -35.46278]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.672351 (full-width crown)
b2_crown_cr09b_profile = [[2.88846, -34.56198], [1.03685, -33.55013], [0.00873, -32.36841], [0.03646, -22.01826], [1.11181, -20.82356], [3.88083, -19.67186], [8.50053, -19.41214], [9.96784, -19.62444], [12.20713, -20.2829], [13.19602, -21.00474], [13.83131, -21.9368], [14.61046, -25.06647], [14.46113, -30.46618], [13.35867, -33.44725], [12.12599, -34.54999], [8.26686, -35.41166]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.872351 (full-width crown)
b2_crown_cr10a_profile = [[2.88846, -34.56198], [1.03685, -33.55013], [0.00873, -32.36841], [0.03646, -22.01826], [1.11181, -20.82356], [3.88083, -19.67186], [8.50053, -19.41214], [9.96784, -19.62444], [12.20713, -20.2829], [13.19602, -21.00474], [13.83131, -21.9368], [14.61046, -25.06647], [14.46113, -30.46618], [13.35867, -33.44725], [12.12599, -34.54999], [8.26686, -35.41166]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.872351 (full-width crown)
b2_crown_cr10b_profile = [[4.69443, -34.99298], [2.28107, -34.26592], [0.59971, -33.09505], [0.00873, -32.32257], [0.05776, -22.03492], [1.08381, -20.89527], [2.2933, -20.19765], [4.05066, -19.68664], [7.96741, -19.45378], [9.87861, -19.69431], [12.48993, -20.56736], [13.36903, -21.40224], [14.1177, -23.01527], [14.55019, -26.0826], [14.25917, -30.94916], [13.49087, -33.02742], [12.57969, -34.08906], [11.42771, -34.75838], [9.04081, -35.28003], [8.28988, -35.34096]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.072351 (full-width crown)
b2_crown_cr11a_profile = [[4.69443, -34.99298], [2.28107, -34.26592], [0.59971, -33.09505], [0.00873, -32.32257], [0.05776, -22.03492], [1.08381, -20.89527], [2.2933, -20.19765], [4.05066, -19.68664], [7.96741, -19.45378], [9.87861, -19.69431], [12.48993, -20.56736], [13.36903, -21.40224], [14.1177, -23.01527], [14.55019, -26.0826], [14.25917, -30.94916], [13.49087, -33.02742], [12.57969, -34.08906], [11.42771, -34.75838], [9.04081, -35.28003], [8.28988, -35.34096]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.072351 (full-width crown)
b2_crown_cr11b_profile = [[3.53388, -34.65762], [1.4862, -33.7692], [0.1645, -32.50035], [0.00873, -32.26402], [0.00873, -22.17982], [1.64054, -20.58662], [3.6352, -19.82833], [8.05842, -19.5386], [9.99452, -19.81332], [11.78232, -20.31324], [13.08213, -21.23431], [13.89423, -22.68103], [14.45303, -26.09087], [14.18685, -30.73746], [13.45303, -32.86059], [12.20538, -34.22596], [11.07284, -34.77782], [8.035, -35.2651]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.272351 (full-width crown)
b2_crown_cr12a_profile = [[3.53388, -34.65762], [1.4862, -33.7692], [0.1645, -32.50035], [0.00873, -32.26402], [0.00873, -22.17982], [1.64054, -20.58662], [3.6352, -19.82833], [8.05842, -19.5386], [9.99452, -19.81332], [11.78232, -20.31324], [13.08213, -21.23431], [13.89423, -22.68103], [14.45303, -26.09087], [14.18685, -30.73746], [13.45303, -32.86059], [12.20538, -34.22596], [11.07284, -34.77782], [8.035, -35.2651]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.272351 (full-width crown)
b2_crown_cr12b_profile = [[3.5675, -34.60282], [1.00002, -33.34105], [0.00873, -32.20488], [0.00873, -22.24489], [1.27315, -20.88797], [2.48104, -20.24461], [4.38689, -19.75929], [7.57174, -19.60225], [11.29982, -20.23485], [12.47869, -20.82914], [13.62753, -22.30263], [14.1884, -24.26839], [14.36245, -26.18587], [14.10022, -30.62484], [13.23769, -32.99263], [11.35827, -34.56894], [7.99311, -35.17387]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.527649 (full-width crown)
b2_crown_cr13a_profile = [[3.5675, -34.60282], [1.00002, -33.34105], [0.00873, -32.20488], [0.00873, -22.24489], [1.27315, -20.88797], [2.48104, -20.24461], [4.38689, -19.75929], [7.57174, -19.60225], [11.29982, -20.23485], [12.47869, -20.82914], [13.62753, -22.30263], [14.1884, -24.26839], [14.36245, -26.18587], [14.10022, -30.62484], [13.23769, -32.99263], [11.35827, -34.56894], [7.99311, -35.17387]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.527649 (full-width crown)
b2_crown_cr13b_profile = [[3.96189, -34.62848], [1.25317, -33.46547], [0.00873, -32.13433], [0.00873, -22.31337], [0.59224, -21.53725], [1.84953, -20.61272], [3.3713, -20.03519], [7.95184, -19.72268], [11.45638, -20.39209], [12.9342, -21.4041], [13.45417, -22.17768], [14.15258, -24.67344], [14.25545, -28.49125], [13.76924, -31.56018], [12.919, -33.24895], [12.17446, -33.97312], [10.78852, -34.6564], [7.73996, -35.07894]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.327649 (full-width crown)
b2_crown_cr14a_profile = [[3.96189, -34.62848], [1.25317, -33.46547], [0.00873, -32.13433], [0.00873, -22.31337], [0.59224, -21.53725], [1.84953, -20.61272], [3.3713, -20.03519], [7.95184, -19.72268], [11.45638, -20.39209], [12.9342, -21.4041], [13.45417, -22.17768], [14.15258, -24.67344], [14.25545, -28.49125], [13.76924, -31.56018], [12.919, -33.24895], [12.17446, -33.97312], [10.78852, -34.6564], [7.73996, -35.07894]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.327649 (full-width crown)
b2_crown_cr14b_profile = [[3.41723, -34.40378], [0.85937, -33.06841], [0.00873, -32.0637], [0.00873, -22.38456], [2.08369, -20.57808], [5.46316, -19.81195], [10.83721, -20.2875], [13.48904, -22.46662], [14.0985, -24.97294], [13.78869, -31.14534], [12.57082, -33.4983], [10.56548, -34.61097], [7.67943, -34.97497]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.127649 (full-width crown)
b2_crown_cr15a_profile = [[3.41723, -34.40378], [0.85937, -33.06841], [0.00873, -32.0637], [0.00873, -22.38456], [2.08369, -20.57808], [5.46316, -19.81195], [10.83721, -20.2875], [13.48904, -22.46662], [14.0985, -24.97294], [13.78869, -31.14534], [12.57082, -33.4983], [10.56548, -34.61097], [7.67943, -34.97497]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.127649 (full-width crown)
b2_crown_cr15b_profile = [[4.75173, -34.62518], [2.17564, -33.85446], [0.95036, -33.06834], [0.00873, -31.99341], [0.00873, -22.45222], [0.62371, -21.66583], [1.94029, -20.73332], [4.64205, -19.98279], [6.94532, -19.88403], [10.59954, -20.31998], [11.77517, -20.75422], [12.97, -21.76146], [13.69423, -23.25344], [14.16969, -27.38937], [13.92958, -30.13899], [13.36365, -32.12873], [12.44256, -33.50752], [11.48692, -34.16425], [9.55832, -34.71218], [7.52869, -34.87117]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.927649 (full-width crown)
b2_crown_cr16a_profile = [[4.75173, -34.62518], [2.17564, -33.85446], [0.95036, -33.06834], [0.00873, -31.99341], [0.00873, -22.45222], [0.62371, -21.66583], [1.94029, -20.73332], [4.64205, -19.98279], [6.94532, -19.88403], [10.59954, -20.31998], [11.77517, -20.75422], [12.97, -21.76146], [13.69423, -23.25344], [14.16969, -27.38937], [13.92958, -30.13899], [13.36365, -32.12873], [12.44256, -33.50752], [11.48692, -34.16425], [9.55832, -34.71218], [7.52869, -34.87117]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.927649 (full-width crown)
b2_crown_cr16b_profile = [[3.19941, -34.18655], [1.54575, -33.43532], [0.00873, -31.92822], [0.00873, -22.51163], [1.84159, -20.86112], [3.67595, -20.2227], [5.54796, -19.98626], [7.84538, -20.02429], [11.78292, -20.86249], [13.30684, -22.45486], [13.95417, -25.00618], [13.89866, -29.97427], [12.78747, -32.98858], [12.0256, -33.75305], [9.64631, -34.60964], [7.39328, -34.77717]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.727649 (full-width crown)
b2_crown_cr17a_profile = [[3.19941, -34.18655], [1.54575, -33.43532], [0.00873, -31.92822], [0.00873, -22.51163], [1.84159, -20.86112], [3.67595, -20.2227], [5.54796, -19.98626], [7.84538, -20.02429], [11.78292, -20.86249], [13.30684, -22.45486], [13.95417, -25.00618], [13.89866, -29.97427], [12.78747, -32.98858], [12.0256, -33.75305], [9.64631, -34.60964], [7.39328, -34.77717]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.727649 (full-width crown)
b2_crown_cr17b_profile = [[7.21611, -34.70571], [0.00873, -30.00011], [0.00873, -24.80011], [7.21497, -20.06022], [11.52614, -20.82502], [12.94176, -22.00045], [13.68707, -23.7668], [14.05139, -28.01807], [13.73532, -30.47315], [12.6611, -33.03028], [11.22677, -34.08385], [9.0083, -34.62027]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.527649 (full-width crown)
b2_crown_cr18a_profile = [[7.21611, -34.70571], [0.00873, -30.00011], [0.00873, -24.80011], [7.21497, -20.06022], [11.52614, -20.82502], [12.94176, -22.00045], [13.68707, -23.7668], [14.05139, -28.01807], [13.73532, -30.47315], [12.6611, -33.03028], [11.22677, -34.08385], [9.0083, -34.62027]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.527649 (full-width crown)
b2_crown_cr18b_profile = [[0.00873, -30.00011], [0.00873, -24.80011], [9.46472, -20.32015], [11.99254, -21.18773], [12.87015, -22.02613], [13.3936, -23.00401], [13.69257, -24.08827], [14.00505, -27.515], [13.44652, -31.29433], [12.58545, -33.00334], [11.66833, -33.79293], [9.93914, -34.41334], [9.53193, -34.49433]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.327649 (full-width crown)
b2_crown_cr19a_profile = [[0.00873, -30.00011], [0.00873, -24.80011], [9.46472, -20.32015], [11.99254, -21.18773], [12.87015, -22.02613], [13.3936, -23.00401], [13.69257, -24.08827], [14.00505, -27.515], [13.44652, -31.29433], [12.58545, -33.00334], [11.66833, -33.79293], [9.93914, -34.41334], [9.53193, -34.49433]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.327649 (full-width crown)
b2_crown_cr19b_profile = [[10.65249, -34.16933], [0.00873, -30.00011], [0.00873, -24.80011], [10.65369, -20.61781], [12.40583, -21.61198], [13.13614, -22.57668], [13.77914, -24.99706], [13.8971, -28.6635], [13.46883, -31.05161], [12.25132, -33.25458]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.127649 (full-width crown)
b2_crown_cr20a_profile = [[10.65249, -34.16933], [0.00873, -30.00011], [0.00873, -24.80011], [10.65369, -20.61781], [12.40583, -21.61198], [13.13614, -22.57668], [13.77914, -24.99706], [13.8971, -28.6635], [13.46883, -31.05161], [12.25132, -33.25458]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.127649 (full-width crown)
b2_crown_cr20b_profile = [[11.48519, -33.73882], [0.00873, -30.00011], [0.00873, -24.80011], [11.52203, -21.04844], [12.74635, -22.07754], [13.57843, -24.06047], [13.86602, -28.2083], [13.23987, -31.59048], [12.73475, -32.56481]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.927649 (full-width crown)
b2_crown_cr21a_profile = [[11.48519, -33.73882], [0.00873, -30.00011], [0.00873, -24.80011], [11.52203, -21.04844], [12.74635, -22.07754], [13.57843, -24.06047], [13.86602, -28.2083], [13.23987, -31.59048], [12.73475, -32.56481]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.927649 (full-width crown)
b2_crown_cr21b_profile = [[11.73811, -33.54156], [0.00873, -30.00011], [0.00873, -24.80011], [11.75915, -21.21658], [12.91649, -22.35897], [13.57953, -24.15326], [13.83946, -28.26963], [13.33518, -31.26517], [12.52049, -32.8111]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=7.227649 (full-width crown)
b2_crown_cr22a_profile = [[11.73811, -33.54156], [0.00873, -30.00011], [0.00873, -24.80011], [11.75915, -21.21658], [12.91649, -22.35897], [13.57953, -24.15326], [13.83946, -28.26963], [13.33518, -31.26517], [12.52049, -32.8111]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=7.227649 (full-width crown)
b2_crown_cr22b_profile = [[11.95792, -33.33378], [0.00873, -30.00011], [0.00873, -24.80011], [11.95668, -21.38205], [13.05998, -22.6525], [13.58059, -24.24326], [13.84415, -26.93128], [13.6768, -29.68587], [13.21175, -31.57078], [12.52954, -32.7624]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=7.518651 (full-width crown)

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
                hull() {
                    // b2_crown_cr00a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.372351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.372351]) linear_extrude(0.02) polygon(b2_crown_cr00a_profile);
                    // b2_crown_cr00b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.072351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.072351]) linear_extrude(0.02) polygon(b2_crown_cr00b_profile);
                }
                hull() {
                    // b2_crown_cr01a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.072351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.072351]) linear_extrude(0.02) polygon(b2_crown_cr01a_profile);
                    // b2_crown_cr01b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.772351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.772351]) linear_extrude(0.02) polygon(b2_crown_cr01b_profile);
                }
                hull() {
                    // b2_crown_cr02a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.772351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.772351]) linear_extrude(0.02) polygon(b2_crown_cr02a_profile);
                    // b2_crown_cr02b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.472351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.472351]) linear_extrude(0.02) polygon(b2_crown_cr02b_profile);
                }
                hull() {
                    // b2_crown_cr03a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.472351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.472351]) linear_extrude(0.02) polygon(b2_crown_cr03a_profile);
                    // b2_crown_cr03b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.172351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.172351]) linear_extrude(0.02) polygon(b2_crown_cr03b_profile);
                }
                hull() {
                    // b2_crown_cr04a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.172351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.172351]) linear_extrude(0.02) polygon(b2_crown_cr04a_profile);
                    // b2_crown_cr04b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.872351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -5.872351]) linear_extrude(0.02) polygon(b2_crown_cr04b_profile);
                }
                hull() {
                    // b2_crown_cr05a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.872351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -5.872351]) linear_extrude(0.02) polygon(b2_crown_cr05a_profile);
                    // b2_crown_cr05b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.072351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -5.072351]) linear_extrude(0.02) polygon(b2_crown_cr05b_profile);
                }
                hull() {
                    // b2_crown_cr06a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.072351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -5.072351]) linear_extrude(0.02) polygon(b2_crown_cr06a_profile);
                    // b2_crown_cr06b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.272351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -4.272351]) linear_extrude(0.02) polygon(b2_crown_cr06b_profile);
                }
                hull() {
                    // b2_crown_cr07a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.272351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -4.272351]) linear_extrude(0.02) polygon(b2_crown_cr07a_profile);
                    // b2_crown_cr07b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.472351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -3.472351]) linear_extrude(0.02) polygon(b2_crown_cr07b_profile);
                }
                hull() {
                    // b2_crown_cr08a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.472351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -3.472351]) linear_extrude(0.02) polygon(b2_crown_cr08a_profile);
                    // b2_crown_cr08b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.672351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -2.672351]) linear_extrude(0.02) polygon(b2_crown_cr08b_profile);
                }
                hull() {
                    // b2_crown_cr09a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.672351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -2.672351]) linear_extrude(0.02) polygon(b2_crown_cr09a_profile);
                    // b2_crown_cr09b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.872351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -1.872351]) linear_extrude(0.02) polygon(b2_crown_cr09b_profile);
                }
                hull() {
                    // b2_crown_cr10a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.872351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -1.872351]) linear_extrude(0.02) polygon(b2_crown_cr10a_profile);
                    // b2_crown_cr10b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.072351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -1.072351]) linear_extrude(0.02) polygon(b2_crown_cr10b_profile);
                }
                hull() {
                    // b2_crown_cr11a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.072351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -1.072351]) linear_extrude(0.02) polygon(b2_crown_cr11a_profile);
                    // b2_crown_cr11b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.272351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -0.272351]) linear_extrude(0.02) polygon(b2_crown_cr11b_profile);
                }
                hull() {
                    // b2_crown_cr12a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.272351 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -0.272351]) linear_extrude(0.02) polygon(b2_crown_cr12a_profile);
                    // b2_crown_cr12b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.527649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 0.527649]) linear_extrude(0.02) polygon(b2_crown_cr12b_profile);
                }
                hull() {
                    // b2_crown_cr13a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.527649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 0.527649]) linear_extrude(0.02) polygon(b2_crown_cr13a_profile);
                    // b2_crown_cr13b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.327649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 1.327649]) linear_extrude(0.02) polygon(b2_crown_cr13b_profile);
                }
                hull() {
                    // b2_crown_cr14a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.327649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 1.327649]) linear_extrude(0.02) polygon(b2_crown_cr14a_profile);
                    // b2_crown_cr14b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.127649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 2.127649]) linear_extrude(0.02) polygon(b2_crown_cr14b_profile);
                }
                hull() {
                    // b2_crown_cr15a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.127649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 2.127649]) linear_extrude(0.02) polygon(b2_crown_cr15a_profile);
                    // b2_crown_cr15b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.927649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 2.927649]) linear_extrude(0.02) polygon(b2_crown_cr15b_profile);
                }
                hull() {
                    // b2_crown_cr16a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.927649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 2.927649]) linear_extrude(0.02) polygon(b2_crown_cr16a_profile);
                    // b2_crown_cr16b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.727649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 3.727649]) linear_extrude(0.02) polygon(b2_crown_cr16b_profile);
                }
                hull() {
                    // b2_crown_cr17a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.727649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 3.727649]) linear_extrude(0.02) polygon(b2_crown_cr17a_profile);
                    // b2_crown_cr17b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.527649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 4.527649]) linear_extrude(0.02) polygon(b2_crown_cr17b_profile);
                }
                hull() {
                    // b2_crown_cr18a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.527649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 4.527649]) linear_extrude(0.02) polygon(b2_crown_cr18a_profile);
                    // b2_crown_cr18b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.327649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 5.327649]) linear_extrude(0.02) polygon(b2_crown_cr18b_profile);
                }
                hull() {
                    // b2_crown_cr19a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.327649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 5.327649]) linear_extrude(0.02) polygon(b2_crown_cr19a_profile);
                    // b2_crown_cr19b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.127649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.127649]) linear_extrude(0.02) polygon(b2_crown_cr19b_profile);
                }
                hull() {
                    // b2_crown_cr20a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.127649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.127649]) linear_extrude(0.02) polygon(b2_crown_cr20a_profile);
                    // b2_crown_cr20b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.927649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.927649]) linear_extrude(0.02) polygon(b2_crown_cr20b_profile);
                }
                hull() {
                    // b2_crown_cr21a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.927649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.927649]) linear_extrude(0.02) polygon(b2_crown_cr21a_profile);
                    // b2_crown_cr21b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=7.227649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 7.227649]) linear_extrude(0.02) polygon(b2_crown_cr21b_profile);
                }
                hull() {
                    // b2_crown_cr22a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=7.227649 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 7.227649]) linear_extrude(0.02) polygon(b2_crown_cr22a_profile);
                    // b2_crown_cr22b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=7.518651 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 7.518651]) linear_extrude(0.02) polygon(b2_crown_cr22b_profile);
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

// ---- body 3 (strategy: csg — semantic parametric plan) ----
// plan: semantic laws: beam = exact wall window × envelope laws (top res 0.099, bottom res 0.093; knuckle lobes are r6 arcs concentric with the exact pin bores); ridge stem/cap = window × fitted laws; crown kept as measured loft (no clean law); recess/web profiles vectorized

// ======== PARAMETERS (every value measured; see source comments) ========
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
b3_fn               = 96;  // curve resolution

b3_crown_cr00a_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [12.51951, 7.84839], [13.70957, 7.37534], [14.50739, 6.59181], [14.90619, 5.76243], [15.81546, 3.17117], [15.81546, 0.53035], [14.47993, -2.7864], [13.62985, -3.67611], [12.51071, -4.17097]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-8.040772 (full-width crown)
b3_crown_cr00b_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [12.31796, 7.8699], [13.66, 7.37833], [14.64904, 6.30144], [15.78616, 3.17146], [15.78616, 0.53002], [14.30787, -2.98496], [13.48318, -3.74065], [12.3181, -4.20062]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.740772 (full-width crown)
b3_crown_cr01a_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [12.31796, 7.8699], [13.66, 7.37833], [14.64904, 6.30144], [15.78616, 3.17146], [15.78616, 0.53002], [14.30787, -2.98496], [13.48318, -3.74065], [12.3181, -4.20062]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.740772 (full-width crown)
b3_crown_cr01b_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [12.05798, 7.89584], [13.61294, 7.37152], [14.50524, 6.47833], [14.83417, 5.79505], [15.75686, 3.17174], [15.75686, 0.5297], [14.15231, -3.1237], [13.01981, -3.95113], [12.05844, -4.23777]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.440772 (full-width crown)
b3_crown_cr02a_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [12.05798, 7.89584], [13.61294, 7.37152], [14.50524, 6.47833], [14.83417, 5.79505], [15.75686, 3.17174], [15.75686, 0.5297], [14.15231, -3.1237], [13.01981, -3.95113], [12.05844, -4.23777]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.440772 (full-width crown)
b3_crown_cr02b_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.77077, 7.92309], [13.21252, 7.54937], [14.29255, 6.71952], [14.79415, 5.81317], [15.72756, 3.17203], [15.72756, 0.52937], [14.32929, -2.83656], [13.07448, -3.89684], [11.77197, -4.27382]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.140772 (full-width crown)
b3_crown_cr03a_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.77077, 7.92309], [13.21252, 7.54937], [14.29255, 6.71952], [14.79415, 5.81317], [15.72756, 3.17203], [15.72756, 0.52937], [14.32929, -2.83656], [13.07448, -3.89684], [11.77197, -4.27382]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.140772 (full-width crown)
b3_crown_cr03b_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.45123, 7.95011], [13.1312, 7.55317], [13.95242, 7.03361], [14.7787, 5.75833], [15.69825, 3.17232], [15.69825, 0.52905], [14.15639, -3.00626], [13.01591, -3.89198], [11.38373, -4.31224]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.840772 (full-width crown)
b3_crown_cr04a_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.45123, 7.95011], [13.1312, 7.55317], [13.95242, 7.03361], [14.7787, 5.75833], [15.69825, 3.17232], [15.69825, 0.52905], [14.15639, -3.00626], [13.01591, -3.89198], [11.38373, -4.31224]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.840772 (full-width crown)
b3_crown_cr04b_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.095, 7.97306], [13.37655, 7.40336], [14.27097, 6.63403], [14.72792, 5.80075], [15.66895, 3.1726], [15.66895, 0.52872], [14.16971, -2.93892], [13.21197, -3.76534], [11.74103, -4.23848], [11.01827, -4.33786]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.540772 (full-width crown)
b3_crown_cr05a_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.095, 7.97306], [13.37655, 7.40336], [14.27097, 6.63403], [14.72792, 5.80075], [15.66895, 3.1726], [15.66895, 0.52872], [14.16971, -2.93892], [13.21197, -3.76534], [11.74103, -4.23848], [11.01827, -4.33786]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.540772 (full-width crown)
b3_crown_cr05b_profile = [[9.68, -4.35935], [0.00873, -0.74943], [0.00873, 4.45057], [9.67993, 8.00468], [12.94797, 7.51959], [13.80411, 7.00387], [14.58794, 5.89886], [15.59082, 3.15431], [15.59082, 0.54792], [13.92453, -3.0945], [12.59014, -3.94951], [10.16733, -4.35081]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.740772 (full-width crown)
b3_crown_cr06a_profile = [[9.68, -4.35935], [0.00873, -0.74943], [0.00873, 4.45057], [9.67993, 8.00468], [12.94797, 7.51959], [13.80411, 7.00387], [14.58794, 5.89886], [15.59082, 3.15431], [15.59082, 0.54792], [13.92453, -3.0945], [12.59014, -3.94951], [10.16733, -4.35081]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.740772 (full-width crown)
b3_crown_cr06b_profile = [[7.27515, -4.2832], [0.00873, -0.74943], [0.00873, 4.45057], [7.27753, 8.0336], [12.14933, 7.69434], [13.29033, 7.27014], [14.60734, 5.56974], [15.51268, 2.54825], [15.51268, 1.1547], [14.16063, -2.62712], [13.15232, -3.62593], [11.70158, -4.11022], [9.29499, -4.32103]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.940772 (full-width crown)
b3_crown_cr07a_profile = [[7.27515, -4.2832], [0.00873, -0.74943], [0.00873, 4.45057], [7.27753, 8.0336], [12.14933, 7.69434], [13.29033, 7.27014], [14.60734, 5.56974], [15.51268, 2.54825], [15.51268, 1.1547], [14.16063, -2.62712], [13.15232, -3.62593], [11.70158, -4.11022], [9.29499, -4.32103]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.940772 (full-width crown)
b3_crown_cr07b_profile = [[3.22596, -3.80253], [1.07657, -3.0387], [0.00873, -2.11067], [0.02755, 6.12826], [0.89548, 6.91388], [3.56526, 7.77309], [9.10452, 7.94769], [12.39412, 7.56132], [13.7556, 6.80551], [14.4835, 5.64194], [14.81823, 3.99176], [14.71861, -0.71027], [14.31914, -2.15065], [13.41968, -3.34594], [12.7173, -3.75012], [10.18357, -4.21936], [8.68228, -4.28184]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.140772 (full-width crown)
b3_crown_cr08a_profile = [[3.22596, -3.80253], [1.07657, -3.0387], [0.00873, -2.11067], [0.02755, 6.12826], [0.89548, 6.91388], [3.56526, 7.77309], [9.10452, 7.94769], [12.39412, 7.56132], [13.7556, 6.80551], [14.4835, 5.64194], [14.81823, 3.99176], [14.71861, -0.71027], [14.31914, -2.15065], [13.41968, -3.34594], [12.7173, -3.75012], [10.18357, -4.21936], [8.68228, -4.28184]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.140772 (full-width crown)
b3_crown_cr08b_profile = [[3.51781, -3.82768], [1.55795, -3.24787], [0.23997, -2.3743], [0.00873, -2.09676], [0.00873, 6.08607], [1.11922, 7.01265], [3.85005, 7.77532], [9.19757, 7.87555], [11.89137, 7.59927], [12.95313, 7.26855], [13.86734, 6.54815], [14.48199, 5.34651], [14.93591, 1.67099], [14.44077, -1.60792], [13.69497, -2.94449], [12.36058, -3.79172], [10.59053, -4.10028], [8.7358, -4.22486]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.340772 (full-width crown)
b3_crown_cr09a_profile = [[3.51781, -3.82768], [1.55795, -3.24787], [0.23997, -2.3743], [0.00873, -2.09676], [0.00873, 6.08607], [1.11922, 7.01265], [3.85005, 7.77532], [9.19757, 7.87555], [11.89137, 7.59927], [12.95313, 7.26855], [13.86734, 6.54815], [14.48199, 5.34651], [14.93591, 1.67099], [14.44077, -1.60792], [13.69497, -2.94449], [12.36058, -3.79172], [10.59053, -4.10028], [8.7358, -4.22486]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.340772 (full-width crown)
b3_crown_cr09b_profile = [[3.52565, -3.77063], [0.92049, -2.87138], [0.00873, -2.06934], [0.00873, 6.05782], [0.57279, 6.62439], [1.9935, 7.32735], [8.61472, 7.8525], [12.77135, 7.2599], [13.58934, 6.71568], [14.28088, 5.63937], [14.63339, 4.17134], [14.85305, 1.85645], [14.34657, -1.61416], [13.7473, -2.72783], [12.41627, -3.69036], [10.97062, -3.98082], [8.21058, -4.16664]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.540772 (full-width crown)
b3_crown_cr10a_profile = [[3.52565, -3.77063], [0.92049, -2.87138], [0.00873, -2.06934], [0.00873, 6.05782], [0.57279, 6.62439], [1.9935, 7.32735], [8.61472, 7.8525], [12.77135, 7.2599], [13.58934, 6.71568], [14.28088, 5.63937], [14.63339, 4.17134], [14.85305, 1.85645], [14.34657, -1.61416], [13.7473, -2.72783], [12.41627, -3.69036], [10.97062, -3.98082], [8.21058, -4.16664]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.540772 (full-width crown)
b3_crown_cr10b_profile = [[3.63838, -3.72689], [1.55251, -3.13497], [0.4157, -2.45731], [0.00873, -2.03201], [0.02525, 6.04019], [1.29985, 6.9936], [3.19138, 7.55294], [8.76499, 7.77196], [12.23105, 7.35481], [13.53152, 6.6381], [14.17891, 5.64338], [14.51026, 4.39764], [14.74423, 1.62144], [14.322, -1.39638], [13.87117, -2.38553], [12.89919, -3.38211], [11.82197, -3.76764], [8.2825, -4.09392]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.740772 (full-width crown)
b3_crown_cr11a_profile = [[3.63838, -3.72689], [1.55251, -3.13497], [0.4157, -2.45731], [0.00873, -2.03201], [0.02525, 6.04019], [1.29985, 6.9936], [3.19138, 7.55294], [8.76499, 7.77196], [12.23105, 7.35481], [13.53152, 6.6381], [14.17891, 5.64338], [14.51026, 4.39764], [14.74423, 1.62144], [14.322, -1.39638], [13.87117, -2.38553], [12.89919, -3.38211], [11.82197, -3.76764], [8.2825, -4.09392]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.740772 (full-width crown)
b3_crown_cr11b_profile = [[3.65767, -3.64873], [1.53186, -3.05417], [0.45334, -2.43146], [0.00873, -1.98972], [0.00873, 5.97125], [1.0108, 6.78333], [2.45783, 7.31867], [8.24116, 7.72142], [13.04859, 6.92266], [13.68786, 6.33137], [14.31568, 4.9207], [14.66532, 1.8147], [14.26714, -1.27118], [13.79822, -2.33099], [12.73839, -3.3685], [10.75077, -3.84621], [8.05142, -4.01692]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.940772 (full-width crown)
b3_crown_cr12a_profile = [[3.65767, -3.64873], [1.53186, -3.05417], [0.45334, -2.43146], [0.00873, -1.98972], [0.00873, 5.97125], [1.0108, 6.78333], [2.45783, 7.31867], [8.24116, 7.72142], [13.04859, 6.92266], [13.68786, 6.33137], [14.31568, 4.9207], [14.66532, 1.8147], [14.26714, -1.27118], [13.79822, -2.33099], [12.73839, -3.3685], [10.75077, -3.84621], [8.05142, -4.01692]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.940772 (full-width crown)
b3_crown_cr12b_profile = [[3.63675, -3.55986], [1.37689, -2.9055], [0.00873, -1.94025], [0.03825, 5.95442], [1.06827, 6.74053], [3.50617, 7.42772], [9.2056, 7.58685], [12.14851, 7.2025], [12.87833, 6.9279], [13.51323, 6.40708], [13.98707, 5.6301], [14.4016, 3.98698], [14.52523, 1.31047], [14.10306, -1.52204], [13.13509, -2.98337], [12.44058, -3.41396], [10.86052, -3.75839], [8.14417, -3.93234]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.140772 (full-width crown)
b3_crown_cr13a_profile = [[3.63675, -3.55986], [1.37689, -2.9055], [0.00873, -1.94025], [0.03825, 5.95442], [1.06827, 6.74053], [3.50617, 7.42772], [9.2056, 7.58685], [12.14851, 7.2025], [12.87833, 6.9279], [13.51323, 6.40708], [13.98707, 5.6301], [14.4016, 3.98698], [14.52523, 1.31047], [14.10306, -1.52204], [13.13509, -2.98337], [12.44058, -3.41396], [10.86052, -3.75839], [8.14417, -3.93234]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.140772 (full-width crown)
b3_crown_cr13b_profile = [[3.39255, -3.42061], [1.54899, -2.90407], [0.57729, -2.39612], [0.00873, -1.89077], [0.00873, 5.86838], [1.12587, 6.69302], [2.90994, 7.24077], [5.01131, 7.46531], [9.76341, 7.45103], [12.43066, 7.04112], [13.59919, 6.15283], [14.37991, 3.49778], [14.45088, 1.45053], [14.03632, -1.43737], [13.23604, -2.76352], [12.36385, -3.3572], [11.04712, -3.66692], [8.03592, -3.84615]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.659228 (full-width crown)
b3_crown_cr14a_profile = [[3.39255, -3.42061], [1.54899, -2.90407], [0.57729, -2.39612], [0.00873, -1.89077], [0.00873, 5.86838], [1.12587, 6.69302], [2.90994, 7.24077], [5.01131, 7.46531], [9.76341, 7.45103], [12.43066, 7.04112], [13.59919, 6.15283], [14.37991, 3.49778], [14.45088, 1.45053], [14.03632, -1.43737], [13.23604, -2.76352], [12.36385, -3.3572], [11.04712, -3.66692], [8.03592, -3.84615]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.659228 (full-width crown)
b3_crown_cr14b_profile = [[4.29456, -3.48549], [2.24206, -3.05571], [0.97538, -2.57114], [0.00873, -1.8398], [0.00873, 5.81448], [1.1872, 6.64644], [4.26962, 7.32246], [8.86177, 7.44998], [12.04839, 7.07643], [12.96099, 6.68977], [13.67424, 5.87911], [14.16312, 4.37678], [14.40673, 2.12146], [13.95866, -1.39732], [13.2929, -2.57751], [12.60051, -3.15291], [10.96493, -3.61064], [8.34255, -3.75766]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.459228 (full-width crown)
b3_crown_cr15a_profile = [[4.29456, -3.48549], [2.24206, -3.05571], [0.97538, -2.57114], [0.00873, -1.8398], [0.00873, 5.81448], [1.1872, 6.64644], [4.26962, 7.32246], [8.86177, 7.44998], [12.04839, 7.07643], [12.96099, 6.68977], [13.67424, 5.87911], [14.16312, 4.37678], [14.40673, 2.12146], [13.95866, -1.39732], [13.2929, -2.57751], [12.60051, -3.15291], [10.96493, -3.61064], [8.34255, -3.75766]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.459228 (full-width crown)
b3_crown_cr15b_profile = [[4.42223, -3.41522], [2.09036, -2.93331], [0.70217, -2.35499], [0.00873, -1.78775], [0.00873, 5.76229], [0.57142, 6.2515], [2.27347, 6.93192], [5.40096, 7.31042], [9.92191, 7.30167], [12.67082, 6.77822], [13.35362, 6.20914], [13.94987, 4.95417], [14.3257, 2.22842], [13.7366, -1.72429], [13.11436, -2.65384], [12.12458, -3.28898], [11.17131, -3.52375], [8.76082, -3.67435]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.259228 (full-width crown)
b3_crown_cr16a_profile = [[4.42223, -3.41522], [2.09036, -2.93331], [0.70217, -2.35499], [0.00873, -1.78775], [0.00873, 5.76229], [0.57142, 6.2515], [2.27347, 6.93192], [5.40096, 7.31042], [9.92191, 7.30167], [12.67082, 6.77822], [13.35362, 6.20914], [13.94987, 4.95417], [14.3257, 2.22842], [13.7366, -1.72429], [13.11436, -2.65384], [12.12458, -3.28898], [11.17131, -3.52375], [8.76082, -3.67435]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.259228 (full-width crown)
b3_crown_cr16b_profile = [[4.54989, -3.34495], [1.00507, -2.46752], [0.00873, -1.7399], [0.03513, 5.74272], [1.20614, 6.52335], [3.07439, 7.01211], [8.72762, 7.28683], [12.15284, 6.93289], [13.03582, 6.44494], [13.81682, 5.12278], [14.2039, 2.88605], [14.17787, 0.9996], [13.39909, -2.18168], [12.95771, -2.70616], [11.59093, -3.38889], [8.98555, -3.60174]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.059228 (full-width crown)
b3_crown_cr17a_profile = [[4.54989, -3.34495], [1.00507, -2.46752], [0.00873, -1.7399], [0.03513, 5.74272], [1.20614, 6.52335], [3.07439, 7.01211], [8.72762, 7.28683], [12.15284, 6.93289], [13.03582, 6.44494], [13.81682, 5.12278], [14.2039, 2.88605], [14.17787, 0.9996], [13.39909, -2.18168], [12.95771, -2.70616], [11.59093, -3.38889], [8.98555, -3.60174]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.059228 (full-width crown)
b3_crown_cr17b_profile = [[7.21614, -3.48536], [0.00873, -0.74943], [0.00873, 4.45057], [7.2151, 7.23886], [11.09611, 7.11133], [12.21366, 6.86624], [13.23499, 6.14431], [13.66852, 5.3408], [14.08527, 3.24292], [14.1098, 0.85545], [13.75707, -1.1588], [13.03675, -2.54278], [12.16193, -3.14883], [11.07995, -3.43366], [9.34635, -3.54578]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.859228 (full-width crown)
b3_crown_cr18a_profile = [[7.21614, -3.48536], [0.00873, -0.74943], [0.00873, 4.45057], [7.2151, 7.23886], [11.09611, 7.11133], [12.21366, 6.86624], [13.23499, 6.14431], [13.66852, 5.3408], [14.08527, 3.24292], [14.1098, 0.85545], [13.75707, -1.1588], [13.03675, -2.54278], [12.16193, -3.14883], [11.07995, -3.43366], [9.34635, -3.54578]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.859228 (full-width crown)
b3_crown_cr18b_profile = [[9.46865, -3.50631], [0.00873, -0.74943], [0.00873, 4.45057], [9.63447, 7.17242], [11.85763, 6.94392], [13.10777, 6.2169], [13.64144, 5.23789], [13.97426, 3.57911], [14.12079, 1.85673], [13.4998, -1.70606], [13.04449, -2.45778], [11.41066, -3.34327]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.659228 (full-width crown)
b3_crown_cr19a_profile = [[9.46865, -3.50631], [0.00873, -0.74943], [0.00873, 4.45057], [9.63447, 7.17242], [11.85763, 6.94392], [13.10777, 6.2169], [13.64144, 5.23789], [13.97426, 3.57911], [14.12079, 1.85673], [13.4998, -1.70606], [13.04449, -2.45778], [11.41066, -3.34327]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.659228 (full-width crown)
b3_crown_cr19b_profile = [[10.65036, -3.42698], [0.00873, -0.74943], [0.00873, 4.45057], [10.76055, 7.10001], [12.15308, 6.81954], [13.21184, 6.02129], [13.72774, 4.75677], [14.05363, 1.7762], [13.68536, -0.99559], [13.11822, -2.30197], [12.52407, -2.8626]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.459228 (full-width crown)
b3_crown_cr20a_profile = [[10.65036, -3.42698], [0.00873, -0.74943], [0.00873, 4.45057], [10.76055, 7.10001], [12.15308, 6.81954], [13.21184, 6.02129], [13.72774, 4.75677], [14.05363, 1.7762], [13.68536, -0.99559], [13.11822, -2.30197], [12.52407, -2.8626]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.459228 (full-width crown)
b3_crown_cr20b_profile = [[11.4863, -3.27314], [0.00873, -0.74943], [0.00873, 4.45057], [11.4825, 6.98101], [12.79063, 6.42007], [13.59314, 5.09922], [13.93788, 3.0285], [13.91715, 0.60827], [13.26723, -1.99027], [12.3508, -2.93307]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.259228 (full-width crown)
b3_crown_cr21a_profile = [[11.4863, -3.27314], [0.00873, -0.74943], [0.00873, 4.45057], [11.4825, 6.98101], [12.79063, 6.42007], [13.59314, 5.09922], [13.93788, 3.0285], [13.91715, 0.60827], [13.26723, -1.99027], [12.3508, -2.93307]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.259228 (full-width crown)
b3_crown_cr21b_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.73685, 6.91752], [13.02647, 6.1787], [13.5594, 5.16392], [13.91668, 3.05871], [13.88755, 0.51635], [13.47715, -1.48959], [12.89312, -2.49346], [11.75555, -3.18777]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.559228 (full-width crown)
b3_crown_cr22a_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [11.73685, 6.91752], [13.02647, 6.1787], [13.5594, 5.16392], [13.91668, 3.05871], [13.88755, 0.51635], [13.47715, -1.48959], [12.89312, -2.49346], [11.75555, -3.18777]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.559228 (full-width crown)
b3_crown_cr22b_profile = [[0.00873, -0.74943], [0.00873, 4.45057], [12.32883, 6.69194], [13.08801, 6.08329], [13.54841, 5.1514], [13.89637, 3.08802], [13.85884, 0.42718], [13.33572, -1.80025], [12.59215, -2.74838], [12.03547, -3.07276]];  // (z, x) points — crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.850229 (full-width crown)

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
                hull() {
                    // b3_crown_cr00a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-8.040772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -8.040772]) linear_extrude(0.02) polygon(b3_crown_cr00a_profile);
                    // b3_crown_cr00b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.740772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.740772]) linear_extrude(0.02) polygon(b3_crown_cr00b_profile);
                }
                hull() {
                    // b3_crown_cr01a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.740772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.740772]) linear_extrude(0.02) polygon(b3_crown_cr01a_profile);
                    // b3_crown_cr01b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.440772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.440772]) linear_extrude(0.02) polygon(b3_crown_cr01b_profile);
                }
                hull() {
                    // b3_crown_cr02a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.440772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.440772]) linear_extrude(0.02) polygon(b3_crown_cr02a_profile);
                    // b3_crown_cr02b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.140772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.140772]) linear_extrude(0.02) polygon(b3_crown_cr02b_profile);
                }
                hull() {
                    // b3_crown_cr03a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-7.140772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -7.140772]) linear_extrude(0.02) polygon(b3_crown_cr03a_profile);
                    // b3_crown_cr03b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.840772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.840772]) linear_extrude(0.02) polygon(b3_crown_cr03b_profile);
                }
                hull() {
                    // b3_crown_cr04a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.840772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.840772]) linear_extrude(0.02) polygon(b3_crown_cr04a_profile);
                    // b3_crown_cr04b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.540772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.540772]) linear_extrude(0.02) polygon(b3_crown_cr04b_profile);
                }
                hull() {
                    // b3_crown_cr05a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-6.540772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -6.540772]) linear_extrude(0.02) polygon(b3_crown_cr05a_profile);
                    // b3_crown_cr05b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.740772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -5.740772]) linear_extrude(0.02) polygon(b3_crown_cr05b_profile);
                }
                hull() {
                    // b3_crown_cr06a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-5.740772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -5.740772]) linear_extrude(0.02) polygon(b3_crown_cr06a_profile);
                    // b3_crown_cr06b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.940772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -4.940772]) linear_extrude(0.02) polygon(b3_crown_cr06b_profile);
                }
                hull() {
                    // b3_crown_cr07a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.940772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -4.940772]) linear_extrude(0.02) polygon(b3_crown_cr07a_profile);
                    // b3_crown_cr07b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.140772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -4.140772]) linear_extrude(0.02) polygon(b3_crown_cr07b_profile);
                }
                hull() {
                    // b3_crown_cr08a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-4.140772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -4.140772]) linear_extrude(0.02) polygon(b3_crown_cr08a_profile);
                    // b3_crown_cr08b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.340772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -3.340772]) linear_extrude(0.02) polygon(b3_crown_cr08b_profile);
                }
                hull() {
                    // b3_crown_cr09a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-3.340772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -3.340772]) linear_extrude(0.02) polygon(b3_crown_cr09a_profile);
                    // b3_crown_cr09b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.540772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -2.540772]) linear_extrude(0.02) polygon(b3_crown_cr09b_profile);
                }
                hull() {
                    // b3_crown_cr10a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-2.540772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -2.540772]) linear_extrude(0.02) polygon(b3_crown_cr10a_profile);
                    // b3_crown_cr10b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.740772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -1.740772]) linear_extrude(0.02) polygon(b3_crown_cr10b_profile);
                }
                hull() {
                    // b3_crown_cr11a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-1.740772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -1.740772]) linear_extrude(0.02) polygon(b3_crown_cr11a_profile);
                    // b3_crown_cr11b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.940772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -0.940772]) linear_extrude(0.02) polygon(b3_crown_cr11b_profile);
                }
                hull() {
                    // b3_crown_cr12a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.940772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -0.940772]) linear_extrude(0.02) polygon(b3_crown_cr12a_profile);
                    // b3_crown_cr12b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.140772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -0.140772]) linear_extrude(0.02) polygon(b3_crown_cr12b_profile);
                }
                hull() {
                    // b3_crown_cr13a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=-0.140772 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, -0.140772]) linear_extrude(0.02) polygon(b3_crown_cr13a_profile);
                    // b3_crown_cr13b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.659228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 0.659228]) linear_extrude(0.02) polygon(b3_crown_cr13b_profile);
                }
                hull() {
                    // b3_crown_cr14a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=0.659228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 0.659228]) linear_extrude(0.02) polygon(b3_crown_cr14a_profile);
                    // b3_crown_cr14b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.459228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 1.459228]) linear_extrude(0.02) polygon(b3_crown_cr14b_profile);
                }
                hull() {
                    // b3_crown_cr15a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=1.459228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 1.459228]) linear_extrude(0.02) polygon(b3_crown_cr15a_profile);
                    // b3_crown_cr15b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.259228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 2.259228]) linear_extrude(0.02) polygon(b3_crown_cr15b_profile);
                }
                hull() {
                    // b3_crown_cr16a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=2.259228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 2.259228]) linear_extrude(0.02) polygon(b3_crown_cr16a_profile);
                    // b3_crown_cr16b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.059228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 3.059228]) linear_extrude(0.02) polygon(b3_crown_cr16b_profile);
                }
                hull() {
                    // b3_crown_cr17a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.059228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 3.059228]) linear_extrude(0.02) polygon(b3_crown_cr17a_profile);
                    // b3_crown_cr17b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.859228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 3.859228]) linear_extrude(0.02) polygon(b3_crown_cr17b_profile);
                }
                hull() {
                    // b3_crown_cr18a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=3.859228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 3.859228]) linear_extrude(0.02) polygon(b3_crown_cr18a_profile);
                    // b3_crown_cr18b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.659228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 4.659228]) linear_extrude(0.02) polygon(b3_crown_cr18b_profile);
                }
                hull() {
                    // b3_crown_cr19a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=4.659228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 4.659228]) linear_extrude(0.02) polygon(b3_crown_cr19a_profile);
                    // b3_crown_cr19b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.459228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 5.459228]) linear_extrude(0.02) polygon(b3_crown_cr19b_profile);
                }
                hull() {
                    // b3_crown_cr20a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=5.459228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 5.459228]) linear_extrude(0.02) polygon(b3_crown_cr20a_profile);
                    // b3_crown_cr20b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.259228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.259228]) linear_extrude(0.02) polygon(b3_crown_cr20b_profile);
                }
                hull() {
                    // b3_crown_cr21a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.259228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.259228]) linear_extrude(0.02) polygon(b3_crown_cr21a_profile);
                    // b3_crown_cr21b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.559228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.559228]) linear_extrude(0.02) polygon(b3_crown_cr21b_profile);
                }
                hull() {
                    // b3_crown_cr22a: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.559228 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.559228]) linear_extrude(0.02) polygon(b3_crown_cr22a_profile);
                    // b3_crown_cr22b: crown loft station (measured; kept organic — no clean law found across stations) — measured section hull at y=6.850229 (full-width crown)
                    rotate([0, -90, -90]) translate([0, 0, 6.850229]) linear_extrude(0.02) polygon(b3_crown_cr22b_profile);
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
