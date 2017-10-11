%**************************************************************
%*      setup.m - Loads paths into memory so fix_finder can run
%*
%*      setup script for UNIX/SGI platforms; run first
%*
%**************************************************************
% Change accordingly so that ROOT will reference your home
% directory
% NOTE: do not use ~, as in 
% '~/vrlab/src/mainprogs/utilities/fixlib'
%
% ~ will not be expanded

ROOT = '/u/sullivan/vrlab/src/mainprogs/utilities/fixlib';

addpath(ROOT);


%If you want matlab to see your datafiles you must add a path,
%these are just example directorie
addpath(['/u/droll/bricks-droll/data']);

addpath(['/u/nmennie/baufix_data/baufix_version_2/data_files']);
addpath(['/u/nmennie/baufix_data/baufix_version_3/data_files']);

addpath(['/u/nmennie/baufix_data/baufix_version_3/dat_files']);

addpath(['/u/nmennie/baufix_data/baufix_version_2/mat_files']);
addpath(['/u/nmennie/baufix_data/baufix_version_3/mat_files']);


%source code for relevant .m files
addpath(['/scratch/droll']);
	 
addpath([ROOT, '/src']);
addpath([ROOT, '/src/bfx']);
addpath([ROOT, '/src/cba']);
addpath([ROOT, '/src/stp']);
addpath([ROOT, '/src/bricks']);
addpath([ROOT, '/src/baufix']);