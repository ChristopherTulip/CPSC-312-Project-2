%% entry point to the program
clue_repl :- format("\n\nWelcome to Clue!\nPlease use the following commands:\n\"stop\".\t\t->\tQuit\n\"remove\".\t->\tenter a logical deduction\n"), read(X), process(X), clue_repl.

weapon(dagger).
weapon(rope).
weapon(lead_pipe).
weapon(candlestick).
weapon(revolver).
weapon(wrench).

player(col_Mustard).
player(prof_Plum).
player(miss_Scarlett).
player(mr_Green).
player(mrs_Peacock).
player(mrs_White).

room(ballroom).
room(conservatory).
room(kitchen).
room(dining_room).
room(lounge).
room(hall).
room(study).
room(library).
room(billiard_room).

process(stop) :- halt.
process(remove) :- format("Please enter the item that you want to remove\n"), read(X), remove(X).
process(X) :- format("Sorry I didn't understand your input\n").

remove(stop) :- !.
remove(X) :- weapon(X), format("removing the following weapon: ~a\n", X), remove_weapon(X).
remove(X) :- room(X), format("removing the following room: ~a\n", X), remove_room(X).
remove(X) :- player(X),format("removing the following player: ~a\n", X), remove_player(X).
remove(X) :- format("Sorry I don't understand that item\n"), process(remove).

remove_weapon(X) :- output(weapon).
remove_room(X)   :- output(room).
remove_player(X) :- output(player).

output(X) :- format("heck yes ~a\n", X).

%% This is how we can output string values
%% swritef(S, '%w %w blah blah', ['Hello', 'World'])

