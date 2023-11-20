# fMRI_PhysioPreps

Author: Kunru Song

Version: 2023-11-14

Environment: MATLAB R2022a

### Introduction

Functional Magnetic Resonance Imaging - Physiological Preprocessing (**fMRI_PhysioPreps)** is a collection of user-defined MATLAB scripts and functions to perform physiological data preprocessing. The term "**physiological data**" used here refer to the cardiac or respiratory time-series recorded by peripheral measurement equipment (such as Siemens portable WIFI-direct device).&#x20;

This free software aims to extend the scope of **PhysIO** **toolbox** and add compatibility for ECG data recorded by SIEMENS Physiological Monitoring Unit (PMU).

### Installation

1.  Clone the full repository from Github and download it to you local PC. &#x20;

2.  Run _fMRI_PhysioPreps_init(false);_ in your MATLAB command window. If you would like to reset your MATLAB path to default, run _fMRI_PhysioPreps_init(); ._

3.  You would see some text-format information printed out in your command window, which tell you the installation results.

    &#x20;It may be something like as below (assume if you are using Windows OS):

    > Change the working directory to E:\fMRI_PhysioPreps
    >
    > \=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=
    >
    > This is the TAPAS PhysIO Toolbox Version R2022a-v8.1.0
    >
    > \=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=
    >
    > Checking Matlab PhysIO paths, SPM paths and Batch Editor integration now\...&#x20;
    >
    > Checking Matlab PhysIO paths now\...added PhysIO path recursively: E:\fMRI_PhysioPreps\depends\PhysIO\code&#x20;
    >
    > Checking Matlab SPM path now\...OK.
    >
    > Checking whether PhysIO/code folder is a subfolder of SPM/toolbox (or a link within there)...OK.&#x20;
    >
    > Success: PhysIO successfully installed, integration with Batch Editor possible. Updating SPM batch editor information...done.
    >
    > Finished!

### Dependencies

**fMRI_PhysioPreps** depends on the **PhysIO toolbox** and **SPM12**. Both of them are free software under the GNU GPL license (v2 or v3). Therefore, **fMRI_PhysioPreps** is also licensed by GNU GPL v3 to follow their licenses . See full text in _LICENSE_ file.

**SPM12** used here was downloaded from <https://www.fil.ion.ucl.ac.uk/spm/software/download/> to get the latest version at 2023-11-14.

**PhysIO toolbox** is part of the TAPAS (<https://www.tnu.ethz.ch/en/software/tapas/documentations/physio-toolbox>). Only the \*\*PhysIO toolbox \*\*was included here.

You can find the two open-source software under _depends_ folder.

### Output Data Format

As specified in your own MATLAB script (may be modified from **demo** in the open source repository), the output files in the folder directory may include: 1) a _multiple_regressor.txt file_, which contains the generated time series based on cardiac time course (made by **PhysIO toolbox**); 2) a _physio.mat_ file, contains a struct inherited from **PhysIO toolbox**; 3) a _post_physio.mat_ file, if you have run the post-processing for raw physiological data, which contains the filtered time series about cardiac response that has been aligned with fMRI acquisition time (non-filtered but aligned data were also stored in _physio.mat_).

According to **PhysIO toolbox** documentation, the struct in _physio.mat_ file is described as follows:

