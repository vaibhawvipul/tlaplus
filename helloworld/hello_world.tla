---- MODULE hello_world ----

EXTENDS Sequences 

VARIABLES alices_outbox, network, bobs_mood, bobs_inbox

Init == 
    /\ alices_outbox = {} 
    /\ network = {}
    /\ bobs_mood = "neutral"
    /\ bobs_inbox = <<>>

AliceSends(m) == 
    /\ m \notin alices_outbox
    /\ alices_outbox' = alices_outbox \union {m}
    /\ network' = network \union {m}
    /\ UNCHANGED <<bobs_mood, bobs_inbox>>

NetworkLoss == 
    /\ \E e \in network: network' = network \ {e}
    /\ UNCHANGED <<bobs_inbox, bobs_mood, alices_outbox>>

NetworkDeliver == 
    /\ \E e \in network:
        /\ bobs_inbox' = bobs_inbox \o <<e>>
        /\ network' = network \ {e}
    /\ UNCHANGED <<bobs_mood, alices_outbox>>

BobCheckInbox == 
    /\ bobs_mood' = IF bobs_inbox = <<"hello", "world">> THEN "happy" ELSE "neutral"
    /\ UNCHANGED <<network, bobs_inbox, alices_outbox>>

Next == 
    \/ AliceSends("hello")
    \/ AliceSends("world")
    \/ NetworkLoss
    \/ NetworkDeliver
    \/ BobCheckInbox

NothingUnexpectedInNetwork == \A e \in network: e \in alices_outbox

NotBobIsHappy ==
    LET BobisHappy == bobs_mood = "happy"
    IN ~BobisHappy

====