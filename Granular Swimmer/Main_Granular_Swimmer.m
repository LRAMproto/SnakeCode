clc
clear all

% Initial Values
S.L = 1;                   % The link length
S.r = 0.2;                 % The radius of the cylinder
S.K = 0.5;                 % The differential viscous drag constant
S.C_S = 7.70;              % Granular parameter
S.C_F = 2.79;              % Granular parameter
S.C_L = -2.03;             % Granular parameter
S.gama = 1.57;             % Granular parameter
S.Range = 8;               % Number of segments in each link for integrating
S.Model = 'real_model';

% Shape Velocity
dalpha1 = linspace(-1,1,5);
dalpha2 = linspace(-1,1,5);

% Range of variation of alpha (shape change)
R_alpha1 = linspace(-2.5,2.5,5);
R_alpha2 = linspace(-2.5,2.5,5);

target = fullfile(pwd,'Main_Granular_Swimmer.m');

%path to 'granular_data' folder
addpath(genpath('granular_data'))

% This section calculate the body velocity for low Reynolds swimmer in
% order to have it as an initial guess for solving nonlinear eqauations of
% granular swimmer
BodyVelocityfile = 'Initial_Body_Velocity.mat';

if exist(BodyVelocityfile,'file')

    % Load the Local_Connection file
    load('Initial_Body_Velocity');
    
    subfile = fullfile(pwd,'granular_data',BodyVelocityfile);
    
    dcheck = depcheck(target,subfile);
    

elseif ~exist(BodyVelocityfile,'file')
    
    Xi0.x = cell(length(R_alpha1),length(R_alpha2));
    Xi0.y = cell(length(R_alpha1),length(R_alpha2));
    Xi0.theta = cell(length(R_alpha1),length(R_alpha2));

    for i = 1:length(R_alpha1)

        for j = 1:length(R_alpha2)

            alpha = [R_alpha1(i); R_alpha2(j)];

            Xi = Connection_Vector_Solver_Low_Reynolds_Swimmer(S,alpha,[dalpha1; dalpha2]);
            
            Xi0.x{i,j} = Xi.x;
            Xi0.y{i,j} = Xi.y;
            Xi0.theta{i,j} = Xi.theta;
            
            Current_path = pwd;
            dp = fullfile(Current_path,'granular_data');

            cd(dp)
            
            save('Initial_Body_Velocity.mat','Xi0')

            cd(Current_path)        

        end

    end

end

Ite = 0;    % Number if iteration for shape change
A1 = cell(length(R_alpha1),length(R_alpha2));
Mp = cell(length(dalpha1),length(dalpha2));

for i = 1:length(R_alpha1)

    for j = 1:length(R_alpha2)
            
        Xi.x = Xi0.x{i,j};
        Xi.y = Xi0.y{i,j};
        Xi.theta = Xi0.theta{i,j};
        alpha = [R_alpha1(i); R_alpha2(j)];
        
        [A,C_data,C_ellipse_data] = Connection_Vector_Solver(Xi,S,alpha,[R_alpha1; R_alpha2],[dalpha1; dalpha2]);

        A1{i,j} = A;
        Contour_data{i,j} = C_data;
        Contour_ellipse_data{i,j} = C_ellipse_data;

    end
     
end


Ar_woven = cell2mat(A1);

%Rearrange the A matrix
Ar = [ Ar_woven(1:3:end,1:2:end) Ar_woven(1:3:end,2:2:end);
	   Ar_woven(2:3:end,1:2:end) Ar_woven(2:3:end,2:2:end);
	   Ar_woven(3:3:end,1:2:end) Ar_woven(3:3:end,2:2:end)];


[alpha1,alpha2] = ndgrid(R_alpha1,R_alpha2);

Ax1 = Ar_woven(1:3:end,1:2:end);
Ax2 = Ar_woven(1:3:end,2:2:end);

Ay1 = Ar_woven(2:3:end,1:2:end);
Ay2 = Ar_woven(2:3:end,2:2:end);

Atheta1 = Ar_woven(3:3:end,1:2:end);
Atheta2 = Ar_woven(3:3:end,2:2:end);

LocalConnectionMatrix = 'Local_Connection_Matrix.mat';

if exist(LocalConnectionMatrix,'file')

    % Load the Local_Connection file
    load('Local_Connection_Matrix');

else

    Current_path = pwd;
    dp = '\Users\Hossein\Documents\MATLAB\Dr Hatton Snake Robot\GeometricSystemPlotter\UserFiles\v4\Hossein\Systems';

    cd(dp)

    save('Local_Connection_Matrix','Ax1','Ax2','Ay1','Ay2','Atheta1','Atheta2','alpha1','alpha2')

    cd(Current_path)

end

Vecfield = cell(2,1);

[Vecfield{:}] = ndgrid(R_alpha1);

% This function get the metric and grid for shape angles and plot ellipse
% field of a metric tensor (Mp)
h = metricellipsefield_power1(Vecfield{1},Vecfield{2},Contour_data,'tissot',{});


figure(4)
quiver(alpha1,alpha2,Ar_woven(1:3:end,1:2:end),Ar_woven(1:3:end,2:2:end))
axis equal
xlabel('\alpha_1');
ylabel('\alpha_2');

figure(5)
quiver(alpha1,alpha2,Ar_woven(2:3:end,1:2:end),Ar_woven(2:3:end,2:2:end))
axis equal
xlabel('\alpha_1');
ylabel('\alpha_2');

figure(6)
quiver(alpha1,alpha2,Ar_woven(3:3:end,1:2:end),Ar_woven(3:3:end,2:2:end))
axis equal

xlabel('\alpha_1');
ylabel('\alpha_2');
axis square