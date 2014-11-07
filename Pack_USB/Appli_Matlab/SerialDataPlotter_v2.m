function simple_gui2
clear all;
close all;
h=figure;
%% bug : update com ne marche pas : qd l'appli tourne, elle ne voit pas quand 
% un nouveau COM arrive ou est quitté. A creuser




% bug réduction de fenêtre, mélange pourcentage / absolu



% pousser graphe vers dte à cause des valeurs axes verti


% Flag à regrouper dans la structure Flag (y en a un à faire (passge ds la
% COM)





%% Les variables partagées, fonctions associées
%
%% partie purement COM
% Var Globale: Tab_COM est un tableau qui contient les informations sur l'accessibilité
% de chaque port série énuméré de 1 à 20.
%     Tab_COM(i).Name = 'COMi'
%     Tab_COM(i).Available = 0 ou 1 selon qu'il est disponible ou pas.
%     Tab_COM(i).Liste_str : liste des COM valables
%
% Fct : Update_Avalable_COM
% Remplit Tab_COM à partir des ressources réellement disponibles


%% PartieSetUp_COM
% Var Globale: COM est la variable qui contient toute les spécifications
% du port utilisé
% COM.Name : Nom de la COM utilisée
% COM.Debit: Valeur en Baud
% COM.NbBitsStop : Nbre de bits de stop
% COM.TimeOut : temps d'attente maxi des données après appui sur load
% COM.ValuesNb : nbre de données au format demandé à télécharger

       

%% Format des données
% Var Globale: Data_Format est une structure qui contient les informations clé
% qui renseignent sur le format des données à traiter :
%   Data_Format.IntPart : Nbre bit partie entière
%   Data_Format.FractPart : Nbre bit partie fractionnaire
% 	Data_Format.Intervalle_Str : Intervalle des valeurs correspondant 
%   au format fractionnaire actuel, sous forme d'une chaine de caractères
%	Data_Format.Quantum_Str : Le quantum sous format string
%   Data_Format.Type_Str : 'u8' ou 's32'...
%   Data_Format.Fread_Type_Str : 'u8' ou 's32'... idem mais syntaxe diff
%   pour MATLAB, fonction fread
%   Data_Format.Fract_Str : '1.7' ou 1.15'..
%
% Fct : Caclul_Format(Data_Type_String,Fract_String)
% Mets à jour la structure Data_Format à partir de deux string, le type
% et le format fractionnaire

%% Donnees téléchargées
% Tab_DataRecues : tableau de valeurs
%    DataRecues.Byte_Vect : vecteur valeurs dans le format de tél byte
%    DataRecues.Byte_Vect_Str : idem en str dans le format de tél byte
%    DataRecues.Val_Vect : vecteur dans le format fractionnaire
%    DataRecues.Val_Vect_Str : idem en str dans le format spécifié
%    DataRecues.Val_Nb : Nombre de valeur calculée en fct du format ;
%%
%************************************************************************
%
%   CODE DE DEMARRAGE
%
%************************************************************************




% Vocabulaire
% Byte => octet, pas d'ambiguité...
% Val => Valeur au format fractionnaire (u16, s32 en 1.31...)

Max.Val_Nb=1024;
Max.Byte_Nb=1024; % réglage à priori, il sera recalculé en fct du format 
% donc potentiellement augmenté à Max.Val_Nb*8

% initialisation des données reçues
DataRecues.Byte_Vect=[0];
DataRecues.Byte_Vect_Str{1} ='0';
DataRecues.Val_Vect=[0];
DataRecues.Val_Vect_Str{1} ='0';
DataRecues.Val_FFT_Vect=[0];
DataRecues.Byte_Nb=1;
DataRecues.Val_Nb=1;
DataRecues.FFT_Val_Nb=0;


%initialisation des 3 variables structure globales
for Indice_COM = 1:20
    Tab_COM(Indice_COM).Name=['COM' num2str(Indice_COM)];
    Tab_COM(Indice_COM).Available=1; % tous actif par défaut
end

Flag.Hex=1;
Flag.Time='Time';
Flag.Dot=0;
Flag.COM_OK=0;


Update_Port; 

if (Flag.COM_OK==0)
    Tab_COM(1).Liste{1}='No COM';
end

COM.Name=Tab_COM(1).Liste{1};
COM.Debit= 1200;
COM.NbBitsStop =1;
COM.TimeOut=1;
COM.ValuesNb=1;


Data_Format.IntPart = 0;
Data_Format.FractPart =0;
Data_Format.Intervalle_Str ='_';
Data_Format.Quantum_Str ='1';
Data_Format.Type_Str='u8';
Data_Format.Signed=0;
Data_Format.Nb_Byte_Per_Value=1;
Calcul_Format('u8','8.0');



%% Variables partagées

	% 		- Type_Data_String (extraits des saisies user)
	% 		- Fract_String (extraits des saisies user)
	% 
	%		- IntPart : valeur de la partie entière
	% 		- FractPart : valeur de la partie fractionnaire
	% 		- LimBasse, LimHaute : valeurs extrêmes des valeurs

    
%s = serial('COM1', 'Baudrate', 9600, 'Databits',8,'StopBits',1);    
%Data_Number=1;

Flag_Com_Set_up=0;

%%
%************************************************************************
%
%   CREATION FENËTRE PRINCIPALE
%
%************************************************************************


% ____Main figure_________________________________________________________
 
   %  Create and then hide the GUI as it is being constructed.
   Main_Fig = figure('Visible','off','Position',[20,100,1200,600]);
%__________________________________________________________________________   
   
   
% ____Panel Com Port & Data settings_______________________________________
    % Panel
    Main_Fig_Panel_COM_Format = uipanel('Parent',Main_Fig,'background',...
       [0.8 0.8 0.8],'Title','   Com Port & Data Setings ',...
       'Position',[.02 .87 .30 0.12]); % postion = [left, bottom, width, height]

   %  BOUTON de conf COM   
   Main_Fig_ConfLiaisonButton = uicontrol(Main_Fig,'Style','pushbutton',...
           'String','COM Port Setup','Position',[50,540,100,25],...
           'Callback',{@Main_Callback_ConfLiaisonButton});     

   %  BOUTON de conf Data Format 
   Main_Fig_DataFormatButton = uicontrol(Main_Fig,'Style','pushbutton',...
           'String','Data Format Setup','Position',[200,540,150,25],...
           'Callback',{@Main_Callback_DataFormatButton}); 
   
%__________________________________________________________________________   
       

% ____Zone chargement______________________________________________________
   % BOUTON de chargement
   Main_Fig_LoadButton = uicontrol(Main_Fig,'Style','pushbutton','String','Load',...
           'Position',[400,530,70,25],...
           'Callback',{@Main_Callback_LoadButton});  

   % Saisie nombre de points à télécharger    
   uicontrol(Main_Fig,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Data Number','HorizontalAlignment','left', ...
          'Position',[400,560,70,25]); 
   Main_Fig_Edit_Data_Number =   uicontrol(Main_Fig,'Style','edit','String',...
           num2str(COM.ValuesNb),'Position',[500,565,50,25],...
           'Callback',{@Main_Callback_Edit_Data_Number});  
%__________________________________________________________________________   

% ____Panel Data Format____________________________________________________
    % Panel
    Main_Fig_Panel_Data_Format = uipanel('Parent',Main_Fig,...
            'background',[0.8 0.8 0.8],'Title','   Data Format ',...
            'Position',[.5 .87 .45 0.12]); 
        
    % Affichage format fract, 8.1, 1.15...
    uicontrol(Main_Fig_Panel_Data_Format,'background',[0.8 0.8 0.8],...
            'Style','text','String','Fractional :',...
            'HorizontalAlignment','left','Position',[10,20,70,17]); 
    Main_Fig_Text_Fract = uicontrol(Main_Fig_Panel_Data_Format,...
            'background',[0.8 0.8 0.8],'Style','text','String',...
             [num2str(Data_Format.IntPart) '.' num2str(Data_Format.FractPart)],...
             'Position',[70,20,50,17]); 
         
    % Affichage de l'intervalle de valeurs décimales correspondant 
    uicontrol(Main_Fig_Panel_Data_Format,'background',[0.8 0.8 0.8],...
            'Style','text','String','Limits :','HorizontalAlignment','left', ...
            'Position',[180,20,50,17]); 	  
    Main_Fig_LimitDisplay = uicontrol(Main_Fig_Panel_Data_Format,...
            'background',[0.8 0.8 0.8],'Style','text',...
            'String',Data_Format.Intervalle_Str,'HorizontalAlignment','left', ...
            'Position',[230,20,200,17]);
        
	% Affichage du quantum	  
    uicontrol(Main_Fig_Panel_Data_Format,'background',[0.8 0.8 0.8],...
            'Style','text','String','Quantum :',...
            'HorizontalAlignment','left','Position',[420,20,50,17]); 
    Main_Fig_QuantumDisplay = uicontrol(Main_Fig_Panel_Data_Format,...
            'background',[0.8 0.8 0.8],'Style','text',...
          'String',Data_Format.Quantum_Str,'Position',[480,20,50,17]);
%__________________________________________________________________________  
 
      
% ____Panel Graphic View___________________________________________________      
   Main_Fig_Panel_Graph = uipanel('Parent',Main_Fig,...
            'background',[0.8 0.8 0.8],'Title','   Graphic View ',...
            'Position',[.02 .02 0.63 0.82]);    
        
   Main_Fig_Axes      =   axes(...         % the axes for plotting selected plot
                        'Parent', Main_Fig, ...
                        'Units', 'normalized', ...
                        'HandleVisibility','callback', ...
                        'Position',[0.05 0.06 0.55 0.63]);
   % BOUTON Time / Freq 
   Main_Fig_SwitchTime_FreqButton = uicontrol(Main_Fig,'Style','pushbutton','String','Switch Time / Frequence',...
           'Position',[100,440,150,25],...
           'Callback',{@Main_Callback_SwitchTime_FreqButton}); 
       
   % Affichage Time/freq    
   Main_Fig_Time_Text=uicontrol(Main_Fig,'background',[0.8 0.8 0.8],...
            'Style','text','String',Flag.Time,...
            'HorizontalAlignment','left','Position',[280,441,100,17]);
   % Affichage nb valeur pour la FFT
   uicontrol(Main_Fig,'background',[0.8 0.8 0.8],...
            'Style','text','String','Data Number used for FFT  :',...
            'HorizontalAlignment','left','Position',[380,441,150,17]);   
   Main_Fig_FFT_Val_NB=uicontrol(Main_Fig,'background',[0.8 0.8 0.8],...
            'Style','text','String',DataRecues.FFT_Val_Nb,...
            'HorizontalAlignment','left','Position',[540,441,100,17]);
        
   % Bouton radio pour affichage dot/line
   uicontrol(Main_Fig,'background',[0.8 0.8 0.8],...
            'Style','text','String','Dot Display :',...
            'HorizontalAlignment','left','Position',[600,441,100,17]);
   Main_Fig_Graphic_Rad_Button=uicontrol(Main_Fig,'background',[0.8 0.8 0.8],...
            'Style','radiobutton','Value',0,...
            'HorizontalAlignment','left','Position',[680,441,10,17],...
            'Callback',{@Main_Callback_Graphic_Rad_Button});     
    
        
%__________________________________________________________________________  


% ____Memory View__________________________________________________________
   Main_Fig_Panel_Mem = uipanel('Parent',Main_Fig,'background',[0.8 0.8 0.8],...
            'Title','   Memory View ','Position',[.7 .02 0.25 0.82]); 
    Init_Val=[45;45;56;78];  
    Init_Val = dec2hex(Init_Val);
    Main_Fig_Memory_Display=  uicontrol('Parent',Main_Fig,'background',[1 1 1],'Style','listbox ',...
          'String',Init_Val, ...
          'Position',[900,80,200,390]);
   %  BOUTON choix 
   Main_Fig_SwitchFormatButton = uicontrol(Main_Fig,'Style','pushbutton',...
           'String','Switch Hexa / fractional','Position',[902,35,180,25],...
           'Callback',{@Main_Callback_SwitchFormatButton});  
%__________________________________________________________________________  
 



   % Make the GUI visible.
   set(Main_Fig,'Visible','on');
   
%************************************************************************

%%
%************************************************************************
%
%   CREATION FENËTRE COM PORT SETUP
%
%************************************************************************

% ____Main figure_________________________________________________________
 
   %  Create and then hide the GUI as it is being constructed.
    COM_Fig = figure('Visible','off','Position',[360,400,450,285]);
    set(COM_Fig,'CloseRequestFcn',@COM_Callback_Closefcn);
%__________________________________________________________________________   
   
   
% ____Panel Com Port setup ________________________________________________

    COM_Fig_Panel = uipanel('Parent',COM_Fig,'background',[0.8 0.8 0.8],'Title','Com Port Setup',...
             'Position',[.02 .02 .96 .96]);
         
    % Select COM port
    uicontrol(COM_Fig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Select Com Port',...
          'Position',[5,210,100,20]);

    COM_Name = uicontrol(COM_Fig_Panel,'Style','listbox',...
          'String',Tab_COM(1).Liste,...
          'Position',[10,60,200,150]);
      
    % Bouton Update Available Port
    COM_Update_Port_Button = uicontrol(COM_Fig_Panel,'Style','pushbutton','String','Update Available Port',...
           'Position',[30,20,150,25],...
           'Callback',{@COM_Callback_Update_Port_Button});
      
    % Baud   
    uicontrol(COM_Fig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Baud','HorizontalAlignment','left', ...
          'Position',[270,187,60,20]);
    COM_Debit = uicontrol(COM_Fig_Panel,'Style','popupmenu',...
          'String',{'1200','2400','4800','9600','19200','38400','57600','115200','230400'},...
          'Position',[350,190,70,20]);
      
    % Stops bit    
    uicontrol(COM_Fig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Stop Bits','HorizontalAlignment','left',...
          'Position',[270,157,60,20]); 
    COM_NbBitsStop = uicontrol(COM_Fig_Panel,'Style','popupmenu',...
          'String',{'1','2'},...
          'Position',[350,160,70,20]); 
      
    % Time Out  
    uicontrol(COM_Fig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Time Out','HorizontalAlignment','left',...
          'Position',[270,127,60,20]); 
    COM_TimeOut = uicontrol(COM_Fig_Panel,'Style','popupmenu',...
          'String',{'1','5','10','30'},...
          'Position',[350,130,70,20]); 
      
    % Bouton OK
    COM_OK_Button = uicontrol(COM_Fig_Panel,'Style','pushbutton','String','OK',...
           'Position',[250,20,70,25],...
           'Callback',{@COM_Callback_OK_Button});
       
    % Bouton Cancel   
    COM_Cancel_Button = uicontrol(COM_Fig_Panel,'Style','pushbutton','String','Cancel',...
           'Position',[350,20,70,25],...
           'Callback',{@COM_Callback_Cancel_Button});   
      
%%
%************************************************************************
%
%   CREATION FENËTRE CONF DATA
%
%************************************************************************
   
    Format_Fig = figure('Visible','off','Position',[360,400,450,285]);
    set(Format_Fig,'CloseRequestFcn',@Format_Callback_Closefcn);
    
% Définition du panel "Data Format Setup"
    FormatFig_Panel = uipanel('Parent',Format_Fig,'background',[0.8 0.8 0.8],'Title','Data Format Setup',...
             'Position',[.02 .02 .96 .96]);
    uicontrol(FormatFig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Data Format','HorizontalAlignment','left', ...
          'Position',[20,217,60,20]);   
      
    uicontrol(FormatFig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Fractionnal Format E.F','HorizontalAlignment','left', ...
          'Position',[180,217,120,20]); 
      
    uicontrol(FormatFig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Limits :','HorizontalAlignment','left', ...
          'Position',[20,130,120,20]); 	  
    Format_LimitDisplay = uicontrol(FormatFig_Panel,'background',[1 1 1],'Style','text',...
          'String',Data_Format.Intervalle_Str, ...
          'Position',[100,130,250,17]);
		
		  
    uicontrol(FormatFig_Panel,'background',[0.8 0.8 0.8],'Style','text',...
          'String','Quantum :','HorizontalAlignment','left', ...
          'Position',[20,100,120,20]); 
    Format_QuantumDisplay = uicontrol(FormatFig_Panel,'background',[1 1 1],'Style','text',...
          'String',Data_Format.Quantum_Str, ...
          'Position',[100,100,250,17]);  
      
    % MENU choix   
    Format_Data_Format = uicontrol(FormatFig_Panel,'Style','popupmenu',...
          'String',{'u8','s8','u16','s16','u32','s32', 'u64', 's64'},...
          'Position',[20,187,120,20],...
          'Callback',{@Format_Callback_Data_Format_popup}); 
           ListeFraction={'8.0'};
    Format_Fract_Format = uicontrol(FormatFig_Panel,'Style','popupmenu',...
          'String',ListeFraction,...
          'Position',[180,187,120,20],'Callback',{@Format_Callback_Fract_Format_popup}); 
  
      
    % Bouton OK et Cancel
    Format_OK_Button = uicontrol(FormatFig_Panel,'Style','pushbutton','String','OK',...
           'Position',[140,20,70,25],...
           'Callback',{@Format_Callback_OK_Button});
       
    Format_Cancel_Button = uicontrol(FormatFig_Panel,'Style','pushbutton','String','Cancel',...
           'Position',[240,20,70,25],...
           'Callback',{@Format_Callback_Cancel_Button});  
      
      
      
 
   
      
      
      
      
      
      
      
%************************************************************************
%
%   GESTION DES CALLBACK
%
%************************************************************************


   %% Les Callback de la fenêtre principale
 
   function Main_Callback_SwitchTime_FreqButton(source,eventdata)
        if (strcmp(Flag.Time,'Frequence'))
            Time_Display();
            Flag.Time='Time';
        else
            Freq_Display();
            Flag.Time='Frequence';
        end    
   end
 
   function Main_Callback_LoadButton(source,eventdata) 
   if (Flag_Com_Set_up==0)
      msgbox('Fix COM settings first','warn','modal')
   else
             
       % création du port série
      s = serial(COM.Name, 'Baudrate', COM.Debit, 'Databits',8,...
      'StopBits',COM.NbBitsStop);    
      set(s,'Timeout',COM.TimeOut); 
      N=COM.ValuesNb*Data_Format.Nb_Byte_Per_Value;
      set(s,'InputBufferSize',N);
      State=get(s,'status');
      if (strcmp(State,'closed'))            % ------------------------------------%(State=='closed') 
         fopen(s);   
      end
      
      % Lecture des nbres à n octets se fait en considérant le premier
      % byte reçu comme l'octet de pds faible et ainsi de suite jusqu'à
      % l'octet de poids fort.
      % au préalable on envoie un octet qui prévient le STM d'envoyer
      fwrite(s,'A');
      [DataRecues.Byte_Vect,count,msg] = fread(s,N,'uchar'); % vect colonne
      if (strcmp(msg,''))
          msgbox('Load OK','warn','modal')
      else
          msgbox('Time Out','warn','modal')
      end
          
      %toto=get(s,'InputBufferSize')
      DataRecues.Byte_Nb = get(s,'valuesreceived');
      % conversion Byte / str 
      Byte_Display;
      Flag.Hex=1;
      fclose(s)
      delete(s)
      clear s
      Fill_Val_Vect();
      Time_Display();      
   end 
   end

   function Main_Callback_ConfLiaisonButton(source,eventdata) 
        Update_Port;
        if (Flag.COM_OK==0)
            Tab_COM(1).Liste{1}='No COM';
        end     
      
       
        set(COM_Fig,'WindowStyle','normal');
        set(COM_Fig,'Visible','on');
   end

   function Main_Callback_DataFormatButton(source,eventdata) 
        set(Format_Fig,'WindowStyle','normal');
        set(Format_Fig,'Visible','on');
   end

   function Main_Callback_Edit_Data_Number(source,eventdata)
        Data_Numb_Str=get(Main_Fig_Edit_Data_Number,'String');
        N=str2num(Data_Numb_Str);
        if((N<1)||(N>1024))
            %msg
            msgbox('Value for Data Number must be from 1 to 1024','warn','modal');
        else
            COM.ValuesNb=N;
            set(Main_Fig_Edit_Data_Number,'String',COM.ValuesNb);
        end
   end  

   function Main_Callback_SwitchFormatButton(source,eventdata)
        if (Flag.Hex==0)
            Byte_Display();
            Flag.Hex=1;
        else
            Fract_Display();
            Flag.Hex=0;
        end  
        
   end 

   function Main_Callback_Graphic_Rad_Button(source,eventdata)
        if (get(Main_Fig_Graphic_Rad_Button,'Value') == 1)
            Flag.Dot=1;
        else
            Flag.Dot=0;
        end
        
   end 

   %% Les Callback de la fenêtre configuration COM

   function COM_Callback_Update_Port_Button(source,eventdata)
       Update_Port;
       if (Flag.COM_OK==0)
            Tab_COM(1).Liste{1}='No COM';
       end
       set(COM_Name,'String',Tab_COM(1).Liste);        
       
   end    
   
   function COM_Callback_OK_Button(source,eventdata) 
        % Store Name
        Val = get(COM_Name,'Value');
        Str=get(COM_Name,'String');
        COM.Name = Str{Val};
        % Store Debit
        Val = get(COM_Debit,'Value');
        Str=get(COM_Debit,'String');
        COM.Debit = str2num(Str{Val});       
        % Store NbStop
        Val = get(COM_NbBitsStop,'Value');
        Str=get(COM_NbBitsStop,'String');
        COM.NbBitsStop = str2num(Str{Val});       
        % Store TimeOut
        Val = get(COM_TimeOut,'Value');
        Str=get(COM_TimeOut,'String');
        COM.TimeOut = str2num(Str{Val});  
        
        % Création de l'objet port
        s = serial(COM.Name, 'Baudrate', COM.Debit,'Timeout',COM.TimeOut,...
            'Databits',8,'StopBits',COM.NbBitsStop);
  
        Flag_Com_Set_up=1;
        set(COM_Fig,'WindowStyle','normal');
        set(COM_Fig,'Visible','off'); 
    end

   function COM_Callback_Cancel_Button(source,eventdata)
       set(COM_Fig,'WindowStyle','normal');
       set(COM_Fig,'Visible','off'); 
    end

   function COM_Callback_Closefcn(source,eventdata)
        COM_Callback_Cancel_Button(); 
   end

	
	
	
%% Les Callback de la fenêtre configuration data
% Data_Type_Str='u8';
% Fract_Str='8.0';
% Data_Format.IntPart = 0;
% Data_Format.FractPart =0;
% Data_Format.Intervalle_Str ='_';
% Data_Format.Quantum_Str ='1';
% Data_Format.Type_Str : 'u8' ou 's32'...
% Data_Format.Fract_Str

% Caclul_Format('u8','8.0');

  function Format_Callback_Data_Format_popup(source,eventdata)
        Val = get(Format_Data_Format,'Value');
        Str=get(Format_Data_Format,'String');
		
        switch Str{Val};
        case 'u8' 
            ListeFraction={'8.0'};
            Data_Format.Nb_Byte_Per_Value=1;
            Data_Format.Signed=0;
        case 's8' 
            ListeFraction={'1.7','2.6','3.5','4.4','5.3','6.2','7.1','8.0'};
            Data_Format.Nb_Byte_Per_Value=1;
            Data_Format.Signed=1;
        case 'u16' 
            ListeFraction={'16.0'};
            Data_Format.Nb_Byte_Per_Value=2;
            Data_Format.Signed=0;
        case 's16' 
            ListeFraction={'1.15','2.14','3.13','4.12','5.11','6.10','7.9',...
               '8.8','9.7','10.6','11.5','12.4','13.3','14.2','15.1','16.0'}; 
            Data_Format.Nb_Byte_Per_Value=2;
            Data_Format.Signed=1;
        case 'u32' 
            ListeFraction={'32.0'}; 
            Data_Format.Nb_Byte_Per_Value=4;
            Data_Format.Signed=0;
        case 's32' 
            ListeFraction={'1.31','2.30','3.29','4.28','5.27','6.26','7.25',...
               '8.24','9.23','10.22','11.21','12.20','13.19','14.18',...
               '15.17','16.16','17.15','18.14','19.13','20.12','21.11',...
               '22.10','23.9','24.8','25.7','26.6','27.5','28.4','29.3',...
               '30.2','31.1','32.0'};
            Data_Format.Nb_Byte_Per_Value=4;
            Data_Format.Signed=1;
        case 'u64' 
            ListeFraction={'64.0'};
            Data_Format.Nb_Byte_Per_Value=8;
            Data_Format.Signed=0;
        case 's64' 
            ListeFraction={'1.63'}; 
            Data_Format.Nb_Byte_Per_Value=8;
            Data_Format.Signed=1;
        case 'float' 
            ListeFraction={''};    
        end
		
		Data_Format.Type_Str=Str{Val};
		
        % on refait le uicontrol car bug d'affichage sinon
        Format_Fract_Format = uicontrol(FormatFig_Panel,'Style','popupmenu',...
          'String',ListeFraction,...
          'Position',[180,187,120,20],'Callback',{@Format_Callback_Fract_Format_popup}); 
       % Erase des champs Limits et Quatum pour que l'utilisateur aille
       % dans l'autre popoup
       Data_Format.Intervalle_Str='_';
       Data_Format.Quantum_Str='_';
       set(Format_LimitDisplay,'String', Data_Format.Intervalle_Str);
       set(Format_QuantumDisplay,'String', Data_Format.Quantum_Str);
       %Calcul du Max byte number
       Max.Val_Nb=1024;
       Max.Byte_Nb=Max.Val_Nb*Data_Format.Nb_Byte_Per_Value;
  end

  function Format_Callback_Fract_Format_popup(source,eventdata)
        Val = get(Format_Data_Format,'Value');
        Str=get(Format_Data_Format,'String');
		Data_Format.Type_Str=Str{Val};
		
		Val = get(Format_Fract_Format,'Value');
        Str=get(Format_Fract_Format,'String');
		Data_Format.Fract_Str=Str{Val};

		Calcul_Format(Data_Format.Type_Str,Data_Format.Fract_Str);
		
        set(Format_LimitDisplay,'String', Data_Format.Intervalle_Str);
        set(Format_QuantumDisplay,'String', Data_Format.Quantum_Str);
       
  end

  function Format_Callback_OK_Button(source,eventdata)

       if (Data_Format.Quantum_Str=='_')
            msgbox('Choose a fractional format.','warn','modal')
       else

           %affichage du format fractionnaire dans la fenêtre principale
            set(Main_Fig_Text_Fract,'String',Data_Format.Type_Str);
          
            set(Format_Fig,'WindowStyle','normal');
            set(Format_Fig,'Visible','off'); 
            %MAJ fenêtre principale
            set(Main_Fig_QuantumDisplay,'String',Data_Format.Quantum_Str);
            set(Main_Fig_LimitDisplay,'String',Data_Format.Intervalle_Str);
            % mise à jour des variables dans le nouveau format
            Fill_Val_Vect();
            Byte_Display();
            Flag.Hex=1;
            Time_Display();
       end
   end

  function Format_Callback_Cancel_Button(source,eventdata)
       
       set(Format_Fig,'WindowStyle','normal');
       set(Format_Fig,'Visible','off'); 
   
  end

  function Format_Callback_Closefcn(source,eventdata)
        Format_Callback_Cancel_Button(); 
  end

	
	

%% Fonctions

	
	function Calcul_Format(Data_Type_String,Fract_String)
     % PARAM ENTREE : Data_Type_String,Fract_String (extraits des saisies user)
	% PARAM SORTIE : 
	%	Data_Format.IntPart 
    % Data_Format.FractPart 
    % Data_Format.Intervalle_Str 
    % Data_Format.Quantum_Str 
        switch Data_Type_String;
        case 'u8'
            Data_Format.Quantum_Str= '1';
            Data_Format.Intervalle_Str= '[0   ; 256 ]' ;
            Data_Format.IntPart = 8;
            Data_Format.FractPart=0;
        case 'u16'
            Data_Format.Quantum_Str= '1';
            Data_Format.Intervalle_Str= '[0   ; 65 536 ]';
            Data_Format.IntPart = 16;
            Data_Format.FractPart=0;
        case 'u32'
            Data_Format.Quantum_Str= '1';
            Data_Format.Intervalle_Str= '[0   ; 4 264 967 296 ]'; 
            Data_Format.IntPart = 32;
            Data_Format.FractPart=0;
        case 'u64'
            Data_Format.Quantum_Str= '1';
            Data_Format.Intervalle_Str= '[0   ; 18.446e18 ]'; 
            Data_Format.IntPart = 64;
            Data_Format.FractPart=0;
        otherwise
            N=str2num(Fract_String);
            IntPart= floor(N);
            FractPart=(N-IntPart)*100; % ex 9.23-9.0 = 0.23 => 23.0 ou 7.1 => 10.0
            FractPart=round(FractPart); % FractPart=23 ou 10

            if (mod(FractPart,10)==0) %cas particulier y.x donne x0. Il faut 
               FractPart=FractPart/10;  % au ça donne x. D'où la recherche du modulo
            end 
                     
            %!! ne marche pas pour : 2.30,12.20, 22.10 et aussi 6.10 
            % En faire des cas particulier :
            switch Fract_String;
                case '2.30'
                     FractPart=30;
                case '12.20'
                     FractPart=20;
                case '22.10'
                     FractPart=10;
                case '6.10'
                     FractPart=10;
            end
 
            % Affectation
            Data_Format.IntPart=IntPart;
            Data_Format.FractPart=FractPart;
            
            LimBasse=-2^(IntPart-1);
            LimHaute = 2^(IntPart-1)-2^(-FractPart);
            LimBasse_str = num2str(LimBasse,10);
            LimHaute_str = num2str(LimHaute,10);
            Data_Format.Quantum_Str= num2str(2^(-FractPart),3);
            Data_Format.Intervalle_Str= ['[ ' LimBasse_str '  ;  +' LimHaute_str '  ]' ];
        end
     
    end
	
    function Update_Port
    % PARAM ENTREE : Aucun
	% PARAM SORTIE : 
	% Tab_COM(i).Name = 'COMi'
    % Tab_COM(i).Available = 0 ou 1 selon qu'il est disponible ou pas. 
    % Exploration de 20 ports COM
    
    for i = 1:20
        s = serial(Tab_COM(i).Name, 'Baudrate', 9600, 'Databits',8,'StopBits',1);
        set(s,'Timeout',1);
        State=get(s,'status');
        if (strcmp(State,'closed'))  %%   ----------------------------------------- if (State=='closed')
            try 
                fopen(s);
                fclose(s);
            catch ME1
                %erreur d'ouverture, forcément
                %ME1.identifier; %regexp !!
                Tab_COM(i).Available=0;
            end
        end
    end
    
    % création de la liste
    j=1;
    for i = 1:20
       if (Tab_COM(i).Available==1)
          Cell_Tab_Str{j}=Tab_COM(i).Name;
          j=j+1; 
       end

    end
    
    if (j==1) % Aucune init faite
         msgbox('No COM detected. Please close the application then connect a COM/USB device before starting the application again','warn','modal')
         Flag.COM_OK=0;
    else
        Tab_COM(1).Liste=Cell_Tab_Str;
        Flag.COM_OK=1;
    end

    
    end    
     
    function  Byte_Display
        
        for i = 1:Max.Byte_Nb
            DataRecues.Byte_Vect_Str{i}=[''];
        end 
        
        for i = 1:DataRecues.Byte_Nb
            N_hex=dec2hex(DataRecues.Byte_Vect(i,1),2);
            i_str=num2str(i,'%05.0f');
            DataRecues.Byte_Vect_Str{i}=[ '@' i_str '   ' '0x' N_hex];
        end 
         % Mise à jour de l'affichage
        set(Main_Fig_Memory_Display,'String',DataRecues.Byte_Vect_Str);    
    end

    function  Fract_Display
        for i = 1:Max.Val_Nb
            DataRecues.Val_Vect_Str{i}=[''];
        end 
        for i=1: DataRecues.Val_Nb
            N_Val=num2str(DataRecues.Val_Vect(i,1));
            i_str=num2str(i,'%05.0f');
            DataRecues.Val_Vect_Str{i}=[ '@' i_str '   '  N_Val];
        end
       
         % Mise à jour de l'affichage
        set(Main_Fig_Memory_Display,'String',DataRecues.Val_Vect_Str);    
    end

    function  Time_Display

        % Save the sample.txt file to a new text fie
        fid = fopen('capture.txt', 'w');
        for i = 1:length(DataRecues.Val_Vect(:,1))
            fprintf(fid, '%d\n', DataRecues.Val_Vect(i,1));
        end
        fclose(fid);
        
        figure(h);
        
         if (Flag.Dot==0)
             plot(DataRecues.Val_Vect((1:DataRecues.Val_Nb),1));
             plot(Main_Fig_Axes,DataRecues.Val_Vect((1:DataRecues.Val_Nb),1));
         else
             plot(DataRecues.Val_Vect((1:DataRecues.Val_Nb),1),'+');
             plot(Main_Fig_Axes,DataRecues.Val_Vect((1:DataRecues.Val_Nb),1),'+');
         end
                
        Flag.Time='Time';
        set(Main_Fig_Time_Text,'String',Flag.Time);
    end

    function  Freq_Display
        % Calcul du nombre en 2^N pour la FFT
        DataRecues.Val_Nb;
        Exp_Deux=log2(DataRecues.Val_Nb);
        Exp_Deux=floor(Exp_Deux);
        if  (Exp_Deux>0)
            DataRecues.FFT_Val_Nb=2^(Exp_Deux);
            DataRecues.Val_FFT_Vect=fft(DataRecues.Val_Vect,DataRecues.FFT_Val_Nb)/DataRecues.FFT_Val_Nb;
            set(Main_Fig_FFT_Val_NB,'String',DataRecues.FFT_Val_Nb);
            A=DataRecues.Val_FFT_Vect((1:DataRecues.FFT_Val_Nb),1);
            figure(h);
            if (Flag.Dot==0)
                plot(abs(A));
                plot(Main_Fig_Axes,abs(A));
            else
                plot(abs(A),'+');
                plot(Main_Fig_Axes,abs(A),'+');
            end
            Flag.Time='Frequence';
            set(Main_Fig_Time_Text,'String',Flag.Time);
        end
    end

    function  Fill_Val_Vect
        % DataRecues.Byte_Nb : nb d'octets reçus effectivement
        % ----------COM.ValuesNb    : nb de valeur au format spécifié demandé 
        % Data_Format.Nb_Byte_Per_Value : nb d'octets par valeur
        % DataRecues.Byte_Vect les bytes
        % DataRecues.Val_Vect les valeurs
        
        % Redimensionnement du nombre d'octet reçus (s'il y a eu un Timout)
        if ~(mod(DataRecues.Byte_Nb,Data_Format.Nb_Byte_Per_Value)==0)
            DataRecues.Val_Nb=floor(DataRecues.Byte_Nb/Data_Format.Nb_Byte_Per_Value);
            % A virer !! DataRecues.Byte_Nb=Val_Nb*Data_Format.Nb_Byte_Per_Value;
        else
            DataRecues.Val_Nb=DataRecues.Byte_Nb/Data_Format.Nb_Byte_Per_Value;
        end
        
        
        % Nb_Val contient le nb de valeur effectivement reçu

        if (DataRecues.Val_Nb>=1) % sinon on ne lance pas la conversion
            % Composition des valeurs en non signé brute
            for i=1: DataRecues.Val_Nb
                DataRecues.Val_Vect(i,1)=0;
                for j=1:Data_Format.Nb_Byte_Per_Value
                    k=(i-1)*Data_Format.Nb_Byte_Per_Value;% ex si u32 k= 0, 4, 8 ------------------------------------------------
                    DataRecues.Val_Vect(i,1)=DataRecues.Byte_Vect(j+k,1)*256^(j-1)+DataRecues.Val_Vect(i,1);
                    
                end
               
            end

            % passage en fractionnaire signé
            if (Data_Format.Signed==1)
                Exposant=Data_Format.FractPart+Data_Format.IntPart;
                FullScale=2^Exposant;
                for i=1:DataRecues.Val_Nb
                    if (DataRecues.Val_Vect(i,1)>=FullScale/2) % Détection et mise en forme nb négatif
                        DataRecues.Val_Vect(i,1)=DataRecues.Val_Vect(i,1)-FullScale;
                       
                    end
                    % fractionnaire
                    DataRecues.Val_Vect(i,1)=DataRecues.Val_Vect(i,1)/2^(Data_Format.FractPart);
                                      
                end
            end
              
        end
    end

	
	
end 