function h = metricellipsefield_power1(x,y,C,style,varargin)
%Plot an ellipse field based on the singular values of a metric
%tensor M. M should be specified as a cell array with with the same
%dimensions as x and y, and each cell containing a 2x2 matrix containing
%its value at the corresponding x,y location

circles = C;
%%%%%%%%%%%%%
% Construct the ellipses for each location

% Make the circle primitive
% th = linspace(0,2*pi,50);
% xc = cos(th);
% yc = sin(th);
% 
% % Replicate the circle primitive into a cell array at each x,y location
% circles = repmat({[xc;yc]},size(x));


% switch style
% 
% 	% The tissot indicatrix, showing linear stretch
% 	case 'tissot'
% 		
% 		% Calculate the svd of the metric tensor
% 		[u,s,v] = cellfun(@(m) svd(inv(m)),M,'UniformOutput',false);
% 
% 		% Apply the transform corresponding to M to the circles
% 		circles = cellfun(@(u,s,v,c)(u*sqrt(s)*v')*c,u,s,v,circles,'UniformOutput',false);
% 		%circles = cellfun(@(u,s,v,c)(sqrt(s)*v')*c,u,s,v,circles,'UniformOutput',false);
% 		
		plot_options = varargin{1};
% 		
% 	% the tissot indicatrix, with major and minor axis crosses added
% 	case 'tissot-cross'
% 
% 		% Calculate the svd of the metric tensor
% 		[u,s,v] = cellfun(@(m) svd(inv(m)),M,'UniformOutput',false);
% 		
% 		% Apply the transform corresponding to M to the circles
% 		circles = cellfun(@(u,s,v,c)(u*sqrt(s)*v')*c,u,s,v,circles,'UniformOutput',false);
% 		
% 		% Create the crosses
% 		crosses = cellfun(@(u,s)...
% 			[u(1,1)*s(1,1) -u(1,1)*s(1,1);...% NaN u(1,2)*s(2,2) u(1,2)*s(2,2);...
% 			u(2,1)*s(1,1) -u(2,1)*s(1,1);... NaN u(2,2)*s(2,2) -u(2,2)*s(2,2)
% 			],u,s,'UniformOutput',false);
% 		
% 		plot_options = varargin{1};
% 		plot_options_crosses = varargin{2};
% 		
% 		
% 
% end
for l = 1:length(C)
    for n = 1:length(C)

    %     [C_Max1,C_Indx1] = find(C{n}(1,:)==2);

        for m = 1:length(C{l,n})

    %         C_data{m} = C{n}{m}(:,C_Indx1(m)+1:C_Indx1(m)+C{n}{m}(2,C_Indx1(m)));
            C_data1 = C{l,n}{m};
            if ~isempty(C_data1)
                Sum_C_data{m} = sum(C_data1(1,:));
            end

        end

        [C_Min,C_Indx2] = min(abs([Sum_C_data{:}]));
    %     C_data{n} = C{n}(:,C_Indx1(C_Indx2)+1:C_Indx1(C_Indx2)+C{n}(2,C_Indx1(C_Indx2)));
        C_data{l,n} = C{l,n}{C_Indx2};

        Sum_C_data = {};
    end
end

% Find the greatest x or y range in the circles
% xrange = cellfun(@(u)range(u(1,:)),circles);
% yrange = cellfun(@(u)range(u(2,:)),circles);

xrange = cellfun(@(u)range(u(1,:)),C_data);
yrange = cellfun(@(u)range(u(2,:)),C_data);

xrange = max(xrange(:));
yrange = max(yrange(:));

% Find the smallest spacing in each direction
xspacing = min(diff(x(:,1)));
yspacing = min(diff(y(1,:)));

% Set the percentage of the spacing that the largest element should occupy
max_fill = 0.6;

% Determine if x or y fitting is the limiting factor for the plot and set
% the scaling accordingly
scale_factor = min(xspacing/xrange, yspacing/yrange)*max_fill;

% Multiply all the circles by the scale factor
% circles = cellfun(@(u)u*scale_factor,C_data,'UniformOutput',false);

for l = 1:length(C)
    for n = 1:length(C)
        
        circles1{l,n} = cellfun(@(u)u*scale_factor,circles{l,n},'UniformOutput',false);
        
    end
end


if exist('crosses','var')
	crosses = cellfun(@(u)u*scale_factor,crosses,'UniformOutput',false);
end

% Recenter the circles
% circles = cellfun(@(u,v,w) [u(1,:)+v;u(2,:)+w],circles,num2cell(x),num2cell(y),'UniformOutput',false);


for l = 1:length(C)
    for n = 1:length(C)
        
        circles2{l,n} = cellfun(@(u) [u(1,:)+x(l,n);u(2,:)+y(l,n)],circles1{l,n},'UniformOutput',false);
        
    end
end

if exist('crosses','var')
	crosses = cellfun(@(u,v,w) [u(1,:)+v;u(2,:)+w],crosses,num2cell(x),num2cell(y),'UniformOutput',false);
end

%%%%%%%%%%%%%%%%%
% Fill in default values for plot options

% Ensure plot options exists
if ~exist('plot_options','var')
	
	plot_options = {};
	
end


% Color
if ~any(strcmpi('edgecolor',plot_options(1:2:end)))
	
	plot_options = [plot_options,{'EdgeColor','k'}];
	
end
if ~any(strcmpi('facecolor',plot_options(1:2:end)))
	
	plot_options = [plot_options,{'FaceColor','none'}];
	
end

% Parent
if isempty(plot_options) || ~any(strmatch('parent',lower(plot_options(1:2:end))))
	
	f = figure;
	ax = axes('Parent',f);
	plot_options = [plot_options,{'Parent',ax}];
	
end

%%%%%%%%%%%%%%%%%%
% Make the ellipses

switch style
	
	case 'tissot'
		
% 		h = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options{:}),circles);
        
        
        for l = 1:length(C)
            for n = 1:length(C)
                
                h = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options{:}),circles2{l,n});
                
            end
        end
        
        xlabel('\alpha_1');
        ylabel('\alpha_2');
        axis equal
        axis square
		
	case 'tissot-cross'
		
		h_cross = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options_crosses{:}),crosses);
		
		h_ellipse = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options{:}),circles);


end