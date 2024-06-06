% Set input variables
wavName = "exampleAudio.wav"; % our audio file
csvName = "exampleOnsets.csv"; % our csv of markers from reaper
normLevel = -3; % our normalisation level in dBFs
windowSize = 1; % size of onset search window in s, try to use 0.2 for MIR framesize safety
onsetDetectMethod = 'SpectralFlux'; % Pitched instrument with sustain, so Spectral Flux is preferrable.
beatDivisions = [1 1 1 1 1 1 1 1 1 1 2 1 1 2 0.5 0.5 0.5 0.5 1 1 0.5 0.5 0.5 0.5 1 1 1 1 2 1 1]; % Beat divisions for performance (1 being a full beat, 0.5 being a half beat etc)

% ----------------------------------------------------------------
% Load in our audio and markers using the function loadResource
[audio, Fs, res, markerTimes_s, markerNames, audio_fileName] = loadResource(wavName, csvName, normLevel);
% ----------------------------------------------------------------


% ----------------------------------------------------------------
% Get our onsets --------
onsets = getOnsets(windowSize, audio, Fs, markerTimes_s, onsetDetectMethod);
% ----------------------------------------------------------------


% ----------------------------------------------------------------
% Plot our audio and Onsets --------
plotOnsets(audio, Fs, audio_fileName, onsets)
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Get the tempo samples for each onset interval --------
[tempoSamples, tempoFit] = getTempo(onsets, beatDivisions);
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Get the tempo samples for each onset interval --------
plotTempo(tempoSamples, tempoFit, audio, Fs, audio_fileName, onsets);
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Save the data --------

% Generate filenames
tempoSamples_fileName = sprintf('%s_tempoSamples.csv', audio_fileName);
tempoData_fileName = sprintf('%s_tempoInfo.csv', audio_fileName);
onsets_fileName = sprintf('%s_onsets.csv', audio_fileName);

% Sort tempoInfo
tempoSlope = tempoFit(1)';
tempoStart = tempoFit(2)';
tempoMean = mean(tempoSamples)';
tempoData = table(tempoMean, tempoStart, tempoSlope);

% Write files
writematrix(onsets, onsets_fileName);
writematrix(tempoSamples, tempoSamples_fileName);
writetable(tempoData, tempoData_fileName);

% ----------------------------------------------------------------
