function result = compute_cost_noPV(E_load, params)

% Compute energy cost per month
C_energy = E_load .* (params.c_sup + params.c_tr + params.c_distE + params.c_oth + params.c_etm + params.c_yko + params.c_efk);
C_power  = params.c_distP * params.Pcontr .* (30/365);

C_base_spec = E_load .* (params.c_sup + params.c_tr + params.c_distE + params.c_oth + params.c_yko + params.c_efk - params.c_etm) + C_power;

C_spec  = params.k_spec .* C_base_spec;
C_total = C_energy + C_power + C_spec;

% Print table
Month = (1:12)';
T = table(Month, E_load, C_total, 'VariableNames', {'Month','Consumption','Cost'});

disp(T);

% Store results
result.monthly_cost = C_total;
result.annual_cost  = sum(C_total);

end
