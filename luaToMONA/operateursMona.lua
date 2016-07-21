require "config"

function writeOperateursMona()
file = io.open(operateursMona, "w")
io.output(file) 

io.write(operateursInclude);

local prePost = ""

local pre = ""
local post = ""
for i=1, gamma do
  pre = pre .. "Pre" ..i .. ", "
  post = post .. "Post" ..i .. ", "
end

prePost = pre .. post
prePost = prePost:sub(1, -3) 


local EXP = "pred EXP( var2 RES, P,"..prePost..", Mot) =\n"
EXP = EXP .. "all1 x : ((x in RES) <=> ( ex1 y: y in P & successeurImmediat(x,y,"..prePost..", Mot)));\n"

local AXP = "pred AXP( var2 RES, P,"..prePost..", Mot)=\n"
AXP = AXP .. "  EXP(Mot\\RES, Mot\\P,"..prePost..",Mot);\n"

local pEUq = "pred pEUq ( var2 RES, P, Q, "..prePost..", Mot)= \n"
pEUq = pEUq .. 'all1 x : \n   x in RES <=> ( x in Q |\n   ex1 z : (successeurImmediat(x,z,'..prePost..',Mot) & x in P & z in RES )\n   )\n;\n'

local pAUq = "pred pAUq ( var2 RES, P, Q, "..prePost..", Mot)=\n"
pAUq = pAUq .. "  all1 x : x in RES <=> ( x in Q |( x in P & all1 z : ~(successeurImmediat(x,z,"..prePost..", Mot)) | (successeurImmediat(x,z,"..prePost..", Mot) & z in RES))); \n"

local pGUq = "pred pGUq(var2 RES,P,Q,"..prePost..", Mot) = \n"
pGUq = pGUq .. "  all1 x : x in RES <=> ( x in Q | ( x in P & ex1 z: (z in Q & z>x &  partialOrder(x,z,"..prePost..",Mot))"
pGUq = pGUq .. " & (all1 y: ( y>x & y<z & partialOrder(x,y,"..prePost..",Mot) & partialOrder(y,z,"..prePost..",Mot)) => y in P)));\n"


local texte = EXP .. "\n\n" .. AXP .. "\n\n" .. pEUq .. "\n\n" .. pAUq .. "\n\n" .. pGUq .. "\n"
io.write(texte)
io.close(file)
end
