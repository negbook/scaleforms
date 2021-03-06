this = {}
this.scriptName = "scaleforms"
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


if GetCurrentResourceName() ~= this.scriptName then 
Scaleforms = {}
ThisScriptsScaleforms = {}
end 

AddEventHandler('onResourceStop', function(resourceName)
   
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  --print(this.scriptName,resourceName,GetCurrentResourceName() ,ThisScriptsScaleforms)
  --print('The resource ' .. resourceName .. ' was stopped.')
  if resourceName ~= this.scriptName then 
      for i,v in pairs( ThisScriptsScaleforms ) do 
        --print(i,v)
        Scaleforms.EndScaleformMovie(i)
      end 
  end 
end)

Scaleforms.CallScaleformMovie = function(scaleformName,cb) 
    if GetCurrentResourceName() ~= this.scriptName then 
        ThisScriptsScaleforms[scaleformName] = true 
    end 
    local handle = exports.scaleforms:CallScaleformMovie(scaleformName) 
    local inputfunction = function(sfunc) PushScaleformMovieFunction(handle,sfunc) end
    cb(inputfunction,SendScaleformValues,PopScaleformMovieFunctionVoid,handle)
end
Scaleforms.DrawScaleformMovie = function(scaleformName,...)
    exports.scaleforms:DrawScaleformMovie(scaleformName,...)
end
Scaleforms.DrawScaleformMovieDuration = function(scaleformName,duration,...)
    exports.scaleforms:DrawScaleformMovieDuration(scaleformName,duration,...)
end
Scaleforms.EndScaleformMovie = function(scaleformName)
    exports.scaleforms:EndScaleformMovie(scaleformName)
end; Scaleforms.KillScaleformMovie = Scaleforms.EndScaleformMovie
Scaleforms.RequestScaleformCallbackAny = function(scaleformName,SfunctionName,...) 
    exports.scaleforms:RequestScaleformCallbackAny(scaleformName,SfunctionName,...) 
end
Scaleforms.RequestScaleformCallbackString = function(scaleformName,SfunctionName,...) 
    exports.scaleforms:RequestScaleformCallbackString(scaleformName,SfunctionName,...) 
end
Scaleforms.RequestScaleformCallbackInt = function(scaleformName,SfunctionName,...) 
    exports.scaleforms:RequestScaleformCallbackInt(scaleformName,SfunctionName,...) 
end
Scaleforms.RequestScaleformCallbackBool = function(scaleformName,SfunctionName,...) 
    exports.scaleforms:RequestScaleformCallbackBool(scaleformName,SfunctionName,...) 
end
Scaleforms.DrawScaleformMoviePosition = function(scaleformName,...) 
    exports.scaleforms:DrawScaleformMoviePosition(scaleformName,...) 
end
Scaleforms.DrawScaleformMoviePosition2 = function(scaleformName,...) 
    exports.scaleforms:DrawScaleformMoviePosition2(scaleformName,...) 
end
Scaleforms.DrawScaleformMoviePositionDuration = function(scaleformName,duration,...)
    exports.scaleforms:DrawScaleformMoviePositionDuration(scaleformName,duration,...)
end
Scaleforms.DrawScaleformMoviePosition2Duration = function(scaleformName,duration,...)
    exports.scaleforms:DrawScaleformMoviePosition2Duration(scaleformName,duration,...)
end

Scaleforms.DrawScaleformMovie3DSpeical = function(scaleformName,ped,...) 
    exports.scaleforms:DrawScaleformMovie3DSpeical(scaleformName,ped,...) 
end




Scaleforms.GetTotal = function()
    return exports.scaleforms:GetTotal()
end

