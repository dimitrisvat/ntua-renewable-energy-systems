function simulate_time_series(WT, v_vec, beta_vec)

% Wind profile for 10 minutes
t_min = (0:0.01:10);        

v10 = zeros(size(t_min));

v10(t_min < 2) = 5;

idx = (t_min >= 2) & (t_min < 4);
v10((t_min >= 2) & (t_min < 4)) = 5 + (12-5)*(t_min(idx)-2)/(4-2);

v10((t_min >= 4) & (t_min < 7)) = 12;

idx = (t_min >= 7) & (t_min < 8);
v10(idx) = 12 + (8-12)*(t_min(idx)-7);

v10(t_min >= 8) = 8;

% Wind shear to hub height
vhub = v10 .* (WT.H_hub_m/10)^WT.alpha_shear;

% Time-series mapping
Pout_W   = zeros(size(vhub));
NR_rpm   = zeros(size(vhub));
beta_deg = zeros(size(vhub));

for k = 1:length(vhub)

    v = vhub(k);

    if v < WT.V_cutin_ms
        Pout_W(k) = 0;
        NR_rpm(k) = 0;
        beta_deg(k) = 0;

    elseif v <= WT.v_rated
        beta_deg(k) = 0;
        omega = (WT.omega_rated / WT.v_rated) * v;
        NR_rpm(k) = omega * 60/(2*pi);
        Pout_W(k) = WT.Pout_rated_W * (v/WT.v_rated)^3;

    elseif v <= WT.V_cutout_ms
        NR_rpm(k) = WT.NR_rated_rpm;
        beta_deg(k) = interp1(v_vec, beta_vec, v, 'linear', 'extrap');
        Pout_W(k) = WT.Pout_rated_W;

    else
        Pout_W(k) = 0;
        NR_rpm(k) = 0;
        beta_deg(k) = 0;
    end
end

% Plots

figure;
plot(t_min, v10, 'LineWidth', 2, 'DisplayName', 'Wind speed at 10m');
hold on;
plot(t_min, vhub, 'LineWidth', 2, 'DisplayName', 'Wind speed at 120m');
hold off;
grid on;
xlabel('Time t [min]');
ylabel('Wind speed V_w [m/s]');
title('Wind speed adjusted for hub height vs Time');
legend;
saveas(gcf, fullfile(fullfile(pwd,'Figures'),'Vw_vs_time.png'));

figure;
plot(t_min, Pout_W/1e6, 'LineWidth', 2);
grid on;
xlabel('Time t [min]');
ylabel('Output power P_{out} [MW]');
title('Output Power vs Time');
saveas(gcf, fullfile(fullfile(pwd,'Figures'),'Pout_vs_time.png'));

figure;
plot(t_min, NR_rpm, 'LineWidth', 2);
grid on;
xlabel('Time t [min]');
ylabel('Rotor speed N_R [rpm]');
title('Rotor Speed vs Time');
saveas(gcf, fullfile(fullfile(pwd,'Figures'),'NR_vs_time.png'));

figure;
plot(t_min, beta_deg, 'LineWidth', 2);
grid on;
xlabel('Time t [min]');
ylabel('Pitch angle \beta [deg]');
title('Pitch Angle vs Time');
saveas(gcf, fullfile(fullfile(pwd,'Figures'),'beta_vs_time.png'));

end
