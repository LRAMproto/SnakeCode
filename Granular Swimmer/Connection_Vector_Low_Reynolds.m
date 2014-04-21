function F = Connection_Vector_Low_Reynolds(Xi,alpha,dalpha,S)


        % The link body velocities
        Xi1 = [cos(alpha(1))*Xi(1) - sin(alpha(1))*Xi(2) + sin(alpha(1))*S.L*Xi(3)
                 sin(alpha(1))*Xi(1) + cos(alpha(1))*Xi(2) - (cos(alpha(1)) + 1)*S.L*Xi(3) + S.L*dalpha(1)     % Body Velocity Link 1
                 Xi(3) - dalpha(1)];


        Xi2 = Xi;        % Body Velocity Link 2


        Xi3 = [cos(alpha(2))*Xi(1) + sin(alpha(2))*Xi(2) + sin(alpha(2))*S.L*Xi(3)
                -sin(alpha(2))*Xi(1) + cos(alpha(2))*Xi(2) + (cos(alpha(2)) + 1)*S.L*Xi(3) + S.L*dalpha(2)      % Body Velocity Link 3
                 Xi(3) + dalpha(2)];


        % Drag Forces on links     
        Fx = [S.K*S.L*Xi1(1) S.K*S.L*Xi2(1) S.K*S.L*Xi3(1)];
        Fy = 2*[S.K*S.L*Xi1(2) S.K*S.L*Xi2(2) S.K*S.L*Xi3(2)];
        M = (2/3)*[S.K*(S.L^3)*Xi1(3) S.K*(S.L^3)*Xi2(3) S.K*(S.L^3)*Xi3(3)];


        % "Psi" is the angle between the axis of the element and instantaneous
        F = [cos(alpha(1)) sin(alpha(1)) 0 ; -sin(alpha(1)) cos(alpha(1)) 0 ; S.L*sin(alpha(1)) -S.L*(1 + cos(alpha(1))) 1]*[Fx(1) ; Fy(1); M(1)] ...
            + [Fx(2) ; Fy(2); M(2)]...
            + [cos(alpha(2)) -sin(alpha(2)) 0 ; sin(alpha(2)) cos(alpha(2)) 0 ; S.L*sin(alpha(2)) S.L*(1 + cos(alpha(2))) 1]*[Fx(3) ; Fy(3); M(3)];
  
        F = sqrt(F(1)^2 + F(2)^2 + (F(3)*1/3*S.L)^2);


end

