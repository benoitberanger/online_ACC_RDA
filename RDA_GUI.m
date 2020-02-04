function varargout = RDA_GUI
% Run this function start a GUI that will handle the whole stimulation
% process and parameters

% global handles

%% Open a singleton figure

% Is the GUI already open ?
figPtr = findall(0,'Tag',mfilename);

if isempty(figPtr) % Create the figure
    
    clc
    rng('default')
    rng('shuffle')
    
    ft_defaults
    
    % Create a figure
    figHandle = figure( ...
        'HandleVisibility', 'off'                    ,... % close all does not close the figure
        'MenuBar'         , 'figure'                   , ...
        'Toolbar'         , 'figure'                   , ...
        'Name'            , mfilename                , ...
        'NumberTitle'     , 'off'                    , ...
        'Units'           , 'Normalized'             , ...
        'Position'        , [0.01, 0.01, 0.98, 0.88] , ...
        'Tag'             , mfilename                );
    
    % Create GUI handles : pointers to access the graphic objects
    handles = guihandles(figHandle);
    
    handles.figureBGcolor = [0.9 0.9 0.9]; set(figHandle,'Color',handles.figureBGcolor);
    handles.buttonBGcolor = handles.figureBGcolor - 0.1;
    handles.editBGcolor   = [1.0 1.0 1.0];
    
    
    %% Graphic objects
    
    % Graph
    a_osci.x = 0.04;
    a_osci.w = 0.45;
    a_osci.y = 0.05 ;
    a_osci.h = 0.85;
    a_osci.tag = 'axes_Oscillo';
    handles.(a_osci.tag) = axes('Parent',figHandle,...
        'Tag',a_osci.tag,...
        'Units','Normalized',...
        'Position',[ a_osci.x a_osci.y a_osci.w a_osci.h ]);
    
    
    % Position
    a_pos.x = a_osci.x + a_osci.w + 0.05;
    a_pos.w = 0.45;
    a_pos.y = a_osci.y ;
    a_pos.h = a_osci.h;
    a_pos.tag = 'axes_Position';
    handles.(a_pos.tag) = axes('Parent',figHandle,...
        'Tag',a_pos.tag,...
        'Units','Normalized',...
        'Position',[ a_pos.x a_pos.y a_pos.w a_pos.h ]);
    
    
    % IP adress
    e_adr.x = a_osci.x;
    e_adr.w = 0.20;
    e_adr.y = a_osci.y + a_osci.h + a_osci.y/2;
    e_adr.h = (1 - e_adr.y)*0.80;
    e_adr.tag = 'edit_Adress';
    handles.(e_adr.tag) = uicontrol(figHandle,...
        'Style','edit',...
        'Tag',e_adr.tag,...
        'Units', 'Normalized',...
        'Position',[e_adr.x e_adr.y e_adr.w e_adr.h],...
        'BackgroundColor',handles.editBGcolor,...
        'String','192.168.18.99',...
        'Tooltip','IP adress',...
        'Callback',@edit_Adress_Callback);
    
    
    % Connecion
    t_con.x = e_adr.x + e_adr.w + 0.05;
    t_con.w = e_adr.w;
    t_con.y = e_adr.y;
    t_con.h = e_adr.h;
    t_con.tag = 'toggle_Connection';
    handles.(t_con.tag) = uicontrol(figHandle,...
        'Style','toggle',...
        'Tag',t_con.tag,...
        'Units', 'Normalized',...
        'Position',[t_con.x t_con.y t_con.w t_con.h],...
        'BackgroundColor',handles.buttonBGcolor,...
        'String','Connect',...
        'Tooltip','Switch On/Off TCPIP connection',...
        'Callback',@toggle_Connection_Callback);
    
    
    % Stream
    t_stream.x = t_con.x + t_con.w + 0.05;
    t_stream.w = e_adr.w;
    t_stream.y = e_adr.y;
    t_stream.h = e_adr.h;
    t_stream.tag = 'toggle_Stream';
    handles.(t_stream.tag) = uicontrol(figHandle,...
        'Style','toggle',...
        'Tag',t_stream.tag,...
        'Units', 'Normalized',...
        'Position',[t_stream.x t_stream.y t_stream.w t_stream.h],...
        'BackgroundColor',handles.buttonBGcolor,...
        'String','Stream',...
        'Tooltip','Switch On/Off the data streaming',...
        'Callback',@toggle_Stream_Callback,....
        'Visible','Off');
    
    % Apply filter
    c_filter.x = t_stream.x + t_stream.w + 0.05;
    c_filter.w = e_adr.w;
    c_filter.y = e_adr.y;
    c_filter.h = e_adr.h;
    c_filter.tag = 'checkbox_Filter';
    handles.(c_filter.tag) = uicontrol(figHandle,...
        'Style','checkbox',...
        'Tag',c_filter.tag,...
        'Units', 'Normalized',...
        'Position',[c_filter.x c_filter.y c_filter.w c_filter.h],...
        'BackgroundColor',handles.figureBGcolor,...
        'String','Filter',...
        'Tooltip','Switch On/Off the filter',...
        'Value',1,...
        'Visible','Off');
    
    
    %% End of opening
    
    % IMPORTANT
    guidata(figHandle,handles)
    % After creating the figure, dont forget the line
    % guidata(figHandle,handles) . It allows smart retrive like
    % handles=guidata(hObject)
    
    % assignin('base','handles',handles)
    % disp(handles)
    
    figPtr = figHandle;
    
    
    %% Default values
    
    
