%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 14:04
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("ajris").

-include("pollution_header.hrl").

-behavior(gen_server).

-define(SERVER, ?MODULE).

%% API
-export([stop/0]).
-export([addStation/2]).
-export([addValue/4]).
-export([removeValue/3]).
-export([getOneValue/3]).
-export([getStationMean/2]).
-export([getDailyMean/2]).
-export([getDailyAverageDataCount/1]).
-export([start_link/0]).
-export([init/1]).
-export([terminate/2]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([code_change/3]).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop()->
  gen_server:stop(?SERVER).

terminate(Reason, State) ->
  io:format("Server terminated REASON: ~p, STATE ~p~n]", [Reason, State]).

init([]) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting... ~n", [{local, ?SERVER}, self()]),
  State = #monitor{},
  {ok, State}.

addStation(Name, Position) ->
  gen_server:call(?MODULE, {addStation, Name, Position}).

addValue(Key, Date, Type, Value) ->
  gen_server:call(?MODULE, {addValue, Key, Date, Type, Value}).

removeValue(Key, Date, Type) ->
  gen_server:call(?MODULE, {removeValue, Key, Date, Type, self()}).

getOneValue(Key, Date, Type) ->
  gen_server:call(?MODULE, {getOneValue, Key, Date, Type, self()}).

getStationMean(Key, Type) ->
  gen_server:call(?MODULE, {getStationMean, Key, Type, self()}).

getDailyMean(Type, Date) ->
  gen_server:call(?MODULE, {getDailyMean, Type, Date, self()}).

getDailyAverageDataCount(Date) ->
  gen_server:call(?MODULE, {getDailyAverageDataCount, Date, self()}).

handle_call({addStation, N, C}, _From, State) ->
  case pollution:addStation(N, C, State) of
    #monitor{} = M ->
      {reply, ok, M};
    Failed ->
      {reply, Failed, State}
  end;

handle_call({addValue, K, Tm, Tp, V}, _From, State) ->
  case pollution:addValue(K, Tm, Tp, V, State) of
    #monitor{} = M ->
      {reply, ok, M};
    Failed ->
      {reply, Failed, State}
  end;

handle_call({removeValue, K, Tm, Tp}, _From, State) ->
  case pollution:removeValue(K, Tm, Tp, State) of
    #monitor{} = M ->
      {reply, ok, M};
    Failed ->
      {reply, Failed, State}
  end;

handle_call({getOneValue, K, Tm, Tp}, _From, State) ->
  case pollution:getOneValue(K, Tm, Tp, State) of
    Value when is_float(Value) ->
      {reply, Value, State};
    Failed ->
      {reply, Failed, State}
  end;

handle_call({getStationMean, K, Tp}, _From, State) ->
  case pollution:getStationMean(K, Tp, State) of
    Value when is_float(Value) ->
      {reply, Value, State};
    Failed ->
      {reply, Failed, State}
  end;

handle_call({getDailyMean, Tm, Tp}, _From, State) ->
  case pollution:getDailyMean(Tm, Tp, State) of
    Value when is_float(Value) ->
      {reply, Value, State};
    Failed ->
      {reply, Failed, State}
  end;

handle_call(_Request, _From, State) ->
  {reply, {error, invalid_request}, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Request, State) ->
  {noreply, State}.

code_change(_Arg0, _Arg1, _Arg2) ->
  erlang:error(not_implemented).