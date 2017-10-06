function  task_mitotic_expert( hObj )
%MITOTIC_EXPERT Summary of this function goes here
%   Detailed explanation goes here
try
    
    handles = guidata(hObj);
    myData = handles.myData;
    taskinfo = myData.taskinfo;
    calling_function = handles.myData.taskinfo.calling_function;
    
    display([taskinfo.task, ' called from ', calling_function])
%     taskinfo.flagsl=0;
%     taskinfo.flagcb=0;
    switch calling_function
        
        case 'Load_Input_File' % Read in the taskinfo
            
            handles = guidata(hObj);
            
            desc = taskinfo.desc;
            
            taskinfo.task  = char(desc{1});
            taskinfo.id = char(desc{2});
            taskinfo.order = str2double(desc{3});
            taskinfo.slot = str2double(desc{4});
            taskinfo.roi_x  = str2double(desc{5});
            taskinfo.roi_y = str2double(desc{6});
            taskinfo.roi_w = str2double(desc{7});
            taskinfo.roi_h = str2double(desc{8});
            taskinfo.img_w = str2double(desc{9});
            taskinfo.img_h = str2double(desc{10});
            taskinfo.text  = 'mitotic_expert';
            taskinfo.moveflag = str2double(desc{11});
            taskinfo.zoomflag = str2double(desc{12});
            taskinfo.checkboxresult=zeros(1,8);
            taskinfo.rotateback = 0;
            if length(taskinfo.desc)>12
                myData.finshedTask = myData.finshedTask + 1;
            end
        case {'Update_GUI_Elements', ...
                'ResumeButtonPressed'} % Initialize task elements
            % reset checkboxes results
            taskinfo.checkboxresult=zeros(1,8);
            
            % Load the image
            taskimage_load(hObj);
            handles = guidata(hObj);
            % Show management buttons
            taskmgt_default(handles, 'on');
            handles = guidata(hObj);
            
            
            
            handles.edittext = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [0.2,0.2,0.5,0.3], ...
                'Style', 'edit', ...
                'Tag', 'edittext', ...
                'String', 'what do you see',...
                'Max',2,'Min',0,...
                'Callback', @edittext_Callback,...
                'KeyPressFcn', @edittext_KeyPressFcn);
            uicontrol(handles.edittext);
            
            % checkbox
            handles.checkbox1 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Enable','off',...
                'visible','off',...
                'Position', [0.1,0.65,0.2,0.1], ...
                'Style', 'checkbox', ...
                'Callback',@checkbox1_Callback, ...
                'String', 'Dark spindle',...
                'TooltipString','Spindle darker (general)');
            
           handles.checkbox2 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.3,0.65,0.2,0.1], ...
                'Style', 'checkbox', ...
                'Enable','off',...
                'visible','off',...
                'Callback',@checkbox2_Callback, ...
                'String', 'Ropy texture',...
                'TooltipString','Ropy, hetero. texture (general)');
          
            handles.checkbox3 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.5,0.65,0.2,0.1], ...
                'Style', 'checkbox', ...
                'Enable','off',...
                'visible','off',...
                'Callback',@checkbox3_Callback, ...
                'String', 'Visible cytoplasm',...
                'TooltipString','Visible cytoplasm (general)');
            
            handles.checkbox4 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.7,0.65,0.2,0.1], ...
                'Style', 'checkbox', ...
                'Enable','off',...
                'visible','off',...
                'Callback',@checkbox4_Callback, ...
                'String', 'Not apoptotic',...
                'TooltipString','Not apoptotic: brown stain or dissolving, shrinking (general)');
            
            handles.checkbox5 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.1,0.45,0.2,0.1], ...
                'Style', 'checkbox', ...
                'Enable','off',...
                'visible','off',...
                'Callback',@checkbox5_Callback,...
                'String', 'N/C~2',...
                'TooltipString','Spindle area majority of cell, N/C~2 (prophase)');
            
            
            handles.checkbox6 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.3,0.45,0.2,0.1], ...
                'Enable','off',...
                'visible','off',...
                'Style', 'checkbox', ...
                'Callback',@checkbox6_Callback,...
                'String', 'Spindle aligned',...
                'TooltipString','Spindle aligned with cell (metaphase)');
            
            
            handles.checkbox7 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.5,0.45,0.2,0.1], ...
                'Style', 'checkbox', ...
                'Enable','off',...
                'visible','off',...
                'Callback',@checkbox7_Callback,...
                'String', 'Two spindles',...
                'TooltipString','Two spindles have formed (anaphase)');
            
            
            
            handles.checkbox8 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [0.7,0.45,0.2,0.1], ...
                'Style', 'checkbox', ...
                'Enable','off',...
                'visible','off',...
                'Callback',@checkbox8_Callback,...
                'String','Two membranes',...
                'TooltipString','Two cell membranes visible (telophase)');
             
            
            % slider  
            initvalue = 50;
            slider_x = .1;
            slider_y = .1;
            slider_w = .6;
            slider_h = .2;
            position = [slider_x, slider_y, slider_w, slider_h];
            handles.slider = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', position, ...
                'Style', 'slider', ...
                'Enable','off',...
                'visible','off',...
                'Tag', 'slider', ...
                'String', 'Probability being mitosis', ...
                'Min', 0, ...
                'Max', 100, ...
                'SliderStep', [1.0/100.0, .1], ...
                'Value', initvalue, ...
                'Callback', @slider_Callback);

            position = [slider_x+slider_w+.05, slider_y, .1, .2];
            handles.editvalue = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', position, ...
                'Style', 'edit', ...
                'Enable','off',...
                'visible','off',...
                'Tag', 'editvalue', ...
                'String', num2str(initvalue), ...
                'KeyPressFcn', @editvalue_KeyPressFcn, ...
                'Callback', @editvalue_Callback);

           
            
            position = [slider_x, slider_y+slider_h, .1, .1];
            handles.textleft = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'visible','off',...
                'Tag', 'textleft', ...
                'String', '0');

            position = [slider_x+slider_w/2-.05, slider_y+slider_h, .1, .1];
            handles.textcenter = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'visible','off',...
                'Tag', 'textcenter', ...
                'String', '50');

            position = [slider_x+slider_w-.1, slider_y+slider_h, .1, .1];
            handles.textright = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'visible','off',...
                'Tag', 'textright', ...
                'String', '100');

            position = [slider_x+slider_w+.05, slider_y+slider_h, .1, .1];
            handles.textscore = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', position, ...
                'Style', 'text', ...
                'Enable','off',...
                'visible','off',...
                'Tag', 'textright', ...
                'String', 'Score');
            
            position = [0.85, 0.8, .15, .2];
            handles.Next_Part = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'ForegroundColor',  handles.myData.settings.FG_color, ...
                'BackgroundColor',  handles.myData.settings.BG_color, ...
                'Position',position, ...
                'Style', 'pushbutton', ...
                'Tag', 'editvalue', ...
                'enable','off',...
                'String', 'Next Part',...
                'Callback',@Next_Part_Callback);
            
            

            
        case {'NextButtonPressed', ...
                'PauseButtonPressed',...
                'Backbutton_Callback'} % Clean up the task elements
            taskmgt_default(handles, 'off');
            handles = guidata(hObj);
            % Hide image and management buttons
            set(handles.iH,'visible','off');
            set(handles.ImageAxes,'visible','off');
            
            delete(handles.edittext);
            handles = rmfield(handles, 'edittext');
            
            delete(handles.slider);
            delete(handles.editvalue);
            delete(handles.textleft);
            delete(handles.textcenter);
            delete(handles.textright);
            delete(handles.textscore);
            handles = rmfield(handles, 'slider');
            handles = rmfield(handles, 'editvalue');
            handles = rmfield(handles, 'textleft');
            handles = rmfield(handles, 'textcenter');
            handles = rmfield(handles, 'textright');
            handles = rmfield(handles, 'textscore');
            
            
            delete( handles.checkbox1);
            delete( handles.checkbox2);
            delete( handles.checkbox3);
            delete( handles.checkbox4);
            delete( handles.checkbox5);
            delete( handles.checkbox6);
            delete( handles.checkbox7);
            delete( handles.checkbox8);
            handles = rmfield(handles, 'checkbox1');
            handles = rmfield(handles, 'checkbox2');
            handles = rmfield(handles, 'checkbox3');
            handles = rmfield(handles, 'checkbox4');
            handles = rmfield(handles, 'checkbox5');
            handles = rmfield(handles, 'checkbox6');
            handles = rmfield(handles, 'checkbox7');
            handles = rmfield(handles, 'checkbox8');
            
            delete (handles.Next_Part);
            handles =rmfield(handles, 'Next_Part');
            
            taskimage_archive(handles);
            
        case 'exportOutput' % export current task information and reuslt
            if taskinfo.currentWorking ==1 % write finish task in current study
                fprintf(myData.fid, [...
                    taskinfo.task, ',', ...
                    taskinfo.id, ',', ...
                    num2str(taskinfo.order), ',', ...
                    num2str(taskinfo.slot), ',',...
                    num2str(taskinfo.roi_x), ',',...
                    num2str(taskinfo.roi_y), ',', ...
                    num2str(taskinfo.roi_w), ',', ...
                    num2str(taskinfo.roi_h), ',', ...
                    num2str(taskinfo.img_w), ',', ...
                    num2str(taskinfo.img_h), ',', ...
                    taskinfo.text, ',', ...
                    num2str(taskinfo.moveflag), ',', ...
                    num2str(taskinfo.zoomflag), ',', ...
                    num2str(taskinfo.duration), ',', ...
                    num2str(taskinfo.checkboxresult(1)),',',...
                    num2str(taskinfo.checkboxresult(2)),',',...
                    num2str(taskinfo.checkboxresult(3)),',',...
                    num2str(taskinfo.checkboxresult(4)),',',...
                    num2str(taskinfo.checkboxresult(5)),',',...
                    num2str(taskinfo.checkboxresult(6)),',',...
                    num2str(taskinfo.checkboxresult(7)),',',...
                    num2str(taskinfo.checkboxresult(8)),',',...
                    num2str(taskinfo.score),...
                    ',Desc:',taskinfo.inputtext]);
            elseif taskinfo.currentWorking ==0 % write undone task
                fprintf(myData.fid, [...
                    taskinfo.task, ',', ...
                    taskinfo.id, ',', ...
                    num2str(taskinfo.order), ',', ...
                    num2str(taskinfo.slot), ',',...
                    num2str(taskinfo.roi_x), ',',...
                    num2str(taskinfo.roi_y), ',', ...
                    num2str(taskinfo.roi_w), ',', ...
                    num2str(taskinfo.roi_h), ',', ...
                    num2str(taskinfo.img_w), ',', ...
                    num2str(taskinfo.img_h), ',', ...
                    num2str(taskinfo.moveflag), ',', ...
                    num2str(taskinfo.zoomflag)]);
            else                               % write done task from previous study
                desc = taskinfo.desc;
                for i = 1 : length(desc)-1
                    fprintf(myData.fid,[desc{i},',']);
                end
                fprintf(myData.fid,[desc{length(desc)}]);
            end            
            fprintf(myData.fid,'\r\n');
            handles.myData.taskinfo = taskinfo;
            guidata(handles.GUI, handles);   
