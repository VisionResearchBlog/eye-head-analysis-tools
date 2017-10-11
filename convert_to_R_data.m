function out = convert_to_R_data(dat,flist)
% CondLabels={
% 	'Slow, Small, Eyes'
% 	'Fast, Small, Eyes'
% 	'Slow, Small, Hand'
% 	'Fast, Small, Hand'
% 	'Slow, Medium, Eyes'
% 	'Fast, Medium, Eyes'
% 	'Slow, Medium, Hand'
% 	'Fast, Medium, Hand'
% 	'Slow, Large, Eyes'
% 	'Fast, Large, Eyes'
% 	'Slow, Large, Hand'
% 	'Fast, Large, Hand'};
numlabels_H=[
    0	0	0	0
    1	0	0	0
    0	0	1	0
    1	0	1	0
    0	0	0	1
    1	0	0	1
    0	0	1	1
    1	0	1	1
    0	0	0	2
    1	0	0	2
    0	0	1	2
    1	0	1	2];

numlabels_V=[
    0	1	0	0
    1	1	0	0
    0	1	1	0
    1	1	1	0
    0	1	0	1
    1	1	0	1
    0	1	1	1
    1	1	1	1
    0	1	0	2
    1	1	0	2
    0	1	1	2
    1	1	1	2];

out=[];
lastname=[];
%assumes 12x19 array
%condition x participant
for j=1:size(dat,2) %subject
    
    fname=flist{j,1};
    
    if(j~=1)
        %keyboard
        if(~strcmp(lastname,fname(1:2)))
            subID=subID+1;
            lastname=fname(1:2);
        end
    else
        lastname=fname(1:2);
        subID=1;
    end
    
    if( ~isempty(regexpi(fname,'horz') ) )
        numlabels=numlabels_H;
    else
        numlabels=numlabels_V;
    end
    
    for i=1:size(dat,1) %condition
        
        %keyboard
        out(end+1,:)=[subID numlabels(i,:) dat(i,j)];
        
    end
end

