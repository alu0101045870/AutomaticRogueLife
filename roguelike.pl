% -----------------------------------
%  Declaring dynamic methods

:- dynamic ([
       heroe_location/1,
       current_goal/1,
       npc_locations/1,
       monster_locations/1,
       trapdoor_location/1,
%       obst_locations/1,            %obstacles in the future
       visited_cells/1,
       name/1,
       gender/1,
       has_weapon/1,
       has_key/1,
%       exp_gained/1,
%       hp/1,
%       atk/1,
       npc_nearby/0,
       visited_friends/1
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
    But watch closely!' , [CN])
    ;           format('~p ended up in a subterranean and got separated from her friends.
It is her mission to find them and get out of here.\n
For that she has to:\n\n
    1. Find the key. Abby knows where it is.\n
    2. Get a sword. Nero always has one with him (for some reason).\n
    3. Get to the trapdoor. Margarette probably knows the way\n\n

    Aaaand thats about it! You (player) dont really have to do much.\n
    But watch closely!\n\n\n' , [CN])
    )

    ,    help_me

    .

help_me :-
    format('\n\nCommands:\n\n
    - "start."   -> Start game with random values.\n
    - "behave."  -> Interact with surroundings (talk, check on monsters, etc)\n
    - "talk."    -> Talk to friend if around.\n
    - "try_and_leave." -> If near the exit and you have key, leave.\n
    - "move."    -> Move automatically to checkpoint.\n
    - "oneStep." -> Take only ONE STEP towards the goal (may be useful when monsters are around!)\n
    (TIPS): Moving without a goal is not a good idea. It´d be better to check on your surroundings first!').


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
    heroe_location(X),
    (   juli_near(X)
    ;   marg_near(X)
    ;   nero_near(X)
    ;   abby_near(X)
    ;    false).

see_campfire(no).

juli_near(Loc) :-
    npc_locations([[_, X],[_, _],[_, _],[_, _]]),
    adjacent(X, Loc).

marg_near(Loc) :-
    npc_locations([[_, _],[_, _],[_, _],[_, X]]),
    adjacent(X, Loc).

nero_near(Loc) :-
    npc_locations([[_, _],[_, _],[_, X],[_, _]]),
    adjacent(X, Loc).

abby_near(Loc) :-
    npc_locations([[_, _],[_, X],[_, _],[_, _]]),
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
game_over :-
    format('\n\n          GAME OVER         \n\n
    Please, if you want to start again, type "start."').

init_agent(G, CN) :-
    retractall( heroe_location(_)),
    assert( heroe_location([1,1])),

    retractall(gender(_)),
    assert(gender(G)),

    retractall(name(_)),
    assert(name(CN)),

%    retractall( exp_gained(_)),
%    assert( exp_gained(0)),

%    retractall( hp(_)),
%    assert( hp(5)),

%    retractall( atk(_)),
%    assert( atk(10)),
%
    retractall(has_weapon(_)),
    assert(has_weapon(no)),        % Start without a weapon

    retractall(has_key(_)),
    assert(has_key(no)),

    retractall(current_goal(_)),   % Start is null

    retractall(visited_cells(_)),
    assert(visited_cells([[1,1]])),

    retractall(visited_friends(_)),
    assert(visited_friends([no, no, no ,no]))
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

    retractall(trapdoor_location(_)),
    random_between(1, WS, T1), random_between(1, WS, T2),
    assert(trapdoor_location([T1, T2])),

    init_agent(G, CN),
    init_npcs(WS),
    init_monsters(WS).

%------------------------------------------------
% Actions

    visit(Xs) :-
        visited_cells(Ys),
        npc_locations([[_, J], [_, A], [_, N], [_, M]]),

        (   J \= Xs, A \= Xs, N \= Xs, M \= Xs ->
            retractall(visited_cells(_)),
            assert(visited_cells([Xs|Ys]))
        ;   true
        ).

    move :-
        %ATM only checks monsters around at the start
        mon_check.

    moving :-
        heroe_location(H),
        current_goal(G),
        (   not(adjacent(H, G)) ->
                oneStep, moving           %recursion may happen
        ;   name(Name),
            look_around(Camp, Smell, Wind),
            format('\n~p: Woah, something´s up...Lets see what I can do', Name)
        ).

    mon_check :-
        smelly(S),
        (   S = yes ->
            has_weapon(X),
           (   X = no ->
                format('\n\nYou DED\n\n
                   GAME OVER\n\nPlease restrart (start.)')
           ;   X = yes ->
                format('\n\nYou killed a monster that blocked the way!'),
                oneStep, moving
           )
        ;   oneStep, moving
        ).

    oneStep :-
        heroe_location([H1, H2]),
        current_goal([G1, G2]),
        (   H1 \= G1 -> stepToX(G1)
        ;   not(adj(H2, G2)) -> stepToY(G2)
        ;   name(Name),
            format('~p: This is my current goal!', Name)

        ),
        heroe_location(X),
        visit(X),
        visited_cells([[V1,V2]|_]),
        format('Visited: [~w,~w]\n', [V1, V2])
        .

    stepToX(GoalX) :-
        heroe_location([H1, H2]),
        (   NewX is H1+1; NewX is H1-1),   %prolog things: LOGIC
        (   H1 < GoalX -> NewX is H1+1,
            retractall(heroe_location(_)),
            assert(heroe_location([NewX, H2]))

        ;   NewX is H1-1,
            retractall(heroe_location(_)),
            assert(heroe_location([NewX, H2]))
        ).

    stepToY(GoalY) :-
        heroe_location([H1, H2]),
        (   NewY is H2+1; NewY is H2-1),
        (   H2 < GoalY -> NewY is H2+1,
            (   not(adj(H2, GoalY)) ->
                  retractall(heroe_location(_)),
                  assert(heroe_location([H1, NewY]))
            ;   true)    %prolog's "do nothing"
        ;   NewY is H2-1,
            (   not(adj(H2, GoalY)) ->
                  retractall(heroe_location(_)),
                  assert(heroe_location([H1, NewY]))
            ;   true)
        ).


    behave :-
         look_around(Camp, Smell, Wind),

         (  Camp=yes -> talk
         ;   fail
         ),
         ( Smell=yes -> monster_around
         ;   fail
         ),
         (  Wind=yes -> try_and_leave
         ;   fail
         ).

    monster_around :-
         name(Name),
         smelly(S),
         (   S=yes ->
             has_weapon(X),
            (   X=no ->
            format('\n\n~p: I´m near a monster. I better walk slowly to avoid getting', Name)
            ;   true
            )
         ;    fail
         ).

    try_and_leave :-
         name(Name),
         has_key(K),
         windy(W),
         (   W=yes ->
         format('\n~p: It looks like the exit is ahead', Name),
         (   K=yes -> format('\n\n~p (Shouting): I´M OUTA HERE BOIS', Name),
                      game_over

         ;   where_is(abigail, AbPos),
             retractall(current_goal(_)),
             assert(current_goal(AbPos)),
             format('\n\n~p: Hmmm. I don´t have the key, so I cannot leave yet\nI have to find Abby first', Name)
         ;   fail
         )).


    talk :-
         heroe_location(C),
         visited_cells(L),
         (   juli_near(C) ->
                 where_is(julian, J),
                 retractall(visited_cells(_)),
                 assert(visited_cells([J|L])),
                 talk_to_julian(L)
          ;  abby_near(C) ->
                 where_is(abigail, A),
                 retractall(visited_cells(_)),
                 assert(visited_cells([A|L])),
                 talk_to_abby(L)
          ;  nero_near(C) ->
                 where_is(nero, N),
                 retractall(visited_cells(_)),
                 assert(visited_cells([N|L])),
                 talk_to_nero(L)
          ;  marg_near(C) ->
                 where_is(margarette, M),
                 retractall(visited_cells(_)),
                 assert(visited_cells([M|L])),
                 talk_to_marg(L)
         ).

    talk_to_julian(L) :-
          where_is(julian, NpcPos),        %
         (   not_member(NpcPos, L) ->
             retractall(current_goal(_)),
             where_is(abigail, X),
             assert(current_goal(X)),
             format('\n\nJULIAN: Oh, so you woke up huh? Always so cryptic, aren´t you? Well, hear me out:\nGo find Abby and ask for the key. She probably has it already. \nHere´s the map- She should be around here\n')
         ;   name(Name),
             format('\n\nJULIAN: Mmmm, hey ~p , are you lost or something?'                    , Name)
         ),
         visited_friends([_, Abb, Ner, Mar]),
         retractall(visited_friends(_)),
         assert(visited_friends([yes, Abb, Ner, Mar]))
         .

    talk_to_abby(L) :-
          where_is(abigail, NpcPos),
          (   not_member(NpcPos, L) ->
              retractall(current_goal(_)),   %change goal
              where_is(nero, X),
              assert(current_goal(X)),
              name(Name),
              retractall(has_key(_)),        %get key
              assert(has_key(yes)),
              format('\n\nABIGAIL: Hey ~p! How is JULIAN doing?\n
Anyways, I found this KEY. It may be our way out of here, so keep it with you, OK?', Name)
          ; name(Name),
            format('\n\nABIGAIL: Mmmmm, hey ~p, are you lost or something?', Name)
          ),
         visited_friends([Jul, _, Ner, Mar]),
         retractall(visited_friends(_)),
         assert(visited_friends([Jul, yes, Ner, Mar]))
          .

    talk_to_nero(L) :-
          where_is(nero, NpcPos),
          (   not_member(NpcPos, L) ->
              where_is(margarette, X),
              retractall(current_goal(_)),    %change goal
              assert(current_goal(X)),
              name(Name),
              retractall(has_weapon(_)),      %get weapon
              assert(has_weapon(yes)),
              format('\n\nNERO: Long time no see, ~p. Are your survival skills on point? Wait, I dont see you carrying a weapon!\nIm ashamed of calling you a friend! Here is a spare one I SO HAPPEN to have', Name)
          ;   name(Name),
              format('\n\nNERO: Mmmmm, hey ~p, are you lost or something?', Name)
          ),
         visited_friends([Jul, Abb, _, Mar]),
         retractall(visited_friends(_)),
         assert(visited_friends([Jul, Abb, yes, Mar]))
          .

    talk_to_marg(L) :-
          where_is(margarette, NpcPos),
          (   not_member(NpcPos, L) ->
              retractall(current_goal(_)),
              trapdoor_location(X),
              assert(current_goal(X)),
              name(Name),
              format('\n\nMARGARETTE: It sure took you a while ~p. Anyways, lets get going already. I will tell you where the exit is ', Name)
          ;   name(Name),
              format('\n\nMARGARETTE: Mmmmm, hey ~p, are you planning on staying here forever?', Name)
          ),
          visited_friends([Jul, Abb, Ner, _]),
          retractall(visited_friends(_)),
          assert(visited_friends([Jul, Abb, Ner, yes]))

          .

    look_around(Camp,Smell,Wind) :-
         name(Name),
         make_percept_sentence([Camp, Smell, Wind]),

         %Campings around?
         (   Camp=yes -> format('~p: I can see a camp\n', Name)
         ;   format('~p: Nobody around\n', Name)),

         %Monsters around?
         (   Smell=yes -> format('~p: It smells like Nero´s wardrove!\nThat means monsters are around\n', Name)
         ;   format('~p: It´s safe here\n', Name)),

         %Exit around?
         (   Wind=yes -> format('~p: This wind - I must be close to the exit!\n', Name)
         ;   format('~p: I can´t feel the wind..\n', Name)
         ).

    make_percept_sentence([Camp, Smell, Wind]) :-
         see_campfire(Camp),
         smelly(Smell),
         windy(Wind).

%------------------------------------------------
% Utils

not_member(_, []).
not_member([X,Y], [[U,V]|Ys]) :-
    ( X=U,Y=V -> fail
    ; not_member([X,Y], Ys)
    ).








































