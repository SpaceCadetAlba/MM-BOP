function onsets = getOnsets(windowSize, audio, Fs, markerTimes_s, onsetDetectMethod)

% --------------------------------
% PREAMBLE:
%
% getOnsets returns a list of onset times in seconds based on audio and
% Reaper marker metadata returned by the loadResource function. This script
% is ultimately an extension to MIRToolBox mironsets function. The
% extension adds note partitioning based on marker times, and forces only a
% single onset return for each note partition. 
% ~ PC
% --------------------------------

% --------------------------------
% INPUTS:
%   - windowSize:           double, defining the size of note partitions in seconds.
%                           1 second windows is a recommended default value for
%                           mironsets to work well.
%   - audio:                vector of doubles, containing audio data.
%   - Fs:                   double, sample rate of audio.
%   - markerTimes_s:        vector of doubles, containing a list of marker
%                           times in seconds.
%   - onsetDetectMethod:    string, to pass to mironsets to define onset
%                           detection method (i.e. 'Envelope' for amplitude-based
%                           method, 'SpectralFlux' for frequency-based method etc).
% --------------------------------

% --------------------------------
% OUTPUTS:
%   - onsets:               double vector containing list of onset times in
%                           seconds.
% --------------------------------

% --------------------------------
% SCRIPT
% --------------------------------
% Setup
addpath('mirtoolbox'); % Add externals (MIRToolBox)

nMarkers = length(markerTimes_s); % Get N of markers to be handled

onsets = zeros(nMarkers, 1); % Create vector to store onsets.

% Main loop: increment through marker times, partition audio, search for
% onset, return onet and store in onsets vector at relevant index.
for i = 1:nMarkers
    % Window a section of Audio
    clipStart_s = markerTimes_s(i) - (windowSize/2); % Get start time in seconds
    clipStart_samples = round(clipStart_s*Fs); % Get start sample (rounding to int for sample)
    clipEnd_s = markerTimes_s(i) + (windowSize/2); % Get end time in seconds
    clipEnd_samples = round(clipEnd_s*Fs); % Get end sample (rounding to int for sample)
    audioSample = audio(clipStart_samples:clipEnd_samples, 1); % Window current partition

    % Retrieve onsets with MIR toolbox
    audioSample_MIR = miraudio(audioSample); % Convert our audio clip to MIR audio item
    currentOnset = mironsets(audioSample_MIR, onsetDetectMethod); % Get onsets
    currentOnset = mirgetdata(currentOnset); % Return the onset in a usable format

    % Force single value return if multiple onsets are detected.
    if length(currentOnset) ~= 1 % If we are non-one
        % Solve this by returning only the onset nearest the marker
        onsetMarkerDistance = zeros(length(currentOnset), 1);
        for k = 1:length(currentOnset) % For each returned onset
            offset = currentOnset(k, 1) + clipStart_s;
            dist = abs(markerTimes_s(i) - offset);
            onsetMarkerDistance(k, 1) = dist;         
        end
        [minValue, minIndex] = min(onsetMarkerDistance); % Get index of onset nearest marker. minValue is unused but Matlab want the syntax.
        currentOnset = currentOnset(minIndex); % Discard other onsets and return only onset nearest marker
    end

    currentOnset = clipStart_s + currentOnset; % Convert from time in our partition to absolute time
    onsets(i, 1) = currentOnset; % Store our onset time
end
% --------------------------------

