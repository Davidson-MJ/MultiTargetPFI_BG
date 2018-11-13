% draws target to periphery based on targetx and targety, for each trial

rect = [0, 0, p.targetsize, p.targetsize];

%% Draw gaussian blob to soften edges of flashing stimulus
if gaussEdges ==1
    %%
    rect1 = ones(p.targetsize, p.targetsize)*p.targetcolour(1); %fill rect with white
    %make matrix for gaussian
    imSize = p.targetsize;                           % image size: n X n
    sigma = p.targetsize/5;                             % gaussian standard deviation in pixels
    
    trim = .04; %below this becomes black
    %     highlight=.1; %above this full contrast.
    
    %linear ramp
    X = 1:imSize;
    X0 = (X / imSize) - .5;   %rescale
    s=(sigma / imSize) ; %Gaussian width as fraction of imageSize
    
    %2D grating
    [Xm Ym] = meshgrid(X0, X0);
    
    Xg = exp( -(((X0.^2)) ./ (2* s^2))); % 2D mesh guassian
    
    
    gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); %2D gauss curve
    %%
    %     if p.backgroundcolour(1) == 127.5;
    %         gauss2 = gauss./2;
    %         gauss = gauss2+.5;
    %     end
    
    %     %trim edges
    %     for i=1:imSize
    %         for j = 1:imSize
    %             val = gauss(i,j);
    %             if val<trim
    %                 gauss(i,j)=0;
    %             end
    % %             if val>highlight
    % %                 gauss(i,j)=1;
    % %             end
    %         end
    %     end
    %
    
    %     clf
    %     subplot(2,1,1)
    %     plot(gauss)
    %     subplot(2,1,2)
    %     imagesc(gauss)
    %     % show in grey scale
    %     cmap=contrast(gauss)
    %     colormap(cmap)
    %     %%
    %     clf
    %     %%
    %     imagesc(gauss)
    %     colorbar
    %%
    %multiply to create white guassian blob
    %     temp= rect1.* gauss;
    
    
    %show shape/sanity check
    %     subplot(2,2,1)
    %     plot(Xg)
    %     subplot(2,2,2)
    %     plot(gauss)
    %     subplot(2,2,3)
    %     imagesc(gauss)
    %     colorbar
    %     subplot(2,2,4)
    %     imagesc(blob)
    %     colorbar
    %%
    %multiply blobgrid by contrast, target colour, flicker position, and catch
    %value
    X1  = am1(frame).*gauss;
    %     if am1(frame) < 0;
    %         X1 = X1*-1;
    %     end
    % subplot(2,1,1)
    % imagesc(X1);
    % colorbar
    %
    if andCheckbd==1
    Xdup = ones(size(X1,1), size(X1,2));    
    
    %filling texture
    for ifillr = 1:(imSize/10)
        rows =(1:10) + (10*(ifillr-1));
        isoddr = mod(ifillr,2);
        if isoddr==1 
            for ifillc=1:(imSize/10)
                cols =(1:10) + (10*(ifillc-1));
                isoddc = mod(ifillc,2);
                if isoddc==1;
                    Xdup(rows,cols)= Xdup(rows,cols)*-1;
                end
            end
            
        else    
            for ifillc=1:(imSize/10)
                cols =(1:10) + (10*(ifillc-1));
                isoddc = mod(ifillc,2);
                if isoddc==0;
                    Xdup(rows,cols)= Xdup(rows,cols)*-1;
                end
            end
            
        end
    end
%         Xdup = ones(size(X1,1), size(X1,2));    
%     
%     halfIndex= imSize/2;
%     %filling texture
%     for ifillr = 1:(imSize/(imSize/2))
%         rows =(1:halfIndex) + (halfIndex*(ifillr-1));
%         isoddr = mod(ifillr,2);
%         if isoddr==1 
%             for ifillc=1:(imSize/(imSize/2))
%                 cols =(1:halfIndex) +(halfIndex*(ifillc-1));
%                 isoddc = mod(ifillc,2);
%                 if isoddc==1;
%                     Xdup(rows,cols)= Xdup(rows,cols)*-1;
%                 end
%             end
%             
%         else    
%             for ifillc=1:(imSize/(imSize/2))
%                 cols =(1:halfIndex) + (halfIndex*(ifillc-1));
%                 isoddc = mod(ifillc,2);
%                 if isoddc==0;
%                     Xdup(rows,cols)= Xdup(rows,cols)*-1;
%                 end
%             end
%             
%         end
%     end
%     
    