> All intermediate data processing steps (e.g. filtering, cropping) of the peripheral data, including the computation of physiologically meaningful time courses, such as heart rate and respiratory volume, are saved in the substructure `ons_secs` ("onsets in seconds) of the physio-structure mentioned in question 7. This structure is typically saved in a file `physio.mat`.
>
> &#x20;
>
> `physio.ons_secs` then contains the different time courses, cropped to the acquisition window synchronized to your fMRI scan (the same values before synchronization/cropping, is found in `physio.ons_secs.raw`). Here are the most important ones:
>
> - `ons_secs.t` \= \[]; % time vector corresponding to c and r
>
> - `ons_secs.c` \= \[]; % raw cardiac waveform (ECG or PPU)
>
> - `ons_secs.r` \= \[]; % raw respiration amplitude time course
>
> - `ons_secs.cpulse` \= \[]; % onset times of cardiac pulse events (e.g. R-peaks)
>
> - `ons_secs.fr` \= \[]; % filtered respiration amplitude time series
>
> - `ons_secs.c_sample_phase` \= \[]; % phase in heart-cycle when each slice of each volume was acquired
>
> - `ons_secs.r_sample_phase` \= \[]; % phase in respiratory cycle when each slice of each volume was acquired
>
> - `ons_secs.hr` \= \[]; % \[nScans,1] estimated heart rate at each scan
>
> - `ons_secs.rvt` \= \[]; % \[nScans,1] estimated respiratory volume per time at each scan
>
> - `ons_secs.c_outliers_high` \= \[]; % onset of too long heart beats
>
> - `ons_secs.c_outliers_low` \= \[]; % onsets of too short heart beats
>
> - `ons_secs.r_hist` \= \[]; % histogram of breathing amplitudes

In _post_physio.mat_ file, the filtered ECG signal data and HRV-related metrics are stored in a MATLAB struct, see in below:

`ECGsignal` - A struct containing the filtered ECG signal data that has been aligned with fMRI scanning.

- `ECGsignal.filtered_c`: The filtered ECG signal data, in unit of sampling interval (in most cases, it is 2.5ms).

- `ECGsignal.filtered_cpulse`: The detected R-wave peaks from filtered ECG signal, in unit of seconds.

- `ECGsignal.RR_intervals`: The extract R-R intervals time course from filtered_cpulse.

`HRV` - A struct containing HRV metrics calculated from the input ECG time series, including time-domain and frequency-domain features.

- `HRV.time.MeanRR`: The average value of R-R intervals, indicative of the mean heart rate.

- `HRV.time.SDNN`: Standard deviation of NN intervals, reflecting overall HRV and autonomic nervous system activity.

- `HRV.time.RMSSD`: The root mean square of successive differences between NN intervals, associated with short-term variability and parasympathetic activity.

- `HRV.freq.LowFreqPower`: Power in the low-frequency band (0.04–0.15 Hz), related to both sympathetic and parasympathetic activity.

- `HRV.freq.HighFreqPower`: Power in the high-frequency band (0.15–0.4 Hz), reflecting primarily parasympathetic activity.

- `HRV.freq.LFHF`: The ratio of low-frequency to high-frequency power, used to assess the balance between sympathetic and parasympathetic influences on heart rate.

### References

1.  Notebooks from Ronald Hartley-Davies's Github Gist([Web Page](https://gist.github.com/rtrhd))

2.  Source codes from open source tool \_bidsphysio \_([Github Repository](https://github.com/cbinyu/bidsphysio)), issue#14 ([Web Page](https://github.com/cbinyu/bidsphysio/issues/14)), and issue#201 ([Web Page]())

3.  Discussion at NeuroStars forum ([Web Page](https://neurostars.org/t/bids-physio-questions-on-readthedocs-examples/26054))

4.  Documentations from _PhysIO toolbox_ ([Web Page](https://www.tnu.ethz.ch/en/software/tapas/documentations/physio-toolbox)), and Read-in of files page ([Web Page](https://gitlab.ethz.ch/physio/physio-doc/-/wikis/MANUAL_PART_READIN))

5.  Siemens Healthineers: _Physiologging tool_ ([Web Page](https://www.magnetomworld.siemens-healthineers.com/clinical-corner/application-tips/physiologging))

6.  Source codes from _fmri-physio-log_ ([Github Repository](https://github.com/andrewrosss/fmri-physio-log))

7.  HCP Wiki pages related to physiological data recorded during fMRI scanning ([Web Page](https://wiki.humanconnectome.org/display/PublicData/Understanding+Timing+Information+in+HCP+Physiological+Monitoring+Files))

8.  Post from Michał Szczepanik's blog ([Web Page](https://mslw.github.io/posts/2020-12-17-working-with-siemens-physio/))

9.  Documentations from CFMRI Siemens Prisma Documentation ([Web Page](https://ucsd-center-for-functional-mri-cfmri-prisma-external.readthedocs-hosted.com/en/latest/physio.html#transferring-physio-data))

10. GKAguirre Lab's Wiki page ([Web Page](https://cfn.upenn.edu/aguirre/wiki/doku.php?id=public:pulse-oximetry_during_fmri_scanning ')'))

11. Chirs Roden's *Physiological Artifact Removal Tool* (PART) ([Github Repository](https://github.com/neurolabusc/Part#usage))
