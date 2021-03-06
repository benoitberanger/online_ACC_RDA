classdef neuromodulation < handle
    
    %======================================================================
    properties
        
        %------------------------------------------------------------------
        % THIGS TO MODIFY HERE
        
        maxTime         = 10*60; % s
        
        % BVA related
        fsBVA           = 5000;  % Hz
        ip              = '192.168.18.99';
        
        % Figure
        displaySize     = 20;    % s
        fftWindow       = 1;     % s
        
        % Stream
        refreshPeriod   = 0.010; % s
        
        % TiePie
        acq_time_tiepie = 70;    % s
        fs_tiepie       = 1e4;   % Hz
        scp_range       = 4;     % ? unit = volt ?
        
        %------------------------------------------------------------------
        
        
        %------------------------------------------------------------------
        % DO NOT MODIFY BELLOW
        figH
        GUIdata
        GUIname      = 'neuromodulationGUI'
        debug        = 0
        commit_info
        comments     = ''
        
        isaudioready = 0;
        Audio        = struct
        
        dpath        = ''
        fpath        = ''
        fname        = ''
        
        isconnected  = 0
        RDA          = struct
        isstreaming  = 0
        timer
        
        StartTimePTB
        KeyLogger
        
        use_tiepie   = 0
        scp
        data_tiepie
        
        %------------------------------------------------------------------
    end
    
    %======================================================================
    events
    end
    
    %======================================================================
    methods
        
        %------------------------------------------------------------------
        % Constructor
        function self = neuromodulation( )
            
            % Is the GUI already open ?
            self.figH = findall(0,'Tag',self.GUIname);
            
            if ~isempty(self.figH) % Figure exists so brings it to the focus
                
                
                figure(self.figH);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%%%%
                if self.debug
                    close(self.figH);
                    neuromodulation();
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            else % Create the figure
                
                self.createGUI();
                self.get_commit_info();
                
            end
            
            
        end % function
        
        %------------------------------------------------------------------
        % set.IP
        function set.ip( self, adress )
            errormsg = 'invalid IP adress : x.x.x.x with x in {0;...;255}';
            
            paternIP = '^([0-9]+\.){3}[0-9]+$';
            status = regexp(adress,paternIP,'once');
            if isempty(status)
                error(errormsg)
            end
            
            adress_num = sscanf(adress,'%d.%d.%d.%d');
            if any(adress_num > 255)
                error(errormsg)
            end
            
            self.ip = adress;
            
        end % function
        
    end % methods
    
    
end % classdef
