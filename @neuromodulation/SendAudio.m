function SendAudio( self, name )

switch name
    case 'test_son'
        msg = 77;
    case 'posture'
        msg = 11;
    case 'repos'
        msg = 12;
    otherwise
        error('???')
end

PsychPortAudio('FillBuffer', self.Audio.Playback_pahandle, self.Audio.(name));
PsychPortAudio('Start'     , self.Audio.Playback_pahandle, [], [], 1);
% PsychPortAudio('Start'     , self.Audio.Playback_pahandle);
WriteParPort(msg);
WaitSecs(0.005);
WriteParPort(0);

end % function
