function [FullTraceDat,T_ECG_Channels,T_ECG_SignalIndex] = s_parse_siemens_ECG_Channels(T_ParsedHeaders)
% Concatenate all trace data that were extracted from ECG file. Then, split
% it into four channels according to SIEMENS PMU settings.
% 
% By Kunru Song 2023.11.16
% 
% The VD13 IDEA notes clarify that:
% 5000, 6000 are trigger on/off marks
% 5002, 6002 indicate information regions, data follows a 6002 mark
% 5003, 6003 are a footer with statistics and start/stop times
% Pulse and Respiratory triggering 0 to 4095, with 2048 as the zero line
% ECG Multiple channels:
% Channel 1 Data ranges from 0 to 4095, with 2048 as the zero line
% Channel 2 Data ranges from 8192 to 12287, with 10240 as the zero line
% Channel 3 Data ranges from 17408 to 21503, with 18432 as the zero line
% Channel 4 Data ranges from 25600 to 29695, with 26624 as the zero line
FullTraceDat = [T_ParsedHeaders.TraceData{:}];
IdxCH1 = find(FullTraceDat <= 4095)';
IdxCH2 = find((FullTraceDat >= 8192) & (FullTraceDat <= 12287))';
IdxCH3 = find((FullTraceDat >= 17408) & (FullTraceDat <= 21503))';
IdxCH4 = find((FullTraceDat >= 25600) & (FullTraceDat <= 29695))';

T_ECG_SignalIndex = table(IdxCH1,IdxCH2,IdxCH3,IdxCH4);

Channel_1 = FullTraceDat(IdxCH1)';
Channel_2 = FullTraceDat(IdxCH2)';
Channel_3 = FullTraceDat(IdxCH3)';
Channel_4 = FullTraceDat(IdxCH4)';

T_ECG_Channels = table(Channel_1,Channel_2,Channel_3,Channel_4);

% Subtract the offset value from each channel
T_ECG_Channels.Channel_1 = T_ECG_Channels.Channel_1 - 2048;
T_ECG_Channels.Channel_2 = T_ECG_Channels.Channel_2 - 10240;
T_ECG_Channels.Channel_3 = T_ECG_Channels.Channel_3 - 18432;
T_ECG_Channels.Channel_4 = T_ECG_Channels.Channel_4 - 26624;

% After mannually insepction, I found the sampling rate of ECG Channel time
% series is approximately 400Hz (2.5ms), which is consistent with SIEMENS
% PMU equipment.
% For a single subject, the duration calculated by MDH is 770.348s while
% the duration calculated by MPCU is 770.590. The recorded ECG time-series
% has 308216 data points. When multiplicating it by 0.0025, it equals to
% 770.5375s.