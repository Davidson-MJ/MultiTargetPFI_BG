function [window] = SetScreen(varargin)
% Full help file will be writen in the future.....
%
% For now:
%
% StereoMode: StereoMode checks are taken from StereoDemo.m, see StereoDemo
%       for explanation. Briefly: 0 is monocular, 4 is left/right split, 6-9 are
%       different color combinations for anaglyphic glasses.
%
% Blending: can be set to 
%       'Transparent' (is equal to [GL.SRC_ALPHA GL.ONE_MINUS_SRC_ALPHA]
%       'Default'/'Replace' (is equal to [GL_ONE GL_ZERO]. 
%       You can also use SetBlending(window,type) after the SetScreen
%       call. This function also takes GL values as input for more flexibility.
%
% by JvB July, Aug 2011
% Aug 2011.     JvB first version
% Sept 2011.    JvB added blending functionality 



%% default parameters
debug       = 0;
windowin    = 0; 
fontsize    = 16;
fontcolor   = [255 255 255];   % white
BGColor     = 0;            
multiSample = 0;
imagingPipeline = 0;
OGL         = 0;    % is OpenGL set?

window= struct('Number', windowin, ...
    'Rect',         [0 0],  ...
    'Width',        0,      ...
    'Height',   	0,      ...
    'Center',   	[0 0],  ...
    'AspectRatio',  0,      ...
    'MultiSample',  multiSample,      ...
    'ImagingPipeline',imagingPipeline,    ...
    'Debug',        debug,      ...
    'BGColor',      BGColor,     ...
    'OpenGL',       OGL,    ...
    'LCD',          0,...
    'IsWin',        1,...
    'StereoMode',   0,...
    'Blending',     []);

global GL;
%% update parameters based on passed arguments
if nargin > 0
    for index = 1:2:length(varargin)
        field = varargin{index};
        val = varargin{index+1};
        switch field
            case {'Debug', 'debug'}
                if (val==1)
                    window.Debug = val;
                else
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "Debug". Debug will be set to 0.');
                    window.Debug = debug;
                end
            case {'Window', 'window'}
                windowin = val;
            case {'Fontsize' ,  'fontsize','FontSize'}
                if numel(val)~=1
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "Fontsize". Fontsize will be set to 16.');
                    %fontsize = fontsize;
                else
                    fontsize = val;
                end
            case {'Fontcolor' , 'fontcolor','FontColor'}
                if length(val)==1 || length(val)==3
                    fontcolor = val;
                else
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "Fontcolor". Fontcolor will be set to [255 0 0] == red.');
                    %fontcolor = fontcolor;
                end
            case {'BGColor', 'bgcolor','BackgroundColor'}
                if length(val)==1 || length(val)==3
                    window.BGColor = val;
                else
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "BGColor". BGColor will be set to 0 == black.');
                    window.BGColor = BGColor;
                end
            case {'multisample' , 'MultiSample' , 'multiSample'}
                if val<0
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "MultiSample". MultiSample will be set to 0.');
                    window.MultiSample = multiSample;
                else
                    window.MultiSample = val;
                end
            case {'imagingPipeline' , 'ImagingPipeline' , 'imagingpipeline'}
                if val<0
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "ImagingPipeline". ImagingPipeline will be set to 0.');
                    window.ImagingPipeline = imagingPipeline;
                else
                    window.ImagingPipeline = val;
                end
            case {'StereoMode' , 'Stereomode' , 'stereomode'}
                if ~any(val==(0:10))
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "StereoMode". StereoMode will be set to 0 (no stereo)');
                    window.StereoMode = 0;
                else
                    window.StereoMode = val;
                end
            case {'Blending' , 'blending'}
                if ischar(val)
                    switch val
                        case {'Transparent', 'transparent', 'AntiAlias','antialias'}
                            window.Blending = [GL.SRC_ALPHA GL.ONE_MINUS_SRC_ALPHA];
                        case {'Default','Replace','default','replace'}
                            window.Blending = [GL.ONE GL.ZERO];
                        otherwise
                            warning('SetScreen:InvalidParam',['Blending: invalid mode: ',field]);
                    end               
                else
                    warning('SetScreen:InvalidParam',['Blending: invalid mode: ',field]);
                    window.Blending = [];
                end
            case {'OpenGL' , 'opengl', 'Opengl'}
                if (val==0 || val==1)
                    if val==1
                        AssertOpenGL;                   % Is the script running in OpenGL Psychtoolbox? Abort, if not.
                        InitializeMatlabOpenGL;         % Setup Psychtoolbox for OpenGL 3D rendering support and initialize the mogl OpenGL for Matlab wrapper:
                        window.OpenGL = 1;
                    end
                else
                    warning('SetScreen:InvalidParam','SetScreen: invalid value for "OpenGl"; use 0 or 1. OpenGL with be set to 0 (=off).');
                end
            otherwise
                warning('SetScreen:InvalidParam',['SetScreen: invalid parameter: ',field]);
        end
    end
end

%% Some Checks for stereo setup
if IsWin && (window.StereoMode==4 || window.StereoMode==5)
    windowin = 0;
end

if window.StereoMode == 10
    if length(Screen('Screens')) < 2         % Do we have at least two separate displays for both views?
        error('Sorry, for stereoMode 10 you''ll need at least 2 separate display screens in non-mirrored mode.');
    end
    if ~IsWin
        windowin = 0;            % Assign left-eye view (the master window) to main display:
    else
        windowin = 1;            % Assign left-eye view (the master window) to main display:
    end
end

%% Set screen and determine dimensions


if window.Debug == 1 % creates smaller window for debugging
    
%     if window.StereoMode == 4
%          PsychImaging('PrepareConfiguration');
          [window.Number , window.Rect] = PsychImaging('OpenWindow', 1, window.BGColor, [0 0 300 300], [], [], window.StereoMode,window.MultiSample, window.ImagingPipeline);
%     else
%     [window.Number , window.Rect] = Screen('OpenWindow', windowin, window.BGColor,[0 0 1000 800],[],[],window.StereoMode,window.MultiSample, window.ImagingPipeline);
%     end
else
    if window.StereoMode == 4
        PsychImaging('PrepareConfiguration');
        [window.Number , window.Rect] = PsychImaging('OpenWindow', windowin, window.BGColor, [], [], [], window.StereoMode,window.MultiSample, window.ImagingPipeline);
    else
        [window.Number , window.Rect] = Screen('OpenWindow', windowin, window.BGColor,[],[],[],window.StereoMode,window.MultiSample, window.ImagingPipeline);
    end
end
window.Width        = RectWidth(window.Rect);
window.Height       = RectHeight(window.Rect);
window.Center       = [window.Width/2 window.Height/2];
window.AspectRatio  = window.Rect(4)/window.Rect(3);       % Get the aspect ratio of the screen:
window.RefreshRate  = Screen('NominalFramerate', windowin);
if (window.RefreshRate == 0) %% correct refreshrate for LCD screens
    window.LCD = 1;
    window.RefreshRate = 60;
end
window.IsWin = IsWin;


if window.StereoMode == 10
    % In dual-window, dual-display mode, we open the slave window on
    % the secondary screen. Please note that, after opening this window
    % with the same parameters as the "master-window", we won't touch
    % it anymore until the end of the experiment. PTB will take care of
    % managing this window automatically as appropriate for a stereo
    % display setup. That is why we are not even interested in the window
    % handles of this window:
    if IsWin
        slaveScreen = 2;
    else
        slaveScreen = 1;
    end
    Screen('OpenWindow', slaveScreen, BlackIndex(slaveScreen), [], [], [], stereoMode);
end

if  ~isempty(window.Blending)
    Screen('BeginOpenGL', window.Number);
    glEnable(GL.BLEND);
    glBlendFunc(window.Blending(1), window.Blending(2));
    Screen('EndOpenGL', window.Number);
end

%% Set font parameters
Screen('TextFont', window.Number ,'Helvetica');
Screen('TextSize', window.Number , fontsize);
Screen('TextColor', window.Number , fontcolor);
end