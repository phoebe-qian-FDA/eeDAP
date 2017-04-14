function task_checkMof4(hObj)
try
    
    handles = guidata(hObj);
    myData = handles.myData;
    taskinfo = myData.taskinfo;
    calling_function = handles.myData.taskinfo.calling_function;
    
    display([taskinfo.task, ' called from ', calling_function])
    
    switch calling_function
        
        case 'Load_Input_File' % Read in the taskinfo
            
            taskinfo_default(hObj, taskinfo)
            handles = guidata(hObj);
            taskinfo = handles.myData.taskinfo;
            taskinfo.rotateback = 0;
        case {'Update_GUI_Elements', ...
                'ResumeButtonPressed'} % Initialize task elements

            % Load the image
            taskimage_load(hObj);
            handles = guidata(hObj);

            % Show management buttons
            taskmgt_default(handles, 'on');
            handles = guidata(hObj);
            
            set(handles.checkbox1,'FontSize', myData.settings.FontSize,...
        'BackgroundColor',myData.settings.BG_color,...
        'ForegroundColor',myData.settings.FG_color);
    set(handles.checkbox2,'FontSize', myData.settings.FontSize,...
        'BackgroundColor',myData.settings.BG_color,...
        'ForegroundColor',myData.settings.FG_color);
    set(handles.checkbox3,'FontSize', myData.settings.FontSize,...
        'BackgroundColor',myData.settings.BG_color,...
        'ForegroundColor',myData.settings.FG_color);
    set(handles.checkbox4,'FontSize', myData.settings.FontSize,...
        'BackgroundColor',myData.settings.BG_color,...
        'ForegroundColor',myData.settings.FG_color);

            handles.radiobutton1 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'Characters', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [10,6,25,2], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton1', ...
                'String', taskinfo.q_op1);
            
            handles.radiobutton2 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'Characters', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [35,6,25,2], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton2', ...
                'String', taskinfo.q_op2);

            handles.radiobutton3 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'Characters', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [60,6,25,2], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton3', ...
                'String', taskinfo.q_op3);

            handles.radiobutton4 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'Characters', ...
                'HorizontalAlignment', 'left', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', handles.myData.settings.BG_color, ...
                'Position', [85,6,25,2], ...
                'Style', 'radiobutton', ...
                'Tag', 'radiobutton4', ...
                'String', taskinfo.q_op4);
            
            set(handles.task_panel, ...
                'SelectionChangeFcn', @radiobutton_Callback, ...
                'SelectedObject', []);
            
        case {'NextButtonPressed', ...
                'PauseButtonPressed',...
                'Backbutton_Callback'} % Clean up the task elements

            % Hide image and management buttons
            taskmgt_default(handles, 'off');
            handles = guidata(hObj);
            

            set(handles.iH,'visible','off');
            set(handles.ImageAxes,'visible','off');
            delete(handles.radiobutton1);
            delete(handles.radiobutton2);
            delete(handles.radiobutton3);
            delete(handles.radiobutton4);
            handles = rmfield(handles, 'radiobutton1');
            handles = rmfield(handles, 'radiobutton1');
            handles = rmfield(handles, 'radiobutton1');
            handles = rmfield(handles, 'radiobutton1');
            
            taskimage_archive(handles);
            
        case 'Save_Results' % Save the results for this task
            
            fprintf(taskinfo.fid, [...
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
                taskinfo.q_op1, ',', ...
                taskinfo.q_op2, ',', ...
                taskinfo.q_op3, ',', ...
                taskinfo.q_op4, ',', ...
                num2str(taskinfo.duration), ',', ...
                num2str(taskinfo.buttonID), ',', ...
                taskinfo.button_desc]);
            fprintf(taskinfo.fid,'\r\n');
            
    end

    % Update handles.myData.taskinfo and pack
    myData.taskinfo = taskinfo;
    handles.myData = myData;
    guidata(hObj, handles);

catch ME
    error_show(ME)
end
end

function radiobutton_Callback(hObj, eventdata)
try
    
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    taskinfo.button_desc = get(eventdata.NewValue, 'Tag');
    switch taskinfo.button_desc
        case 'radiobutton1'
            taskinfo.buttonID = 1;
        case 'radiobutton2'
            taskinfo.buttonID = 2;
        case 'radiobutton3'
            taskinfo.buttonID = 3;
        case 'radiobutton4'
            taskinfo.buttonID = 4;
    end

    % Enable next button
    set(handles.NextButton,'Enable','on');

    % Pack the results
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);

catch ME
    error_show(ME)
end

end

%% GUI callbacks tasks

function checkbox1_Callback(hObj, eventdata, handles) %#ok<*INUSL,DEFNU>
%--------------------------------------------------------------------------
% This function is executed when the user changes the value of a
% checkbox. All this function does is calling Update_Next_Button.
%--------------------------------------------------------------------------
Update_Next_Button(handles)
guidata(hObj, handles);
end
function checkbox2_Callback(hObj, eventdata, handles) %#ok<DEFNU>
%--------------------------------------------------------------------------
% This function is executed when the user changes the value of a
% checkbox. All this function does is calling Update_Next_Button.
%--------------------------------------------------------------------------
Update_Next_Button(handles);
guidata(hObj, handles);
end
function checkbox3_Callback(hObj, eventdata, handles) %#ok<DEFNU>
%--------------------------------------------------------------------------
% This function is executed when the user changes the value of a
% checkbox. All this function does is calling Update_Next_Button.
%--------------------------------------------------------------------------
Update_Next_Button(handles);
guidata(hObj, handles);
end
function checkbox4_Callback(hObj, eventdata, handles) %#ok<DEFNU>
%--------------------------------------------------------------------------
% This function is executed when the user changes the value of a
% checkbox. All this function does is calling Update_Next_Button.
%--------------------------------------------------------------------------
Update_Next_Button(handles);
guidata(hObj, handles);
end

