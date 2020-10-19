function stopStream( self )

switch self.isstreaming
    
    case 1
        try
            stop( self.timer );
            delete( self.timer );
            fprintf('[%s]: streaming stopped @ %s \n', mfilename, datestr(now,13))
        catch err
            warning('neuromodulation:Timer','[%s]: Cannot delete the timer object. delete(timerfind) can clean all timers in the memory', mfilename)
        end
    case 0
        fprintf('[%s]: not streaming \n', mfilename, datestr(now,13))
        
end

self.isstreaming = 0;


end % function
