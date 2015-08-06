function value=neighbor_v2(theta,Z,Npix,x,y,method)
% find the neighboring sites and value of which point to
% assign to the interpolated point
Zs=size(Z);
temp=zeros(Zs(1),Zs(2)+1);
temp(:,1:Zs(2))=Z;
temp(:,Zs(2)+1)=flipud(Z(:,1));
Z=temp;
[t r]=cart2pol(x,y);
t=t/pi*180;
dt=theta(2)-theta(1);
P=zeros(4,2);

ds=1;
dx=1;
Nw=size(Z,1);
dw_s=2*pi/(Nw-1)/ds;
dw_x=2*pi/(Npix-1)/dx;

w_s_max=2*pi/2/ds;
w_s=-w_s_max:dw_s:w_s_max;
if t<0
    w_x=-r*dw_x;
else
    w_x=r*dw_x;
end
ind=find(w_s>w_x);
if isempty(ind)
    if w_x<=(w_s_max+dw_s)
        J1=Nw;
        J2=J1+1;
    else
        J1=Nw+1;
        J2=J1+1;
    end
else
    J2=ind(1);
    J1=J2-1;
end
ind=find(theta>abs(t));
if isempty(ind)
    I1=length(theta);
    I2=I1+1;
else
    I2=ind(1);
    I1=I2-1;
end
tbound1=(I1-1)*dt;
tbound2=(I2-1)*dt;
rbound1=abs((J1-1)*dw_s-w_s_max);
rbound2=abs((J2-1)*dw_s-w_s_max);
P(1,1)=dist_polar(r,rbound1,t,tbound1);
P(2,1)=dist_polar(r,rbound2,t,tbound1);
P(3,1)=dist_polar(r,rbound1,t,tbound2);
P(4,1)=dist_polar(r,rbound2,t,tbound2);
if J1>=1 && J1<=Nw
    P(1,2)=Z(J1,I1);
    P(3,2)=Z(J1,I2);
else
    P(1,2)=0;
    P(3,2)=0;
end
if J2>=1 && J2<=Nw
    P(2,2)=Z(J2,I1);
    P(4,2)=Z(J2,I2);
else
    P(2,2)=0;
    P(4,2)=0;
end

switch method
    case 1  %nearest neighbor approximation
        [~, K]=min(P,[],1);
        value=P(K(1),2);
    case 2  %linear interpolation
        index=find(P(:,1)==0);
        if isempty(index)
            value=sum(P(:,2)./P(:,1))/sum(1./P(:,1));
        else
            value=P(index(1),2);
        end
end