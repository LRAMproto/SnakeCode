clear all
clc
% Integrate through different shape change and shape velocity to calculate
% the power on a desire gait.

current_directory = pwd;

% dp = 'C:\Users\Hossein\Documents\MATLAB\Dr Hatton Snake Robot\GeometricSystemPlotter\UserFiles\v4\Hossein\sysplotter_data\v4.1\';
dp = 'C:\Users\Hossein\Documents\MATLAB\Dr Hatton Snake Robot\GeometricSystemPlotter\ProgramFiles\v4.1';

cd(dp)

% gait = 'sysf_granular_swimmer__shchf_circle_1p25.mat';
gait = 'sum.mat';

if exist(gait,'file')
    
    load(gait)
    
end
cd(current_directory)

alpha = cell2mat(alpha);
dalpha = cell2mat(dalpha);
t = time;

dalpha1 = linspace(-1.5,1.5,11);
dalpha2 = linspace(-1.5,1.5,11);

[dalpha1,dalpha2] = ndgrid(dalpha1,dalpha2);




% alpha = p.phi_locus_full{1}.shape;
% dalpha = p.dphi_locus{1}{1}.shape;
% old_alpha = 0;
% old_dalpha = 0;
% old_time = 0;

for i = 1:length(alpha)

%     new_alpha = alpha(i,:) - old_alpha;
%     new_dalpha = dalpha(i,:) - old_dalpha;
%     new_time = p.time_full{1}(i) - old_time;
%     new_time(i) = t(i) - old_time;
    
%     P1 = Main_Granular_Swimmer(alpha(i,:),dalpha(i,:));
    P1 = Main_Granular_Swimmer(alpha(:,i),dalpha(:,i));
    
    P(i) = interpn(dalpha1,dalpha2,P1,dalpha(1,i),dalpha(2,i));
    
%     old_alpha = alpha(i,:);
%     old_dalpha = dalpha(i,:);
%     if i~=1
%         old_time = p.time_full{1}(i-1);
%         old_time = t(i-1);
%     end
    
    
end

P_total = sqrt(trapz((p.time_full{1}),P));

