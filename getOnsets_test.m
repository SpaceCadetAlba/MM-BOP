% ----------------------------------------------------------------
% Initialise Input Variables - should be all we need
wavName = "testAudio.wav";
csvName = "testMarkers.csv";
normLevel = -3;
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Load in our audio and markers using the function loadResource
[audio, Fs, res, markerTimes_s, markerNames, audio_fileName] = loadResource(wavName, csvName, normLevel);
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Plot our audio --------
plotAudio(audio, Fs, audio_fileName);
% ----------------------------------------------------------------






% MIR Onsets
% ----------------
% We want to grab a window from the audio file based upon markers
% We want to convert that window of audio to a miraudio object
% We want to run mironsets on that miraudio() object
% We want to use mirgetdata() to return the estimated onset times
% This process will return a vector of doubles, giving onset times in
% seconds
% We then need the safety check: Do we just have one onset per window?
% - Does our vector have more than one row?
% If it does...(this seems like a fair way of forcing a single value
% return)
% - Check the amplitude at the t for each predicted onset in the window
% - Select the onset time estimate relating to the largest amplitude.
% - Return that onset value
% So we can do this with a switch case, either size = 1 or it does not.