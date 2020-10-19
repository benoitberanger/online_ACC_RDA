function resetData( self )
global dataBVA

% Pre-allocate memory
dataBVA             = zeros(self.maxTime*self.fsBVA, self.RDA.props.channelCount);
self.RDA.idx        = 0;
self.RDA.slidingACC = zeros(self.displaySize*self.fsBVA, 3); % euclidian norm
self.RDA.ratioPower = zeros(self.displaySize*self.fsBVA, 1); % power ratio
self.RDA.onset      = 0;

end % function
