function startStream( self )

self.RDA.lastBlock = [];

self.timer = timer(...
    'StartDelay',0 ,...
    'Period', self.refreshPeriod ,...
    'TimerFcn', @self.streamLoop,...
    'BusyMode', 'drop',...  %'queue'
    'TasksToExecute', Inf,...
    'ExecutionMode', 'fixedRate');

start(self.timer);

self.isstreaming = 1;

fprintf('[%s]: streaming started @ %s \n', mfilename, datestr(now,13))

end % function
