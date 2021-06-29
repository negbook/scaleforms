Scaleforms = {}
Scaleforms.main = {}
Scaleforms.main.temp_tasks = {}
Scaleforms.main.Tasks = {}
Scaleforms.main.Handles = {}
Scaleforms.main.Kill = {}
Scaleforms.main.ReleaseTimer = {}

Scaleforms.debug = true 
if Scaleforms.debug then 
CreateThread(function()
    while true do 
        print("Total:"..Scaleforms.GetTotal())
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
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.main.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.main.Handles) do 
            count = count + 1
        end 
        Scaleforms.main.counts = count
    end 
    return Scaleforms.main.Handles[scaleformName]
end)
exports('DrawScaleformMovie', function (scaleformName,...)
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        --[=[
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.main.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.main.Handles) do 
            count = count + 1
        end 
        Scaleforms.main.counts = count
        --]=]
        error('Scaleforms:DrawScaleformMovie error,Please CallScaleformMovie first',2)
        return 
    end 
    if Scaleforms.main.Handles[scaleformName] then 
        local ops = {...}
        if #ops > 1 then 
            Threads.CreateLoopOnce('scaleforms:draw',0,function()
                if Scaleforms.main.counts == 0 then 
                    Threads.KillActionOfLoop('scaleforms')
                end 
                for i = 1,#(Scaleforms.main.Tasks) do
                    Scaleforms.main.Tasks[i]()
                end 
            end)
            Scaleforms.main.temp_tasks[scaleformName] = function()
                if Scaleforms.main.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.main.Handles[scaleformName])
                    Scaleforms.main.Handles[scaleformName] = nil 
                    Scaleforms.main.Kill[scaleformName] = nil
                    Scaleforms.main.counts = Scaleforms.main.counts - 1
                    Scaleforms.main.temp_tasks[scaleformName] = nil
                elseif Scaleforms.main.Handles[scaleformName] then
                    if #ops > 1 then 
                    SetScriptGfxDrawOrder(ops[#ops])
                    end 
                    DrawScaleformMovie(Scaleforms.main.Handles[scaleformName], table.unpack(ops))
                    ResetScriptGfxAlign()
                end 
            end 
            local task = {}
            for i,v in pairs (Scaleforms.main.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.main.Tasks = task
        else 
            Threads.CreateLoopOnce('scaleforms:draw',0,function()
                if Scaleforms.main.counts == 0 then 
                    Threads.KillActionOfLoop('scaleforms:draw')
                end 
                for i = 1,#(Scaleforms.main.Tasks) do
                    Scaleforms.main.Tasks[i]()
                end 
            end)
            Scaleforms.main.temp_tasks [scaleformName] = function()
                if Scaleforms.main.Kill[scaleformName] then  
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.main.Handles[scaleformName])
                    Scaleforms.main.Handles[scaleformName] = nil 
                    Scaleforms.main.Kill[scaleformName] = nil
                    Scaleforms.main.counts = Scaleforms.main.counts - 1
                    Scaleforms.main.temp_tasks[scaleformName] = nil
                elseif Scaleforms.main.Handles[scaleformName] then 
                    
                    if #ops == 1 then 
                    
                    SetScriptGfxDrawOrder(ops[1])
                    end 
                    DrawScaleformMovieFullscreen(Scaleforms.main.Handles[scaleformName])
                    ResetScriptGfxAlign()
                    
                end 
            end
            local task = {}
            for i,v in pairs (Scaleforms.main.temp_tasks ) do
                table.insert(task,v)
            end 
            Scaleforms.main.Tasks = task
        end 
    end 
end )

exports('DrawScaleformMovieDuration', function (scaleformName,duration,...)
    local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.main.DrawScaleformMovie(scaleformName,table.unpack(ops))
        Scaleforms.main.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        
        Threads.CreateLoopOnce("ScaleformDuration"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.main.ReleaseTimer[scaleformName] then 
                Scaleforms.main.KillScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                
                Threads.KillActionOfLoop("ScaleformDuration"..scaleformName,333);
            end 
        end)
    end)
end )

exports('EndScaleformMovie', function (scaleformName)
    if not Scaleforms.main.Handles[scaleformName] then 
    else 
        Scaleforms.main.Kill[scaleformName] = true
        SetScaleformMovieAsNoLongerNeeded(Scaleforms.main.Handles[scaleformName])
        Scaleforms.main.Handles[scaleformName] = nil 
        Scaleforms.main.counts = Scaleforms.main.counts - 1
        Scaleforms.main.temp_tasks[scaleformName] = nil
    end 
end )



exports('RequestScaleformCallbackString', function (scaleformName,SfunctionName,...) 
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.main.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.main.Handles) do 
            count = count + 1
        end 
        Scaleforms.main.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.main.Handles[scaleformName],SfunctionName) --call function
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
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.main.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.main.Handles) do 
            count = count + 1
        end 
        Scaleforms.main.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.main.Handles[scaleformName],SfunctionName) --call function
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
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        Threads.CreateLoad(scaleformName,RequestScaleformMovie,HasScaleformMovieLoaded,function(handle)
            Scaleforms.main.Handles[scaleformName] = handle
        end)
        local count = 0
        for i,v in pairs(Scaleforms.main.Handles) do 
            count = count + 1
        end 
        Scaleforms.main.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.main.Handles[scaleformName],SfunctionName) --call function
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


exports('GetTotal',function()
    return Scaleforms and Scaleforms.main and Scaleforms.main.counts or 0
end)

