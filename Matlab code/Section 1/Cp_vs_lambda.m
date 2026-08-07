function [lambda_opt, Cp_max] = Cp_vs_lambda(WT, beta_deg)

% Lambda vector
lambda_vec = linspace(0, 20, 5000);

% Cp curve and lambda optimum
Cp_vec = WT.Cp(lambda_vec, beta_deg);

% Find where Cp is zero
cutoff = find(Cp_vec <= 0, 1, 'first');
lambda_vec = lambda_vec(1:cutoff); 
Cp_vec = Cp_vec(1:cutoff); 

% Calculate lambda optimum
[Cp_max, lambda_opt_pos] = max(Cp_vec);
lambda_opt = lambda_vec(lambda_opt_pos);

% Plot
figure;
plot(lambda_vec, Cp_vec, 'LineWidth', 2);
grid on;
xlabel('Tip-speed ratio λ');
ylabel('Power coefficient C_p');
xlim([0 max(lambda_vec)]);
title(sprintf('C_p(λ) for β = %.0f^\\circ', beta_deg));

% Save figure
figFolder = fullfile(pwd, 'Figures');
saveas(gcf, fullfile(figFolder, 'Cp_vs_lambda.png'));

end
