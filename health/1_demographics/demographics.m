clear
close all
rng(1216)

age_list = 0:100;
survival_list = arrayfun(@survival, age_list);
plot(survival_list(1:end-1),'LineWidth',2)
ylabel('Survival rate');
xlabel('Age');
title('Survival rate by age');
saveas(gcf, 'PS5_1_F1', 'png');

% initialize
demog = zeros(101, 2);
demog(16, :) = [1000 1000];

ds = simulate_pop(demog, 300);

plot(squeeze(sum(ds, [1 2])), 'LineWidth',2)
hold on
plot(squeeze(sum(ds(:,1,:), [1])), 'LineWidth',2)
hold off
ylabel('Population');
xlabel('Year from beginning of simulation');
title('Simulated demographics over 300 years');
legend('Total','Female/Male');
saveas(gcf, 'PS5_1_F2', 'png');

for i = [50:50:300]
    subplot(2, 3, i/50)
    bar(sum(ds(:,:, i), [2]), 1)
    ylabel('Total population');
    xlabel('Age');
    title(strcat('t =', num2str(i)));
end

saveas(gcf, 'PS5_1_F3', 'png');


% Create gif to gut check results.
if (1 == 0)
    h = figure;
    axis tight manual % this ensures that getframe() returns a consistent size
    filename = 'testAnimated.gif';

    for i = [1:300]
        % subplot(2, 3, i/50)
        bar(sum(ds(:,:, i), [2]))
        drawnow 
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        if i == 1 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        end 
    end
end