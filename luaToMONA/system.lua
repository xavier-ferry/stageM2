require "config"

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
AB = AB:sub(1, -3)

local prePost = pre .. post
prePost = prePost:sub(1, -3)


system = "pred system(var2 AX)=\n"
system = system .. "  ex2 "..prePost..", P, Mot:\n"
system = system .. "    P={3} &\n"
system = system .. "    Pre0={1,2,3,4,5,6} &\n"
system = system .. "    Post0 = {0,2,3} &\n"
system = system .. "    Mot = {0,1,2,3,4,5,6} &\n"
system = system .. "    transitions("..prePost..",P,AX, Mot);\n"



system = "pred system(var2 AX)=\n"
system = system .. "  ex2 "..prePost..", P, Mot:\n"
system = system .. "    P={1} &\n"
system = system .. "    Pre0={1} &\n"
system = system .. "    Post0 = {0} &\n"
system = system .. "    Pre1={2} &\n"
system = system .. "    Post1 = {0} &\n"
system = system .. "    Mot = {0,1,2} &\n"
system = system .. "    transitions("..prePost..",P,AX, Mot);\n"

system = "pred system(var2 AX)=\n"
system = system .. "  ex2 "..prePost..", P, Mot:\n"
system = system .. "    P={3,5} &\n"
system = system .. "    Pre0={1,2,3,4,5} &\n"
system = system .. "    Post0 = {0,2,3} &\n"
system = system .. "    Pre1={3,5} &\n"
system = system .. "    Post1 = {0,3,4} &\n"
system = system .. "    Mot = {0,1,2,3,4,5} &\n"
system = system .. "    transitions("..prePost..",P,AX, Mot);\n"
