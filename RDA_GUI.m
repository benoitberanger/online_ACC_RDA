function varargout = RDA_GUI
% Run this function start a GUI that will handle the whole stimulation
% process and parameters

% debug=1 closes previous figure and reopens it, and send the gui handles
% to base workspace.
debug = 1;


%% Open a singleton figure

% Is the GUI already open ?
figPtr = findall(0,'Tag',mfilename);

% Force go the directory
task_code_dir = fileparts(which(mfilename));
cd(task_code_dir)

if ~isempty(figPtr) % Figure exists so brings it to the focus
    
    figure(figPtr);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if debug
        close(figPtr); %#ok<UNRCH>
        RDA_GUI;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
else % Create the figure
    
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
    
    
    %% ====================================================================
    %% Graphic objects
    %% ====================================================================
    
    
    %% Panels
    
    panel_x_ratio = 0.2;
    panel_y_ratio = 0.3;
    
    P_setup.x = 0;
    P_setup.w =   panel_x_ratio;
    P_setup.y = 1-panel_y_ratio;
    P_setup.h =   panel_y_ratio;
    handles.uipanel_Setup = uipanel(handles.(mfilename),...
        'Title','Setup',...
        'Units', 'Normalized',...
        'Position',[P_setup.x P_setup.y P_setup.w P_setup.h],...
        'BackgroundColor',handles.figureBGcolor );
    
    P_audio.x = 0;
    P_audio.w =   panel_x_ratio;
    P_audio.y = 0;
    P_audio.h = 1-panel_y_ratio;
    handles.uipanel_Audio = uipanel(handles.(mfilename),...
        'Title','Audio',...
        'Units', 'Normalized',...
        'Position',[P_audio.x P_audio.y P_audio.w P_audio.h],...
        'BackgroundColor',handles.figureBGcolor );
    
    P_graph.x =   panel_x_ratio;
    P_graph.w = 1-panel_x_ratio;
    P_graph.y = 0;
    P_graph.h = 1;
    handles.uipanel_Graph = uipanel(handles.(mfilename),...
        'Title','Graph',...
        'Units', 'Normalized',...
        'Position',[P_graph.x P_graph.y P_graph.w P_graph.h],...
        'BackgroundColor',handles.figureBGcolor );
    
    obj_x_offcet = 0.05;
    obj_x_width  = 1 - 2*obj_x_offcet;
    
    
    %% Panel : Setup
    
    %     [    ip    ] [connect]
    %
    %     subjectID
    %     [                    ]
    %
    %     sessionID
    %     [                    ]
    %
    %     Outputfile:
    %     |                    |
    
    P_setup = Object_pos_width_dispatcher(...
        [1 3 1 1  3 1 1  3 1 1  2],...
        P_setup );
    
    % Empty space
    P_setup.count = P_setup.count+1;
    
    P_setup.count = P_setup.count+1;
    Txt_fnameD.x = obj_x_offcet;
    Txt_fnameD.w = obj_x_width;
    Txt_fnameD.y = P_setup.pos  (P_setup.count);
    Txt_fnameD.h = P_setup.width(P_setup.count);
    Txt_fnameD.tag = 'text_fnameD';
    handles.(Txt_fnameD.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','text',...
        'Units', 'Normalized',...
        'Position',[Txt_fnameD.x Txt_fnameD.y Txt_fnameD.w Txt_fnameD.h],...
        'String','',...
        'BackgroundColor',handles.figureBGcolor*1.1,...
        'Visible','On');
    
    P_setup.count = P_setup.count+1;
    Txt_fnameU.x = obj_x_offcet;
    Txt_fnameU.w = obj_x_width;
    Txt_fnameU.y = P_setup.pos  (P_setup.count);
    Txt_fnameU.h = P_setup.width(P_setup.count);
    Txt_fnameU.tag = 'text_fnameU';
    handles.(Txt_fnameU.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','text',...
        'Units', 'Normalized',...
        'Position',[Txt_fnameU.x Txt_fnameU.y Txt_fnameU.w Txt_fnameU.h],...
        'String','File name:',...
        'BackgroundColor',handles.figureBGcolor,...
        'Visible','On',...
        'HorizontalAlignment','Left');
    
    % Empty space
    P_setup.count = P_setup.count+1;
    
    % SessionID
    P_setup.count = P_setup.count+1;
    E_sessionID.x = obj_x_offcet;
    E_sessionID.w = obj_x_width;
    E_sessionID.y = P_setup.pos  (P_setup.count);
    E_sessionID.h = P_setup.width(P_setup.count);
    E_sessionID.tag = 'edit_sessionID';
    handles.(E_sessionID.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','edit',...
        'Units', 'Normalized',...
        'Position',[E_sessionID.x E_sessionID.y E_sessionID.w E_sessionID.h],...
        'String','',...
        'BackgroundColor',handles.editBGcolor,...
        'Visible','On',...
        'HorizontalAlignment','Left',...
        'Callback',@edit_GenerateFname_Callback);
    
    P_setup.count = P_setup.count+1;
    Txt_sessionID.x = obj_x_offcet;
    Txt_sessionID.w = obj_x_width;
    Txt_sessionID.y = P_setup.pos  (P_setup.count);
    Txt_sessionID.h = P_setup.width(P_setup.count);
    Txt_sessionID.tag = 'text_sessionID';
    handles.(Txt_sessionID.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','text',...
        'Units', 'Normalized',...
        'Position',[Txt_sessionID.x Txt_sessionID.y Txt_sessionID.w Txt_sessionID.h],...
        'String','Session ID :',...
        'BackgroundColor',handles.figureBGcolor,...
        'Visible','On',...
        'HorizontalAlignment','Left');
    
    % Empty space
    P_setup.count = P_setup.count+1;
    
    % SubjectID
    P_setup.count = P_setup.count+1;
    E_subjectID.x = obj_x_offcet;
    E_subjectID.w = obj_x_width;
    E_subjectID.y = P_setup.pos  (P_setup.count);
    E_subjectID.h = P_setup.width(P_setup.count);
    E_subjectID.tag = 'edit_subjectID';
    handles.(E_subjectID.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','edit',...
        'Units', 'Normalized',...
        'Position',[E_subjectID.x E_subjectID.y E_subjectID.w E_subjectID.h],...
        'String','',...
        'BackgroundColor',handles.editBGcolor,...
        'Visible','On',...
        'HorizontalAlignment','Left',...
        'Callback',@edit_GenerateFname_Callback);
    
    P_setup.count = P_setup.count+1;
    Txt_subjectID.x = obj_x_offcet;
    Txt_subjectID.w = obj_x_width;
    Txt_subjectID.y = P_setup.pos  (P_setup.count);
    Txt_subjectID.h = P_setup.width(P_setup.count);
    Txt_subjectID.tag = 'text_subjectID';
    handles.(Txt_subjectID.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','text',...
        'Units', 'Normalized',...
        'Position',[Txt_subjectID.x Txt_subjectID.y Txt_subjectID.w Txt_subjectID.h],...
        'String','Subject ID :',...
        'BackgroundColor',handles.figureBGcolor,...
        'Visible','On',...
        'HorizontalAlignment','Left');
    
    % Empty space
    P_setup.count = P_setup.count+1;
    
    % IP adress
    P_setup.count = P_setup.count+1;
    E_adr.x = obj_x_offcet;
    E_adr.w = obj_x_width/2;
    E_adr.y = P_setup.pos  (P_setup.count);
    E_adr.h = P_setup.width(P_setup.count);
    E_adr.tag = 'edit_Adress';
    handles.(E_adr.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','edit',...
        'Tag',E_adr.tag,...
        'Units', 'Normalized',...
        'Position',[E_adr.x E_adr.y E_adr.w E_adr.h],...
        'BackgroundColor',handles.editBGcolor,...
        'String','192.168.18.99',...
        'Tooltip','IP adress',...
        'Callback',@edit_Adress_Callback);
    
    % Connecion
    T_con.x = obj_x_offcet + obj_x_width/2 + obj_x_offcet;
    T_con.w =                obj_x_width/2 - obj_x_offcet;
    T_con.y = P_setup.pos  (P_setup.count);
    T_con.h = P_setup.width(P_setup.count);
    T_con.tag = 'toggle_Connection';
    handles.(T_con.tag) = uicontrol( handles.uipanel_Setup,...
        'Style','toggle',...
        'Tag',T_con.tag,...
        'Units', 'Normalized',...
        'Position',[T_con.x T_con.y T_con.w T_con.h],...
        'BackgroundColor',handles.buttonBGcolor,...
        'String','Connect',...
        'Tooltip','Switch On/Off TCPIP connection',...
        'Callback',@toggle_Connection_Callback);
    
    
    %% Panel : Graph
    
    P_graph = Object_pos_width_dispatcher(...
        [1 3  1 5  1 5  1 1 ],...
        P_graph );
    
    % Empty space
    P_graph.count = P_graph.count+1;
    
    % freqDomain
    P_graph.count = P_graph.count+1;
    a_freqDomain.x = obj_x_offcet;
    a_freqDomain.w = obj_x_width;
    a_freqDomain.y = P_graph.pos  (P_graph.count);
    a_freqDomain.h = P_graph.width(P_graph.count);
    a_freqDomain.tag = 'axes_freqDomain';
    handles.(a_freqDomain.tag) = axes('Parent',handles.uipanel_Graph,...
        'Tag',a_freqDomain.tag,...
        'Units','Normalized',...
        'Position',[ a_freqDomain.x a_freqDomain.y a_freqDomain.w a_freqDomain.h ]);
    
    % Empty space
    P_graph.count = P_graph.count+1;
    
    % powerDowain
    P_graph.count = P_graph.count+1;
    a_powerDomain.x = obj_x_offcet;
    a_powerDomain.w = obj_x_width;
    a_powerDomain.y = P_graph.pos  (P_graph.count);
    a_powerDomain.h = P_graph.width(P_graph.count);
    a_powerDomain.tag = 'axes_powerDomain';
    handles.(a_powerDomain.tag) = axes('Parent',handles.uipanel_Graph,...
        'Tag',a_powerDomain.tag,...
        'Units','Normalized',...
        'Position',[ a_powerDomain.x a_powerDomain.y a_powerDomain.w a_powerDomain.h ]);
    
    % Empty space
    P_graph.count = P_graph.count+1;
    
    % timeDomain
    P_graph.count = P_graph.count+1;
    a_timeDomain.x = obj_x_offcet;
    a_timeDomain.w = obj_x_width;
    a_timeDomain.y = P_graph.pos  (P_graph.count);
    a_timeDomain.h = P_graph.width(P_graph.count);
    a_timeDomain.tag = 'axes_timeDomain';
    handles.(a_timeDomain.tag) = axes('Parent',handles.uipanel_Graph,...
        'Tag',a_timeDomain.tag,...
        'Units','Normalized',...
        'Position',[ a_timeDomain.x a_timeDomain.y a_timeDomain.w a_timeDomain.h ]);
    
    % Empty space
    P_graph.count = P_graph.count+1;
    
    % Stream
    P_graph.count = P_graph.count+1;
    t_stream.x = obj_x_offcet;
    t_stream.w = obj_x_width/2;
    t_stream.y = P_graph.pos  (P_graph.count);
    t_stream.h = P_graph.width(P_graph.count);
    t_stream.tag = 'toggle_Stream';
    handles.(t_stream.tag) = uicontrol(handles.uipanel_Graph,...
        'Style','toggle',...
        'Tag',t_stream.tag,...
        'Units', 'Normalized',...
        'Position',[t_stream.x t_stream.y t_stream.w t_stream.h],...
        'BackgroundColor',handles.buttonBGcolor,...
        'String','Stream',...
        'Tooltip','Switch On/Off the data streaming',...
        'Callback',@toggle_Stream_Callback,....
        'Visible','On');
    
    % Apply filter
    % same Y
    c_filter.x = obj_x_offcet + obj_x_width/2 + obj_x_offcet;
    c_filter.w =                obj_x_width/2 - obj_x_offcet;
    c_filter.y = P_graph.pos  (P_graph.count);
    c_filter.h = P_graph.width(P_graph.count);
    c_filter.tag = 'checkbox_Filter';
    handles.(c_filter.tag) = uicontrol(handles.uipanel_Graph,...
        'Style','checkbox',...
        'Tag',c_filter.tag,...
        'Units', 'Normalized',...
        'Position',[c_filter.x c_filter.y c_filter.w c_filter.h],...
        'BackgroundColor',handles.figureBGcolor,...
        'String','Filter',...
        'Tooltip','Switch On/Off the filter',...
        'Value',1,...
        'Visible','On');
    
    
    %% Default values
    
    fs          = 5000; % Hz
    bufferSize  = 60; % seconds
    displaySize = 10; % seconds
    fftWindow   = 3;  % seconds
    
    
    %% Setup graph
    
    handles.fs          = fs;
    handles.displaySize = displaySize;
    handles.fftWindow   = fftWindow;
    
    global rawACC %#ok<TLEV>
    rawACC = zeros(displaySize*fs,3);
    
    % timeDomain
    timeDomain.X = 1/fs:1/fs:displaySize;
    timeDomain.Y = zeros(size(timeDomain.X));
    handles.tplot = plot(handles.axes_timeDomain, timeDomain.X, timeDomain.Y);
    handles.axes_timeDomain.XLabel.String = 'time (s)';
    handles.axes_timeDomain.YLabel.String = 'amplitude (A.U.)';
    
    % powerDomain
    powerDomain.X = timeDomain.X;
    powerDomain.Y = timeDomain.Y;
    handles.pplot = plot(handles.axes_powerDomain, powerDomain.X, powerDomain.Y);
    handles.axes_powerDomain.XLabel.String = 'time (s)';
    handles.axes_powerDomain.YLabel.String = 'power[4-6]Hz ratio';
    
    % freqDomain
    [freqDomain.X, freqDomain.Y] = FFT(getWindow(timeDomain.Y',fs,fftWindow),fs);
    handles.fplot = plot(handles.axes_freqDomain, freqDomain.X, freqDomain.Y);
    handles.axes_freqDomain.XLabel.String = 'frequency (Hz)';
    handles.axes_freqDomain.YLabel.String = 'Power (A.U.)';
    handles.axes_freqDomain.XLim = [0 30];
    handles.axes_freqDomain.XTick = 0:30;
    
    
    %% End of opening
    
    % IMPORTANT
    guidata(figHandle,handles)
    % After creating the figure, dont forget the line
    % guidata(figHandle,handles) . It allows smart retrive like
    % handles=guidata(hObject)
    
    % assignin('base','handles',handles)
    % disp(handles)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if debug
        assignin('base','handles',handles) %#ok<UNRCH>
        disp(handles)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    figPtr = figHandle;
    
    
end

if nargout > 0
    
    varargout{1} = guidata(figPtr);
    
end


end % function


%% GUI Functions

% -------------------------------------------------------------------------
function edit_GenerateFname_Callback(hObject, eventdata)
handles = guidata(hObject);

subjectID = handles.edit_subjectID.String; % fetch the field in the GUI
sessionID = handles.edit_sessionID.String; % fetch the field in the GUI

timestamp = datestr(now, 30); % it looks like "20200625T184209"

data_dir = fullfile( fileparts(fileparts(mfilename('fullpath'))), 'data' );

% Generate & save fname
fname = fullfile(data_dir,...
    [timestamp '__' subjectID '__' sessionID '.mat']); % generate
handles.fname = fname;                                 % save it in the GUI main variable
handles.text_fnameD.String = fname;                    % show it in the GUI

guidata(hObject, handles);
end % function

% -------------------------------------------------------------------------
function obj = Object_pos_width_dispatcher( vect , obj )

obj.vect  = vect; % relative proportions of each panel, from left to right

obj.vectLength    = length(obj.vect);
obj.vectTotal     = sum(obj.vect);
obj.adjustedTotal = obj.vectTotal + 1;
obj.unitWidth     = 1/obj.adjustedTotal;
obj.interWidth    = obj.unitWidth/obj.vectLength;

obj.count  = 0;
obj.pos   = @(count) obj.unitWidth*sum(obj.vect(1:(count-1))) + 0.8*count*obj.interWidth;
obj.width = @(count) obj.vect(count)*obj.unitWidth;

end % function

% *************************************************************************
function window = getWindow(data,fs,windowlength)

window = data(end-fs*windowlength-1:end,:);

end % function

% *************************************************************************
function [frequency,power] = FFT(signal,fs)

L = length(signal);
Y = fft(signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
power = P1;
frequency = fs*(0:(L/2))/L;

end % function

% *************************************************************************
function [SCORE,COEFF,LATENT,EXPLAINED] = PCA(data)

% PCA =====================================================

[nChan,nPoint] = size(data); %#ok<ASGLU>

% Perform Singular Value Ddecomposition
[u,s,v] = svd(data,0);

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

COEFF = v;                     % [nChan  , nPCs]
SCORE = u .* singular_values'; % [nPoint , nPCs]

end % function

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
        
        handles.RefreshPeriod = 0.010; % secondes
        
        handles.TimerHandle = timer(...
            'StartDelay',0 ,...
            'Period', handles.RefreshPeriod ,...
            'TimerFcn', {@DoStream,handles.(mfilename)} ,...
            'BusyMode', 'drop',...  %'queue'
            'TasksToExecute', Inf,...
            'ExecutionMode', 'fixedRate');
        
        guidata(hObject, handles);
        
        set(hObject,'BackgroundColor',[0.5 0.5 1])
        fprintf('Streaming ON \n')
        
        start(handles.TimerHandle)
        
    case 0
        
        if isfield(handles,'TimerHandle')
            
            try
                stop( handles.TimerHandle );
                delete( handles.TimerHandle );
                handles = rmfield( handles , 'TimerHandle' );
            catch err %#ok<*NASGU>
                warning('GUI:Timer','Cannot delete the timer object. delete(timerfind) can clean all timers in the memory')
            end
            
            fprintf('Streaming OFF \n')
            
        end
        
        set(hObject,'BackgroundColor',handles.buttonBGcolor)
        
end

guidata(hObject, handles);

end % function


% *************************************************************************
function DoStream(hObject,eventdata,hFigure) %#ok<*INUSL>
handles = guidata(hFigure);

global props
global lastBlock
global ACC_X_idx
global ACC_Y_idx
global ACC_Z_idx
global rawACC

try
    header_size = 24;
    
    % check for existing data in socket buffer
    tryheader = pnet(handles.con, 'read', header_size, 'byte', 'network', 'view', 'noblock');
    stop = false;
    
    while ~isempty(tryheader) && ~stop
        
        % Read header of RDA message
        hdr = RDA.ReadHeader(handles.con);
        
        % Perform some action depending of the type of the data package
        switch hdr.type
            case 1 % Start, Setup information
                
                disp('Start');
                
                % Read and display properties
                props = RDA.ReadStartMessage(handles.con, hdr);
                handles.props = props;
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
                
            case 4 % 32Bit Data block
                
                % Read data and markers from message
                [datahdr, data, markers] = RDA.ReadDataMessage(handles.con, hdr, props); %#ok<ASGLU>
                data = double(data);
                
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
                newACC = reshape(data, props.channelCount, length(data) / props.channelCount)';
                newACC = newACC(:,[ACC_X_idx ACC_Y_idx ACC_Z_idx]); % save only the EOG channels
                
                % Apply scaling resolution
                newACC(:,1) = newACC(:,1) * props.resolutions(ACC_X_idx);
                newACC(:,2) = newACC(:,2) * props.resolutions(ACC_Y_idx);
                newACC(:,3) = newACC(:,3) * props.resolutions(ACC_Z_idx);
                
                % update
                nr_new_points = size(newACC,1);
                rawACC = circshift(rawACC,-nr_new_points,1);
                rawACC(end-nr_new_points+1 : end, : ) = newACC;
                
                if get(handles.checkbox_Filter,'Value')
                    %                     filtACC = ft_preproc_bandpassfilter( rawACC', handles.fs, [0.1 20],4)';
                    filtACC = ft_preproc_highpassfilter( rawACC', handles.fs, 1, 4 )';
                else
                    filtACC = rawACC;
                end
                
                PC = PCA(filtACC);
                compACC = PC(:,1);
                % compACC = mean(filtACC,2); % or average
                
                handles.tplot.YData = flipud(compACC);
                
                windowACC = getWindow(compACC,handles.fs,handles.fftWindow);
                [~,power] = FFT(windowACC,handles.fs);
                handles.fplot.YData = power;
                
            case 3       % Stop message
                disp('Stop');
                data = pnet(handles.con, 'read', hdr.size - header_size);
                finish = true;
                
            otherwise    % ignore all unknown types, but read the package from buffer
                data = pnet(handles.con, 'read', hdr.size - header_size);
        end
        
        tryheader = pnet(handles.con, 'read', header_size, 'byte', 'network', 'view', 'noblock');
        stop = ~get(handles.toggle_Stream,'Value') || ~get(handles.toggle_Connection,'Value') ;
        
    end
    
catch err
    
    err.getReport
    
end

end % function
