function [A,C_data,C_ellipse_data] = Connection_Vector_Solver(Xi0,S,alpha,R_alpha,dalpha)


    for i = 1:length(dalpha(1,:))

        for j = 1:length(dalpha(2,:))

            %%%%%% Check this Part %%%%%%%
            dalpha_p = [dalpha(1,i); dalpha(2,j)];

            % The initial guess of the solution using the body velocities of
            % low Reynolds system
            Xi01.x = Xi0.x(i,j);
            Xi01.y = Xi0.y(i,j);
            Xi01.theta = Xi0.theta(i,j);

            % This function extract the Body Velocity by integrating over the links and
            % using 'fminsearch'
            [Xi1] = Integrate_Equation(@ForceLaw_Calc,Xi01,alpha,dalpha_p,S);

            % Put the body velocity into the matrices
            Xi.x(i,j) = Xi1(1);
            Xi.y(i,j) = Xi1(2);
            Xi.theta(i,j) = Xi1(3);
            
%             [T] = Metric_Calc(Xi1,alpha,dalpha_p,S);
%             
%             T1(i,j) = T(1);
%             
%             T2(i,j) = T(2);
                        
        end

    end

    [dalpha1,dalpha2] = ndgrid(dalpha(1,:), dalpha(2,:));
    
    % This function fit a plane to the plots of Body Velocity
    [Reg] = Regression(dalpha1,dalpha2,Xi);
    
    % This function calculate the gradient of Body Velocity and create the
    % Local Connection for a given shape angle (alpha)
    A = ConnectionVector_Calc1(Reg);
    

%% Compute the Torques on each joint
%{...
    for i = 1:length(dalpha(1,:))

        for j = 1:length(dalpha(2,:))

            %%%%%% Check this Part %%%%%%%
            dalpha_p = [dalpha(1,i); dalpha(2,j)];

            Xi1(1) = Reg.x(i,j);
            Xi1(2) = Reg.y(i,j);
            Xi1(3) = Reg.theta(i,j);
            
            [T] = Metric_Calc(Xi1,alpha,dalpha_p,S);
            
            T1(i,j) = T(1);
            
            T2(i,j) = T(2);
                        
        end

    end

%}
%%

% Scale the two different powers at the same size and then compare them for
% specific shape change
mode = 'real_shape_power';

switch mode
    
    case 'ellipse_shape_power'
        
        % This function Plot the power as an contour and extract the data of
        % the contour in desire power.
        [P,C] = Power_Plot(T1,T2,dalpha,1);

        % Seperate the data of the contour for specific power and put them into
        % the individual cell.

        [C_Max1,C_Indx1] = find(C(1,:) == C(1,1));

        for m = 1:length(C_Indx1)

            C_data = C(:,C_Indx1(m)+1:C_Indx1(m)+C(2,C_Indx1(m)));
            Sum_C_data{m} = sum(C_data(1,:));     % uesd for Removeing the akward shapes

        end
        [C_Min,C_Indx2] = min(abs([Sum_C_data{:}]));      % uesd for Removeing the akward shapes
        C_data = C(:,C_Indx1(C_Indx2)+1:C_Indx1(C_Indx2)+C(2,C_Indx1(C_Indx2)));      % uesd for Removeing the akward shapes
        
        % This function get the contour and extract the data from that, then
        % using that data fit the ellipse on them
        C_ellipse_data = Fit_ellipse(C_data);
        
    case 'real_shape_power'

        for n = 1:1

            % This function Plot the power as an contour and extract the data of
            % the contour in desire power.
            [P,C] = Power_Plot(T1,T2,dalpha,n);

            % Seperate the data of the contour for specific power and put them into
            % the individual cell.
            [C_Max1,C_Indx1] = find(C(1,:) == C(1,1));

            for m = 1:length(C_Indx1)

                C_data{m} = C(:,C_Indx1(m)+1:C_Indx1(m)+C(2,C_Indx1(m)));

            end

%             circles1 = Power_Comparison(C_data,'Power_Comparison',{});
% 
%             figure(2)

            if n == 1

%                 PC = cellfun(@(u)plot(u(1,:),u(2,:),'color','black','LineWidth',2),circles1);

            else

                PC = cellfun(@(u)plot(u(1,:),u(2,:),'color','red','LineWidth',2),circles1);
                legend('Power = 4','Power = 6')
                str = sprintf('alpha1 = %f, alpha2 = %f',alpha(1),alpha(2));

                title(str)
                axis equal
                axis square

            end

%             hold on

        end
        
        C_ellipse_data = {};
    
end % end switch
   
    
%     hh = cellfun(@(u)patch(u(1,:),u(2,:),'w'),C_data);

%     patch(C_data(1,:),C_data(2,:),'w');
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('Power');
%     axis equal
%     axis square
    
    % Plot the Body Velocities
%     figure(1)
%     surf(dalpha1,dalpha2,Xi.x)
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_x')
%     axis equal
%     axis square
% 
%     figure(2)
%     surf(dalpha1,dalpha2,Xi.y)
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_y')
%     axis equal
%     axis square
% 
%     figure(3)
%     surf(dalpha1,dalpha2,Xi.theta)
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_\theta')
%     axis equal
%     axis square

end
    
    % Plot fitting the regression plane
    % figure(4)
    % surf(dalpha1, dalpha2,Reg.Xi_x)
    % title('\xi_x After Regression');
    % xlabel('d\alpha_1');
    % ylabel('d\alpha_2');
    % zlabel('\xi_x')
    % axis equal
    % axis square
    % 
    % figure(5)
    % surf(dalpha1, dalpha2,Reg.Xi_y)
    % title('\xi_y After Regression');
    % xlabel('d\alpha_1');
    % ylabel('d\alpha_2');
    % zlabel('\xi_y')
    % axis equal
    % axis square
    % 
    % figure(6)
    % surf(dalpha1, dalpha2,Reg.Xi_theta)
    % title('\xi_\theta After Regression');
    % xlabel('d\alpha_1');
    % ylabel('d\alpha_2');
    % zlabel('\xi_\theta')
    % axis equal
    % axis square
    