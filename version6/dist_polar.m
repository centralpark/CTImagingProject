function D=dist_polar(theta1,theta2,w1,w2)
if w1<0
    t1=theta1*pi/180-180;
    w1=-w1;
else
    t1=theta1*pi/180;
end
if w2<0
    t2=theta2*pi/180-180;
    w2=-w2;
else
    t2=theta2*pi/180;
end
[x1 y1]=pol2cart(t1,w1);
[x2 y2]=pol2cart(t2,w2);
D=sqrt((x1-x2)^2+(y1-y2)^2);