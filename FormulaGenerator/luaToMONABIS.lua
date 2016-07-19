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

automate = returnAuto(1)


local aVerif = automate.proprietes.aVerifier[1]
local prop1  = automate.proprietes.props[1]
local prop2  = automate.proprietes.props[2]
local props
if (prop2 ~= nil ) then props = prop1 ..','..prop2 else props = prop1 end


local function replacePrime(txt)
    txt = string.gsub(txt, "x in A'", "x+1 in A")
    txt = string.gsub(txt, "x in B'", "x+1 in B")
    txt = string.gsub(txt, "x in Xa'", "x+1 in Xa")
    return txt
end


local function concat(contrainte,x,op, bLeft, aRight,option)
    bLeft = bLeft or ''
    aRight = aRight or ''
    local ind = 0
    if( option.indice ~= nil) then ind = option.indice else ind = option.i end

    local left,right = "",""
    if type(contrainte.val1) ~= 'number' then -- Dans le cas où on effectue un Set.appartient
        if ( contrainte.val1.val ~= nil) then
            left = x .. " in ".. contrainte.val1.val
    --        Si val vaut empty, on ajoute pas le i derriere
            if (table.containsString(automate.proprietes.nePasDecliner,contrainte.val1.val) == false ) then
                left = left ..tostring(ind) end
        else
            left = lireContrainte(contrainte.val1,option)
            left = left:sub(1,-4)
        end
    end


    if type(contrainte.val2) == 'number' then -- Dans le cas où on effectue un Set.moinsProp
        op = ' - '
        right = tostring(contrainte.val2)
    else
        if ( contrainte.val2.val ~= nil) then
            right = option.x .. " in ".. contrainte.val2.val
    --        Si val vaut empty, on ajoute pas le i derriere
            if (table.containsString(automate.proprietes.nePasDecliner,contrainte.val2.val) == false ) then
                right = right ..tostring(ind) end
        else
            right = lireContrainte(contrainte.val2,option)
            right = right:sub(1,-4)
        end
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
--            option.indice = i
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
    option.indice = nil
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
    elseif (contrainte["op"] == "appartient" ) then
        op = ""
        option.x = tostring(contrainte.val1)
        left = ''
        right = ''
    elseif (contrainte["op"] == "moinsProp" ) then
        op = ""
        option.x = tostring(contrainte.val1)
        left = ''
        right = ''
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

    local res = concat(contrainte,x, op,left,right,optionBis) .. " & \n"
    option.x = nil
    return res
end


local function generateHeader(auto)
    if (auto == automate.initial) then
        return "pred initial(var2 "..declinerVariables("A","B").. ",Mot) =\n"
    elseif (auto == automate.final) then
        local res =  "pred final(var2 "..declinerVariables(tostring(automate.final[1])).. ",Mot) = \n "
        res = res .. "  all1 x : \n     (x+1 in Mot => x in Mot) &\n"
        for i = 1, gamma do
            res = res .. '(x in '..automate.final[1]..i..' => x in Mot) &\n'
            end
        res = res :sub(1,-4)
        res = res .. '\n;\n'
        return res
    end
    for k,v in pairs(automate.transitions) do
        if (table.contains(v, auto)) then
            return "pred "..k.."(var1 x, var2 "..aVerif..','..props..','..declinerVariables("A","B","Pre","Post")..
                    ",Mot)=\n"
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
    if ( auto == automate.final) then
        res = res .. '\n'
        addTexte(res)
    else
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

end

local function conditions()
    local res = 'pred conditions(var1 x, var2 '..declinerVariables('A','B','Pre','Post')..') =\n'
    for i = 1, gamma do
        res = res .. '~(x in A'..i..' & x in B'..i..') &\n'
    end
    res = res .. '(\n    '
    for i = 1, gamma do
            res = res .. '('
        for j = 1, gamma  do
            if j==i then
                res = res .. ' x in Pre'..i..' &'
            else
                res = res .. ' x notin Pre'..j..' &'
            end
        end
        res = res:sub(1,-3)
        res = res .. ' ) |\n    '
    end
--    res = res:sub(1,-2)
    res = res .. 'x notin ('
    for i = 1,gamma do
        res = res ..'Pre'..i..' union '
    end
    res =res:sub(1,-8)
    res = res .. ')\n);\n\n'
    addTexte(res)
end
local function choixTransition()
    local res ='pred transitions(var2 '..aVerif..','..props..','..declinerVariables('Pre','Post')
            ..',Mot)=\n'
    res = res .. 'ex2 ' .. declinerVariables('A','B')..' :((\n'
            ..'(all1 x :\n'
            ..'x in Mot => ( conditions(x,'..declinerVariables('A','B','Pre','Post')..') & (\n'
    for k,_ in pairs(automate.transitions) do
        res = res ..k.."(x,"..aVerif..','..props..','..declinerVariables("A","B","Pre","Post")..",Mot) |\n"
    end
    res = res:sub(1,-3)
    res = res .. ')\n)) & \n'
            .. 'final('..declinerVariables(automate.final[1])..',Mot) & initial('..
            declinerVariables('A','B')..',Mot)\n))\n;\n\n'
    addTexte(res)
end


local function DEBUGchoixTransition()
    local res ='pred transitionsAB(var2 '..aVerif..','..props..','..declinerVariables('Pre','Post','A','B')
            ..',Mot)=\n'
    res = res ..'(all1 x :\n'
            ..'x in Mot => ( conditions(x,'..declinerVariables('A','B','Pre','Post')..') & (\n'
    for k,_ in pairs(automate.transitions) do
        res = res ..k.."(x,"..aVerif..','..props..','..declinerVariables("A","B","Pre","Post")..",Mot) |\n"
    end
    res = res:sub(1,-3)
    res = res .. ')\n)) & \n'
            .. 'final('..declinerVariables(automate.final[1])..',Mot) & initial('..
            declinerVariables('A','B')..',Mot)\n;\n\n'
    addTexte(res)
end


local function system()
    local res = 'pred system(var2 '..aVerif..')=\n'..
            'ex2 '..declinerVariables("Pre","Post")..','..props..', Mot:\n'..
            'Mot = {0,1,2,3} &\n'..
            'transitions('..aVerif..','..props..','..declinerVariables("Pre","Post")..', Mot);\n\n'..
            'var2 '..aVerif..'; system('..aVerif..');'
    addTexte(res)
end

local function generateMona()
    automate = returnAuto(1)
    lireAutomate(automate.final)
    lireAutomate(automate.initial)
    for _,v in pairs(automate.transitions) do
        lireAutomate(v.Conditions)
    end
    conditions()
    choixTransition()

    if debugON == true  then
        print("Debug activé ?",debugON)
        DEBUGchoixTransition()
        debug(automate)
    end

    system()
end


generateMona()
io.close()
