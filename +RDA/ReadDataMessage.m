function [datahdr, data, markers] = ReadDataMessage(con, hdr, props)
% Read a data message
% con       tcpip connection object
% hdr       message header
% props     eeg properties
% datahdr   data header with information on datalength and number of markers
% data      data as one dimensional arry
% markers   markers as array of marker structs

% Define data header struct and read data header
datahdr = struct('block',[],'points',[],'markerCount',[]);

datahdr.block = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));
datahdr.points = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));
datahdr.markerCount = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));

% Read data in float format
data = swapbytes(pnet(con,'read', props.channelCount * datahdr.points, 'single', 'network'));

% Define markers struct and read markers
markers = struct('size',[],'position',[],'points',[],'channel',[],'type',[],'description',[]);
for m = 1:datahdr.markerCount
    marker = struct('size',[],'position',[],'points',[],'channel',[],'type',[],'description',[]);
    
    % Read integer information of markers
    marker.size = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));
    marker.position = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));
    marker.points = swapbytes(pnet(con,'read', 1, 'uint32', 'network'));
    marker.channel = swapbytes(pnet(con,'read', 1, 'int32', 'network'));
    
    % type and description of markers are zero-terminated char arrays
    % of unknown length
    c = pnet(con,'read', 1);
    while c ~= 0
        marker.type = [marker.type c];
        c = pnet(con,'read', 1);
    end
    
    c = pnet(con,'read', 1);
    while c ~= 0
        marker.description = [marker.description c];
        c = pnet(con,'read', 1);
    end
    
    % Add marker to array
    markers(m) = marker;
end

end % function
