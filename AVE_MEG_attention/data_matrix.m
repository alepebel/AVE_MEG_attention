function [Experimentalsession] = data_matrix(Experimentalsession, block);

%% creating a matrix that we can update with new data.
%% RECORDING DATA IN THIS TEMPLATE MATRIX
% define your variables of interest
Experimentalsession(block).results.responses_vector_variables = {'subj','block','trial','trial_time','templ_time','1cue_time','Stim_time','2cue_time','condition','grating_tilt', 'modality','contrast','SF','order','retrocued','samediff','keypressed','correct','RT'};
           
Experimentalsession(block).results.responses_vector = zeros(Experimentalsession(block).nTrials,length(Experimentalsession(block).results.responses_vector_variables)); % vector to record conditions 1 session, 2 trial, 3stim time, 4 orientation,5postcue,6intensity, 7 resp, 8 RT, 9 correct

% cell format.
Experimentalsession(block).results.responses_vector = num2cell(Experimentalsession(block).results.responses_vector);
% these will be my variables

end

% [nrows,ncols] = size(Experimentalsession.results.responses_vector); % this makes very slow the process. Record the data at the end in txt file
