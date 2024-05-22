function onsets = getOnsets(windowSize, audio, Fs, markerTimes_s, onsetDetectMethod)
% This function returns a vector of onset times associated with an audio
% recording of an instrument.
% For time in a list of marker times the audio file is windowed and MIR
% toolbox (v3.1) to return onset estimates in this window returning a
% single onset for each window, and storing the onset time value in a
% vector of onset times to be returned.

% Variables
% Returned:
% Vector of onset times, double vector: onsets
% Input:
% Size of search window around in each marker time, double, specified in
% seconds: windowSize.
% Audio file, double vector: audio
% List of marker times in seconds, around which an onset search should be
% computed, double vector: markerTimes_s
% onsetDetectMethod: string expects 'Envelope' or 'SpectralFlux'

% Get N of markers to be handled
nMarkers = length(markerTimes_s);

% Initialise vector to store onsets in
onsets = zeros(nMarkers, 1);

% Main loop: increment through marker times, compute onset search, return
% onset in onsets vector
for i = 1:nMarkers
    % Window a section of Audio
    clipStart_s = markerTimes_s(i) - (windowSize/2); % Get start time in s
    clipStart_samples = round(clipStart_s*Fs); % Get start sample (rounding)
    clipEnd_s = markerTimes_s(i) + (windowSize/2); % Get end in s
    clipEnd_samples = round(clipEnd_s*Fs); % Get end sample (rounding)
    audioSample = audio(clipStart_samples:clipEnd_samples, 1); % chop out our audio sample

    % Retrieve onsets with MIR toolbox
    audioSample_MIR = miraudio(audioSample); % Convert our audio clip to MIR audio item

    % Get onsets, ***We can spec method here, we are using half-wave amp env by default***
    currentOnset = mironsets(audioSample_MIR, onsetDetectMethod); 
    currentOnset = mirgetdata(currentOnset); % Return the onset in a usable format

    % Run an error catch for multiple onsets returned (we only want one)
    if length(currentOnset) ~= 1 % If we are non-one
        disp(['+++WOOPS, HERE COMES MR JELLY+++ It looks more than one onset ' ...
            'has been returned (we only expect 1 associated with each marker. ' ...
            'The onset nearest the start of the search window has been returned and ' ...
            'other detected onsets have been discarded.'])
        % Solve this by returning only the onset nearest the marker
        onsetMarkerDistance = zeros(length(currentOnset), 1);
        for k = 1:length(currentOnset)
            a = currentOnset(k, 1);
            b = a + clipStart_s;
            dist = abs(markerTimes_s(i) - b);
            onsetMarkerDistance(k, 1) = dist;         
        end
        [minValue, minIndex] = min(onsetMarkerDistance);
        currentOnset = currentOnset(minIndex);


    end

    % Convert from time in our clip to absolute time
    currentOnset = clipStart_s + currentOnset;
    
    % Store our onset time
    onsets(i, 1) = currentOnset;
    
    % ***PROBABLY NEEDS SOME REFACTORING WHEN ADDING ONSET LIST
    % PARTITIONING BY TAKE***
    % ----------------
    % Save onsets to csv
    %onsets_fileName = sprintf('%s_fullOnsetList.csv',audio_fileName); % generate filename
    %writematrix(onsets, onsets_fileName); % write to csv


end

