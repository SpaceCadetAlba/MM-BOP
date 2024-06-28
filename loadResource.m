function [audio, Fs, res, markerTimes_s, markerNames, audio_fileName] = loadResource(wavName, csvName, normLevel, SVtag)

% --------------------------------
% PREAMBLE:
%
% loadResources reads and prepares audio (.wav) and marker metadata (.csv)
% for the getOnsets function.
%
% The audio file is expected to be a mono .wav in which onsets are
% detected, however stereo and N_channel > 2 audio files are also handled.
%
% The marker metadata is expected to be a Reaper marker export .csv where
% each marker corresponds with an onset and onset times are defined in
% MINUTES:SECONDS syntax (rather than default MEASURES:BEATS timebase in
% Reaper).
% ~ PC
% --------------------------------

% --------------------------------
% INPUTS:
%   - wavName:          string, defining name of .wav to be read.
%   - csvName:          string, defining name of .csv to be read.
%   - normLevel:        double, defining normalisation level for read .wav
%                       file in dBFS (-3 dBFS recommended).
%   - SVtag:            string, defining use of Sonic Visualiser Time
%                       Instants input, and if the .csv file is in
%                       'Samples' or 'Seconds'.
% --------------------------------

% --------------------------------
% OUTPUTS:
%   - audio:            vector of doubles, containing audio data.
%   - Fs:               double, sample rate of audio file.
%   - res:              double, audio resolution (expected to be mostly
%                       unused but handy if audio needs written).
%   - markerTimes_s:    vector of doubles, containing marker times in
%                       seconds.
%   - markerNames:      cell array (strings), containing name of each
%                       marker (expected to be mostly unused, but
%                       potentially useful for using marker naming logic
%                       for data parsing).
%   - audio_fileName:   string, containing audio filename retaining path.
% --------------------------------

% --------------------------------
% SCRIPT
%---------------------------------
% Check Number of Input Arguments
if nargin == 3
    SVtag = 'none';
end

% --------------------------------
% Read Audio File
% --------------------------------
% Check the audio file exists. If it doesnt, throw an error
if isfile(wavName) ~= 1
    error(['+++DIVIDE BY CUCUMBER ERROR. PLEASE REINSTALL UNIVERSE AND ' ...
        'REBOOT+++ (The specified wav file could not be found. Please check' ...
        'the specified file exists in the working directory).']);
end

% Read the audio file
[audio, Fs] = audioread(wavName);

% Get wav metadata
wavMetadata = audioinfo(wavName);

% Hold audio resolution
res = wavMetadata.BitsPerSample;

% Return the audio filename.
audio_fileName = wavMetadata.Filename;
audio_fileName = audio_fileName(1:end-4);

% Check if we have stereo audio. If we do sum down to a mono stem.
if wavMetadata.NumChannels == 2
    audio = audio(:, 1) + audio(:, 2);
    audio = audio./2;
end

% Check if we have N_channels > 2. If so grab ch 1.
if wavMetadata.NumChannels > 2
    disp(['+++COMPUTER WANTS A COOKIE+++ (You appear to have input a wav ' ...
        'file with 3 or more channels.' ...
        'This script is designed to work with mono or stereo wav stems.' ...
        'The script will use the first channel of the input audio file ' ...
        'and continue).'])
    audio = audio(:,1);
end

% Normalisation
% --------------------------------
normOffset = db2mag(normLevel); % Convert to magnitude
audio = audio * (normOffset/max(abs(audio))); % normalisation to spec level.

% Load Marker File
% --------------------------------
% Check the file exists. If it doesnt, throw an error.
if isfile(csvName) ~= 1
    error(['+++OUT OF CHEESE ERROR, REDO FROM START+++ ' ...
        '(The specified csv file could not be found. Please check the file' ...
        'exists in the working directory.']);
end

% Load the Markers csv
markers = readtable(csvName);

if matches(SVtag,'none')
    % Sort the markers into a vector of marker times in seconds
    markerTimes_s = markers.Start; % Get the time variables from the marker table

    % Parse the time variables from the marker table.
    markerTimes_parsed = datevec(markerTimes, 'MM:SS.FFF');

    % Make a vector to store our marker time values in seconds
    markerTimes_s = zeros(length(markerTimes), 1);

    % Loop through the marker times, convert to seconds, and fill markerTimes_s
    for i = 1:length(markerTimes)
        markerTimes_s(i, 1) = (markerTimes_parsed(i, 5) * 60) + markerTimes_parsed(i, 6);
    end

    % Return the marker names.
    markerNames = markers.x_;
end


if matches(SVtag,'Samples')
    if width(markers) == 1
    markerNames = num2cell(1:height(markers));
    else
        markerNames = markers.Var2;
    end
    markerTimes_s = markers.Var1/Fs;    
end

if matches(SVtag,'Seconds')
    if width(markers) == 1
        markerNames = num2cell(1:height(markers));
    else
        markerNames = markers.Var2;
    end
    markerTimes_s = markers.Var1;
end
% --------------------------------
