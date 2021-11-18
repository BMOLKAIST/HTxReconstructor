function [sp_loaded]=loading_stack_notiff_JY2(sp_path)
    %sp_path = 'D:\CBCData\2021\09\01\20210901.154006.683.SS21-19891_YUHS_5X5-001\20210901.154006.683.SS21-19891_YUHS_5X5-001P001\bgImages';
    sp_list = dir(strcat(sp_path,'\*.PNG'));

    temp = imread(strcat(sp_list(1).folder, '\', sp_list(1).name));
    sp_loaded = zeros(size(temp,1),size(temp,2),numel(sp_list),'single');
    

    img_ind=1;
    for i = 1:4
        for ii = i:4:length(sp_list)
            temp = imread(strcat(sp_list(ii).folder, '\', sp_list(ii).name));
%           sp_loaded(:,:,img_ind)=single(temp(:,:))*255;
            sp_loaded(:,:,img_ind)=single(temp(:,:));
            img_ind = img_ind+1;
        end
    end

    sp_loaded = reshape(sp_loaded,size(sp_loaded,1),size(sp_loaded,2),[],4);

    sp_loaded=permute(sp_loaded,[4 1 2 3]);
end