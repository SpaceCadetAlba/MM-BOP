% ----------------------------------------------------------------
% Initialise Input Variables - should be all we need
wavName = "testAudio.wav"; % our audio file
csvName = "testMarkers.csv"; % our csv of markers for reaper
normLevel = -3; % our normalisation level in dBFs
windowSize = 0.2; % size of onset search window in s, try to use 0.2 for MIR framesize safety
beatDivisions = ones(13, 1); % beat divisions for our test wav
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Load in our audio and markers using the function loadResource
[audio, Fs, res, markerTimes_s, markerNames, audio_fileName] = loadResource(wavName, csvName, normLevel);
% ----------------------------------------------------------------


% ----------------------------------------------------------------
% Get our onsets --------
onsets = getOnsets(windowSize, audio, Fs, markerTimes_s, audio_fileName);
% ----------------------------------------------------------------


% ----------------------------------------------------------------
% Plot our audio and Onsets --------
plotOnsets(audio, Fs, audio_fileName, onsets);
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Get the tempo samples for each onset interval --------
tempoSamples = getTempo(onsets, beatDivisions);
% ----------------------------------------------------------------

% Plot the tempo trace
% get a list of tempo sample times
tempoTimes = onsets(2:end);
figure;
plot(tempoTimes, tempoSamps);
ylim([mean(tempoSamps)-20 mean(tempoSamps)+20]);
title('Tempo');
xlabel('time, s');
ylabel('BPM');
xlim([0 length(audio)/Fs]);
