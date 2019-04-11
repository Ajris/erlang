%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Apr 2019 13:25
%%%-------------------------------------------------------------------
-module(pingpong).
-author("ajris").

%% API
-export([start/0]).
-export([stop/0]).
-export([play/1]).

start() ->
  FirstProcess = spawn(fun(X) ->
    receive
      _ -> io:format(X)
    end
                       end),
  SecondProcess = spawn(fun(X) ->
    receive
      _ -> io:format(X)
    end
                        end),
  register(ping, FirstProcess),
  register(pong, SecondProcess).

stop() ->
  ping ! stop,
  pong ! stop.

play(Count) ->
  ping ! xD
.
