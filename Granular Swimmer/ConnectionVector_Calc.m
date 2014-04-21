function  A = ConnectionVector_Calc(Xi,alpha,R_alpha)
% This function take the gradient from Body Velocity to obtain the local
% connection in specified shape angle and save them in a 3 by 2 matrix ...

% Make the initial condition
A = cell(3,2);



index1 = find(alpha(1) == R_alpha(1,:));
index2 = find(alpha(2) == R_alpha(2,:));

A_ini.x1 = cell(length(R_alpha(1,:)),length(R_alpha(2,:)));
A_ini.x2 = cell(length(R_alpha(1,:)),length(R_alpha(2,:)));

A_ini.y1 = cell(length(R_alpha(1,:)),length(R_alpha(2,:)));
A_ini.y2 = cell(length(R_alpha(1,:)),length(R_alpha(2,:)));

A_ini.theta1 = cell(length(R_alpha(1,:)),length(R_alpha(2,:)));
A_ini.theta2 = cell(length(R_alpha(1,:)),length(R_alpha(2,:)));


% Find the gradient vector for Body Velocity in X direction
[px1,px2] = gradient(Xi.x);

A_x1 = px1((length(px1)-1)/2);
A_x2 = px2((length(px2)-1)/2);

% Find the gradient vector for Body Velocity in Y direction
[py1,py2] = gradient(Xi.y);

A_y1 = py1((length(py1)-1)/2);
A_y2 = py2((length(py2)-1)/2);

% Find the gradient vector for Body Velocity in Theta direction
[ptheta1,ptheta2] = gradient(Xi.theta);

A_theta1 = ptheta1((length(ptheta1)-1)/2);
A_theta2 = ptheta2((length(ptheta2)-1)/2);


Localfile = 'Local_Connection.mat';

if exist(Localfile,'file')

    % Load the Local_Connection file
    load('Local_Connection');

end

% Create the 3 by 2 Local Connection matrix in which every array consists
% of 
A_ini.x1{index1,index2} = A_x1;
A_ini.x2{index1,index2} = A_x2;
A_ini.y1{index1,index2} = A_y1;
A_ini.y2{index1,index2} = A_y2;
A_ini.theta1{index1,index2} = A_theta1;
A_ini.theta2{index1,index2} = A_theta2;

A = [{A_ini.x1}  {A_ini.x2}
     {A_ini.y1}  {A_ini.y2}
     {A_ini.theta1}  {A_ini.theta2}];
 
 save('Local_Connection','A', 'A_ini')

end


