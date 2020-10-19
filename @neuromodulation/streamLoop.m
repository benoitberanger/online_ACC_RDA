function streamLoop( self, timer, event )
global dataBVA

try
    header_size = 24;
    
    % check for existing data in socket buffer
    tryheader = pnet(self.RDA.con, 'read', header_size, 'byte', 'network', 'view', 'noblock');
    stop = false;
    
    while ~isempty(tryheader) && ~stop
        
        % Read header of RDA message
        hdr = RDA.ReadHeader(self.RDA.con);
        
        % Perform some action depending of the type of the data package
        switch hdr.type
            case 1 % Start, Setup information
                
                % Read and display properties
                props = RDA.ReadStartMessage(self.RDA.con, hdr);
                self.RDA.props = props;
                disp(props);
                
                % Pre-allocate memory
                dataBVA             = zeros(self.maxTime*self.fsBVA, self.RDA.props.channelCount);
                self.RDA.idx        = 0;
                self.RDA.slidingACC = zeros(self.displaySize*self.fsBVA, 3); % euclidian norm
                self.RDA.ratioPower = zeros(self.displaySize*self.fsBVA, 1); % power ratio
                self.RDA.onset      = 0;
                
                ACC_X_idx = strcmp(props.channelNames,'ACC_X');
                ACC_Y_idx = strcmp(props.channelNames,'ACC_Y');
                ACC_Z_idx = strcmp(props.channelNames,'ACC_Z');
                
                if sum(ACC_X_idx) == 0
                    stop( self.timer );
                    delete( self.timer );
                    error('ACC_X channel not found')
                elseif sum(ACC_X_idx) > 1
                    stop( self.timer );
                    delete( self.timer );
                    error('several ACC_X channels found')
                elseif sum(ACC_Y_idx) == 0
                    stop( self.timer );
                    delete( self.timer );
                    error('ACC_Y channel not found')
                elseif sum(ACC_Y_idx) > 1
                    stop( self.timer );
                    delete( self.timer );
                    error('several ACC_Y channels found')
                elseif sum(ACC_Z_idx) == 0
                    stop( self.timer );
                    delete( self.timer );
                    error('ACC_Z channel not found')
                elseif sum(ACC_Z_idx) > 1
                    stop( self.timer );
                    delete( self.timer );
                    error('several ACC_Z channels found')
                end
                
                self.RDA.ACC_X_idx = find(ACC_X_idx);
                self.RDA.ACC_Y_idx = find(ACC_Y_idx);
                self.RDA.ACC_Z_idx = find(ACC_Z_idx);
                
                % Reset block counter to check overflows
                self.RDA.lastBlock = -1;
                
            case 4 % 32Bit Data block
                
                % Read data and markers from message
                [datahdr, data, markers] = RDA.ReadDataMessage(self.RDA.con, hdr, self.RDA.props);
                data = double(data);
                
                % check tcpip buffer overflow
                if self.RDA.lastBlock ~= -1 & datahdr.block > self.RDA.lastBlock + 1
                    disp(['******* Overflow with ' int2str(datahdr.block - self.RDA.lastBlock) ' blocks ******']);
                end
                self.RDA.lastBlock = datahdr.block;
                
%                 % print marker info to MATLAB console
%                 if datahdr.markerCount > 0
%                     for m = 1:datahdr.markerCount
%                         disp(markers(m));
%                     end
%                 end
                
                newdata = reshape(data, self.RDA.props.channelCount, length(data) / self.RDA.props.channelCount)';
                newdata = newdata .* self.RDA.props.resolutions;
                
                % update
                nNewPoints = size(newdata,1);
                idx = self.RDA.idx;
                dataBVA(idx+1:idx+nNewPoints,:) = newdata;
                
                newACC = newdata(:,[self.RDA.ACC_X_idx self.RDA.ACC_Y_idx self.RDA.ACC_Z_idx])/1450; % 1450mV = 1g;
                
                self.RDA.slidingACC = circshift(self.RDA.slidingACC,-nNewPoints,1);
                self.RDA.slidingACC(end-nNewPoints+1 : end, : ) = newACC;
                
                combACC = sqrt(sum(self.RDA.slidingACC.^2,2)); % euclidian norm <=== best
                
                self.GUIdata.tplot.YData = flipud(combACC);
                
                windowACC_X = self.getWindow(self.RDA.slidingACC(:,1),self.fsBVA,self.fftWindow);
                windowACC_Y = self.getWindow(self.RDA.slidingACC(:,2),self.fsBVA,self.fftWindow);
                windowACC_Z = self.getWindow(self.RDA.slidingACC(:,3),self.fsBVA,self.fftWindow);
                [~        ,power_X] = self.FFT(windowACC_X,self.fsBVA);
                [~        ,power_Y] = self.FFT(windowACC_Y,self.fsBVA);
                [frequency,power_Z] = self.FFT(windowACC_Z,self.fsBVA);
                
                power =  mean([power_X(:) power_Y(:) power_Z(:)],2);
                self.GUIdata.fplot.YData = power;
                
                [~,idx_04hz] = min(abs(frequency-04));
                [~,idx_06hz] = min(abs(frequency-06));
                [~,idx_30hz] = min(abs(frequency-30));
                
                % newratio = sum(power(idx_04hz:idx_06hz)) / (sum(power(1:idx_04hz-1)) + sum(power(idx_06hz+1:idx_30hz)));
                newratio = sum(power(idx_04hz:idx_06hz)) / sum(power(1:idx_30hz));
                self.RDA.ratioPower = circshift(self.RDA.ratioPower,-nNewPoints,1);
                self.RDA.ratioPower(end-nNewPoints+1 : end, : ) = repmat(newratio,[nNewPoints 1]);
                self.GUIdata.pplot.YData = flipud(self.RDA.ratioPower);
                
                self.RDA.idx = self.RDA.idx + nNewPoints;
                
            case 3       % Stop message
                disp('Stop');
                data = pnet(self.RDA.con, 'read', hdr.size - header_size);
                finish = true;
                
            otherwise    % ignore all unknown types, but read the package from buffer
                data = pnet(self.RDA.con, 'read', hdr.size - header_size);
        end
        
        tryheader = pnet(self.RDA.con, 'read', header_size, 'byte', 'network', 'view', 'noblock');
        stop = self.isstreaming==0 || self.isconnected==0 ;
        
    end % while
    
    %----------------------------------------------------------------------
    % Button press
    [keyIsDown, secs, keyCode] = KbCheck();
    if keyIsDown && (secs-self.RDA.onset)>2
        if     keyCode(self.GUIdata.Keybinds.Posture)
            self.SendAudio('posture');
            self.RDA.onset = secs;
        elseif keyCode(self.GUIdata.Keybinds.Rest)
            self.SendAudio('repos');
            self.RDA.onset = secs;
        else
            % pass
        end
    end
    %----------------------------------------------------------------------
    
catch err
    
    err.getReport
    
end

end % function
