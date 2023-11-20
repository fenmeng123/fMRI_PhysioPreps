function filtered_ecg = s_ECG_Butterworth(ecg_signal, Fs, varargin)
% Butterworth Filter for post-processing of ECG Signal.
% Apply a high-pass (>0.2 Hz) and bandpass filter (0.3 ~ 9 Hz, in default).
% If the input bandpass contains the frequency of alternating current in
% power line (50Hz in China), a bandstop filer (48 ~ 52 Hz) is
% subsequently applied to remove noise from power line. 
%
% Input:
%   Positional Arugments:
%       ecg_signal (required) - a vector that contains the raw time series
%                               of ECG signal 
%       Fs (optional) - a scalar indicates the frequency of ECG sampling, 
%                       in Hz. Default is 400 Hz.
%   Key-value Pairs Arugments (Optional):
%       'Highpass' - a scalar indicate the low boundary of high-pass
%                   filter, in Hz. Default is 0.3 Hz. Using fisrt-order
%                   Butterworth filter.
%       'Bandpass' - a two elements vector indicates the low and up
%                   boundary of a band-pass filter, in Hz.
%                   Default is [0.3 9]. Using third-order Butterworth
%                   filter.
%       'Bandstop' - a two elements vector indicates the low and up
%                   boundary of a band-stop filter, in Hz.
%                   Default is [48 52] (i.e. not apply after bandpass
%                   filtering). Using third-order Butterworth filter.
% 
% Written By Kunru Song 2023.11.20
if nargin == 1
    Fs = 400;
elseif isempty(Fs)
    Fs = 400;
end

p = s_ECGfilter_ParseInput(ecg_signal, Fs, varargin{:});

% High-pass filter to remove baseline wander
hp_cutoff = p.Results.Highpass; % High-pass cutoff frequency
% Bandpass filter parameters (Using default settings from PhysIO toolbox)
% Aims to remove slow drifts, breathing and slice sampling artifacts
bp_low_cutoff = p.Results.Bandpass(1); % Lower cutoff frequency (Hz)
bp_high_cutoff = p.Results.Bandpass(2); % Upper cutoff frequency (Hz)
% Bandstop filter parameters to remove power line interference
bs_low_cutoff = p.Results.Bandstop(1); % Lower cutoff frequency (Hz)
bs_high_cutoff = p.Results.Bandstop(2); % Upper cutoff frequency (Hz)


% Generate Butterworth filters for high-pass, band-pass and band-stop
[b_hp, a_hp] = butter(1, hp_cutoff / (Fs/2), 'high');  % First-order filter
% Normalize frequencies for bandpass and bandstop filters
[Wn_bp_low, Wn_bp_high] = deal(bp_low_cutoff/(Fs/2), bp_high_cutoff/(Fs/2));
[Wn_bs_low, Wn_bs_high] = deal(bs_low_cutoff/(Fs/2), bs_high_cutoff/(Fs/2));
% Design Butterworth bandpass filter
[b_bp, a_bp] = butter(3, [Wn_bp_low, Wn_bp_high], 'bandpass'); % Third-order filter
% Design Butterworth bandstop filter
[b_bs, a_bs] = butter(3, [Wn_bs_low, Wn_bs_high], 'stop');

% Apply high-pass filter
ecg_hp_filtered = filtfilt(b_hp, a_hp, ecg_signal);

% Apply bandpass filter
ecg_bp_filtered = filtfilt(b_bp, a_bp, ecg_hp_filtered);

% Apply bandstop filter
if bp_high_cutoff > bs_high_cutoff
    filtered_ecg = filtfilt(b_bs, a_bs, ecg_bp_filtered);
else
    filtered_ecg = ecg_bp_filtered;
end
end

function p = s_ECGfilter_ParseInput(ecg_signal, Fs, varargin)
% Parse the input of s_ECG_Butterworth
p = inputParser;
ValidateFilterBandInput = @(x)isvector(x) && @(x)(length(x)==2);
addRequired(p,'ecg_signal',@(x)isvector(x));
addRequired(p,'Fs',@(x)isscalar(x));
addParameter(p,'Bandpass',[0.3 9],ValidateFilterBandInput);
addParameter(p,'Bandstop',[48 52],ValidateFilterBandInput);
addParameter(p,'Highpass',0.2,@(x)isscalar(x));
parse(p,ecg_signal, Fs, varargin{:});
end