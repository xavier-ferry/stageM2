--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 16/06/2016
-- Time: 16:11
-- To change this template use File | Settings | File Templates.
--
function deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end


function addTexte(txt)
    io.write(txt)
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end


function table.containsString(table, element)
    for _, value in pairs(table) do
        if value.val == element then
            return true
        end
    end
    return false
end

function declinerVariables(...)
    local args = {... }
    local res = ""
    for i =1 , #args do
        for j =1 , gamma do
            res = res .. args[i] ..tostring(j)..", "
        end
    end
    res = res:sub(1,-3)
    return res
end

function debug(automate)
    infile = io.open(outputMONAFile, "r")
    instr = infile:read("*a")
    infile:close()

    outfile = io.open(outputDEBUGMONAfile, "w")
    outfile:write(instr)
    outfile:close()

    local fileComp = io.open(outputCOMPMONAfile, "w")
    props = tostring(automate.proprietes.props[1])..','
    if (automate.proprietes.props[2] ~= nil ) then
        props = props .. tostring(automate.proprietes.props[2])..','
    end
    props = props:sub(1,-2)
    res = ' include "../operateurs.mona";\n'..
            'include "debug.mona";\n\n'..
            'pred systemComp(var2 '..automate.proprietes.aVerifier[1]..','..props..','..declinerVariables('Pre','Post')..',Mot) =\n' ..
            '~(preUnique('..declinerVariables('Pre')..',Mot) => (transitions('..automate.proprietes.aVerifier[1]..','..props..
            ','..declinerVariables('Pre','Post')..',Mot) <=> '..automate.proprietes.aVerifier[1]..'P('..automate.proprietes.aVerifier[1]..','..
            props..','..declinerVariables('Pre','Post')..',Mot)))\n;\n\n'


    res = res .. 'pred systemCompTEST(var2 '..automate.proprietes.aVerifier[1]..','..props..','..declinerVariables('Pre','Post')..',Mot) =\n'..
            'transitions('..automate.proprietes.aVerifier[1]..','..props.. ','..declinerVariables('Pre','Post')..',Mot)\n;\n\n'


    res = res .. 'var2 '..automate.proprietes.aVerifier[1]..', '..props..', '.. declinerVariables('Pre','Post')..', Mot;\n'..
            '#Mot = {0,1,2};\n'..
            'systemComp('..automate.proprietes.aVerifier[1]..', '..props..', '.. declinerVariables('Pre','Post')..', Mot);\n'
    fileComp:write(res)
    fileComp:close()
end