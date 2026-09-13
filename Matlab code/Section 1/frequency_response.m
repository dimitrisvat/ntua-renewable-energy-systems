function frequency_response(WT, v_vec, Pout_W)

% Given data
f_nom = 50;            % Nominal frequency [Hz]
f_th  = 50.2;          % Threshold frequency [Hz]
droop = 0.05;          % 5% droop

% Frequency points
t_s = [6.7, 8.6, 12.6];
f_Hz = [50.62, 50.40, 50.06];    

% Initial output power
Pout_0 = 2e6;                     

% Wind speed assumed constant (hub height)
mask = (v_vec >= WT.V_cutin_ms) & (v_vec <= WT.v_rated);

v_operating = v_vec(mask);
P_operating = Pout_W(mask);

v = interp1(P_operating, v_operating, Pout_0, 'linear');

% Aerodynamics
Pwind = 0.5 * WT.rho_air * WT.A_m2 * v^3;

% Losses at rated speed
Prot_loss = 1000 * (-5 + 7*WT.NR_rated_rpm);

% Preallocate
Pout = zeros(size(f_Hz));
beta = zeros(size(f_Hz));
NR = zeros(size(f_Hz));

for k = 1:length(f_Hz)

    f = f_Hz(k);

    NR(k) = WT.lambda_opt * v / WT.R_rotor_m * 60 / (2*pi);

    % Droop control
    if f > f_th
        delta_f = f - f_th;
        deltaP = -(1/droop) * (delta_f / f_nom) * WT.Pout_rated_W;
    else
        deltaP = 0;
    end

    Pout(k) = max(Pout_0 + deltaP, 0);

    % Required Cp including losses
    Cp_req = (Pout(k)/WT.effi + Prot_loss) / Pwind;

    if(Cp_req > WT.Cp_max)
        Cp_req = WT.Cp_max;
    else

        % Solve for beta using Cp
        fun = @(b) abs(WT.Cp(WT.lambda_opt, b) - Cp_req);
        beta(k) = fminbnd(fun, WT.beta_min_deg, WT.beta_max_deg);
    end
end

% Output table
results = table(t_s(:), f_Hz(:), Pout(:)/1e6, NR(:), beta(:), 'VariableNames', {'t_s','f_Hz','Pout_MW','NR_rpm','beta_deg'});

disp('Q5 results:');
disp(results);

end
