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
Scaleforms.main.CallScaleformMovie = function (scaleformName)
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
end 
Scaleforms.main.DrawScaleformMovie = function(scaleformName,...)
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        error('Scaleforms:DrawScaleformMovie error,Please CallScaleformMovie first',2)
        return 
    else 
        local ops = {...}
        if #ops > 1 then 
            Threads.CreateLoopOnce('scaleforms:draw:'..scaleformName,0,function()
                if Scaleforms.main.Handles[scaleformName] then 
                    SetScriptGfxDrawOrder(ops[#ops])
                    DrawScaleformMovie(Scaleforms.main.Handles[scaleformName], table.unpack(ops))
                    ResetScriptGfxAlign()
                else 
                    if Threads.IsActionOfLoopAlive('scaleforms:draw:'..scaleformName) then 
                        Threads.KillActionOfLoop('scaleforms:draw:'..scaleformName);
                    end 
                end 
            end)
        elseif #ops == 1 then  
            Threads.CreateLoopOnce('scaleforms:draw:'..scaleformName,0,function()
                if Scaleforms.main.Handles[scaleformName] then 
                    SetScriptGfxDrawOrder(ops[1])
                    DrawScaleformMovieFullscreen(Scaleforms.main.Handles[scaleformName])
                    ResetScriptGfxAlign()
                else 
                    if Threads.IsActionOfLoopAlive('scaleforms:draw:'..scaleformName) then 
                        Threads.KillActionOfLoop('scaleforms:draw:'..scaleformName);
                    end 
                end 
            end)
        else
            Threads.CreateLoopOnce('scaleforms:draw:'..scaleformName,0,function()
                if Scaleforms.main.Handles[scaleformName] then 
                    DrawScaleformMovieFullscreen(Scaleforms.main.Handles[scaleformName])
                else 
                    if Threads.IsActionOfLoopAlive('scaleforms:draw:'..scaleformName) then 
                        Threads.KillActionOfLoop('scaleforms:draw:'..scaleformName);
                    end 
                end 
            end)
        end 
    end 
end 
Scaleforms.main.DrawScaleformMovieDuration = function (scaleformName,duration,...)
local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.main.DrawScaleformMovie(scaleformName,table.unpack(ops))
        Scaleforms.main.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        Threads.CreateLoopOnce("ScaleformDuration"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.main.ReleaseTimer[scaleformName] then 
                Scaleforms.main.EndScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                Threads.KillActionOfLoop("ScaleformDuration"..scaleformName,333);
            end 
        end)
    end)
end
Scaleforms.main.EndScaleformMovie = function (scaleformName)
    if not Scaleforms.main.Handles[scaleformName] then 
    else 
        Scaleforms.main.Handles[scaleformName] = nil
    end 
end
Scaleforms.main.DrawScaleformMoviePosition = function (scaleformName,...)
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        --[=[
        Scaleforms.main.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.main.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
        --]=]
        error('Scaleforms:DrawScaleformMoviePosition error,Please CallScaleformMovie first',2)
        return 
    else
        local ops = {...}
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms3d:draw'..scaleformName,0,function()
                if Scaleforms.main.Handles[scaleformName] then 
                    DrawScaleformMovie_3d(Scaleforms.main.Handles[scaleformName], table.unpack(ops))
                else 
                    if Threads.IsActionOfLoopAlive("scaleforms3d:draw"..scaleformName) then 
                        Threads.KillActionOfLoop("scaleforms3d:draw"..scaleformName);
                    end 
                end 
            end)
        end 
    end 
end 
Scaleforms.main.DrawScaleformMoviePositionDuration = function (scaleformName,duration,...)
local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.main.DrawScaleformMoviePosition(scaleformName,table.unpack(ops))
        Scaleforms.main.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        Threads.CreateLoopOnce("ScaleformDuration3d"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.main.ReleaseTimer[scaleformName] then 
                Scaleforms.main.EndScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                Threads.KillActionOfLoop("ScaleformDuration3d"..scaleformName,333);
            end 
        end)
    end)
