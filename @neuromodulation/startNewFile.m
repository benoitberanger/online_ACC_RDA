function startNewFile( self, subjectID, sessionID )

assert( ~isempty(subjectID) && ~isempty(sessionID), 'subjectID & sessionID must be specified' )

self.GenerateFname(subjectID,sessionID);

self.resetData();

end % function
