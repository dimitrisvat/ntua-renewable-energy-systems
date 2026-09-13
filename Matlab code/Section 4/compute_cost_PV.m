function res = compute_cost_PV(E_load, CF_pct, v_inj, s, params)

% Compute energy cost per month with PV
hours = 24 * 30;
CF = CF_pct / 100;

E_PV_raw = params.P_PV .* hours .* CF;

% Self-consumption cannot exceed the load:
E_self = min(s .* E_PV_raw, E_load);

E_inj  = E_PV_raw - E_self;
E_grid = E_load - E_self;

% Costs
cost_results = compute_cost_noPV(E_grid, params);
C_total = cost_results.monthly_cost;

% Credit for injected energy
Credit = E_inj .* v_inj;

% Net cost
C_net = C_total - Credit;

% Print table
Month = (1:12)';
T = table(Month, E_load, E_grid, E_inj, E_self, Credit, C_net, 'VariableNames', {'Month','Consumption','Grid_kWh','Inject_kWh','Self_kWh','Credit','Cost'});

disp(T);

fprintf('\nTotals:\n');
fprintf('Annual Grid:   %.1f kWh\n', sum(E_grid));
fprintf('Annual Inject: %.1f kWh\n', sum(E_inj));
fprintf('Annual Self: %.1f kWh\n', sum(E_self));
fprintf('Annual Credit: %.2f EUR\n', sum(Credit));
fprintf('Annual Net:    %.2f EUR\n', sum(C_net));

% Return results
res.T = T;
res.E_grid = E_grid;
res.E_inj  = E_inj;
res.E_self  = E_self;
res.Credit = Credit;
res.C_net  = C_net;
res.annual_cost = sum(C_net);
end
