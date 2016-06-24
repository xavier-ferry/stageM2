--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--

outputTXTFile = 'generated.txt'
outputMONAFile = 'generated.mona'

Set=require('Set')
Prop=require('Prop')

gamma = 2
P     = Set("P",1)
AX    = Set('AX')
A     = Set('A')
A_    = Set("A\'")
B     = Set('B')
B_    = Set("B\'")
Pre   = Set('Pre')
Post  = Set('Post')
empty = Set()


automate = {
    proprietes = {
        nePasDecliner = {
          P, AX, empty
        },
        label = {
            P,AX,Pre,Post
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
                AX,
                Set.egal(B*Post,empty),

                Set.egal(A_,A+Post),
                Set.egal(B_,B)
            }
        },
        t2 = {
            Conditions = {
                Set.non(P),
                AX,
                Set.egal(A*Pre,empty),
                Set.egal(B_*Post,empty),

                Set.egal(A_, A+Post),
                Set.egal(B_, B-Pre)
            }
        },
        t3 = {
            Conditions = {
                P,
                Set.non(AX),
                Set.non(Set.egal(B*Post,empty)),
                Set.egal(A_*Post,empty),

                Set.egal(A_, A-Post),
                Set.egal(B_, B)
            }
        },
        t3b = {
            Conditions = {
                P,
                Set.non(AX),
                Set.egal(B*Post,empty),
                Set.egal(A_*Post,empty),

                Set.egal(A_, A-Post),
                Set.exists(B_,B,Post-A_)
            }
        },
        t4 = {
            Conditions = {
                Set.non(P),
                Set.non(AX),
                Set.egal(A*Pre,empty),
                Set.non(Set.egal((B-Pre)*Post,empty)),

                Set.egal(A_, A-Post),
                Set.egal(B_, B-Pre)
            }
        },
        t4b = {
            Conditions = {
                Set.non(P),
                Set.non(AX),
                Set.egal(A*Pre,empty),
                Set.egal((B-Pre)*Post,empty),

                Set.egal(A_, A-Post),
                Set.exists(B_,B-Pre,Post-A)
            }
        }
    }
}

