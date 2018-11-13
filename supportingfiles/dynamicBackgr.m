
%This is coppied from the drawTargetGL file and makes the gaussian
%distribution
%     imSize = p.targetsize;                           % image size: n X n
%     sigma = p.targetsize/5;                             % gaussian standard deviation in pixels
%     
%     X = 1:imSize;
%     X0 = (X / imSize) - .5;   %rescale
%     s=(sigma / imSize) ; %Gaussian width as fraction of imageSize
%     
%     %2D grating
%     [Xm, Ym] = meshgrid(X0, X0);
%     
%     Xg = exp( -(((X0.^2)) ./ (2* s^2))); % 2D mesh guassian
%     
%     
%     gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); %2D gauss curve
%     
%     %This is used to compute the target location
%     rect = [0, 0, p.targetsize, p.targetsize];
%     Xloc1=-1;
%     Xloc2=1;
%     Xloc3=-1;
%     Xloc4=1;
%     
%     Yloc1=-1;
%     Yloc2=-1;
%     Yloc3=1;
%     Yloc4=1;
%     
%         xcoordLoc1 = win.Center(1)+Xloc1*p.eccx;
%         xcoordLoc2 = win.Center(1)+Xloc2*p.eccx;
%         xcoordLoc3 = win.Center(1)+Xloc3*p.eccx;
%         xcoordLoc4 = win.Center(1)+Xloc4*p.eccx;
%         
%         ycoordLoc1 = win.Center(2)+Yloc1*p.eccy;
%         ycoordLoc2 = win.Center(2)+Yloc2*p.eccy;
%         ycoordLoc3 = win.Center(2)+Yloc3*p.eccy;
%         ycoordLoc4 = win.Center(2)+Yloc4*p.eccy;
%         
%         targetlocation1 = CenterRectOnPoint(rect,xcoordLoc1,ycoordLoc1);
%         targetlocation2 = CenterRectOnPoint(rect,xcoordLoc2,ycoordLoc2);
%         targetlocation3 = CenterRectOnPoint(rect,xcoordLoc3,ycoordLoc3);
%         targetlocation4 = CenterRectOnPoint(rect,xcoordLoc4,ycoordLoc4);
%choose is a random number between 1 and 100 used to randomly draw one
%background from the 100 pre-made random backgrounds.
backgFreq=20;
ambackg = sin(2*pi*tspan*backgFreq/win.RefreshRate - pi/2) ;

if frame==1 || backgroundcounter==1
    backgrounds = 1:100;
    backgrounds_rand = backgrounds(randperm(length(backgrounds)));
    backgroundcounter=1;
end
if ambackg(frame)==-1
    backgroundcounter=backgroundcounter+1;
%     oldbackgcounter=backgroundcounter;
%     backgrounds = 1:100;
%     backgrounds_rand = backgrounds(randperm(length(backgrounds)));
%     if backgrounds_rand(1)==oldbackgcounter
%         backgroundcounter=backgrounds_rand(2);
%     else
%         backgroundcounter=backgrounds_rand(1);
%     end

%     
end

%This indexes the area of the target and either makes it gradually random towards the edges to create
%the blurring effect (targetspot) or completely random for the catch
%(targetspot2). These matrices are added to the blob in drawTargetGLD.m
% rectdLoc1= randd(targetlocation1(2):(targetlocation1(4)-1), targetlocation1(1):(targetlocation1(3)-1), backgroundcounter);
% rectdLoc2= randd(targetlocation2(2):(targetlocation2(4)-1), targetlocation2(1):(targetlocation2(3)-1), backgroundcounter);
% rectdLoc3= randd(targetlocation3(2):(targetlocation3(4)-1), targetlocation3(1):(targetlocation3(3)-1), backgroundcounter);
% rectdLoc4= randd(targetlocation4(2):(targetlocation4(4)-1), targetlocation4(1):(targetlocation4(3)-1), backgroundcounter);
% 
%  rectdyndec1=-1 + (1+1)*rectdLoc1;
%  rectdyndec2=-1 + (1+1)*rectdLoc2;
%  rectdyndec3=-1 + (1+1)*rectdLoc3;
%  rectdyndec4=-1 + (1+1)*rectdLoc4;
%  targetspot1=rectdyndec1.*(1-gauss);
%  targetspot2=rectdyndec2.*(1-gauss);
%  targetspot3=rectdyndec3.*(1-gauss);
%  targetspot4=rectdyndec4.*(1-gauss);
 
%  targetspot2=rectdyndec;

 
 %This draws the selected random background.
%backgtex=Screen('MakeTexture', win.Number, rectdyn(:,:,choose));
Screen('DrawTexture', win.Number, texindexes(backgrounds_rand(backgroundcounter),1));


if backgroundcounter==100
    backgroundcounter=1;
end
