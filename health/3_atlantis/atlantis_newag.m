function [K] = atlantis_newag(E, Pr, R)
    % Updates K for a single grid cell.
    if (R == 1)
        K = (0.5 + E) * 1000;
    else
        W = max(Pr + 0.1 * normrnd(0, 1), 1e-5);
        K = (0.5 + E) * min(1000 * sqrt(W), 1000);
    end