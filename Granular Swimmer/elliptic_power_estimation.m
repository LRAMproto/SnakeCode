
function [Reg_P,Metric_Tensor] = elliptic_power_estimation(P,dalpha1,dalpha2)

    Len = length(dalpha1);

    % Change the matrix of shape velocities to the vector
    Redalpha1 = (reshape(dalpha1,1,[]));
    Redalpha2 = (reshape(dalpha2,1,[]));
    Radalpha = [Redalpha1.^2' Redalpha1'.*Redalpha2' Redalpha2.^2'];

    % Cheange the matrix of body velocities to the vector
    Re_P = (reshape(P,1,[])').^2;
%     ReXi_y = reshape(Xi.y,1,[])';
%     ReXi_theta = reshape(Xi.theta,1,[])';
    

    % Use the Psedo_Inverse to find the constant of the plane equation (plane equation Xi = a*dalpha1 + b*dalpha2)
    A_Xi_x = Radalpha \ Re_P;
%     A_Xi_y = Radalpha \ ReXi_y;
%     A_Xi_theta = Radalpha \ ReXi_theta;

    Metric_Tensor = [A_Xi_x(1) 0.5*A_Xi_x(2);0.5*A_Xi_x(2) A_Xi_x(3)];
    
    for i = 1:length(dalpha1(:,1))
        for j = 1:length(dalpha1(:,1))
    
            P_test(i,j) = [dalpha1(i,1) dalpha2(1,j)']*((Metric_Tensor))*[dalpha1(i,1)'; dalpha2(1,j)];
            
        end
    end
    
    
%     Metric_Tensor = [sqrt(abs(A_Xi_x(1)))*sign(A_Xi_x(1)) sqrt(abs(A_Xi_x(2)))*sign(A_Xi_x(2)); 0 sqrt(abs(A_Xi_x(3)))*sign(A_Xi_x(3))];


    P = sqrt(abs(Radalpha*A_Xi_x));
%     Xi_y = Radalpha*A_Xi_y;
%     Xi_theta = Radalpha*A_Xi_theta;
    

    Reg_P = reshape(P,Len,Len);
%     Reg_Xi.y = reshape(Xi_y,Len,Len);
%     Reg_Xi.theta = reshape(Xi_theta,Len,Len);



end