%This script draws a flickering square in the bottom left corner.

bottomX = win.Rect(3) - win.Rect(1); %finds bottom of the screen
bottomY= win.Rect(4)- win.Rect(2);

sidelengthRect = 100; %pixels

baseRect = [0, bottomY-sidelengthRect sidelengthRect bottomY];


%if outside catch duration, then draw the square as oscillating black to
%white (same as target)

if c_rampval>0
    rectCol = [250 250 250];
    flickerCol = rectCol.*(am1(frame)/2+0.5);
    
%     if flickerCol < 0
%         flickerCol = [0 0 0];
%     else
%         flickerCol = [250 250 250];
%     end
else %if we are inside the catch, probably easier to see when photodiode drops to black (not grey)
    flickerCol = [ 0 0 0];
end
    

Screen('FillRect', win.Number, flickerCol, baseRect);