%         case 'Save_Results' % Save the results for this task
% %            templarge=length(taskinfo.checkboxresult);
% %            taskinfo.checkboxresult= padarray(taskinfo.checkboxresult,[0,8- templarge],'post');
%             fprintf(taskinfo.fid, [...
%                 taskinfo.task, ',', ...
%                 taskinfo.id, ',', ...
%                 num2str(taskinfo.order), ',', ...
%                 num2str(taskinfo.slot), ',',...
%                 num2str(taskinfo.roi_x), ',',...
%                 num2str(taskinfo.roi_y), ',', ...
%                 num2str(taskinfo.roi_w), ',', ...
%                 num2str(taskinfo.roi_h), ',', ...
%                 num2str(taskinfo.img_w), ',', ...
%                 num2str(taskinfo.img_h), ',', ...
%                 taskinfo.text, ',', ...
%                 num2str(taskinfo.moveflag), ',', ...
%                 num2str(taskinfo.zoomflag), ',', ...
%                 num2str(taskinfo.duration), ',', ...
%                 num2str(taskinfo.checkboxresult(1)),',',...
%                 num2str(taskinfo.checkboxresult(2)),',',...
%                 num2str(taskinfo.checkboxresult(3)),',',...
%                 num2str(taskinfo.checkboxresult(4)),',',...
%                 num2str(taskinfo.checkboxresult(5)),',',...
%                 num2str(taskinfo.checkboxresult(6)),',',...
%                 num2str(taskinfo.checkboxresult(7)),',',...
%                 num2str(taskinfo.checkboxresult(8)),',',...
%                 num2str(taskinfo.score),'\r\n'...
%                 taskinfo.task, ',', ...
%                 taskinfo.id, ',', ...
%                 'Desc:',taskinfo.inputtext]);
%                 fprintf(taskinfo.fid,'\r\n');
            
    end

    % Update handles.myData.taskinfo and pack
    myData.taskinfo = taskinfo;
    handles.myData = myData;
    guidata(hObj, handles);

