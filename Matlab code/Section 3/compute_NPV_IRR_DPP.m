function out = compute_NPV_IRR_DPP(pv_inj, price, params, hasBattery)

% CAPEX 
capex_pv  = params.cost_PV * (params.Pnom_PV * 1000);
capex_bat = hasBattery * params.cost_BAT * (params.Ebat * 1000);
K0 = capex_pv + capex_bat;

K0_Eq = params.Pe * K0;

A = K0 / params.N;

% Energy revenue
E_t = sum(pv_inj.*params.gov_price.*(price>0));

% Loan
t = (1:params.N)';

Kd = params.Pd * K0;
X  = zeros(params.N,1);
T  = zeros(params.N,1);

if params.Nd > 0 && Kd > 0
    DD = (params.kd + params.kd / ((1+params.kd)^params.Nd - 1)) * Kd;

    t_limited = t <= params.Nd;

    X(t_limited) = (params.kd / ((1+params.kd)^params.Nd - 1)) * Kd .* (1+params.kd).^(t(t_limited)-1);

    T(t_limited) = DD - X(t_limited);
end

% Operating costs
LD = params.maint_cost * K0 .* (1 + params.infl).^(t) + params.special_fee * sum(pv_inj);

% KTP
Profit = E_t - LD - A - T;
KTP = Profit .* (1 - params.taxRate) + A - X;

% NPV
YA_N = params.residual;
NPV = -K0_Eq + sum( KTP ./ (1 + params.ke).^t) + YA_N / (1 + params.ke)^params.N;

% IRR 
irr_fun = @(r) -K0_Eq + sum( KTP ./ (1+r).^t);
IRR = fzero(irr_fun, 0.1);

%DPP
sum1 = -K0_Eq;

for t = 1:params.N
    sum1 = sum1 + KTP(t) / (1 + params.ke)^t;
    if sum1 >= 0
        DPP = t;
        break;
    end
end

% Results
out.NPV = NPV;
out.IRR = IRR;
out.DPP = DPP;

fprintf('\n[FIN – Equity Evaluation]\n');
fprintf('NPV  = %.2f €\n', NPV);
fprintf('IRR  = %.2f%%\n',100*IRR);
fprintf('DPP  = %.2f years\n', DPP);

end