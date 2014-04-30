
function Reg_P = elliptic_power_estimation(P,dalpha1,dalpha2)

    Len = length(dalpha1);

    % Change the matrix of shape velocities to the vector
    Redalpha1 = (reshape(dalpha1,1,[])).^2;
    Redalpha2 = (reshape(dalpha2,1,[])).^2;
    Radalpha = [Redalpha1' Redalpha2'];

    % Cheange the matrix of body velocities to the vector
    Re_P = (reshape(P,1,[])').^2;
%     ReXi_y = reshape(Xi.y,1,[])';
%     ReXi_theta = reshape(Xi.theta,1,[])';
    

    % Use the Psedo_Inverse to find the constant of the plane equation (plane equation Xi = a*dalpha1 + b*dalpha2)
    A_Xi_x = Radalpha \ Re_P;
%     A_Xi_y = Radalpha \ ReXi_y;
%     A_Xi_theta = Radalpha \ ReXi_theta;


    P = sqrt(Radalpha*A_Xi_x);
%     Xi_y = Radalpha*A_Xi_y;
%     Xi_theta = Radalpha*A_Xi_theta;
    

    Reg_P = reshape(P,Len,Len);
%     Reg_Xi.y = reshape(Xi_y,Len,Len);
%     Reg_Xi.theta = reshape(Xi_theta,Len,Len);



end