catch ME
    error_show(ME)
end
end


function edittext_Callback(hObj, eventdata)
try
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};
    wholeinputtext = get(hObj,'String');
    taskinfo.inputtext = strrep(wholeinputtext, ' ', '_');
    set(handles.Next_Part,'Enable','on');
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end

function edittext_KeyPressFcn(hObj, eventdata)
try
    %--------------------------------------------------------------------------
    % When the text box is non-empty, the reader can continue
    %--------------------------------------------------------------------------
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};
    if strcmpi(get(handles.edittext , 'String'),'')
        set(handles.Next_Part,'Enable','off');
    else
        set(handles.Next_Part,'Enable','on');
    end

catch ME
    error_show(ME)
end

end


function checkbox1_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};
% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(1)=1;
else
	taskinfo.checkboxresult(1)=0;
end
% taskinfo.flagcb=1;
% if taskinfo.flagsl==1
%     set(handles.NextButton,'Enable','on');
% end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end

function checkbox2_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};
% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(2)=1;
else
	taskinfo.checkboxresult(2)=0;
end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end

function checkbox3_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};
% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(3)=1;
else
	taskinfo.checkboxresult(3)=0;
end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end



function checkbox4_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(4)=1;
else
	taskinfo.checkboxresult(4)=0;
end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end

