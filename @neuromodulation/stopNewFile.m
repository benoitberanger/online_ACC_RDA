function stopNewFile( self )
global dataBVA

self.stopStream();

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

scp = struct(self.scp); %#ok<NASGU>

% get comments from the GUI
self.comments = self.GUIdata.edit_comments.String;

% save
save( self.fpath, 'self', 'dataBVA', 'scp' )
fprintf('done ! \n')


%% Quick analyze & plot

[tremor_assessment, left_data, right_data] = analyze_neuromod_data(self, dataBVA, 'imposed_freq_tremor', [] );

visualize_tremor_assessment_recording(left_data, right_data, tremor_assessment)


%% Reset

% reset, ready for a new session
self.resetData();


end % function
