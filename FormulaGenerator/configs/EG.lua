--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--
P     = Set("P",1)
EG    = Set('EG')
A     = Set('A')
A_    = Set("A\'")
B     = Set('B')
B_    = Set("B\'")
C     = Set('C')
C_    = Set("C\'")
Pre   = Set('Pre')
Post  = Set('Post')
Dead = Set('Dead')
empty = Set()

function auto()
    return {
        proprietes = {
            aVerifier = {
                "EG"
            },
            props = {
                "P"
            },
            nePasDecliner = {
                P, EG, Dead, empty
            },
            label = {
                P,EG,Pre,Post
            },
            state = {
                A,B,C
            }
        },
        initial = {
            Set.egal(A+B+C,empty)
        },
        final = {
            'A','C'
        },
        transitions = {
            t1 = {
                Conditions = {
                    Set.non(Dead),
                    P,
                    EG,
                    Set.egal(B*Pre,empty),
                    Set.egal(C*Post,empty),
                    Set.egal(A*Post-Pre,empty),
                    --                    Set.non(Set.egal(Post,empty)),

                    Set.affectUnion(A_,A-Pre,Post),
                    Set.egal(B_,B-Post),
                    Set.egal(C_,C)
                }
            },
            t2 = {
                Conditions = {
                    Set.non(Dead),
                    P,
                    Set.non(EG),
                    Set.egal(A*Post,empty),

                    Set.egal(A_, A),
                    Set.egal(B_, B+Post),
                    Set.affectUnion(C_,C-Pre,Post)
                }
            },
            t3 = {
                Conditions = {
--                    Set.non(Dead),
                    Set.non(P),
                    Set.non(EG),
                    Set.egal(A*Post,empty),

                    Set.egal(A_, A),
                    Set.egal(B_,B-Post),
                    Set.egal(C_,C-Pre)
                }
            },
            t4 = {
                Conditions = {
                    Dead,
                    P,
                    EG,
                    Set.egal(B*Pre,empty),
                    Set.egal(C*Post,empty),
                    Set.egal(A*Post-Pre,empty),

                    Set.egal(A_,A-Pre),
                    Set.egal(B_,B-Post),
                    Set.egal(C_,C)
                }
            }
--            ,
--            t5 = {
--                Conditions = {
--                    Dead,
--                    Set.non(P),
--                    Set.non(EG),
--                    Set.egal(A*Pre,empty),
--                    Set.egal(A_,A-Post),
--                    Set.egal(B_,B-Pre)
--                }
--            }
        }
    }

end