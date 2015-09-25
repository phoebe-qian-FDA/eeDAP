function task_mitotic_counts( hObj )
%TASK_MITOTIC_COUNTS Summary of this function goes here
%   Detailed explanation goes here
try
    
    handles = guidata(hObj);
    myData = handles.myData;
    taskinfo = myData.taskinfo;
    calling_function = handles.myData.taskinfo.calling_function;
    
    display([taskinfo.task, ' called from ', calling_function])
    
    switch calling_function
        
        case 'Load_Input_File' % Read in the taskinfo
            
           handles = guidata(hObj);
            
            desc = taskinfo.desc;

            taskinfo.task  = char(desc{1});
            taskinfo.id = char(desc{2});
            taskinfo.order = str2double(desc{3});
            taskinfo.slot = str2double(desc{4});
            wsi_files = myData.wsi_files{taskinfo.slot};
            taskinfo.roi_w = wsi_files.wsi_w;
            taskinfo.roi_h = wsi_files.wsi_h;
            taskinfo.roi_x = taskinfo.roi_w/2+1;
            taskinfo.roi_y = taskinfo.roi_h/2+1;
            mp = get(0, 'MonitorPositions');
            screensize= mp(find(mp(:,1)==1&mp(:,2)==1),:);
            if  taskinfo.roi_w/ taskinfo.roi_h>(screensize(4)*0.8)/screensize(3); 
            taskinfo.img_w = floor(screensize(4)*0.7);
            taskinfo.img_h = 0;
            else
            taskinfo.img_w = 0;
            taskinfo.img_h = floor(screensize(3)*0.9);
            end
            taskinfo.text  = 'mitotic_counts: Please input mitotic counts for 10 fields';
            taskinfo.moveflag = str2double(desc{5});
            taskinfo.zoomflag = str2double(desc{6});
     
            
        case {'Update_GUI_Elements', ...
                'ResumeButtonPressed'} % Initialize task elements
            
            % Load the image
            taskimage_load(hObj);
            handles = guidata(hObj);

            % Show management buttons
            taskmgt_default(handles, 'on');
            handles = guidata(hObj);
            taskinfo.done=zeros(1,11);
            % Static text question for count task
            handles.editCase = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.8, 0.8, .2, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', 'Case ID', ...
                'Callback', @editCase_Callback);

            % Count task response box
            handles.editCount1 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.05, .55, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount1_Callback);
            
           handles.editCount2 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.23, .55, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount2_Callback);
            
            handles.editCount3 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.41, .55, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount3_Callback);
            
            handles.editCount4 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.59, .55, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount4_Callback);
            
            handles.editCount5 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.77, .55, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount5_Callback);
            
            handles.editCount6 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.05, .25, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount6_Callback);
            
            handles.editCount7 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.23, .25, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount7_Callback);
            
            handles.editCount8 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.41, .25, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount8_Callback);
            
            handles.editCount9 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.59, .25, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'KeyPressFcn', @integer_test, ...
                'Callback', @editCount9_Callback);
            
            handles.editCount10 = uicontrol(...
                'Parent', handles.task_panel, ...
                'FontSize', handles.myData.settings.FontSize, ...
                'Units', 'normalized', ...
                'HorizontalAlignment', 'center', ...
                'ForegroundColor', handles.myData.settings.FG_color, ...
                'BackgroundColor', [.95, .95, .95], ...
                'Position', [.77, .25, .1, .2], ...
                'Style', 'edit', ...
                'Tag', 'editCount', ...
                'String', '<int>', ...
                'Callback', @editCount10_Callback,...
                'KeyPressFcn', @integer_test);
            
            
            
            
           
        case {'NextButtonPressed', ...
                'PauseButtonPressed',...
                'Backbutton_Callback'} % Clean up the task elements
            
            % Hide image and management buttons
            
            taskmgt_default(handles, 'off');
            handles = guidata(hObj);
            
            set(handles.iH,'visible','off');
            set(handles.ImageAxes,'visible','off');
            delete(handles.editCount1);
            delete(handles.editCount2);
            delete(handles.editCount3);
            delete(handles.editCount4);
            delete(handles.editCount5);
            delete(handles.editCount6);
            delete(handles.editCount7);
            delete(handles.editCount8);
            delete(handles.editCount9);
            delete(handles.editCount10);
            delete(handles.editCase);

            handles = rmfield(handles, 'editCount1');
            handles = rmfield(handles, 'editCount2');
            handles = rmfield(handles, 'editCount3');
            handles = rmfield(handles, 'editCount4');
            handles = rmfield(handles, 'editCount5');
            handles = rmfield(handles, 'editCount6');
            handles = rmfield(handles, 'editCount7');
            handles = rmfield(handles, 'editCount8');
            handles = rmfield(handles, 'editCount9');
            handles = rmfield(handles, 'editCount10');
            handles = rmfield(handles, 'editCase');


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
                'mitotic_counts', ',', ...
                num2str(taskinfo.moveflag), ',', ...
                num2str(taskinfo.zoomflag), ',', ...
                num2str(taskinfo.duration), ',', ...
                taskinfo.caseid,',',...
                taskinfo.score1,',',...
                taskinfo.score2,',',...
                taskinfo.score3,',',...
                taskinfo.score4,',',...
                taskinfo.score5,',',...
                taskinfo.score6,',',...
                taskinfo.score7,',',...
                taskinfo.score8,',',...
                taskinfo.score9,',',...
                taskinfo.score10,]);
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

