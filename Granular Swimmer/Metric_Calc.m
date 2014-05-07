function [T] = Metric_Calc(Xi,alpha,dalpha,S)

% Initial Value
T1 = 0; T2 = 0;
Mid = round(S.Range/2)+1;    % Mid point of each Rod
delta_L = 2*S.L/S.Range;   % segments of integral per length of rod
    
for i = 1:S.Range

        % The link body velocities
        Xi1 = [cos(alpha(1))*Xi(1) - sin(alpha(1))*Xi(2) + sin(alpha(1))*S.L*Xi(3)
                 sin(alpha(1))*Xi(1) + cos(alpha(1))*Xi(2) - (cos(alpha(1)) + 1)*S.L*Xi(3) + S.L*dalpha(1)     % Body Velocity Link 1
                 Xi(3) - dalpha(1)];


        Xi2 = Xi;        % Body Velocity Link 2


        Xi3 = [cos(alpha(2))*Xi(1) + sin(alpha(2))*Xi(2) + sin(alpha(2))*S.L*Xi(3)
                -sin(alpha(2))*Xi(1) + cos(alpha(2))*Xi(2) + (cos(alpha(2)) + 1)*S.L*Xi(3) + S.L*dalpha(2)      % Body Velocity Link 3
                 Xi(3) + dalpha(2)];


        % Compute the body velocities in every segment
        Xi1 = [Xi1(1)
               Xi1(2) - ((delta_L/2) + (Mid - (i+1))*delta_L)*Xi1(3)
                Xi1(3)];

        Xi2 = [Xi2(1)
               Xi2(2) - ((delta_L/2) + (Mid - (i+1))*delta_L)*Xi2(3)
                Xi2(3)];


        Xi3 = [Xi3(1)
               Xi3(2) - ((delta_L/2) + (Mid - (i+1))*delta_L)*Xi3(3)
                Xi3(3)];


        % "Psi" is the angle between the axis of the element and instantaneous
        % velocity
        psi(1) = atan2(Xi1(2),Xi1(1));% - (alpha(1));   % For link 1

        psi(2) = atan2(Xi2(2),Xi2(1));                  % For link 2

        psi(3) = atan2(Xi3(2),Xi3(1));% - (alpha(2));   % For link 3
        

        % Drag Forces in Granular Environment
        switch S.Model
        
            case 'basic_model'
                
                % "beta" is an angle used in drag forces defined as follow and "gama" is a constant parameter
                beta0 = atan(S.gama*[sin(psi(1)) sin(psi(2)) sin(psi(3))]);
                
                % C_F, C_L, C_F are constant parameters obtained from experience 
                Fx = (delta_L)*[S.C_F*cos(psi(1)) + S.C_L*(1 - sin(psi(1)))  S.C_F*cos(psi(2)) + S.C_L*(1 - sin(psi(2)))  S.C_F*cos(psi(3)) + S.C_L*(1 - sin(psi(3)))];
                Fy = (delta_L)*[S.C_S*sin(beta0(1))  S.C_S*sin(beta0(2))  S.C_S*sin(beta0(3))];
                M  = [0 0 0];
                
                % Force equation for head                
                if S.head
                    
                    if i == 1
                    
                        psi_head(1) = pi/2 - psi(1);
                        psi_head(2) = pi/2 - psi(2);
                        psi_head(3) = pi/2 - psi(3);

                        beta0_head = atan(S.head_gama*[sin(psi_head(1)) sin(psi_head(2)) sin(psi_head(3))]);

%                         Fx_head(1) = (2*S.r)*[S.head_C_F*cos(psi_head(1)) + S.head_C_L*(1 - sin(psi_head(1)))  S.head_C_F*cos(psi_head(2)) + S.head_C_L*(1 - sin(psi_head(2)))  S.head_C_F*cos(psi_head(3)) + S.head_C_L*(1 - sin(psi(3)))];
%                         Fy_head(1) = (2*S.r)*[S.head_C_S*sin(beta0_head(1))  S.head_C_S*sin(beta0_head(2))  S.head_C_S*sin(beta0_head(3))];
%                         M_head(1)  = [0 0 0];

                        Fx_head1 = (2*S.r)*[S.head_C_F*cos(psi_head(1)) + S.head_C_L*(1 - sin(psi_head(1)))];
                        Fy_head1 = (2*S.r)*[S.head_C_S*sin(beta0_head(1))];
                        M_head1  = [0];
                        
                        Fx_head3 = 0; Fy_head3 = 0; M_head3 = 0;
                        
                    elseif i == S.Range
                        
                        psi_head(1) = pi/2 - psi(1);
                        psi_head(2) = pi/2 - psi(2);
                        psi_head(3) = pi/2 - psi(3);

                        beta0_head = atan(S.head_gama*[sin(psi_head(1)) sin(psi_head(2)) sin(psi_head(3))]);
                        
