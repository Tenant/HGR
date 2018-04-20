% Demo macro to extract frames and get frame means from an avi movie
% and save individual frames to separate image files.
% Then rebuilds a new movie by recalling the saved images from disk.
% Also computes the mean gray value of the color channels
% And detects the difference between a frame and the previous frame.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 14;

% Change the current folder to the folder of this m-file.
% (The line of code below is from Brett Shoelson of The Mathworks.)
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end

vid = videoinput('winvideo', 1, 'YUY2_320x240');
vid.ReturnedColorspace = 'rgb';
src=getselectedsource(vid);
vid.FramesPerTrigger = 1;
src.FrameRate ='30';
h1=preview(vid);
start(vid);

try
    frame=getsnapshot(vid);
	vidHeight =size(frame,1);
	vidWidth = size(frame,2);
	
	numberOfFramesWritten = 0;
	% Prepare a figure to show the images in the upper half of the screen.
	figure;
	% 	screenSize = get(0, 'ScreenSize');
	% Enlarge figure to full screen.
	set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
	
	% Ask user if they want to write the individual frames out to disk.
	promptMessage = sprintf('Do you want to save the individual frames out to individual disk files?');
	button = questdlg(promptMessage, 'Save individual frames?', 'Yes', 'No', 'Yes');
	
	% Loop through the movie, writing all frames out.
	% Each frame will be in a separate file with unique name.
    frame=1;
	while ishandle(h1)
		% Extract the frame from the movie structure.
		thisFrame = getsnapshot(vid);;
		
		% Display it
		hImage = subplot(2, 2, 1);
		image(thisFrame);
		caption = sprintf('Frame %4d.', frame);
		title(caption, 'FontSize', fontSize);
		drawnow; % Force it to refresh the window.
		
		% Calculate the mean gray level.
		grayImage = rgb2gray(thisFrame);
		meanGrayLevels(frame) = mean(grayImage(:));
		
		% Calculate the mean R, G, and B levels.
		meanRedLevels(frame) = mean(mean(thisFrame(:, :, 1)));
		meanGreenLevels(frame) = mean(mean(thisFrame(:, :, 2)));
		meanBlueLevels(frame) = mean(mean(thisFrame(:, :, 3)));
		
		% Plot the mean gray levels.
		hPlot = subplot(2, 2, 2);
		hold off;
		plot(meanGrayLevels, 'k-', 'LineWidth', 2);
		hold on;
		plot(meanRedLevels, 'r-');
		plot(meanGreenLevels, 'g-');
		plot(meanBlueLevels, 'b-');
		grid on;
		
		% Put title back because plot() erases the existing title.
		title('Mean Gray Levels', 'FontSize', fontSize);
		if frame == 1
			xlabel('Frame Number');
			ylabel('Gray Level');
			% Get size data later for preallocation if we read
			% the movie back in from disk.
			[rows, columns, numberOfColorChannels] = size(thisFrame);
		end
		
		% Update user with the progress.  Display in the command window.
	    progressIndication = sprintf('Processed frame %4d.', frame);
		disp(progressIndication);
		% Increment frame count (should eventually = numberOfFrames
		% unless an error happens).
		numberOfFramesWritten = numberOfFramesWritten + 1;
		
		% Now let's do the differencing
		alpha = 0.5;
		if frame == 1
			Background = thisFrame;
		else
			% Change background slightly at each frame
			% 			Background(t+1)=(1-alpha)*I+alpha*Background
			Background = (1-alpha)* thisFrame + alpha * Background;
		end
		% Display the changing/adapting background.
		subplot(2, 2, 3);
		imshow(Background);
		title('Adaptive Background', 'FontSize', fontSize);
		% Calculate a difference between this frame and the background.
		differenceImage = thisFrame - uint8(Background);
		% Threshold with Otsu method.
		grayImage = rgb2gray(differenceImage); % Convert to gray level
		thresholdLevel = graythresh(grayImage); % Get threshold.
		binaryImage = im2bw( grayImage, thresholdLevel); % Do the binarization
		% Plot the binary image.
		subplot(2, 2, 4);
		imshow(binaryImage);
		title('Binarized Difference Image', 'FontSize', fontSize);
        
        frame=frame+1;
	end
	
	% Alert user that we're done.
    finishedMessage = sprintf('Done!  It processed %d frames of\n"%s"', numberOfFramesWritten, movieFullFileName);

    disp(finishedMessage); % Write to command window.
	uiwait(msgbox(finishedMessage)); % Also pop up a message box.
	
	% Exit if they didn't write any individual frames out to disk.
	if ~writeToDisk
		return;
	end
	
	% Ask user if they want to read the individual frames from the disk,
	% that they just wrote out, back into a movie and display it.
	promptMessage = sprintf('Do you want to recall the individual frames\nback from disk into a movie?\n(This will take several seconds.)');
	button = questdlg(promptMessage, 'Recall Movie?', 'Yes', 'No', 'Yes');
	if strcmp(button, 'No')
		return;
	end

	% Create a VideoWriter object to write the video out to a new, different file.
	writerObj = VideoWriter('NewRhinos.avi');
	open(writerObj);
	
	% Read the frames back in from disk, and convert them to a movie.
	% Preallocate recalledMovie, which will be an array of structures.
	% First get a cell array with all the frames.
	allTheFrames = cell(numberOfFrames,1);
	allTheFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
	% Next get a cell array with all the colormaps.
	allTheColorMaps = cell(numberOfFrames,1);
	allTheColorMaps(:) = {zeros(256, 3)};
	% Now combine these to make the array of structures.
	recalledMovie = struct('cdata', allTheFrames, 'colormap', allTheColorMaps)
	for frame = 1 : numberOfFrames
		% Construct an output image file name.
		outputBaseFileName = sprintf('Frame %4.4d.png', frame);
		outputFullFileName = fullfile(outputFolder, outputBaseFileName);
		% Read the image in from disk.
		thisFrame = imread(outputFullFileName);
		% Convert the image into a "movie frame" structure.
		recalledMovie(frame) = im2frame(thisFrame);
		% Write this frame out to a new video file.
		writeVideo(writerObj, thisFrame);
	end
	close(writerObj);
	% Get rid of old image and plot.
	delete(hImage);
	delete(hPlot);
	% Create new axes for our movie.
	subplot(1, 3, 2);
	axis off;  % Turn off axes numbers.
	title('Movie recalled from disk', 'FontSize', fontSize);
	% Play the movie in the axes.
	movie(recalledMovie);
	% Note: if you want to display graphics or text in the overlay
	% as the movie plays back then you need to do it like I did at first
	% (at the top of this file where you extract and imshow a frame at a time.)
	msgbox('Done with this demo!');
	
catch ME
	% Some error happened if you get here.
	strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
	uiwait(msgbox(strErrorMessage));
end

