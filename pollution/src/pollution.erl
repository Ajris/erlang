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
-include("pollution_header.hrl").

%% API
-export([createMonitor/0]).
-export([addStation/3]).
-export([addValue/5]).
-export([removeValue/4]).
-export([getOneValue/4]).
-export([getStationMean/3]).
-export([getDailyMean/3]).
-export([getDailyAverageDataCount/2]).

createMonitor() ->
  #monitor{}.

addStation(Name, {X, Y}, Monitor) ->
  Stations = pollution_utils:getStationsByNameAndPosition(Name, {X, Y}, Monitor),
  case Stations of
    [] ->
      Station = #station{stationName = Name, stationCoordinates = {X, Y}},
      ActualizedStations = Monitor#monitor.stations ++ [Station],
      Monitor#monitor{
        stations = ActualizedStations
      };
    [_] -> ?STATION_ALREADY_EXIST_ERROR
  end.

addValue(Key, Date, Type, Value, Monitor) ->
  Stations = pollution_utils:getStationsByKey(Key, Monitor),
  case Stations of
    [] -> ?STATION_NOT_FOUND_ERROR;
    [CurrentStation] ->
      case pollution_utils:isMeasurementType(Type) of
        true ->
          ResultMeasurement = pollution_utils:getMeasurementsByDateAndType(Date, Type, CurrentStation),
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
            [_] -> ?SAME_MEASUREMENT_EXIST_ERROR
          end;
        false -> ?WRONG_TYPE_SPECIFIED_ERROR
      end
  end.

removeValue(Key, Date, Type, Monitor) ->
  Stations = pollution_utils:getStationsByKey(Key, Monitor),
  case Stations of
    [] -> ?STATION_NOT_FOUND_ERROR;
    [CurrentStation] ->
      case pollution_utils:isMeasurementType(Type) of
        true ->
          ResultMeasurement = pollution_utils:getMeasurementsByDateAndType(Date, Type, CurrentStation),
          case ResultMeasurement of
            [] -> ?MEASUREMENT_NOT_FOUND_ERROR;

            [CurrentMeasurement] ->
              ActualizedMeasurements = lists:delete(CurrentMeasurement, CurrentStation#station.measurements),

              NewCurrentStation = CurrentStation#station{
                measurements = ActualizedMeasurements
              },
              ActualizedStation = lists:delete(CurrentStation, Monitor#monitor.stations) ++ [NewCurrentStation],

              Monitor#monitor{
                stations = ActualizedStation
              }
          end;
        false -> ?WRONG_TYPE_SPECIFIED_ERROR
      end
  end.

getOneValue(Type, Key, Date, Monitor) ->
  Stations = pollution_utils:getStationsByKey(Key, Monitor),
  case Stations of
    [] -> ?STATION_NOT_FOUND_ERROR;
    [Station] ->
      ResultMeasurement = pollution_utils:getMeasurementsByDateAndType(Date, Type, Station),
      case ResultMeasurement of
        [] -> ?MEASUREMENT_NOT_FOUND_ERROR;
        [V] -> V
      end
  end.

getStationMean(Type, Key, Monitor) ->
  Stations = pollution_utils:getStationsByKey(Key, Monitor),
  case Stations of
    [] -> ?STATION_NOT_FOUND_ERROR;
    [Station] ->
      Measurements = pollution_utils:getMeasurementsByType(Type, Station),
      case Measurements of
        [] -> ?MEASUREMENT_NOT_FOUND_ERROR;
        _ ->
          pollution_utils:calculateMean(lists:map(fun(Measurement) -> Measurement#measurement.value end, Measurements))
      end
  end.

getDailyMean(Type, Date, Monitor) ->
  Stations = Monitor#monitor.stations,
  Measurements = lists:flatmap(fun(X) -> X#station.measurements end, Stations),
  FilteredMeasurements = lists:filter(fun(X) ->
    (pollution_utils:isDayEqual(X#measurement.date, Date)) and (X#measurement.type == Type) end, Measurements),
  pollution_utils:calculateMean(lists:map(fun(XD) -> XD#measurement.value end, FilteredMeasurements)).

getDailyAverageDataCount(Date, Monitor) ->
  Stations = Monitor#monitor.stations,
  Measurements = lists:flatmap(fun(X) -> X#station.measurements end, Stations),
  FilteredMeasurements = lists:filter(fun(X) ->
    (pollution_utils:isDayEqual(X#measurement.date, Date)) end, Measurements),
  lists:flatlength(FilteredMeasurements) / lists:flatlength(Stations).