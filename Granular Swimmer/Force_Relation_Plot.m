clc
clear all
L = 1;               % The link length
K = 0.5;             % The differential viscous drag constant
S.C_S = 7.70;        % 
S.C_F = 2.79;        %
S.C_L = -2.03;       %
S.gama = 1.57; 

% "Psi" is the angle between the axis of the element and instantaneous
% velocity
psi = linspace(0,pi/2,20);

for i = 1:length(psi)



V = 1;
Xi1(i) = V*cos(psi(i));
Xi2(i) =  tan(psi(i))*Xi1(i);% - (alpha(1));   % For link 1

% gama is a constant parameter
beta0(i) = atan(S.gama*sin(psi(i)));


% Drag Forces for Low Reynolds Rod
Fx_LR(i) = K*L*Xi1(i);
Fy_LR(i) = 2*K*L*Xi2(i);
% M = (2/3)*K*(L^3)*Xi1(3);

% Drag Forces in Granular Environment
% C_F, C_L, C_F are constant parameters obtained from experience 

Fx(i) = (S.C_F*cos(psi(i)) + S.C_L*(1 - sin(psi(i))))*0.5/1.4121;
Fy(i) = S.C_S*sin(beta0(i))*0.5/1.4121;

end

plot(psi,Fx_LR,'-+','color','red','LineWidth',2)

hold on
plot(psi,Fy_LR,'-.','color','green','LineWidth',2)
hold on
plot(psi,Fx,'-p','color','black','LineWidth',2)
hold on
plot(psi,Fy,'-o','color','blue','LineWidth',2)

legend('Fx (Viscous)','Fy (Viscous)','Fx (Granular)','Fy (Granular)')
xlabel('\psi')