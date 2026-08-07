%% MATLAB script for the forth section of the semester project for Renewable energy sources

clear; 
clc; 
close all;

%%  Data 
data = struct();

data.E_load = [530 440 390 310 330 520 670 570 410 370 440 520]';
data.CF_pct = [12 13 17 20 21 23 23 22 20 16 12 11]';
data.value_inj  = [0.09 0.07 0.04 0.03 0.02 0.05 0.06 0.05 0.06 0.06 0.04 0.08]';

%% Parameters 
params = struct();

% PV & load
params.P_PV   = 5;        % kW
params.Pcontr = 8;        % kW

% Tariffs
params.c_sup   = 0.14;
params.c_tr    = 0.00999;
params.c_distE = 0.00339;
params.c_oth   = 0.00007;
params.c_etm   = 0.017;
params.c_yko   = 0.0069;
params.c_efk   = 0.0022;
params.c_distP = 6.210;
params.k_spec  = 0.005;

% Financial
params.ke = 0.04;
params.N  = 25;

% Investment
params.cost_PV   = 1000;   % €/kWp
params.cost_conn = 600;    % €

%% 4.1 Calculate montly and yearly energy cost
fprintf('\nWithout PV:\n');
res_Q1 = compute_cost_noPV(data.E_load, params);

%% 4.2 Calculate montly and yearly energy cost with PV
s_PV = 0.25;
fprintf('\nWith PV:\n');
res_Q2 = compute_cost_PV(data.E_load, data.CF_pct, data.value_inj, s_PV, params);

%% 4.3
KTP = res_Q1.annual_cost - res_Q2.annual_cost;
compute_financials(KTP, params);

%% 4.4
s_PV_bat = 0.60;
fprintf('\nWith PV and batt:\n');
res_Q4 = compute_cost_PV(data.E_load, data.CF_pct, data.value_inj, s_PV_bat, params);

%% 4.5

% Additional annual saving due to battery
KTP_bat = res_Q2.annual_cost - res_Q4.annual_cost;

% Maximum acceptable battery cost from NPV = 0
K0_lim_bat = compute_max_battery_cost(KTP_bat, params);