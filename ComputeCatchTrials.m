%% Catch Trials for Four stimuli

%catches with 1 disap:
catch1dis(1,:)=[1,0,0,0];
catch1dis(2,:)=[0,1,0,0];
catch1dis(3,:)= [0,0,1,0];
catch1dis(4,:)= [0,0,0,1];
 
 %catches with 2 disap:
 catch2dis(1,:)=[1,1,0,0];
 catch2dis(2,:)=[0,1,1,0];
 catch2dis(3,:)=[0,0,1,1];
 catch2dis(4,:)=[1,0,1,0];
 catch2dis(5,:)=[0,1,0,1];
 catch2dis(6,:)=[1,0,0,1];
 
 %catches with 3 disap:
 catch3dis(1,:)=[1,1,1,0];
 catch3dis(2,:)=[0,1,1,1];
 catch3dis(3,:)=[1,0,1,1];
 catch3dis(4,:)=[1,1,0,1];

 %catches with 4 disap:
 catch4dis(1,:)=[1,1,1,1];
 catch4dis(2,:)=[1,1,1,1];
 catch4dis(3,:)=[1,1,1,1];
 catch4dis(4,:)=[1,1,1,1];
 catch4dis(5,:)=[1,1,1,1];
 catch4dis(6,:)=[1,1,1,1];
 
choicevec1= randperm(4);
catch1dis(5,:)=catch1dis(choicevec1(1),:);
catch1dis(6,:)=catch1dis(choicevec1(2),:);

choicevec2= randperm(4);
catch3dis(5,:)=catch3dis(choicevec2(1),:);
catch3dis(6,:)=catch3dis(choicevec2(1),:);

catchTrials(1:6,:)=catch1dis;
catchTrials(7:12,:)=catch2dis;
catchTrials(13:18,:)=catch3dis;
catchTrials(19:24,:)=catch4dis;
 