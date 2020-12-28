function [migration, starving] = atlantis_migrate(coord, migrants, H, K, buffer)
    % Handles migration decisions as described in report.

    x = coord(1); y = coord(2);
    if (buffer(x, y) == 0)
        migration = 0;
        starving = 0;
    else
        buff = buffer(x-1:x+1, y-1:y+1);
        buff = (K(x-1:x+1, y-1:y+1) - H(x-1:x+1, y-1:y+1)).*buff;
        mig = migrants(x, y);
        allocation = zeros(size(buff));
        for i = 1:8
            if (mig > 0)
                [m, max_ind] = sort(buff(:), 'descend');
                if (m == 0)
                    continue
                end
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
        starving = mig;
        migration = zeros(size(H(:,:)));
        migration(x-1:x+1, y-1:y+1) = allocation;
    end

