 function plotCalculations(savebasesubject, savebasegroup, dataExp, win, Targtype, flickers, contrasts, RefreshRate)

dbstop if error
cd(savebasesubject);
load('dataExp.mat')
%%
rect = Screen('Rect', 1);
%%
fontsize = 10;
%%
 preallocate
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
    if trialdata{i}.targetx1==-1
        targx= 'Target Left';
    else
        targx= 'Target Right';
    end
    text(10,1.25,[ targx ', ' num2str(trialdata{i}.flicker) 'Hz, Contrast ' num2str(trialdata{i}.contrast)], 'fontsize', fontsize)
    
    % display avg duration and count
   countdisap = length(durs{i});
   avgdur = round(100*(mean(durs{i}))/ RefreshRate); %in seconds
    
   text(1, 1.25, [num2str(countdisap) ' disap.'], 'fontsize', fontsize)
   text(2.5, 1.25, ['Avg  ' num2str(avgdur/100) 'sec'], 'fontsize', fontsize)

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
    switch trialdata{i}.targetx1
        case -1
            location = 'L';
        case 1
            location = 'R';
    end
    switch trialdata{i}.targety
        case -1
            locationY = 'Upper';
    end
    Each_trialdata{i}.flicker= trialdata{i}.flicker;
    Each_trialdata{i}.contrast = trialdata{i}.contrast;
    Each_trialdata{i}.target =[locationY location];
    Each_trialdata{i}.disapinframes = durs{i};
    Each_trialdata{i}.disapinSECS = durs{i}./RefreshRate;
    Each_trialdata{i}.numdisap = length(durs{i});
    Each_trialdata{i}.reportedcatcg = reportedcatch(i);
    
end
%%
save('Avg_trialdata', 'Each_trialdata', 'RefreshRate')


%% concatenate information by parameters
data = processtrialsbyParameterType(Each_trialdata);

%% %% run tests for significance
p_sig = checkexpforSIG(Each_trialdata);

%% Left/Right calcs
for i=1:size(Each_trialdata,2)
    
    % plot Left vs Right
    tmp = Each_trialdata{i};
    
    targetlocalx = tmp.targetx1;
    
    switch targetlocalx
        case -1 %left target
            L_totaldisap(i)= tmp.totaldisap_dur;
            L_numberdisap(i)=tmp.number_disap;
            L_avg_disap_seconds(i)=tmp.avg_disap_seconds;
            
        case 1 %right targets
            R_totaldisap(i)= tmp.totaldisap_dur;
            R_numberdisap(i)=tmp.number_disap;
            R_avg_disap_seconds(i)=tmp.avg_disap_seconds;
    end
end
%%  plot L/R
L_totaldisap=sum(L_totaldisap,2);
R_totaldisap=sum(R_totaldisap,2);

L_numberdisap=sum(L_numberdisap,2);
R_numberdisap=sum(R_numberdisap,2);

L_numberdisap_avg= L_numberdisap/size(dataExp,1);
R_numberdisap_avg=R_numberdisap/size(dataExp,1);

L_avg=L_totaldisap/L_numberdisap;
R_avg=R_totaldisap/R_numberdisap;

%  leftdata=[L_numberdisap, L_totaldisap, L_avg];
%  rightdata=[R_numberdisap, R_totaldisap, R_avg];

LRdisap=[L_numberdisap_avg,  R_numberdisap_avg];
LRdurat=[L_avg,  R_avg];

figure(2)
subplot(2, 2,1)
b= bar(LRdisap);
hold on
title('Left vs Right Target, avg number of disap', 'FontSize', fontsize);
%%
set(gca, 'xticklabel', {'Left' 'Right'}, 'fontsize', 20);
leghandle= legend('Avg(#)', 'Avg(s)');
set(leghandle, 'fontsize', 14);
ylimset=2*ylim;
ylim([ylimset]);

%% now flicker (low vs high)
lowtargetflicker = min(datam(:,3));
hightargetflicker=max(datam(:,3));

