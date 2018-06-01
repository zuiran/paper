function [Train, Test] = getTrainAndTest(Data, trainPerClass_num)
%
    tr_descr = [];
    tt_descr = [];
    tr_label = [];
    tt_label = [];
    for i = unique(Data.label)
        indexPerClass = find(Data.label == i);
        tr_descr = [tr_descr Data.descr(:, indexPerClass(1:trainPerClass_num))];
        tr_label = [tr_label Data.label(indexPerClass(1:trainPerClass_num))];
        tt_descr = [tt_descr Data.descr(:, indexPerClass(trainPerClass_num+1:end))];
        tt_label = [tt_label Data.label(indexPerClass(trainPerClass_num+1:end))];
    end
%     Train.descr = tr_descr./255;
%     Train.label = tr_label;
%     Test.descr  = tt_descr./255;
%     Test.label  = tt_label;
    Train.descr = tr_descr;
    Train.label = tr_label;
    Test.descr  = tt_descr;
    Test.label  = tt_label;
    
end

