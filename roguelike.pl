% -----------------------------------
%  Declaring dynamic methods

:- dynamic ([
       heroe_location/1,
%       treasure_location/1,
       npc_locations/1,
       monster_locations/1,
%       visited/1,
%       visited_cells/1,
       exp_gained/1,
       hp/1,
       atk/1
   ]).

start(WS) :-
    format('E A SPORTS ... CHENEGUEIN\n\n', []),
    init_world(WS),
    format('Escribe, crack', []).

%------------------------------------
% Knowledge

character(heroe).
character(CH) :- lives(CH, la_laguna).
npc(julian).
npc(margarette).
npc(nero).
npc(abigail).
npc(NPC) :- lives(NPC, la_laguna).

where_is(NPC, L) :-
    npc_locations([[NPC, L], [_,_], [_,_], [_,_]]);
    npc_locations([[_,_], [NPC, L], [_,_], [_,_]]);
    npc_locations([[_,_], [_,_], [NPC, L], [_,_]]);
    npc_locations([[_,_], [_,_], [_,_], [NPC, L]]).

%------------------------------------
% Perceptors

permitted(X) :-
    world_size(WS),
    0 < X,
    X < WS+1.

adj(X,Y) :-
    (   permitted(X),
        (   X is Y+1
    ;       X is Y-1)).

adjacent( [X1, Y1], [X2, Y2] ) :-
    (   X1 = X2, adj(Y1, Y2)
    ;   Y1 = Y2, adj(X1, X2)
    ).

isMonster(P) :-
    monster_locations([P,_,_,_]);
    monster_locations([_,P,_,_]);
    monster_locations([_,_,P,_]);
    monster_locations([_,_,_,P]).

%--------------------------------------------
% Game setup

init_agent :-
    retractall( heroe_location(_)),
    assert( heroe_location([1,1])),

    retractall( exp_gained(_)),
    assert( exp_gained(0)),

    retractall( hp(_)),
    assert( hp(5)),

    retractall( atk(_)),
    assert( atk(10))
    .

init_npcs(WS) :-
    retractall( npc_locations(_)),
    random_between(1, WS, X1), random_between(1, WS, Y1),
    random_between(1, WS, X2), random_between(1, WS, Y2),
    random_between(1, WS, X3), random_between(1, WS, Y3),

    assert( npc_locations([[julian, [1,1]], [margarette, [X1,Y1]], [nero,[X2,Y2]], [abigail,[X3,Y3]]])).

init_monsters(WS) :-
    retractall( monster_locations(_)),
    random_between(1, WS, X1), random_between(1, WS, Y1),
    random_between(1, WS, X2), random_between(1, WS, Y2),
    random_between(1, WS, X3), random_between(1, WS, Y3),
    random_between(1, WS, X4), random_between(1, WS, Y4),

    assert( monster_locations([[X1,Y1],[X2,Y2],[X3,Y3],[X4,Y4]])).


init_world(WS) :-
    retractall( world_size(_)),
    assert( world_size(WS) ),
    init_agent,
    init_npcs(WS),
    init_monsters(WS).

%------------------------------------------------
% Utils

not_member(_, []).
not_member([X,Y], [[U,V]|Ys]) :-
    ( X=U,Y=V -> fail
    ; not_member([X,Y], Ys)
    ).


















