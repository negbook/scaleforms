
local IsUtilForLocalScript  = false 

Scaleforms = {}
Scaleforms.temp_tasks = {}
Scaleforms.Tasks = {}
Scaleforms.Handles = {}
Scaleforms.Kill = {}
Scaleforms.ReleaseTimer = {}


SendScaleformValues = function (...)
    local tb = {...}
    for i=1,#tb do
        if type(tb[i]) == "number" then 
            if math.type(tb[i]) == "integer" then
                    ScaleformMovieMethodAddParamInt(tb[i])
            else
                    ScaleformMovieMethodAddParamFloat(tb[i])
            end
        elseif type(tb[i]) == "string" then ScaleformMovieMethodAddParamTextureNameString(tb[i])
        elseif type(tb[i]) == "boolean" then ScaleformMovieMethodAddParamBool(tb[i])
        end
    end 
end

--[=[
--  TriggerEvent('CallScaleformMovie','TALK_MESSAGE',function(run,send,stop)  -- or function(run,send,stop,handle)
            run('SayToAll')
                send(1,2,3,4,5)
            stop()
    end )
--]=]
Scaleforms.CallScaleformMovie = function (scaleformName,cb)
    if not Scaleforms.Handles[scaleformName] then 
    Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
        Scaleforms.Handles[scaleformName] = handle
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
        local inputfunction = function(sfunc) PushScaleformMovieFunction(Scaleforms.Handles[scaleformName],sfunc) end
        cb(inputfunction,SendScaleformValues,PopScaleformMovieFunctionVoid,Scaleforms.Handles[scaleformName])
    end)
    else 
        local inputfunction = function(sfunc) PushScaleformMovieFunction(Scaleforms.Handles[scaleformName],sfunc) end
        cb(inputfunction,SendScaleformValues,PopScaleformMovieFunctionVoid,Scaleforms.Handles[scaleformName])
    end 
end


Scaleforms.RequestScaleformCallbackString = function (scaleformName,SfunctionName,...) 
    local ops = {...}
    Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
        Scaleforms.Handles[scaleformName] = handle
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
        BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
        
        local cb = ops[#ops]
        table.remove(ops,#ops)
        SendScaleformValues(table.unpack(ops))

        local b = EndScaleformMovieMethodReturnValue()
        while not IsScaleformMovieMethodReturnValueReady(b) do 
            Wait(0)
        end 
        cb(GetScaleformMovieMethodReturnValueString(b))

    end)
end 


Scaleforms.RequestScaleformCallbackInt = function(scaleformName,SfunctionName,...) 
    local ops = {...}
    Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
        Scaleforms.Handles[scaleformName] = handle
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(table.unpack(ops))
    local b = EndScaleformMovieMethodReturnValue()
    while not IsScaleformMovieMethodReturnValueReady(b) do 
        Wait(0)
    end 
    cb(GetScaleformMovieMethodReturnValueInt(b))

    end)
end 


Scaleforms.RequestScaleformCallbackBool = function(scaleformName,SfunctionName,...) 
    local ops = {...}
    Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
        Scaleforms.Handles[scaleformName] = handle
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(table.unpack(ops))
    local b = EndScaleformMovieMethodReturnValue()
    while not IsScaleformMovieMethodReturnValueReady(b) do 
        Wait(0)
    end 
    cb(GetScaleformMovieMethodReturnValueBool(b))
    

    end)
end 


Scaleforms.DrawScaleformMovie = function (scaleformName,...)
    local ops = {...}
    Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
        Scaleforms.Handles[scaleformName] = handle
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count

        
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks[scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovie(Scaleforms.Handles[scaleformName], table.unpack(ops))
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        else 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks [scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovieFullscreen(Scaleforms.Handles[scaleformName])
                    
                end 
            end
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        end 

    end)
end 


Scaleforms.DrawScaleformMoviePosition = function (scaleformName,...)
    local ops = {...}
    Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
        Scaleforms.Handles[scaleformName] = handle
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count

        
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks[scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovie_3d(Scaleforms.Handles[scaleformName], table.unpack(ops))
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        end 

    end)
end 


Scaleforms.DrawScaleformMoviePosition2 = function (scaleformName,...)
    local ops = {...}
    Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
        Scaleforms.Handles[scaleformName] = handle
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count

        
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms',0,function()
                if Scaleforms.counts == 0 then 
                    Threads.KillLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.Tasks) do
                    Scaleforms.Tasks[i]()
                end 
            end)
            Scaleforms.temp_tasks[scaleformName] = function()
                if Scaleforms.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    Scaleforms.temp_tasks[scaleformName] = nil
                elseif Scaleforms.Handles[scaleformName] then 
                    DrawScaleformMovie_3dSolid(Scaleforms.Handles[scaleformName], table.unpack(ops))
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.Tasks = task
        end 

    end)
