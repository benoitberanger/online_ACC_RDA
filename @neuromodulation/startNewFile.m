function startNewFile( self )

subjectID = self.GUIdata.edit_subjectID.String; % fetch the field in the GUI
sessionID = self.GUIdata.edit_sessionID.String; % fetch the field in the GUI

assert( ~isempty(subjectID) && ~isempty(sessionID), 'subjectID & sessionID must be specified' )

self.GenerateFname(subjectID,sessionID);
self.GUIdata.text_fnameD.String = self.fname;   % show it in the GUI

self.resetData();

% fprintf('')

end % function
