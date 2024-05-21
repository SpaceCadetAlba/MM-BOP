function tempoSamples = getTempo(onsets, beatDivisions)

% This function returns a list of tempo estimates associated with an onset
% list and a list of beat divisions between onsets.

% Create vector to store tempo samples
tempoSamples = zeros(length(onsets)-1, 1);

% Main loop
for i = 1:length(onsets) - 1
    % Get OTD, and use beat division reference to calculate BPM then store
    % in tempo.
    tempoSamples(i) = (60/((onsets(i + 1)) - (onsets(i)))) * beatDivisions(i);
end
