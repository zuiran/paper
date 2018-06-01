function [accuracy, Alpha0, pre_label0] = SRC(train, test, sp_level, eps)  % varargin
%  
    train_descr  = train.descr;
    train_label   = train.label;
    test_descr   = test.descr;
    test_label    = test.label;
    clear train test;
    for i = 1 : size(train_descr, 2)
        train_descr(:,i) = train_descr(:,i) ./ norm(train_descr(:,i));
    end
    for i = 1 : size(test_descr, 2)
        test_descr(:,i) = test_descr(:,i) ./ norm(test_descr(:,i));
    end
    testAll_num = length(test_label);
    trainAll_num = length(train_label);
    unique_label = unique(test_label);
    k = floor(sp_level * trainAll_num);
    
%     onesvecs = full(ind2vec(train_label));
    Alpha = [];
    param.L = k;            % 0.3
    param.eps = eps;      % 0.0005
    for i = 1 : testAll_num
        y = test_descr(:,i);
        a = mexOMP(y, train_descr, param);   % a is sparse double
        Alpha = [Alpha a];
    end

     pre_test_descr = train_descr * Alpha;
    for ci = 1 : length(unique_label)
        error = test_descr - train_descr(:, train_label==unique_label(ci))*Alpha(train_label==unique_label(ci), :);
        loss_ci(ci, :) = sum(error.^2, 1);
    end
    [~, index] = min(loss_ci, [], 1);
    for i = 1 : testAll_num
        pre_label(i)  = unique_label(index(i)); 
    end
    accuracy = sum(pre_label==test_label) / testAll_num;
    accuracy = accuracy * 100;
%     for i = 1 : max(test_label)
%         temp = test_descr-train_descr(:, train_label==train_label(unique_label(i)))*Alpha(train_label==train_label(unique_label(i)), :);
%         error(i,:) = sum(temp .* temp, 1);
%     end
%     [~, pre_label] = min(error, [], 1);
%     accuracy = sum(pre_label==test_label) / testAll_num;

if nargout >1
    Alpha0 = Alpha;
end

if nargout > 2
    pre_label0 = [pre_label; test_label];
end

end

