function [v_vec, Pout_W, v_rated, omega_rated] = power_vs_wind(WT)

% Rated rotor speed
omega_rated = WT.NR_rated_rpm * 2*pi/60;

% Rated wind speed (MPPT)
v_rated = (omega_rated * WT.R_rotor_m) / WT.lambda_opt;

% Rated power
Pwind_r = 0.5 * WT.rho_air * WT.A_m2 * v_rated^3;
Pmech_r = WT.Cp_max * Pwind_r;
Prot_r  = 1000 * (-5 + 7*WT.NR_rated_rpm);
Pout_rated_W = WT.effi * (Pmech_r - Prot_r);

v_vec = linspace(0, WT.V_cutout_ms, 500);
Pout_W = zeros(size(v_vec));

for k = 1:length(v_vec)
    v = v_vec(k);

    if v < WT.V_cutin_ms
        Pout_W(k) = 0;

    elseif v <= v_rated
        Pout_W(k) = Pout_rated_W * (v/v_rated)^3;

    elseif v <= WT.V_cutout_ms
        Pout_W(k) = Pout_rated_W;
    end
end

figure;
plot(v_vec, Pout_W/1e6, 'LineWidth', 2);
grid on;
xlabel('Wind speed V_w [m/s]');
ylabel('Output power P_{out} [MW]');
title('Wind turbine power curve');
xlim([0 WT.V_cutout_ms]);

% Save figure
saveas(gcf, fullfile(fullfile(pwd,'Figures'),'Pout_vs_wind.png'));

end
