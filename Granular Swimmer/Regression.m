function [Reg_Xi] = Regression(dalpha1,dalpha2,Xi)

    Len = length(dalpha1);

    % Change the matrix of shape velocities to the vector
    Redalpha1 = reshape(dalpha1,1,[]);
    Redalpha2 = reshape(dalpha2,1,[]);
    Radalpha = [Redalpha1' Redalpha2'];

    % Cheange the matrix of body velocities to the vector
    ReXi_x = reshape(Xi.x,1,[])';
    ReXi_y = reshape(Xi.y,1,[])';
    ReXi_theta = reshape(Xi.theta,1,[])';
    
%     RegT1 = reshape(T1,1,[])';
%     RegT2 = reshape(T2,1,[])';

    % Use the Psedo_Inverse to find the constant of the plane equation (plane equation Xi = a*dalpha1 + b*dalpha2)
    A_Xi_x = Radalpha \ ReXi_x;
    A_Xi_y = Radalpha \ ReXi_y;
    A_Xi_theta = Radalpha \ ReXi_theta;

%     A_T1 = Radalpha \ RegT1;
%     A_T2 = Radalpha \ RegT2;
    


    Xi_x = Radalpha*A_Xi_x;
    Xi_y = Radalpha*A_Xi_y;
    Xi_theta = Radalpha*A_Xi_theta;
    
%     T1 = Radalpha*A_T1;
%     T2 = Radalpha*A_T2;


    Reg_Xi.x = reshape(Xi_x,Len,Len);
    Reg_Xi.y = reshape(Xi_y,Len,Len);
    Reg_Xi.theta = reshape(Xi_theta,Len,Len);
    
%     Reg_T1 = reshape(T1,Len,Len);
%     Reg_T2 = reshape(T2,Len,Len);


end