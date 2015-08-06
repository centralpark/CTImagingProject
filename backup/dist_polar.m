function D=dist_polar(r1,r2,theta1,theta2)
t1=theta1*pi/180;
t2=theta2*pi/180;
D=sqrt(r1^2+r2^2-2*r1*r2*cos(t1-t2));