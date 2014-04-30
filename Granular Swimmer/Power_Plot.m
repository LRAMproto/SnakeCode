function [P,C,Reg_C] = Power_Plot(T1,T2,dalpha,n)
% This function plot the contour of the Power dissipated through the joints
% as a function of shape velocities for determined shape angles
dalpha1 = dalpha(1,:);
dalpha2 = dalpha(2,:);

for i = 1:length(dalpha1)
    
    for j = 1:length(dalpha2)
        
        dalpha = ([dalpha1(i);dalpha2(j)]);

        P(i,j) = dalpha' * [T1(i,j);T2(i,j)];
        P1(i,j) = dalpha(1)' * T1(i,j);
        P2(i,j) = dalpha(2)' * T2(i,j);
            
    end
    
end

[dalpha1,dalpha2] = ndgrid(dalpha1,dalpha2);

% This function estimate the bowl shape power as an elliptic power
Reg_P = elliptic_power_estimation(P,dalpha1,dalpha2);


% Extract the data from the contour in specific power
figure(1)
% [C,h] = contour(dalpha1,dalpha2,P,[2*n+2 2*n+2]);
[C,h] = contour(dalpha1,dalpha2,P,[4 4]);

figure(10)
[Reg_C,Reg_h] = contour(dalpha1,dalpha2,Reg_P,[4 4]);


figure(2)
contour3(dalpha1,dalpha2,P);
xlabel('d\alpha_1');
ylabel('d\alpha_2');
zlabel('Power');
axis equal
axis square

figure(3)
surf(dalpha1,dalpha2,P)

xlabel('d\alpha_1');
ylabel('d\alpha_2');
zlabel('Power')
axis equal
axis square

figure(4)
surf(dalpha1,dalpha2,Reg_P)

xlabel('d\alpha_1');
ylabel('d\alpha_2');
zlabel('Power')
axis equal
axis square


figure(5)
contour3(dalpha1,dalpha2,Reg_P);
xlabel('d\alpha_1');
ylabel('d\alpha_2');
zlabel('Power');
axis equal
axis square


% figure(3)
% surf(dalpha1,dalpha2,P)
% 
% xlabel('d\alpha_1');
% ylabel('d\alpha_2');
% zlabel('Power')
% axis equal
% axis square
% 
% figure(7)
% surf(dalpha1,dalpha2,P1)
% 
% xlabel('d\alpha_1');
% ylabel('d\alpha_2');
% zlabel('Power1')
% axis equal
% axis square
% 
% 
% figure(8)
% surf(dalpha1,dalpha2,P2)
% 
% xlabel('d\alpha_1');
% ylabel('d\alpha_2');
% zlabel('Power2')
% axis equal
% axis square
% 
% 
% figure(4)
% surf(dalpha1,dalpha2,T1)
% 
% xlabel('d\alpha_1');
% ylabel('d\alpha_2');
% zlabel('T1')
% axis equal
% axis square
% 
% 
% figure(5)
% surf(dalpha1,dalpha2,T2)
% 
% xlabel('d\alpha_1');
% ylabel('d\alpha_2');
% zlabel('T2')
% axis equal
% axis square