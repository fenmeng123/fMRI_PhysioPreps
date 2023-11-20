function [R_locs, HRV] = s_ECG_ExtractRwave(ecg_signal, Fs)
% Get the location of R-wave peaks in ECG signal
% 
% 
% Written By Kunru Song 2023.11.20

if nargin == 1
    Fs = 400;% Default sampling rate of Siemens ECG equipment
end

% QRS complex detection using MATLAB Wavelet tools
wt = modwt(ecg_signal, 5);
wtrec = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:);
y = imodwt(wtrec, 'sym4');

% Find R-wave Peaks
[~, R_locs] = findpeaks(y, 'MinPeakHeight', 0.5, 'MinPeakDistance', Fs/2.5);

% Calculate HRV
RR_intervals = diff(R_locs) / Fs; % RR间期，单位为秒
HRV = std(RR_intervals); % 心率变异性，标准差表示


end