% function editCount_KeyPressFcn(hObj, eventdata)
% try
%     %--------------------------------------------------------------------------
%     % When the text box is non-empty, the user can continue
%     %--------------------------------------------------------------------------
%     handles = guidata(findobj('Tag','GUI'));
%     editCount_string = eventdata.Key;
% %     desc_digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9','backspace','delete','leftarrow','rightarrow'...
% %                    'numpad0','numpad1','numpad2','numpad3','numpad4','numpad5','numpad6','numpad7','numpad8','numpad9'};
% %                
% %     test = max(strcmp(editCount_string, desc_digits));
% %     if ~test
% %         desc = 'Input should be an integer';
% %         h_errordlg = errordlg(desc,'Application error','modal');
% %         uiwait(h_errordlg)
% % 
% %         set(handles.NextButton, 'Enable', 'off');
% % 
% %         return
% %     end
% catch ME
%     error_show(ME)
% end
% 
% end

function editCount1_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};
    
    % Pack the results
    taskinfo.score1 = get(handles.editCount1, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(1)=1;
    else
    taskinfo.done(1)=0;
    end
    taskinfo.valiad_input=0;    
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount2_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score2 = get(handles.editCount2, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(2)=1;
    else
    taskinfo.done(2)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount3_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score3 = get(handles.editCount3, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(3)=1;
    else
    taskinfo.done(3)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount4_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score4 = get(handles.editCount4, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(4)=1;
    else
    taskinfo.done(4)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount5_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score5 = get(handles.editCount5, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(5)=1;
    else
    taskinfo.done(5)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount6_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score6 = get(handles.editCount6, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(6)=1;
    else
    taskinfo.done(6)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');

        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount7_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score7 = get(handles.editCount7, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(7)=1;
    else
    taskinfo.done(7)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount8_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score8 = get(handles.editCount8, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(8)=1;
    else
    taskinfo.done(8)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount9_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score9 = get(handles.editCount9, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(9)=1;
    else
    taskinfo.done(9)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCount10_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.score10 = get(handles.editCount10, 'String');
    if taskinfo.valiad_input==1
    taskinfo.done(10)=1;
    else
    taskinfo.done(10)=0;
    end
    taskinfo.valiad_input=0;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

function editCase_Callback(hObj, eventdata)
    handles = guidata(findobj('Tag','GUI'));
    taskinfo = handles.myData.tasks_out{handles.myData.iter};

    % Pack the results
    taskinfo.caseid = get(handles.editCase, 'String');
    taskinfo.done(11)=1;
    tdone=sum(taskinfo.done);
        if tdone==11;
            set(handles.NextButton,'Enable','on');
        end
    handles.myData.tasks_out{handles.myData.iter} = taskinfo;
    guidata(handles.GUI, handles);
    
end

