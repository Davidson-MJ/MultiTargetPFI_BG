
%catch paramaters%
p.catchbuffer  = [10 10];    % first n seconds, and last n seconds of the trial during which the catch trial cannot occur
p.catchdur     = [5 8];     % min and max duration of catch in sec;
p.catchramp    = 1.5;         % ramp luminance up and down; sec

p.catchrange   = [p.catchbuffer(1) p.trialdur-p.catchbuffer(2)];   % min and max START time of catch in sec;

catchstart      = round((p.catchrange(1) + diff(p.catchrange) * rand()) * win.RefreshRate);
catchduration   = round((p.catchdur(1)   + diff(p.catchdur) * rand())* win.RefreshRate);
catchend        = catchstart + catchduration;
catchramp       = round(p.catchramp * win.RefreshRate);

%if p.backgroundcolour== [ 0 0 0] %Different background colours don't
    %matter for alpha blending.
c_ramp = [fliplr(linspace(0,1,catchramp)) zeros(1,catchduration-2*catchramp) linspace(0,1,catchramp)];%This is set to a range 
    %from 1 to 0, so it can be used to set the alpha value for the stimulus.
%else %for grey
   % c_ramp = [fliplr(linspace(0.5,1,catchramp)) 0.5*ones(1,catchduration-2*catchramp) linspace(0.5,1,catchramp)];
%end


%can also play a sound to signal start of catch
% tdur = (catchend-catchramp)- (catchstart+catchramp);
%     fs = 44100; % Hz
%                 t = 0:1/fs:tdur/win.RefreshRate; % seconds
%                 f = 440; % Hz

%                 soundCATCH = sin(2.*pi.*f.*t);