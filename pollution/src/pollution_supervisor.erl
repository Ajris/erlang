%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. May 2019 19:44
%%%-------------------------------------------------------------------
-module(pollution_supervisor).
-author("ajris").

%% API
-behaviour(supervisor).

-export([start_link/0]).
-export([start_link_shell/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link_shell() ->
  {ok, Pid} = supervisor:start_link({local, ?SERVER}, ?MODULE, []),
  unlink(Pid).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  io:format("~p (~p) starting... ~n", [{local, ?MODULE}, self()]),

  RestartStrategy = one_for_one,
  MaxRestarts = 10,
  MaxSecondsBetweenRestarts = 60,
  Flags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 3600,
  Type = worker,

  ChildSpec = {pollution_serverID, {pollution_server, start_link, []},
    Restart, Shutdown, Type, [pollution_gen_server]},

  {ok, {Flags, [ChildSpec]}}.