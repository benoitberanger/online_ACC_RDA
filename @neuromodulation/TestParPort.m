function TestParPort( self )

fprintf('[%s]: starting... \n', mfilename);

for i = 0 : 7
    msg = 2^i;
    WriteParPort(msg);
    fprintf('[%s]: writing %d \n', mfilename, msg);
    WaitSecs(0.250); % 250 ms
end

fprintf('[%s]: ...done \n', mfilename);

end % function