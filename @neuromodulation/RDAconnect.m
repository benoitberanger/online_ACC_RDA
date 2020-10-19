function status = RDAconnect( self )

pnet('closeall');

fprintf('[%s]: Trying to connect to : %s ... ',mfilename,self.ip)

self.RDA.con = pnet('tcpconnect', self.ip, 51244);

status = pnet(self.RDA.con,'status');
if status > 0
    fprintf('connection established \n');
    self.isconnected = 1;
elseif status == -1
    self.isconnected = 0;
    error('connection FAILED')
end

end
