function LCOE = compute_LCOE(E_gen, params, hasBattery)

k_tot = params.Pd*params.kd*(1-params.taxRate) + params.Pe*params.ke;

% CAPEX
capex_pv = params.cost_PV * (params.Pnom_PV*1000);

if hasBattery
    capex_bat = params.cost_BAT * (params.Ebat*1000);
else
    capex_bat = 0;
end

K0 = capex_pv + capex_bat;

A = K0 / params.N;

PV_cost = 0;
PV_energy = 0;

for t = 1:params.N

    LD   = params.maint_cost * K0 * (1+params.infl)^(t) + params.special_fee * E_gen;

    afterTaxCost = LD * (1-params.taxRate) - A*params.taxRate;
    
    PV_cost = PV_cost + afterTaxCost/(1+k_tot)^t;

    PV_energy = PV_energy + (E_gen)/(1+k_tot)^t;
end

PV_cost = PV_cost + K0 - params.residual/(1+k_tot)^params.N;
PV_energy = PV_energy*(1-params.taxRate);

LCOE = PV_cost / PV_energy;

fprintf('\nLCOE (hasBattery = %d) %.2f €/MWh\n', hasBattery, LCOE);
end
