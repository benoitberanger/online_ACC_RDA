function stopNewFile( self )
global dataBVA

% outidr
fprintf('[%s]: saving in %s ... ', mfilename, self.fpath)
if exist(self.dpath, 'dir')~=7
    mkdir(self.dpath)
end

% trim data
dataBVA = dataBVA(1:self.RDA.idx,:);

% KeyLogger
self.KeyLogger.GetQueue;
self.KeyLogger.Stop;
self.KeyLogger.ScaleTime(self.StartTimePTB);
self.KeyLogger.ComputeDurations;
self.KeyLogger.BuildGraph;

if self.use_tiepie
    while ~self.scp.IsDataReady
        pause(1e-3)
    end
    self.data_tiepie = self.scp.getData();
end

% save
save( self.fpath, 'self', 'dataBVA' )
fprintf('done ! \n')

% reset, ready for a new session
self.resetData();

end % function
