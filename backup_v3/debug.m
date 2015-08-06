clc
w_s=omega_s;
theta=0:179;
N_image=201;
x = linspace(-100,100,N_image); 
y = x; 
dx=1; 
d_omega = 2*pi/(N_image-1); 
omega_x = x * d_omega; 
omega_y= fliplr(omega_x); 
    
% Label each (omega_x, omega_y) to (omega_s, theta) 
[OMEGA_X OMEGA_Y] = meshgrid(omega_x, omega_y); 
[THETA_I OMEGA_SI] = cart2pol(OMEGA_X,OMEGA_Y); 
     
% map from {theta,omega_s : [-pi,pi],[0,inf]} to {theta,omega_s : [0, 180],[-inf,inf]} 
sign_theta=sign(THETA_I);
ind=find(sign_theta==0);
sign_theta(ind)=1;
OMEGA_SI = OMEGA_SI .* sign_theta; 
THETA_I = mod( THETA_I * (180/pi), 180);
len=size(THETA_I,1);
dw_s=mean(diff(w_s));
dt=mean(diff(theta));
i=200;j=200;
theta_q=THETA_I(i,j);
        w_q=OMEGA_SI(i,j);
        ind=find(w_s>w_q);
        if isempty(ind)
            if w_q<=(w_s(end)+dw_s)
                J1=length(w_s);
                J2=J1+1;
            else
                J1=length(w_s)+1;
                J2=J1+1;
            end
        else
            J2=ind(1);
            J1=J2-1;
        end
        ind=find(theta>theta_q);
        if isempty(ind)
            I1=length(theta);
            I2=I1+1;
        else
            I2=ind(1);
            I1=I2-1;
        end
        theta1=(I1-1)*dt;
        theta2=(I2-1)*dt;
        w1=(J1-1)*dw_s-w_s(end);
        w2=(J2-1)*dw_s-w_s(end);
        P(1,1)=dist_polar(theta_q,theta1,w_q,w1);
        P(2,1)=dist_polar(theta_q,theta2,w_q,w1);
        P(3,1)=dist_polar(theta_q,theta1,w_q,w2);
        P(4,1)=dist_polar(theta_q,theta2,w_q,w2);
        if J1>=1 && J1<=length(w_s)
            P(1,2)=Z(J1,I1);
            P(2,2)=Z(J1,I2);
        else
            P(1,2)=0;
            P(2,2)=0;
        end
        if J2>=1 && J2<=length(w_s)
            P(3,2)=Z(J2,I1);
            P(4,2)=Z(J2,I2);
        else
            P(3,2)=0;
            P(4,2)=0;
        end
        
        switch method
            case 'nearest'  %nearest neighbor approximation
                [~, K]=min(P,[],1);
                ZI(i,j)=P(K(1),2);
            case 'linear'  %linear interpolation
                index=find(P(:,1)==0);
                if isempty(index)
                    ZI(i,j)=sum(P(:,2)./P(:,1))/sum(1./P(:,1));
                else
                    ZI(i,j)=P(index(1),2);
                end
            otherwise
                error('Unknown interpolation method');
        end