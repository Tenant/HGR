config.Perihelion=100;
config.Aphelion=2000;
config.imd.threshold=4;
config.bgs.learningrate=0.75;
config.bgs.threshold=zeros(120, 160)+6; % ### ±³¾°·Ö¸îËã·¨ãÐÖµ precious=3
config.kf.enableFingertipTrack=false;
config.kf.Sigma=[1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1];
config.kf.mu=[80  60 0 0]';

% ------Table of Parameters inside Functions--------
% getHandMask, Line 34, if p/total>0.1