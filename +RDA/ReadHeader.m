function hdr = ReadHeader(con)
% Read the message header
% con    tcpip connection object

% define a struct for the header
hdr = struct('uid',[],'size',[],'type',[]);

% read id, size and type of the message
% swapbytes is important for correct byte order of MATLAB variables
% pnet behaves somehow strange with byte order option
hdr.uid = pnet(con,'read', 16);
hdr.size = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));
hdr.type = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));

end % function
