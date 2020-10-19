function resetData( self )
global dataBVA

% Pre-allocate memory
dataBVA             = zeros(self.maxTime*self.fsBVA, self.RDA.props.channelCount);
self.RDA.idx        = 0;
self.RDA.slidingACC = zeros(self.displaySize*self.fsBVA, 3); % euclidian norm
self.RDA.ratioPower = zeros(self.displaySize*self.fsBVA, 1); % power ratio
self.RDA.onset      = 0;
self.RDA.marker     = struct('size',[],'position',[],'points',[],'channel',[],'type',[],'description',[]);

% Keyboard logger, used for response button & mri trigger
KbName('UnifyKeyNames');
self.KeyLogger = KbLogger( ...
    struct2array(self.GUIdata.Keybinds) ,...
    KbName(struct2array(self.GUIdata.Keybinds)) );
self.KeyLogger.Start; % Start recording events

% timing
self.StartTimePTB = GetSecs();

end % function
