 % draws target to periphery based on targetx and targety, for each trial
 %  
 tbsize = 20;
 
 targetlocation = CenterRectOnPoint([0, 0, p.targetsize, p.targetsize], win.Center(1)+trialdata{trial}.targetx*p.eccx, win.Center(2)+trialdata{trial}.targety*p.eccy); % can replace target with targetx in second element and targety in third element

%  targetlocation = CenterRectOnPoint([0, 0, p.targetsize, p.targetsize], win.Center(1)+trialdata{trial}.target*p.eccx, win.Center(2)+trialdata{trial}.target*p.eccy); % can replace target with targetx in second element and targety in third element
 
 %Draw 10 pixel buffer around screen;
 targetbuffer = targetlocation +[-tbsize -tbsize tbsize tbsize]/2;
 Screen('FillOval', win.Number, [gray], [targetbuffer]);
%Draw target inside buffer.
 Screen('FillOval', win.Number, white, targetlocation);
 