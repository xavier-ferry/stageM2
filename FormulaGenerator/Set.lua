--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--

local Prop=require('Prop')

Set = {}

local mt = {}

function Set.new(a,taille)
    if a == nil then a = 'empty' end
    local res ={op='set',val=a}
    if taille == 1 then res.taille=1 end
    setmetatable(res,mt)
    return res
end

setmetatable(Set, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function mt.__add(a,b)
    local res ={op='+',val1=a,val2=b}
    setmetatable(res,mt)
    return res
end

function mt.__mul(a,b)
    local res ={op='*',val1=a,val2=b}
    setmetatable(res,mt)
    return res
end

function mt.__sub(a,b)
    local res ={op='-',val1=a,val2=b}
    setmetatable(res,mt)
    return res
end

function Set.egal(a,b)
    local res ={op='egal',val1=a,val2=b}
    Prop.set(res)
    return res
end

function Set.negal(a,b)
    local res ={op='negal',val1=a,val2=b}
    Prop.set(res)
    return res
end
function Set.non(a)
    local res ={op='non', val = a }
    Prop.set(res)
    return res
end

function Set.affectUnion(a,b,c)
    local res ={op='Ex',val1=a,val2=b,val3=c}
    Prop.set(res)
    return res
end

function Set.appartient(a,b)
    local res = {op='appartient', val1 = a, val2 = b }
    Prop.set(res)
    return res
end

function Set.moinsProp(a,b)
    local res = {op='moinsProp', val1 = a, val2 = b }
    Prop.set(res)
    return res
end

function mt.__bxor(a,b)
    return Set.egal(a,b)
end


local function mytostring(a,res)
    if (type(a) == 'number') then
        res[#res+1] = a
    elseif (a.op == 'set') then
        res[#res+1] = a.val
    elseif (a.op == '+') then
        res[#res+1] = '(' .. tostring(a.val1) .. '+' .. tostring(a.val2) .. ')'
    elseif (a.op == '-') then
        res[#res+1] = '(' .. tostring(a.val1) .. '-' .. tostring(a.val2) .. ')'
    elseif (a.op == '*') then
        res[#res+1] = '(' .. tostring(a.val1) .. '*' .. tostring(a.val2) .. ')'
    else
        res[#res+1] = '('
        mytostring(a.val1,res)
        res[#res+1] = a.type
        mytostring(a.val2,res)
        res[#res+1] = ')'
    end
end

function mt.__tostring(a)
    local res ={}
    mytostring(a,res)
    return table.concat(res)
end

return Set