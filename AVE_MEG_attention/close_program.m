%% Here we close video and audio devices and shows cursor if removed
function close_program(pahandle, MEG)

ShowCursor;
Screen('Closeall')
PsychPortAudio('Close', pahandle)
if MEG.use
    MEG.bitsi.close();
end
end


