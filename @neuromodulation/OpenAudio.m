function OpenAudio( self )

try
    
    % Perform basic initialization of the sound driver
    InitializePsychSound(1);
    
    % Close the audio device
    PsychPortAudio('Close')
    
    % Sampling frequency of the output
    freq = 44100;
    
    % Playback device initialization
    self.Audio.Playback_pahandle = PsychPortAudio('Open', [],...
        1,...     % 1 = playback, 2 = record
        1,...     % {0,1,2,3,4}
        freq,...  % Hz
        2);       % 1 = mono, 2 = stereo
    
    task_code_dir = fileparts(fileparts(which(class(self))));
    
    for sound = {'test_son','posture','repos'}
        
        % Load
        [content,fs] = audioread( fullfile(task_code_dir,'wav', [char(sound) '.wav']) );
        N = length(content);
        
        % Normalize to -1 +1
        content = content / max(abs(content));
        
        % Resample @ output frequency
        content = interp1( (1:N)/fs, content, (1:N/fs*freq)/freq, 'pchip' );
        
        % Save
        self.Audio.(char(sound)) = [content(:) content(:)]' ; % Need 1 line per channel
        
    end
    
    self.isaudioready = 1;
    
catch err
    rethrow(err)
end

end % function
