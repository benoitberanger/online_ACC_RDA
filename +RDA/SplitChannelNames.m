function channelNames = SplitChannelNames(allChannelNames)
% Helper function for channel name splitting, used by function
% ReadStartMessage for extraction of channel names
% allChannelNames   all channel names together in an array of char
% channelNames      channel names splitted in a cell array of strings

% cell array to return
channelNames = {};

% helper for actual name in loop
name = [];

% loop over all chars in array
for i = 1:length(allChannelNames)
    if allChannelNames(i) ~= 0
        % if not a terminating zero, add char to actual name
        name = [name allChannelNames(i)];
    else
        % add name to cell array and clear helper for reading next name
        channelNames = [channelNames {name}];
        name = [];
    end
end

end % function
