t = linspace(0,2*pi,20);
n1=1; n2=1;
m=4;    % Number of arms

x = cos(t) ./ [(abs(cos(m*t/4))).^n2 + (abs(sin(m*t/4))).^n2].^(1/n1);
 
y = sin(t) ./ [(abs(cos(m*t/4))).^n2 + (abs(sin(m*t/4))).^n2].^(1/n1);

