% trainSVM.m

function [alpha, b]=trainSVM(X, y, C, sigma)
    % funtion, train SVM for binay classification
    % ������ѵ�����ڶ�Ԫ�����֧��������
    % input: X-Characteristics vector, y-Classification
    % ���룺X-��������, y-����
    % output: alpha-coefficient,b-bias
    % �����alpha-ϵ���� b-ƫ��
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
     % �����˹�˺���
     P=exp(-norm(X-Y)^2/sigma);
end