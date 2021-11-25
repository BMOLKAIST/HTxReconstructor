%% initialization
clear; clc;
head_dir=fileparts(matlab.desktop.editor.getActiveFilename);
addpath(genpath(fullfile(head_dir,'supplementary_codes')));

%% read recon_path.json and load PSF
path_info=loadJSON('recon_path.json');

% PSF information
% lambda: mean wavelength of illumination light(unit:um)
% n_m: RI of media
% NA_cond: NA of condensor lens
% NA_obj: NA of objective lens
% PSF1: Four PSF for each patterns
%       The size means (# of patterns)x(x axis)x(y axis)x(z axis x 3)
PSF_info=load(path_info.PSF_path,'PSF1','n_m','lambda','NA_cond','NA_obj');

%% reconstruction
for data_info=path_info.data_group
    reconstruct(data_info,PSF_info,head_dir)
end

%% main functions
function reconstruct(data_info,PSF_info,head_dir)
    % get data path
    data_path=data_info.path;
    
    % move to working directory
    cd(data_path);
    filelist=dir;
    reconstruction_list=filelist(~startsWith({filelist.name},'.'));
    
    % get background path and load background images
    if isfield(data_info,'background')
        background_path=data_info.background;
    else
        background_dirs=dir('*/bgImages/');
        background_path=background_dirs(1).folder;
    end
    background_loaded=readPepsidata(background_path);
    
    % reconstruction
    for tile_num=1:length(reconstruction_list)
        disp(['reconstruction in progress ... tile no. ',num2str(tile_num), ' out of ', num2str(length(reconstruction_list))])
        recon_dir=reconstruction_list(tile_num);
    
        %%% dealiasing
        sample_loaded=readPepsidata([recon_dir.name,'/data3d']);
    
        [RI] = process_dealias(sample_loaded, background_loaded, PSF_info); % scattering potential 
        data = PSF_info.n_m*sqrt(1-imag(RI));
        data = flipud(data);
        %figure, orthosliceViewer(flipud(Reconimg2),'Scale',[0.162 0.162 0.73]),colormap gray, axis image
    
        %save as mat file
        savepath = strcat(recon_dir.name,'\',recon_dir.name,'.mat');
        save(savepath, 'data');
    end

    % move back to original location
    cd(head_dir);
end

function data = readPepsidata(datadir)
    assert(isfolder(datadir), 'Given path should be directory');
    data=loading_stack_notiff(datadir); % generate (4(pattern) x y z) dimension
    data=flip_stack(data);              % loading sample and background similarly to original version
    data=data(:,:,237:237+1463,:);      % crop image
end

    



    