for i=1:size(Each_trialdata,2)
    
    tmp = Each_trialdata{i};
    targetflicker= tmp.flicker;
    
    switch targetflicker
        case lowtargetflicker
            lowhz_totaldisap(i)= tmp.totaldisap_dur;
            lowhz_numberdisap(i)=tmp.number_disap;
            lowhz_disap_seconds(i)=tmp.avg_disap_seconds;
        case hightargetflicker
            highhz_totaldisap(i)= tmp.totaldisap_dur;
            highhz_numberdisap(i)=tmp.number_disap;
            highhz_disap_seconds(i)=tmp.avg_disap_seconds;
    end
end
% plot low vs high
lowtotaldisap=sum(lowhz_totaldisap,2);
hightotaldisap=sum(highhz_totaldisap,2);

lownumberdisap=sum(lowhz_numberdisap,2);
highnumberdisap=sum(highhz_numberdisap,2);


Low_numberdisap_avg= lownumberdisap/size(dataExp,1);
High_numberdisap_avg=highnumberdisap/size(dataExp,1);

lowavg=lowtotaldisap/lownumberdisap;
highavg=hightotaldisap/highnumberdisap;

%  lowdata=[lownumberdisap, lowtotaldisap, lowavg];
%  highdata=[highnumberdisap, hightotaldisap, highavg];
%
lowdata=[Low_numberdisap_avg,  lowavg];
highdata=[High_numberdisap_avg,  highavg];

LowHighdata= [lowdata; highdata];

subplot(2,2,2)
b= bar(LowHighdata);
hold on
title([num2str(lowtargetflicker) ' vs ' num2str(hightargetflicker) ' (Hz)'], 'FontSize', 20);
ylim(ylimset)
set(gca, 'xticklabel', {[num2str(lowtargetflicker) ' (Hz)'] [num2str(hightargetflicker) ' (Hz)']}, 'fontsize', 20);
% leghandle= legend('# disap', 'Total(s)', 'Avg(s)');
leghandle= legend('Avg(#)', 'Avg(s)');
set(leghandle, 'fontsize', 14);

%% now contrasts
contrasts= datam(:,4)';

if range(contrasts,2)==0 %% analyses ends with low/high flicker
    
    subplot(2, 2, 3:4)
    text(.4,.5, ['single contrast experiment (' num2str(datam(1,4)) ')'], 'Fontsize', 20)
    
    print(gcf, '-dpng', [num2str(subject) '_Parameters']);
    
    
    proc.LRdata= LRdata;
    proc.LowHighdata= LowHighdata;
    
    %individual
    save(['Processed' num2str(Targtype) '(' num2str(lowtargetflicker) 'Hz,' num2str(datam(1,4)) '_Data.mat'], 'LRdata', 'LowHighdata');
    
    cd(savebasegroup) %groupdata
    
    filename=['AllProcessed' num2str(Targtype) '(' num2str(lowtargetflicker) 'Hz,' num2str(1,4) '_Data.mat'];
        
    try load(filename);
    Processed_SingleContrast = [Processed_SingleContrast, proc];
    
    catch
        Processed_SingleContrast = proc;
    
    end
    save(filename, 'Processed_SingleContrast');
    
    

    
