% -----------------------------------
%  Declaring dynamic methods

:- dynamic ([
       heroe_location/1,
       trapdoor_location/1,
       npc_locations/1,
       monster_locations/1,
%       obst_locations/1,
       visited/1,
       visited_cells/1,
       name/1,
       gender/1,
       exp_gained/1,
       hp/1,
       atk/1,
       npc_nearby/0
   ]).
             % WS = world size, G = gender(0|1), CN = Character name
start(WS, G, CN) :-
    format('\t\tAUTOMATIC ROGUELIFE\n\n', []),
    init_world(WS, G, CN),

    introduction(G, CN).

start :-
    format('\t\tAUTOMATIC ROGUELIFE\n\n', []),
    init_world(10, 0, "Hiro"),

    introduction(0, "Hiro").



introduction(G, CN) :-

    ( G = 0 ->  format('~p ended up in a subterranean and got separated from his friends.
It is his mission to find them and get out of here.\n
For that he has to:\n\n
    1. Find the key. Abby knows where it is.\n
    2. Get a sword. Nero always has one with him (for some reason).\n
    3. Get to the trapdoor. Margarette probably knows the way\n\n

    Aaaand thats about it! You (player) do absolutely nothing.\n
    But watch closely!' , [CN]);

                format('~p ended up in a subterranean and got separated from her friends.
It is her mission to find them and get out of here.\n
For that she has to:\n\n
    1. Find the key. Abby knows where it is.\n
    2. Get a sword. Nero always has one with him (for some reason).\n
    3. Get to the trapdoor. Margarette probably knows the way\n\n

    Aaaand thats about it! You (player) do absolutely nothing.\n
    But watch closely!\n\n\n' , [CN])
    )


    .




%------------------------------------
% Knowledge

character(CH) :- lives(CH, jospallad).
npc(julian).
npc(margarette).
npc(nero).
npc(abigail).
npc(NPC) :- lives(NPC, jospallad).

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
    monster_locations(P).

where_is(NPC, L) :-
    npc_locations([[NPC, L], [_,_], [_,_], [_,_]]);
    npc_locations([[_,_], [NPC, L], [_,_], [_,_]]);
    npc_locations([[_,_], [_,_], [NPC, L], [_,_]]);
    npc_locations([[_,_], [_,_], [_,_], [NPC, L]]).

see_campfire(yes) :-
    heroe_location([X,Y]),
    juli_near([X,Y]);
    marg_near([X,Y]);
    nero_near([X,Y]);
    abby_near([X,Y]).

see_campfire(no).

juli_near(Loc) :-
    npc_locations([[_, X],[_, _],[_, _],[_, _]]),
    adjacent(X, Loc).

marg_near(Loc) :-
    npc_locations([[_, _],[_, X],[_, _],[_, _]]),
    adjacent(X, Loc).

nero_near(Loc) :-
    npc_locations([[_, _],[_, _],[_, X],[_, _]]),
    adjacent(X, Loc).

abby_near(Loc) :-
    npc_locations([[_, _],[_, _],[_, _],[_, X]]),
    adjacent(X, Loc).

        % Monsters smell... duh
smelly(yes) :-
    heroe_location(AL),
    isMonster(ML),
    adjacent(AL,ML).

smelly(no).

        % trapdoor = wind
windy(yes) :-
    heroe_location(AL),
    trapdoor_location(TL),
    adjacent(AL, TL).

windy(no).

%--------------------------------------------
% Game setup

init_agent(G, CN) :-
    retractall( heroe_location(_)),
    assert( heroe_location([1,1])),

    retractall(gender(_)),
    assert(gender(G)),

    retractall(name(_)),
    assert(name(CN)),

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


    assert( npc_locations([[julian, [1,2]],[abigail,[X1, Y1]],[nero, [X2, Y2]],[margarette,[X3, Y3]]])).

init_monsters(WS) :-
    retractall( monster_locations(_)),
    random_between(1, WS, X1), random_between(1, WS, Y1),
    random_between(1, WS, X2), random_between(1, WS, Y2),
    random_between(1, WS, X3), random_between(1, WS, Y3),
    random_between(1, WS, X4), random_between(1, WS, Y4),

    assert( monster_locations([X1,Y1])),
    assert( monster_locations([X2,Y2])),
    assert( monster_locations([X3,Y3])),
    assert( monster_locations([X4,Y4])).

init_world(WS, G, CN) :-
    retractall( world_size(_)),
    assert( world_size(WS) ),
%    init_obst(WS),

    retractall(visited(_)),
    assert(visited(1)),

    retractall(visited_cells(_)),
    assert(visited_cells([])),

    retractall(trapdoor_location(_)),

    init_agent(G, CN),
    init_npcs(WS),
    init_monsters(WS).

%------------------------------------------------
% Actions

    visit(Xs) :-
        visited_cells(Ys),
        retractall(visited_cells(_)),
        assert(visited_cells([Ys|Xs])).

%    take_steps(VisitedList) :-
%%        look_around(Perception),
%        heroe_location(HL),
%        npc_locations(NPCL).




%------------------------------------------------
% Utils

not_member(_, []).
not_member([X,Y], [[U,V]|Ys]) :-
    ( X=U,Y=V -> fail
    ; not_member([X,Y], Ys)
    ).




















