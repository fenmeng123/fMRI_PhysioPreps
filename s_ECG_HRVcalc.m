function HRV = s_ECG_HRVcalc(R_locs, Fs)
% Calculate Heart Rate Variability-related Features from ECG Signals
% 
% Written By Kunru Song 2023.11.20

if nargin == 1
    Fs = 400;% Default sampling rate of Siemens ECG equipment
end

% Get the R-R interval
RR_intervals = diff(R_locs) / Fs; % convert unit into seconds

% Calculate time-domain features
HRV.time.MeanRR = mean(RR_intervals);
HRV.time.SDNN = std(RR_intervals);
HRV.time.RMSSD = sqrt(mean(diff(RR_intervals).^2));

% Calculate frequency-domain features
[pxx, f] = pwelch(RR_intervals-mean(RR_intervals), [], [], [], Fs);
HRV.freq.LowFreqPower = bandpower(pxx, f, [0.04 0.15], 'psd');
HRV.freq.HighFreqPower = bandpower(pxx, f, [0.15 0.4], 'psd');
HRV.freq.LFHF = HRV.freq.LowFreqPower / HRV.freq.HighFreqPower;


end
