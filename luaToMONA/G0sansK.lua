pred t1 (var1 x, var2 A0, B0, Pre0, Post0, P, AX, Mot) =
  ~(x in B0 & x in Post0) &
  (x+1 in A0 <=> (x in Post0 | x in A0)) &
  (x+1 in B0 <=> x in B0) &
  x in P & x in AX;


pred t2 (var1 x, var2 A0, B0, Pre0, Post0, P, AX, Mot) =
  ~(x in A0 & x in Pre0) & ~(x+1 in B0 & x in Post0) &
  (x+1 in A0 <=> (x in Post0 | x in A0)) &
  (x+1 in B0 <=> (x in B0 & x notin Pre0)) &
  x notin P & x in AX;


pred t3 (var1 x, var2 A0, B0, Pre0, Post0, P, AX, Mot) =
  ~(x in B0 & x in Pre0) & ~(x+1 in A0 & x in Post0) &
  x in B0 & x in Post0  &
  (x+1 in A0 <=> (x in A0 & x notin Post0)) &
  (x+1 in B0 <=> x in B0) &
  x in P & x notin AX;


pred t3b (var1 x, var2 A0, B0, Pre0, Post0, P, AX, Mot) =
  ~(x in B0 & x in Pre0) & ~(x+1 in A0 & x in Post0) &
  ~(x in B0 & x in Post0)  &
  (x+1 in A0 <=> (x in A0 & x notin Post0)) &
  (x+1 in B0 & ( x in B0 | (x in Post0 &  x+1 notin A0))) &
  x in P & x notin AX;


pred t4 (var1 x, var2 A0, B0, Pre0, Post0, P, AX, Mot) =
  ~(x in A0 & x in Pre0)  &
  (x in B0 & x notin Pre0 & x in Post0) &
  (x+1 in A0 <=> (x in A0 & x notin Post0)) &
  (x+1 in B0 <=> (x in B0 & x notin Pre0)) &
  x notin P & x notin AX;


pred t4b (var1 x, var2 A0, B0, Pre0, Post0, P, AX, Mot) =
  ~(x in A0 & x in Pre0)  &
  ~(x in B0 & x notin Pre0 & x in Post0) &
  (x+1 in A0 <=> (x in A0 & x notin Post0)) &
  (x+1 in B0 & ( (x in B0 & x notin Pre0) | (x in Post0 &  x notin A0))) &
  x notin P & x notin AX;


pred final (var2 B0,  Mot) = 
  all1 x : 
    (x+1 in Mot => x in Mot) &
    (x in B0 => x in Mot) ;

pred initial (var2 A0, B0, Mot) = 
  0 in Mot => (0 notin A0 & 0 notin B0) ;

pred transitions (var2 Pre0, Post0,P, AX, Mot )= 
  ex2 A0, B0 :(
    (
      (all1 x :
        x in Mot => (
          t1(x,A0, B0, Pre0, Post0, P,AX,Mot) | 
          t2(x,A0, B0, Pre0, Post0, P,AX,Mot) | 
          t3(x,A0, B0, Pre0, Post0, P,AX,Mot) | 
          t3b(x,A0, B0, Pre0, Post0, P,AX,Mot) | 
          t4(x,A0, B0, Pre0, Post0, P,AX,Mot) | 
          t4b(x,A0, B0, Pre0, Post0, P,AX,Mot) 
          )
       ) &
       final(B0, Mot) & initial(A0, B0, Mot)
     )
  );

pred system(var2 AX)=
  ex2 Pre0, Post0, P, Mot:
    P={1} &
    Pre0={1} &
    Post0 = {0} &
    Pre1={2} &
    Post1 = {0} &
    Mot = {0,1,2} &
    transitions(Pre0, Post0,P,AX, Mot);


var2 AX; system(AX);