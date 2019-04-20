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

-include("pollution.hrl").

%% API
-export([start/0]).
-export([stop/0]).
-export([addStation/2]).
-export([addValue/4]).
-export([removeValue/3]).
-export([getOneValue/3]).
-export([getStationMean/2]).
-export([getDailyMean/2]).
-export([getDailyAverageDataCount/1]).

start() ->
  PID = spawn(fun() -> init() end),
  register(server, PID),
  io:format("SERVER STARTED").

stop() ->
  server ! {stop, self()},
  io:format("KONIEC").

init() ->
  Monitor = pollution:createMonitor(),
  loopServer(Monitor).

addStation(Name, Position) ->
  server ! {addStation, Name, Position, self()}.

addValue(NameOrPosition, Date, Type, Value) ->
  server ! {addValue, NameOrPosition, Date, Type, Value, self()}.

removeValue(NameOrPosition, Date, Type) ->
  server ! {removeValue, NameOrPosition, Date, Type, self()}.

getOneValue(NameOrPosition, Date, Type) ->
  server ! {getOneValue, NameOrPosition, Date, Type, self()}.

getStationMean(NameOrPosition, Type) ->
  server ! {getStationMean, NameOrPosition, Type, self()}.

getDailyMean(Type, Date) ->
  server ! {getDailyMean, Type, Date, self()}.

getDailyAverageDataCount(Date) ->
  server ! {getDailyAverageDataCount, Date, self()}.

loopServer(Monitor) ->
  receive
    {addStation, Name, Position, PID} -> NewMonitor = pollution:addStation(Name, Position, Monitor),
      handleResult(NewMonitor, Monitor);

    {addValue, NameOrPosition, Date, Type, Value, PID} ->
      NewMonitor = pollution:addValue(NameOrPosition, Date, Type, Value, Monitor),
      handleResult(NewMonitor, Monitor);

    {removeValue, NameOrPosition, Date, Type, PID} ->
      NewMonitor = pollution:removeValue(NameOrPosition, Date, Type, Monitor),
      handleResult(NewMonitor, Monitor);

    {getOneValue, NameOrPosition, Date, Type, PID} ->
      Value = pollution:getOneValue(NameOrPosition, Date, Type, Monitor),
      handleResult(Value, Monitor);

    {getStationMean, NameOrPosition, Type, PID} -> Value = pollution:getStationMean(NameOrPosition, Type, Monitor),
      handleResult(Value, Monitor);

    {getDailyMean, Type, Date, PID} -> Value = pollution:getDailyMean(Type, Date, Monitor),
      handleResult(Value, Monitor);

    {getDailyAverageDataCount, Date, PID} -> Value = pollution:getDailyAverageDataCount(Date, Monitor),
      handleResult(Value, Monitor);

    {stop, PID} -> PID ! ok;

    _ -> loopServer(Monitor)
  end.

handleResult(Result, Monitor) ->
  case lists:member(Result, ?SPECIFIED_EXCEPTIONS) of
    true -> io:format("Error occured: ~w", [Result]),
      loopServer(Monitor);
    _ ->
      case Result of
        {_, _} -> io:format("Got new monitor");
        _ -> io:format("Got value ~w", [Result])
      end,
      loopServer(Result)
  end.