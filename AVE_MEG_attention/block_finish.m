%% Basic example of an instructions screen
function task_instructions = task_instructions(init, win, block, datas)
Screen('FillRect', win, init.gray);

% some general parameters
max_n_ofcharperline = 60;
linesep = init.ppd * 0.04;

p_correct = mean(cell2mat(datas(2:end,18)));
disp(['Proportion of correct responses = ' num2str(p_correct)]);


Screen('TextSize',  win, round(init.ppd * 0.65));
if mod(block,2)
    title = ['VISUAL DETECTION TASK RESULTS'];
    DrawFormattedText(win,title , 'center', init.hMid-init.ppd*2, [0 0.9 0], max_n_ofcharperline,0,0,linesep);
    
    Screen('TextSize',  win, init.ppd * 0.5);
    firstext = ['Proportion of correct responses = ' num2str(round(p_correct*100)), '%', ...
        ''];
    DrawFormattedText(win,firstext , 'center', init.hMid-init.ppd, init.white, max_n_ofcharperline,0,0,linesep);
   
else
    
    title = ['COLOR MEMORY TASK RESULTS'];
    DrawFormattedText(win,title , 'center', init.hMid-init.ppd*2, [0 0.1 0.9], max_n_ofcharperline,0,0,linesep);
    
    Screen('TextSize',  win, init.ppd * 0.5);
      firstext = ['Proportion of correct responses = ' num2str(round(p_correct*100)), '%', ...
        ''];
    DrawFormattedText(win,firstext , 'center', init.hMid-init.ppd, init.white, max_n_ofcharperline,0,0,linesep);
   

end

% print buffer (update window)
Screen(win,'Flip');

end
