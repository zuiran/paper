function [accuracy, Alpha0, pre_label0] = ProCRC(lambda, gamma, train, test)
%
    train_descr   =   train.descr;
    test_descr   =   test.descr;
    train_label   =   train.label;
    test_label   =   test.label;
    clear train test;
    class_num  =   max(test_label);
%     testPerClass_num  = sum(test_label  == 1);
    testAll_num = length(test_label);
    tr_blocks = cell(1, class_num);
    for ci = 1: class_num
        tr_blocks{ci} = train_descr(:,train_label == ci)' * train_descr(:,train_label == ci);
    end
    tr_block_diag_mat = blkdiag(tr_blocks{:});
    tr_sym_mat = (gamma * (class_num - 2) + 1) * (train_descr' * train_descr) + gamma * tr_block_diag_mat + lambda * eye(size(train_descr, 2));
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
    
    if nargout >1
         Alpha0 = Alpha;
    end

    if nargout > 2
        pre_label0 = [pred_ttls; test_label];
    end
    
end