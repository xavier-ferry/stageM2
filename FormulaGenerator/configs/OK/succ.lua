--
-- Created by IntelliJ IDEA.
-- User: Xavier
-- Date: 14/06/2016
-- Time: 17:27
-- To change this template use File | Settings | File Templates.
--
Xa     = Set("Xa",1)
Xa_     = Set("Xa\'",1)
OK    = Set('OK',1)
A     = Set('A')
A_    = Set("A\'")
Pre   = Set('Pre')
Post  = Set('Post')
empty = Set()

function succAuto(ha)
    return {
        proprietes = {
            aVerifier = {
                "OK"
            },
            props = {
                "Xa"
            },
            nePasDecliner = {
                OK,Xa,Xa_, empty
            },
            parametre = {

            },
            label = {
                OK, Pre, Post
            },
            state = {
                A,Xa
            }
        },
        initial = {
            Set.egal(A,empty)
        },
        final = {
            'A'
        },
        transitions = {
            t1 = {
                Conditions = {
                    Set.non(Xa),
                    Set.non(OK),
                    Set.non(Set.appartient('Post',ha)),
                    Set.non(Xa_)
                }
            },
            t2 = {
                Conditions = {
                    Set.non(Xa),
                    Set.non(OK),
                    Set.appartient('Post',ha),
                    Set.egal(A_,Set.moinsProp(Post,ha)),
                    Xa_
                }
            },
            t3 = {
                Conditions = {
                    Xa,
                    OK,
                    Set.appartient('Pre',ha),
                    Set.non(Set.appartient('Post',ha)),
                    Set.egal(A*Pre,empty),
                    Xa_,
                    Set.egal(A_,A+Post)
                }
            },
            t4 = {
                Conditions = {
                    Xa,
                    OK,
                    Set.appartient('Post',ha),
                    Set.appartient('Pre',ha),
                    Set.egal(A*Pre,empty),
                    Xa_,
                    Set.egal(A_,Set.moinsProp(Post,ha))
                }
            },

            t5 = {
                Conditions = {
                    Xa,
                    Set.non(OK),
                    Set.appartient('Pre',ha),
                    Set.non(Set.appartient('Post',ha)),
                    Xa_,
                    Set.non(Set.egal(A*Pre,empty)),
                    Set.egal(A_,A+Post)
                }
            },
            t6 = {
                Conditions = {
                    Xa,
                    Set.non(OK),
                    Set.appartient('Pre',ha),
                    Set.appartient('Post',ha),
                    Set.non(Set.egal(A*Pre,empty)),
                    Xa_,
                    Set.egal(A_,Set.moinsProp(Post,ha))

                }
            },
            t7 = {
                Conditions = {
                    Xa,
                    Set.non(OK),
                    Set.non(Set.appartient('Post',ha)),
                    Set.non(Set.appartient('Pre',ha)),
                    Xa_,
                    Set.egal(A_,A+Post)
                }
            },
            t8 = {
                Conditions = {
                    Xa,
                    Set.non(OK),
                    Set.appartient('Post',ha),
                    Set.non(Set.appartient('Pre',ha)),
                    Xa_,
                    Set.egal(A_,Set.moinsProp(Post,ha))
                }
            }
        }
    }
end
