% Read in SMI video data
% VideoReader has many fields,
% BitsPerPixel, Duration, FrameRate, Height, Name, NumberOfFrames
% Path, Tag, Type, UserData, VideoFormat, Width
function [vidObj, mov] = Import_SMI_VideoData(par,fn)

vidObj=VideoReader(fn);

mov(1:vidObj.NumberOfFrames) = ...
    struct('cdata', zeros(vidObj.Height, vidObj.Width, 3, 'uint8'),...
    'colormap', []);

if(par)
    disp('SMI_analysis expects the Parallel toolbox to be installed...')
    matlabpool
    disp('Opened Pool... Diving in')
    
    % Read frames.
    parfor k = 1:vidObj.NumberOfFrames
        mov(k).cdata = read(vidObj, k);
    end
    matlabpool close
else
    
    % Read one frame at a time.
    for k = 1:vidObj.NumberOfFrames
        mov(k).cdata = read(vidObj, k);
    end
end

% Size a figure based on the video's width and height.
%hf = figure;
%set(hf, 'position', [150 150 vidObj.Height vidObj.Width])

% Play back the movie once at the video's frame rate.
%movie(hf, mov, 1, vidObj.FrameRate);
end
