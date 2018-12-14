function AVE_MEG_CM(task)

% Alexis Perez-Bellido 21-6-2018
%% This is the third experiment of the AVE detection project.
% I have implemented a color memory discrimination task, which is the main
% task of the experiment 
% AVE_MEG_cM('main') main_task;
% The program also allows to calculate the visual detection threshold using the proper calls 
% AVE_MEG_cM('quest'); %quest_task;
% And practice detection blocks
% AVE_MEG_cM('detect'); %detection_task;

% Relative to the previos experiment, timings are different, I have
% optimized the frame rate control and possibly the sound presentation.
% I have also programed the experiment in a more modular fashion.

%% Triggers codes using BITSI (there are more triggers but these are the main ones)
% X0 Block number X (e.g. 10)
% X2 X3 1st Cue presentation (e.g. 12 or 15, First and second cue respectively)
% 1X3 1X4 Target (e.g. 113 or 114 noise or signal respectively) In noise events actually nothing happens


% indicate program whether use button box or keyboard
MEG.use = 1; % 0 behavioral, 1 with MEG.

quest_task = 0; % QUEST TASK
detect_task = 0; % JUST TO PRACTICE THE TASK

if strcmp(task, 'quest')
    quest_task = 1;    % AVE_MEG_cM('quest') quest_task;
end

if strcmp(task, 'detect')
    detect_task = 1;    %AVE_MEG_cM('detect') detection practice
end

%% First of all initialize main parameters of this experiment
init_variables;

%% Collecting subject data and verifying whether is the first session.
[Experimentalsession, block, path, outputFolder, dataFile] = subj_ID(init, quest_task,  detect_task);

%% Creating the different combinations of conditions for the experiment 
[Experimentalsession] = exp_design(Experimentalsession, block, dataFile);

%% Initialize media devices (window to draw visual stimuli and sound buffer)
% Screen('Preference', 'SkipSyncTests', 1);  % You might need to run this
% if your screen if PTB3 screen tests failed in your monitor. Dont use SkipSyncTest for accurate time presentation
init_media_devices;
HideCursor;
%% Creating the timing vector for the events on this experiment. It creates the timing relative to the monitor frame rate
[Experimentalsession] = exp_timings(Experimentalsession, block);

%% Creating an empty matrix to record online the conditions and subject responses during the experiment
[Experimentalsession] = data_matrix(Experimentalsession, block);

%% Pre-buffering visual and/or auditory stimuli (if you are using always a finit number of visual or auditory stim, it makes sense to precreate the texture here.
[pahandle]  = pre_buffering_stim(Experimentalsession, block, init, pahandle); 

%% Display some text with instructions 
task_instructions(init, win, block, quest_task,detect_task);

% Wait until instructions have been readed
if MEG.use
    MEG.bitsi.clearResponses
    MEG.bitsi.pahandle = pahandle;
   % MEG.bitsi.MEG = MEG;
    getResponse(MEG.bitsi,1000,true); % seems that when it says false, even if you press a button it doesnt exit the function
else
    KbWait(); % press a key to continue with the script
end

%% Create quest object variable to attach handles (inside of the function create_quest yo can configure your quests... 
% You can use the same function to update the quest after a correct or incorrect response)
%quest = [];
%quest.guess = Experimentalsession(block).params.guess;
% Create quest handle (you dont need to provide contrast now, only a guess value).
%quest = create_quest(quest, quest.guess, [], 0);
if quest_task
    quest = [];
    quest.guess = Experimentalsession(block).params.guess;
    quest = create_quest(quest, quest.guess, [], 0);
else
    quest = []; % I dont use quest here
end

%% Lets start to present the different trials
[Experimentalsession quest] = trial_function(win, Experimentalsession, init, quest, block, pahandle, MEG  );

if quest_task
    Experimentalsession(block).quest = quest;
    Experimentalsession(block).threshold = QuestMean(quest.q1)
    disp(['the estimated QUEST threshold is ' num2str(Experimentalsession(block).threshold)])
end
%% Save data in m matrix
save(dataFile,'Experimentalsession');
% save matrix data to txt file. This is convenient for analyses in R

%% Save data in txt file

datas = [Experimentalsession(block).results.responses_vector_variables;
               Experimentalsession(block).results.responses_vector];

subj = Experimentalsession(block).params.initials;

nrows = size(datas,1);

 
 if quest_task
     dataadaptoutput = [path filesep 'results' filesep 'subj_' subj '_block_' num2str(block) '_quest.txt'];
 else
     %if mod(block,2)
     %    dataadaptoutput = [path filesep 'results' filesep 'subj_' subj '_block_' num2str(block) '_det.txt'];
     %else
         dataadaptoutput = [path filesep 'results' filesep 'subj_' subj '_block_' num2str(block) '_cold.txt'];
     %end
 end

fileID = fopen([dataadaptoutput],'wt'); % try to write on top
formatheader = '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s \r\n';  

formatSpec = '%s %i %i %f %f %f %f %f %s %f %s %f %f %i %i %s %i %i %f \r\n';  

% writting header...
fprintf(fileID, formatheader , datas{1,:});
% writting data
for row = 2 : nrows
    fprintf(fileID, formatSpec, datas{row,:}) ;
end

fclose(fileID);


 block_finish(init, win, block,  datas);

 KbWait();
 

%% Close video and audio
close_program(pahandle, MEG);


%% feedback
corrects = [datas(2:end,18)];
contrast = [datas(2:end,12)];
response = [datas(2:end,17)];
%imagesc(cell2mat(corrects));
figure;
subplot(2,1,1);
plot(1:length(corrects), cell2mat(corrects)','o');
subplot(2,1,2);
plot( cell2mat(contrast) , cell2mat(response)','o');

end
