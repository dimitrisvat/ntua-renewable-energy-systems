function [f_max, NR_cutin_rpm] = generator_frequency(WT)

% Generator frequency function
f_gen = @(NR_rpm) (WT.p_pairs .* (WT.gear_ratio .* NR_rpm)) / 60;  

% Cut-in rotor speed
omega_cutin = (WT.lambda_opt * WT.V_cutin_ms) / WT.R_rotor_m; 
NR_cutin_rpm = omega_cutin * 60/(2*pi);                   

% Maximum frequency at rated speed
f_max = f_gen(WT.NR_rated_rpm);

fprintf('  lambda_opt = %.3f\n', WT.lambda_opt);
fprintf('  Cut-in rotor speed = %.2f rpm\n', NR_cutin_rpm);
fprintf('  Maximum generator frequency at rated speed = %.2f Hz\n', f_max);

% Rotor speed range
NR_vec = linspace(0, WT.NR_rated_rpm, 500);
f_vec  = f_gen(NR_vec);

% Zero frequency below cut-in speed
f_vec(NR_vec < NR_cutin_rpm) = 0;

% Plot
figure;
plot(NR_vec, f_vec, 'LineWidth', 2);
grid on;
xlabel('Rotor speed N_R [rpm]');
ylabel('Generator-side frequency f_{gen} [Hz]');
title('Generator-side vs Rotor Speed');
xlim([0 WT.NR_rated_rpm]);
ylim([0 f_max]);

% Save figure
saveas(gcf, fullfile(fullfile(pwd, 'Figures'), 'fgen_vs_NR.png'));

end
