% Demo script for mannully perform ECG signal filtering and QRS detection
% Also show how to use post-process workflow function 's_ECG_Postprocess'
% 
% Kunru Song 2023.11.20


%% Apply Butterworth filter on ECG signal data
load 20231114_lixin\physio.mat

% Your ECG signal variable and sampling frequency
ecg_signal = physio.ons_secs.c;% (Your ECG signal data here)
Fs = 400; % Sampling frequency

% Call the custom filter function
filtered_ecg = s_ECG_Butterworth(ecg_signal, Fs);

% Plot the original and filtered ECG signal
t = (0:length(ecg_signal)-1) / Fs; % Time vector for plotting

figure;
subplot(2, 1, 1);
plot(t, ecg_signal);
title('Original ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, filtered_ecg);
title('Filtered ECG Signal');
xlabel('Time (s)');
ylabel('Amplitude');


%% Extract R-peaks from filtered ECG signal and calculate HRV
cpulse_detect_options.method = 'auto_matched';
cpulse_detect_options.min = 0.4;
cpulse_detect_options.file = 'initial_cpulse_kRpeakfile.mat';
cpulse_detect_options.max_heart_rate_bpm = 120;
cpulse_detect_options.kRpeak = [];

physio_verbose.close_figs = false;
physio_verbose.level = 0;
physio_verbose.fig_output_file = '';
physio_verbose.use_tabs = true;
physio_verbose.fig_handles = [];


[cpulse, ~] = tapas_physio_get_cardiac_pulses(t, filtered_ecg, ...
    cpulse_detect_options, 'ECG', physio_verbose);
%   cpulse - vector of onset-times (in seconds) of occuring heart beats

HRV = s_ECG_HRVcalc(cpulse,[]);

% 在计算心率变异性(HRV)的频域特征时，LF/HF比率中的频率带宽通常定义如下：
% 
% 低频（LF）范围：0.04至0.15 Hz，反映交感和副交感神经系统的活动。
% 高频（HF）范围：0.15至0.4 Hz，主要反映副交感神经系统的活动。
% LF/HF比率被用来评估交感神经和副交感神经之间的平衡。高的LF/HF比率可能指示交感神经系统活动增加，而低的比率可能指示副交感神经系统的主导。
disp(HRV.time)
disp(HRV.freq)
%% Using the all-in-one workflow function to perform all post-processing
Results = s_ECG_Postprocess(fullfile(pwd,'20231114_lixin/physio.mat'),400);
disp(Results)