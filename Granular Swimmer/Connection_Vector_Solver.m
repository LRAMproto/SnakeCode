function [A,C_data,C_ellipse_data,Reg_C_data,Metric_Tensor,P,Reg_P] = Connection_Vector_Solver(Xi0,S,alpha,R_alpha,dalpha)


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
            
            % Compute the torques using the body velocity
%             [T] = Torque_Calc(Xi1,alpha,dalpha_p,S);
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
    if  strcmp(S.power_type,'Power_field')
        A = ConnectionVector_Calc1(Reg);
    end
    

%% Compute the Torques on each joint using the regression of Body Velocity
%{...
    for i = 1:length(dalpha(1,:))

        for j = 1:length(dalpha(2,:))

            %%%%%% Check this Part %%%%%%%
            dalpha_p = [dalpha(1,i); dalpha(2,j)];

            Xi1(1) = Reg.x(i,j);
            Xi1(2) = Reg.y(i,j);
            Xi1(3) = Reg.theta(i,j);
            
            [T] = Torque_Calc(Xi1,alpha,dalpha_p,S);
            
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
        [P,C,Reg_C] = Power_Plot(T1,T2,dalpha,1);

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
            % 'Reg_C' is the elliptic cone estimation of power plot
            [P,Reg_P,C,Reg_C,Metric_Tensor] = Power_Plot(T1,T2,dalpha,n,S);
            
            switch S.power_type
                
                case 'Power_for_gait'
        
                    % Do nothing
                    C_data = [];
                    C_ellipse_data = [];
                    Reg_C_data = [];
                    Metric_Tensor = [];
                    A = [];
        
                case 'Power_field'

                    % Seperate the data of the contour for specific power and put them into
                    % the individual cell.
                    [C_Max1,C_Indx1] = find(C(1,:) == C(1,1));
                    [Reg_C_Max1,Reg_C_Indx1] = find(Reg_C(1,:) == Reg_C(1,1));

                    for m = 1:length(C_Indx1)

                        C_data{m} = C(:,C_Indx1(m)+1:C_Indx1(m)+C(2,C_Indx1(m)));

                    end

                    for m = 1:length(Reg_C_Indx1)

                        Reg_C_data{m} = Reg_C(:,Reg_C_Indx1(m)+1:Reg_C_Indx1(m)+Reg_C(2,Reg_C_Indx1(m)));

                    end

                    % This part evaluate the power plot by scaling different
                    % contour of power at the same size and then comparissing them
                    if S.Power_comparison

                        circles1 = Power_Comparison(C_data,'Power_Comparison',{});

                        figure(3)

                        if n == 3

                            PC = cellfun(@(u)plot(u(1,:),u(2,:),'color','red','LineWidth',2),circles1);
                            legend('Power = 4','Power = 6', 'Power = 8')
                            str = sprintf('alpha1 = %f, alpha2 = %f',alpha(1),alpha(2));
                            title(str)
                            axis equal
                            axis square

                        elseif n == 1

                            PC = cellfun(@(u)plot(u(1,:),u(2,:),'color','black','LineWidth',2),circles1);

                        else

                            PC = cellfun(@(u)plot(u(1,:),u(2,:),'color','blue','LineWidth',2),circles1);

                        end

                        hold on

                    end % end of power comparison

            end
            
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
%     subplot(2,3,1);
%     surf(dalpha1,dalpha2,Xi.x)
%     title('\xi_x');
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_x')
%     axis equal
%     axis square
% 
% %     figure(2)
%     subplot(2,3,2);
%     surf(dalpha1,dalpha2,Xi.y)
%     title('\xi_y');
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_y')
%     axis equal
%     axis square
% 
% %     figure(3)
%     subplot(2,3,3);
%     surf(dalpha1,dalpha2,Xi.theta)
%     title('\xi_\theta');
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_\theta')
%     axis equal
%     axis square

% end
    
    % Plot fitting the regression plane
% %     figure(4)
%     subplot(2,3,4);
%     surf(dalpha1, dalpha2,Reg.x)
%     title('\xi_x After Regression');
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_x')
%     axis equal
%     axis square
%     
% %     figure(5)
%     subplot(2,3,5);
%     surf(dalpha1, dalpha2,Reg.y)
%     title('\xi_y After Regression');
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_y')
%     axis equal
%     axis square
%     
% %     figure(6)
%     subplot(2,3,6);
%     surf(dalpha1, dalpha2,Reg.theta)
%     title('\xi_\theta After Regression');
%     xlabel('d\alpha_1');
%     ylabel('d\alpha_2');
%     zlabel('\xi_\theta')
%     axis equal
%     axis square
    
