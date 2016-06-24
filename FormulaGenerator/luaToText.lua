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
    local txt = ""
    for _, value in pairs(foo) do
        txt = txt .. (tostring(value) .. " & ")
    end

    txt = txt:sub(1, -3) .. "\n"
    addTexte(txt)
end


local function initial(auto)
    addTexte("Initial:\n")
    decoup(auto)
    addTexte("\n")
end


local function final(auto)
    addTexte("Final:\n")
    decoup(auto)
    addTexte("\n")
end

local function trans(t)
    decoup(t.Conditions)
    decoup(t.Trans)
end


local function transitions(automate)
    addTexte("Transitions:\n")
    for i in pairs(automate.transitions) do
        addTexte("\n"..i .. " :\n ")
        trans(automate.transitions[i])
    end
    addTexte("\n")
end


local function decomp(automate)
    initial(automate.initial)
    final(automate.final)
    transitions(automate)
end


decomp(automate)