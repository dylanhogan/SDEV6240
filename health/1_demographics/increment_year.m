function [demog_tp1] = increment_year(demog)
    demog_tp1 = zeros(size(demog));
    survival_list = arrayfun(@survival, 0:100).';
    fert = sum(demog(16+1:35+1, 1)) * .1;
    demog_tp1(1, :) = [0.5*fert 0.5*fert];
    aged_demog = survival_list .* demog;
    demog_tp1(2:end, :) = aged_demog(1:end-1, :);