return function (path)
    local file = io.open (path, "r")
    if file then
        tex.sprint ("\\input{".. path .."}")
    else
        tex.sprint ("\\TODO{".. path .." unavailable}")
    end
end
