function results = PV_performance(params, data, pv_input)

% Export capacity
export_cap = 2500 * ones(size(data.hour_of_day));
export_cap(data.hour_of_day >= 8  & data.hour_of_day < 11) = 1750;
export_cap(data.hour_of_day >= 14 & data.hour_of_day < 17) = 1750;
export_cap(data.hour_of_day >= 11 & data.hour_of_day < 14) = 1000;

% Rejected power
rejected_total = max(0, (data.res_generation + params.Pth_min) - (data.load_total + export_cap));

% Proportional rejection
pv_share = zeros(size(data.res_generation));
idx = data.res_generation > 1e-9;
pv_share(idx) = pv_input(idx) ./ data.res_generation(idx);

pv_rejected = rejected_total .* pv_share;

% Injected power
pv_inj = min(pv_input - pv_rejected, params.P_cap * params.Pnom_PV);

% Annual metrics
E_inj = sum(pv_inj);
E_raw = sum(pv_input);
E_rej = sum(pv_rejected);

CF = 100 * E_inj / (params.Pnom_PV * 8760);
Revenue = sum(pv_inj .* data.price);
AvgPrice = Revenue / E_inj;
RejectedPct = 100 * E_rej / E_raw;

% Print
fprintf('\nPV Results:\n');
fprintf('Annual injected energy: %.2f MWh\n', E_inj);
fprintf('Capacity factor: %.2f %%\n', CF);
fprintf('Annual revenue: %.2f €\n', Revenue);
fprintf('Average price: %.2f €/MWh\n', AvgPrice);
fprintf('Rejected energy: %.2f %%\n', RejectedPct);

% Store results
results.pv_inj = pv_inj;
results.E_inj = E_inj;
results.CF = CF;
results.Revenue = Revenue;
results.AvgPrice = AvgPrice;
results.RejectedPct = RejectedPct;

end
