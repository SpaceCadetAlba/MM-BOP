Marker Metadata - Based Onset Picking (MM-BOP)

These scripts act as an extension to mironsets function from the MIR Toolbox linked to this repo.

These scripts are designed to avoid false negative and false positive onsets in onset detection processes.
This is achieved by:
- Manual pre-processing, here placing markers approximately at each onset in an audio file.
- Exporting these markers as .csv (these scripts consider markers exported from Reaper - via the actions menu - using minutes:seconds timebase).
- Partitioning the audio file based on marker partitions.
- Performing onset detection on each partitioned window.
- Forcing only a single onset returned per window, returning the onset nearest the relevant marker time.

Though this involves some manual pre-processing, errors are avoided, and the need for manual handling of false positive and false negative onsets in post-processing is negated.
Fundamentally onset detection becomes more precise, and overall manual processing load is reduced.

TO DO:
- Video tutorial for Reaper audio and marker export.
