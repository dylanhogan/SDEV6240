function [dist] = atldist(coord1, coord2)
    % simple distance formula
    dist = sqrt((coord1(1) - coord2(1))^2 + (coord1(2) - coord2(2))^2);