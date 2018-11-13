function SaveToFile(data,varargin)
% Usage: SaveToFile(dataarray [, parname1, parval1] [,parname2,parval2]
%
% dataarray can be an array of arrays. It can also be a cell. 
% e.g.  SaveToFile(dataarray,'FileName','mybackup.txt');
% or    SaveToFile({string1 string2},'FileName','mybackup.txt');
%
% Parameter names: 'FileName' and  'WriteMode'
% a FileName has to be provided, otherwise an error is returned
% WriteMode is set to 'a' (= append) by default. Options are as fprintf:
% 'r'  = Open file for reading
% 'w'  = Open or create new file for writing. Discard existing contents, if any.
% 'a'  = Open or create new file for writing. Append data to the end of the file.
% 'r+' = Open file for reading and writing.
% 'w+' = Open or create new file for reading and writing. Discard existing contents, if any.
% 'a+' = Open or create new file for reading and writing. Append data to the end of the file.
% 'A'  = Append without automatic flushing. (Used with tape drives.)
% 'W'  = Write without automatic flushing. (Used with tape drives.)
%
%  Aug 2011 - jvb

filename = [];
writemode = 'a';
for index = 1:2:length(varargin)
    field = varargin{index};
    val = varargin{index+1};
    switch field
        case {'FileName', 'filename','Filename'}
            if ischar(val)
                filename = val;
            else
                error('SaveToFile:InvalidParam','Filename: needs to be a string.');
            end
        case {'WriteMode','writemod'}
            writemode = val;
    end
    
end

if isempty(filename)
    error('SaveToFile:MissingParam','Filename: Please provide a filename.');
end

FID = fopen(filename, writemode);

for nrow = 1:size(data,1)
    for bwidth=1:size(data,2)-1
        if ~iscell(data)
            fprintf(FID,'%s\t',num2str(data(nrow,bwidth),6));
        else
            fprintf(FID,'%s\t',cell2mat(data(nrow,bwidth)));
        end
    end
    if ~iscell(data)
        fprintf(FID,'%s\n',num2str(data(nrow,size(data,2)),6));
    else
        fprintf(FID,'%s\n',cell2mat(data(size(data,2))));
    end
end

fclose(FID);
end