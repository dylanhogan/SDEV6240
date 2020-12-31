function [demog_tp1, outmig, deaths] = update_pop(demog, D_tp1, K_tp1)
    % Increments population 1 time step, accounting for deaths due to disease.
    % Outputs new population in the grid cell, migrants, and deaths in separate
    % objects.
    
    demog_prime = demog * 2;
    deaths = (D_tp1 * rand * 0.25) * demog_prime;
    demog_prime = demog_prime - deaths;
    if (demog_prime > K_tp1);
        outmig = demog_prime - K_tp1;
        demog_tp1 = K_tp1;
    else
        outmig = 0;
        demog_tp1 = demog_prime;
    end