else % Figure exists so brings it to the focus
    
    figure(figPtr);
    
    close(figPtr);
    RDA_GUI;
    
end

if nargout > 0
    
    varargout{1} = guidata(figPtr);
    
end


end % function


%% GUI Functions


% *************************************************************************
function edit_Adress_Callback(hObject, eventdata) %#ok<*INUSD>

errormsg = 'invalid IP adress : x.x.x.x with x in {0;...;255}';

adress = get(hObject,'String');

paternIP = '^([0-9]+\.){3}[0-9]+$';
status = regexp(adress,paternIP,'once');
if isempty(status)
    set(hObject,'String','192.168.18.99')
    error(errormsg)
end

ip = sscanf(adress,'%d.%d.%d.%d');
if any(ip > 255)
    set(hObject,'String','192.168.18.99')
    error(errormsg)
end

end % function


% *************************************************************************
function toggle_Connection_Callback(hObject, eventdata)

handles = guidata(hObject);

switch get(hObject,'Value')
    
    case 1
        
        recorderip = get(handles.edit_Adress,'String');
        
        fprintf('Trying to connect to : %s ... ',recorderip)
        
        % Establish connection to BrainVision Recorder Software 32Bit RDA-Port
        % (use 51234 to connect with 16Bit Port)
        handles.con = pnet('tcpconnect', recorderip, 51244);
