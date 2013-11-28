:- dynamic suggestions/1.
suggestions([]).

suggestion(P) :- suggestions(L1), suggestion_helper(P, L1).
suggestion_helper(P, [P|T]).
suggestion_helper(P, [H|T]) :- suggestion_helper(P, T).

:- dynamic weapons/1.
weapons([knife, rope, pipe]). %, candlestick, gun, wrench]).

weapon(P) :- weapons(L1), weapon_helper(P, L1).
weapon_helper(P, [P|T]).
weapon_helper(P, [H|T]) :- weapon_helper(P, T).

:- dynamic gone_weapons/1.
gone_weapons([]).
are_gone_weapons :- gone_weapons(H), H = [].

:- dynamic players/1.
players([mustard, plum, scarlett]). %, green, peacock, white]).

player(P) :- players(L1), players_helper(P, L1).

players_helper(P, [P|T]).
players_helper(P, [H|T]) :- players_helper(P, T).

:- dynamic gone_players/1.
gone_players([]).
are_gone_players :- gone_players(H), H = [].

:- dynamic rooms/1.
rooms([kitchen, lounge]). %, lounge, hall, study, library, billiards_room, conservatory, ball_room ]).

room(P) :- rooms(L1), rooms_helper(P, L1).
rooms_helper(P, [P|T]).
rooms_helper(P, [H|T]) :- rooms_helper(P, T).

:- dynamic gone_rooms/1.
gone_rooms([]).
are_gone_rooms :- gone_rooms(H), H = [].

%% entry point to the program
clue    :- format("Enter the number of players OR ELSE!\n"),
           read(C),
           X is 18 / C,
           format("So you want to play clue...\nI'm going to need to you enter your cards\n"),
           enter_cards(0, X),
           repl.

enter_cards(Y, Y)  :- remove(stop).
enter_cards(X, Y)  :- Next is (X+1), process(remove), enter_cards(Next, Y).

repl :- format("\n\nWelcome to Clue!\nPlease use the following commands:\n"),
  format("guess.\t\t\t->\tGet me to tell you what to think!\n"),
  format("remove.\t\t\t->\tEnter a logical deduction\n"),
  format("print_suggestions.\t->\tView previous suggestions\n"),
  format("view_database.\t\t->\tprint all valid items in the db\n"),
  format("stop.\t\t\t->\tQuit\n"),
  read(X),
  process(X),
  check_if_done,
  repl.

process(next).

process(stop)         :-  halt.

process(guess)        :-  format("Please enter the type you want to guess for otherwise enter none.\n"),
                          format("room.\t\t->\tGets you closer to the correct room\n"),
                          format("weapon.\t\t->\tGets you closer to the correct weapon\n"),
                          format("player.\t->\tGets you closer to the correct player\n"),
                          read(X),
                          guess(X).

process(remove)       :-  format("Please enter the item that you want to remove\n"),
                          read(X),
                          remove(X).

process(view_database) :- process(valid_weapons),
                          process(valid_rooms),
                          process(valid_players).

process(valid_players) :-  format("The remaining valid players are: \n"),
                          players(L1),
                          print_players( L1 ).

process(valid_rooms)  :-  format("The remaining valid rooms are: \n"),
                          rooms(L1),
                          print_rooms(L1).

process(valid_weapons):-  format("The remaining valid weapons are: \n"),
                          weapons(L1),
                          print_weapons(L1).

process( print_suggestions ) :- format("The suggestions you have made are: \n"),
                                suggestions(L1),
                                print_suggestions(L1).

process(X) :- format("Process: Sorry I didn't understand your input\n").

print_guess(Room, Weapon, Player) :- format("You should make this awesome guess:\n"),
                             format("Room: ~w", Room),
                             format(" Weapon: ~w ", Weapon ),
                             format("Player: ~w\n", Player).

