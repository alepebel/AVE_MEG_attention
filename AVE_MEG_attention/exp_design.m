
%% Experiment conditions and design

function [Experimentalsession] = exp_design(Experimentalsession, block, dataFile);

quest_task = Experimentalsession(block).quest_task;

% I am going to create 2 orthogonal design matrixes. One for the detection experiment
% and another one for the attentional task.

%% Define the different conditions for detection experiment
exp_cond.v_stim = {'signal','noise'};
if quest_task
    exp_cond.modality = {'V'}; %
else
    exp_cond.modality = {'V','AV'};
end
exp_cond.orientation = [-45, 45];


if quest_task
    reps = 10;
else
    % Define number of repetitions
    if strcmp(Experimentalsession(block).params.initials, 'test')
        reps = 2;
    else
        reps = 12;
    end
end

% Combinations of conditions and randomization
allCombinations = combvec(1:numel(exp_cond.v_stim),1:numel(exp_cond.modality),1:numel(exp_cond.orientation));
allCombinations = allCombinations'; % transposing all combinations matrix
sizeComb        = length(allCombinations);
nTrials         = reps*sizeComb;
allCombinations = repmat(allCombinations,reps,1);

%generic variable to randomize trials order inside the allCombination
rand_trials_vector = 1 : nTrials;
rand_trials_vector = rand_trials_vector(randperm(nTrials));  % This will serve to select the corresponding arrow during the experiment.

%randomize order
stim_combinations = allCombinations(rand_trials_vector,:);

Experimentalsession(block).design_detect.stim_combinations = stim_combinations;
Experimentalsession(block).design_detect.repetitions = reps;

% save the different conditions conforming your experimental design
Experimentalsession(block).design_detect.exp_cond.v_stim = exp_cond.v_stim;
Experimentalsession(block).design_detect.exp_cond.modality = exp_cond.modality;
Experimentalsession(block).design_detect.exp_cond.orientation = exp_cond.orientation;


%% Define the different conditions for color discrimination task
if quest_task % this is a dummy variable that I use to equate the number of combinations in both tasks
    exp_cond.order = [1]; % what color is presented first and second
else
    exp_cond.order = [1 2]; % what color is presented first and second
end
exp_cond.retrocued = [1 2]; % what color the participants have to compare
exp_cond.samediff = {'same','different'}; % is it same or different test color


% Combinations of conditions and randomization
allCombinations = combvec(1:numel(exp_cond.order),1:numel(exp_cond.retrocued),1:numel(exp_cond.samediff));
allCombinations = allCombinations'; % transposing all combinations matrix
sizeComb        = length(allCombinations);
nTrials         = reps*sizeComb;
allCombinations = repmat(allCombinations,reps,1);

%generic variable to randomize trials order inside the allCombination
rand_trials_vector = 1 : nTrials;
rand_trials_vector = rand_trials_vector(randperm(nTrials));  % This will serve to select the corresponding arrow during the experiment.

%randomize order
stim_combinations = allCombinations(rand_trials_vector,:);

Experimentalsession(block).design_coldiscr.stim_combinations = stim_combinations;
Experimentalsession(block).design_coldiscr.repetitions = reps;

% save the different conditions conforming your experimental design
Experimentalsession(block).design_coldiscr.exp_cond.order = exp_cond.order;
Experimentalsession(block).design_coldiscr.exp_cond.retrocued = exp_cond.retrocued;
Experimentalsession(block).design_coldiscr.exp_cond.samediff = exp_cond.samediff;




Experimentalsession(block).nTrials = nTrials;


% saving the updated matrix (you can move this step to the end later
save(dataFile,'Experimentalsession');


end