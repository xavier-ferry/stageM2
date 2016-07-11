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

local preUnique = 'pred preUnique(var2 '..pre..' Mot)=\n all1 x : x in Mot => \n(   \n'
for i = 1, gamma do
            preUnique = preUnique .. '('
        for j = 1, gamma  do
            if j==i then
                preUnique = preUnique .. ' x in Pre'..i..' &'
            else
                preUnique = preUnique .. ' x notin Pre'..j..' &'
            end
        end
        preUnique = preUnique:sub(1,-3)
        preUnique = preUnique .. ' ) |\n    '
    end
--    preUnique = preUnique:sub(1,-2)
    preUnique = preUnique .. 'x notin ('
    for i = 1,gamma do
        preUnique = preUnique ..'Pre'..i..' union '
    end
    preUnique =preUnique:sub(1,-8)
    preUnique = preUnique .. ')\n);\n\n'


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


local texte = preUnique .. "\n\n" .. relationGPomset .. '\n\n' .. partialOrder .. "\n\n" .. successeurImmediat
io.write(texte)
io.close(file)
end
