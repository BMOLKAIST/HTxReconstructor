clear; clc;

% custom variable
PSFfile='PSF_water_1464_dealias.mat';
data_dir='C:\Users\labdo\Desktop\20211005.135414.689.height_1mm_chip_bacteria-005';

%% initialization
% load functions
head_dir=fileparts(matlab.desktop.editor.getActiveFilename);
addpath(genpath(fullfile(head_dir,'supplementary_codes')));
% load PSF
% lambda: mean wavelength of illumination light(unit:um)
% n_m: RI of media
% NA_cond: NA of condensor lens
% NA_obj: NA of objective lens
% PSF1: Four PSF for each patterns
%       The size means (# of patterns)x(x axis)x(y axis)x(z axis x 3)
load(PSFfile);

%% reconstruction
cd(data_dir);
filelist=dir;
reconstruction_list=filelist(~startsWith({filelist.name},'.'));

% find dir containing bgIamges and load the background
background_dir=dir('*/bgImages/');
background_loaded=readPepsidata(background_dir(1).folder);

for tile_num=1:length(reconstruction_list)
    disp(['reconstruction in progress ... tile no. ',num2str(tile_num), ' out of ', num2str(length(reconstruction_list))])
    recon_dir=reconstruction_list(tile_num);

    %%% dealiasing
    sample_loaded=readPepsidata([recon_dir.name,'/data3d']);

    [RI] = processing_dealias2_JY3(sample_loaded, background_loaded, PSF1); % scattering potential 
    data = n_m*sqrt(1-imag(RI));
    data = flipud(data);
    %figure, orthosliceViewer(flipud(Reconimg2),'Scale',[0.162 0.162 0.73]),colormap gray, axis image

    %save as mat file
    savepath = strcat(recon_dir.name,'\',recon_dir.name,'_k_included.mat');
    save(savepath, 'data');
end

% move back to original location
cd(head_dir);

%%
function data = readPepsidata(datadir)
    assert(isfolder(datadir), 'Given path should be directory');
    data=loading_stack_notiff_JY2(datadir); % generate (4(pattern) x y z) dimension
    data=flip_stack(data);          % loading sample and background similarly to original version
    data=data(:,:,237:237+1463,:);  % crop image
end

    



    