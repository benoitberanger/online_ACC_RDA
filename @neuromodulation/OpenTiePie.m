function OpenTiePie( self )
try
    %% Path o the libs
    addpath(genpath('fichiers_thomas'))
    
    parentdir = fileparts(fileparts(fileparts(which('neuromodulation'))));
    
    addpath(fullfile(parentdir,'matlab-libtiepie'));
    if ispc
        addpath(fullfile(parentdir,'libtiepie-0.9.10.WindowsNT-x86-64'));
        addpath(fullfile(parentdir,'libtiepie-0.9.10.WindowsNT-x86-64','C'));
    elseif isunix
        addpath(fullfile(parentdir,'libtiepie-0.9.10.GNULinux-x86-64'));
        addpath(fullfile(parentdir,'libtiepie-0.9.10.GNULinux-x86-64','C'));
    else
        error('??')
    end
    
    
    %% Init TiePie
    
    w = instrfind;
    if ~isempty(w)
        fclose(w); delete(w);
    end
    clear w;
    
    scp = setdefault_scp_INSIGHTEC('SamplingFrequency', self.fs_tiepie, ...
        'AcquisitionTime', self.acq_time_tiepie, 'ScopeRange', self.scp_range);
    
    fprintf('Temps d enregistrement %2.2f sec \n', scp.RecordLength/self.fs_tiepie);
    
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
    
    
    %% Save
    
    self.scp = scp;
    self.use_tiepie = 1;
    
    
catch err
    self.use_tiepie = 0;
    rethrow(err)
end
end % function
