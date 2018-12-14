
%% This function displays the stimuli in this experiment. Alexis Perez Bellido 11-2017

function [Experimentalsession quest] = trial_function(win, Experimentalsession, init, quest, block, pahandle, MEG)

%HideCursor;
quest_task = Experimentalsession(block).quest_task;
ifi = Experimentalsession(block).init.ifi;

cond = [];
visual_stim = [];

%while(find(keycode) ~= KbName('ESCAPE')) % press this key to stop the program (resp function also checks ESC)

% First flip. Time reference of the begining of the block
init_time = Screen('Flip', win); % collect init time of the experiment
vbl = init_time;
time_log = [];

% Animation loop: we loop for the total number of trials
for iTrial = 1 : Experimentalsession(block).nTrials
    
    rel_event_times = [];
    % create the stimuli for this trial and record the conditions
    [cond, visual_stim, basis_color, response_options] = create_stimuli(Experimentalsession, block, win, quest, iTrial, cond, visual_stim);
    
    oldPriority = Priority(2);
    % 1: frames to start 1st trial and draw fixation
    if iTrial == 1
        waitframes = Experimentalsession(block).frame_events.INIT_DELAY;
        Screen('FillOval', win,visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); % and fixation point
        vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi); % collect init time
    end
    
    %% I am going to verify that timing is correct
    time_exp = vbl - init_time; % measures relative elapsed time
    % saving relative time of this trial
    rel_event_times.trialtime =   time_exp;
        
    %plot(1:iTrial,trial_time_diff)
    trial_time_diff(iTrial) = Experimentalsession(block).time_events.TRIAL_TIMES(iTrial) - time_exp;
    time_log = [time_log vbl];
   
    
    %  After this time draw FP
    waitframes = Experimentalsession(block).frame_events.FP(iTrial);
    
    % Screen('DrawTextures', win, visual_stim.gabortex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('DrawTextures', win, visual_stim.noisetex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('FillOval', win, visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    Screen('DrawingFinished', win);
    %  Screen('DrawingFinished', win);
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    MEG.bitsi.sendTrigger((block*10)+1); % sends a trigger marking the trial init
    
    time_log = [time_log vbl];
    % relative time to begining of trial of template presentation
    rel_event_times.templatetime =  (vbl - init_time) - Experimentalsession(block).time_events.TRIAL_TIMES(iTrial); 
    
    
    %  After this timed draw the 1st cue
    waitframes = Experimentalsession(block).frame_events.T1(iTrial);
    Screen('DrawTextures', win, visual_stim.noisetex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('FillOval', win, basis_color(iTrial).cues(1,:), visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    Screen('DrawingFinished', win);
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    MEG.bitsi.sendTrigger((block*10)+2); % First cue trigger
    
    time_log = [time_log vbl];
    rel_event_times.cue1time =  (vbl - init_time) - Experimentalsession(block).time_events.TRIAL_TIMES(iTrial); 
    
    
    %  After this time draw back normal FP
    waitframes = Experimentalsession(block).frame_events.CUESTIMDUR;
    Screen('DrawTextures', win, visual_stim.noisetex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('FillOval', win, visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    Screen('DrawingFinished', win);
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi); 
    time_log = [time_log vbl];
    
        
    if strcmp(cond(iTrial).modality,'AV')
    sound_waitframes = Experimentalsession(block).frame_events.VSTIM(iTrial);
    %% Preparing auditory stimulus to be reproduced
    PsychPortAudio('Start', pahandle, 1, Inf); % Load A stim
    PsychPortAudio('RescheduleStart',pahandle, vbl + (sound_waitframes * ifi)-0.0025); % Set the time for presenting the sound (you might need to adjust this carefully)
    end
    
    % After this time draw Stim Grating
    waitframes = Experimentalsession(block).frame_events.VSTIM(iTrial);    
    Screen('DrawTextures', win, visual_stim.gabortex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('FillOval', win, visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    
    Screen('DrawingFinished', win);
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    time_log = [time_log vbl];
    
    if strcmp(cond(iTrial).v_stim,'signal')
        MEG.bitsi.sendTrigger(100+(block*10)+4); % Stim presentation
    else
        MEG.bitsi.sendTrigger(100+(block*10)+3); % Noise presentation
    end
    rel_event_times.stimtime =  (vbl - init_time) - Experimentalsession(block).time_events.TRIAL_TIMES(iTrial); 
    
    
    % After this time remove stim and draw only FP
    waitframes = Experimentalsession(block).frame_events.VSTIMDUR;
    Screen('DrawTextures', win, visual_stim.noisetex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('FillOval', win, visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    Screen('DrawingFinished', win);
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    time_log = [time_log vbl];
    
    %  After this timed draw the 2nd cue
    waitframes = Experimentalsession(block).frame_events.T2a(iTrial);
    Screen('DrawTextures', win, visual_stim.noisetex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('FillOval', win, basis_color(iTrial).cues(2,:), visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    Screen('DrawingFinished', win);
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    MEG.bitsi.sendTrigger((block*10)+5); % Second cue trigger
    
    time_log = [time_log vbl];
    rel_event_times.cue2time =  (vbl - init_time) - Experimentalsession(block).time_events.TRIAL_TIMES(iTrial); 
    
    
    %  After this time remove the cue and draw back normal FP
    waitframes = Experimentalsession(block).frame_events.CUESTIMDUR;
    Screen('DrawTextures', win, visual_stim.noisetex, [], visual_stim.dstRects, visual_stim.rotAngles); % draw texture
    Screen('FillOval', win, visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    Screen('DrawingFinished', win);
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    time_log = [time_log vbl];
    
    
    % close texture
    Screen('Close', visual_stim.gabortex);
    
    %  After this time draw response options + cue color in color task    
    waitframes = Experimentalsession(block).frame_events.RESP(iTrial);
    
              
    Screen('TextSize',  win, 3*init.ppd);
    DrawFormattedText(win, response_options(1), init.wMid - (5*init.ppd), 'center',  [0,0,0]); % right response option
    DrawFormattedText(win, response_options(2), init.wMid + (3*init.ppd), 'center',  [0,0,0]); % left response option
    
    % only show color probe fixation in color memory discrimination blocks
    if mod(block,2) | quest_task 
        colfix = visual_stim.color_fp;
    else
        colfix = basis_color(iTrial).test;
    end
    
    Screen('FillOval', win,colfix ,visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    time_log = [time_log vbl];
    
     %  After this time draw response options, without presenting color cue
    waitframes = Experimentalsession(block).frame_events.CUESTIMDUR;
    Screen('TextSize',  win, 3*init.ppd);
  
    DrawFormattedText(win, response_options(1), init.wMid - (5*init.ppd), 'center',  [0,0,0]); % right response option
    DrawFormattedText(win, response_options(2), init.wMid + (3*init.ppd), 'center',  [0,0,0]); % left response option
    Screen('FillOval', win, visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    MEG.bitsi.sendTrigger((block*10)+6); % Response options
    time_log = [time_log vbl];
    
    
    oldPriority = Priority(0);
    %  After this time draw Feedback
    waitframes = Experimentalsession(block).frame_events.RESPONSETIME;
    
    time_resp = (waitframes-2) * ifi; % translate to time (Participant has all these frames -2 to respond)
    
    [response RT correct color Experimentalsession] = resp_func(vbl, time_resp, Experimentalsession, block, iTrial, cond, visual_stim, pahandle, response_options, rel_event_times, MEG);
    
    % Draw feedback
    Screen('FillOval', win, color, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    time_log = [time_log vbl];
    
    
    % disp(RT)
    % Experimentalsession(block).results.responses_vector
    
    % Update quest handle (you need to provide contrast in the last trial).
    % Only for signal trials
    if strcmp(cond(iTrial).v_stim,'signal')
        if quest_task
            quest = create_quest(quest,[] ,quest.q1.updated_contrast, correct);
        end
    end
    
    % 6: erase feedback draw fixation and move on to the next trial
    waitframes = Experimentalsession(block).frame_events.FEEDBACK;
    Screen('FillOval', win, visual_stim.color_fp, visual_stim.centeredRect_fp, visual_stim.radious_fp); %color_fp
    vbl = Screen('Flip', win, vbl + (waitframes - 0.5) * ifi);
    time_log = [time_log vbl];
    
    
    % saving presentation times in relative times between events and
    % difference relative to expected trial initiation.
    Experimentalsession(block).log.time_log = time_log;         %diff(time_log);
    Experimentalsession(block).log.trial_time_log = trial_time_diff;
    
    % if time error relative to expected is too big (> 10ms), exit program
    if(abs(trial_time_diff(iTrial)) > 0.020)
        warning('time error relative to expected time larger than 20 ms')
        disp(trial_time_diff(iTrial))
      %  break
    end
    
    %end
       
end

end

