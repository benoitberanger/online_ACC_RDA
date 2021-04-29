function createGUI( self )

rng('default')
rng('shuffle')

ft_defaults

% Create a figure
figHandle = figure( ...
    'HandleVisibility', 'off'                    ,... % close all does not close the figure
    'MenuBar'         , 'figure'                 , ...
    'Toolbar'         , 'figure'                 , ...
    'Name'            , self.GUIname             , ...
    'NumberTitle'     , 'off'                    , ...
    'Units'           , 'Normalized'             , ...
    'Position'        , [0.01, 0.01, 0.98, 0.88] , ...
    'Tag'             , self.GUIname             );

% Create GUI handles : pointers to access the graphic objects
handles      = guihandles(figHandle);
handles.self = self;

handles.figureBGcolor = [0.9 0.9 0.9]; set(figHandle,'Color',handles.figureBGcolor);
handles.buttonBGcolor = handles.figureBGcolor - 0.1;
handles.editBGcolor   = [1.0 1.0 1.0];


%% ====================================================================
%% Graphic objects
%% ====================================================================


%% Panels

panel_x_ratio = 0.2;

P_setup.x = 0;
P_setup.w =   panel_x_ratio;
P_setup.y = 0.60;
P_setup.h = 0.40;
handles.uipanel_Setup = uipanel(handles.(self.GUIname),...
    'Title','Setup',...
    'Units', 'Normalized',...
    'Position',[P_setup.x P_setup.y P_setup.w P_setup.h],...
    'BackgroundColor',handles.figureBGcolor );

P_tiepie.x = 0;
P_tiepie.w =  panel_x_ratio;
P_tiepie.y = 0.40;
P_tiepie.h = 0.20;
handles.uipanel_TiePie = uipanel(handles.(self.GUIname),...
    'Title','TiePie',...
    'Units', 'Normalized',...
    'Position',[P_tiepie.x P_tiepie.y P_tiepie.w P_tiepie.h],...
    'BackgroundColor',handles.figureBGcolor );

P_audio.x = 0;
P_audio.w =   panel_x_ratio;
P_audio.y = 0;
P_audio.h = 0.40;
handles.uipanel_Audio = uipanel(handles.(self.GUIname),...
    'Title','Audio',...
    'Units', 'Normalized',...
    'Position',[P_audio.x P_audio.y P_audio.w P_audio.h],...
    'BackgroundColor',handles.figureBGcolor );

P_graph.x =   panel_x_ratio;
P_graph.w = 1-panel_x_ratio;
P_graph.y = 0;
P_graph.h = 1;
handles.uipanel_Graph = uipanel(handles.(self.GUIname),...
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
    'HorizontalAlignment','Left');

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


%% Panel : TiePie

% TiePie (x) Off ( ) On
%
% acq_time_tiepie
% [             ]

P_tiepie = Object_pos_width_dispatcher(...
    [1 2 1 2],...
    P_tiepie);

% Empty space
P_tiepie.count = P_tiepie.count+1;

% EDIT : acq_time_tiepie
P_tiepie.count = P_tiepie.count+1;
E_acq_time_tiepie.x = obj_x_offcet;
E_acq_time_tiepie.w = obj_x_width;
E_acq_time_tiepie.y = P_tiepie.pos  (P_tiepie.count);
E_acq_time_tiepie.h = P_tiepie.width(P_tiepie.count);
E_acq_time_tiepie.tag = 'edit_acq_time_tipe';
handles.(E_acq_time_tiepie.tag) = uicontrol( handles.uipanel_TiePie,...
    'Style','edit',...
    'Units', 'Normalized',...
    'Position',[E_acq_time_tiepie.x E_acq_time_tiepie.y E_acq_time_tiepie.w E_acq_time_tiepie.h],...
    'String',num2str(self.acq_time_tiepie),...
    'BackgroundColor',handles.editBGcolor,...
    'Visible','Off',...
    'HorizontalAlignment','Left',...
    'Callback',@edit_acq_time_tipe_Callback);

% TEXT acq_time_tiepie
P_tiepie.count = P_tiepie.count+1;
T_acq_time_tiepie.x = obj_x_offcet;
T_acq_time_tiepie.w = obj_x_width;
T_acq_time_tiepie.y = P_tiepie.pos  (P_tiepie.count);
T_acq_time_tiepie.h = P_tiepie.width(P_tiepie.count);
T_acq_time_tiepie.tag = 'text_acq_time_tipe';
handles.(T_acq_time_tiepie.tag) = uicontrol( handles.uipanel_TiePie,...
    'Style','text',...
    'Units', 'Normalized',...
    'Position',[T_acq_time_tiepie.x T_acq_time_tiepie.y T_acq_time_tiepie.w T_acq_time_tiepie.h],...
    'String','acq_time_tiepie (s) :',...
    'BackgroundColor',handles.figureBGcolor,...
    'Visible','Off',...
    'HorizontalAlignment','Left');

