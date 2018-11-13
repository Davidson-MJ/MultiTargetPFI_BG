% p.eccx = win.Center(1).*eccen_X_axis; 
% p.eccy = win.Center(2).*eccen_Y_axis; 
p.eccx = win.Center(1).*trialdata{trial}.centricity; 
p.eccy = win.Center(2).*trialdata{trial}.centricity; 

% p.targetsize = target_size; % pixels
p.targetsize = trialdata{trial}.size;
% 
% white = WhiteIndex(win.Number);
% black = BlackIndex(win.Number);
% gray= white/2;

p.occ_color=white;
modr= 0.5;
 

 %% %% %% %% %%
            % set modulating vector for flicker - so it doesnt just flash
            % in and out
            
           
            tspan= 0:trialduration-1; % fps
            
            %time vector for modulating values, between 0 and 1                        
%                 am1 = sin(2*pi*tspan*trialdata{trial}.flicker/win.RefreshRate - pi/2) * 0.5 + mod; 
am1 = sin(2*pi*tspan*options(trialdata{trial}.condition,2)/win.RefreshRate - pi/2) ;
am2 = sin(2*pi*tspan*options(trialdata{trial}.condition,3)/win.RefreshRate - pi/2) ;
am3 = sin(2*pi*tspan*options(trialdata{trial}.condition,4)/win.RefreshRate - pi/2) ;
am4 = sin(2*pi*tspan*options(trialdata{trial}.condition,5)/win.RefreshRate - pi/2) ;


% plot(am1)
% shg
% %             if p.backgroundcolour==127.5
%                 am2= (am1./2)+.5;
%                 am1=am2;
%             end
            
            
%             plot(am)
            
