%% Basic example of an instructions screen
function task_instructions = task_instructions(init, win, block, quest_task)
Screen('FillRect', win, init.gray);

% some general parameters
max_n_ofcharperline = 60;
linesep = init.ppd * 0.04;

Screen('TextSize',  win, round(init.ppd * 0.65));
if  quest_task
    title = ['VISUAL THRESHOLD ESTIMATION TASK'];
    DrawFormattedText(win,title , 'center', init.hMid-init.ppd*5, [0 0.1 0.9], max_n_ofcharperline,0,0,linesep);
    
    Screen('TextSize',  win, init.ppd * 0.5);
    firstext = ['In this block you will have to DETECT a transient contrast change around the fixation point', ...
        ''];
    DrawFormattedText(win,firstext , 'center', init.hMid-init.ppd*2, init.white, max_n_ofcharperline,0,0,linesep);
    
    Screen('TextSize',  win, round(init.ppd * 0.5));
    secondtext = ['REMEMBER: At the end of each trial, press the button located in the same side as the response that you want to give. YES(Y) or NO(N) signal.' ];
    DrawFormattedText(win,secondtext , 'center', init.hMid+init.ppd*0.5, [255,255,255], max_n_ofcharperline,0,0,linesep);
    
    thirdtext = ['If you are ready, press one of the buttons to continue..' ];
    Screen('TextSize',  win, round(init.ppd * 0.3));
else
    if mod(block,2)
        title = ['VISUAL DETECTION TASK'];
        DrawFormattedText(win,title , 'center', init.hMid-init.ppd*5, [0 0.9 0], max_n_ofcharperline,0,0,linesep);
        
        Screen('TextSize',  win, init.ppd * 0.5);
        firstext = ['In this block you will have to DETECT a transient contrast change around the fixation point', ...
            ''];
        DrawFormattedText(win,firstext , 'center', init.hMid-init.ppd*2, init.white, max_n_ofcharperline,0,0,linesep);
        
        Screen('TextSize',  win, round(init.ppd * 0.5));
        secondtext = ['REMEMBER: At the end of each trial, press the button located in the same side as the response that you want to give. YES(Y) or NO(N) signal.' ];
        DrawFormattedText(win,secondtext , 'center', init.hMid+init.ppd*0.5, [1,1,1], max_n_ofcharperline,0,0,linesep);
        
        thirdtext = ['If you are ready, press one of the buttons to continue..' ];
        Screen('TextSize',  win, round(init.ppd * 0.3));
        DrawFormattedText(win,thirdtext , 'center', init.hMid+init.ppd*5, init.black, max_n_ofcharperline,0,0,linesep);
    else
        
        title = ['COLOR MEMORY TASK'];
        DrawFormattedText(win,title , 'center', init.hMid-init.ppd*5, [0.8 0.0 0.0], max_n_ofcharperline,0,0,linesep);
        
        Screen('TextSize',  win, init.ppd * 0.5);
        firstext = ['In this block you will have to REMEMBER THE COLOR of a changing fixation point', ...
            ''];
        DrawFormattedText(win,firstext , 'center', init.hMid-init.ppd*2, [0.0 0.8 0.0], max_n_ofcharperline,0,0,linesep);
        
        Screen('TextSize',  win, round(init.ppd * 0.5));
        secondtext = ['REMEMBER: At the end of each trial, press the button located in the same side as the response that you want to give SAME(S) or DIFFERENT (D).' ];
        DrawFormattedText(win,secondtext , 'center', init.hMid+init.ppd*0.5, [255,255,255], max_n_ofcharperline,0,0,linesep);
        
        thirdtext = ['If you are ready, press one of the buttons to continue..' ];
        Screen('TextSize',  win, round(init.ppd * 0.3));
        
    end
    
end

% print buffer (update window)
Screen(win,'Flip');

end
