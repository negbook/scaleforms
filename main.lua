Scaleforms = {}
Scaleforms.init = {}
Scaleforms.init.temp_tasks = {}
Scaleforms.init.Tasks = {}
Scaleforms.init.Handles = {}
Scaleforms.init.Kill = {}
Scaleforms.init.ReleaseTimer = {}

Scaleforms.debug = true 
if Scaleforms.debug then 
CreateThread(function()
    while true do 
        print("Total:"..Scaleforms.GetScaleformsTotal())
        Wait(600000)
    end 
end)
end 

--[=[
--  TriggerEvent('CallScaleformMovie','TALK_MESSAGE',function(run,send,stop)  -- or function(run,send,stop,handle)
            run('SayToAll')
                send(1,2,3,4,5)
            stop()
    end )
--]=]


exports('CallScaleformMovie', function (scaleformName)
    if not Scaleforms.init.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.init.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.init.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.init.Handles) do 
            count = count + 1
        end 
        Scaleforms.init.counts = count
    end 
    return Scaleforms.init.Handles[scaleformName]
end)
exports('DrawScaleformMovie', function (scaleformName,...)
    if not Scaleforms.init.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.init.Handles[scaleformName]) then 
        --[=[
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.init.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.init.Handles) do 
            count = count + 1
        end 
        Scaleforms.init.counts = count
        --]=]
        error('Scaleforms:DrawScaleformMovie error,Please CallScaleformMovie first',2)
        return 
    end 
    if Scaleforms.init.Handles[scaleformName] then 
        local ops = {...}
        if #ops > 1 then 
            Threads.CreateLoopOnce('scaleforms:draw',0,function()
                if Scaleforms.init.counts == 0 then 
                    Threads.KillActionOfLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.init.Tasks) do
                    Scaleforms.init.Tasks[i]()
                end 
            end)
            Scaleforms.init.temp_tasks[scaleformName] = function()
                if Scaleforms.init.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.init.Handles[scaleformName])
                    Scaleforms.init.Handles[scaleformName] = nil 
                    Scaleforms.init.Kill[scaleformName] = nil
                    Scaleforms.init.counts = Scaleforms.init.counts - 1
                    Scaleforms.init.temp_tasks[scaleformName] = nil
                elseif Scaleforms.init.Handles[scaleformName] then
                    if #ops > 1 then 
                    SetScriptGfxDrawOrder(ops[#ops])
                    end 
                    DrawScaleformMovie(Scaleforms.init.Handles[scaleformName], table.unpack(ops))
                    ResetScriptGfxAlign()
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.init.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.init.Tasks = task
        else 
            Threads.CreateLoopOnce('scaleforms:draw',0,function()
                if Scaleforms.init.counts == 0 then 
                    Threads.KillActionOfLoop('scaleforms:draw')
                end 
                for i = 1,#(Scaleforms.init.Tasks) do
                    Scaleforms.init.Tasks[i]()
                end 
            end)
            Scaleforms.init.temp_tasks [scaleformName] = function()
                if Scaleforms.init.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.init.Handles[scaleformName])
                    Scaleforms.init.Handles[scaleformName] = nil 
                    Scaleforms.init.Kill[scaleformName] = nil
                    Scaleforms.init.counts = Scaleforms.init.counts - 1
                    Scaleforms.init.temp_tasks[scaleformName] = nil
                elseif Scaleforms.init.Handles[scaleformName] then 
                    
                    if #ops == 1 then 
                    
                    SetScriptGfxDrawOrder(ops[1])
                    end 
                    DrawScaleformMovieFullscreen(Scaleforms.init.Handles[scaleformName])
                    ResetScriptGfxAlign()
                    
                end 
            end
            local task = {}
            for i,v in pairs (Scaleforms.init.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.init.Tasks = task
        end 
    end 
end )


exports('EndScaleformMovie', function (scaleformName)
    if not Scaleforms.init.Handles[scaleformName] then 
    else 
        Scaleforms.init.Kill[scaleformName] = true
        SetScaleformMovieAsNoLongerNeeded(Scaleforms.init.Handles[scaleformName])
        Scaleforms.init.Handles[scaleformName] = nil 
        Scaleforms.init.Kill[scaleformName] = nil
        Scaleforms.init.counts = Scaleforms.init.counts - 1
        Scaleforms.init.temp_tasks[scaleformName] = nil
    end 
end )



exports('RequestScaleformCallbackString', function (scaleformName,SfunctionName,...) 
    if not Scaleforms.init.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.init.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.init.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.init.Handles) do 
            count = count + 1
        end 
        Scaleforms.init.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.init.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(...)
    local b = EndScaleformMovieMethodReturnValue()
    while true do 
    if IsScaleformMovieMethodReturnValueReady(b) then 
       local c = GetScaleformMovieMethodReturnValueString(b)  --output
       cb(c)
       break 
    end 
    Citizen.Wait(0)
    end
end )



exports('RequestScaleformCallbackInt', function(scaleformName,SfunctionName,...) 
    if not Scaleforms.init.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.init.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.init.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.init.Handles) do 
            count = count + 1
        end 
        Scaleforms.init.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.init.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(...)
    local b = EndScaleformMovieMethodReturnValue()
    while true do 
    if IsScaleformMovieMethodReturnValueReady(b) then 
       local c = GetScaleformMovieMethodReturnValueInt(b)  --output
       cb(c)
       break 
    end 
    Citizen.Wait(0)
    end
end )


exports('RequestScaleformCallbackBool', function(scaleformName,SfunctionName,...) 
    if not Scaleforms.init.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.init.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.init.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.init.Handles) do 
            count = count + 1
        end 
        Scaleforms.init.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.init.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    SendScaleformValues(...)
    local b = EndScaleformMovieMethodReturnValue()
    while true do 
    if IsScaleformMovieMethodReturnValueReady(b) then 
       local c = GetScaleformMovieMethodReturnValueBool(b)  --output
       cb(c)
       break 
    end 
    Citizen.Wait(0)
    end
end )

exports('DrawScaleformMovieDuration', function (scaleformName,duration,...)
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.init.DrawScaleformMovie(scaleformName,table.unpack(ops))
        Scaleforms.init.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        
        Threads.CreateLoopOnce("ScaleformDuration"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.init.ReleaseTimer[scaleformName] then 
                Scaleforms.init.KillScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                
                Threads.KillActionOfLoop("ScaleformDuration"..scaleformName,333);
            end 
        end)
    end)
end )


exports('GetScaleformsTotal',function()
    return Scaleforms and Scaleforms.init and Scaleforms.init.counts or 0
end)

