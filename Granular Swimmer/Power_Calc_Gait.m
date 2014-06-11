clear all
clc
% Integrate through different shape change and shape velocity to calculate
% the power on a desire gait.

current_directory = pwd;

% dp = 'C:\Users\Hossein\Documents\MATLAB\Dr Hatton Snake Robot\GeometricSystemPlotter\UserFiles\v4\Hossein\sysplotter_data\v4.1\';
dp = 'C:\Users\Hossein\Documents\MATLAB\Dr Hatton Snake Robot\GeometricSystemPlotter\ProgramFiles\v4.1';

cd(dp)

% gait = 'sysf_granular_swimmer__shchf_circle_1p25.mat';
gait = 'pathlength_data.mat';

if exist(gait,'file')
    
    load(gait)
    
end

% Get the data for the power field
cd(current_directory)
cd(fullfile(current_directory,'granular_data'));

power_data = 'power_data.mat';

if exist(power_data,'file')
    
    load('power_data');
    
end

cd(current_directory)

% Initial data needed
alpha = cell2mat(alpha);
dalpha = cell2mat(dalpha);
t = time;

dalpha1 = linspace(-3,3,11);
dalpha2 = linspace(-3,3,11);

[dalpha1,dalpha2] = ndgrid(dalpha1,dalpha2);


alpha1 = linspace(-2.5,2.5,11);
alpha2 = linspace(-2.5,2.5,11);

[alpha1,alpha2] = ndgrid(alpha1,alpha2);



% alpha = p.phi_locus_full{1}.shape;
% dalpha = p.dphi_locus{1}{1}.shape;
% t = p.time_full{1};


for j = 1:3
    for i = 1:length(alpha)

        P1 = cellfun(@(u) interpn(alpha1,alpha2,u,alpha(1,i),alpha(2,i)),Power_field,'UniformOutput', false);
        P2 = cell2mat(P1);
        P(i,j) = interpn(dalpha1,dalpha2,0.5*j*P2,0.5*j*dalpha(1,i),0.5*j*dalpha(2,i));


    end
    P_total(j) = (trapz(t./(0.5*j),P(:,j)));
end


% for j = 1:3
% 
%     for i = 1:length(alpha)
% 
% %         P1 = Main_Granular_Swimmer(alpha(i,:),dalpha(i,:));
%         P(i,j) = Main_Granular_Swimmer(alpha(:,i),j*dalpha(:,i));
% 
% %         P(i,j) = interpn(dalpha1,dalpha2,P1,dalpha(1,i)*0.5*j,dalpha(2,i)*0.5*j);
% %         P(i,j) = interpn(dalpha1,dalpha2,P1,dalpha(1,i),dalpha(2,i));
% 
%     end
% 
% %     P_total(j) =  trapz(t(2:end),P(:,j).*(t(2:end)'./j));
%     P_total(j) = (trapz(t./j,P(:,j)));
% 
% end

P = trapz(t,P);
ds = trapz(t,ds);
plot(1.5,P_total,'*')
hold on
plot(1.5,ds,'+','color','k')
xlabel('Amplitude');
ylabel('Pdt & ds');
% legend('Pdt (d\alpha = d\alpha)','Pdt (d\alpha = 2d\alpha)','Pdt (d\alpha = 3d\alpha)','S')
