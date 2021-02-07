Scaleforms = {}
Scaleforms.temp_tasks = {}
Scaleforms.Tasks = {}
Scaleforms.Handles = {}
Scaleforms.Kill = {}

SendScaleformValues = function (...)
    local tb = {...}
    for i=1,#tb do
        if type(tb[i]) == "number" then 
            if math.type(tb[i]) == "integer" then
                    PushScaleformMovieFunctionParameterInt(tb[i])
            else
                    PushScaleformMovieFunctionParameterFloat(tb[i])
            end
        elseif type(tb[i]) == "string" then PushScaleformMovieFunctionParameterString(tb[i])
        elseif type(tb[i]) == "boolean" then PushScaleformMovieFunctionParameterBool(tb[i])
        end
    end 
end

RegisterNetEvent('CallScaleformMovie')
--[=[
--  TriggerEvent('CallScaleformMovie','TALK_MESSAGE',function(run,send,stop)  -- or function(run,send,stop,handle)
            run('SayToAll')
                send(1,2,3,4,5)
            stop()
    end )
--]=]

AddEventHandler('CallScaleformMovie', function(scaleformName,cb) 
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
       
        
        Scaleforms.counts = count
    end 
    local inputfunction = function(sfunc) PushScaleformMovieFunction(Scaleforms.Handles[scaleformName],sfunc) end
    cb(inputfunction,SendScaleformValues,PopScaleformMovieFunctionVoid,Scaleforms.Handles[scaleformName])

end)
RegisterNetEvent('RequestScaleformCallbackString')
AddEventHandler('RequestScaleformCallbackString', function(scaleformName,SfunctionName,...) 
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    cb = ops[#ops]
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

end)
RegisterNetEvent('RequestScaleformCallbackInt')
AddEventHandler('RequestScaleformCallbackInt', function(scaleformName,SfunctionName,...) 
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    cb = ops[#ops]
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

end)
RegisterNetEvent('RequestScaleformCallbackBool')
AddEventHandler('RequestScaleformCallbackBool', function(scaleformName,SfunctionName,...) 
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        Scaleforms.counts = count
    end 
    BeginScaleformMovieMethod(Scaleforms.Handles[scaleformName],SfunctionName) --call function
    local ops = {...}
    cb = ops[#ops]
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

end)




RegisterNetEvent('DrawScaleformMovie')
AddEventHandler('DrawScaleformMovie', function(scaleformName,...)
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        
        Scaleforms.counts = count
    end 
    if Scaleforms.Handles[scaleformName] then 
        local ops = {...}
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
                    
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
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
                    
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
                    
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
    end 
    
end)

RegisterNetEvent('DrawScaleformMoviePosition')
AddEventHandler('DrawScaleformMoviePosition', function(scaleformName,...)
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        
        Scaleforms.counts = count
    end 
    if Scaleforms.Handles[scaleformName] then 
    
        local ops = {...}
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
                    
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
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
    end 
    
end)

RegisterNetEvent('DrawScaleformMoviePosition2')
AddEventHandler('DrawScaleformMoviePosition2', function(scaleformName,...)
    if not Scaleforms.Handles[scaleformName] or not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) then 
        Scaleforms.Handles[scaleformName] = RequestScaleformMovie(scaleformName)
        while not HasScaleformMovieLoaded(Scaleforms.Handles[scaleformName]) do 
            Wait(0)
        end 
        local count = 0
        for i,v in pairs(Scaleforms.Handles) do 
            count = count + 1
        end 
        
        Scaleforms.counts = count
    end 
    if Scaleforms.Handles[scaleformName] then 
    
        local ops = {...}
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
                    
                    Scaleforms.Handles[scaleformName] = nil 
                    Scaleforms.Kill[scaleformName] = nil
                    Scaleforms.counts = Scaleforms.counts - 1
                    SetScaleformMovieAsNoLongerNeeded(Scaleforms.Handles[scaleformName])
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
    end 
    
end)

RegisterNetEvent('EndScaleformMovie')
AddEventHandler('EndScaleformMovie', function(scaleformName)
    if not Scaleforms.Handles[scaleformName] then 
    
    else 
        Scaleforms.Kill[scaleformName] = true
    end 
end)
RegisterNetEvent('KillScaleformMovie')
AddEventHandler('KillScaleformMovie', function(scaleformName)
    if not Scaleforms.Handles[scaleformName] then 
    
    else 
        Scaleforms.Kill[scaleformName] = true
    end 
end)



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