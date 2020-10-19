function CloseAudio( self )

% Close the audio device
PsychPortAudio('Close')
self.Audio = rmfield(self.Audio, 'Playback_pahandle');
fprintf('Closed all audio devices \n');

end % function
