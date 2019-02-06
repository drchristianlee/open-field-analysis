clear;
myFolder = uigetdir;
cd(myFolder);
filePattern = fullfile(myFolder, '*.tif');
tiffiles = dir(filePattern);
count = length(tiffiles);
% nMovies = count;
% curMovie = 0;

%figure;

X = str2num(cell2mat(inputdlg('please enter the top left x coordinate')))
Y = str2num(cell2mat(inputdlg('please enter the top left y coordinate')))
value = str2num(cell2mat(inputdlg('please enter the contrast value')))

for curMovie = 1:count;
    %if mod(y, 2) ==1;
    curMovieName = tiffiles(curMovie, 1).name;
    fileinfo = imfinfo(curMovieName);
    frames = numel(fileinfo);
    
    I = imreadtiffstack (curMovieName, frames);
    % resize option would go here - change I to J in line above
    % I = imresize(J, 0.5);
    %diamKeeper = zeros(frames,1);
    
    I2 = I(Y:Y+75, X:X+168, :);
    
    for z = 1:frames;
        contrastkeeper(:,:,z) = imadjust(I2(:,:,z), [0.0 value], []); %originally 0.06, also used at 0.04, for recent movies set to 0.1 to start
    end
    
    clear('I')
    
    level = graythresh(contrastkeeper(:,:,1));
    
    for b = 1:frames;
        bwkeeper(:,:,b) = im2bw(contrastkeeper(:,:,b), level);
    end
    
    for currentFrame = 1:frames;
        
        %gimg = min( I(:,:,currentFrame), [], 3 );
        %BW = im2bw( gimg, .02 ); %imagesc(BW) % changed to 0.02, was 0.4
        BW = bwkeeper(:,:,currentFrame);
        %  3. Get area and centroid porperties of image regions
        
        st = regionprops( ~BW, 'Area', 'Centroid', 'PixelIdxList' );
        
        %now pick largest region and get centroid
        [sel_val, sel_inx] = max([st(1:end, 1).Area]);
        res = st(sel_inx, 1).Centroid;
        
        if currentFrame == 1;
            res_keeper = res;
        else
            res_keeper = vertcat(res_keeper, res);
        end
        name = curMovieName(1:end-4);
        save(char(strcat(name, '.mat')), 'res_keeper');
    end
end

save('files', 'tiffiles');
save('X', 'X');
save('Y', 'Y');
save('value', 'value');
