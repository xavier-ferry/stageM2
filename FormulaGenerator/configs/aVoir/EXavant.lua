--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--
P     = Set("P",1)
EX    = Set('EX')
A     = Set('A')
A_    = Set("A\'")
B     = Set('B')
B_    = Set("B\'")
Pre   = Set('Pre')
Post  = Set('Post')
empty = Set()

function auto()
return {
    proprietes = {
        aVerifier = {
            "EX"
        },
        props = {
            "P"
        },
        nePasDecliner = {
          P, EX, empty
        },
        label = {
            P,EX,Pre,Post
        },
        state = {
            A,B
        }
    },
    initial = {
        Set.egal(A+B,empty)
    },
    final = {
        'A'
    },
    transitions = {
        t1 = {
            Conditions = {
                P,
                EX,
                Set.egal(B*Pre,empty),

                Set.affectUnion(A_,A-Pre,Post),
                Set.egal(B_,B)
            }
        },
        t2 = {
            Conditions = {
                Set.non(P),
                EX,
                Set.egal(A*Pre,empty),

                Set.affectUnion(A_, A,Post-B_),
                Set.egal(B_, B-Pre)
            }
        },
        t3 = {
            Conditions = {
                P,
                Set.non(EX),
                Set.egal(B*Pre,empty),

                Set.egal(A_, A-Pre),
                Set.egal(B_, B+Post)
            }
        },
        t4 = {
            Conditions = {
                Set.non(P),
                Set.non(EX),
                Set.egal(A*Pre,empty),

                Set.egal(A_, A),
                Set.egal(B_,B-Pre+Post)
            }
        }
    }
}

end

