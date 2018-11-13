%% experiment
doublebuffer=1;
p.targetcolour = [255 255 255]; % = white;
%p.targetcolour = [255 0 0]; %yellow
p.backgroundcolour= [127.5, 127.5, 127.5]; %grey
%p.backgroundcolour = [ 0 0 0]; %black
% target_size = 100; % pixels
backgroundcounter=0;

p.nreps = 1; %how many repetitions of each trial type?

p.startexp = datestr(now,'HH.MM');
p.trialdur = 60; %seconds
waitframes=1; % show new image at each waitframes refresh

simultaneousTargets=0; %1 for dual targets, 0 for single

% eccentricities
% eccen_X_axis = 4/10; % e.g., 1/2 places eccentricty along x axis for targets at half the distance to center
% eccen_Y_axis = 4/10; % e.g., 1/2 places eccentricty along y axis for targets at half the distance to center

gaussEdges=1;

switch simultaneousTargets
    case 1;
        Targtype= 'DualTarget';
    case 0;
        Targtype= 'SingleTarget';
end

savebasegroup = [outdir filesep Targtype];

if exist([savebasegroup]) ~= 7
    command = ['mkdir -p ' savebasegroup];
    system(command);
end;


%skip save if debugging or short trial lengths.
if p.trialdur<60;
    saveq=1;
end
if debugging>0
    saveq=0;
end