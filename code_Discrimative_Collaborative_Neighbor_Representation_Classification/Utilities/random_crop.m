function [crop_descr] = random_crop(descr, crop_type, crop_ratio)
% return double
	sampleAll_num = size(descr, 2);
	sample_height = 32;
	sample_width  = 32;
% 	baboon = rgb2gray(imread('baboon.tif'));
    panda = rgb2gray(imread('Panda.jpg'));
    crop_descr = zeros(size(descr));
%     descr = descr .* 255;
    for i = 1 : sampleAll_num
		y = descr(:, i);
		y = reshape(y, sample_height, sample_width);
		switch crop_type
%             case 'n'
%                 type = 'n';
			case 'c'
				crop_y = random_pixel_crop(uint8(y), crop_ratio);
%                 type = ['c' num2str(crop_ratio)];
			case 'b'
				height  = floor(sqrt(sample_height * sample_width * crop_ratio));
        		width   = height;
        		r_h = round(rand(1, sampleAll_num) * (sample_height - height -1)) + 1;
        		r_w = round(rand(1, sampleAll_num) * (sample_width  - width  -1)) + 1;
				crop_y = random_block_occlu(uint8(y), r_h(i), r_w(i), height, width, panda);
%                 type = ['b' num2str(crop_ratio)];
		end
		crop_descr(:, i) = crop_y(:);
    end
%     crop_descr = crop_descr ./ 255;
% 	crop_Data.label = Data.label;
end

function [J] = random_pixel_crop(I,ratio)
	[h,w] = size(I);
	num_c = floor(ratio*h*w);
	tem_index = (ceil(h*w.*rand(20*num_c,1)));

	i =1;index_c = tem_index(1);j=1;
	while i<=num_c && j<size(tem_index,1)
	      if sum(index_c==tem_index(j+1))==0
	         index_c(i+1)=tem_index(j+1);
	         i = i+1;
	      end
	      j = j+1;
	end

	[hc,wc] = ind2sub(size(I),index_c);
	value_c = ceil(256.*rand(num_c,1))-1;
	J = I;
	for i = 1:num_c
	    J(hc(i),wc(i))=value_c(i);
	end
end	

function [J] = random_block_occlu(I,r_h,r_w,height,width,baroon)
	J = I;
	% baroon = rgb2gray(imread('baboon.tif'));
	J(r_h:r_h+height-1,r_w:r_w+width-1)= imresize(baroon,[height width]);
end