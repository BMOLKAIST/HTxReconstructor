function [T] = process_dealias(sp_loaded, bg_loaded, datainfo)
    n_m = datainfo.n_m; lambda = datainfo.lambda; PSF1 = datainfo.PSF1;
    sp_loaded_norm = ((sp_loaded)./(bg_loaded))-1;                         % incident normalization
    z_size = size(sp_loaded_norm,4);
    for i = 1:size(sp_loaded_norm,1)
        for ii=1:z_size
            temp = squeeze(sp_loaded_norm(i,:,:,ii));
            sp_loaded_norm(i,:,:,ii) = normalization_shift(temp);
        end
    end
    
    %%% Deconvolution, reconstructing RI
    T = single(0);
    x=single(linspace(0,z_size-1,z_size));
    for r = 0:2
        disp(r)        
        
        scale = exp(-1i*2*pi*r/(3*z_size)*x);
        U_modi = sp_loaded_norm.*reshape(scale, 1, 1,1,34); % scale term for each z-axis
        u_eff = zeros(size(sp_loaded_norm),'single','gpuArray');  
        % sample intensity, to the fourier space 
        for pattern = 1:4
            u_eff(pattern,:,:,:) = exp(-1i*2*pi*r/3)*fftn(gpuArray(squeeze(U_modi(pattern,:,:,:))));  % exponential r for global phase
        end
        u_eff = gather(u_eff);
        clear U_modi
        
        Convo = u_eff.*PSF1(:,:,:,linspace(1+r,1+r+3*(z_size-1),z_size));      
        Convo = squeeze(sum(Convo,1));
        clear u_eff;
        % t_eff =exp(1i*2*pi*r/3)*ifftn(gpuArray(Convo))/3; 원래는 이렇게 되어있었으나
        % convention 변환하는 과정에서 k^2 term이 누락된 듯 합니다. k^2 = (n_m/lambda)^2 로
        % 대입하여 아래줄 변경하였습니다.
        t_eff =exp(1i*2*pi*r/3)*ifftn(gpuArray(Convo))/3*(n_m/lambda)^2;

        t_eff = gather(t_eff);
        T = T + t_eff.*reshape(scale.^-1, 1, 1,34);
    end
end