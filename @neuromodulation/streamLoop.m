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
                
                self.resetData();
                
                L_ACC_X_idx = strcmp(props.channelNames,'L_ACC_X');
                L_ACC_Y_idx = strcmp(props.channelNames,'L_ACC_Y');
                L_ACC_Z_idx = strcmp(props.channelNames,'L_ACC_Z');
                R_ACC_X_idx = strcmp(props.channelNames,'R_ACC_X');
                R_ACC_Y_idx = strcmp(props.channelNames,'R_ACC_Y');
                R_ACC_Z_idx = strcmp(props.channelNames,'R_ACC_Z');
                
                self.RDA.L_ACC_X_idx = find(L_ACC_X_idx);
                self.RDA.L_ACC_Y_idx = find(L_ACC_Y_idx);
                self.RDA.L_ACC_Z_idx = find(L_ACC_Z_idx);
                self.RDA.R_ACC_X_idx = find(R_ACC_X_idx);
                self.RDA.R_ACC_Y_idx = find(R_ACC_Y_idx);
                self.RDA.R_ACC_Z_idx = find(R_ACC_Z_idx);
                
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
                
                % print marker info to MATLAB console
                if datahdr.markerCount > 0
                    for m = 1:datahdr.markerCount
                        % disp(markers(m));
                        self.RDA.marker(end+1 : end+datahdr.markerCount) = markers;
                    end
                end
                
                newdata = reshape(data, self.RDA.props.channelCount, length(data) / self.RDA.props.channelCount)';
                newdata = newdata .* self.RDA.props.resolutions;
                
                % update
                nNewPoints = size(newdata,1);
                idx = self.RDA.idx;
                dataBVA(idx+1:idx+nNewPoints,:) = newdata;
                
                newACC_L = newdata(:,[self.RDA.L_ACC_X_idx self.RDA.L_ACC_Y_idx self.RDA.L_ACC_Z_idx])/1450; % 1450mV = 1g;
                newACC_R = newdata(:,[self.RDA.R_ACC_X_idx self.RDA.R_ACC_Y_idx self.RDA.R_ACC_Z_idx])/1450; % 1450mV = 1g;
                
                comb_newACC_L = sqrt(sum(newACC_L.^2,2)); % euclidian norm <=== best
                comb_newACC_R = sqrt(sum(newACC_R.^2,2)); % euclidian norm <=== best
                
                self.RDA.slidingACC = circshift(self.RDA.slidingACC,-nNewPoints,1);
                self.RDA.slidingACC(end-nNewPoints+1 : end, : ) = [comb_newACC_L comb_newACC_R];
                
                self.GUIdata.tplot(1).YData = flipud(self.RDA.slidingACC(:,2));
                self.GUIdata.tplot(2).YData = flipud(self.RDA.slidingACC(:,1));
                
                window_ACC = self.getWindow(self.RDA.slidingACC,self.fsBVA,self.fftWindow);
                
                [frequency,power] = self.FFT(window_ACC,self.fsBVA);
                
                power_L =  power(:,1);
                power_R =  power(:,2);
                
                [~,idx_04hz] = min(abs(frequency-04));
                [~,idx_12hz] = min(abs(frequency-12));
                [~,idx_30hz] = min(abs(frequency-30));
                
                newratio_L = sum(abs(power_L(idx_04hz:idx_12hz)))/sum(abs(power_L(1:idx_30hz)));
                newratio_R = sum(abs(power_R(idx_04hz:idx_12hz)))/sum(abs(power_R(1:idx_30hz)));
                self.RDA.ratioPower = circshift(self.RDA.ratioPower,-nNewPoints,1);
                self.RDA.ratioPower(end-nNewPoints+1 : end, : ) = repmat([newratio_L newratio_R],[nNewPoints 1]);
                
                ratioPower = flipud( self.RDA.ratioPower );
                self.GUIdata.pplot(1).YData = ratioPower(:,2);
                self.GUIdata.pplot(2).YData = ratioPower(:,1);
                
                self.RDA.idx = self.RDA.idx + nNewPoints;
                
                if self.RDA.idx >= size(dataBVA,1)
                    self.resetData();
                end
                
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
    if self.isaudioready &&  keyIsDown && (secs-self.RDA.onset)>2
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
