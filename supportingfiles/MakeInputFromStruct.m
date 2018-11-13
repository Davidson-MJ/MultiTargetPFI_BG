function array = MakeInputFromStruct(in,varargin)
% Usage: array = MakeInputFromStruct(in [,param1, valpar1] [, param2, valpar2] ...)
%
% 'in' is a structure with field names that are free to be assigned by you.
% MakeInputFromStruct creates a cell structure that contains all
% permutations of the values from all the fields provided in 'in'.
% e.g. the following code
%
% in.myfield1 = [0 1];
% in.myfield2 = [3 4 5];
% arrayout = MakeInputFromStruct(in)
%
% will produce a cell of 6 (= 2 x 3) structures, each containing the fields
% "myfield1" and "myfield2" with a single value assigned to each. All
% permutations are given. For example arrayout{1} gives
% ans =
%
%    myfield1: 0
%    myfield2: 3
%
% and arrayout{1}.myfield2 gives the answer 3.
%
% Parameters that can be provided:
%
% 'Randomize': 0 (default) or 1. Randomizes the output cell structure
%
% 'SaveAsFile': 0 (default) or 1. Dou you want to save the output as a
%       human readable tab-delimited text file? The name of this file is
%       'inputdata.txt' by default,but can be changed with 'FileName'.
%
% 'FileName': the name for the file in which the human-readable
%       tab-delimited text is saved (if 'SaveAsFile' is 1).
%
% 'OutputArray' 0 (default) or 1. By default MakeInputFromStruct returns a
%       cell structure. However, if you want to get an array (such a saved when
%       'SaveAsFile' is 1, then set 'OutputArray' to 1.
%
% 'Replications': give the number of replications of the array you want.
%       Say you want 10 replications of the above example, then put
%       'Replications' to 10. This will create a cell structure of 60 (2x3x10)
%       length. 'Replications' is by default 1.
%
% 'Titles': 0 or 1 ('yes'; default). Do you want to have the column titles in the
%       output file (which is requested by 'SaveAsFile'). 
%
% 'Link': link two or more parameters such that they will covary.
%       You need to provide the fieldnames in a cell array. E.g.
%       in.field1 = [1 2 3];
%       in.field2 = [4 5 6];
%       MakeInputFromStruct(in,'Link',{'field1' 'field2'})
%
%       Now the output will always have field2 = 4 when field1 = 1; and field2=5 when field1=2, etc
%       Making more independent linkings should be done by adding additional rows, e.g.:
%       MakeInputFromStruct(in,'Link',{{'field1' 'field2' 'anotherfield'} {'field3' 'field4'}})
%
%
% Example use: arrayout = MakeInputFromStruct(in,'SaveAsFile',1,'Replications',3)
%
% Aug, 2011. JvB
% Sept, 2011. JvB. Added 'Titles' option
% Sept, 2011. JvB. Added 'Link' option

randomize   = 0;
saveasfile  = 0;
dataout     = 'inputdata.txt';
out         = in;
%outbase     = in;
outputarray = 0;
replications = 1;
printtitles =1;
linkedvars = cell(0,0);

if nargin > 0
    for index = 1:2:length(varargin)
        field = varargin{index};
        val = varargin{index+1};
        switch field
            case {'Randomize', 'randomize'}
                if (val==1 || val ==0)
                    randomize = val;
                else
                    warning('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid value for "Randomize". Randomize will be set to 0.');
                    randomize = 0;
                end
            case {'SaveAsFile', 'saveasfile','SaveToFile','savetofile'}
                if (val==1 || val ==0)
                    saveasfile = val;
                else
                    warning('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid value for "SaveAsFile". SaveAsFile will be set to 0.');
                    saveasfile = 0;
                end
            case {'FileName', 'filename'}
                if ~ischar(val)
                    warning('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid value for "FileName". FileName neesd to be a sting. Is is set to "inputdata.txt" (default)');
                    dataout = 'inputdata.txt';
                else
                    dataout = val;
                end
            case {'OutputArray', 'outputarray'}
                if (val==1 || val ==0)
                    outputarray = val;
                else
                    warning('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid value for "OutputArray". OutputArray will be set to 0.');
                    outputarray = 0;
                end
            case {'Replications', 'replications'}
                if ischar(val)
                    error('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid input for Replications. Cannot be a char or string.');
                else
                    replications = val;
                end
            case {'Titles', 'titles'}
                if ischar(val)
                    error('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid input for Titles. Cannot be a char or string.');
                end
                if (val==1 || val ==0)
                    printtitles = val;
                else
                    warning('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid input for Titles. Should be 1 (print) or 0 (no print). Will be set to 0 (default)');
                    printtitles = 0;
                end
            case {'Link', 'link'}
                if ~iscell(val)
                    error('MakeInputFromStruct:InvalidParam','MakeInputFromStruct: invalid input for Link. Should be a cell with fieldnames from the input structure.');
                else
                    linkedvars = val;
                end
            otherwise
                warning('MakeInputFromStruct:UnknownField',['MakeInputFromStruct: unknown field: ',field]);
        end
    end
end



%% Bin the linked fields such that the Recursive Combinations are correctly computed
if ~isempty(linkedvars)
    try %best thing would be to check the level in linkedvars, if only one deep, then add one. However, don't know how to do that; this is a work around.
        cell2mat(linkedvars);
        linkedvars = {linkedvars};
    end
    binnames = cell(size(linkedvars));
    for nlinkings = 1:size(linkedvars,2)
        bin =[];
        for f = 1:length(linkedvars{nlinkings})
            bin = [bin ;in.(linkedvars{nlinkings}{f})];
            binnames{nlinkings}{f} = linkedvars{nlinkings}{f};
            
            in  = rmfield(in,linkedvars{nlinkings}{f});
        end
        in.(['bin' num2str(nlinkings)])=bin;
        
    end
end

%% Do RecursiveAdd
FieldNames  = fieldnames(in);

array       = RecursiveAdd(in)';%,firstpars)';
array       = repmat(array,replications,1);

%% randomize order
if randomize
    randorder   = randperm(size(array,1));
    array       = array(randorder,:);
end

%% debin the fields (this will destroy the correct field order, which will
%% be corrected later
if ~isempty(linkedvars)
    for f = 1:size(linkedvars,2)
        in =  rmfield(in,(['bin' num2str(f)]));
        for i = 1:length(binnames{f})
            in.(binnames{f}{i}) = NaN;
        end
    end
    FieldNames = fieldnames(in);
end

%% Construct an output structure with the same fieldnames as the input structure
if ~outputarray
    output = cell(1,size(array,1));
    for i = 1:size(array,1)
        counter =0;
        for j=1:size(FieldNames,1)
            interm = [];
            for k = 1:size(in.(FieldNames{j}),1)
                counter = counter+1;
                interm = [interm array(i,counter)];
            end
            out.(FieldNames{j}) = interm;
        end
        output{i} = out;
    end
    %array = output;
end

%% Reorder array such that in same order as input
intermarray=array;
correctorder=fieldnames(out);
for i=1:length(correctorder)
    takepos= find(ismember(FieldNames, correctorder(i))==1);
    intermarray(:,i) = array(:,takepos);
end
array = intermarray;

%% Save File
if saveasfile
    FID = fopen(sprintf(['./' '%s'],dataout), 'w');
    if printtitles
        for inlength = 1:length(FieldNames)
            fprintf(FID,'%s\t',correctorder{inlength});
        end
        
        fprintf(FID,'\n');
    end
    for inlength = 1:size(array,1)
        for inwidth=1:size(array,2)-1
            fprintf(FID,'%f\t',array(inlength,inwidth));
        end
        fprintf(FID,'%f\n',array(inlength,size(array,2)));
    end
    fclose(FID);
end

if ~outputarray
    array = output;
end
end


%% Recursive Adding of data conditions
function arr = RecursiveAdd(st,oldbase)

if nargin<2
    FieldNames = fieldnames(st);
    oldbase   = st.(FieldNames{1});
    st          = rmfield(st,FieldNames{1});
end
FieldNames = fieldnames(st);

if isempty(FieldNames)
    arr = oldbase;
    if size(arr,1)==1
        arr = oldbase';
    end
else
    base = st.(FieldNames{1});
    newoldbase = [];
    for i = 1:size(base,2)
        interm = [oldbase ; repmat(base(:,i), 1,size(oldbase,2))];
        newoldbase = [newoldbase interm];
    end
    st =rmfield(st,FieldNames{1});
    arr = RecursiveAdd(st,newoldbase);
end
end