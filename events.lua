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
RegisterNetEvent('DrawScaleformMovie3DSpeical')
AddEventHandler('DrawScaleformMovie3DSpeical', function(scaleformName,ped,...) 
    Scaleforms.DrawScaleformMovie3DSpeical(scaleformName,ped,...) 
end)

AddEventHandler('CallScaleformMovie', function(scaleformName,cb) 
    Scaleforms.CallScaleformMovie(scaleformName,cb) 
end)
AddEventHandler('RequestScaleformCallbackString', function(scaleformName,SfunctionName,...) 
    Scaleforms.RequestScaleformCallbackString(scaleformName,SfunctionName,...) 
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