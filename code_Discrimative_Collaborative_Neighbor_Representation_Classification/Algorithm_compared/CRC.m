function [accuracy] = CRC(lambda, train, test)
%
    train_descr  = train.descr;
    train_label   = train.label;
    test_descr    = test.descr;
    test_label   = test.label;
    clear train test;
    trainPerClass_num = sum(train_label == 1);
%     testPerClass_num  = sum(test_label  == 1);
    class_num     = max(test_label);
    testAll_num    = length(test_label); 
    errors = zeros(1, class_num);
%% solution of CRC
    for i = 1 : testAll_num
        y = test_descr(:,i);
        solution_crc = (train_descr'*train_descr + lambda*eye(trainPerClass_num*class_num)) \ train_descr' * test_descr(:,i);
        for j = 1:class_num
            K = trainPerClass_num*(j-1)+1 : trainPerClass_num*j;
            errors(j) = norm(y-train_descr(:,K)*solution_crc(K)) / norm(solution_crc(K));
        end
        [~, es_test_label(i)] = min(errors);      
    end
    accuracy = sum(es_test_label==test_label) / testAll_num;
    accuracy = accuracy * 100;
    
%     if nargout >1
%     Alpha0 = Alpha;
%     end
% 
%     if nargout > 2
%         pre_label0 = [es_test_label; test_label];
%     end
end