function obj = Create_ellipse(Data,x_data,y_data,Tilt_Angle,Xc,Yc,i)

Xdim = Data(1);
Ydim = Data(2);
New_Deviation = 0;



    for j = 1:length(x_data{i})

        if ~isnan(x_data{i}(j))

            % x, y are data from contour
            Data_angle = atan((y_data{i}(j)-Yc)/(x_data{i}(j)-Xc));

            % Distance of the center of ellipse with the data from the contour
            Data_Distance = sqrt((x_data{i}(j)-Xc)^2 + (y_data{i}(j)-Yc)^2);

            % Calculate the angle of ellipse based on disturbution of data
            Angle = Data_angle - Tilt_Angle;

            % Compute the radius of the ellipse (distance from center to perimeter) for 
            % this data angle. (Uses polar coordinate equation for an ellipse.)
            r = sqrt( (Xdim^2 * Ydim^2) / ((Xdim*sin(Angle))^2 + (Ydim*cos(Angle))^2));

            % Compute the difference between the distance for the data point and the ellipse.
            Deviation = Data_Distance - r;

            % Minimize the sum of squared deviations.
            New_Deviation = Deviation^2 + New_Deviation;

        end

    end

    obj = New_Deviation;
    save('Ange_of_Ellipse.mat','Angle')

end