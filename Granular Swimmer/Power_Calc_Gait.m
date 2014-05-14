clear all
clc
% Integrate through different shape change and shape velocity to calculate
% the power on a desire gait.

current_directory = pwd;

dp = 'C:\Users\Hossein\Documents\MATLAB\Dr Hatton Snake Robot\GeometricSystemPlotter\UserFiles\v4\Hossein\sysplotter_data\v4.1\';

cd(dp)

gait = 'sysf_granular_swimmer__shchf_circle_1p25.mat';

cd(current_directory)

if exist(gait,'file')
    
    load(gait)
    
end

alpha = p.phi_locus_full{1}.shape;
dalpha = p.dphi_locus{1}{1}.shape;

for i = 1:length(alpha)

    P(i) = Main_Granular_Swimmer(alpha(i,:),dalpha(i,:));
    

end

P_total = trapz((p.time_full{1}).^2,P')

