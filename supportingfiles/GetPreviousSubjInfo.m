function subjinfo = GetPreviousSubjInfo(filename)
    subjinfo = [];
    
    FID = fopen(filename);
    if FID ~= -1
        counter=0;
        while 1
            in=fscanf(FID,'%s',1);
            if         isempty(in)
                break;
            end
            counter = counter +1;
        end
        fclose(FID);
        FID = fopen(filename);
        cout = cell(2,floor(counter/2));
        for i = 1: counter
            cout{i}=fscanf(FID,'%s',1);
        end
        subjinfo = cout';
        fclose(FID);        
    end   
end