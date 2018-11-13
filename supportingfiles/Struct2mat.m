function m = Struct2mat(s)
% m = Struct2mat(s) transforms a structure into a row-vector giving the
% values stored in the structure in order of the fieldnames. Fieldnames
% will be ommited. Will only work if all fields have equal sizes.
m = cell2mat(struct2cell(s))';
end