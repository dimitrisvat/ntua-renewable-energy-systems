%% MATLAB script for the first section of the semester project for Renewable energy sources

clear; 
clc; 
close all;

%% Wind Turbine parameters

WT = struct();

% Rotor / Geometry
WT.NR_rated_rpm   = 11;                 % Rated rotor speed [rpm]
WT.D_rotor_m      = 136;                % Rotor diameter [m]
WT.R_rotor_m      = WT.D_rotor_m/2;     % Rotor radius [m]
WT.H_hub_m        = 120;                % Hub height [m]
WT.A_m2           = pi*WT.R_rotor_m^2;  % Swept area [m^2]

% Generator
WT.gear_ratio     = 40;                 % Gearbox ratio (1:40)
WT.P_poles        = 12;                 % Number of generator poles
WT.p_pairs        = WT.P_poles/2;       % Pole pairs
WT.effi           = 0.96;               % Generator and converter efficiency
WT.Vgrid_LL_rms   = 400;                % Grid side line-line RMS voltage [V]

% Operating limits
WT.V_cutin_ms     = 3;                  % Cut-in wind speed [m/s]
WT.V_cutout_ms    = 26;                 % Cut-out wind speed [m/s]
WT.beta_min_deg   = 0;                  % Minimum pitch angle [deg]
WT.beta_max_deg   = 40;                 % Maximum pitch angle [deg]

% Wind / Air
WT.rho_air        = 1.225;              % Air density [kg/m^3]
WT.alpha_shear    = 0.15;               % Wind shear exponent [-]


%%  Cp and beta

% Tip Speed Ratio: lambda = omega*R / v
WT.lambda = @(NR_rpm, v_ms) ...
    ((NR_rpm*2*pi/60) * R_rotor_m) ./ v_ms;

% Intermediate lambda_i
WT.lambda_i = @(lam, beta_deg) ...
    1 ./ ( (1./(lam + 0.08*beta_deg)) - (0.035./(beta_deg.^3 + 1)) );

% Power coefficient Cp(lambda, beta)
WT.Cp = @(lam, beta_deg) ...
    0.5176 .* ( (116./WT.lambda_i(lam,beta_deg)) - 0.4*beta_deg - 5 ) .* exp(-21./WT.lambda_i(lam,beta_deg)) + 0.0068 .* lam;

[WT.lambda_opt, WT.Cp_max] = Cp_vs_lambda(WT, 0);

%% 1.1 Generator-side Frequency vs Rotor speed

[f_gen_max, NR_cutin_rpm] = generator_frequency(WT);

%% 1.2 Output power vs Rotor speed

[WT.Pout_rated_W] = output_power_vs_NR(WT, NR_cutin_rpm);

%% 1.3 Output power curve and pitch control curve vs wind speed

[v_vec_Pout, Pout_W, WT.v_rated, WT.omega_rated ] = power_vs_wind(WT);
[v_vec_beta, beta_vec] = pitch_vs_wind(WT);

%% 1.4 Power, Rotor speed and Beta for a 10-minute wind speed window

simulate_time_series(WT, v_vec_beta, beta_vec);

%% 1.5 Power, Rotor speed and Beta for a frequency disturbance of WT

frequency_response(WT, v_vec_Pout, Pout_W);