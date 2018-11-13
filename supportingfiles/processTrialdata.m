% processTrialdata
%%
rect = Screen('Rect', 0);
%%
fontsize = 10;
%%
 preallocate %check what this does
%%
%find button presses where params end.
idxstart= find(dataExp(1,:)==0, 1, 'first');
buttonpresses = dataExp(:,idxstart:end);

reportedcatch = [];

for i = 1:size(dataExp,1)
    press_start = find(diff(buttonpresses(i,:))==1);
    press_end = find(diff(buttonpresses(i,:))==-1);
    
    catch_startend = dataExp(i,idxstart-2:idxstart-1); %index of catch frames
    
    if length(press_start)>length(press_end)
        press_end = [press_end size(buttonpresses,2)]; %button held till end of trial
    end
    
    
    startendpresses = [press_start ;press_end];
    ss = [];
    
    for j = 1:size(startendpresses,2)
        ss = [ss all(startendpresses(:,j)<catch_startend(1)) || all(startendpresses(:,j)>catch_startend(2))];
        %removes button presses which overlap catch
    end
    
    reportedcatch = [reportedcatch any(1-ss)];
    durs{i} = press_end(logical(ss))-press_start(logical(ss));
    
    catchtrace = zeros(1,size(buttonpresses,2));
    catchtrace(catch_startend(1):catch_startend(2)) = 1;
    catchtraces{i} = catchtrace;
end
catchtrace = zeros(1,size(buttonpresses,2));
catchtrace(catch_startend(1):catch_startend(2)) = 1;
close all


rowscols = size(dataExp,1)/2;
timing = 1:size(buttonpresses,2);
timing = timing/win.RefreshRate;


%%
%  set(0, 'DefaultFigurePosition', []);
clf
figure(1)
set(gcf, 'Position', [0 0 rect(3) rect(4)], 'name', num2str(Targtype), 'numbertitle', 'off', 'color', 'w')
printfilename= [num2str(subject) '_TrialbyTrial'];
%
for i=1:size(dataExp,1)
    
    subplot(rowscols,2,i)
    area(timing, buttonpresses(i,:))
    hold on
    plot(timing, catchtraces{i},'r','linewidth',2)
    ylim([0 1.5]);
    title(['Trial ' num2str(i)], 'fontsize', fontsize*2)
    xlabel('Time (s)', 'fontsize', fontsize)
    
    %labelling
%     if trialdata{i}.targetx1==-1
%         targx= 'Target Left';
%     else
%         targx= 'Target Right';
%     end
%     text(10,1.25,[ targx ', ' num2str(trialdata{i}.flicker) 'Hz, Contrast ' num2str(trialdata{i}.contrast)], 'fontsize', fontsize)
%     
    % display avg duration and count
   countdisap = length(durs{i});
    avgdur = round(100*(mean(durs{i}))/ win.RefreshRate); %in seconds
    
   text(1, 1.25, [num2str(countdisap) ' disap.'], 'fontsize', fontsize)
   text(1, 1.10, ['Avg  ' num2str(avgdur/100) 'sec'], 'fontsize', fontsize)

   %reported catch?
   if reportedcatch(i) ==0
       title(['Trial' num2str(i) ' CATCH FAIL'], 'fontsize', fontsize*2);
   end
   
    set(gca, 'yTick',  [0 1], 'YTicklabel', { '0' 'Button Press'});
    set(gca, 'fontsize', fontsize)         
    
    hold off
end
cd(savebasesubject)
% print(gcf, '-dpng', printfilename);
screen2jpeg(printfilename);
sca
%% process each trial for number of disap, total duration, and avg. in seconds
Each_trialdata=[];
for i = 1:length(durs)
%     switch trialdata{i}.targetx1
%         case -1
%             location = 'L';
%         case 1
%             location = 'R';
%     end
%     switch trialdata{i}.targety
%         case -1
%             locationY = 'Upper';
%     end
    Each_trialdata{i}.upperLeft= options(trialdata{i}.condition,2);
    Each_trialdata{i}.upperRight = options(trialdata{i}.condition,3);
    Each_trialdata{i}.lowerLeft =options(trialdata{i}.condition,4);
    Each_trialdata{i}.lowerRight =options(trialdata{i}.condition,5);
    Each_trialdata{i}.disapinframes = durs{i};
    Each_trialdata{i}.disapinSECS = durs{i}./win.RefreshRate;
    Each_trialdata{i}.numdisap = length(durs{i});
    Each_trialdata{i}.reportedcatcg = reportedcatch(i);
    
end
%%
RefreshRate= win.RefreshRate;

save('Avg_trialdata', 'Each_trialdata', 'RefreshRate')%This gives an error. 
