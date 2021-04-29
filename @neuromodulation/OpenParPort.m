function OpenParPort( self )

% Open or rollback
try
    OpenParPort();
    WriteParPort(0);
catch err
    rethrow(err)
end

end % function