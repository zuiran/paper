function [accuracy] = DSRC(lambda, train, test)
%    
    train_data  = train.descr;
    train_label = train.label;
    test_data   = test.descr;
    test_label  = test.label;
    clear train test;
    trainPerClass_num = sum(train_label == 1);
    testAll_num = length(test_label);
%     testPerClass_num = sum(test_label == 1);
    class_num = max(test_label); 
    ex_data    = train_data';
    ex_data1  = train_data;
    data1       = test_data;
    errors=0;

    %% solve the equation (11)
    [size1, ~]=size(ex_data1);
    M=eye(trainPerClass_num*class_num);
    X=zeros(trainPerClass_num*class_num);
    for i=1:class_num
        xi=ex_data1(:,(i-1)*trainPerClass_num+1:i*trainPerClass_num);
        M((i-1)*trainPerClass_num+1:i*trainPerClass_num,(i-1)*trainPerClass_num+1:i*trainPerClass_num)=xi'*xi;
    end
    X=ex_data*ex_data';
    T=inv((1+2*lambda)*X+2*lambda*class_num*M);  % Matrix is close to singular or badly scaled. Results may be inaccurate. RCOND =  4.738178e-35. 
    %% classify the test samples
    for i=1 : testAll_num
        y(:,1)=data1(:,i);
        solution=T*ex_data*y;
        contribution0=zeros(size1,class_num);
        for kk=1:class_num
            for hh=1:trainPerClass_num
                contribution0(:,kk)=solution((kk-1)*trainPerClass_num+hh)*ex_data1(:,(kk-1)*trainPerClass_num+hh)+contribution0(:,kk);
            end
        end
        for kk=1:class_num
            wucha0(kk)=norm(y-contribution0(:,kk));
        end
        [recorded_value, record00]=min(wucha0);
        record0_class(i)=record00;

%         inte=floor((i-1)/testPerClass_num)+1;
%         label2(i)=inte;
        if record0_class(i)~=test_label(i)
            errors=errors+1;
        end
    end
    errors_ratio=errors/testAll_num;
    accuracy=1-errors_ratio;
    accuracy = accuracy * 100;
    
%     if nargout >1
%     Alpha0 = Alpha;
%     end
% 
%     if nargout > 2
%         pre_label0 = [es_test_label; test_label];
%     end

    
end