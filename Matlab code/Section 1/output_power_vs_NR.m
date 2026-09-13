function [Pout_rated_W] = output_power_vs_NR(WT, NR_cutin_rpm)

% Rotor speed vector
NR_vec = linspace(0, WT.NR_rated_rpm, 500);
omega_vec = NR_vec * 2*pi/60;

% MPPT
v_vec = (omega_vec * WT.R_rotor_m) ./ WT.lambda_opt;

% Wind power and captured mechanical power
Pwind_W = 0.5 * WT.rho_air * WT.A_m2 .* (v_vec.^3);
Pmech_W = WT.Cp_max .* Pwind_W;

% Rotational losses
Prot_loss_W = 1000 * (-5 + 7*NR_vec);

% Output power
Pout_W = WT.effi .* max(Pmech_W - Prot_loss_W, 0);

% Zero output below cut-in rotor speed
Pout_W(NR_vec < NR_cutin_rpm) = 0;

% Rated output power at NR_rated
omega_r = WT.NR_rated_rpm * 2*pi/60;
v_r = (omega_r * WT.R_rotor_m) / WT.lambda_opt;

Pwind_r_W = 0.5 * WT.rho_air * WT.A_m2 * v_r^3;
Pmech_r_W = WT.Cp_max * Pwind_r_W;
Prot_r_W  = 1000 * (-5 + 7*WT.NR_rated_rpm);

Pout_rated_W = WT.effi * max(Pmech_r_W - Prot_r_W, 0);

fprintf('  Rated output power at N_R = %.2f rpm: %.3f MW\n', WT.NR_rated_rpm, Pout_rated_W/1e6);

% Plot
figure;
plot(NR_vec, Pout_W/1e6, 'LineWidth', 2);
grid on;
xlabel('Rotor speed N_R [rpm]');
ylabel('Output power P_{out} [MW]');
title('Output Power vs Rotor Speed');
xlim([0 WT.NR_rated_rpm]);
ylim([0 max(Pout_W/1e6)]);

% Save figure
saveas(gcf, fullfile(fullfile(pwd, 'Figures'), 'Pout_vs_NR.png'));

end
