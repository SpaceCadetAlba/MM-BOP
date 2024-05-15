% To Do:
% - Double check error cases
% - Simplify variables
% - markerNames parsing logic?

function [audio, Fs, res, markerTimes_s, markerNames] = loadResource(wavName, csvName)

% This function loads a wav file containing instrument capture of a
% series of onsets, and a csv file containing marker metadata from reaper,
% where each marker approximately tags an onset in the audio recording. The
% script then sorts the marker times and audio file into sensible formats
% to handle in onset detection scripts (i.e. a mono audio file, and a
% vector of doubles for onset marker times in seconds). ~PC


% Variables
% --------
% Audio file name, string: wavName
% Reaper markers csv filename, string: csvName
%
% Return
% --------
% Audio file, double vector: wavFile
% Audio sample rate, double: Fs
% Audio resolution, double, res
% Markers at vector of time in seconds, double vector: markerTimes_s
% Marker names, cell array: markerNames

% ----------------

% Load audio file
% --------

% Check the audio file exists. If it doesnt, throw an error
if isfile(wavName) ~= 1
    error('+++DIVIDE BY CUCUMBER ERROR. PLEASE REINSTALL UNIVERSE AND REBOOT+++ (The specified wav file could not be found');
end

% Read the audio file
[audio, Fs] = audioread(wavName); % load audio file wavName

% Get wav metadata
wavMetadata = audioinfo(wavName);

% Hold the audio resolution in case any audio writing needs done later.
% MATLAB wants audiowrite to specify BitsPerSample or will default to
% 16-bit with associated quantisation
res = wavMetadata.BitsPerSample;

% This part doesnt seem like it should be needed - more a catch for people
% making matlab errors handling wavs than anything else - it is sensible
% for this script to rather assume input of wavs that have been correctly
% written.
% ----------------
% If we have more rows than columns we assume wav channels are on rows 
% rather than columns as expected. If this returns true transpose the
% audio. Not really any need to throw a message here.

%if size(audio,2) > size(audio, 1)
%    audio = audio';
%end
% ----------------

% If we have stereo audio then sum the channels
if wavMetadata.NumChannels == 2
    audio = audio(:, 1) + audio(:, 2);
    audio = audio./2;
end


% If we have 3 or more channels of audio we grab the first channel and return a warning.
if wavMetadata.NumChannels > 2
    disp(['+++COMPUTER WANTS A COOKIE+++ (you appear to have input a wav file with 3 or more channels.' ...
        'This script is designed to work with mono or stereo wav stems for each instrument.' ...
        'The script will use the first channel of the input audio file and continue.'])
    audio = audio(:,1);
end

% Load Marker File
% --------

% Check the file exists. If it doesnt, throw an error.
if isfile(csvName) ~= 1
    error('+++OUT OF CHEESE ERROR, REDO FROM START+++ (The specified csv file could not be found');
end

% Load the Markers csv
markers = readtable(csvName);

% Sort the markers into a vector of marker times in seconds

markerTimes = markers.Start; % Get the time variables from the marker table

% Parse the time variables from the marker table. We only handle audio
% files of less than an hour length.
markerTimes_parsed = datevec(markerTimes, 'MM:SS.FFF');

% Convert this into a column vector where each element is a marker time in
% seconds.
% Make a vector to store our marker time values in seconds
markerTimes_s = zeros(length(markerTimes), 1);

% Loop through the marker times and fill markerTimes_s
for i = 1:length(markerTimes)
    % use minutes * 60 + seconds
    markerTimes_s(i, 1) = (markerTimes_parsed(i, 5) * 60) + markerTimes_parsed(i, 6);
end

% Return the marker names. This allows use of naming logic in onset
% detection if required

markerNames = markers.x_;
