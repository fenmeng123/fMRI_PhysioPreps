function [T_ParsedHeaders,T_HeadersIdx,LogHeader] = s_parse_siemens_ECG_Extract_Headers(lineData)
% Parse the first line data in the input ECG file.
% 
% Input:
%   Positional Arguments (Required):
%       lineData - a char variable contains the first line data from a
%                   Siemens PMU ECG file, which can be extracted by 
%                   'tapas_physio_read_physlogfiles_siemens_raw'.
% Output:
%   T_ParseHeaders - a table contains the parsed headers with trace data.
%   T_HeadersIdx - a table contains the string location index of headers.
%   LogHeader - a table contains the main header of a ECG file.
% 
% By Kunru Song 2023.11.6


%% Find information region index in ECG line data
% Find all headers in the first line
HeaderStart = regexpi(lineData, ' 5002 ');
HeaderEnd = regexpi(lineData, ' 6002 ');
% Check ECG file format
if length(HeaderStart) ~= length(HeaderEnd)
    error('Mis-matched header start-end flag paris! %d for start, %d for end',length(HeaderStart),length(HeaderEnd))
end
T_HeadersIdx = table(HeaderStart',HeaderEnd', ...
    'VariableNames',{'IdxStart','IdxEnd'});
NoHeaders = height(T_HeadersIdx);
T_HeadersIdx.No = (1:NoHeaders)';
% Check ECG header start and end index
if sum(T_HeadersIdx.IdxStart < T_HeadersIdx.IdxEnd) ~= NoHeaders
    fprintf('Please check the following headers in ecg file:\n')
    disp(T_HeadersIdx(~(T_HeadersIdx.IdxStart < T_HeadersIdx.IdxEnd),:))
    error('The position index for header start and end is mis-matched!')
end
%% Parse headers in ECG file into key-values pairs 
T_HeadersIdx.Content = repmat({''},NoHeaders,1);
for ihdr = 1:NoHeaders
    tmpContent = lineData( ...
        (T_HeadersIdx.IdxStart(ihdr)) : ...
        (T_HeadersIdx.IdxEnd(ihdr)) ...
        );
    T_HeadersIdx.Content(ihdr) = cellstr(regexprep(tmpContent,'( 5002 )|( 6002 )',''));
end
T_ParsedHeaders = s_parse_siemens_ECG_Header_KeyValPairs(T_HeadersIdx);
%% Find the trace data value index from ECG line data
% Find the final end of trace data
SignalEnd = regexpi(lineData, ' 5003');
% Create the trace data index
TraceDatStart = T_HeadersIdx.IdxEnd;
TraceDatEnd = [T_HeadersIdx.IdxStart(2:end); SignalEnd];
%% Parse the trace data values into numeric vector
T_ParsedHeaders.TraceData = repmat({[]},NoHeaders,1);
for itracedat = 1:NoHeaders
    tmpTraceStr = regexprep( ...
        lineData(TraceDatStart(itracedat):TraceDatEnd(itracedat)), ...
        '(6002)|(5003)','');
    tmpTraceValue = str2num(tmpTraceStr); %#ok<ST2NM>
    if isempty(tmpTraceValue)
        tmpTraceValue = nan;
    end
    T_ParsedHeaders.TraceData(itracedat) = {tmpTraceValue};
end

% Find nan values in extracted trace data
Nan_RowFlag = cellfun(@(x) any(isnan(x)),T_ParsedHeaders.TraceData,'UniformOutput',true);
LogHeader = T_ParsedHeaders(Nan_RowFlag & (T_ParsedHeaders.No < 3),:);
T_ParsedHeaders(Nan_RowFlag,:) = [];
MSGTYPE_values = nan(height(T_ParsedHeaders),1);
for ihdr = 1:height(T_ParsedHeaders)
    if ismember('MSGTYPE', T_ParsedHeaders.InfoRegion{ihdr}.Properties.VariableNames)
        % Extract MSGTYPE value from information regions
        MSGTYPE_values(ihdr) = T_ParsedHeaders.InfoRegion{ihdr}.MSGTYPE;
    else
        % if not exist, set a NaN
        MSGTYPE_values(ihdr) = NaN;
    end
end
T_ParsedHeaders.MSGTYPE = MSGTYPE_values;
T_ParsedHeaders = movevars(T_ParsedHeaders,'MSGTYPE','Before','TraceData');
T_ParsedHeaders = removevars(T_ParsedHeaders,{'IdxEnd','IdxStart'});
