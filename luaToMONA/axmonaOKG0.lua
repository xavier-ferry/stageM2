require "config"

file = io.open(AXMona, "w")
io.output(file)

-- io.write(axInclude)

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



local t1 = "pred t1 (var1 x, var2 " ..AB.. ", "..prePost..", P, AX, Mot) =\n"
local transimpl = ""
local transcond = "  "
for i=0, gamma do
  transcond = transcond .. "~(x in B"..i.." & x in Post"..i..") &\n  "
  transimpl = transimpl .. "(x+1 in A"..i.." <=> (x in Post"..i.." | x in A"..i..")) &\n  "
  transimpl = transimpl .. "(x+1 in B"..i.." <=> x in B"..i..") &\n  "
end
  transimpl = transimpl .. "x in P & x in AX;\n"

t1 = t1 .. transcond .. transimpl




local t2 = "pred t2 (var1 x, var2 " ..AB.. ", "..prePost..", P, AX, Mot) =\n"
transimpl = ""
transcond = "  "
for i=0, gamma do
  transcond = transcond .. "~(x in A"..i.." & x in Pre"..i..") & ~(x+1 in B"..i.." & x in Post"..i..") &\n  "
  transimpl = transimpl .. "(x+1 in A"..i.." <=> (x in Post"..i.." | x in A"..i..")) &\n  "
  transimpl = transimpl .. "(x+1 in B"..i.." <=> (x in B"..i.." & x notin Pre"..i..")) &\n  "
end
  transimpl = transimpl .. "x notin P & x in AX;\n"

t2 = t2 .. transcond .. transimpl



local t3 = "pred t3 (var1 x, var2 " ..AB.. ", "..prePost..", P, AX, Mot) =\n"
transimpl = ""
transcond = "  "
for i=0, gamma do
  transcond = transcond .. "~(x in B"..i.." & x in Pre"..i..") & ~(x+1 in A"..i.." & x in Post"..i..") &\n  "
  transcond = transcond .. "x in B"..i.." & x in Post"..i.."  &\n  "
  transimpl = transimpl .. "(x+1 in A"..i.." <=> (x in A"..i.." & x notin Post"..i..")) &\n  "
  transimpl = transimpl .. "(x+1 in B"..i.." <=> x in B"..i..") &\n  "
end
  transimpl = transimpl .. "x in P & x notin AX;\n"

t3 = t3 .. transcond .. transimpl


local t3b = "pred t3b (var1 x, var2 " ..AB.. ", "..prePost..", P, AX, Mot) =\n"
transimpl = ""
transcond = "  "
for i=0, gamma do
  transcond = transcond .. "~(x in B"..i.." & x in Pre"..i..") & ~(x+1 in A"..i.." & x in Post"..i..") &\n  "
  transcond = transcond .. "~(x in B"..i.." & x in Post"..i..")  &\n  "
  transimpl = transimpl .. "(x+1 in A"..i.." <=> (x in A"..i.." & x notin Post"..i..")) &\n  "
  for k=0, gamma do
    transimpl = transimpl .. "(x+1 in B"..i.." & ( x in B"..i.." | (x in Post"..k.." &  x+1 notin A"..k.."))) &\n  "
  end
end
  transimpl = transimpl .. "x in P & x notin AX;\n"

t3b = t3b .. transcond .. transimpl



local t4 = "pred t4 (var1 x, var2 " ..AB.. ", "..prePost..", P, AX, Mot) =\n"
transimpl = ""
transcond = "  "
for i=0, gamma do
  transcond = transcond .. "~(x in A"..i.." & x in Pre"..i..")  &\n  "
  transcond = transcond .. "(x in B"..i.." & x notin Pre"..i.." & x in Post"..i..") &\n  "
  transimpl = transimpl .. "(x+1 in A"..i.." <=> (x in A"..i.." & x notin Post"..i..")) &\n  "
  transimpl = transimpl .. "(x+1 in B"..i.." <=> (x in B"..i.." & x notin Pre"..i..")) &\n  "
end
  transimpl = transimpl .. "x notin P & x notin AX;\n"

t4 = t4 .. transcond .. transimpl


