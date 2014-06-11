clc
clear all

% function P = Main_Granular_Swimmer(alpha,dalpha)

% Initial Values
S.L = 1;                   % The link length
S.r = 0.05;               % The radius of the cylinder
S.K = 0.5;                 % The differential viscous drag constant
% Body parameters
S.C_S = 7.70;              % Granular parameter
S.C_F = 2.79;              % Granular parameter
S.C_L = -2.03;             % Granular parameter
S.gama = 1.57;             % Granular parameter
% Head parameters
S.head = 0;                % If head should be considred put 1 otherwise put 0.
S.head_C_S = 42.16;        % Granular parameter
S.head_C_F = 1.87;         % Granular parameter
S.head_C_L = -1.58;        % Granular parameter
S.head_gama = 0.088;       % Granular parameter
% Cylindrical shape parameters
S.Cyl_C_S = 0.77*10^4;    % Granular parameter
S.Cyl_C_F = 0.59*10^4;    % Granular parameter
S.Cyl_gama = 12.21*pi/180;        % Granular parameter

S.Power_comparison = 0;    % If power comparison of different contour is required put 1 otherwise put 0.

S.Range = 8;               % Number of segments in each link for integrating
S.Model = 'basic_model';

% Choose whether you want to calculate power field (Power_field) or power
% for any gait (Power_for_gait)

S.power_type = 'Power_field';

if  strcmp(S.power_type,'Power_field')

    % Shape Velocity
    dalpha1 = linspace(-3,3,11);
    dalpha2 = linspace(-3,3,11);

    % Range of variation of alpha (shape change)
    R_alpha1 = linspace(-2.5,2.5,11);
    R_alpha2 = linspace(-2.5,2.5,11);

else

    dalpha1 = dalpha(1);
    dalpha2 = dalpha(2);

    R_alpha1 = alpha(1);
    R_alpha2 = alpha(2);

end

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
    
    refrence = fullfile(pwd,'granular_data',BodyVelocityfile);
    
    % This function check if the target function is older than any file it 
    % depends on, or younger than any file it produces.
    dcheck = depcheck(target,refrence);
   
end
if ~exist(BodyVelocityfile,'file') || ~dcheck
    
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
        
        [A,C_data,C_ellipse_data,Reg_C_data,Metric_Tensor,P,Reg_P] = Connection_Vector_Solver(Xi,S,alpha,[R_alpha1; R_alpha2],[dalpha1; dalpha2]);

        A1{i,j} = A;
        Contour_data{i,j} = C_data;
        Contour_ellipse_data{i,j} = C_ellipse_data;
        Contour_Reg_C_data{i,j} = Reg_C_data;
        Metric_Tensor_cell{i,j} = Metric_Tensor;
        Power_field{i,j} = P;
        Power_field_Reg{i,j} = Reg_P;
        

    end
     
end


switch S.power_type

    case 'Power_for_gait'

        % Do nothing

    case 'Power_field'
        
        Current_path = pwd;
        
        cd(fullfile(Current_path,'granular_data'));
        
        save('power_data','Power_field');
        
        cd(Current_path)

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

        % This function get the power for any shape angle and plot them as a field
        h = metricellipsefield_power1(Vecfield{1},Vecfield{2},Contour_data,'tissot',{});

        % This function get the metric and grid for shape angles and plot ellipse
        % field of a metric tensor (Mp)
        h1 = metricellipsefield(Vecfield{1},Vecfield{2},Metric_Tensor_cell,'tissot',{});

        % Rearrange the Metric Tensor
        Metric_Tensor_raw = cell2mat(Metric_Tensor_cell);
        % Metric_Tensor = [{Metric_Tensor(1:2:end,1:2:end)} {Metric_Tensor(1:2:end,2:2:end)};{Metric_Tensor(2:2:end,1:2:end)} {Metric_Tensor(2:2:end,2:2:end)}];

        % Save the Metric Tensor
        save('Granular_Metric_Tensor','Metric_Tensor_raw','alpha1','alpha2')
        
        % Save the power data
        [dalpha1,dalpha2] = ndgrid(dalpha1,dalpha2);
        save('Power_bowl_shape','Power_field','Power_field_Reg','Metric_Tensor_cell','dalpha1','dalpha2','Vecfield');


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

end