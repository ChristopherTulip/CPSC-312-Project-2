%% This is the base file

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

list(X)   :- X == rooms, format("test").
list(X)   :- X == people, format("test").
list(X)   :- X == weapons, format("test").
list(X)   :- format("sorry I don't understand what you mean by: ~a\nPlease use the key words people, rooms, or weapons!\n", X).

remove(X) :- weapon(X), format("removing the following weapon: ~a\n", X), remove_weapon(X).
remove(X) :- room(X),   remove_room(X).
remove(X) :- player(X), remove_player(X).

remove_weapon(X) :- output(weapon).
remove_room(X)   :- output(room).
remove_player(X) :- output(player).

output(X) :- format("heck yes ~a", X).

%% This is how we can output string values
%% swritef(S, '%w %w blah blah', ['Hello', 'World'])

