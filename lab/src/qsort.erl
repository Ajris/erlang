%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Mar 2019 13:11
%%%-------------------------------------------------------------------
-module(qsort).
-author("ajris").

%% API
-export([qs/1]).
-export([randomElems/3]).
-export([compareSpeeds/3]).

qs([Pivot | Tail]) -> qs(lessThan(Tail, Pivot)) ++ [Pivot] ++ qs(grtEqThan(Tail, Pivot));
qs([]) -> [].
lessThan(List, Arg) -> [X || X <- List, X < Arg].
grtEqThan(List, Arg) -> [X || X <- List, X >= Arg].

randomElems(N, Min, Max) -> [rand:uniform(Max - Min + 1) + Min - 1 || _ <- lists:seq(1, N)].
compareSpeeds(List, Fun1, Fun2) -> {timer:tc(Fun1,[List]), timer:tc(Fun2,[List])}.