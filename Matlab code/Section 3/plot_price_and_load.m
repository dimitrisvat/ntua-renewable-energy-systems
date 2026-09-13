function plot_price_and_load(data)

% Residual load
residual_load = data.load_total - data.res_generation;

% Daily average curves
price_daily = accumarray(data.hour_of_day, data.price, [], @mean);
residual_daily = accumarray(data.hour_of_day, residual_load, [], @mean);

% Plot
figure;
yyaxis left
plot(1:24, price_daily, '-o', 'LineWidth', 1.5)
ylabel('Average day-ahead market price [€/MWh]')
ylim([-200 200])

yyaxis right
plot(1:24, residual_daily, '-s', 'LineWidth', 1.5)
ylabel('Average residual load [MW]')
ylim([-6000 6000])

xlabel('Time of day')
xlim([1 24]);
grid on
title('Daily average market price and residual load')

% Save figure
saveas(gcf, fullfile(fullfile(pwd, 'Figures'), 'Dailyprice_vs_load_vs_RESgen.png'));

end