else % range(contrasts,2)>0
    
    mincontrast = min(datam(:,4));
    midcontrast=mincontrast*3;
    maxcontrast=mincontrast*5;
    
    for i=1:size(Each_trialdata,2)
        
        tmp = Each_trialdata{i};
        targetcontrast= tmp.contrast;
        
        switch targetcontrast
            
            case mincontrast
                mincon_totaldisap(i)= tmp.totaldisap_dur;
                mincon_numberdisap(i)=tmp.number_disap;
                mincon_disap_seconds(i)=tmp.avg_disap_seconds;
                if tmp.flicker== lowtargetflicker
                    lowmin_totaldisap(i)= tmp.totaldisap_dur;
                    lowmin_numberdisap(i)=tmp.number_disap;
                    lowmin_disap_seconds(i)=tmp.avg_disap_seconds;
                else
                    highmin_totaldisap(i)= tmp.totaldisap_dur;
                    highmin_numberdisap(i)=tmp.number_disap;
                    highmin_disap_seconds(i)=tmp.avg_disap_seconds;
                end
            case midcontrast
                midcon_totaldisap(i)= tmp.totaldisap_dur;
                midcon_numberdisap(i)=tmp.number_disap;
                midcon_disap_seconds(i)=tmp.avg_disap_seconds;
                if tmp.flicker== lowtargetflicker
                    lowmid_totaldisap(i)= tmp.totaldisap_dur;
                    lowmid_numberdisap(i)=tmp.number_disap;
                    lowmid_disap_seconds(i)=tmp.avg_disap_seconds;
                else
                    highmid_totaldisap(i)= tmp.totaldisap_dur;
                    highmid_numberdisap(i)=tmp.number_disap;
                    highmid_disap_seconds(i)=tmp.avg_disap_seconds;
                end
                
            case maxcontrast
                maxcon_totaldisap(i)= tmp.totaldisap_dur;
                maxcon_numberdisap(i)=tmp.number_disap;
                maxcon_disap_seconds(i)=tmp.avg_disap_seconds;
                
                if tmp.flicker== lowtargetflicker
                    lowmax_totaldisap(i)= tmp.totaldisap_dur;
                    lowmax_numberdisap(i)=tmp.number_disap;
                    lowmax_disap_seconds(i)=tmp.avg_disap_seconds;
                else
                    highmax_totaldisap(i)= tmp.totaldisap_dur;
                    highmax_numberdisap(i)=tmp.number_disap;
                    highmax_disap_seconds(i)=tmp.avg_disap_seconds;
                end
                
        end
    end
    
    % plot min, mid, max contrasts
    mintotaldisap=sum(mincon_totaldisap,2);
    midtotaldisap=sum(midcon_totaldisap,2);
    maxtotaldisap=sum(maxcon_totaldisap,2);
    
    mincnumberdisap=sum(mincon_numberdisap,2);
    midcnumberdisap=sum(midcon_numberdisap,2);
    maxcnumberdisap=sum(maxcon_numberdisap,2);
    
    mincnumberdisap_avg=mincnumberdisap/size(dataExp,1);
    midcnumberdisap_avg=midcnumberdisap/size(dataExp,1);
    maxcnumberdisap_avg=maxcnumberdisap/size(dataExp,1);
    
    mincavg=mintotaldisap/mincnumberdisap;
    midcavg=midtotaldisap/midcnumberdisap;
    maxcavg=maxtotaldisap/maxcnumberdisap;
    
    %  mincon_data=[mincnumberdisap, mintotaldisap, mincavg];
    %  midcon_data=[midcnumberdisap, midtotaldisap, midcavg];
    %   maxcon_data=[maxcnumberdisap, maxtotaldisap, maxcavg];
    
    mincon_data=[mincnumberdisap_avg, mincavg];
    midcon_data=[midcnumberdisap_avg, midcavg];
    maxcon_data=[maxcnumberdisap_avg,  maxcavg];
    
    contrast_data= [mincon_data; midcon_data; maxcon_data];
    
    
    subplot(2, 2,3:4)
    b= bar(contrast_data);
    hold on
    title('Low vs Med vs High Contrast', 'FontSize', 20);
    ylim(ylimset)
    set(gca, 'xticklabel', {['Low(' num2str(mincontrast) ')'] ['Medium(' num2str(midcontrast) ')']  ['High(' num2str(maxcontrast) ')']}, 'fontsize', 20);
    legend('Avg(#)', 'Avg(s)')
    
    print(gcf, '-dpng', [num2str(subject) '_Parameters']);
    clf
    %%
    figure(3)
    
    % plot min, mid, max contrasts for low/high
    %  first all low
    lowmintotaldisap=sum(lowmin_totaldisap,2);
    lowmidtotaldisap=sum(lowmid_totaldisap,2);
    lowmaxtotaldisap=sum(lowmax_totaldisap,2);
    
    lowmincnumberdisap=sum(lowmin_numberdisap,2);
    lowmidcnumberdisap=sum(lowmid_numberdisap,2);
    lowmaxcnumberdisap=sum(lowmax_numberdisap,2);
    
    lowmincnumberdisap_avg=lowmincnumberdisap/size(dataExp,1);
    lowmidcnumberdisap_avg=lowmidcnumberdisap/size(dataExp,1);
    lowmaxcnumberdisap_avg=lowmaxcnumberdisap/size(dataExp,1);
    
    lowmincavg=lowmintotaldisap/lowmincnumberdisap;
    lowmidcavg=lowmidtotaldisap/lowmidcnumberdisap;
    lowmaxcavg=lowmaxtotaldisap/lowmaxcnumberdisap;
    
    %  mincon_data=[mincnumberdisap, mintotaldisap, mincavg];
    %  midcon_data=[midcnumberdisap, midtotaldisap, midcavg];
    %   maxcon_data=[maxcnumberdisap, maxtotaldisap, maxcavg];
    
    lowmincon_data=[lowmincnumberdisap_avg, lowmincavg];
    lowmidcon_data=[lowmidcnumberdisap_avg, lowmidcavg];
    lowmaxcon_data=[lowmaxcnumberdisap_avg,  lowmaxcavg];
    
    lowHzcontrast_data= [lowmincon_data; lowmidcon_data; lowmaxcon_data];
    
    
    subplot(2, 2,1:2)
    b= bar(lowHzcontrast_data);
    hold on
    title(['Low (' num2str(lowtargetflicker) ' Hz), by Contrast'], 'FontSize', 20);
