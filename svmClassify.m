function result=svmClassify(kfun, sv, x, alpha, bias, ScaleData, varargin)
    %
    % function result=svmClassify(kfun, sv, x, alpha, bias, ScaleData, varargin)
    %
    % 根据训练的SVM模型对新对象进行归类
    
     if ~isempty(ScaleData)
        for c = 1:size(x, 2)
           x(:,c) = ScaleData.scaleFactor(c) * (x(:,c) +  ScaleData.shift(c));
        end
    end
    result=sign(feval(kfun,sv, x)'*alpha+bias);
end

function K=linear_kernel(u,v,varargin)
 % linear kernel for SVM functions
    K=(u*v');
end

function K=quadratic_kernel(u,v,vargrgin)
    % Quadratic Kernel for SVM functions
    dotproduct=(u*v');
    K=dotproduct.*(1+dotproduct);
end

function K=rbf_kernel(u, v, rbf_sigma, varargin)
    % Gaussian Radia Basis function kernel for SVM functions
    if nargin<3 || isempty(rbf_sigma)
        rbf_sigma=1;
    end
    K=exp(-(1/(2*rbf_sigma^2))*(repmat(sqrt(sum(u.^2,2).^2),1,size(v,1))...
    -2*(u*v')+repmat(sqrt(sum(v.^2,2)'.^2),size(u,1),1)));
end

function K=poly_kernel(u, v, polyOrder, varargin)
    % Polynomial kernel for SVM functions
    
    if nargin<3 || isempty(polyOrder)
        polyOrder=3;
    end
    dotproduct=(u*v');
    K=dotproduct;
    for ii=2:polyOrder
        K=K.*(1+dotproduct);
    end
end

function kval=mlp_kernel(u,v,P1,P2,varargin)
    % Multilayer perceptron kernel for SVM functions
    if nargin<3 || isempty(P1)
      P1=1;
    end
    if nargin<4 || isempty(P2)
        P2=1;
    end
    kval=tanh(P1*(u*v')+P2);
end
