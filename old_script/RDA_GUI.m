function varargout = RDA_GUI
% Run this function start a GUI that will handle the whole stimulation
% process and parameters

% debug=1 closes previous figure and reopens it, and send the gui handles
% to base workspace.
debug = 1;

%% ====================================================================
%% Open a singleton figure
%% ====================================================================

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
    panel_y_ratio = 0.4;
    
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
    
    %     [   ip   ] [[connect]]
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
        'HorizontalAlignment','Left');
    %         'Callback',@edit_GenerateFname_Callback);
    
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
    E_adr.w = obj_x_width/2 - obj_x_offcet;
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
    
    
    %% Panel : Audio
    
    %
    % Audio (x)Off  ( )On      ParPort (x)Off  ( )On
    %
    % [] TestAudio         [] [] TestParPort      []
    %
    % [] Posture                                  []
    %
    % [] Rest                                     []
    %
    
    
    P_audio = Object_pos_width_dispatcher(...
        [1 3  1 3  1 2  2],...
        P_audio );
    
    % Empty space
    P_audio.count = P_audio.count+1;
    
    % Rest
    P_audio.count = P_audio.count+1;
    B_rest.x = obj_x_offcet;
    B_rest.w = obj_x_width;
    B_rest.y = P_audio.pos  (P_audio.count);
    B_rest.h = P_audio.width(P_audio.count);
    B_rest.tag = 'pushbutton_Rest';
    handles.(B_rest.tag) = uicontrol(handles.uipanel_Audio,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[B_rest.x B_rest.y B_rest.w B_rest.h],...
        'String','Repos',...
        'BackgroundColor',handles.buttonBGcolor*0.9,...
        'Tag',B_rest.tag,...
        'Callback',@pushbutton_SendAudio_Callback,...
        'Visible','Off');
    
    % Empty space
    P_audio.count = P_audio.count+1;
    
    % Posture
    P_audio.count = P_audio.count+1;
    B_posture.x = obj_x_offcet;
    B_posture.w = obj_x_width;
    B_posture.y = P_audio.pos  (P_audio.count);
    B_posture.h = P_audio.width(P_audio.count);
    B_posture.tag = 'pushbutton_Posture';
    handles.(B_posture.tag) = uicontrol(handles.uipanel_Audio,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[B_posture.x B_posture.y B_posture.w B_posture.h],...
        'String','Posture',...
        'BackgroundColor',handles.buttonBGcolor*0.9,...
        'Tag',B_posture.tag,...
        'Callback',@pushbutton_SendAudio_Callback,...
        'Visible','Off');
    
    % Empty space
    P_audio.count = P_audio.count+1;
    
    % TestAudio
    P_audio.count = P_audio.count+1;
    B_testaudio.x = obj_x_offcet;
    B_testaudio.w = obj_x_width/2 - obj_x_offcet;
    B_testaudio.y = P_audio.pos  (P_audio.count);
    B_testaudio.h = P_audio.width(P_audio.count);
    B_testaudio.tag = 'pushbutton_TestAudio';
    handles.(B_testaudio.tag) = uicontrol(handles.uipanel_Audio,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[B_testaudio.x B_testaudio.y B_testaudio.w B_testaudio.h],...
        'String','TestAudio',...
        'BackgroundColor',handles.buttonBGcolor*0.9,...
        'Tag',B_testaudio.tag,...
        'Callback',@pushbutton_SendAudio_Callback,...
        'Visible','Off');
    
    % TestParPort
    % Same Y
    B_testpp.x = obj_x_offcet + obj_x_width/2 + obj_x_offcet;
    B_testpp.w =                obj_x_width/2 - obj_x_offcet;
    B_testpp.y = P_audio.pos  (P_audio.count);
    B_testpp.h = P_audio.width(P_audio.count);
    B_testpp.tag = 'pushbutton_TestParPort';
    handles.(B_testpp.tag) = uicontrol(handles.uipanel_Audio,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[B_testpp.x B_testpp.y B_testpp.w B_testpp.h],...
        'String','TestParPort',...
        'BackgroundColor',handles.buttonBGcolor*0.9,...
        'Tag',B_testpp.tag,...
        'Callback',@pushbutton_TestParPort_Callback,...
        'Visible','Off');
    
    
    % ButtunGroup : Audio On/Off
    P_audio.count = P_audio.count+1;
    p_aof.x = obj_x_offcet;
    p_aof.w = obj_x_width/2 - obj_x_offcet;
    p_aof.y = P_audio.pos  (P_audio.count);
    p_aof.h = P_audio.width(P_audio.count);
    handles.uipanel_AudioOnOff = uibuttongroup( handles.uipanel_Audio, ...
        'Title','Audio : On / Off',...
        'Units', 'Normalized',...
        'Position',[p_aof.x p_aof.y p_aof.w p_aof.h],...
        'BackgroundColor',handles.figureBGcolor,...
        'SelectionChangeFcn',@uipanel_AudioOnOff_SelectionChangeFcn);
    
    % ButtunGroup : ParPort On/Off
    % Same Y
    p_ppof.x = obj_x_offcet + obj_x_width/2 + obj_x_offcet;
    p_ppof.w =                obj_x_width/2 - obj_x_offcet;
    p_ppof.y = P_audio.pos  (P_audio.count);
    p_ppof.h = P_audio.width(P_audio.count);
    handles.uipanel_ParPortOnOff = uibuttongroup( handles.uipanel_Audio, ...
        'Title','ParPort : On / Off',...
        'Units', 'Normalized',...
        'Position',[p_ppof.x p_ppof.y p_ppof.w p_ppof.h],...
        'BackgroundColor',handles.figureBGcolor,...
        'SelectionChangeFcn',@uipanel_ParPortOnOff_SelectionChangeFcn);
    
    % Audio : On Off buttons
    handles.radiobutton_Audio_Off = uicontrol( handles.uipanel_AudioOnOff,...
        'Style','radiobutton',...
        'Units', 'Normalized',...
        'Position',[obj_x_offcet*2, 0.1, obj_x_width/2 - obj_x_offcet, 0.8],...
        'String','Off',...
        'HorizontalAlignment','Center',...
        'Tag','radiobutton_Audio_Off',...
        'BackgroundColor',handles.figureBGcolor);
    handles.radiobutton_Audio_On = uicontrol( handles.uipanel_AudioOnOff,...
        'Style','radiobutton',...
        'Units', 'Normalized',...
        'Position',[obj_x_offcet + obj_x_width/2 + obj_x_offcet, 0.1, obj_x_width/2 - obj_x_offcet, 0.8],...
        'String','On',...
        'HorizontalAlignment','Center',...
        'Tag','radiobutton_Audio_On',...
        'BackgroundColor',handles.figureBGcolor);
    
    % ParPort : On Off buttons
    handles.radiobutton_ParPort_Off = uicontrol( handles.uipanel_ParPortOnOff,...
        'Style','radiobutton',...
        'Units', 'Normalized',...
        'Position',[obj_x_offcet*2, 0.1, obj_x_width/2 - obj_x_offcet, 0.8],...
        'String','Off',...
        'HorizontalAlignment','Center',...
        'Tag','radiobutton_ParPort_Off',...
        'BackgroundColor',handles.figureBGcolor);
    handles.radiobutton_ParPort_On = uicontrol( handles.uipanel_ParPortOnOff,...
        'Style','radiobutton',...
        'Units', 'Normalized',...
        'Position',[obj_x_offcet + obj_x_width/2 + obj_x_offcet, 0.1, obj_x_width/2 - obj_x_offcet, 0.8],...
        'String','On',...
        'HorizontalAlignment','Center',...
        'Tag','radiobutton_ParPort_On',...
        'BackgroundColor',handles.figureBGcolor);
    
    
    %% Panel : Graph
    
    % [[ STREAM ]] [Start] [Stop]
    %  ________________________
    % |aplitude                |
    % |                        |
    % |________________________|
    %
    %  ________________________
    % |power                   |
    % |                        |
    % |________________________|
    %
    %  ________________________
    % |classic FFT             |
    % |                        |
    % |________________________|
    %
    
    
    P_graph = Object_pos_width_dispatcher(...
        [1 4  1 6  1 6  1 1 ],...
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
    t = obj_x_width - 2*obj_x_offcet;
    w = t/3;
    P_graph.count = P_graph.count+1;
    t_stream.x = obj_x_offcet;
    t_stream.w = w;
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
        'Visible','Off');
    
    % Start recording
    p_start.x = obj_x_offcet*2 + w;
    p_start.w = w;
    p_start.y = P_graph.pos  (P_graph.count);
    p_start.h = P_graph.width(P_graph.count);
    p_start.tag = 'pushbutton_Start';
    handles.(p_start.tag) = uicontrol(handles.uipanel_Graph,...
        'Style','pushbutton',...
        'Tag',p_start.tag,...
        'Units', 'Normalized',...
        'Position',[p_start.x p_start.y p_start.w p_start.h],...
        'BackgroundColor',handles.figureBGcolor,...
        'String','Start',...
        'Visible','Off');
    
    % Stop recording
    p_stop.x = obj_x_offcet*3 + w*2;
    p_stop.w = w;
    p_stop.y = P_graph.pos  (P_graph.count);
    p_stop.h = P_graph.width(P_graph.count);
    p_stop.tag = 'pushbutton_Stop';
    handles.(p_stop.tag) = uicontrol(handles.uipanel_Graph,...
        'Style','pushbutton',...
        'Tag',p_stop.tag,...
        'Units', 'Normalized',...
        'Position',[p_stop.x p_stop.y p_stop.w p_stop.h],...
        'BackgroundColor',handles.figureBGcolor,...
        'String','Stop',...
        'Visible','Off');
    
    
    %% Default values
    
    fs          = 5000; % Hz
    
    bufferSize  = 60; % seconds
    displaySize = 30; % seconds
    fftWindow   =  1; % seconds
    
    
    %% Setup graph
    
    handles.fs          = fs;
    handles.displaySize = displaySize;
    handles.fftWindow   = fftWindow;
    
    global rawACC ratio_power onset%#ok<TLEV>
    rawACC      = zeros(displaySize*fs,3);
    ratio_power = zeros(displaySize*fs,1);
    onset       = GetSecs;
    
    % timeDomain
    timeDomain.X = 1/fs:1/fs:displaySize;
    timeDomain.Y = zeros(size(timeDomain.X));
    handles.tplot = plot(handles.axes_timeDomain, timeDomain.X, timeDomain.Y);
    handles.axes_timeDomain.XLabel.String = 'time (s)';
    handles.axes_timeDomain.YLabel.String = 'Acceleration (g)';
    handles.axes_timeDomain.YLim = [0 5];
    
    % powerDomain
    powerDomain.X = timeDomain.X;
    powerDomain.Y = timeDomain.Y;
    handles.pplot = plot(handles.axes_powerDomain, powerDomain.X, powerDomain.Y);
    handles.axes_powerDomain.XLabel.String = 'time (s)';
    handles.axes_powerDomain.YLabel.String = 'power[4-6]Hz ratio';
    handles.axes_powerDomain.YLim = [0 0.5];
    
    % freqDomain
    [freqDomain.X, freqDomain.Y] = FFT(getWindow(timeDomain.Y',fs,fftWindow),fs);
    handles.fplot = plot(handles.axes_freqDomain, freqDomain.X, freqDomain.Y);
    handles.axes_freqDomain.XLabel.String = 'frequency (Hz)';
    handles.axes_freqDomain.YLabel.String = 'Power (g^2)';
    handles.axes_freqDomain.XLim  = [1 30];
    handles.axes_freqDomain.XTick =  1:30;
    handles.axes_freqDomain.YLim  = [0 1.5];
    
    
    %% Set keys
    
    KbName('UnifyKeyNames');
    handles.Keybinds.Posture = KbName('b');
    handles.Keybinds.Rest    = KbName('y');
    
    fprintf('\n')
    fprintf('Response buttons (fORRP 932) : \n')
    fprintf('USB \n')
    fprintf('2 x 1 CYL \n')
    fprintf('HID NAR BYGRT \n')
    fprintf('\n')
    
    
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

%% ====================================================================
%% GUI Functions
%% ====================================================================

% *************************************************************************
function pushbutton_TestParPort_Callback(hObject, eventdata)
handles = guidata(hObject);

fprintf('[%s]: starting... \n', 'TestParPort');

for i = 0 : 7
    msg = 2^i;
    WriteParPort(msg);
    fprintf('[%s]: writing %d \n', 'TestParPort', msg);
    WaitSecs(0.250); % 250 ms
end

fprintf('[%s]: ...done \n', 'TestParPort');

guidata(hObject, handles);
end % function

% -------------------------------------------------------------------------
function pushbutton_SendAudio_Callback(hObject, eventdata)
handles = guidata(hObject);

switch eventdata.Source.Tag
    case 'pushbutton_TestAudio'
        content = handles.test_son;
        msg     = 77;
    case 'pushbutton_Posture'
        content = handles.posture;
        msg     = 11;
    case 'pushbutton_Rest'
        content = handles.repos;
        msg     = 12;
    otherwise
        error('???')
end

PsychPortAudio('FillBuffer', handles.Playback_pahandle, content);
PsychPortAudio('Start'     , handles.Playback_pahandle, [], [], 1);
% PsychPortAudio('Start'     , handles.Playback_pahandle);
WriteParPort(msg);
WaitSecs(0.005);
WriteParPort(0);

guidata(hObject, handles);
end % function

% -------------------------------------------------------------------------
function uipanel_AudioOnOff_SelectionChangeFcn(hObject, eventdata)
handles = guidata(hObject);

switch eventdata.NewValue.Tag
    case 'radiobutton_Audio_On'
        
        try
            
            % Perform basic initialization of the sound driver
            InitializePsychSound(1);
            
            % Close the audio device
            PsychPortAudio('Close')
            
            % Sampling frequency of the output
            freq = 44100;
            
            % Playback device initialization
            handles.Playback_pahandle = PsychPortAudio('Open', [],...
                1,...     % 1 = playback, 2 = record
                1,...     % {0,1,2,3,4}
                freq,...  % Hz
                2);       % 1 = mono, 2 = stereo
            
            task_code_dir = fileparts(which(mfilename));
            
            for sound = {'test_son','posture','repos'}
                
                % Load
                [content,fs] = audioread( fullfile(task_code_dir,'wav', [char(sound) '.wav']) );
                N = length(content);
                
                % Normalize to -1 +1
                content = content / max(abs(content));
                
                % Resample @ output frequency
                content = interp1( (1:N)/fs, content, (1:N/fs*freq)/freq, 'pchip' );
                
                % Save
                handles.(char(sound)) = [content(:) content(:)]' ; % Need 1 line per channel
                
            end
            
        catch err
            rethrow(err)
        end
        
        handles.pushbutton_TestAudio.Visible = 'On';
        handles.pushbutton_Posture.  Visible = 'On';
        handles.pushbutton_Rest.     Visible = 'On';
        
    case 'radiobutton_Audio_Off'
        
        % Close the audio device
        PsychPortAudio('Close')
        handles = rmfield(handles, 'Playback_pahandle');
        fprintf('Closed all audio devices \n');
        
        handles.pushbutton_TestAudio.Visible = 'Off';
        handles.pushbutton_Posture.  Visible = 'Off';
        handles.pushbutton_Rest.     Visible = 'Off';
        
end

guidata(hObject, handles);
end % function

% -------------------------------------------------------------------------
function uipanel_ParPortOnOff_SelectionChangeFcn(hObject, eventdata)
handles = guidata(hObject);

switch eventdata.NewValue.Tag
    case 'radiobutton_ParPort_On'
        
        % Open or rollback
        try
            OpenParPort();
            WriteParPort(0);
        catch err
            rethrow(err)
        end
        
        handles.pushbutton_TestParPort.Visible = 'On';
        
    case 'radiobutton_ParPort_Off'
        
        CloseParPort();
        handles.pushbutton_TestParPort.Visible = 'Off';
        
end

guidata(hObject, handles);
end % function

% -------------------------------------------------------------------------
function edit_GenerateFname_Callback(hObject, eventdata)
handles = guidata(hObject);

subjectID = handles.edit_subjectID.String; % fetch the field in the GUI
sessionID = handles.edit_sessionID.String; % fetch the field in the GUI

timestamp = datestr(now, 30); % it looks like "20200625T184209"

data_dir = fullfile( fileparts(fileparts(mfilename('fullpath'))), 'data' );

% Generate & save fname
fname = [ timestamp '__' subjectID '__' sessionID ]; % generate
fpath = fullfile(data_dir,fname);
handles.fname = fname;                                 % save it in the GUI main variable
handles.text_fnameD.String = fname;                    % show it in the GUI

fprintf('files will be written with this name : %s \n', fname)

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
        set(handles.toggle_Stream   ,'Visible','On')
        set(handles.pushbutton_Start,'Visible','On')
        set(handles.pushbutton_Stop ,'Visible','On')
        
    case 0
        
        % Switch off streaming if needed
        set(handles.toggle_Stream,'Value',0);
        toggle_Stream_Callback(handles.toggle_Stream, eventdata)
        
        % Close all open socket connections
        pnet('closeall');
        
        % Display a message
        fprintf('connection closed \n\n\n');
        
        set(hObject,'BackgroundColor',handles.buttonBGcolor)
        set(handles.toggle_Stream   ,'Visible','Off')
        set(handles.pushbutton_Start,'Visible','Off')
        set(handles.pushbutton_Stop ,'Visible','Off')
        
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
global ratio_power
global onset

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
                
                % print marker info to MATLAB console
                if datahdr.markerCount > 0
                    for m = 1:datahdr.markerCount
                        disp(markers(m));
                    end
                end
                
                % Process EEG data,
                % in this case extract last recorded second,
                newACC = reshape(data, props.channelCount, length(data) / props.channelCount)';
                newACC = newACC(:,[ACC_X_idx ACC_Y_idx ACC_Z_idx]); % save only the EOG channels
                
                % Apply scaling resolution
                newACC(:,1) = newACC(:,1) * props.resolutions(ACC_X_idx);
                newACC(:,2) = newACC(:,2) * props.resolutions(ACC_Y_idx);
                newACC(:,3) = newACC(:,3) * props.resolutions(ACC_Z_idx);
                
                newACC = newACC/1450; % 1450mV = 1g;
                
                % update
                nr_new_points = size(newACC,1);
                rawACC = circshift(rawACC,-nr_new_points,1);
                rawACC(end-nr_new_points+1 : end, : ) = newACC;
                
                % filtACC = ;
                % if get(handles.checkbox_Filter,'Value')
                %     % filtACC = ft_preproc_bandpassfilter( newACC', handles.fs, [1 15],2)';
                %    filtACC = ft_preproc_highpassfilter( filtACC', handles.fs, 1, 4 )';
                % end
                
                %PC = PCA(filtACC);
                %compACC = PC(:,1);
                %compACC = mean(filtACC,2); % or average
                %compACC = sum(filtACC,2);
                
                compACC = sqrt(sum(rawACC.^2,2)); % euclidian norm <=== best
                
                handles.tplot.YData = flipud(compACC);
                % handles.tplot.YData = flipud(filtACC(:,1));
                
                windowACC_X = getWindow(rawACC(:,1),handles.fs,handles.fftWindow);
                windowACC_Y = getWindow(rawACC(:,2),handles.fs,handles.fftWindow);
                windowACC_Z = getWindow(rawACC(:,3),handles.fs,handles.fftWindow);
                [~        ,power_X] = FFT(windowACC_X,handles.fs);
                [~        ,power_Y] = FFT(windowACC_Y,handles.fs);
                [frequency,power_Z] = FFT(windowACC_Z,handles.fs);
                
                %                 windowACC = getWindow(compACC,handles.fs,handles.fftWindow);
                %                 [frequency,power] = FFT(windowACC,handles.fs);
                
                power =  mean([power_X(:) power_Y(:) power_Z(:)],2);
                handles.fplot.YData = power;
                
                [~,idx_04hz] = min(abs(frequency-04));
                [~,idx_06hz] = min(abs(frequency-06));
                [~,idx_30hz] = min(abs(frequency-30));
                
                % newratio = sum(power(idx_04hz:idx_06hz)) / (sum(power(1:idx_04hz-1)) + sum(power(idx_06hz+1:idx_30hz)));
                newratio = sum(power(idx_04hz:idx_06hz)) / sum(power(1:idx_30hz));
                ratio_power = circshift(ratio_power,-nr_new_points,1);
                ratio_power(end-nr_new_points+1 : end, : ) = repmat(newratio,[nr_new_points 1]);
                handles.pplot.YData = flipud(ratio_power);
                
            case 3       % Stop message
                disp('Stop');
                data = pnet(handles.con, 'read', hdr.size - header_size);
                finish = true;
                
            otherwise    % ignore all unknown types, but read the package from buffer
                data = pnet(handles.con, 'read', hdr.size - header_size);
        end
        
        tryheader = pnet(handles.con, 'read', header_size, 'byte', 'network', 'view', 'noblock');
        stop = ~get(handles.toggle_Stream,'Value') || ~get(handles.toggle_Connection,'Value') ;
        
    end % while
    
    %----------------------------------------------------------------------
    % Button press
    [keyIsDown, secs, keyCode] = KbCheck();
    if keyIsDown && (secs-onset)>2
        if     keyCode(handles.Keybinds.Posture)
            eventdata.Source.Tag = 'pushbutton_Posture';
            pushbutton_SendAudio_Callback(handles.pushbutton_Posture, eventdata);
            onset = secs;
        elseif keyCode(handles.Keybinds.Rest)
            eventdata.Source.Tag = 'pushbutton_Rest';
            pushbutton_SendAudio_Callback(handles.pushbutton_Rest, eventdata);
            onset = secs;
        else
            % pass
        end
    end
    %----------------------------------------------------------------------
    
catch err
    
    err.getReport
    
end

end % function
