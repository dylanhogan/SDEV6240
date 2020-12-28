function [ds] = simulate_pop(demog, T)
    ds = zeros([size(demog,1) size(demog,2) T]);
    ds(:,:,1) = demog;
    for t = 2:T
        ds(:,:,t) = increment_year(ds(:,:,t-1));
    end