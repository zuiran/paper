function [accuracy, Alpha0, pre_label0] = ProCRC_l1(lambda, gamma, train, test)
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
    Alpha_l2 = T * test_descr;
    iter_R = 5;
    tr_sym_mat_xx = tr_sym_mat - train_descr'*train_descr - lambda*eye(size(train_descr,2)); 
    Alpha_l1 = [];
    for i = 1 : testAll_num
        alpha = Alpha_l2(:, i);
        y        = test_descr(:, i);
%         pre_y  = train_descr * alpha;
        for j = 1 : iter_R
            pre_y  = train_descr * alpha;
            W_alpha = diag(1 ./ max(abs(alpha), 1e-4));
            W_x       = diag(1 ./ max(abs(y - pre_y), 1e-6));
            alpha     = (tr_sym_mat_xx + train_descr'*W_x*train_descr + lambda*W_alpha) \ (train_descr'*W_x*y);
        end  
        Alpha_l1 = [Alpha_l1 alpha];
    end
    coefs = Alpha_l1;
    recon_tr_descr =  train_descr * coefs;
    for ci = 1:class_num
        loss_ci = recon_tr_descr - train_descr(:, train_label == ci) * coefs(train_label == ci,:);
        pci = sum(loss_ci.^2, 1);
        pre_matrix(ci,:) = pci;
    end
    [~,pred_ttls] = min(pre_matrix,[],1);

    accuracy = sum(pred_ttls==test_label) / testAll_num;
    accuracy = accuracy * 100;
    
    if nargout >1
         Alpha0 = Alpha_l2;
    end

    if nargout > 2
        pre_label0 = [pred_ttls; test_label];
    end
    
end