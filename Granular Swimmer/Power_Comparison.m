function circles1 = Power_Comparison(C,style,varargin)
%Plot an ellipse field based on the singular values of a metric
%tensor M. M should be specified as a cell array with with the same
%dimensions as x and y, and each cell containing a 2x2 matrix containing
%its value at the corresponding x,y location

circles = C;
%%%%%%%%%%%%%

plot_options = varargin{1};
		

% for l = 1:length(C)
%     for n = 1:length(C)

        for m = 1:length(C)

            C_data1 = C{m};

            if ~isempty(C_data1)
                Sum_C_data{m} = sum(C_data1(1,:));
            end

        end

        [C_Min,C_Indx2] = min(abs([Sum_C_data{:}]));
        C_data = C{C_Indx2};
        Sum_C_data = {};
%     end
% end

% Find the greatest x or y range in the circles
% xrange = cellfun(@(u)range(u(1,:)),circles);
% yrange = cellfun(@(u)range(u(2,:)),circles);

xrange = cellfun(@(u)range(u(1,:)),{C_data});
yrange = cellfun(@(u)range(u(2,:)),{C_data});

xrange = max(xrange(:));
yrange = max(yrange(:));

% Find the smallest spacing in each direction
xspacing = 1; %min(diff(x(:,1)));
yspacing = 1; %min(diff(y(1,:)));

% Set the percentage of the spacing that the largest element should occupy
max_fill = 1;

% Determine if x or y fitting is the limiting factor for the plot and set
% the scaling accordingly
scale_factor = min(xspacing/xrange, yspacing/yrange)*max_fill;

% Multiply all the circles by the scale factor
% circles = cellfun(@(u)u*scale_factor,C_data,'UniformOutput',false);

% for l = 1:length(C)
%     for n = 1:length(C)
        
        circles1 = cellfun(@(u)u*scale_factor,circles,'UniformOutput',false);
        
%     end
% end

% Recenter the circles
% circles = cellfun(@(u,v,w) [u(1,:)+v;u(2,:)+w],circles,num2cell(x),num2cell(y),'UniformOutput',false);


% for l = 1:length(C)
%     for n = 1:length(C)
        
%         circles2 = cellfun(@(u) [u(1,:)+x;u(2,:)+y],circles1,'UniformOutput',false);
        
%     end
% end

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
% if isempty(plot_options) || ~any(strmatch('parent',lower(plot_options(1:2:end))))
% 	
% 	f = figure;
% 	ax = axes('Parent',f);
% 	plot_options = [plot_options,{'Parent',ax}];
% 	
% end

%%%%%%%%%%%%%%%%%%
% Make the ellipses

switch style
	
	case 'Power_Comparison'
		
% 		h = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options{:}),circles);
        
        
%         for l = 1:length(C)
%             for n = 1:length(C)
                
%                 PC = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options{:}),circles1);
                
%             end
%         end
        
%         xlabel('\alpha_1');
%         ylabel('\alpha_2');
%         axis equal
%         axis square
%         hold on
		
	case 'tissot-cross'
		
		h_cross = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options_crosses{:}),crosses);
		
		h_ellipse = cellfun(@(u)patch('XData',u(1,:),'YData',u(2,:),plot_options{:}),circles);


end