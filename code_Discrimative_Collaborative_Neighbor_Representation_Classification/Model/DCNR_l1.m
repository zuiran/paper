function [accuracy, Alpha0, pre_label0] = DCNR_l1(lambda, gamma, beta, train, test)
%   Robust DCNR
%   Input:  1. Regularization parameters: lambda, gamma, beta 
%           2. The training sample set: train(train.descr, train.label)
%           3. The testing sample set: test(test.descr, test.label) 
%   Output: 1. The classification accuracy: accuracy
%           2. The representation coefficients: Alpha0
%           3. The predicted labels and the truth labels: pre_label0
%           %%  Number of outputs in this function is variable 

	train_descr  = train.descr;
    train_label  = train.label;
    test_descr   = test.descr;
    test_label   = test.label;
    clear train test;
 
    trainPerClass_num = sum(train_label == 1);
    class_num         = max(test_label);
    trainAll_num      = length(train_label);
    testAll_num       = length(test_label); 

    M = zeros(trainAll_num, trainAll_num);
    for j = 1 : class_num
        k = (j-1)*trainPerClass_num+1 : j*trainPerClass_num;
        M(k,k) = train_descr(:,k)' * train_descr(:,k);
    end
    equation11 = train_descr' * train_descr;
    equation12 = lambda * eye(trainAll_num);
    equation14 = 2*beta * (equation11 + class_num*M);
    Alpha_l1 = zeros(trainAll_num, testAll_num);
    iter_R = 5; 
    for i = 1 : testAll_num
        y = test_descr(:,i);
        temp = zeros(1,trainAll_num);
        for j = 1 : trainAll_num 
            temp(j) = norm(y - train_descr(:,j),2);
        end
        Dnh = diag(temp);
        equation13 = gamma * Dnh;
        equation1  = equation11 + equation12 + equation13 + equation14;
        equation1_l1 = equation13 + equation14;
        solution   = equation1 \ train_descr' * y;
        for j = 1 : iter_R
            pre_y = train_descr * solution;
        	W_alpha = diag(1 ./ max(abs(solution), 1e-4));
            W_x     = diag(1 ./ max(abs(y - pre_y), 1e-6));
            solution = (equation1_l1+train_descr'*W_x*train_descr+lambda*W_alpha) \ train_descr'*W_x*y;
        end
        for j = 1 : class_num
            k = trainPerClass_num*(j-1)+1 : trainPerClass_num*j;
            errors(j) = norm(train_descr*solution - train_descr(:,k)*solution(k,1),2);   
        end    
        [~, es_test_label(i)] = min(errors);
        Alpha_l1(:, i) = solution;
    end
    accuracy = sum(es_test_label==test_label) / testAll_num;
    accuracy = accuracy * 100;
    
    if nargout >1
    Alpha0 = Alpha_l1;
    end

    if nargout > 2
        pre_label0 = [es_test_label; test_label];
    end
    
end