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
-export([removeValue/4]).
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
  P5 = addValue({4, 5}, calendar:local_time(), pm10, "Wartosc", P4),
  P6 = addValue({4, 5}, calendar:local_time(), pm25, "Wartosc", P5),
  P7 = addValue({4, 5}, calendar:local_time(), temp, "Wartosc", P6),
  P8 = addValue({3, 4}, calendar:local_time(), temp, "Wartosc", P7),
  P9 = addValue("Stacja4", calendar:local_time(), pm10, "Wartosc", P8),
  P10 = removeValue({4,5}, calendar:local_time(), pm10, P9),
  LastStation = lists:last(P10#monitor.stations),
  lists:flatlength(LastStation#station.measurements)
.

createMonitor() ->
  #monitor{}.

addStation(Name, {X, Y}, Monitor) ->
  Stations = Monitor#monitor.stations,
  Result = lists:filter(fun(Station) ->
    (Station#station.coords == {X, Y}) or (Station#station.name == Name) end, Stations),
  case Result of
    [] ->
      Station = #station{name = Name, coords = {X, Y}},
      ActualizedStation = Monitor#monitor.stations ++ [Station],
      Monitor#monitor{
        stations = ActualizedStation
      };
    [_] ->
      erlang:error("That station exists")
  end
.

addValue({X, Y}, Date, Type, Value, Monitor) ->
  Stations = Monitor#monitor.stations,
  ResultStation = lists:filter(fun(Station) -> (Station#station.coords == {X, Y}) end, Stations),
  case ResultStation of
    [] ->
      erlang:error("Coudln't find that station with provided X and Y");
    [CurrentStation] ->
      case isGoodType(Type) of
        true ->
          Measurements = CurrentStation#station.measurements,
          ResultMeasurement = lists:filter(fun(Measurement) -> (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          case ResultMeasurement of
            [] ->
              Measurement = #measurement{station = CurrentStation, date = Date, type = Type, value = Value},
              ActualizedMeasurements = CurrentStation#station.measurements ++ [Measurement],
              NewCurrentStation = CurrentStation#station{
                measurements = ActualizedMeasurements
              },
              ActualizedStation = lists:delete(CurrentStation, Monitor#monitor.stations) ++ [NewCurrentStation],
              Monitor#monitor{
                stations = ActualizedStation
              };

            [CurrentMeasurement | Tail] ->
              erlang:error("Something went wrong");
            [_] -> erlang:error("Something went wrong")
          end;


        false ->
          erlang:error("Wrong type")
      end
  end;

addValue(Name, Date, Type, Value, Monitor) ->
  Stations = Monitor#monitor.stations,
  ResultStation = lists:filter(fun(Station) -> (Station#station.name == Name) end, Stations),
  case ResultStation of
    [] ->
      erlang:error("Coudln't find that station with provided X and Y");
    [CurrentStation] ->
      case isGoodType(Type) of
        true ->
          Measurement = #measurement{station = CurrentStation, date = Date, type = Type, value = Value},
          ActualizedMeasurements = CurrentStation#station.measurements ++ [Measurement],

          NewCurrentStation = CurrentStation#station{
            measurements = ActualizedMeasurements
          },
          ActualizedStation = lists:delete(CurrentStation, Monitor#monitor.stations) ++ [NewCurrentStation],
          Monitor#monitor{
            stations = ActualizedStation
          };
        false ->
          erlang:error("Wrong type")
      end
  end
.

removeValue({X, Y}, Date, Type, Monitor) ->
  Stations = Monitor#monitor.stations,
  ResultStation = lists:filter(fun(Station) -> (Station#station.coords == {X, Y}) end, Stations),
  case ResultStation of
    [] ->
      erlang:error("Coudln't find that station with provided X and Y");
    [CurrentStation] ->
      case isGoodType(Type) of
        true ->
          Measurements = CurrentStation#station.measurements,
          [ResultMeasurementHead | Tail] = lists:filter(fun(Measurement) -> (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          ResultMeasurement = [ResultMeasurementHead],
          case ResultMeasurement of
            [] ->
              erlang:error("No measurement found");
            [CurrentMeasurement] ->
              ActualizedMeasurements = lists:delete(CurrentMeasurement, CurrentStation#station.measurements),

              NewCurrentStation = CurrentStation#station{
                measurements = ActualizedMeasurements
              },
              ActualizedStation = lists:delete(CurrentStation, Monitor#monitor.stations) ++ [NewCurrentStation],

              Monitor#monitor{
                stations = ActualizedStation
              };
            [_] -> erlang:error("Something went wrong")
          end;
        false ->
          erlang:error("Wrong type")
      end
  end;

removeValue(Name, Date, Type, Monitor) ->
  Stations = Monitor#monitor.stations,
  ResultStation = lists:filter(fun(Station) -> (Station#station.name == Name) end, Stations),
  case ResultStation of
    [] ->
      erlang:error("Coudln't find that station with provided X and Y");
    [CurrentStation] ->
      case isGoodType(Type) of
        true ->
          Measurements = CurrentStation#station.measurements,
          [ResultMeasurementHead | Tail] = lists:filter(fun(Measurement) -> (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          ResultMeasurement = [ResultMeasurementHead],
          case ResultMeasurement of
            [] ->
              erlang:error("No measurement found");
            [CurrentMeasurement] ->
              ActualizedMeasurements = lists:delete(CurrentMeasurement, CurrentStation#station.measurements),

              NewCurrentStation = CurrentStation#station{
                measurements = ActualizedMeasurements
              },
              ActualizedStation = lists:delete(CurrentStation, Monitor#monitor.stations) ++ [NewCurrentStation],

              Monitor#monitor{
                stations = ActualizedStation
              };
            [_] -> erlang:error("Something went wrong")
          end;
        false ->
          erlang:error("Wrong type")
      end
  end
.

isGoodType(pm10) -> true;
isGoodType(pm25) -> true;
isGoodType(temp) -> true;
isGoodType(_) -> false.

