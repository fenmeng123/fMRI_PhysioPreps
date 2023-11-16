function T_HeadersIdx = s_parse_siemens_ECG_Header_KeyValPairs(T_HeadersIdx)
% Parse the information region (i.e. headers) in SIEMENS
% ideacmdtool-generated ECG data file. Transfrom them into key-value pairs
% and store it as a MATLAB table
% 
% By Kunru Song 2023.11.16


NoHeaders = height(T_HeadersIdx);
T_HeadersIdx.InfoRegion = repmat({table()}, NoHeaders, 1); % Initialize as a cell array of tables

for ihdr = 1:NoHeaders
    % Using regular expressions to match tokens
    tokens = regexp(T_HeadersIdx.Content{ihdr}, '(\w+)\s+([\d\.\s-]+)', 'tokens');

    % Transform the matched tokens into a struct
    tmpResult = struct();
    for i = 1:length(tokens)
        key = tokens{i}{1};
        value = str2num(tokens{i}{2}); %#ok<ST2NM> 
        tmpResult.(key) = value;
    end
    % Convert the struct to a table and store it in InfoRegion
    T_HeadersIdx.InfoRegion{ihdr} = struct2table(tmpResult);
end
T_HeadersIdx = removevars(T_HeadersIdx,"Content");