%                         Fx_head3 = (2*S.r)*[S.head_C_F*cos(psi_head(1)) + S.head_C_L*(1 - sin(psi_head(1)))  S.head_C_F*cos(psi_head(2)) + S.head_C_L*(1 - sin(psi_head(2)))  S.head_C_F*cos(psi_head(3)) + S.head_C_L*(1 - sin(psi(3)))];
%                         Fy_head3 = (2*S.r)*[S.head_C_S*sin(beta0_head(1))  S.head_C_S*sin(beta0_head(2))  S.head_C_S*sin(beta0_head(3))];
%                         M_head3  = [0 0 0];
              
                        Fx_head3 = (2*S.r)*[S.head_C_F*cos(psi_head(3)) + S.head_C_L*(1 - sin(psi(3)))];
                        Fy_head3 = (2*S.r)*[S.head_C_S*sin(beta0_head(3))];
                        M_head3  = [0];
                        
                        Fx_head1 = 0; Fy_head1 = 0; M_head1 = 0;
                        
                    else
                        Fx_head1 = 0; Fy_head1 = 0; M_head1 = 0; Fx_head3 = 0; Fy_head3 = 0; M_head3 = 0;
                        
                    end
                
                else
                    
                    Fx_head3 = 0; Fy_head3 = 0; M_head3 = 0; Fx_head1 = 0; Fy_head1 = 0; M_head1 = 0;
                    
                end
                
%                 Fx = Fx_head + Fx_b;
%                 Fy = Fy_head + Fy_b;
%                 M = M_head + M_b;
                
            case 'real_model'
                
                % "beta" is an angle used in drag forces defined as follow and "gama" is a constant parameter
                beta0 = atan(cot(S.Cyl_gama)*[sin(psi(1)) sin(psi(2)) sin(psi(3))]);
                beta0p = atan(cot(S.Cyl_gama)*[sin(pi/2 - psi(1)) sin(pi/2 - psi(2)) sin(pi/2 - psi(3))]);
                
                % 'e' is a parameter that can change the head surface between flat
                % circle or semi-sphare. e = 1 ---> flat head, e = 4 --->
                % semi-sphare head.
                e = 4;
                
                % C_F, C_L, C_F are constant parameters obtained from experience 
                Fx = [2*(delta_L)*S.r*(S.Cyl_C_F*cos(psi(1))) + e*pi*(S.r^2)*S.Cyl_C_S*(sin(beta0p(1)))  2*(delta_L)*S.r*(S.Cyl_C_F*cos(psi(2))) + e*pi*(S.r^2)*S.Cyl_C_S*(sin(beta0p(2)))  2*(delta_L)*S.r*(S.Cyl_C_F*cos(psi(3))) + e*pi*(S.r^2)*S.Cyl_C_S*(sin(beta0p(3)))];
                Fy = [2*(delta_L)*S.r*(S.Cyl_C_S*sin(beta0(1)) + S.Cyl_C_F*(sin(psi(1)))) + e*pi*(S.r^2)*S.Cyl_C_F*(sin(psi(1)))  2*(delta_L)*S.r*(S.Cyl_C_S*sin(beta0(2)) + S.Cyl_C_F*(sin(psi(2)))) + e*pi*(S.r^2)*S.Cyl_C_F*(sin(psi(2)))  2*(delta_L)*S.r*(S.Cyl_C_S*sin(beta0(3)) + S.Cyl_C_F*(sin(psi(3)))) + e*pi*(S.r^2)*S.Cyl_C_F*(sin(psi(3)))];
                M  = [0 0 0];
                
                Fx_head1 = 0; Fy_head1 = 0; M_head1 = 0; Fx_head3 = 0; Fy_head3 = 0; M_head3 = 0;
                
        end
                
        
        % Obtaining the relationship between the torque on each link and the
        % generalized velocities
        % T = Mp.dalpha   ### Mp = f(alpha)
        T1 = Fy(1)*((S.Range-i)*(delta_L) + delta_L/2) + Fy_head1*S.L + T1;
        T2 = Fy(3)*((i-1)*(delta_L) + delta_L/2) + Fy_head3*S.L + T2;
                
end
    
T = [T1 T2];
