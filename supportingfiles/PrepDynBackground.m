%% Creating an array of 100 different random backgrounds


screensize = get( groot, 'Screensize' );
randd=zeros(screensize(4),screensize(3),100);
for iz=1:100
    r=rand(screensize(4)/2,screensize(3)/2);
countercollodd=0;
counterrowodd=0;
countercolleven=0;
counterroweven=0;
random=zeros(screensize(4),screensize(3));
for i=1:screensize(3)
    counterroweven=0;
    counterrowodd=0;
    isodcoll = mod(i,2);
    if isodcoll==1
        countercollodd=countercollodd+1;
        for j=1:screensize(4)
        isodrow = mod(j,2);
        if isodrow==1
            counterrowodd=counterrowodd+1;
            random(j,i)=r(counterrowodd,countercollodd);
        elseif isodrow==0
            counterroweven=counterroweven+1;
            random(j,i)=r(counterroweven,countercollodd);
        end
        end
    elseif isodcoll==0
        countercolleven=countercolleven+1;
        for j=1:screensize(4)
        isodrow = mod(j,2);
        if isodrow==1
            counterrowodd=counterrowodd+1;
            random(j,i)=r(counterrowodd,countercollodd);
        elseif isodrow==0
            counterroweven=counterroweven+1;
            random(j,i)=r(counterroweven,countercolleven);
        end
        end
    end
end
 randd(:,:,iz)=random;
 
end

rectdyn=randd*250;
%% Making it 2 by 2

% screensize = get( groot, 'Screensize' );
% r=zeros(screensize(4)/2,screensize(3)/2,100);
% for iz=1:100
%  r(:,:,iz)=rand(screensize(4)/2,screensize(3)/2);
%  rectdyn=r*250;
% end


        
texindexes=zeros(100);
for i=1:100
backgtex=Screen('MakeTexture', win.Number, rectdyn(:,:,i));
texindexes(i)=backgtex;
end

clear rectdyn randd r