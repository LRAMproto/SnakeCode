clc
clear all                  % The link length
S.r = 0.1;
L = 1;               % The link length
K = 0.5;             % The differential viscous drag constant
S.C_S = 7.70;        % 
S.C_F = 2.79;        %
S.C_L = -2.03;       %
S.gama = 1.57; 

S.head_C_S = 42.16;        % Granular parameter
S.head_C_F = 1.87;         % Granular parameter
S.head_C_L = -1.58;        % Granular parameter
S.head_gama = 0.088;       % Granular parameter

S.Cyl_C_S = 0.77%*10^-4;    % Granular parameter
S.Cyl_C_F = 0.59%*10^-4;    % Granular parameter
S.Cyl_gama = 12.21*pi/180;        % Granular parameter

% "Psi" is the angle between the axis of the element and instantaneous
% velocity
psi = linspace(0,pi/2,20);
psi_head = pi/2 - psi;

for i = 1:length(psi)



    V = 1;
    Xi1(i) = V*cos(psi(i));
    Xi2(i) =  tan(psi(i))*Xi1(i);% - (alpha(1));   % For link 1

    % gama is a constant parameter
    beta0(i) = atan(S.gama*sin(psi(i)));

    beta0_h(i) = atan(cot(S.Cyl_gama)*(sin(psi(i))));
    beta0p_h(i) = atan(cot(S.Cyl_gama)*sin(pi/2 - psi(1)));


    beta0_head(i) = atan(S.head_gama*(sin(psi_head(i))));

    % Drag Forces for Low Reynolds Rod
    Fx_LR(i) = K*L*Xi1(i);
    Fy_LR(i) = 2*K*L*Xi2(i);
    % M = (2/3)*K*(L^3)*Xi1(3);

    % Drag Forces in Granular Environment
    % C_F, C_L, C_F are constant parameters obtained from experience 

    Fxx = (S.C_F*cos(psi(i)) + S.C_L*(1 - sin(psi(i))));%*0.5/1.4121;
    Fyy = S.C_S*sin(beta0(i));%*0.5/1.4121;

    Fx_head = 0;%(2*S.r)*(S.head_C_F*cos(psi_head(i)) + S.head_C_L*(1 - sin(psi_head(i))));
    Fy_head = 0;%(2*S.r)*(S.head_C_S*sin(beta0_head(i)));

    Fx(i) = (Fxx + Fx_head)*0.5/1.52;
    Fy(i) = (Fyy + Fy_head)*0.5/1.52;

    e=1;

    Fx_cyl(i) = 2*(L)*S.r*(S.Cyl_C_F*cos(psi(i))) + e*pi*(S.r^2)*S.Cyl_C_S*(sin(beta0p_h(i)));%*0.5/1.4121;
    Fy_cyl(i) = 2*(L)*S.r*(S.Cyl_C_S*sin(beta0_h(i)) + S.Cyl_C_F*(sin(psi(i)))) + e*pi*(S.r^2)*S.Cyl_C_F*(sin(psi(i)));%*0.5/1.4121;

end

plot(psi,Fx_LR,'-+','color','red','LineWidth',2)

hold on
plot(psi,Fy_LR,'-.','color','green','LineWidth',2)
hold on
plot(psi,Fx,'-p','color','black','LineWidth',2)
hold on
plot(psi,Fy,'-o','color','blue','LineWidth',2)
hold on
plot(psi,Fx_cyl,'--rs','color','cyan','LineWidth',2)
hold on
plot(psi,Fy_cyl,'-*','color','magenta','LineWidth',2)


legend('Fx (Viscous)','Fy (Viscous)','Fx (Granular)','Fy (Granular)','Fx (Granular_head)','Fy (Granular_head)')
xlabel('\psi')