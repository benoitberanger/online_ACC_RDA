clc
clear

% params TiePie
use_tiepie = 0;
acq_time_tiepie = 70; % in [s]
% trigger_timeout_tiepie = 10; % in [s]

%% Main

nm = neuromodulation()


if use_tiepie
    %% init path libtiepie
    
    fs_tiepie = 10e3; % in [Hz]
    
    addpath(genpath('fichiers_thomas'))
    
    [parentdir,~,~]=fileparts(pwd);
    % main_path = fileparts(fileparts(mfilename('fullpath')));
    
    addpath(fullfile(parentdir,'matlab-libtiepie'));
    addpath(fullfile(parentdir,'libtiepie-0.9.10.WindowsNT-x86-64'));
    addpath(fullfile(parentdir,'libtiepie-0.9.10.WindowsNT-x86-64','C'));

    
    %% load scp
    
    clear scp;
    scp_range = 4;
    
    w = instrfind;
    if ~isempty(w)
        fclose(w); delete(w);
    end
    clear w;
    
    scp = setdefault_scp_INSIGHTEC('SamplingFrequency', fs_tiepie, ...
        'AcquisitionTime', acq_time_tiepie, 'ScopeRange', scp_range);
    
    fprintf('Temps d enregistrement %2.2f sec \n', scp.RecordLength/fs_tiepie);
    
    import LibTiePie.Const.*
    import LibTiePie.Enum.*
    
    triggerInput = scp.getTriggerInputById(TIID.EXT3);
    if triggerInput == false
        clear triggerInput;
        clear scp;
        error('Unknown trigger input!');
    end
    
    triggerInput.Enabled = true;
    clear triggerInput;
    
    % scp.TriggerTimeOut = trigger_timeout_tiepie;
    
    nm.scp = scp;
    
    
    %% Add to object
    
end

nm.use_tiepie = use_tiepie;
