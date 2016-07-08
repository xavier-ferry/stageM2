require "config"

function writeGammaPomset()
file = io.open(gammaPomsetMonaFile, "w")
io.output(file) 


local prePost = ""

local pre = ""
local post = ""
for i=1, gamma do
  pre = pre .. "Pre" ..i .. ", "
  post = post .. "Post" ..i .. ", "
end

prePost = pre .. post
prePost = prePost:sub(1, -3) 

local relationGPomset = '#Traduction de la relation de successeurImmediat sur les gamma-pomset \n'
relationGPomset = relationGPomset .. 'pred relationGPomset(var1 x,y, var2 ' .. prePost ..', Mot) = \n'
relationGPomset = relationGPomset .. '  x < y & \n  (\n'
for i=1, gamma do
  relationGPomset = relationGPomset .. '   ( x in Post' ..i.. ' & y in Pre'..i..' & (all1 z:(z>x & z<y) => z notin Post'..i..')) |\n'
end
relationGPomset = relationGPomset:sub(1, -3) 
relationGPomset = relationGPomset .. "\n );\n"


local partialOrder = "#Traduction de la relation d'ordre partiel \n"
partialOrder = partialOrder .. " pred partialOrder(var1 x, y, var2 " .. prePost .. ", Mot) =\n"
partialOrder = partialOrder .. "   all2 X: ( (x in X & \n"
partialOrder = partialOrder .. "             (all1 u,v: (relationGPomset(u,v,"..prePost..", Mot) & u in X)\n"
partialOrder = partialOrder .. "             => v in X)) => y in X);\n"


local successeurImmediat = "#Traduction de la relation de causalité sur les Pomsets\n"
successeurImmediat = successeurImmediat .. " pred successeurImmediat(var1 x, y, var2 "..prePost.." , Mot) =\n"
successeurImmediat = successeurImmediat .. "  x ~= y &\n"
successeurImmediat = successeurImmediat .. "  partialOrder(x,y,"..prePost..",Mot) & ~(ex1 z: z~=x & z~=y &\n"
successeurImmediat = successeurImmediat .. "      (partialOrder(x,z,"..prePost..",Mot) &\n"
successeurImmediat = successeurImmediat .. "        partialOrder(z,y,"..prePost..",Mot)\n"
successeurImmediat = successeurImmediat .. "      )\n"
successeurImmediat = successeurImmediat .. "  );\n"


local texte = relationGPomset .. "\n\n" .. partialOrder .. "\n\n" .. successeurImmediat
io.write(texte)
io.close(file)
end
