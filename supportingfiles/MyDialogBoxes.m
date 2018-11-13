function answerdlg = MyDialogBoxes(prevsubjinfo)
    if nargin < 1
        prevsubjinfo = [];
    elseif ~isempty(prevsubjinfo)
        suggestedRseed = str2double(prevsubjinfo{2})+1;
    end

    subjok      = 0;
    genderok    = 0;
    ageok       = 0;
    
    answerdlg = {'','','',''};
    
    while  max(strcmp(answerdlg(1:4),'')) ||  ~(str2double(answerdlg{2})>0) || ~subjok || ~genderok
        prompt={'Enter subject name:','Enter subject number:','Enter subject Gender (M/F):','Enter subject Age:'};
        name='Input';
        numlines=1;
        if ~isempty(prevsubjinfo)
            defaultanswer={'',num2str(suggestedRseed),'',''};
        else
            defaultanswer={'','','',''};
        end
        answerdlg=inputdlg(prompt,name,numlines,defaultanswer);
        if isempty(answerdlg)
            break;
        end
        
        subjok = 1;
        
        if ~isempty(prevsubjinfo)
            for i = 1:size(prevsubjinfo,1)
                if subjok == 1
                    subjok = ~strcmp(prevsubjinfo{i,1},answerdlg{1});
                end
            end
            if ~subjok
                h = warndlg('Subject Name exists already. Choose other name.','!! Warning !!','modal');
                uiwait(h);
            end
        end
        genderok = 1;
        if ~(strcmpi(answerdlg{3},'m') || strcmpi(answerdlg{3},'f'))
            genderok = 0;
            if ~genderok
                h = warndlg('Subject gender not correctly entered.','!! Warning !!','modal');
                uiwait(h);
            end
        end
        
        ageok = 1;
        if str2double(answerdlg{4})<18 || str2double(answerdlg{4})>99
            ageok = 0;
            if ~ageok
                h = warndlg('Subject age not correctly entered.','!! Warning !!','modal');
                uiwait(h);
            end
        end
    end
end