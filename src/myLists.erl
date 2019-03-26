%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2019 12:29
%%%-------------------------------------------------------------------
-module(myLists).
-author("ajris").

-record(grupa, {nazwa, licznosc, stan=aktywna}).

%% API
-export([contains/2]).
-export([duplicateElements/1]).
-export([sumFloats/1]).
-export([isDividedBy3Or5/1]).

isDividedBy3Or5(Value) -> Value rem 5 == 0 orelse Value rem 3 == 0;
isDividedBy3Or5(_) -> false.

contains(Value, [Head | Tail]) -> Value == Head orelse contains(Value, Tail);
contains(_, []) -> false.

duplicateElements([Head | Tail]) -> [Head,Head] ++ duplicateElements(Tail);
duplicateElements([]) -> [].

%%sumFloats([Head | Tail]) -> if
%%                              is_float(Head) ->
%%                                Head + sumFloats(Tail);
%%                              true -> sumFloats(Tail)
%%                            end;
sumFloats([Head|Tail]) when is_float(Head) -> Head + sumFloats(Tail);
sumFloats([Head|Tail]) -> sumFloats(Tail);
sumFloats([]) -> 0.
