function tempoSamples = getTempo(onsets, beatDivisions)

% --------------------------------
% PREAMBLE:
%
% getTempo calculates and returns tempo estimates for a set of
% inter-onset-intervals derived from a list of onsets and a list of
% inter-onset beat divisions.
% ~ PC
% --------------------------------

% --------------------------------
% INPUTS:
%   - onsets:           double vector, containing list of onset times in
%                       seconds.
%   - beatDivisions:    double vector, containing list of inter-onset beat 
%                       divisions (1 = full beat, 4 = quarter beat etc.).
% --------------------------------

% --------------------------------
% OUTPUTS:
%   - tempoSamples:     double vector, containing list of tempo values.
% --------------------------------

% --------------------------------
% SCRIPT
% --------------------------------
% Create vector to store tempo samples
tempoSamples = zeros(length(onsets)-1, 1);

% Loop through onsets
for i = 1:length(onsets) - 1
    % Get OTD, use beat division to calculate and return BPM
    tempoSamples(i) = (60/((onsets(i + 1)) - (onsets(i)))) / beatDivisions(i);
end
% --------------------------------
