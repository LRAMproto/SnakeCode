function ellipse_Pos = Fit_ellipse(C)

    % plot1 = openfig('name.fig');

%     h = findobj(Plot,'type','patch');
% 
%     x_data = get(h,'xdata');
%     y_data = get(h,'ydata');
%     z_data = get(h,'zdata');

    x_data{1} = C(1,:);
    y_data{1} = C(2,:);


    % function for fitting the ellipse to tha data obtained from the contour

    % Center of ellipse
    Xc = 0; 
    Yc = 0;  

    % Initial guess
    Xdim = 0.001;   % Radious of ellipse along x axis
    Ydim = 0.001;   % Radious of ellipse along y axis

    Data = [Xdim Ydim];

    Tilt_Angle = 0;     % Rotation of ellipse in counter-clockwise direction (radians)

    % This function fit Ellipse to data points
%     for i = length(x_data):-1:1

        ellipse = fminsearch(@Create_ellipse,Data,[],x_data,y_data,Tilt_Angle,Xc,Yc,1);
 

%         break
% 
%     end

    th = linspace(0,2*pi,50);
    xc = ellipse(1)*cos(th);
    yc = ellipse(2)*sin(th);

    load('Ange_of_Ellipse.mat')

    R = [cos(Angle) sin(Angle);-sin(Angle) cos(Angle)];

    ellipse_Pos = R*[xc;yc];

%     plot(ellipse_Pos(1,:),ellipse_Pos(2,:))
