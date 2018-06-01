function ar2mat(sampleSize)
%from Dataset/AR_face folder, getting AR_data
%orginal pixel : 120x165; 100 classes; 14 samples per class.
%
    sample_height = sampleSize.sample_height;
    sample_width  = sampleSize.sample_width;
    clear sampleSize;
    %% reading images 
    if isunix
        folder = 'Dataset/AR_face/';             %linux style
        slash = '/*';                                    %linux style
    else
        folder = 'Dataset\AR_face\';             %windows style
        slash = '\*';                                    %windows style
    end
    file_extend = '.bmp';
    sample_dir = dir([folder,slash, file_extend]);    
    sampleAll_num = length(sample_dir);
    sample_dim     = sample_width * sample_height;
    sampleAll_data = zeros(sample_dim,sampleAll_num);
    Descr              = [];
    Label              = [];
    sampleAll_label = zeros(2,sampleAll_num);  

    %% get sampleAll_data matrix
    for i = 1 : sampleAll_num
        [sampleAll_label(1,i), sampleAll_label(2,i)] = getLabel(sample_dir(i).name);
        img = imread([folder, sample_dir(i).name]);  
        img = imresize(img, [sample_height, sample_width]);
        if ndims(img) == 2
            img = double(img);
        else
            img = double(rgb2gray(img));
        end
        sampleAll_data(:,i) =  img(:);
    end

    %% get sampleAll_label matrix and sort sampleAll_data
    class_num = max(sampleAll_label(1, :));
    for i = 1 : class_num
        index0 = find(sampleAll_label(1, :) == i);
        [~, index] = sort(sampleAll_label(2, index0), 'ascend');
        Descr = [Descr, sampleAll_data(:, index0(index))];
        samplePerClass_num = length(index0);
        Label = [Label, ones(1, samplePerClass_num).*i];
    end

    %% save ORL_data.mat 
    Data.descr = Descr;
    Data.label  = Label;
    clear Descr  Label;
    if isunix
        save(['Mat/AR_' num2str(sample_height) 'x' num2str(sample_width) '.mat'], 'Data');        %linux style
    else
        save(['Mat\AR_' num2str(sample_height) 'x' num2str(sample_width) '.mat'], 'Data');        %windows style
    end

end

%% seperate sample_name, like 's1_1.bmp'
function [label, num] = getLabel(sample_name)
    i       = strfind(sample_name, '_');
    label = str2num(sample_name(2 : i-1));
    j       = strfind(sample_name(i+1 : end), '.');
    num  = str2num(sample_name(i+1 : i+j-1)); 
end
