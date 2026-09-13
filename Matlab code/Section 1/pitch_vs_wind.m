function [v_vec, beta_vec] = pitch_vs_wind(WT)

% Rotor losses
Prot_loss_W = 1000 * (-5 + 7*WT.NR_rated_rpm);  

v_vec = linspace(0, WT.V_cutout_ms, 500);
beta_vec = zeros(size(v_vec));

for k = 1:length(v_vec)
    v = v_vec(k);
    if v < WT.v_rated
        beta_vec(k) = 0;
    
    elseif v >= WT.v_rated

        lambda = (WT.omega_rated * WT.R_rotor_m) / v;
        Pwind = 0.5 * WT.rho_air * WT.A_m2 * v^3;

        Cp_req = (WT.Pout_rated_W/WT.effi + Prot_loss_W) / Pwind;
        Cp_req = min(Cp_req, 0.45); % safety clamp
    
        fun = @(beta) WT.Cp(lambda, beta) - Cp_req;
        beta_vec(k) = fzero(fun, [0 WT.beta_max_deg]);
    end
end

figure;
plot(v_vec, beta_vec, 'LineWidth', 2);
grid on;
xlabel('Wind speed V_w [m/s]');
ylabel('Pitch angle \beta [deg]');
title('Pitch control characteristic');
xlim([0 WT.V_cutout_ms]);

% Save figure
saveas(gcf, fullfile(fullfile(pwd,'Figures'),'beta_vs_wind.png'));

end
