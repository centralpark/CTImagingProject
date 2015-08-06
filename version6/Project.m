% BMEN E4984 Biomedical Imaging Project
% CT image reconstruction using Direct Fourier Reconstruction
% Siheng He, Natalie Delport

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate the effct of number of projections
num_proj = [45 90 180 360];
SSE_proj = zeros(length(num_proj),2);
time_proj = zeros(length(num_proj),2);
N_image=201;
for i=1:length(num_proj)
    N_theta = num_proj(i);
    tic
    Reconstruct_image = FourierReconstruction(N_theta,N_image,'linear',inf,0);
    time_proj(i,1) = toc;
    save_result(Reconstruct_image,strcat('Number of Projections:  ',...
        num2str(N_theta)));
    SSE_proj(i,1) = evaluation(N_image,Reconstruct_image);
    
    d_theta = 180/N_theta;
    theta = linspace(0,180-d_theta,N_theta);
    rad = radon(phantom(N_image),theta);
    tic
    irad = iradon(rad,theta);
    time_proj(i,2) = toc;
    save_result(irad,strcat('Number of Projections:  ',num2str(N_theta),...
        '(iradon)'));
    SSE_proj(i,2) = evaluation(N_image,irad(1:N_image,1:N_image));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate the effct of image size
N_theta = 180;
image_size = [201 301 401 501];
SSE_size = zeros(length(image_size),2);
time_size = zeros(length(image_size),2);
d_theta = 180/N_theta;
theta = linspace(0,180-d_theta,N_theta);
for i=1:length(image_size)
    % evaluate DFR
    N_image = image_size(i);
    tic
    Reconstruct_image = FourierReconstruction(N_theta,N_image,'linear',inf,0);
    time_size(i,1) = toc;
    save_result(Reconstruct_image,strcat('Image Size:  ',...
        num2str(N_image)));
    SSE_size(i,1) = evaluation(N_image,Reconstruct_image)/(N_image/201)^2;
    % evaluate iradon
    rad = radon(phantom(N_image),theta);
    tic
    irad = iradon(rad,theta);
    time_size(i,2) = toc;
    save_result(irad,strcat('Image Size:  ',num2str(N_image),'(iradon)'));
    SSE_size(i,2) = evaluation(N_image,irad(1:N_image,1:N_image))/(N_image/201)^2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate the effct of Interpolation Scheme
interp_m = cell(1,4);
interp_m{1}='nereast';
interp_m{2}='linear';
interp_m{3}='spline';
interp_m{4}='cubic';
SSE_interp = zeros(length(interp_m),2);
time_interp = zeros(length(interp_m),2);
N_theta = 180;
theta = 0:179;
N_image = 201;
for i=1:length(interp_m)
    % evaluate DFR
    tic
    Reconstruct_image = FourierReconstruction(N_theta,N_image,interp_m{i},inf,0);
    time_interp(i,1) = toc;
    save_result(Reconstruct_image,strcat('Interpolation Scheme:  ',...
        interp_m{i}));
    SSE_interp(i,1) = evaluation(N_image,Reconstruct_image);
    % evaluate iradon
    rad = radon(phantom(N_image),theta);
    tic
    irad = iradon(rad,theta);
    time_interp(i,2) = toc;
    save_result(irad,strcat('Interpolation Scheme:  ',interp_m{i},'(iradon)'));
    SSE_interp(i,2) = evaluation(N_image,irad(1:N_image,1:N_image));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluate noise tolerance
noise_level = [inf 60 40 20];
SSE_noise = zeros(length(noise_level),2);
time_noise = zeros(length(noise_level),2);
N_image=201;
N_theta=180;
theta=0:179;
for i=1:length(noise_level)
    SNRdB = noise_level(i);
    tic
    Reconstruct_image = FourierReconstruction(N_theta,N_image,'linear',SNRdB,0);
    time_noise(i,1) = toc;
    save_result(Reconstruct_image,strcat('SNR =  ',num2str(SNRdB),' dB'));
    SSE_noise(i,1) = evaluation(N_image,Reconstruct_image);
    
    
    rad = radon(phantom(N_image),theta);
    tic
    rad = add_noise(rad,SNRdB);
    irad = iradon(rad,theta);
    time_noise(i,2) = toc;
    save_result(Reconstruct_image,strcat('SNR =  ',num2str(SNRdB),' dB (iradon)'));
    SSE_noise(i,2) = evaluation(N_image,irad(1:N_image,1:N_image));
end