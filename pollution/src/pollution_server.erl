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
  server ! {addStation, Name, Position, self()},
  returnValue().

addValue(Key, Date, Type, Value) ->
  server ! {addValue, Key, Date, Type, Value, self()},
  returnValue().

removeValue(Key, Date, Type) ->
  server ! {removeValue, Key, Date, Type, self()},
  returnValue().

getOneValue(Key, Date, Type) ->
  server ! {getOneValue, Key, Date, Type, self()},
  returnValue().

getStationMean(Key, Type) ->
  server ! {getStationMean, Key, Type, self()},
  returnValue().

getDailyMean(Type, Date) ->
  server ! {getDailyMean, Type, Date, self()},
  returnValue().

getDailyAverageDataCount(Date) ->
  server ! {getDailyAverageDataCount, Date, self()},
  returnValue().

loopServer(Monitor) ->
  receive
    {addStation, Name, Position, PID} -> NewMonitor = pollution:addStation(Name, Position, Monitor),
      handleResult(NewMonitor, Monitor, PID);

    {addValue, Key, Date, Type, Value, PID} ->
      NewMonitor = pollution:addValue(Key, Date, Type, Value, Monitor),
      handleResult(NewMonitor, Monitor, PID);

    {removeValue, Key, Date, Type, PID} ->
      NewMonitor = pollution:removeValue(Key, Date, Type, Monitor),
      handleResult(NewMonitor, Monitor, PID);

    {getOneValue, Key, Date, Type, PID} ->
      Value = pollution:getOneValue(Key, Date, Type, Monitor),
      handleResult(Value, Monitor, PID);

    {getStationMean, Key, Type, PID} -> Value = pollution:getStationMean(Key, Type, Monitor),
      handleResult(Value, Monitor, PID);

    {getDailyMean, Type, Date, PID} -> Value = pollution:getDailyMean(Type, Date, Monitor),
      handleResult(Value, Monitor, PID);

    {getDailyAverageDataCount, Date, PID} -> Value = pollution:getDailyAverageDataCount(Date, Monitor),
      handleResult(Value, Monitor, PID);

    {stop, PID} -> PID ! ok;

    _ -> loopServer(Monitor)
  end.

handleResult(Result, Monitor, PID) ->
  case lists:member(Result, ?SPECIFIED_EXCEPTIONS) of
    true -> io:format("Error occured: ~w", [Result]),
      PID ! Result,
      loopServer(Monitor);
    _ ->
      case Result of
        {_, _} -> io:format("Got new monitor");
        _ -> io:format("Got value ~w", [Result])
      end,
      PID ! Result,
      loopServer(Result)
  end.

returnValue() ->
  receive
    V -> V
  end.