local t4b = "pred t4b (var1 x, var2 " ..AB.. ", "..prePost..", P, AX, Mot) =\n"
transimpl = ""
transcond = "  "
for i=0, gamma do
  transcond = transcond .. "~(x in A"..i.." & x in Pre"..i..")  &\n  "
  transcond = transcond .. "~(x in B"..i.." & x notin Pre"..i.." & x in Post"..i..") &\n  "
  transimpl = transimpl .. "(x+1 in A"..i.." <=> (x in A"..i.." & x notin Post"..i..")) &\n  "
  for k=0, gamma do
    transimpl = transimpl .. "(x+1 in B"..i.." & ( (x in B"..i.." & x notin Pre"..i..") | (x in Post"..k.." &  x notin A"..k.."))) &\n  "
  end
end
  transimpl = transimpl .. "x notin P & x notin AX;\n"

t4b = t4b .. transcond .. transimpl


local final = "pred final (var2 "..B.." Mot) = \n"
final = final .. "  all1 x : \n"
final = final .. "    (x+1 in Mot => x in Mot) &\n"
for i=0, gamma do
  final = final .. "    (x in B"..i.." => x in Mot) &\n"
end
final = final:sub(1, -3)
final = final .. ";"


local initial = "pred initial (var2 "..AB..", Mot) = \n"
for i=0, gamma do
  initial = initial .. "  0 in Mot => (0 notin A"..i.." & 0 notin B"..i..") &\n"
end
initial = initial:sub(1, -3)
initial = initial .. ";"

local transitions = "pred transitions (var2 "..prePost..",P, AX, Mot )= \n"
transitions = transitions .. "  ex2 "..AB.." :(\n"
transitions = transitions .. "    (\n"
transitions = transitions .. "      (all1 x :\n"
transitions = transitions .. "        x in Mot => (\n"
transitions = transitions .. "          t1(x,"..AB..", "..prePost..", P,AX,Mot) | \n"
transitions = transitions .. "          t2(x,"..AB..", "..prePost..", P,AX,Mot) | \n"
transitions = transitions .. "          t3(x,"..AB..", "..prePost..", P,AX,Mot) | \n"
transitions = transitions .. "          t3b(x,"..AB..", "..prePost..", P,AX,Mot) | \n"
transitions = transitions .. "          t4(x,"..AB..", "..prePost..", P,AX,Mot) | \n"
transitions = transitions .. "          t4b(x,"..AB..", "..prePost..", P,AX,Mot) \n"
transitions = transitions .. "          )\n"
transitions = transitions .. "       ) &\n"
transitions = transitions .. "       final("..B.."Mot) & initial("..AB..", Mot)\n"
transitions = transitions .. "     )\n"
transitions = transitions .. "  );"

local system = "pred system(var2 AX)=\n"
system = system .. "  ex2 "..prePost..", P, Mot:\n" 
system = system .. "    P={1,4} &\n" 
system = system .. "    Pre0={1,2,3,4,5} &\n" 
system = system .. "    Post0 = {0,2,3} &\n" 
system = system .. "    Pre1={3,5} &\n" 
system = system .. "    Post1 = {0,3,4} &\n" 
system = system .. "    Mot = {0,1,2,3,4,5} &\n" 
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
system = system .. "    P={3} &\n" 
system = system .. "    Pre0={1,2,3,4,5,6} &\n" 
system = system .. "    Post0 = {0,2,3} &\n" 
system = system .. "    Mot = {0,1,2,3,4,5,6} &\n" 
system = system .. "    transitions("..prePost..",P,AX, Mot);\n" 




local declaration = "var2 AX; system(AX);"

local texte =  ""
texte = texte .. t1 ..  "\n\n"
texte = texte .. t2 ..  "\n\n"
texte = texte .. t3 ..  "\n\n"
texte = texte .. t3b ..  "\n\n"
texte = texte .. t4 ..  "\n\n"
texte = texte .. t4b ..  "\n\n"
texte = texte .. final ..  "\n\n"
texte = texte .. initial ..  "\n\n"
texte = texte .. transitions ..  "\n\n"
texte = texte .. system ..  "\n\n"
texte = texte .. declaration


io.write(texte)
io.close(file)
