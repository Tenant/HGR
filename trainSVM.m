% trainSVM.m

function [alpha, b]=trainSVM(X, y, C, sigma)
    % funtion, train SVM for binay classification
    % 函数，训练用于二元分类的支持向量机
    % input: X-Characteristics vector, y-Classification
    % 输入：X-特征向量, y-分类
    % output: alpha-coefficient,b-bias
    % 输出：alpha-系数， b-偏置
    m=size(X,1);
    K=zeros(m);
    for i=1:m
        for j=1:m
            K(i,j)=Prob(X(i,:),X(j,:), sigma);
        end
    end
    one=ones(m,1);
    alpha=ones(m,1);
    cvx_begin
        variables alpha(m)
        maximize(-1/2*(alpha.*y)'*K*(alpha.*y)+one'*alpha)
        subject to
        (0<=alpha)&& (alpha<=C)
        alpha'*y==0
    cvx_end
    
    ind = find(alpha>=C*0.00001 & alpha<=C*(1-0.00001));
    ind = ind(1);
    b = Y(ind) - alpha'*(Y.*K(:,ind));   
end

function P=Prob(X, Y, sigma)
     % Calculate Gaussican Kernel
     % 计算高斯核函数
     P=exp(-norm(X-Y)^2/sigma);
end