X = [-5:0.1:5]
Y = [-5:0.1:5]

[x,y] = meshgrid(X,Y)

z_1 = x.^2 + sin(y) + x.*y

subplot(1, 2, 1)
surf(z_1)
hold
surf(z_2)
xlabel('x')
ylabel('y')
zlabel('z')
title('Two surfaces defined in Question 1')
hold off
subplot(1, 2, 2)
zdiff = z_1 - z_2;
C = contours(x, y, zdiff, [0 0]);
xL = C(1, 2:end);
yL = C(2, 2:end);
zL = interp2(x, y, z_1, xL, yL);
line(xL, yL, zL, 'Color', 'k', 'LineWidth', 3);
xlabel('x')
ylabel('y')
title('Intersection of surfaces in the x-y plane')
saveas(gcf, 'PS4_F1', 'png');