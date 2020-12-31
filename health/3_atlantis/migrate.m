function [migration, starving] = migrate(coord, migrants, H, K, buffer)
    % Handles migration decisions as described in report.

    x = coord(1); y = coord(2);
    if (buffer(x, y) == 0)
        migration = 0;
        starving = 0;
    else
        % Isolate 3 x 3 matrix of cells surrounding coord. Each cell contains
        % available capacity
        buff = buffer(x-1:x+1, y-1:y+1);
        buff = (K(x-1:x+1, y-1:y+1) - H(x-1:x+1, y-1:y+1)).*buff;

        % store number of potential migrants in the cell.
        mig = migrants(x, y);

        % initialize 3x3 allocation matrix, which stores allocation of migrants in
        % neighboring cells
        allocation = zeros(size(buff));

        % Loop eight times.
        for i = 1:8
            if (mig > 0)
                % Sort based on available capacity.
                [m, max_ind] = sort(buff(:), 'descend');
                if (m ~= 0)                    
                    % Fill the cell and reset capacity as necessary for next loop.
                    space = buff(max_ind(1));
                    fill = space - mig;
                    if (fill >= 0)
                        allocation(max_ind(1)) = mig;
                        mig = 0;
                    else 
                        allocation(max_ind(1)) = space;
                        buff(max_ind(1)) = 0;
                        mig = mig - space;
                    end
                end
            end
        end
        starving = mig;
        migration = zeros(size(H(:,:)));
        migration(x-1:x+1, y-1:y+1) = allocation;
    end

