% Input Variables - should be all we need
wavName = "testAudio.wav";
csvName = "testMarkers.csv";

% Load in our audio and markers using the function loadResource
[audio, Fs, res, markerTimes_s, markerNames, audio_fileName] = loadResource(wavName, csvName);

% Plot our audio --------

% Generate time axis
timeAxis = (1:length(audio))./Fs;

% Plot our audio
figAudio = figure;
plot(timeAxis, audio);
ylim([-1 1]) % standard audio sample range
xlim([0 length(audio)/Fs]) % zero to end sample of audio


title("Input .wav file", 'FontSize', 24); % A sensible title
xlabel("Time, seconds"); % And sensible axis names
ylabel("Amplitude");
ax = gca;
ax.FontName = "Times"; % Times font standard
ax.FontSize = 24;
figAudio.WindowState = 'maximized'; % Keep everything the same size
figAudio_fileName = sprintf("%s_fullwav.pdf", audio_fileName); % Generate a filename
exportgraphics(figAudio, figAudio_fileName, 'Resolution', 600); % Save hi-res pdf graphic

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