function checkbox5_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(5)=1;
else
	taskinfo.checkboxresult(5)=0;
end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end

function checkbox6_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(6)=1;
else
	taskinfo.checkboxresult(6)=0;
end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end

function checkbox7_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(7)=1;
else
	taskinfo.checkboxresult(7)=0;
end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end

function checkbox8_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

% taskinfo.button_desc = get(eventdata.NewValue, 'Tag');

if (get(hObj,'Value') == get(hObj,'Max'))
	taskinfo.checkboxresult(8)=1;
else
	taskinfo.checkboxresult(8)=0;
end
    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end
end


function slider_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    set(handles.slider, 'BackgroundColor', [.95, .95, .95]);
%     taskinfo.flagsl=1;
%     if taskinfo.flagcb==1
%        set(handles.NextButton,'Enable','on');
%     end
    set(handles.NextButton,'Enable','on');
    score = round(get(hObj, 'Value'));
    set(handles.editvalue, 'String', num2str(score));

    taskinfo.score = score;
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
catch ME
    error_show(ME)
end

end

function editvalue_KeyPressFcn(hObj, eventdata)
try
    %--------------------------------------------------------------------------
    % When the text box is non-empty, the user can continue
    %--------------------------------------------------------------------------
    handles = guidata(findobj('Tag','GUI'));
    editvalue_string = eventdata.Key;
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    set(handles.slider, ...
        'BackgroundColor', handles.myData.settings.BG_color);

    desc_digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ...
        'delete', 'return', 'backspace'};
    test = max(strcmp(editvalue_string, desc_digits));
    if test
       taskinfo.flagsl=1;
           if taskinfo.flagcb==1
              set(handles.NextButton,'Enable','on');
           end
    else
        desc = 'Input should be an integer';
        h_errordlg = errordlg(desc,'Application error','modal');
        uiwait(h_errordlg)

        score = round(get(hObj, 'Value'));
        set(handles.editvalue, 'String', num2str(score));
        taskinfo.flagsl=0;
        set(handles.NextButton,'Enable','off');
        uicontrol(handles.editvalue);

        return
    end

catch ME
    error_show(ME)
end

end


function editvalue_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    score = str2double(get(handles.editvalue, 'String'));

    if score > 100
        score = 100;
        set(handles.editvalue, 'String', '100');
        set(handles.slider, 'Value', 100);
    elseif score < 0
        score = 0;
        set(handles.editvalue, 'String', '0');
        set(handles.slider, 'Value', 0);
    end
    
    set(handles.slider, ...
        'BackgroundColor', [.95, .95, .95], ...
        'Value', score);
    taskinfo.flagsl=1;
        if taskinfo.flagcb==1
            set(handles.NextButton,'Enable','on');
        end
    uicontrol(handles.NextButton);
    
    % Pack the results
    taskinfo.score = score;
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end







function Next_Part_Callback(hObj, eventdata) %#ok<DEFNU>
try
     handles = guidata(findobj('Tag','GUI'));
     set(handles.edittext,'visible','off','Enable','off');
     set(handles.checkbox1,'visible','on','Enable','on');
     set(handles.checkbox2,'visible','on','Enable','on');
     set(handles.checkbox3,'visible','on','Enable','on');
     set(handles.checkbox4,'visible','on','Enable','on');
     set(handles.checkbox5,'visible','on','Enable','on');
     set(handles.checkbox6,'visible','on','Enable','on');
     set(handles.checkbox7,'visible','on','Enable','on');
     set(handles.checkbox8,'visible','on','Enable','on');      
     set(handles.slider,'visible','on','Enable','on'); 
     set(handles.editvalue,'visible','on','Enable','on');   
     set(handles.textleft,'visible','on','Enable','on');   
     set(handles.textcenter,'visible','on','Enable','on');   
     set(handles.textright,'visible','on','Enable','on');             
     set(handles.textscore,'visible','on','Enable','on');
     set(handles.Next_Part,'Enable','off');
     uicontrol(handles.editvalue);
catch ME
    error_show(ME)
end
end





