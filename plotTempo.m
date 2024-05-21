function plotTempo(tempoSamples, onsets, audio, Fs, audio_fileName)
% This function takes tempo samples associated with an onset list and plots
% and saves the tempo data figure.

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

% ***REFACTOR GETTEMPOSLOPE INTO GETTEMPO***
% Plot tempo slope
% Get best fit line
tempoFit = polyfit(onsets(2:end), tempoSamples, 1);
tempoTrend = polyval(tempoFit,onsets(2:end));
plot(onsets(2:end),tempoTrend,'k--');


% Save the figure
figTempo_fileName = sprintf("%s_tempoPlot.pdf", audio_fileName); % Generate a filename
exportgraphics(tempoFig, figTempo_fileName, 'Resolution', 600); % Save hi-res pdf graphic


