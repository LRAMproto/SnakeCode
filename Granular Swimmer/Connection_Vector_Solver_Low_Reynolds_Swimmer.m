function Xi = Connection_Vector_Solver_Low_Reynolds_Swimmer(S,alpha,dalpha)

Xi0 = [10e-2,10e-2,10e-2];   % The initial guess of the solution
% delta_L = 2*S.L/S.Range;     % Length of the integral segment

for i = 1:length(dalpha(1,:))

    for j = 1:length(dalpha(2,:))
    
        %%%%%% Check this Part %%%%%%%
        dalpha_p = [dalpha(1,i); dalpha(2,j)];
              
        % Solveer with integrating over the links
        Xi1 = fminsearch(@Connection_Vector_Low_Reynolds,Xi0,[],alpha,dalpha_p,S);
                
        Xi.x(i,j) = Xi1(1);
        Xi.y(i,j) = Xi1(2);
        Xi.theta(i,j) = Xi1(3);

    end
     
end

