pos1= [12 13 15 20];
pos2=pos1;
pos3=pos1;
pos4=pos1;

optioncount=0;

for i=1:4
    freqPos1=pos1(i);
    count=0;
    for n=1:4
        if pos2(n)>freqPos1 || pos2(n)<freqPos1
            count=count+1;
            OptionsPos2(count)=pos2(n);
        end
    end
        for j=1:3
            freqPos2=OptionsPos2(j);
            count2=0;
            for k=1:4
            if (pos3(k)>freqPos2 || pos3(k)<freqPos2) && (pos3(k)>freqPos1 || pos3(k)<freqPos1)
                count2=count2+1;
                OptionsPos3(count2)=pos3(k);
            end
            end
            for l=1:2
                freqPos3=OptionsPos3(l);
                count3=0;
                for m=1:4
                    if (pos4(m)>freqPos2 || pos4(m)<freqPos2) && (pos4(m)>freqPos1 || pos4(m)<freqPos1) && (pos4(m)>freqPos3 || pos4(m)<freqPos3)
                        count3=count3+1;
                        OptionsPos4(count3)=pos4(m);
                        
                    end
                end
                for o=1:1
                    freqPos4=OptionsPos4(o);
                    optioncount=optioncount+1;
                    options(optioncount,1:4)=[freqPos1 freqPos2 freqPos3 freqPos4];
                end
            end
            
        
    end
end
%%     
  options=[randperm(24)',options];
  
                
                
            
 
    