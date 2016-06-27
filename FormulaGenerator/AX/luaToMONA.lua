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

local aVerif = automate.proprietes.aVerifier[1]
local prop1  = automate.proprietes.props[1]
local prop2  = automate.proprietes.props[2]
local props
if (prop2 ~= nil ) then props = prop1 ..','..prop2 else props = prop1 end


local function replacePrime(txt)
    txt = string.gsub(txt, "x in A'", "x+1 in A")
    txt = string.gsub(txt, "x in B'", "x+1 in B")
    return txt
end


local function concat(contrainte,x,op, bLeft, aRight,option)
    bLeft = bLeft or ''
    aRight = aRight or ''
    local ind = 0
    if( option.indice ~= nil) then ind = option.indice else ind = option.i end

    local left,right = "",""
    if ( contrainte.val1.val ~= nil) then
        left = x .. " in ".. contrainte.val1.val
--        Si val vaut empty, on ajouter pas le i derriere
        if (table.containsString(automate.proprietes.nePasDecliner,contrainte.val1.val) == false ) then
            left = left ..tostring(ind) end
    else
        left = lireContrainte(contrainte.val1,option)
        left = left:sub(1,-4)
    end

    if ( contrainte.val2.val ~= nil) then
        right = x .. " in ".. contrainte.val2.val
--        Si val vaut empty, on ajouter pas le i derriere
        if (table.containsString(automate.proprietes.nePasDecliner,contrainte.val2.val) == false ) then
            right = right ..tostring(ind) end
    else
        right = lireContrainte(contrainte.val2,option)
        right = right:sub(1,-4)
    end

    return "(" .. bLeft..left .. op ..right ..aRight..")"

end

--for i = 1, gamma do
--    option.i = i
--    res = res .. lireContrainte(v,option)
--end
function exist(contrainte,option)
    local res = ''
    local i = option.i
    if i == 1 then res = res .. '(' end
    res = res .. '('
    for j = 1,gamma do
        option.indice = j
        if i == j then
            res = res .. lireContrainte(contrainte.val1,option)
                    ..lireContrainte(contrainte.val3,option)
          else
            res = res .. '('
            res = res .. lireContrainte(contrainte.val1,option)
            res = res:sub(1,-3)
            option.indice = i
            res =  res .. " <=> " .. lireContrainte(contrainte.val2,option)
            res = res:sub(1,-4)
            res = res ..') & '
        end
    end
    res = res:sub(1,-4)
    res = res .. ")| \n"

    if i == gamma then
        res = res:sub(1,-4)
        res = res .. ') &\n'
    end
    --    res = res:sub(1,-4)
    return res
end


function lireContrainte(contrainte, option)
    local op,left,right = '','',''
    local x = option.x or "x"
    if (contrainte["op"] == "+") then
        op = "|"
    elseif (contrainte["op"] == "egal") then
        op = " <=> "
    elseif (contrainte["op"] == "-") then
        op = " & ~("
        left = ''
        right =")"
    elseif (contrainte["op"] == "*") then
        op = " & "
    elseif (contrainte["op"] == "negal") then
        op = " & "
        left = '~('
        right =')'
    elseif (contrainte["op"] == "~" ) then
        op = ""
        left = '~('
        right = ')'
    elseif (contrainte["op"] == "non" ) then
        op = ""
        left = '~('
        right = ') & '
        local res = lireContrainte(contrainte.val,option)
        res = res:sub(1,-4)
        return left .. res .. right
    elseif (contrainte["op"] == "Ex") then
        return exist(contrainte,option)
    else
        local ind =''
        if (option.indice ~= nil ) then ind = tostring(option.indice) else ind ='' end
        return x.." in "..tostring(contrainte) ..ind..  ' & '
    end
    left = option.left .. left
    right = option.right ..right

    local optionBis = deepCopy(option)
    optionBis.left = ''
    optionBis.right = ''

    return concat(contrainte,x, op,left,right,optionBis) .. " & \n"
end


local function generateHeader(auto)
    if (auto == automate.initial) then
        return "pred initial(var2 "..declinerVariables("A","B").. ",Mot) =\n"
    elseif (auto == automate.final) then
        local res =  "pred final(var2 "..declinerVariables("B").. ",Mot) = \n "
        res = res .. "  all1 x : \n     (x+1 in Mot => x in Mot) &\n"..
                '(x in B1 => x in Mot) &\n'..
                '(x in B2 => x in Mot) \n;\n'
        return res
    end
    for k,v in pairs(automate.transitions) do
        if (table.contains(v, auto)) then
            return "pred "..k.."(var1 x, var2 "..declinerVariables("A","B","Pre","Post")..
                    ","..props..','..aVerif..",Mot)=\n"
        end
    end

    return ""
end

local function lireAutomate(auto)
    local option = {
        x,
        left = '',
        right = ''
    }

    if ( auto == automate.initial) then
        option.x = '0'
        option.left = option.x .. ' in Mot => ('
        option.right = ')'
    end

    local res = ""
    res = res .. generateHeader(auto)
    for _,v in pairs(auto) do
        for i = 1, gamma do
            option.i = i
            res = res .. lireContrainte(v,option)
        end
    end
    res = res:sub(1,-4) .. "\n;\n\n"
    res = replacePrime(res)
    addTexte(res)
end

local function choixTransition()
    local res ='pred transitions(var2 '..declinerVariables('Pre','Post')..
    ","..props..','..aVerif..',Mot)=\n'
    res = res .. 'ex2 ' .. declinerVariables('A','B')..' :((\n'
            ..'(all1 x :\n'
            ..'x in Mot => (\n'
    for k,_ in pairs(automate.transitions) do
        res = res ..k.."(x,"..declinerVariables("A","B","Pre","Post")..
                ","..props..','..aVerif..",Mot) |\n"
    end
    res = res:sub(1,-3)
    res = res .. ')) & \n'
        .. 'final('..declinerVariables('B')..',Mot) & initial('..
            declinerVariables('A','B')..',Mot)))\n;\n\n'
    addTexte(res)
end

local function system()
    local res = 'pred system(var2 AX)=\n'..
    'ex2 Pre1, Pre2, Post1, Post2, P, Mot:\n'..
    'P={3,5} &\n'..
    'Pre1={1,2,3,4,5} &\n'..
    'Post1 = {0,2,3} &\n'..
    'Pre2={3,5} &\n'..
    'Post2 = {0,3,4} &\n'..
    'Mot = {0,1,2,3,4,5} &\n'..
    'transitions(Pre1, Pre2, Post1, Post2,P,AX, Mot);\n\n'..
    'var2 AX; system(AX);'
    addTexte(res)
end

local function generateMona()
    lireAutomate(automate.final)
    lireAutomate(automate.initial)
    for _,v in pairs(automate.transitions) do
        lireAutomate(v.Conditions)
    end
    choixTransition()
    system()
end


generateMona()
