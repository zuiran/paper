%  The code is a demo for the paper A New Discriminative Collaborative Neighbor Representation 
%  Method for Robust Face Recognition which is avaliable at https://github.com/zuiran/paper.
%  Different from the paper, the training samples in this demo are selected
%  in order for convenience.

%% initialization 
clear; clc;
addpath 'Utilities' 'Algorithm_compared' 'Model'
addpath(['Utilities' SYSROUTE 'spams-matlab' SYSROUTE 'build'])
load(['Mat' SYSROUTE 'ORL' '_32x32'])
[train, test] = getTrainAndTest(Data, 6);
train.descr = train.descr ./ 255;
test.descr  = test.descr  ./ 255;

%% test samples without noise
Model = {'DCNR', 'DSRC', 'CNRC', 'ProCRC', 'CRC', 'SRC'};
acc(1)      = DCNR(1e-5, 1, 0.01, train, test);
acc(2)      = DSRC(0.1, train, test);
acc(3)      = CNRC(1e-5, 10, train, test);
acc(4)      = ProCRC(1e-5, 0.01, train, test);
acc(5)      = CRC(10, train, test);
acc(6)      = SRC(train, test, 0.1, 0.0005);
for i = 1 : 6
   disp(['The accuracy of ' char(Model(i)) ' is ' num2str(acc(i)) ' % without noise.']) 
end

%% test samples with 30% random corruption
% test.descr = random_crop(test.descr.*255, 'c', 0.3) ./ 255;
% Model = {'R-DCNR', 'R-ProCRC', 'DCNR', 'DSRC', 'CNRC', 'ProCRC', 'CRC', 'SRC'};
% acc(1)      = DCNR_l1(1e-5, 10, 0.01, train, test);
% acc(2)      = ProCRC_l1(10, 1e-5, train, test);
% acc(3)      = DCNR(1e-5, 10, 0.1, train, test);
% acc(4)      = DSRC(0.1, train, test);
% acc(5)      = CNRC(1e-5, 10, train, test);
% acc(6)      = ProCRC(100, 0.1, train, test);
% acc(7)      = CRC(100, train, test);
% acc(8)      = SRC(train, test, 0.1, 0.0005);
% for i = 1 : 8
%    disp(['The accuracy of ' char(Model(i)) ' is ' num2str(acc(i)) ' % with 30% random corruption.']) 
% end

%% test samples with 30% block occlusion
% [train, test] = getTrainAndTest(Data, 5);
% test.descr = random_crop(test.descr, 'b', 0.3);
% train.descr = train.descr ./ 255;
% test.descr  = test.descr  ./ 255;
% Model = {'R-DCNR', 'R-ProCRC', 'DCNR', 'DSRC', 'CNRC', 'ProCRC', 'CRC', 'SRC'};
% acc(1)      = DCNR_l1(0.1, 1, 0.1, train, test);
% acc(2)      = ProCRC_l1(10, 0.01, train, test);
% acc(3)      = DCNR(1, 0.1, 0.1, train, test);
% acc(4)      = DSRC(10, train, test);
% acc(5)      = CNRC(1e-5, 10, train, test);
% acc(6)      = ProCRC(100, 0.01, train, test);
% acc(7)      = CRC(100, train, test);
% acc(8)      = SRC(train, test, 0.1, 0.0005);
% for i = 1 : 8
%    disp(['The accuracy of ' char(Model(i)) ' is ' num2str(acc(i)) ' % with 30% block occlusion.']) 
% end