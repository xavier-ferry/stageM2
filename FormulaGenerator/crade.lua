--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 21/06/2016
-- Time: 14:28
-- To change this template use File | Settings | File Templates.
--

--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:25
-- To change this template use File | Settings | File Templates.
--

require('config')
require('luaToMonaFunctions')

local file = io.open(outputMONAFile, "w")
io.output(file)

local pre = ""
local post = ""
local A = ""
local B = ""

for i=0, gamma do
    pre = pre .. "Pre" ..i .. ", "
    post = post .. "Post" ..i .. ", "
    A = A .. "A" ..i .. ", "
    B = B .. "B" ..i .. ", "

end

local AB = A .. B
A = A:sub(1,-3)
B = B:sub(1,-3)
AB = AB:sub(1, -3)

local prePost = pre .. post
pre = pre:sub(1,-3)
post = post:sub(1,-3)
prePost = prePost:sub(1, -3)


function cond(foo)
    local txt = ""
    print(tostring(foo))
    for _,value in pairs(foo) do
        if (type(value) ~= table)then
            return var(value)
        else

            for type,val in pairs(value) do
                if(type == "type" and val == "egal") then
                    print("foo, type egal! ", tostring(value))
                    txt = txt .. egal(value["val1"],value["val2"])
                elseif (type == "val") then
                    return "x in "..val
                end
            end
        end

    end
    return txt
end



local function initial(foo)
    headerFonction("initial", foo)
    addTexte(cond(foo))
end


local function final(foo)
    headerFonction("final", foo)
    --    decoup(foo)

end


local function choixTransition(foo)
    for label, value in pairs(foo) do
        print(tostring(label))
    end
end

local function decomp(automate)
    initial(automate.initial)
    --    final(automate.final)
    --    choixTransition(automate.transitions)
end


--decomp(automate)
--[[
local function test(automate)
    print("automate", automate, automate["val1"],automate["val2"],automate["val"])
    for k,v in pairs(automate) do
        print(k, v, type(v))
        if ( type(v) == "string" and k ~= "type")then
            print("-----------return 1",k,v)
--            return 1
        elseif (type(v) ~= "string") then
            test(v)
--            return 0
        else
            print("     v est un string", v)
--            return 999
        end
    end

end]]
--test(automate.initial)
--print("return final = " .. tostring(test(automate.initial)))



function var(val)
    return "x in "..tostring(val)
end

function egal(val1, val2)
    print("EGAL !! ", val1, val2)


    return cond(val1).. " <=> " ..cond(val2)
end

function addTexte(txt)
    io.write(txt)
end

function declinerVariable(foo)
    local toWrite = ""
    for i = 0, gamma do
        if ( tostring(foo) ~= "empty" )then
            toWrite = toWrite  .. tostring(foo) .. i .. ", "
        end
    end
    toWrite = toWrite:sub(1,-3)
    return toWrite
end

function headerFonction(nomFonction, foo)
    local res =""
    for _,superValue in pairs(foo) do
        for label,value in pairs(superValue) do
            if ( label ~= "type" and value ~= "empty" )then
                res = res .. declinerVariable(value)
            end
        end
        res = res .. ", "
    end
    res = res:sub(1,-3)
    addTexte("pred "..nomFonction.." (var2 "..res..")=\n  ")
end


function lireExpr(value)
    local txt, res = "" ,""
    for i = 0,gamma do
        local tmp = tostring(value)
        tmp = string.gsub(tmp, "A", "A"..i)
        tmp = string.gsub(tmp, "B", "B"..i)
        tmp = string.gsub(tmp, "Pre", "Pre"..i)
        tmp = string.gsub(tmp, "Post", "Post"..i)
        txt = txt .. tmp .. " & "
    end
    res = res .. txt
    return res
end
--
--function decoup(foo)
--    local toWrite =""
--    for _, value in pairs(foo) do
--        toWrite = toWrite .. lireExpr(value)
--    end
--    toWrite = toWrite:sub(1,-3)
--    addTexte(toWrite)
--    addTexte("\n;\n\n")
--end




--function cond(foo)
--    local txt = ""
--    for t,value in pairs(foo) do
--        if (type(value) == "string") then
--            return tostring(foo)
--        else
--            for type,val in pairs(value) do
--                if(type == "type" and val == "egal") then
--                    txt = txt .. egal(value)
--                elseif (type == "val") then
--                    return "x in "..val
--                end
--            end
--        end
--    end
--    return txt
--end
