function [event] = read_brainstorm_event(filename)

% READ_BRAINSTORM_EVENT reads the event information from .EEG files 
% that have been generated by the Nihon Kohden system. The function 
% constitutes a wrapper around BrainStorm3 functionalities
%
% Use as
%   [event] = read_brainstorm_event(filename)
%
% See also READ_NK1200_HEADER, READ_NK1200_DATA

% Copyright (C) 2018, Arjen Stolk & Sandon Griffin
%
% This file is part of FieldTrip, see http://www.fieldtriptoolbox.org
% for the documentation and details.
%
%    FieldTrip is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    FieldTrip is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with FieldTrip. If not, see <http://www.gnu.org/licenses/>.
%
% $Id$


% call BrainStorm's in_fopen_nk
[sFile] = in_fopen_nk(filename);

% create the event file by pulling values from the output
event = [];
for e = 1:numel(sFile.events)
  event(e).type      = sFile.events(e).label;
  event(e).sample    = sFile.events(e).samples(1);
  event(e).value     = sFile.events(e).label;
  event(e).offset    = 0;
  if numel(sFile.events(e).samples)>1
    event(e).duration  = sFile.events(e).samples(2)-sFile.events(e).samples(1)+1;
  else
    event(e).duration  = 0;
  end
end
