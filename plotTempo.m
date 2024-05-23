function plotTempo(tempoSamples, tempoFit, audio, Fs, audio_fileName, onsets)
% --------------------------------
% PREAMBLE:
% plotTempo plot tempo samples and best fit line, then saves a 600dpi pdf
% graphic to the working directory.
% ~ PC
% --------------------------------

% --------------------------------
% INPUTS:
%   - tempoSamples          double vector, containing list of tempo
%                           samples.
%   - tempoFit              double vector, containing best fit line for
%                           tempo as gradient (element 1) and intercept 
%                           (element 2) - from polyfit.
%   - audio:            vector of doubles, containing audio data.
%   - Fs:               double, sample rate of audio.
%   - audio_fileName:   string, containing .wav filename including
%                       path.
%   - onsets:           vector of doubles, containing list of onset times
%                       in seconds.
% --------------------------------

% --------------------------------
% SCRIPT
% --------------------------------
tempoFig = figure; % new figure
plot(onsets(2:end), tempoSamples, 'k-'); % Plot the tempo sample at the latter onset for each onset interval
ylim([round(mean(tempoSamples)-(mean(tempoSamples)*0.2)) round(mean(tempoSamples)+(mean(tempoSamples)*0.2))]); % +/-20% tolerance from mean BPM as ylims
xlim([0 (length(audio))/Fs]); % Plot over the length of the audio file
title('Tempo', 'FontSize', 24); % Sensible title and axis labels
xlabel('Time, s');
ylabel('Tempo, BPM');
ax = gca; % Get ready for some axis formatting
ax.FontName = "Times"; % Times font standard
ax.FontSize = 24;
ax.XGrid = 'on'; % Turn on grids
ax.YGrid = 'on';
tempoFig.WindowState = 'maximized'; % Keep everything the same size

hold on;

% Plot tempo slope
tempoTrend = polyval(tempoFit,onsets(2:end)); % Get values for best fit line across onset times
plot(onsets(2:end),tempoTrend,'k--');

% Save the figure
figTempo_fileName = sprintf("%s_tempoPlot.pdf", audio_fileName); % Generate a filename
exportgraphics(tempoFig, figTempo_fileName, 'Resolution', 600); % Save hi-res pdf graphic
% --------------------------------


