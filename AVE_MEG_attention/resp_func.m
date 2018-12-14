%% This function is used to define the response actions. Data are also recorded to the data frame.
% if you want a finit ammount of time to respon, provide time_resp.
% Otherwise you can set this time as Inf.
% Alexis Perez Bellido 2017

function [response RT correct color Experimentalsession] = resp_func(vbl, time_resp, Experimentalsession, block, iTrial, cond, visual_stim, pahandle, response_options, rel_event_times, MEG)

quest_task = Experimentalsession(block).quest_task;
 % Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey   = KbName('ESCAPE');
leftKey     = KbName('LeftArrow');
rightKey    = KbName('RightArrow');
ifi = Experimentalsession(block).init.ifi;

% initialize some flags
respToBeMade = true;
rel_time = 0;
response = 0; % no response
correct = 0;

if MEG.use
    MEG.bitsi.clearResponses();
    [button RT] = MEG.bitsi.getResponse(time_resp, true); % leave some time (2 frames) to ESCAPE the program
    if button == 98
        response = 1;
    end
    if button == 99
        response = 2;
    end
else
    while (respToBeMade == true & rel_time < time_resp) % enter response loop and exit two frames before feedback
        rel_time = GetSecs - vbl; % compute time relative to last flip
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapeKey)
            close_program(pahandle);
            break;
            return
        elseif keyCode(leftKey)
            response = 1;
            % disp(keyIsDown);
            respToBeMade = false;
        elseif keyCode(rightKey)
            response = 2;
            %disp(keyIsDown);
            respToBeMade = false;
        end
    end
    % if using keyboard calculate RT this way
    RT = secs - vbl;
    
end
% adjust for correct or incorrect response if you want feedback



% Compute correct or incorrect response
if response    
    if mod(block,2) | quest_task
        % verifying whether response is correct or incorrect DETECTION TASK
        if (strcmp(cond(iTrial).v_stim, 'signal') & response_options(response) == 'Y') | ...
                (strcmp(cond(iTrial).v_stim, 'noise') & response_options(response) == 'N')
            correct = 1;
        end        
    else
        % verifying whether response is correct or incorrect COLOR
        % DISCRIMINATION TASK
        if (strcmp(cond(iTrial).samediff, 'same') & response_options(response) == 'S') | ...
                (strcmp(cond(iTrial).samediff, 'different') & response_options(response) == 'D')
            correct = 1;
        end
    end
    
    %% Assign color for feedback fixation point
    if correct
        color = [0, 0.7, 0]; % correct
    else
        color = [1, 0, 0]; % incorrect
    end
else
    color = [1, 1 , 1]; % not response recorded
end


%% Saving responses vector in datamatrix
% Experimentalsession.results.responses_vector_variables 
%  {'subject_ID','block','trial','trial_time','templ_time','1cue_time','Stim_time','2cue_time','condition',
%  'grating_tilt', 'modality' ,'contrast','SF','order','retrocued','samediff','keypressed','correct','RT'};

subj = Experimentalsession(block).params.initials;

trial_data = {subj block iTrial  rel_event_times.trialtime  rel_event_times.templatetime rel_event_times.cue1time rel_event_times.stimtime rel_event_times.cue2time ...
    char(cond(iTrial).v_stim) visual_stim.gtilt char(cond(iTrial).modality) visual_stim.contrast visual_stim.sf cond(iTrial).order cond(iTrial).retrocued char(cond(iTrial).samediff) response correct RT};%

% Append to results matrix 
Experimentalsession(block).results.responses_vector(iTrial,:) = trial_data;

p_correct = mean(cell2mat(Experimentalsession(block).results.responses_vector(1:iTrial,18)))
disp(['Proportion of correct responses = ' num2str(p_correct)]);
disp(response)
end