% ButtunGroup : TiePie On/Off
P_tiepie.count = P_tiepie.count+1;
p_tof.x = obj_x_offcet;
p_tof.w = obj_x_width;
p_tof.y = P_tiepie.pos  (P_tiepie.count);
p_tof.h = P_tiepie.width(P_tiepie.count);
handles.uipanel_TiePieOnOff = uibuttongroup( handles.uipanel_TiePie, ...
    'Title','TiePie : On / Off',...
    'Units', 'Normalized',...
    'Position',[p_tof.x p_tof.y p_tof.w p_tof.h],...
    'BackgroundColor',handles.figureBGcolor,...
    'SelectionChangeFcn',@uipanel_TiePieOnOff_SelectionChangeFcn);

% TiePie : On Off buttons
handles.radiobutton_TiePie_Off = uicontrol( handles.uipanel_TiePieOnOff,...
    'Style','radiobutton',...
    'Units', 'Normalized',...
    'Position',[obj_x_offcet*2, 0.1, obj_x_width/2 - obj_x_offcet, 0.8],...
    'String','Off',...
    'HorizontalAlignment','Center',...
    'Tag','radiobutton_TiePie_Off',...
    'BackgroundColor',handles.figureBGcolor);
handles.radiobutton_TiePie_On = uicontrol( handles.uipanel_TiePieOnOff,...
    'Style','radiobutton',...
    'Units', 'Normalized',...
    'Position',[obj_x_offcet + obj_x_width/2 + obj_x_offcet, 0.1, obj_x_width/2 - obj_x_offcet, 0.8],...
    'String','On',...
    'HorizontalAlignment','Center',...
    'Tag','radiobutton_TiePie_On',...
    'BackgroundColor',handles.figureBGcolor);


%% Panel : Audio

% Audio (x)Off  ( )On      ParPort (x)Off  ( )On
%
% [] TestAudio         [] [] TestParPort      []
%
% [] Posture                                  []
%
% [] Rest                                     []


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
%
% | comments               |
%  ________________________
% |aplitude                |
% |                        |
% |________________________|
%  ________________________
% |power                   |
% |                        |
% |________________________|


P_graph = Object_pos_width_dispatcher(...
    [ 1 6  1 6  2 1 ],...
    P_graph );

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

% Text : comments
P_graph.count = P_graph.count+1;
E_comments.x = obj_x_offcet;
E_comments.w = obj_x_width;
E_comments.y = P_graph.pos  (P_graph.count);
E_comments.h = P_graph.width(P_graph.count);
E_comments.tag = 'edit_comments';
handles.(E_comments.tag) = uicontrol( handles.uipanel_Graph,...
    'Style','edit',...
    'Units', 'Normalized',...
    'Position',[E_comments.x E_comments.y E_comments.w E_comments.h],...
    'String','',...
    'TooltipString','insert comments here',...
    'BackgroundColor',handles.editBGcolor,...
    'Visible','On',...
    'Max', Inf,... % unlimited number of lines
    'HorizontalAlignment','Left');

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
    'String','Start new file',...
    'Visible','Off',...
    'Callback',@pushbutton_Start_Callback);

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
    'String','Stop new file',...
    'Visible','Off',...
    'Callback',@pushbutton_Stop_Callback);


%% Setup graph

% timeDomain
timeDomain.X = 1/self.fsBVA:1/self.fsBVA:self.displaySize;
timeDomain.Y = zeros(length(timeDomain.X),2);
handles.tplot = plot(handles.axes_timeDomain, timeDomain.X, timeDomain.Y);
handles.axes_timeDomain.XLabel.String = 'time (s)';
handles.axes_timeDomain.YLabel.String = 'Acceleration (g)';
handles.axes_timeDomain.YLim = [0 5];
legend(handles.axes_timeDomain,{'L'; 'R'})

% powerDomain
powerDomain.X = timeDomain.X;
powerDomain.Y = timeDomain.Y;
handles.pplot = plot(handles.axes_powerDomain, powerDomain.X, powerDomain.Y);
handles.axes_powerDomain.XLabel.String = 'time (s)';
handles.axes_powerDomain.YLabel.String = 'power[4-6]Hz ratio';
handles.axes_powerDomain.YLim = [0 0.5];
legend(handles.axes_powerDomain,{'L'; 'R'})


%% Set keys

KbName('UnifyKeyNames');
handles.Keybinds.MRI     = KbName('t');
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
if self.debug
    assignin('base','handles',handles)
    disp(handles)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


self.figH    = figHandle; % save figure pointer
self.GUIdata = handles;   % save guidata


end % function

%% ====================================================================
%% GUI Functions
%% ====================================================================

%**************************************************************************
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

%**************************************************************************
function pushbutton_SendAudio_Callback(hObject, eventdata)
handles = guidata(hObject);

switch eventdata.Source.Tag
    case 'pushbutton_TestAudio'
        name = 'test_son';
    case 'pushbutton_Posture'
        name = 'posture';
    case 'pushbutton_Rest'
        name = 'repos';
    otherwise
        error('???')
end
handles.self.SendAudio(name);

guidata(hObject, handles);
end % function

%**************************************************************************
function uipanel_TiePieOnOff_SelectionChangeFcn(hObject, eventdata)
handles = guidata(hObject);

