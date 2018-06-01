function [accuracy, Alpha0, pre_label0] = CNRC(lambda, gamma, train, test)
% 
    train_descr  = train.descr;
    train_label   = train.label;
    test_deser   = test.descr;
    test_label    = test.label;
    clear train test;
    trainPerClass_num = sum(train_label == 1);
    class_num           = max(test_label);
    trainAll_num         = length(train_label);
    testAll_num          = length(test_label); 
    %
    equation11 = train_descr' * train_descr;
    Alpha = [];
    for i = 1 : testAll_num
        y = test_deser(:, i);
        temp = zeros(1, trainAll_num);
        for j = 1 : trainAll_num 
            temp(j) = norm(y - train_descr(: ,j), 2);
        end
        Dnh = diag(temp);

        equation12 = lambda * eye(trainAll_num);
        equation13 = gamma * Dnh;
        equation1  = equation11 + equation12 + equation13;
        solution   = equation1 \ train_descr' * y; 
        for j = 1 : class_num
            k = trainPerClass_num*(j-1)+1 : trainPerClass_num*j;
    %                 errors(j) = norm(y-train_data(:,k)*solution(k,1),2) / norm(solution(k,1),2);
            errors(j) = norm(y-train_descr(:,k)*solution(k,1),2);   
%             errors(j) = norm(y - train_descr(:,k)*solution(k,1),2) / norm(solution(k,1), 2);   
        end    
        [~, es_test_label(i)] = min(errors);
        Alpha = [Alpha solution];
    end
    accuracy = sum(es_test_label==test_label) / testAll_num;
    accuracy = accuracy * 100;
%     accuracy = 0;
    if nargout >1
    Alpha0 = Alpha;
    end

    if nargout > 2
        pre_label0 = [es_test_label; test_label];
    end
    
end   