end
Scaleforms.main.DrawScaleformMoviePosition2 = function (scaleformName,...)
    if not Scaleforms.main.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) then 
        --[=[
        Scaleforms.main.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.main.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.main.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
        --]=]
        error('Scaleforms:DrawScaleformMoviePosition2 error,Please CallScaleformMovie first',2)
        return 
    else
        local ops = {...}
        if #ops > 0 then 
            Threads.CreateLoopOnce('scaleforms3d2:draw'..scaleformName,0,function()
                if Scaleforms.main.Handles[scaleformName] then 
                    DrawScaleformMovie_3dSolid(Scaleforms.main.Handles[scaleformName], table.unpack(ops))
                else 
                    if Threads.IsActionOfLoopAlive("scaleforms3d2:draw"..scaleformName) then 
                        Threads.KillActionOfLoop("scaleforms3d2:draw"..scaleformName);
                    end 
                end 
            end)
        end 
    end 
end 
Scaleforms.main.DrawScaleformMoviePosition2Duration = function (scaleformName,duration,...)
local ops = {...}
    local cb = ops[#ops]
    table.remove(ops,#ops)
    CreateThread(function()
        Scaleforms.main.DrawScaleformMoviePosition2(scaleformName,table.unpack(ops))
        Scaleforms.main.ReleaseTimer[scaleformName] = GetGameTimer() + duration
        Threads.CreateLoopOnce("ScaleformDuration3d2"..scaleformName,333,function()
            if GetGameTimer() >= Scaleforms.main.ReleaseTimer[scaleformName] then 
                Scaleforms.main.EndScaleformMovie(scaleformName);
                if type(cb) == 'function' then 
                    cb()
                end 
                Threads.KillActionOfLoop("ScaleformDuration3d2"..scaleformName,333);
            end 
        end)
    end)
end
exports('DrawScaleformMoviePosition2', function (scaleformName,...)
    return Scaleforms.main.DrawScaleformMoviePosition2(scaleformName,...)
end )
exports('DrawScaleformMoviePositionDuration', function (scaleformName,duration,...)
    return Scaleforms.main.DrawScaleformMoviePositionDuration(scaleformName,duration,...)
end)
exports('DrawScaleformMoviePosition2Duration', function (scaleformName,duration,...)
    return Scaleforms.main.DrawScaleformMoviePosition2Duration(scaleformName,duration,...)
end)
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
exports('RequestScaleformCallbackAny', function (scaleformName,SfunctionName,...) 
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
    local value = EndScaleformMovieMethodReturnValue()
    CreateThread(function()
        while not IsScaleformMovieMethodReturnValueReady(value) do
            Wait(0)
        end
        local returnString = GetScaleformMovieMethodReturnValueString(value)
        local returnInt = GetScaleformMovieMethodReturnValueInt(value)
        local returnBool = GetScaleformMovieMethodReturnValueBool(value)
        EndScaleformMovieMethod()
        if returnString ~= "" then
            cb(returnString)
            return 
        end
        if returnInt ~= 0 and not returnBool then
            cb(returnInt)
            return 
        end
        cb(returnBool)
        return 
    end)
end )
exports('CallScaleformMovie', function (scaleformName)
    return Scaleforms.main.CallScaleformMovie(scaleformName)
end)
exports('DrawScaleformMovie', function (scaleformName,...)
    Scaleforms.main.DrawScaleformMovie (scaleformName,...)
end )
exports('EndScaleformMovie', function (scaleformName)
    Scaleforms.main.EndScaleformMovie (scaleformName)
end )
exports('DrawScaleformMovieDuration', function (scaleformName,duration,...)
    return Scaleforms.main.DrawScaleformMovieDuration(scaleformName,duration,...)
end)
exports('DrawScaleformMoviePosition', function (scaleformName,...)
    return Scaleforms.main.DrawScaleformMoviePosition(scaleformName,...)
end)
exports('GetTotal',function()
    return Scaleforms and Scaleforms.main and Scaleforms.main.counts or 0
end)