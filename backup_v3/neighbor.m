function value=neighbor(theta,Z,x,y,method)
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
if mod(Zs(1),2)
    N=(Zs(1)-1)/2;
else
    N=Zs(1)/2;
end
rho=linspace(-N,N,Zs(1));
if t>=0
    [~, I]=min(abs(t-theta));
    I1=I;
    tbound1=(I-1)*dt;
    if tbound1<=t
        tbound2=I*dt;
        I2=I+1;
    else
        tbound2=(I-2)*dt;
        I2=I-1;
    end
    [~, J]=min(abs(r-[0:N+1]));
    rbound1=J-1;
    J1=J+N;
    if rbound1<=r
        rbound2=J;
        J2=J1+1;
    else
        rbound2=J-2;
        J2=J1-1;
    end
    if J>N+1 && rbound1<r
        J1=0;
        J2=0;
    end
else
    t=t+180;
    [~, I]=min(abs(t-theta));
    I1=I;
    tbound1=(I-1)*dt;
    if tbound1<=t
        tbound2=I*dt;
        I2=I+1;
    else
        tbound2=(I-2)*dt;
        I2=I-1;
    end
    [~, J]=min(abs(r-[0:N+1]));
    rbound1=J-1;
    J1=N-J+2;
    if rbound1<=r
        rbound2=J;
        J2=J1-1;
    else
        rbound2=J-2;
        J2=J1+1;
    end
    if J>N+1 && rbound1<r
        J1=0;
        J2=0;
    end
end
P(1,1)=dist_polar(r,rbound1,t,tbound1);
P(2,1)=dist_polar(r,rbound2,t,tbound1);
P(3,1)=dist_polar(r,rbound1,t,tbound2);
P(4,1)=dist_polar(r,rbound2,t,tbound2);
if J1>=1 && J1<=length(rho)
    P(1,2)=Z(J1,I1);
    P(3,2)=Z(J1,I2);
else
    P(1,2)=0;
    P(3,2)=0;
end
if J2>=1 && J2<=length(rho)
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