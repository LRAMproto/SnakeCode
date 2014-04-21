function [Xi] = Integrate_Equation(FUN, Xi0,alpha,dalpha,S)

    N = 3;                     % Number of Links
    delta_L = 2*S.L/S.Range;   % segments of integral per length of rod

    Xi(1) = Xi0.x;
    Xi(2) = Xi0.y;
    Xi(3) = Xi0.theta;

%     options = optimset('Display','Iter','TolX',1e-1,'TolFun',1e1);   % Option to display output
    
    options = optimset('Display','Iter','TolX',1e-1,'TolFun',1e0);   % Option to display output


    [Xi] = fminsearch(FUN,Xi,options,alpha,dalpha,S,N,delta_L);
        
end



















% function New_Xi = Integrate_Equation(FUN, Xi0,alpha,dalpha,K,L,S,Range)
% 
%     save('dalpha','dalpha')
% 
%     N = 1;                 % Number of Links
%     delta_L = 2*L/Range;   % segments of integral per length of rod
% 
% %     Xi = fminsearch(FUN,Xi0,[],alpha,dalpha,K,L,S,N,Range,delta_L);
% 
%     
%     obj = @Fitness;
%     nvars = 3;    % Number of variables
%     LB = [-1 -1 -1];   % Lower bound
%     UB = [1 1 1];  % Upper bound
% 
%     Xi = ga(obj,nvars,[],[],[],[],LB,UB,[],[],[]);
% 
%     New_Xi =  Xi;
%         
% end
% 
% 
% 
% function F = Fitness(Xi)
% 
%     load('dalpha')
% 
%     L = 1;               % The link length
%     K = 0.5;             % The differential viscous drag constant
%     S.C_S = 7.70;        % 
%     S.C_F = 2.79;        %
%     S.C_L = -2.03;       %
%     S.gama = 1.57;       %
% 
%     Range = 8;           % Number of segments in each link for integrating
% 
%     alpha = [0.85; -1.14];
%     N = 3;
%     delta_L = 2*L/Range;
% 
%     F = Non_Linear_Connection_Vector1(Xi,alpha,dalpha,K,L,S,N,Range,delta_L);
% 
% 
% end