clear
close all
rng(1216)

load settlement.mat

% Generate buffered matrix of movable locations
mountains = 1 - atlantis.mountains.impassable;
% mountains(find(mountains == 0)) = - Inf;
badland = atlantis.land.mask;
% badland(find(badland==0)) = -Inf;
buffer = mountains .* badland;

T = 4000/25;

% distances from original landing, which we'll use to determine who gets to 
% migrate first. Gridcells with migrants furthest away from the "Plymouth Rock"
% are allowed to migrate first.
dist_mat = zeros([size(lat, 1) size(lon, 2)])
for x = 1:size(dist_mat, 1) 
    for y = 1:size(dist_mat, 2)
        dist_mat(x, y) = atldist([find(lat == 4) find(lon == -9)], [x y]);
    end
end
[A, I] = sort(dist_mat(:), 'descend')
[row,col] = ind2sub(size(dist_mat), I)
idx = [row  col]

% Initialize matrices for each variable in the system

% Population
H_ds = zeros([size(lat, 1) size(lon, 2)  T]);
H_ds(find(lat == 4), find(lon == -9), 1) = 20;

% Ecosystem health
E_ds = zeros([size(lat, 1) size(lon, 2)  T]);
E_ds(:,:,1) = atlantis.ecop;

% Carrying capacity
K_ds = zeros([size(lat, 1) size(lon, 2)  T]);
K_ds(:,:,1) = arrayfun(@atlantis_newag, E_ds(:,:,1), atlantis.rain, atlantis.rivers.flow);

% Deaths from disease and starvation
deaths = zeros(size(K_ds));
starved = zeros(size(K_ds));
% atlantis_neweco(eco, P, K, H)D_tp1, K_tp1)

% Iterate through each time step
for t = 2:T

    % Update values for E, K
    E_ds(:,:,t) = arrayfun(@atlantis_neweco, E_ds(:,:,t-1), atlantis.ecop, K_ds(:,:,t-1), H_ds(:,:,t-1));
    K_ds(:,:,t) = arrayfun(@atlantis_newag, E_ds(:,:,t), atlantis.rain, atlantis.rivers.flow);

    % Update population, also getting the number of potential migrants (subject
    % to available space) and deaths due to disease.
    [H_ds(:,:,t), migrants, deaths(:,:,t)] = arrayfun(@atlantis_newpop, H_ds(:,:,t-1), atlantis.disease, K_ds(:,:,t));
    
    % Loop through grid cells, starting with the furthest from Plymouth Rock, and
    % determine where migrants will go. They will choose the grid cell with the 
    % most "space" (i.e., K_j - H_j). Those who can't "fit" in that cell go to the
    % cell with the next most space, etc. If all adjacent cells are at capacity,
    % the remaining migrants starve.
    for i = 1:size(idx, 1)    
        [allocation, starving] = atlantis_migrate(idx(i,:), migrants, H_ds(:,:,t), K_ds(:,:,t), buffer);
        starved(idx(i,1),idx(i,2), t) = starving; 
        H_ds(:,:,t) = H_ds(:,:,t) + allocation;
    end
end

% All-cause mortality = disease + sarved
all_mort = deaths + starved;


year = [100 500 1000 1500 3000 4000]/25;
% Plots (years 100 - 1000)
i = 0;
tiledlayout(3,3,'TileSpacing','Compact','Padding','Compact')
for t = 1:3:7
    i = i + 1;
    % subplot(3, 3, t)
    nexttile
    imagesc(lon, lat, H_ds(:, :, year(i)))
    axis xy
    colorbar
    caxis([0 800])
    ylabel('Lat');
    if (year(i)*25 == 1000)
        xlabel('Lon');
    end
    title(strcat('Population, year=', num2str(year(i)*25)));

    % subplot(3, 3, t+1)
    nexttile
    imagesc(lon, lat, E_ds(:, :, year(i)))
    axis xy
    colorbar
    caxis([0 1])
    if (year(i)*25 == 1000)
        xlabel('Lon');
    end
    title(strcat('Ecosystem health, year=', num2str(year(i)*25)));

    % subplot(3, 3, t+2)
    nexttile
    imagesc(lon, lat, all_mort(:, :, year(i)))
    axis xy
    colorbar
    caxis([0 800])
    if (year(i)*25 == 1000)
        xlabel('Lon');
    end
    title(strcat('All-cause mortality, year=', num2str(year(i)*25)));
end
saveas(gcf, 'PS5_3_F1', 'png');

% Plots (years 1500 - 4000)
h = figure
i = 3
tiledlayout(3,3,'TileSpacing','Compact','Padding','Compact')
for t = 1:3:7
    i = i + 1;
    % subplot(3, 3, t)
    
    nexttile
    imagesc(lon, lat, H_ds(:, :, year(i)))
    axis xy
    colorbar
    caxis([0 800])
    ylabel('Lat');
    if (year(i)*25 == 4000)
        xlabel('Lon');
    end
    title(strcat('Population, year=', num2str(year(i)*25)));

    % subplot(3, 3, t+1)
    nexttile
    imagesc(lon, lat, E_ds(:, :, year(i)))
    axis xy
    colorbar
    caxis([0 1])
    if (year(i)*25 == 4000)
        xlabel('Lon');
    end
    title(strcat('Ecosystem health, year=', num2str(year(i)*25)));

    % subplot(3, 3, t+2)
    nexttile
    imagesc(lon, lat, all_mort(:, :, year(i)))
    axis xy
    colorbar
    caxis([0 800])
    if (year(i)*25 == 4000)
        xlabel('Lon');
    end
    title(strcat('All-cause mortality, year=', num2str(year(i)*25)));
end
saveas(gcf, 'PS5_3_F2', 'png');


% Generate .gif file.
h = figure;
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [12 4]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'atlantis.gif';

for t = [1:T]
    disp('again!')
    % subplot(1, 3, 1)
    tiledlayout(1,3,'TileSpacing','Compact','Padding','Compact')
    nexttile
    imagesc(lon, lat, H_ds(:, :, t))
    axis xy
    colorbar
    caxis([0 800])
    ylabel('Lat');
    xlabel('Lon');
    title(strcat('Population, year=', num2str(t*25)));

    % subplot(1, 3, 2)
    nexttile
    imagesc(lon, lat, E_ds(:, :, t))
    axis xy
    colorbar
    caxis([0 1])
    ylabel('Lat');
    xlabel('Lon');
    title(strcat('Ecosystem health, year=', num2str(t*25)));

    % subplot(1, 3, 3)
    nexttile
    imagesc(lon, lat, all_mort(:, :, t))
    axis xy
    colorbar
    caxis([0 800])
    ylabel('Lat');
    xlabel('Lon');
    title(strcat('All-cause mortality, year=', num2str(t*25)));

    drawnow 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    if t == 1 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
        imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    end 
end



