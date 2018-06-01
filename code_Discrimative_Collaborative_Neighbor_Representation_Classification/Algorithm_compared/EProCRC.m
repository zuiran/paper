function [accuracy] = EProCRC(lambda, gamma, train, test)
%
    train_descr   =   train.descr;
    test_descr   =   test.descr;
    train_label   =   train.label;
    test_label   =   test.label;
    clear train test;
    class_num  =   max(test_label);
%     testPerClass_num  = sum(test_label  == 1);
    testAll_num = length(test_label);
    trainPerClass_num = sum(train_label == 1);
    a_mean = mean(train_descr,2);
    M = 0;
    for ci = 1 : class_num
        temp = train_descr;
        temp(:,train_label==ci) = zeros(size(train_descr,1),trainPerClass_num);
        a_ci_mean = mean(train_descr(:,train_label==ci),2);
%             M = M + exp(norm(a_mean-a_ci_mean,2))*temp'*temp;
        M = M + exp(-norm(a_mean-a_ci_mean,2))*temp'*temp;
    end
    tr_sym_mat = train_descr'*train_descr + gamma*M + lambda * eye(size(train_descr, 2));
%% compute projection matrix
    T = tr_sym_mat \ train_descr';
%% compute coding vectors
    Alpha = T * test_descr;
    coefs = Alpha;
    recon_tr_descr  =  train_descr * coefs;
    for ci = 1:class_num
        loss_ci = recon_tr_descr - train_descr(:, train_label == ci) * coefs(train_label == ci,:);
        pci = sum(loss_ci.^2, 1);
        pre_matrix(ci,:) = pci;
    end
    [~,pred_ttls] = min(pre_matrix,[],1);
    accuracy = sum(pred_ttls==test_label) / testAll_num;
    accuracy = accuracy * 100;
%     
%     if nargout >1
%     Alpha0 = Alpha;
%     end
% 
%     if nargout > 2
%         pre_label0 = [es_test_label; test_label];
%     end
   
    
end
