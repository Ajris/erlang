%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2019 23:11
%%%-------------------------------------------------------------------
-module(pollution).
-author("ajris").

%% API
-export([test/0]).
-export([createMonitor/0]).
-export([addStation/3]).
-export([addValue/5]).
%%-export([removeValue/4]).
%%-export([getOneValue/4]).
%%-export([getStationMean/3]).
%%-export([getDailyMean/3]).
%%-export([getDailyAverageDataCount/3]).

-record(monitor, {stations = []}).
-record(station, {name, coords, measurements = []}).
-record(measurement, {station, date, type, value}).
-record(coords, {x, y}).

test() ->
  P = createMonitor(),
  P1 = addStation("Stacja1", {1, 2}, P),
  P2 = addStation("Stacja2", {2, 3}, P1),
  P3 = addStation("Stacja3", {3, 4}, P2),
  P4 = addStation("Stacja4", {4, 5}, P3),
  P5 = addValue({4, 5}, calendar:local_time(), "Typ", "Wartosc", P4),
  P6 = addValue({4, 5}, calendar:local_time(), "Typ1", "Wartosc", P5),
  P7 = addValue({4, 5}, calendar:local_time(), "Typ2", "Wartosc", P6),
  P8 = addValue({4, 5}, calendar:local_time(), "Typ3", "Wartosc", P7),
  LastStation = lists:last(P8#monitor.stations),
  lists:flatlength(LastStation#station.measurements)
.

createMonitor() ->
  #monitor{}.

addStation(Name, {X, Y}, Monitor) ->
  Station = #station{name = Name, coords = {X, Y}},
  ActualizedStation = Monitor#monitor.stations ++ [Station],
  Monitor#monitor{
    stations = ActualizedStation
  }.

addValue({X, Y}, Date, Type, Value, Monitor) ->
  [Stations] = [Monitor#monitor.stations],
  Result = lists:filter(fun(Station) -> (Station#station.coords == {X, Y}) end, Stations),
  case Result of
    [] ->
      erlang:error("Coudln't find that station with provided X and Y");
    [Current] ->
      Measurement = #measurement{station = Current, date = Date, type = Type, value = Value},
      ActualizedMeasurements = Current#station.measurements ++ [Measurement],

      NewCurrent = Current#station{
        measurements = ActualizedMeasurements
      },
      ActualizedStation = lists:delete(Current,Monitor#monitor.stations) ++ [NewCurrent],
      Monitor#monitor{
        stations = ActualizedStation
      };
    _ ->
      erlang:error("If this goes here I am out")
  end;

addValue(Name, Date, Type, Value, Monitor) ->
  erlang:error(not_implemented).

