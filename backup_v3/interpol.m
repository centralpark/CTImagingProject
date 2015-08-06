% @param Z  Matrix of 2D Fourier Space in radian grid. Each column is the 
% central slice at angle theta in 2D Fourier space
% @retval ZI  Matrix of 2D Fourier Space in cartesian grid after
% interpolation
function ZI=interpol(theta,w_s,Fourier_Radon,THETA_I,OMEGA_SI,method)
% 2D interpolation from raidan grid to Cartesian grid
Z=horzcat(Fourier_Radon,flipud(Fourier_Radon(:,1)));
len=size(THETA_I,1);
dw_s=mean(diff(w_s));
dt=mean(diff(theta));
for i=1:len
    for j=1:len
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
        elseif w_q<(-w_s(end)-dw_s)
            J2=0;
            J1=J2-1;
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
    end
end