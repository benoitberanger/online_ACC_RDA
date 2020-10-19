function GenerateFname( self, subjectID, sessionID )

timestamp = datestr(now, 30); % it looks like "20200625T184209"

data_dir = fullfile( fileparts(fileparts(fileparts(mfilename('fullpath')))), 'data' );

% Generate & save fname
self.dpath = fullfile(data_dir,[datestr(now, 29) '_' subjectID]);
self.fname = [ timestamp '__' subjectID '__' sessionID ]; % generate
self.fpath = fullfile(self.dpath,self.fname);

fprintf('[%s]: new files will be written here : %s \n', mfilename, self.dpath)
fprintf('[%s]: new files will be written with this name : %s \n', mfilename, self.fname)

end % function
