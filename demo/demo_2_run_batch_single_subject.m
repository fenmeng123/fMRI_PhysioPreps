% Demo script for running a single subject's ECG data preprocessing
% 
% Kunru Song 2023.11.20

OutputDir = fullfile(pwd,"/20231114_lixin/");
CardiacECGDir = fullfile(pwd,"20231114_lixin.ecg");
ScansDICOMDir = fullfile(pwd,"20231114_Y02_ZH.MR.PROJECT_BNU-ZJT.2.1.2023.11.14.11.13.39.866.30729809.dcm");


BatchJob = s_PhysIO_Batch_Job(OutputDir, ...
    CardiacECGDir, ...
    ScansDICOMDir, ...
    'Nscans',240, ...
    'Nslices',30, ...
    'OnsetSlice',1);

spm('defaults', 'FMRI');
spm_jobman('run', BatchJob);