ylim([ylimset])
set(gca, 'xticklabel', {['Low(' num2str(mincontrast) ')'] ['Medium(' num2str(midcontrast) ')']  ['High(' num2str(maxcontrast) ')']}, 'fontsize', 20);
    legend('Avg(#)', 'Avg(s)')
    
    
    %% now all high data
    highmintotaldisap=sum(highmin_totaldisap,2);
    highmidtotaldisap=sum(highmid_totaldisap,2);
    highmaxtotaldisap=sum(highmax_totaldisap,2);
    
    highmincnumberdisap=sum(highmin_numberdisap,2);
    highmidcnumberdisap=sum(highmid_numberdisap,2);
    highmaxcnumberdisap=sum(highmax_numberdisap,2);
    
    highmincnumberdisap_avg=highmincnumberdisap/size(dataExp,1);
    highmidcnumberdisap_avg=highmidcnumberdisap/size(dataExp,1);
    highmaxcnumberdisap_avg=highmaxcnumberdisap/size(dataExp,1);
    
    highmincavg=highmintotaldisap/highmincnumberdisap;
    highmidcavg=highmidtotaldisap/highmidcnumberdisap;
    highmaxcavg=highmaxtotaldisap/highmaxcnumberdisap;
    
    highmincon_data=[highmincnumberdisap_avg, highmincavg];
    highmidcon_data=[highmidcnumberdisap_avg, highmidcavg];
    highmaxcon_data=[highmaxcnumberdisap_avg,  highmaxcavg];
    
    highHzcontrast_data= [highmincon_data; highmidcon_data; highmaxcon_data];
    
    
    subplot(2, 2,3:4)
    b= bar(highHzcontrast_data);
    hold on
    title(['High (' num2str(hightargetflicker) ' Hz), by Contrast'], 'FontSize', 20);
    ylim(ylimset)
    set(gca, 'xticklabel', {['Low(' num2str(mincontrast) ')'] ['Medium(' num2str(midcontrast) ')']  ['High(' num2str(maxcontrast) ')']}, 'fontsize', 20);
    legend('Avg(#)', 'Avg(s)')
    
    %print plot
    print(gcf, '-dpng', [num2str(subject) '_interaction']);
    
    %save individual level
    save(['Processed_' num2str(Targtype) '_Data.mat'], 'LRdata', 'LowHighdata', 'contrast_data', 'lowHzcontrast_data', 'highHzcontrast_data')
    
    %%save data
    %group/exp
    
    proc.LRdata= LRdata;
    proc.LowHighdata= LowHighdata;
    proc.contrast_data = contrast_data;
    proc.lowXcontrast = lowHzcontrast_data;
    proc.highXcontrast=highHzcontrast_data;
    
    cd(savebasegroup)
    filename=['AllProcessed_' num2str(Targtype) '_Data.mat'];
    
    try load(filename)
        Processed_MultiContrast = [Processed_MultiContrast, proc] ;
    catch
        Processed_MultiContrast =proc;
    end
    
    save(filename, 'Processed_MultiContrast')
    
 end