switch eventdata.NewValue.Tag
    case 'radiobutton_TiePie_On'
        
        try
            handles.self.OpenTiePie();
            handles.edit_acq_time_tipe.Visible = 'On';
            handles.text_acq_time_tipe.Visible = 'On';
        catch err
            hObject.SelectedObject = handles.radiobutton_TiePie_Off;
            rethrow(err);
        end
        
    case 'radiobutton_TiePie_Off'
        
        handles.self.CloseTiePie();
        handles.edit_acq_time_tipe.Visible = 'Off';
        handles.text_acq_time_tipe.Visible = 'Off';
        
end

guidata(hObject, handles);
end % function

%**************************************************************************
function uipanel_AudioOnOff_SelectionChangeFcn(hObject, eventdata)
handles = guidata(hObject);

switch eventdata.NewValue.Tag
    case 'radiobutton_Audio_On'
        
        handles.self.OpenAudio();
        
        handles.pushbutton_TestAudio.Visible = 'On';
        handles.pushbutton_Posture.  Visible = 'On';
        handles.pushbutton_Rest.     Visible = 'On';
        
    case 'radiobutton_Audio_Off'
        
        handles.self.CloseAudio();
        
        handles.pushbutton_TestAudio.Visible = 'Off';
        handles.pushbutton_Posture.  Visible = 'Off';
        handles.pushbutton_Rest.     Visible = 'Off';
        
end

guidata(hObject, handles);
end % function

%**************************************************************************
function uipanel_ParPortOnOff_SelectionChangeFcn(hObject, eventdata)
handles = guidata(hObject);

switch eventdata.NewValue.Tag
    case 'radiobutton_ParPort_On'
        handles.self.OpenParPort();
        handles.pushbutton_TestParPort.Visible = 'On';
    case 'radiobutton_ParPort_Off'
        handles.self.CloseParPort();
        handles.pushbutton_TestParPort.Visible = 'Off';
end

guidata(hObject, handles);
end % function

%**************************************************************************
function pushbutton_TestParPort_Callback(hObject, eventdata)
handles = guidata(hObject);

handles.self.TestParPort();

guidata(hObject, handles);
end % function

%**************************************************************************
function edit_acq_time_tipe_Callback(hObject, eventdata) %#ok<*INUSD>
handles = guidata(hObject);

acq_time_tiepie = str2double( get(hObject,'String') );

handles.self.acq_time_tiepie = acq_time_tiepie;
fprintf('[neuromod GUI] : new acq_time_tiepie = %g (s)\n', acq_time_tiepie)

guidata(hObject, handles);
end % function

%**************************************************************************
function edit_Adress_Callback(hObject, eventdata) %#ok<*INUSD>
handles = guidata(hObject);

adress = get(hObject,'String');

try
    handles.self.ip = adress;
catch err
    set(hObject,'String',handles.self.ip);
    rethrow(err)
end

guidata(hObject, handles);
end % function


%**************************************************************************
function toggle_Connection_Callback(hObject, eventdata)
handles = guidata(hObject);

switch get(hObject,'Value')
    
    case 1
        
        try
            handles.self.RDAconnect();
        catch err
            set(hObject,'Value',0)
            rethrow(err)
        end
        
        set(hObject,'BackgroundColor',[0.5 0.5 1])
        set(handles.toggle_Stream ,'Visible','On')
        
    case 0
        
        handles.self.stopStream();
        handles.self.RDAdisconnect();
        
        % Switch off streaming if needed
        set(handles.toggle_Stream,'Value',0);
        toggle_Stream_Callback(handles.toggle_Stream, eventdata)
        
        set(hObject,'BackgroundColor',handles.buttonBGcolor)
        set(handles.toggle_Stream ,'Visible','Off')
        
end

guidata(hObject, handles);
end % function

%**************************************************************************
function toggle_Stream_Callback(hObject, eventdata)
handles = guidata(hObject);

switch get(hObject,'Value')
    
    case 1
        
        handles.self.startStream();
        
        set(hObject,'BackgroundColor',[0.5 0.5 1])
        set(handles.pushbutton_Start,'Visible','On')
        set(handles.pushbutton_Stop ,'Visible','On')
        
    case 0
        
        handles.self.stopStream();
        
        set(hObject,'BackgroundColor',handles.buttonBGcolor)
        
end

guidata(hObject, handles);
end % function

%**************************************************************************
function pushbutton_Start_Callback(hObject, eventdata)
handles = guidata(hObject);

subjectID = handles.self.GUIdata.edit_subjectID.String; % fetch the field in the GUI
sessionID = handles.self.GUIdata.edit_sessionID.String; % fetch the field in the GUI

handles.self.startNewFile(subjectID, sessionID);

handles.text_fnameD.String = handles.self.fname;   % show it in the GUI

guidata(hObject, handles);
end % function

%**************************************************************************
function pushbutton_Stop_Callback(hObject, eventdata)
handles = guidata(hObject);

handles.self.stopNewFile();
set(handles.toggle_Stream,'BackgroundColor',handles.buttonBGcolor)
set(handles.toggle_Stream,'Value',0)

guidata(hObject, handles);
end % function
