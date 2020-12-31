function [eco_tp1] = update_ecohealth(eco, P, K, H)
    % Updates ecosystem health for a single grid cell.
    
    if (P == 0 | K ==0 )
        eco_tp1 = 0;
    else
        r_E = abs(0.33 * P * ( 1 - (H/(2*K))));
        eco_tp1 = eco + r_E * (1 - (eco/P)) - 0.5* eco * (H/K);
    end