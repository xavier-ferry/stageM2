file = io.open("res.mona", "w")
io.output(file) 

gamma = 1
prePost = ""

if (gamma == 0)  then
  prePost = "Pre, Post"
else
  pre = ""
  post = "" 
  for i=0, gamma do
    pre = pre .. "Pre" ..i .. ", "
    post = post .. "Post" ..i .. ", "
  end

  prePost = pre .. post
  prePost = prePost:sub(1, -3) 
end

declarationVariable = "Var2 A, B; \n"
declarationVariable = declarationVariable .. "Var2 " .. prePost .. ";\n"














io.write(declarationVariable)
io.close(file)