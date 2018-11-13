%set up directories
basefol = pwd;
taskpath = basefol;
supportpath = [basefol filesep 'supportingfiles'];
addpath(supportpath);
taskpath = basefol;
addpath(taskpath);

outdir     = [basefol filesep 'BehaviouralData'];      % output data folder

disp('');
disp('');
disp('');
if debugging~=0
    disp('WARNING: Do you want to save behavioural data to... ');    
proceedYN = input([num2str(basefol) '/BehaviouralData/ ?'], 's');
else
    proceedYN='y';
end
    


%create if it doesn't exist.
if exist([outdir]) ~= 7
    command = ['mkdir -p ' outdir];
    system(command);
end;

%% Set up Keyboard
KbName('UnifyKeyNames');
key1        = KbName('LEFTARROW');
key2        = KbName('RIGHTARROW');
key3        = KbName('DOWNARROW');
quitkey     = KbName('Q');
space       = KbName('space');
UpLeft      = KbName('A');
UpRight      = KbName('K');
LowLeft      = KbName('Z');
LowRight      = KbName('M');
%answerkey  = space;
answerkey  = [UpLeft UpRight LowLeft LowRight];

%skips PTB sync tests for timing, useful when working on dual screens.
if debugging==1
Screen('Preference', 'SkipSyncTests', 1);
else
    Screen('Preference', 'SkipSyncTests', 0);
end

saveq=1; %1 to save data
usetobii = 0; %1 for eyetracking  

%% EEG Initialising
if EEG
    ioObj = io64; % initialise the mex command
    status = io64(ioObj); % Status of the driver
    portcode = hex2dec('0378'); % Portcode to send to EEG machine, 
end