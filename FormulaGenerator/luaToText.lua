--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:25
-- To change this template use File | Settings | File Templates.
--

require('config')

file = io.open(outputTXTFile, "w")
io.output(file)

texte = ""

local function addTexte(txt)
    io.write(txt)
end

local function decoup(foo)
    local res = ""
    for _, value in pairs(foo) do
        res = res .. (tostring(value) .. " & ")
    end
    res = res:sub(1,-3)
    return res
end




local function initial(auto)
    local res = 'Initial:\n'
    res = res .. decoup(auto) .. '\n'
    return res
end


local function final(auto)
    local res = 'Final:\n'
    res = res .. decoup(auto) .. '\n'
    return res
end



local function transitions(automate)
    local res = 'Transitions:\n'
    for i in pairs(automate.transitions) do
        res = res ..'\n'..i .. ' :\n '
        res = res .. decoup(automate.transitions[i].Conditions)
    end
    res = res .. '\n'
    return res
end


local function automateToString(automate)
    local res = ''
    res = res .. initial(automate.initial)
            .. final(automate.final)
            .. transitions(automate)
    addTexte(res)
end

automate = returnAuto(1)
automateToString(automate)