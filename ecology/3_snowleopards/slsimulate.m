function [c, ds] = slsimulate(T, N_sl, sl_loc, trap_loc, runs, S_B)

    disp(strcat(num2str(N_sl),' snow leopard(s) in the ecosystem'))
    capture = zeros(T, runs);

    % Set initial locations
    % Specify density of SL in the corresponding grid cell by (N, X, Y). Where
    % N is the number of SL in grid at X and Y
    S_1 = [ N_sl sl_loc(1) sl_loc(2) ];
    init_ind = size(S_1);

    for r = 1:runs

        % Initialize data array
        DS = zeros(T, 2, N_sl);

        i = 1;
        for s = 1:init_ind(1)
            for n = 1:S_1(s,1)
                DS(1, :, i) = [S_1(s,2) S_1(s,3)];
                if (DS(1, :, i) == trap_loc)
                    capture(1, r) = 1;
                end
                for t = 2:T
                    DS(t-1, :, i);
                    loc_tm1 = DS(t-1, :, i);
                    x = loc_tm1(1); y = loc_tm1(2);
                    buff = S_B(x+1-1:x+1+1, y+1-1:y+1+1);
                    buff(2,2) = -Inf;
                    [delta_x, delta_y] = slwalk(buff);
                    DS(t, :, i) = [x + delta_x, y + delta_y];
                    if (DS(t, :, i) == trap_loc)
                        capture(t, r) = 1;
                    end
                end
                i = i + 1;
            end
        end
    end
    c = capture;
    ds = DS;

