--Automate PAUQ
P     = Set("P",1)
Q     = Set("Q",1)
PAUQ    = Set('PAUQ')
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
            "PAUQ"
        },
        props = {
            "P","Q"
        },
        nePasDecliner = {
            P, Q, PAUQ, empty
        },
        label = {
            P,PAUQ,Pre,Post
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
                P,
                Set.non(Q),
                PAUQ,
                Set.egal(B_*Post,empty),

                Set.egal(A_,A+Post),
                Set.egal(B_,B)
            }
        },
        t2 = {
            Conditions = {
                --                Set.non(P)+P,
                Q,
                PAUQ,
                Set.egal(B_*Post,empty),

                Set.egal(A_, A+Post),
                Set.egal(B_, B)
            }
        },
        t4 = {
            Conditions = {
                P,
                Set.non(Q),
                Set.non(PAUQ),
                Set.non(Set.egal(B*Post,empty)),

                Set.egal(A_, A-Post),
                Set.egal(B_, B)
            }
        },
        t4b = {
            Conditions = {
                P,
                Set.non(Q),
                Set.non(PAUQ),
                Set.egal(B*Post,empty),

                Set.egal(A_, A-Post),
                Set.affectUnion(B_,B,Post-A_)
            }
        },
        t5 = {
            Conditions = {
                Set.non(P),
                Set.non(Q),
                Set.non(PAUQ),
                Set.egal(A*Pre,empty),
                Set.non(Set.egal((B-Pre)*Post,empty)),

                Set.egal(A_, A-Post),
                Set.egal(B_, B-Pre)
            }
        },
        t5b = {
            Conditions = {
                Set.non(P),
                Set.non(Q),
                Set.non(PAUQ),
                Set.egal(A*Pre,empty),
                Set.egal((B-Pre)*Post,empty),

                Set.egal(A_, A-Post),
                Set.affectUnion(B_,B-Pre,Post-A)
            }
        }
    }
}