%     clf
%     subplot(3,1,1)
% imagesc(X1)
% colorbar
% %     subplot(3,1,2)
% imagesc(Xdup)
% %     shg
% colorbar
% %     
gratgauss= X1.*Xdup;
% %     subplot(3,1,3)
% imagesc(gratgauss)
% %     colorbar
X1 = gratgauss;
    end
    %%
    
    %%
    X2 = (trialdata{trial}.contrast)*X1;
    %%
    
    X3 = X2/2 + 0.5;
    %     subplot(2,1,2)
    %     imagesc(X3)
    %     shg
    %     colorbar
    %%
    blob= X3*p.targetcolour(1);
    %      blob= X3*p.targetcolour(1).*c_rampval;
    %    subplot(2,1,2)
    %     imagesc(blob)
    %     colorbar
%     
%     
%     
%     
    
    %%
    %     blob= (trialdata{trial}.contrast.*p.targetcolour(1).*am1(frame).*c_rampval)*gauss;
    % sca, keyboard
    %
    %      %trim edges
    %     for i=1:imSize
    %         for j = 1:imSize
    %             val = blob(i,j);
    %             if val<p.backgroundcolour(1)
    %                 blob(i,j)=p.backgroundcolour(1);
    %             end
    % %             if val>highlight
    % %                 gauss(i,j)=1;
    % %             end
    %         end
    %     end
    blobtex = Screen('MakeTexture', win.Number, blob);
  

    %%
    if simultaneousTargets==1
        x1coord = win.Center(1)+trialdata{trial}.targetx1*p.eccx;
        x2coord = win.Center(1)+trialdata{trial}.targetx2*p.eccx;
        
        ycoord = win.Center(2)+trialdata{trial}.targety*p.eccy;
        
        targetlocation1 = CenterRectOnPoint(rect,x1coord,ycoord);
        targetlocation2 = CenterRectOnPoint(rect,x2coord,ycoord);
        
        
        Screen('DrawTexture', win.Number, blobtex, [], targetlocation1, [], [], c_rampval)
        Screen('DrawTexture', win.Number, blobtex, [], targetlocation2, [], [], c_rampval)
    else
        
        xcoord = win.Center(1)+trialdata{trial}.targetx1*p.eccx;
        ycoord = win.Center(2)+trialdata{trial}.targety*p.eccy;
        targetlocation = CenterRectOnPoint(rect,xcoord,ycoord);
        
        
        
        Screen('DrawTexture', win.Number, blobtex, [], targetlocation, [], [], c_rampval);
        
    end
else
    % just draw a normal circle with hard edges, width p.targetsize
    %%
    if simultaneousTargets == 1
        x1coord = win.Center(1)+trialdata{trial}.targetx1*p.eccx;
        x2coord = win.Center(1)+trialdata{trial}.targetx2*p.eccx;
        
        ycoord = win.Center(2)+trialdata{trial}.targety*p.eccy;
        
        targetlocation1 = CenterRectOnPoint(rect,x1coord,ycoord);
        targetlocation2 = CenterRectOnPoint(rect,x2coord,ycoord);
        
        Screen('FillOval', win.Number, trialdata{trial}.contrast.*p.targetcolour.*am1(frame).*c_rampval, targetlocation1);
        Screen('FillOval', win.Number, trialdata{trial}.contrast.*p.targetcolour.*am1(frame).*c_rampval, targetlocation2);
    else
        xcoord = win.Center(1)+trialdata{trial}.targetx1*p.eccx;
        ycoord = win.Center(2)+trialdata{trial}.targety*p.eccy;
        targetlocation = CenterRectOnPoint(rect,xcoord,ycoord);
        Screen('FillOval', win.Number, trialdata{trial}.contrast.*p.targetcolour.*am1(frame).*c_rampval, targetlocation);
    end
    
end

