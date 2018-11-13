%% Code to run a flickering target, Troxler Fading experiment.
%
% saves buttonpress data per trial, and plots trialbytrial activity before printing as jpeg.

% MD 2/02/16

% cd('C:\Users\Eigenaar\Documents\Thesis\MATLAB\Code')
%cd('C:\Users\EEGStim\Desktop\TroxlerFadingxFlicker')
%%
dbstop if error
% clear all
%run code is here:
cd('/Users/MattDavidson/Desktop/FromIrenes Mac/Real_Experiment/Jeroens_EdgesCOPY_Sinussiod_TroxlerFadingxFlickerSeveralTargets')
makeGIF_isSLOW=0;

debugging=0; %1 to throw a smaller window, skip sync tests.
offscreen=1; %if not dual monitors, switch to 0
EEG = 0; %1 for EEGlab(send triggers etc)              
gaussEdges=1; %1 to soften edges of target
andCheckbd=1;

%%
%basic target parameters
contrasts=[ 1]; 

%Possible combinations of frequencies: [8, 13, 15, 18] [7, 12, 14, 16] [6, 13, 15,
%17] [8, 12, 14, 16] [7, 13, 17, 18
targetSize = [150]; %%I changed the code in several documents in order to present different sizes and locations across trials.
centricity = [4/10];
conditions=1:24;

ComputeConditions %this is very hardcoded for the current frequencies.
ComputeCatchTrials

startup_prep
ParameterSet

%     movieptr=Screen('CreateMovie', win.Number, 'ExampleTrial', [],[], 1/ifi);



%%
if proceedYN=='y'
try
    if debugging==0
        %%get subject data
        prevsubjinfo = GetPreviousSubjInfo('SubjSeedinfo.txt');   %% Get Previous Subject Names and RandomSeeds
        answerdlg    = MyDialogBoxes(prevsubjinfo);               %% Input Current Subject Name and RandomSeed
        
        %%
        if ~isempty(answerdlg)
            
            subject         = answerdlg{1};      % get subjects name
            randomseed      = answerdlg{2};      % get subjects seed for random number generator
            
            expstart        = datestr(now,'ddmmmyyyy-HH.MM');   % string with current date
        end
    end
    %%
    % set up the screen
    Screen('Preference', 'SkipSyncTests', 1);

    win = SetScreen('BGColor',p.backgroundcolour,' qFontSize',24,'OpenGL',1, 'debug', debugging, 'Window', offscreen);
    ifi = Screen('GetFlipInterval', win.Number);
    
    vbl = Screen('Flip', win.Number);
    Screen('BlendFunction', win.Number, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    PrepDynBackground;
    %% Construct input parameters for trial types
    
%     in.targety = [-1 1]; % only top half of screen, now both halfs
%     
%     
%     if simultaneousTargets == 1 %simultaneous dual targets
%         in.targetx1 = -1; %gets drawn everytime
%         in.targetx2 = 1; %gets drawn everytime
%     else
%         in.targetx1 = [-1 1]; %trials alternate locations on x axis 
%     end
%     
%     in.flicker = flickers; %trials alternate between flickers
%     in.contrast = contrasts;
    in.condition=conditions;
    in.size = targetSize; %%Added this to randomize size
    in.centricity = centricity; %%added this to randomize position
    
    
    trialdata = MakeInputFromStruct(in, 'SaveToFile',1, 'Randomize', 1, 'Replications', p.nreps); %p.nreps in ParameterSet for how many presentations of each motionxtarget combo
    
    ntrials = size(trialdata,2);
    
   %% create a movie for presentations.
    movieptr=Screen('CreateMovie', win.Number, 'ExampleTrial', [],[], 1/ifi);
    
    
    %% Run rest of experiment
    % Name of file to save data to
    
    if debugging<1
        savebasesubject = [savebasegroup filesep subject '_' answerdlg{3} answerdlg{4}];
        
        %create outpath folder if a new subject
        if exist(savebasesubject) ~= 7
            command = ['mkdir -p ' savebasesubject];
            system(command);
        end;
    end
    %% allocate memory for saving button press
    trialduration = p.trialdur*win.RefreshRate;
    empty_nframes = ceil(trialduration);
    datam = zeros(4,size(trialdata,2), empty_nframes);
    
    
    %% EYEMOVEMENT STUFF
    if usetobii==1
        eyemovParams
    else
    end
    
    %% Begin Stim Presentation
    for trial = 1:ntrials+1; %%+1 so that it repeats the first trial twice
        vblCount=0;
        if trial>1 %%This section makes it repeat the first trial twice.
            trial=trial-1;%%Allowing a practice trial
        end
        %set parameters for catch trial (where target is removed)
        CatchParams
        
        % create response vector
        respoTopLeft=zeros(1,empty_nframes);
        respoTopRight=zeros(1,empty_nframes);
        respoBottomLeft=zeros(1,empty_nframes);
        respoBottomRight=zeros(1,empty_nframes);
        
        % draw text prompt
        Screen('DrawText',win.Number,['Press any key to start trial ' num2str(trial) 'of ' num2str(ntrials)],win.Center(1), win.Center(2));
        Screen('Flip',win.Number);
        
        %turn off key echo
        ListenChar(2)
        
        % WaitSecs(2);
        KbStrokeWait(-1);
%         KbStrokeWait(-1);
        %         if debugging<1
        %          HideCursor
        %         end
        %% set modulating wave for flickering target
        targetParameters;
        
        %% eye tracking
        if usetobii==1;
            
            switch trialdata{trial}.dotmotion
                case 0
                    talk2tobii('EVENT', ['Trial_start_Sta_' num2str(trial)], 5 );
                case 1
                    talk2tobii('EVENT', ['Trial_start_Con_' num2str(trial)], 5 );
                case 2
                    talk2tobii('EVENT', ['Trial_start_Exp_' num2str(trial)], 5 );
                case 3
                    talk2tobii('EVENT', ['Trial_start_Ran_' num2str(trial)], 5 );
            end
        else
        end
        
        
        %% start animation
        InitialTime = GetSecs;
        iTest = -1;
        %         while 1
        i = ceil((GetSecs-InitialTime)*win.RefreshRate);
        
        for frame = 1:trialduration
           
            % Breaks if we finished
            if frame > trialduration(end)
                % Just in case final frame is not recorded, because that would
                % break the frame fixing function
                if isnan(respo(end, 3))
                    respo(end, :) = [1, 0, GetSecs - InitialTime];
                end
                break
            end
            
            % Waits for the next frame if we are getting ahead of ourselves
            if frame > iTest
                pause(((frame+1)/win.RefreshRate) - GetSecs);
                i = i + 1;
            end
            iTest = frame;
            
            
            % Triggers for EEG
            if EEG
                if frame ==1                                        
                    io64(ioObj,portcode, trial); %% trigger for trial start
                    
                elseif frame == trialduration(end);
                    io64(ioObj,portcode, 88); %% 88 is trial ended
                end
                
              
            end
            
           % remove target for catch trials
           
            if frame <= catchstart || frame >= catchend
                c_rampval = 1;
            else
                c_rampval = c_ramp(frame - catchstart + 1);
            end

            if EEG
               if c_rampval == 0
                    io64(ioObj,portcode, 66);
                elseif frame == round(catchend - (FrameRate*p.catchramp))
                    
                    io64(ioObj, portcode, 77);
                end
            end
            
            
            % send trigger/event codes to tobii
            if usetobii ==1;
                if frame == catchstart
                    talk2tobii('EVENT', 'Trial_catch_start', 5 );
                    
                elseif frame == catchend
                    talk2tobii('EVENT', 'Trial_catch_end', 5 );
                end
            else
            end
            
            %% %% %% %% %% %% %% %% %% %% %%
            %% draw fixation cross and target  %%
            %% %% %% %% %% %% %% %% %% %% %%
            dynamicBackgr;
            
            %drawTargetGL;
            drawTargetGLD; %use drawTargetGL to not have the dynamic background
            FixationCross;

            drawSquare;
            
            if frame==catchstart+catchramp;
               
%play sound to help with catch timing?
%                 sound(soundCATCH,fs);
                
            end
           
            
            %% if offscreen buffer full, move location
            startFlip(frame) = GetSecs;
            if (doublebuffer==1)
                [VBLTimestamp, StimulusOnsetTime, FlipTimestamp, Missed, Beampos,] = Screen('Flip', win.Number, vbl + (waitframes-0.5)*ifi);
%                 vblCount=vblCount+1;
%                 vblTimes(vblCount)=StimulusOnsetTime;
            end;
            endFlip(frame) = GetSecs;
            
            if makeGIF_isSLOW==1
            %stash screen for gif (used Nao's ASSC pres)
%             if ~ispath('/Users/MattDavidson/Desktop/TF_Project/Irene_gifs')
%                 addpath('/Users/MattDavidson/Desktop/TF_Project/Irene_gifs')
%             end
            giffilename= 'examplePFItrial.gif';
            if strcmp(num2str(pwd),num2str(savebasesubject))==0
                cd(savebasesubject)
            end
            makegif;
            
            end
            % collect button responses
            [keyIsDown, secs, keyCode] = KbCheck(-1);
            
            if keyIsDown
                
                if any(find(keyCode)==UpLeft)
                    respoTopLeft(frame) = 1;
                end
                if any(find(keyCode)==UpRight)
                    respoTopRight(frame) = 1;
                end
                if any(find(keyCode)==LowLeft)
                    respoBottomLeft(frame) = 1;
                end
                if any(find(keyCode)==LowRight)
                    respoBottomRight(frame) = 1;
                end
                
                % check for quit key
                if any(find(keyCode)==quitkey)
                    error('User ended program.')
                    sca
                end
            end
            
            if usetobii ==1
                
                if frame>1
                    if (respo(frame) == 1 && respo(frame-1) == 0)
                        talk2tobii('EVENT', 'Trial_button_press', 5 );
                    elseif (respo(frame) == 0 && respo(frame-1) == 1)
                        talk2tobii('EVENT', 'Trial_button_release', 5 );
                    end
                end
            else
            end
            Screen('Close', [blobtexLoc1 blobtexLoc2 blobtexLoc3 blobtexLoc4]); %texindexes(backgroundcounter,1) 
        end
        
        buttonpressTopLeft = respoTopLeft;
        buttonpressTopRight = respoTopRight;
        buttonpressBottomLeft = respoBottomLeft;
        buttonpressBottomRight = respoBottomRight;
        
        dataTopLeft = [options(trialdata{trial}.condition,:) catchTrials(options(trialdata{trial}.condition,1),:) Struct2mat(trialdata{trial}) catchstart catchend buttonpressTopLeft];
        dataTopRight = [options(trialdata{trial}.condition,:) catchTrials(options(trialdata{trial}.condition,1),:) Struct2mat(trialdata{trial}) catchstart catchend buttonpressTopRight];
        dataBottomLeft = [options(trialdata{trial}.condition,:) catchTrials(options(trialdata{trial}.condition,1),:) Struct2mat(trialdata{trial}) catchstart catchend buttonpressBottomLeft];
        dataBottomRight = [options(trialdata{trial}.condition,:) catchTrials(options(trialdata{trial}.condition,1),:) Struct2mat(trialdata{trial}) catchstart catchend buttonpressBottomRight];
        
        datam(1,trial,1:size(dataTopLeft,2)) = dataTopLeft; % backup to save as .mat file at end of experiment
        datam(2,trial,1:size(dataTopRight,2)) = dataTopRight;
        datam(3,trial,1:size(dataBottomLeft,2)) = dataBottomLeft;
        datam(4,trial,1:size(dataBottomRight,2)) = dataBottomRight;
        
        if debugging<1
            cd(savebasesubject)
            if saveq==1
                SaveToFile(dataTopLeft,'FileName',[subject '_TL_TF_flickerExp.txt']);
                SaveToFile(dataTopRight,'FileName',[subject '_TR_TF_flickerExp.txt']);
                SaveToFile(dataBottomLeft,'FileName',[subject '_BL_TF_flickerExp.txt']);
                SaveToFile(dataBottomRight,'FileName',[subject '_BR_TF_flickerExp.txt']);
            end
        end
        %             cd(taskpath)
        %         end
        
        filename = ['Trial' num2str(trial) '_data.mat'];
        save(filename, 'datam', 'dataTopLeft', 'dataTopRight', 'dataBottomLeft', 'dataBottomRight', 'trialdata', 'options', 'startFlip', 'endFlip')
        clearvars datam dataBottomLeft dataBottomRight dataTopLeft dataTopRight vblTimes startFlip endFlip
        
    end
    
    
    
    
    %save at subject level.
    dataExp = datam;%(:,1:size(data,2));
    SaveToFile({subject randomseed answerdlg{3} answerdlg{4}},'FileName','SubjSeedinfo.txt');
    
    if saveq==1;
        save('dataExp')
    end
    
    if usetobii==1
        TobiiClose (Exp)
    end
    ListenChar(0);
    
    
    filename=['AllRaw_' num2str(Targtype) '_Data_' num2str(subject) '.mat'];
    
    rawData = dataExp;
    
    if saveq==1
        save(filename, 'rawData');
    end
    
    
    %now add all data to matrix for large analysis.
    cd(savebasegroup)
    
    
    
    try load(filename) %concatenate if already existing
        
        rawData = [rawData; dataExp];
    catch
        rawData = dataExp;
    end
    
    if saveq==1
        save(filename, 'rawData');
    end
    
    
catch SETUP
    ListenChar(0);
    try
        %         TobiiClose (Exp)
    catch MT
    end
    p.endexp = datestr(now,'HH.MM');
    ShowCursor;
    clear screen;
    rmpath(supportpath);
    sca
    rethrow(SETUP);
end
else 
    disp('rethrow program from correct location')

end
sca
ShowCursor

% if saveq >0
%     processTrialdata
% end