end 


Scaleforms.EndScaleformMovie = function (scaleformName)
    if not Scaleforms.Handles[scaleformName] then 
    else 
        Scaleforms.Kill[scaleformName] = true
        SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
        Scaleforms.Handles[scaleformName] = nil 
        Scaleforms.Kill[scaleformName] = nil
        Scaleforms.counts = Scaleforms.counts - 1
        Scaleforms.temp_tasks[scaleformName] = nil
    end 
end 



Scaleforms.KillScaleformMovie = function(scaleformName)
    if not Scaleforms.Handles[scaleformName] then 
    else 
        Scaleforms.Kill[scaleformName] = true
        SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
        Scaleforms.Handles[scaleformName] = nil 
        Scaleforms.Kill[scaleformName] = nil
        Scaleforms.counts = Scaleforms.counts - 1
        Scaleforms.temp_tasks[scaleformName] = nil
    end 
end 


Scaleforms.DrawScaleformMovieDuration = function (scaleformName,duration,...)
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.DrawScaleformMovie(scaleformName,table.unpack(ops))
        Scaleforms.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        
        Threads.CreateLoopOnce("ScaleformDuration"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.ReleaseTimer[scaleformName] then 
                Scaleforms.KillScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                
                Threads.KillLoop("ScaleformDuration"..scaleformName,333);
            end 
        end)
    end)
end 


Scaleforms.DrawScaleformMoviePositionDuration = function (scaleformName,duration,...)
     local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.DrawScaleformMoviePosition(scaleformName,table.unpack(ops))
        Scaleforms.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        
        Threads.CreateLoopOnce("ScaleformDuration"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.ReleaseTimer[scaleformName] then 
                Scaleforms.KillScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                
                Threads.KillLoop("ScaleformDuration"..scaleformName,333);
            end 
        end)
    end)
end 


Scaleforms.DrawScaleformMoviePosition2Duration = function (scaleformName,duration,...)
    local ops = {...}
    local cb = ops[#ops]
    
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.DrawScaleformMoviePosition2(scaleformName,table.unpack(ops))
        Scaleforms.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        
        Threads.CreateLoopOnce("ScaleformDuration"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.ReleaseTimer[scaleformName] then 
                Scaleforms.KillScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                
                Threads.KillLoop("ScaleformDuration"..scaleformName,333);
            end 
        end)
    end)
end 

