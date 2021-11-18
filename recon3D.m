clear all; clc;

% load PSF
load('C:\Users\CBC-A1-10\Desktop\matlab\psfMat102.mat'); %psf_water_1464 넣으면 됩니다

addpath(genpath('E:\pepsi_code\forDH\forDH\supplementary_codes'));
cd('D:\CBCData\2021\10\05\20211005.143309.712.bead_test-001\20211005.143309.712.bead_test-001P001'); %tile 모여져있는 folder
tile_list = dir('2021*');

for tile_num=1:length(tile_list)
    disp(['reconstruction in progress ... tile no. ',num2str(tile_num), ' out of ', num2str(length(tile_list))])
    cd([tile_list(tile_num).name]); 
    
    %%% dealiasing example
        spdir=dir('data3d');
    if tile_num==1
        bgdir=dir('bgImages');
        bg_loaded = loading_stack_notiff_JY2(bgdir(1).folder);
        bg_loaded = flip_stack(bg_loaded);
        bg_loaded = bg_loaded(:,:,237:237+1463,:); % image crop
        
        sp_loaded = loading_stack_notiff_JY2(spdir(1).folder); % generate (4(pattern) x y z) dimension 
        sp_loaded = flip_stack(sp_loaded);      % loading sample and background similarly to original version
        sp_loaded = sp_loaded(:,:,237:237+1463,:);  % image crop

        [RI] = processing_dealias2_JY3(sp_loaded, bg_loaded, PSF1); % scattering potential 
        Reconimg2 = n_m*sqrt(1-imag(RI));
        %figure, orthosliceViewer(flipud(Reconimg2),'Scale',[0.162 0.162 0.73]),colormap gray, axis image
        
        data1=Reconimg2;
        TomoData=dir('*.TCF');
        
        %save as mat file      
        data = flipud(data1);
        savepath = strcat(TomoData.folder,'\',TomoData.name(1:end-4),'_k_included.mat');
        save(savepath, 'data');
    else
        sp_loaded = loading_stack_notiff_JY2(spdir(1).folder);
        sp_loaded = flip_stack(sp_loaded);      
        sp_loaded = sp_loaded(:,:,237:237+1463,:); 


        [RI] = processing_dealias2_JY3(sp_loaded, bg_loaded, psfOriginal);
        Reconimg2 = n_m*sqrt(1-imag(RI));
        
        data1=Reconimg2;
        TomoData=dir('*.TCF');
        
        %save as mat file
        data = flipud(data1);
        savepath = strcat(TomoData.folder,'\',TomoData.name(1:end-4),'_k_included.mat');
        save(savepath, 'data');
    end
    cd ../
end


    



    