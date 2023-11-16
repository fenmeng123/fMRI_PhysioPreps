%   c                   cardiac time series (ECG or pulse oximetry)
%   r                   respiratory time series
%   t                   vector of time points (in seconds)
%   cpulse              time events of R-wave peak in cardiac time series (seconds)


LogFile_PARAMS = struct('vendor','Siemens', ...
    'cardiac','E:\研究生\科研工作\231104磁共振生理数据处理\fMRI_PhysioPreps\demo\20231114_lixin.ecg', ...
    'respiration',{''},...
    'sampling_interval',0.0025, ...
    'relative_start_acquisition',0);
LogFile_PARAMS.scan_timing = {'E:\研究生\科研工作\231104磁共振生理数据处理\fMRI_PhysioPreps\demo\20231114_Y02_ZH.MR.PROJECT_BNU-ZJT.2.1.2023.11.14.11.13.39.866.30729809.dcm';...
    'E:\研究生\科研工作\231104磁共振生理数据处理\fMRI_PhysioPreps\demo\20231114_Y02_ZH.MR.PROJECT_BNU-ZJT.2.240.2023.11.14.11.13.39.866.30732438.dcm'};
LogFile_PARAMS.align_scan = 'first';
sqpar.Nslices = 30;
sqpar.NslicesPerBeat = [];
sqpar.TR = 2;
sqpar.Ndummies = 0;
sqpar.Nscans = 240;
sqpar.onset_slice = 1;
sqpar.time_slice_to_slice = [];
sqpar.Nprep = [];
verbose.level = 0;
verbose.fig_handles = [];

[c, r, t, cpulse, verbose] = ...
    s_read_physlogfiles_siemens(LogFile_PARAMS,'ECG', verbose, ...
    'sqpar', sqpar);

% plot(physio.ons_secs.c(1:10))