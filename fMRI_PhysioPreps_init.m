function fMRI_PhysioPreps_init(ResetPath,SPM_Dir,PhysIO_Dir)
% Automatically initializing the fMRI_PhysioPreps (Add all required paths)
%
% Input:
%   Required:
%       None
%   Optional:
%       ResetPath   - a logical flag, control whether to reset your MATLAB
%                   path to the default settings when you first installed
%                   your matlab. Default is true.
%       SPM_Dir     - a string variable, indicates the directory of SPM12 main
%                   folder. Default is '/depends/spm12/'
%       PhysIO_Dir  - a string variable, indicates the directory of the
%                   subfolder 'code' under the PhysIO toolbox's main
%                   folder. Default is '/depends/PhysIO/code/'
%
% Output:
%   None
%
% If you used all files downloaded from the online Github repository, just
% type 'fMRI_PhysioPreps_init' in command window and run it. The only
% things you should consider is the first positional argument 'ResetPath',
% if you do not want to reset your MATLAB path to default, please set it to
% false!
% 
% Example：
%   fMRI_PhysioPreps_init(false);
% 
% Written by Kunru Song 2023.11.14


% Check if Depends_Dir is provided, if not, set it to an empty string
if nargin == 0
    ResetPath = true;
    SPM_Dir = '/depends/spm12';
    PhysIO_Dir = '/depends/PhysIO/code/';
elseif nargin == 1
    SPM_Dir = '/depends/spm12';
    PhysIO_Dir = '/depends/PhysIO/code/';
end

if ResetPath
    warning('Caution: Reset your MATLAB path to default!')
    restoredefaultpath;  % Restore the default MATLAB search path
    rehash toolboxcache; % Refresh the toolbox cache
end


% Get the full path of the currently running m-file
currentFilePath = mfilename('fullpath');

% Extract the directory path from the full path
[currentDir, ~, ~] = fileparts(currentFilePath);

% Change the current working directory to the directory of this m-file
fprintf('Change the working directory to %s\n',currentDir)
cd(currentDir);

% If a dependency directory (SPM12 Main Folder) is provided, add it to the MATLAB path
if ~isempty(SPM_Dir)
    SPM12FullPath = fullfile(currentDir, SPM_Dir);
    if isfolder(SPM12FullPath)
        addpath(SPM12FullPath);
    else
        error('Specified SPM12 directory does not exist: %s', SPM12FullPath);
    end
end

% If a dependency directory (PhysIO Toolbox 'code' Folder) is provided,
% execute the 'tapas_physio_init' M file.
if ~isempty(PhysIO_Dir)
    PhysIOFullPath = fullfile(currentDir, PhysIO_Dir);
    InitFilePath = fullfile(PhysIOFullPath,'tapas_physio_init.m');
    if isfile(InitFilePath)
        cd(PhysIOFullPath)
        tapas_physio_init;
    else
        error('Specified PhysIO code directory does not exist: %s', PhysIOFullPath);
    end
end
cd(currentDir);


end
