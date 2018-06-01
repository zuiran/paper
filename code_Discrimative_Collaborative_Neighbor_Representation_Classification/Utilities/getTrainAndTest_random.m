function [Train, Test] = getTrainAndTest_random(Data, trainPerClass_num)
% samplePerClass_num are queal;
% 
   %% get train and test logical index
    trainIndex = zeros(1, length(Data.label));
    class_num = max(Data.label);
    for i = 1 : class_num
        indexPerClass = find(Data.label == i);
        samplePerClass_num = length(indexPerClass);
        index_random = randperm(samplePerClass_num);
        trainIndex(indexPerClass(index_random(1:trainPerClass_num))) =  1;
    end
    trainIndex = logical(trainIndex);
    testIndex  = ~trainIndex;
    
    %% return Train adn Test 
    Train.descr = Data.descr(:, trainIndex);
    Train.label  = Data.label(:, trainIndex);
    Test.descr  = Data.descr(:, testIndex);
    Test.label   = Data.label(:, testIndex);
end


