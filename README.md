# fxserver-scaleforms
Scaleforms utilities for FXServer



[DEPENDENCIES]

[Threads](https://forum.cfx.re/t/lib-threads-good-for-loops/2089076)



[INSTALLATION] 

add this line to your server.cfg

```
start scaleforms
```

[EVENTS]
```
    CallScaleformMovie (scaleformName,cb)  cb -> (starterfunc,sendfunc,senderendfunc,scaleformhandle)
    DrawScaleformMovie (scaleformName) or (scaleformName,x,y,width,height)
    DrawScaleformMoviePosition just like DrawScaleformMovie_3d
    DrawScaleformMoviePosition2 just like DrawScaleformMovie_3dSolid
    EndScaleformMovie (scaleformName) 
    DrawScaleformMovieDuration -- same of above but kill after milliseconds and cb
    DrawScaleformMoviePositionDuration -- same of above but kill after milliseconds and cb
    DrawScaleformMoviePosition2Duration -- same of above but kill after milliseconds and cb
    
    
```


[EXAMPLE]

```

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
            --[[
            TriggerEvent('DrawScaleformMoviePosition2','mp_car_stats_02',x,y+1.0,z+3.0,0.0,0.0,0.0,1.0, 1.0, 1.0, 5.0, 5.0, 5.0, 1)
                CreateThread(function()
                Wait(5000)
                TriggerEvent('EndScaleformMovie','mp_car_stats_01')
                TriggerEvent('EndScaleformMovie','mp_car_stats_02')
                end)
            end )
            --]]
            TriggerEvent('DrawScaleformMoviePosition2Duration','mp_car_stats_02',5000,x,y+1.0,z+3.0,0.0,0.0,0.0,1.0, 1.0, 1.0, 5.0, 5.0, 5.0, 1,function()
                    TriggerEvent('EndScaleformMovie','mp_car_stats_01')
                    --TriggerEvent('EndScaleformMovie','mp_car_stats_02')
            end)

    end )

end)
--]==]
```

