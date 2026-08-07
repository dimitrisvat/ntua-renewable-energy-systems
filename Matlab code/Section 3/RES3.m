%% MATLAB script for the third section of the semester project for Renewable energy sources

clear; 
clc; 
close all;

%% Load data
excel_data = readtable('data_3.xlsx');

data = struct();

data.hour           = excel_data{:,1};
data.load_total     = excel_data{:,2};
data.res_generation = excel_data{:,3};
data.price          = excel_data{:,4};
data.pv_raw         = excel_data{:,5};

data.hour_of_day = mod(data.hour-1,24) + 1;

%% Parameters 
params = struct();

% PV
params.Pnom_PV = 30;                   % [MW]
params.Pconn_factor = 0.72;            % Connection limit factor
params.Pth_min = 500;                  % [MW] minimum thermal
params.P_cap = 0.72;                   % Max power limit relative to nominal

% Battery 
params.Pbat = 15;                      % [MW]
params.Ebat = 15;                      % [MWh]
params.effi = 0.85;                    % Battery charging-discharging efficiency

% Economic parameters
params.N = 20;                         % [years]
params.taxRate = 0.22;                 % Tax Rate
params.infl = 0.02;                    % Inflation
params.maint_cost = 0.025;             % Yearly maintance cost
params.special_fee = 2;                % €/MWh RES special fee
params.gov_price = 95;                     % €/MWh RES goverment bonus

% CAPEX
params.cost_PV = 500;                  % €/kW
params.cost_BAT = 120;                 % €/kWh

% Financing
params.Pd = 0.65;                      % Debt share
params.kd = 0.05;                      % Debt interest
params.Pe = 0.35;                      % Equity share
params.ke = 0.08;                      % Equity return
params.Nd = 15;                        % Loan duration

% Residual value
params.residual = 0;                   % Y_A_N


%% 3.1 Daily average of Day-Ahead Market price and residual load 

plot_price_and_load(data);

%% 3.2 PV perfromance

results_Q2 = PV_performance(params, data, data.pv_raw);

%% 3.3 PV performance with battery

pv_net_bat = battery_on_PV(params, data);
results_Q3 = PV_performance(params, data, pv_net_bat);

%% 3.4 Calculate LCOE

LCOE_Q2 = compute_LCOE(results_Q2.E_inj, params, false);
LCOE_Q3 = compute_LCOE(results_Q3.E_inj, params, true);

%% 3.5 Calculate NPV, IRR and DPP

fin_Q2 = compute_NPV_IRR_DPP(results_Q2.pv_inj, data.price, params, false);
fin_Q3 = compute_NPV_IRR_DPP(results_Q3.pv_inj, data.price, params, true);