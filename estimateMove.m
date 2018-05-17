function [direction, config]=estimateMove(BW, config)

    % Estimate the moving direction of hand.
    
%     if numel(J)~=0 && J(1).BoundingBox(3)>100 && J(1).BoundingBox(4)>100
%         BW2 = imerode(BW, strel('disk',35));
%         BW2 = imdilate(BW2,strel('disk',40));
%         
%         BW3 = BW-BW2;
%         BW3(BW3<0)=0;
%         BW3 = bwareaopen(BW3,1000);
%         BW = BW3;
%     end
    
    % Palm Centroid Estimation
    P = regionprops(BW, 'All');
    if size(P,1)==0
        [mu, Sigma]=KFn(config.kf.Sigma, config.kf.mu, config.kf.dt);
        if(mu(1)<config.kf.mu(1)) 
            direction='left';
        else
            direction='right';
        end
        
        config.kf.Sigma=Sigma;
        config.kf.mu=mu;

        return
    end
    
    if numel(P)>1
        P_ = [P.Area];
        [~, sortingIndexes] = sort(P_, 'descend');
        P(1)=P(sortingIndexes(1));
    end
    palm=P(1).Centroid;
    
    [mu, Sigma]=KFs(palm, config.kf.Sigma, config.kf.mu, config.kf.dt);
    if(mu(1)<config.kf.mu(1))
        direction='left';
    else
        direction='right';
    end
    
    config.kf.Sigma=Sigma;
    config.kf.mu=mu;
end


function [x, y]=getRemotePoint(ConvexHull, Centroid)
    length=size(ConvexHull,1);
    maxium=0;
    x=1;
    y=1;
    for k=1:length
        if (ConvexHull(k,1)-Centroid(1))^2+(ConvexHull(k,2)-Centroid(2))^2>maxium
            x=ConvexHull(k,1);
            y=ConvexHull(k,2);
        end
    end
end

function [mu, Sigma]=KFs(z, Sigma, mu, dt)
    
    mu_tt=mu;
    Sigma_tt=Sigma;
    z_t=z';
    
    
    A=[1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
    C=[1 0 0 0; 0 1 0 0];
    R=[1 0 0 0; 0 1 0 0;0 0 0 0; 0 0 0 0]*0.08;
    Q=[1 0; 0 1]*0.2;
    mu_t_=A*mu_tt;
    Sigma_t_=A*Sigma_tt*A'+R;
    K_t=Sigma_t_*C'*(C*Sigma_t_*C'+Q)^(-1);
    mu_t=mu_t_+K_t*(z_t-C*mu_t_);
    Sigma_t=(1-K_t*C)*Sigma_t_;
    
    mu=mu_t;
    Sigma=Sigma_t;
    
    if Sigma(1,1)>10000000000
        Sigma=[0.3714    1.4000    1.0286    1.2000;...
                    1.4000    0.3714    1.2000    1.0286;...
                    1.2286    1.4000    1.1714    1.2000;...
                    1.4000    1.2286    1.2000    1.1714];
    end
end

function [mu, Sigma]=KFn(Sigma, mu, dt)
    mu_tt=mu;
    Sigma_tt=Sigma;
    
    A=[1 0 dt 0; 0 1 0 dt; 0 0 1 0; 0 0 0 1];
    R=[1 0 0 0; 0 1 0 0;0 0 0 0; 0 0 0 0]*0.08;
    mu_t_=A*mu_tt;
    Sigma_t_=A*Sigma_tt*A'+R;
    
    mu=mu_t_;
    Sigma=Sigma_t_;
    
    if Sigma(1,1)>10000000000
        Sigma=[0.3714    1.4000    1.0286    1.2000;...
                    1.4000    0.3714    1.2000    1.0286;...
                    1.2286    1.4000    1.1714    1.2000;...
                    1.4000    1.2286    1.2000    1.1714];
    end
end