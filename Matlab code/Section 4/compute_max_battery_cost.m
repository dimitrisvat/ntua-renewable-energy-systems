function K0_eq_lim = compute_max_battery_cost(KTP_value, params)

K0_eq_lim = 0;

for t = 1:params.N
    K0_eq_lim = K0_eq_lim + KTP_value / (1 + params.ke)^t;
end

fprintf('\nBattery Cost Limit\n');
fprintf('KTP: %.2f EUR/year\n', KTP_value);
fprintf('K0_eq_lim (max cost): %.2f EUR\n', K0_eq_lim);
end
