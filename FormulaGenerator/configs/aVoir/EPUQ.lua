--Automate EPUQ
P     = Set("P",1)
Q     = Set("Q",1)
EPUQ    = Set('EPUQ')
A     = Set('A')
A_    = Set("A\'")
B     = Set('B')
B_    = Set("B\'")
Pre   = Set('Pre')
Post  = Set('Post')
empty = Set()


automate = {
    proprietes = {
        aVerifier = {
            "EPUQ"
        },
        props = {
            "P","Q"
        },
        nePasDecliner = {
            P, Q, EPUQ, empty
        },
        label = {
            P,EPUQ,Pre,Post
        },
        state = {
            A,B
        }
    },
    initial = {
        Set.egal(A+B,empty)
    },
    final = {
        --        Set.egal(B,empty)
    },
    transitions = {
        t1 = {
            Conditions = {
                Set.non(P),
                Set.non(Q),
                Set.non(EPUQ),
                Set.egal(A*Post,empty),

                Set.egal(A_,A),
                Set.egal(B_,B-Pre-Post)
            }
        },
        t2 = {
            Conditions = {
                P,
                Set.non(Q),
                Set.non(EPUQ),
                Set.egal(A*Post,empty),

                Set.egal(A_, A),
                Set.egal(B_, B+Post)
            }
        },
        t3 = {
            Conditions = {
                Q,
                EPUQ,
                Set.egal(A_*Post,empty),
                Set.egal(B*Pre,empty),

                Set.egal(A_, A-Pre),
                Set.egal(B_, B-Post)
            }
        }
--        ,
--        t4 = {
--            Conditions = {
--                P,
--                Set.non(Q),
--                EPUQ,
--                Set.egal(B*Pre,empty),
--
--                Set.egal(A_, A),
--                Set.egal(B_,B-Post)
--            }
--        }
    }
}


