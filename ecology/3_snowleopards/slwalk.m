function [delta_x, delta_y] = slwalk(array)
    flat = reshape(array, 1, []);
    prob = exp(flat)/sum(exp(flat));
    cp = [0, cumsum(prob)];
    r = rand;
    ind = find(r>cp, 1, 'last');
    out = zeros(size(prob)); out(ind) = 1;
    dims = size(array);
    rwalk = reshape(out, dims(1), dims(2));
    [ Y_move, X_move ] = meshgrid(-1:1, -1:1);
    delta_x = sum(rwalk .* X_move, 'all');
    delta_y = sum(rwalk .* Y_move, 'all');