guess(room)   :- rooms([RH|RT]),
                 not(are_gone_weapons), gone_weapons([WH|WT]),
                 not(are_gone_players), gone_players([PH|PT]),
                 suggestions(L1),
                 retract( suggestions(L1) ),
                 assert( suggestions( [ (RH, WH, PH) | L1 ] ) ),
                 print_guess([RH|RT], [WH|WT], [PH|PT]).

guess(player) :- players([PH|PT]),
                 not( are_gone_weapons), gone_weapons([WH|WT]),
                 not( are_gone_rooms ), gone_rooms([RH|RT]),
                 suggestions(L1),
                 retract( suggestions(L1) ),
                 assert( suggestions([(RH, WH, PH)|L1]) ),
                 print_guess([RH|RT], [WH|WT], [PH|PT]).

guess(weapon) :- weapons([WH|WT]),
                 not( are_gone_rooms ), gone_rooms([RH|RT]),
                 not( are_gone_players ), gone_players([PH|PT]),
                 suggestions(L1),
                 retract( suggestions(L1) ),
                 assert( suggestions([(RH, WH, PH)|L1]) ),
                 print_guess([RH|RT], [WH|WT], [PH|PT]).

guess(C)      :- weapons([WH|WT]),
                 rooms([RH|RT]),
                 players([PH|PT]),
                 retract( suggestions(L1) ),
                 assert( suggestions([(RH, WH, PH)|L1]) ),
                 print_guess([RH|RT], [WH|WT], [PH|PT]).

check_if_done :- check_rooms,
                 check_players,
                 check_weapons,
                 format("\n\n
 *****************************
     Make this accusation!
 *****************************\n\n"),
                 process(valid_rooms),
                 process(valid_players),
                 process(valid_weapons).
check_if_done.

check_rooms         :- rooms(L1), L1 = [X].
check_players       :- players(L1), L1 = [X].
check_weapons       :- weapons(L1), L1 = [X].

print_suggestions([]).
print_suggestions([H|T]) :- suggestion(H), format("\t~w\n", H), print_suggestions(T).
print_suggestions([H|T]) :- print_suggestions(T).

print_players([]).
print_players([H|T]) :- player(H), format("\t~w\n", [H|T]), print_players(T).
print_players([H|T]) :- print_players(T).

print_rooms([]).
print_rooms([H|T]) :- room(H), format("\t~w\n", [H|T]), print_rooms(T).
print_rooms([H|T]) :- print_rooms(T).

print_weapons([]).
print_weapons([H|T]) :- weapon(H), format("\t~w\n", [H|T]), print_weapons(T).
print_weapons([H|T]) :- print_weapons(T).

remove(stop).
remove(X) :- room(X), format("removing the following room: ~a\n", X), remove_room(X).
remove(X) :- player(X),format("removing the following player: ~a\n", X), remove_player(X).
remove(X) :- weapon(X), format("removing the following weapon: ~a\n", X), remove_weapon(X).
remove(X) :- format("Remove: Sorry I don't understand that item.\nuse the stop. command to go back\n"), remove(stop).

remove_weapon(X) :- weapons(L1),
                    gone_weapons(L3),
                    delete(L1, X, L2),
                    retract( weapons(L1) ),
                    assert( weapons(L2) ),
                    retract( gone_weapons(L3) ),
                    assert( gone_weapons( [X|L3] ) ),
                    process(valid_weapons).

remove_room(X)   :- rooms(L1),
                    delete(L1, X, L2),
                    retract( rooms(L1) ),
                    assert( rooms(L2) ),
                    retract( gone_rooms(L3) ),
                    assert( gone_rooms( [X|L3] ) ),
                    process(valid_rooms).

remove_player(X) :- players(L1),
                    delete(L1, X, L2),
                    retract( players(L1) ),
                    assert( players(L2) ),
                    retract( gone_players(L3) ),
                    assert( gone_players( [X|L3] ) ),
                    process(valid_players).
