% ****************************************
function filenames = cba_get_filenames(that_dir)

this_dir = pwd;
cd(that_dir);

dir_list = dir;

filenames = {}; idx = 1;

%only keep filenames ending in dat

n = length(dir_list);

for i=1:n
  filename = dir_list(i).name;
  
  reverse_suffix = strtok(fliplr(filename), '.'); % do it backwards
  
  if(strcmp(reverse_suffix, 'tad')) % keep this file
    filenames{idx} = filename; idx = idx + 1;
  end  
end

cd(this_dir);
