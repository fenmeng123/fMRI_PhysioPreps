# fMRI_PhysioPreps

Author: Kunru Song

Version: 2023-11-14

Environment: MATLAB R2022a

### Introduction

Functional Magnetic Resonance Imaging - Physiological Preprocessing (**fMRI_PhysioPreps)** is a collection of user-defined MATLAB scripts and functions to perform physiological data preprocessing. The term "**physiological data**" used here refer to the cardiac or respiratory time-series recorded by peripheral measurement equipment (such as Siemens portable WIFI-direct device).&#x20;

### Installation

1.  Clone the full repository from Github and download it to you local PC.

2.  Run _fMRI_PhysioPreps_init(false);_ in your MATLAB command window. If you would like to reset your MATLAB path to default, run _fMRI_PhysioPreps_init(); ._

3.  You would see some text-format information printed out in your command window, which tell you the installation results.

    &#x20;It may be something like as below (assume if you are using Windows OS):

    > Change the working directory to E:\fMRI_PhysioPreps
    >
    > \=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=\=
    >
    >           This is the TAPAS PhysIO Toolbox Version R2022a-v8.1.0
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

**PhysIO toolbox** is part of the TAPAS (<https://www.tnu.ethz.ch/en/software/tapas/documentations/physio-toolbox>). Only the **PhysIO toolbox **was included here.

You can find the two open-source software under _depends_ folder.
