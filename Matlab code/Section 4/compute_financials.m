function compute_financials(KTP_value, params)

% Initial investment
K0 = params.P_PV * params.cost_PV + params.cost_conn;

% Annual cash flow
KTP = KTP_value * ones(params.N,1);

% NPV and DPP
NPV  = -K0;
sum1 = -K0;
DPP  = NaN;

for t = 1:params.N
    NPV  = NPV  + KTP(t) / (1 + params.ke)^t;
    sum1 = sum1 + KTP(t) / (1 + params.ke)^t;

    if sum1 >= 0 && isnan(DPP)
        DPP = t;
    end
end

% Print results
fprintf('\nFinancial Results\n');
fprintf('KTP:   %.2f EUR/year\n', KTP_value);
fprintf('NPV:  %.2f EUR\n',NPV);
fprintf('DPP: %d years\n', DPP);
end