if not IsUtilForLocalScript  then 
RegisterNetEvent('CallScaleformMovie')
RegisterNetEvent('RequestScaleformCallbackString')
RegisterNetEvent('RequestScaleformCallbackInt')
RegisterNetEvent('RequestScaleformCallbackBool')
RegisterNetEvent('DrawScaleformMovie')
RegisterNetEvent('DrawScaleformMoviePosition')
RegisterNetEvent('DrawScaleformMoviePosition2')
RegisterNetEvent('EndScaleformMovie')
RegisterNetEvent('KillScaleformMovie')
RegisterNetEvent('DrawScaleformMovieDuration')
RegisterNetEvent('DrawScaleformMoviePositionDuration')
RegisterNetEvent('DrawScaleformMoviePosition2Duration')
AddEventHandler('CallScaleformMovie', function(scaleformName,cb) 
    Scaleforms.CallScaleformMovie(scaleformName,cb) 
end)
AddEventHandler('RequestScaleformCallbackString', function(scaleformName,SfunctionName,...) 
    RequestScaleformCallbackString(scaleformName,SfunctionName,...) 
end)
AddEventHandler('RequestScaleformCallbackInt', function(scaleformName,SfunctionName,...) 
    Scaleforms.RequestScaleformCallbackInt(scaleformName,SfunctionName,...) 
end)
AddEventHandler('RequestScaleformCallbackBool', function(scaleformName,SfunctionName,...) 
    Scaleforms.RequestScaleformCallbackBool(scaleformName,SfunctionName,...) 
end)
AddEventHandler('DrawScaleformMovie', function(scaleformName,...)
    Scaleforms.DrawScaleformMovie(scaleformName,...)
    
end)
AddEventHandler('DrawScaleformMoviePosition', function(scaleformName,...)
    Scaleforms.DrawScaleformMoviePosition(scaleformName,...)
end)
AddEventHandler('DrawScaleformMoviePosition2', function(scaleformName,...)
    Scaleforms.DrawScaleformMoviePosition2(scaleformName,...)
end)
AddEventHandler('EndScaleformMovie', function(scaleformName)
    Scaleforms.EndScaleformMovie(scaleformName)
end)
AddEventHandler('KillScaleformMovie', function(scaleformName)
    Scaleforms.KillScaleformMovie(scaleformName)
end)
AddEventHandler('DrawScaleformMovieDuration', function(scaleformName,duration,...)
    Scaleforms.DrawScaleformMovieDuration(scaleformName,duration,...)
end)
AddEventHandler('DrawScaleformMoviePositionDuration', function(scaleformName,duration,...)
   Scaleforms.DrawScaleformMoviePositionDuration(scaleformName,duration,...)
end)
AddEventHandler('DrawScaleformMoviePosition2Duration', function(scaleformName,duration,...)
    Scaleforms.DrawScaleformMoviePosition2Duration(scaleformName,duration,...)
end)
end 

--[==[
Citizen.CreateThread(function()
    TriggerEvent('CallScaleformMovie','instructional_buttons',function(run,send,stop,handle)
            run('CLEAR_ALL')
            stop()
            run('SET_CLEAR_SPACE')
                send(200)
            stop()
            run('SET_DATA_SLOT')
                send(0,GetControlInstructionalButton(2, 191, true),'this is enter')
            stop()
            run('SET_BACKGROUND_COLOUR')
                send(0,0,0,22)
            stop()
            run('SET_BACKGROUND')
            stop()
            run('DRAW_INSTRUCTIONAL_BUTTONS')
            stop()
            TriggerEvent('DrawScaleformMovie','instructional_buttons',0.5,0.5,0.8,0.8,0)
    end )
    TriggerEvent('RequestScaleformCallbackBool','instructional_buttons','isKey','w3s',function(result)
        CreateThread(function()
            Wait(3000)
            TriggerEvent('EndScaleformMovie','instructional_buttons')
        end)
    end )
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    xrot,yrot,zrot = table.unpack(GetEntityRotation(PlayerPedId(), 1))
    TriggerEvent('CallScaleformMovie','mp_car_stats_01',function(run,send,stop,handle)
            run('SET_VEHICLE_INFOR_AND_STATS')
                send("RE-7B","Tracked and Insured","MPCarHUD","Annis","Top Speed","Acceleration","Braking","Traction",68,60,40,70)
            stop()
           TriggerEvent('DrawScaleformMoviePosition','mp_car_stats_01',x,y,z+4.0,xrot,180.0,zrot,2.0, 2.0, 1.0, 5.0, 4.0, 5.0, 2)
            TriggerEvent('CallScaleformMovie','mp_car_stats_02',function(run,send,stop,handle)
                run('SET_VEHICLE_INFOR_AND_STATS')
                send("RE-7B","Tracked and Insured","MPCarHUD","Annis","Top Speed","Acceleration","Braking","Traction",68,60,40,70)
            stop()
            TriggerEvent('DrawScaleformMoviePosition2','mp_car_stats_02',x,y+1.0,z+3.0,0.0,0.0,0.0,1.0, 1.0, 1.0, 5.0, 5.0, 5.0, 1)
                CreateThread(function()
                Wait(5000)
                TriggerEvent('EndScaleformMovie','mp_car_stats_01')
                TriggerEvent('EndScaleformMovie','mp_car_stats_02')
                end)
            end )
    end )
end)
--]==]