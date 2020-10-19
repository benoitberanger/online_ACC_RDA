function RDAdisconnect( self )

% Close all open socket connections
pnet('closeall');

%  switch
switch self.isconnected
    case 1
        fprintf('[%s]: Disconnected from : %s \n',mfilename,self.ip)
    case 0
        fprintf('[%s]: Connection from %s was closed.\n',mfilename,self.ip)
end
self.isconnected = 0;

end % function
