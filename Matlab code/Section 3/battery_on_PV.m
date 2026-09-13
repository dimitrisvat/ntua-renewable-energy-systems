function pv_net = battery_on_PV(params, data)

% Indices for charge/discharge hours
idx13 = 13 : 24 : 8760;   % 13:00 every day
idx20 = 20 : 24 : 8760;   % 20:00 every day

% Charge energy from PV at 13:00
E_from_PV_13 = data.pv_raw(idx13);            
E_ch_13 = min(E_from_PV_13, params.Pbat);      % power limit 
E_ch_13 = min(E_ch_13, params.Ebat);           % energy capacity limit\

% Build hourly vectors
E_ch_vec  = zeros(size(data.pv_raw));
E_dis_vec = zeros(size(data.pv_raw));

E_ch_vec(idx13)  = E_ch_13;                    % charge at 13:00
E_dis_vec(idx20) = params.effi * E_ch_13;      % discharge at 20:00 (same day)

% Net PV after battery
pv_net = data.pv_raw - E_ch_vec + E_dis_vec;

end
