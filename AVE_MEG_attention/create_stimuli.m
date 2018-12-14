%% In this function I select the parameters for the stimuli in this trial. %
% I also update visual and auditory stimuli if it is necessary.
% It returns the visual stimuli, the conditions names of this trial, and
% the new state in the trial.

function [cond, visual_stim, basis_color, response_options] = create_stimuli(Experimentalsession, block, win, quest, iTrial, cond, visual_stim)

quest_task = Experimentalsession(block).quest_task;

init = Experimentalsession(block).init;

%% Visual symbols color codes (FPs)
visual_stim.color_fp = [0.7 0.7 0.7]; % rgb black
visual_stim.radious_fp = 1*init.ppd; % size of radius of fp in visual degrees
visual_stim.baseRect_fp = [0 0 visual_stim.radious_fp  visual_stim.radious_fp ]; % create a fake box to set the center of ovals
visual_stim.centeredRect_fp = CenterRectOnPointd(visual_stim.baseRect_fp, init.w/2, init.h/2);

%% see the names of your conditions
% Experimentalsession(block).design.exp_cond

%% Selecting conditions parameters and saving in structure
v_stim                 =   Experimentalsession(block).design_detect.stim_combinations(iTrial,1); % signal or noise?
cond(iTrial).v_stim    =   Experimentalsession(block).design_detect.exp_cond.v_stim(v_stim);
modality               =   Experimentalsession(block).design_detect.stim_combinations(iTrial,2); % visual or audiovisual?
cond(iTrial).modality  =   Experimentalsession(block).design_detect.exp_cond.modality(modality);
orientation               =   Experimentalsession(block).design_detect.stim_combinations(iTrial,3); % visual or audiovisual?
cond(iTrial).orientation  =   Experimentalsession(block).design_detect.exp_cond.orientation(orientation);


%% Creating grating texture; Selecting appropiated parameters and applying them..
% (here you can prepare anyother V stim texture)

% (if you know a priori the characteristics of the stimuli, this part can
% be moved to the pre-buffering section and create all the stimuli at once prior running trials).

% visual stim contrast. If it is noise, contrast should be = 0

if quest_task
    if strcmp (cond(iTrial).v_stim, 'noise')
        contrast = 0;
    else
        if quest.q1.updated_contrast > 0 % We should limit that the quest creates negative contrast values
            contrast = quest.q1.updated_contrast;
        else
            contrast = 0;
        end
    end
else
    if strcmp (cond(iTrial).v_stim, 'noise')
        contrast = 0;
    else
        contrast = Experimentalsession(block).params.contrast; %threshold;
    end
end




tilt    =  cond(iTrial).orientation; % generate a random orientation for this trial (between 0 and 359 degrees
sf      =  0.5;      % generate a random jitter for this trial
phi     = rand;
[img img_noise] = gabor_stim(init, contrast, tilt, sf, phi, init.gray, init.ppd);

% saving stim characteristics in a struct.
visual_stim.gtilt = tilt;
visual_stim.sf = sf;
visual_stim.contrast = contrast;
visual_stim.phi = phi;

%% Here I prepare the targets texture. Working with textures saves memory in the computer
% all the target textures were pre-generatedthe at the begining). Save the matrix always
% for regression analyses
% Creating textures and visual stim information (you can create multiple
% stimulus if you want, combining for loops and
visual_stim.gabortex = Screen('MakeTexture', win, img); %Texture generated
visual_stim.noisetex = Screen('MakeTexture', win, img_noise); %Texture generated
% Now we get some information of the stimulus to locate the texture in the screen
visual_stim.texrect  = Screen('Rect', visual_stim.gabortex); %Extract information about texture size
visual_stim.scale    = 1; % keep same proportion...
visual_stim.rotAngles = [0]; % we create the gratings already rotated, so no rotation parameter should be applied to the texture.
visual_stim.dstRects  = CenterRectOnPoint(visual_stim.texrect*visual_stim.scale , init.wMid, init.hMid); % coordinates to center the square

%% fixation color discrimination task

% I generate 2 different color cues in each trial (To prevent that people
% can learn their identity
%basis_color(iTrial).cues = [0.3 + round(unifrnd(-0.2,0.2)) 0.7 0.7; 
%                            0.7 0.3 + round(unifrnd(-0.2,0.2))  0.7];


%basis_color(iTrial).cues = [0.3 0.7 0.7; 0.7 0.3 0.7;  0.7 0.7 0.3];
%colors = [0.4 0.55 0.55; 0.55 0.4 0.55;  0.55 0.55 0.4];
colors = [0.6 0.8 0.8; 0.8 0.6 0.8;  0.8 0.8 0.6];

%orders = [1 2; 2 1]; % i dont really use this variable
% order is a dummy variable
order                   =   Experimentalsession(block).design_coldiscr.stim_combinations(iTrial,1); % not using order but maintain to keep same of factors
cond(iTrial).order      =   Experimentalsession(block).design_coldiscr.exp_cond.order(order );
retrocued               =   Experimentalsession(block).design_coldiscr.stim_combinations(iTrial,2); % what color is retrocued
cond(iTrial).retrocued  =   Experimentalsession(block).design_coldiscr.exp_cond.retrocued(modality);
samediff                =   Experimentalsession(block).design_coldiscr.stim_combinations(iTrial,3); % is the probe the same or different?
cond(iTrial).samediff   =   Experimentalsession(block).design_coldiscr.exp_cond.samediff(samediff);


% randomize what 2 of the 3 colors goes into the probes
cols_cues_randomized = randperm(3);
cols_trial = cols_cues_randomized(1:2);
basis_color(iTrial).cues = colors(cols_trial,:);



% selecting the test stimulus (same retrocued or third color)
if strcmp (cond(iTrial).samediff, 'same')
     basis_color(iTrial).test = basis_color(iTrial).cues(retrocued,:);
else
    %coldiff = [-0.1 0.1] ; % lets allow to change the values in different directions
    %coldiff =  coldiff(round(unifrnd(1,2)));
    cols_test_trial = cols_cues_randomized(3);
    basis_color(iTrial).test = colors(cols_test_trial,:);
end

% reorganize the color of the cues for this trial
%basis_color(iTrial).cues =  basis_color(iTrial).cues(orders(order,:),:);
%basis_color(iTrial).test =  basis_color(iTrial).cues(retrocued,:);
% transforming TEST stim vector color if different trial
%basis_color(iTrial).test =  cols_diff; % basis_color(iTrial).test + [coldiff -coldiff 0];  


%% Response options

if mod(block,2) | quest_task % odd blocks is visual detection task
    response_options = ['Y', 'N']; % left and right response option respectively
else
    response_options = ['S', 'D']; % left and right response option respectively
end

response_options = response_options(randperm(2));

end
