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
-export([getOneValue/4]).
-export([getStationMean/3]).
-export([getDailyMean/3]).
-export([getDailyAverageDataCount/2]).

-record(monitor, {stations = []}).
-record(station, {name, coords, measurements = []}).
-record(measurement, {date, type, value}).
-record(coords, {x, y}).

test() ->
  Station = #station{name = "Stacja4", coords = {4, 5}},
  P = createMonitor(),
  P1 = addStation("Stacja1", {1, 2}, P),
  P2 = addStation("Stacja2", {2, 3}, P1),
  P3 = addStation("Stacja3", {3, 4}, P2),
  P4 = addStation("Stacja4", {4, 5}, P3),
  P5 = addValue({4, 5}, calendar:local_time(), pm10, 5, P4),
  P6 = addValue({4, 5}, calendar:local_time(), pm25, 6, P5),
  P7 = addValue({4, 5}, calendar:local_time(), temp, 7, P6),
  P8 = addValue({3, 4}, calendar:local_time(), temp, 8, P7),
  P9 = addValue("Stacja3", calendar:local_time(), pm10, 9, P8),
  P10 = removeValue({4, 5}, calendar:local_time(), pm10, P9),
  P11 = addValue({4, 5}, {{2019, 2, 2}, {2, 2, 2}}, pm25, 15, P10),
  P12 = addValue({1, 2}, {{2019, 2, 2}, {2, 2, 2}}, pm25, 10, P11),
  P13 = addValue({2, 3}, {{2019, 2, 2}, {2, 2, 2}}, pm25, 10, P12),
  LastStation = lists:last(P10#monitor.stations),
  lists:flatlength(LastStation#station.measurements),
  getOneValue(pm25, Station, calendar:local_time(), P10),
  getStationMean(pm25, Station, P11),
  getDailyMean(pm25, {{2019, 2, 2}, {2, 2, 2}}, P12),
  getDailyAverageDataCount({{2019, 2, 2}, {2, 2, 2}}, P13)
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
          ResultMeasurement = lists:filter(fun(Measurement) ->
            (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          case ResultMeasurement of
            [] ->
              Measurement = #measurement{date = Date, type = Type, value = Value},
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
          Measurements = CurrentStation#station.measurements,
          ResultMeasurement = lists:filter(fun(Measurement) ->
            (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          case ResultMeasurement of
            [] ->
              Measurement = #measurement{date = Date, type = Type, value = Value},
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
          ResultMeasurement = lists:filter(fun(Measurement) ->
            (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          case ResultMeasurement of
            [] ->
              erlang:error("No measurement found");
            [CurrentMeasurement | Tail] ->
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
          ResultMeasurement = lists:filter(fun(Measurement) ->
            (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          case ResultMeasurement of
            [] ->
              erlang:error("No measurement found");
            [CurrentMeasurement | Tail] ->
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

getOneValue(Type, Station, Date, Monitor) ->
  Stations = Monitor#monitor.stations,
  ResultStation = lists:filter(fun(Station1) -> (Station1#station.name == Station#station.name) end, Stations),
  if ResultStation == [] -> erlang:error("No station found");
    true ->
      H = hd(ResultStation),
      Measurements = H#station.measurements,
      ResultMeasurement = lists:filter(fun(Measurement) ->
        (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
      if ResultMeasurement == [] -> erlang:error("No measurement found");
        true -> hd(ResultMeasurement)
      end
  end.

getStationMean(Type, Station, Monitor) ->
  Stations = Monitor#monitor.stations,
  ResultStation = lists:filter(fun(Station1) -> (Station1#station.name == Station#station.name) end, Stations),
  if ResultStation == [] -> erlang:error("No station found");
    true ->
      H = hd(ResultStation),
      Measurements = H#station.measurements,
      ResultMeasurement = lists:filter(fun(Measurement) -> (Measurement#measurement.type == Type) end, Measurements),
      if ResultMeasurement == [] -> erlang:error("No measurement found");
        true ->
          mean(lists:map(fun(XD) -> XD#measurement.value end, ResultMeasurement))
      end
  end.

getDailyMean(Type, Date, Monitor) ->
  Stations = Monitor#monitor.stations,
  Measurements = lists:flatmap(fun(X) -> X#station.measurements end, Stations),
  FilteredMeasurements = lists:filter(fun(X) -> (X#measurement.date == Date) and (X#measurement.type == Type) end, Measurements),
  mean(lists:map(fun(XD) -> XD#measurement.value end, FilteredMeasurements))
.

mean([]) -> erlang:error("Wrong man");
mean(Values) -> lists:sum(Values) / length(Values).

getDailyAverageDataCount(Date, Monitor) ->
  Stations = Monitor#monitor.stations,
  Measurements = lists:flatmap(fun(X) -> X#station.measurements end, Stations),
  FilteredMeasurements = lists:filter(fun(X) -> (X#measurement.date == Date) end, Measurements),
  lists:flatlength(FilteredMeasurements)/lists:flatlength(Stations)
.