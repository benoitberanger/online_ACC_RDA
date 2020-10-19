function startNewFile( self, subjectID, sessionID )

assert( ~isempty(subjectID) && ~isempty(sessionID), 'subjectID & sessionID must be specified' )

self.GenerateFname(subjectID,sessionID);

self.resetData();

if self.use_tiepie
    self.scp.start();
end

end % function
