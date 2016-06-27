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