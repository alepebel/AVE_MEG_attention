 %% function used to create the V stimulus. In this case only the contrast 
% and orientation might change in a trial by trial basis
% it requires an amplitud value for the sinusoud, tilt, spatial freq.,
% phase, and background gray in the experiment

function [img img_noise] = gabor_stim(init, contrast, tilt, sf, phi, gray, ppd)

% set default noisy Gabor parameters
cfg          = [];
cfg.gaborcon = contrast;
orientation = pi/180*tilt; % transform to radians
cfg.gaborphi = phi; % sinusoid phase
cfg.gaborang = orientation ; % Gabor orientation (rad)
cfg.ppd = ppd; % saving ppd in the experiment
cfg.patchsiz = ppd*22.0; % patch size (pix) give degrees 1 degree are ppd pixels
cfg.patchenv = ppd*5; % patch spatial envelope s.d. (pix)
cfg.envscale = 10^100; % patch scale spatial envelope (pix)
cfg.patchlum = 0.5; % patch ba ckground luminance
cfg.freq = sf; % spatial frequency (above 5 and adding noise the creation texture process seems to be very slow)
cfg.gaborper = ppd*(1/cfg.freq); % Gabor spatial period (pix) (Transformation from SF)
cfg.noisedim = cfg.gaborper/6; % noise dimension (pix)
cfg.noisecon = 0.3/3; % noise RMS contrast

patchsiz = cfg.patchsiz;
%% creating central mask
[rr cc] = meshgrid(1:patchsiz,1:patchsiz);
mask_radius = patchsiz/2;

mask(1).filter = sqrt((rr-(patchsiz/2)).^2+(cc-(patchsiz/2)).^2)<=mask_radius/2;  %center in pixels
mask(1).filter = mask(1).filter - (sqrt((rr-(patchsiz/2)).^2+(cc-(patchsiz/2)).^2)<=(0.75*ppd)); % add inner empty area
%init.cfg.diameter = init.cfg.patchsiz; % This way scale the gaussian evelop and I make the border very abrupt
%init.cfg.gaborang = tilt; % Gabor orientation (rad)

spatial_filter = mask(1).filter;
indexes_sf = find(spatial_filter == 0);

while true % loop until we generate an image that is not larger than 1 or 0 which are the rgb limits
    [img img_noise] = make_gabor_and_noise(cfg);
    % making not stimulus part like grey background if you apply a mask
    img(indexes_sf ) = 0.5;
    img_noise(indexes_sf) = 0.5;
    if all(img(:) > 0 & img(:) < 1) 
        break
    end
end

% scale to RGB values
img = (init.gray * img)/0.5; % save this if you want to measure the energy of the stimulus
noiseimg = (init.gray * img_noise)/0.5;


end
