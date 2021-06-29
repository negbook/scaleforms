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
end 

Scaleforms.CallScaleformMovie = function(scaleformName,cb) 
    local handle = exports.scaleforms:CallScaleformMovie(scaleformName) 
    local inputfunction = function(sfunc) PushScaleformMovieFunction(handle,sfunc) end
    cb(inputfunction,SendScaleformValues,PopScaleformMovieFunctionVoid,handle)
end
Scaleforms.DrawScaleformMovie = function(scaleformName,...)
    exports.scaleforms:DrawScaleformMovie(scaleformName,...)
end
Scaleforms.EndScaleformMovie = function(scaleformName)
    exports.scaleforms:EndScaleformMovie(scaleformName)
end
Scaleforms.KillScaleformMovie = Scaleforms.EndScaleformMovie

Scaleforms.RequestScaleformCallbackString = function(scaleformName,SfunctionName,...) 
    exports.scaleforms:RequestScaleformCallbackString(scaleformName,SfunctionName,...) 
end
Scaleforms.RequestScaleformCallbackInt = function(scaleformName,SfunctionName,...) 
    exports.scaleforms:RequestScaleformCallbackInt(scaleformName,SfunctionName,...) 
end
Scaleforms.RequestScaleformCallbackBool = function(scaleformName,SfunctionName,...) 
    exports.scaleforms:RequestScaleformCallbackBool(scaleformName,SfunctionName,...) 
end
Scaleforms.DrawScaleformMovieDuration = function(scaleformName,duration,...)
    exports.scaleforms:DrawScaleformMovieDuration(scaleformName,duration,...)
end

Scaleforms.GetScaleformsTotal = function()
    return exports.scaleforms:GetScaleformsTotal()
end