%         handles.con = pnet('tcpconnect', recorderip, 51234);
% handles.con = tcpclient(''        

        % Check established connection and display a message
        status = pnet(handles.con,'status');
        if status > 0
            fprintf('connection established \n');
        elseif status == -1
            set(hObject,'Value',0)
            error('connection FAILED')
        end
        
        set(hObject,'BackgroundColor',[0.5 0.5 1])
        set(handles.toggle_Stream,'Visible','On')
        set(handles.checkbox_Filter,'Visible','On')
        
    case 0
        
        % Switch off streaming if needed
        set(handles.toggle_Stream,'Value',0);
        toggle_Stream_Callback(handles.toggle_Stream, eventdata)
        
        % Close all open socket connections
        pnet('closeall');
        
        % Display a message
        fprintf('connection closed \n\n\n');
        
        set(hObject,'BackgroundColor',handles.buttonBGcolor)
        set(handles.toggle_Stream,'Visible','Off')
        set(handles.checkbox_Filter,'Visible','Off')
        
end

guidata(hObject, handles);

end % function


% *************************************************************************
function toggle_Stream_Callback(hObject, eventdata)

handles = guidata(hObject);

switch get(hObject,'Value')
    
    case 1
        
        % Clear axes and ADC data
        cla(handles.axes_Oscillo)
        cla(handles.axes_Position)
        drawnow
        
        handles.RefreshPeriod = 0.010; % secondes
        
        handles.TimerHandle = timer(...
            'StartDelay',0 ,...
            'Period', handles.RefreshPeriod ,...
            'TimerFcn', {@DoStream,handles.(mfilename)} ,...
            'BusyMode', 'drop',...  %'queue'
            'TasksToExecute', Inf,...
            'ExecutionMode', 'fixedRate');
        
        guidata(hObject, handles);
        start(handles.TimerHandle)
        
        set(hObject,'BackgroundColor',[0.5 0.5 1])
        fprintf('Streaming ON ... \n')
        
    case 0
        
        if isfield(handles,'TimerHandle')
            
            try
                stop( handles.TimerHandle );
                delete( handles.TimerHandle );
                handles = rmfield( handles , 'TimerHandle' );
            catch err %#ok<*NASGU>
                warning('GUI:Timer','Cannot delete the timer object. delete(timerfind) can clean all timers in the memory')
            end
            
            fprintf('Streaming off \n')
            
        end
        
        set(hObject,'BackgroundColor',handles.buttonBGcolor)
        
end

guidata(hObject, handles);

end % function


% *************************************************************************
function DoStream(hObject,eventdata,hFigure) %#ok<*INUSL>

global props
global lastBlock
global unfilteredBuffer
global filteredBuffer
global ACC_X_idx
global ACC_Y_idx
global ACC_Z_idx
% global Hd

bufferSize = 5; % second

try
    
    handles = guidata(hFigure);
    
    header_size = 24;
    
    % check for existing data in socket buffer
    tryheader = pnet(handles.con, 'read', header_size, 'byte', 'network', 'view', 'noblock');
    
    while ~isempty(tryheader)
        
        % Read header of RDA message
        hdr = RDA.ReadHeader(handles.con);
        
        % Perform some action depending of the type of the data package
        switch hdr.type
            case 1 % Start, Setup information
                
                disp('Start');
                
                % Read and display properties
                props = RDA.ReadStartMessage(handles.con, hdr);
                disp(props);
                
                ACC_X_idx = strcmp(props.channelNames,'ACC_X');
                ACC_Y_idx = strcmp(props.channelNames,'ACC_Y');
                ACC_Z_idx = strcmp(props.channelNames,'ACC_Z');
                
                
                if sum(ACC_X_idx) == 0
                    stop( handles.TimerHandle );
                    delete( handles.TimerHandle );
                    error('ACC_X channel not found')
                elseif sum(ACC_X_idx) > 1
                    stop( handles.TimerHandle );
                    delete( handles.TimerHandle );
                    error('several ACC_X channels found')
                elseif sum(ACC_Y_idx) == 0
                    stop( handles.TimerHandle );
                    delete( handles.TimerHandle );
                    error('ACC_Y channel not found')
                elseif sum(ACC_Y_idx) > 1
                    stop( handles.TimerHandle );
                    delete( handles.TimerHandle );
                    error('several ACC_Y channels found')
                elseif sum(ACC_Z_idx) == 0
                    stop( handles.TimerHandle );
                    delete( handles.TimerHandle );
                    error('ACC_Z channel not found')
                elseif sum(ACC_Z_idx) > 1
                    stop( handles.TimerHandle );
                    delete( handles.TimerHandle );
                    error('several ACC_Z channels found')
                end
                
                ACC_X_idx = find(ACC_X_idx);
                ACC_Y_idx = find(ACC_Y_idx);
                ACC_Z_idx = find(ACC_Z_idx);
                
                % Reset block counter to check overflows
                lastBlock = -1;
                
                % Fill data buffer with zeros and plot first time to
                % get handles
                unfilteredBuffer = zeros( bufferSize * 1000000 / props.samplingInterval, 3);
                filteredBuffer = unfilteredBuffer;
                
            case 4 % 32Bit Data block
                
                % Read data and markers from message
                [datahdr, data, markers] = RDA.ReadDataMessage(handles.con, hdr, props);
                
                % check tcpip buffer overflow
                if lastBlock ~= -1 && datahdr.block > lastBlock + 1
                    disp(['******* Overflow with ' int2str(datahdr.block - lastBlock) ' blocks ******']);
                end
                lastBlock = datahdr.block;
                
                %                 % print marker info to MATLAB console
                %                 if datahdr.markerCount > 0
                %                     for m = 1:datahdr.markerCount
                %                         disp(markers(m));
                %                     end
                %                 end
                
                % Process EEG data,
                % in this case extract last recorded second,
                EEGData = reshape(data, props.channelCount, length(data) / props.channelCount)';
                EEGData = EEGData(:,[ACC_X_idx ACC_Y_idx ACC_Z_idx]); % save only the EOG channels
                
                % Apply scaling resolution
                EEGData(:,1) = EEGData(:,1) * props.resolutions(ACC_X_idx);
                EEGData(:,2) = EEGData(:,2) * props.resolutions(ACC_Y_idx);
                EEGData(:,3) = EEGData(:,3) * props.resolutions(ACC_Z_idx);
                
                filteredBuffer = [unfilteredBuffer ; EEGData];
                filteredBuffer = filteredBuffer(end-length(unfilteredBuffer)+1 : end, : );
                unfilteredBuffer = filteredBuffer;
                
                % PCA =====================================================
                
                [nChan,nPoints] = size(unfilteredBuffer);
                
                % Perform Singular Value Ddecomposition
                [u,s,v] = svd(unfilteredBuffer,0);
                
                % Singular values -> Eigen values
                singular_values = diag(s);
                eigen_values    = singular_values.^2/(nChan-1);
                LATENT          = eigen_values; % [nPCs, 1]
                
                % Eigen_values -> Variance explained
                vairance_explained = 100*eigen_values/sum(eigen_values); % in percent (%)
                EXPLAINED          = vairance_explained;                 % [nPCs, 1]
                
                % Sign convention : the max(abs(PCs)) is positive
                [~,maxabs_idx] = max(abs(v));
                [m,n]          = size(v);
                idx            = 0:m:(n-1)*m;
                val            = v(maxabs_idx + idx);
                sgn            = sign(val);
                v              = v .* sgn;
                u              = u .* sgn;
                
                COEFF = v;                     % [nVolumes, nPCs]
                SCORE = u .* singular_values'; % [nVoxel  , nPCs]
                
                filteredBuffer = SCORE(:,1);
                
                % =========================================================
                
                filteredBuffer = mean(unfilteredBuffer,2); % or average

                if get(handles.checkbox_Filter,'Value')
                    filteredBuffer = ft_preproc_bandpassfilter( filteredBuffer', props.samplingInterval, [0.05 20])';
                end

                % Amplitude : µV
                time = (1:length(filteredBuffer(:,1)))*props.samplingInterval/(1000000);
                time = fliplr(time); % for X tick labels
%                 plot(handles.axes_Oscillo,time,filteredBuffer(:,1),'red',time,filteredBuffer(:,2),'blue',time,filteredBuffer(:,3),'green')
                plot(handles.axes_Oscillo,time,filteredBuffer(:,1),'red')
                set(handles.axes_Oscillo,'Xdir','reverse')
                xlim(handles.axes_Oscillo,[0 bufferSize])
                
                signal = filteredBuffer(:,1);
                fs     = 1/(props.samplingInterval/1000000);
                
                L = length(signal);
                
                Y = fft(signal);
                P2 = abs(Y/L);
                P1 = P2(1:L/2+1);
                P1(2:end-1) = 2*P1(2:end-1);
                f = fs*(0:(L/2))/L;

                plot(handles.axes_Position,f,P1)
                xlabel(handles.axes_Position,'Frequency (Hz)')
                ylabel(handles.axes_Position,'|Y(f)|')
                
%                 hold(handles.axes_Position,'off')
                xlim(handles.axes_Position,[0 10])
                
            case 3       % Stop message
                disp('Stop');
                data = pnet(handles.con, 'read', hdr.size - header_size);
                finish = true;
                
            otherwise    % ignore all unknown types, but read the package from buffer
                data = pnet(handles.con, 'read', hdr.size - header_size);
        end
        
        tryheader = pnet(handles.con, 'read', header_size, 'byte', 'network', 'view', 'noblock');
        
    end
    
catch err
    
    err.getReport
    
end

end % function
