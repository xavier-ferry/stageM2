require "config"

file = io.open(AXMona, "w")
io.output(file) 

io.write(axInclude)

local pre = ""
local post = ""
local A = ""
local B = ""
local A_ = ""
local B_ = ""

for i=0, gamma do
  pre = pre .. "Pre" ..i .. ", "
  post = post .. "Post" ..i .. ", "
  A = A .. "A" ..i .. ", "
  B = B .. "B" ..i .. ", "
  A_ = A_ .. "A" ..i .. "_, "
  B_ = B_ .. "B" ..i .. "_, "
end
local AB = A .. B .. A_ .. B_ 
AB = AB:sub(1, -3) 

local prePost = pre .. post
prePost = prePost:sub(1, -3) 


local declarationVariable = "var2 "..AB.."; \n"
declarationVariable = declarationVariable .. "var2 " .. prePost .. ";\n"
declarationVariable = declarationVariable .. "var2 P, AX,EX, Mot;\n"


local ABdisjoint = "pred ABdisjoint(var2 "..AB..") = \n"
for i=0, gamma do
  ABdisjoint = ABdisjoint .. "(A"..i.." inter B"..i..") = empty & \n"
  ABdisjoint = ABdisjoint .. "(A"..i.."_ inter B"..i.."_) = empty & \n" 
end
ABdisjoint = ABdisjoint:sub(1,-4)
ABdisjoint = ABdisjoint .. ";\n"

--[[
  A B -- Pre, Post, P, AX --> A_ B_
    A_ = A\Pre U Post
    B_ = B
    Conditions : B ^ Post = Ø et B ^ Pre = Ø
]]--

local trans1 = "pred trans1 (var2 " ..AB.. ", P, AX, "..prePost..", Mot) =\n"
local trans1impl = ""
local trans1cond = ""
for i=0, gamma do 
  trans1cond = trans1cond .. "(B"..i.." inter Pre"..i.." = empty & B"..i.." inter Post"..i.." = empty) &\n"
  trans1impl = trans1impl .. " all1 x : (x in Pre"..i.." & x in Post"..i.." & x in P & x in AX ) =>( (A"..i.."_ = A"..i.."\\Pre"..i.." union Post"..i..") & B"..i.."_ = B"..i.." ) |\n"
end

trans1 = trans1 .. trans1cond .. trans1impl
trans1 = trans1:sub(1, -3) 
trans1 = trans1 .. ";\n"

--[[
  A B -- Pre, Post, notP, AX --> A_ B_
    A_ = A U Post
    B_ = B\Pre
    Conditions : B_ ^ Post = Ø et A ^ Pre = Ø
]]--

local trans2 = "pred trans2 (var2 " ..AB.. ", P, AX, "..prePost..", Mot) =\n"
local trans2impl = ""
local trans2cond = ""
for i=0, gamma do
  trans2cond = trans2cond .. "(B"..i.."_ inter Post"..i.." = empty & A"..i.." inter Pre"..i.." = empty) &\n"
  trans2impl = trans2impl .. " all1 x : (x in Pre"..i.." & x in Post"..i.." & x in P & x in AX ) =>( (A"..i.."_ = A"..i.." union Post"..i..") & B"..i.."_ = B"..i.."\\Pre"..i.." ) |\n"
end
trans2 = trans2 .. trans2cond .. trans2impl
trans2 = trans2:sub(1, -3) 
trans2 = trans2 .. ";\n"




--[[
  A B -- Pre, Post, P, EX(notP) --> A_ B_
    A_ = A\Pre
    B_ = B si B inter Post = Ø
    B_ = B U {b} si b in Post\A_
    Conditions : B_ ^ Post = Ø et A ^ Pre = Ø
    
    
    ---
    
    
pred trans3(...) = 
(B inter Post = empty & ( x in Pre, X in Post, x in P, EX(notP)) => B_ = B & A_ = A\\Pre) |
all1 b : b in Post\A & (( x in Pre, X in Post, x in P, EX(notP)) => A_ = A \\Pre & B_ = B union b;
]]--

local trans3 = "pred trans3 (var2 " ..AB.. ", P, AX, "..prePost..", Mot) =\n"
for i=0, gamma do
  trans3 = trans3 .. "((B"..i.."_ inter Post"..i.." = empty & all1 x : (x in Pre"..i.." & x in Post"..i.." & x in P & all2 EX : (EXP(EX,Mot\\P,"..prePost..", Mot) & x in EX ) )) => (B"..i.."_ = B"..i.." & A"..i.."_ = A"..i.."\\Pre"..i.." ) |\n"
  trans3 = trans3 .. "(all1 b : b in Post"..i.."\\A"..i.."_ & all1 x : (x in Pre"..i.."& x in Post"..i.." & x in P & all2 EX : (EXP(EX,Mot\\P,"..prePost..", Mot) & x in EX) ) => A"..i.."_ = A"..i.."\\Pre"..i.." & B"..i.."_ = B"..i.." union {b})) |\n"
end
trans3 = trans3:sub(1, -3) 
trans3 = trans3 .. ";\n"


--[[
A B -- Pre, Post, notP, EX(notP) --> A_ B_
    A_ = A
    B_ = B\Pre si B\Pre inter Post = Ø
    B_ = B\Pre U {b} si b in Post\A
    Conditions : B_ ^ Post = Ø et A ^ Pre = Ø
]]--

local trans4 = "pred trans4 (var2 " ..AB.. ", P, AX, "..prePost..", Mot) =\n"
for i=0, gamma do
  trans4 = trans4 .. "((B"..i.."_\\Pre"..i.." inter Post"..i.." = empty & all1 x : (x in Pre"..i.." & x in Post"..i.." & x notin P &  all2 EX : (EXP(EX,Mot\\P,"..prePost..", Mot) & x in EX ) )) => (B"..i.."_ = B"..i.."\\Pre"..i.." & A"..i.."_ = A"..i.." ) |\n"
  trans4 = trans4 .. "(all1 b,x : b in Post"..i.."\\A"..i.." & (x in Pre"..i.." & x in Post"..i.." & x notin P &  all2 EX : (EXP(EX,Mot\\P,"..prePost..", Mot) & x in EX )) => A"..i.."_ = A"..i.."& B"..i.."_ = B"..i.."\\Pre"..i.." union {b})) |\n"
end
trans4 = trans4:sub(1, -3) 
trans4 = trans4 .. ";\n"



local system = "pred AXp (var2 "..AB..",P, AX,"..prePost..", Mot )= \n" 
system = system .. "ABdisjoint("..AB..") & (\n"
system = system .. "  trans1("..AB..",P,AX,"..prePost..",Mot) | \n"
system = system .. "  trans2("..AB..",P,AX,"..prePost..",Mot) | \n"
system = system .. "  trans3("..AB..",P,AX,"..prePost..",Mot) | \n"
system = system .. "  trans4("..AB..",P,AX,"..prePost..",Mot) );\n"



local texte =  ""
texte = texte .. declarationVariable .. "\n\n" 
texte = texte .. ABdisjoint ..  "\n\n" 
texte = texte .. trans1 ..  "\n\n" 
texte = texte .. trans2 ..  "\n\n" 
texte = texte .. trans3 ..  "\n\n" 
texte = texte .. trans4 ..  "\n\n" 
texte = texte .. system ..  "\n\n" 

texte = texte .. "A0 = {}; B0 = {}; \n AXp(A0,B0,A0_, B0_, P, AX, Pre0, Post0, Mot);"

io.write(texte)
io.close(file)