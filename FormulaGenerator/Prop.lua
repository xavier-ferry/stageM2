--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:26
-- To change this template use File | Settings | File Templates.
--

Prop = {}

local mt = {}

function Prop.new(a)
    local res ={op='prop',val=a}
    setmetatable(res,mt)
    return res
end

setmetatable(Prop, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function mt.__bor(a,b)
    local res ={op='|',val1=a,val2=b}
    setmetatable(res,mt)
    return res
end

function mt.__band(a,b)
    local res ={op='&',val1=a,val2=b}
    setmetatable(res,mt)
    return res
end

function mt.__bnot(a)
    local res ={op='~',val=a}
    setmetatable(res,mt)
    return res
end


function Prop.set(a)
    setmetatable(a,mt)
end

local function mytostring(a,res)
--    print('mytostring',a.op, a.val1, a.val2, a.val3, a.val3.val1, a.val3.op, a.val3.val2)
    if (a.op == 'prop') then
        res[#res+1] = a.val
    elseif (a.op == 'egal') then
        res[#res+1] = '(' .. tostring(a.val1) .. '==' .. tostring(a.val2) .. ')'
    elseif (a.op == 'negal') then
        res[#res+1] = '(' .. tostring(a.val1) .. '!=' .. tostring(a.val2) .. ')'
    elseif (a.op == 'Ex') then
        res[#res+1] = '(' .. tostring(a.val1) .. ' = ' .. tostring(a.val2) .. ' U '.. tostring(a.val3).. ')'
    elseif (a.op == '~') then
        res[#res+1] = '~' .. tostring(a.val)
    elseif (a.op == 'non') then
        res[#res+1] = '~' .. tostring(a.val)
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

return Prop