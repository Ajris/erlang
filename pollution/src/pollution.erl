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
-include("pollution.hrl").

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
  Result = pollution_utils:getStationByKeys(Name, {X, Y}, Monitor),
  case Result of
    [] ->
      Station = #station{stationName = Name, stationCoordinates = {X, Y}},
      ActualizedStation = Monitor#monitor.stations ++ [Station],
      Monitor#monitor{
        stations = ActualizedStation
      };
    [_] -> ?STATION_ALREADY_EXIST_ERROR
  end.

addValue(Key, Date, Type, Value, Monitor) ->
  ResultStation = pollution_utils:getStationByKey(Key, Monitor),
  case ResultStation of
    [] -> ?STATION_NOT_FOUND_ERROR;
    [CurrentStation] ->
      case pollution_utils:isMeasurementType(Type) of
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

            [CurrentMeasurement | Tail] -> ?UNKNOWN_ERROR;
            [_] -> ?UNKNOWN_ERROR
          end;


        false -> ?WRONG_TYPE_SPECIFIED_ERROR
      end
  end.

removeValue({X, Y}, Date, Type, Monitor) ->
  Stations = Monitor#monitor.stations,
  ResultStation = lists:filter(fun(Station) -> (Station#station.stationCoordinates == {X, Y}) end, Stations),
  case ResultStation of
    [] -> ?STATION_NOT_FOUND_ERROR;
    [CurrentStation] ->
      case pollution_utils:isMeasurementType(Type) of
        true ->
          Measurements = CurrentStation#station.measurements,
          ResultMeasurement = lists:filter(fun(Measurement) ->
            (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          case ResultMeasurement of
            [] -> ?MEASUREMENT_NOT_FOUND_ERROR;
            [CurrentMeasurement | Tail] ->
              ActualizedMeasurements = lists:delete(CurrentMeasurement, CurrentStation#station.measurements),

              NewCurrentStation = CurrentStation#station{
                measurements = ActualizedMeasurements
              },
              ActualizedStation = lists:delete(CurrentStation, Monitor#monitor.stations) ++ [NewCurrentStation],

              Monitor#monitor{
                stations = ActualizedStation
              };
            [_] -> ?UNKNOWN_ERROR
          end;
        false -> ?WRONG_TYPE_SPECIFIED_ERROR
      end
  end;

removeValue(Key, Date, Type, Monitor) ->
  ResultStation = pollution_utils:getStationByKey(Key, Monitor),
  case ResultStation of
    [] -> ?STATION_NOT_FOUND_ERROR;
    [CurrentStation] ->
      case pollution_utils:isMeasurementType(Type) of
        true ->
          Measurements = CurrentStation#station.measurements,
          ResultMeasurement = lists:filter(fun(Measurement) ->
            (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
          case ResultMeasurement of
            [] -> ?MEASUREMENT_NOT_FOUND_ERROR;

            [CurrentMeasurement | Tail] ->
              ActualizedMeasurements = lists:delete(CurrentMeasurement, CurrentStation#station.measurements),

              NewCurrentStation = CurrentStation#station{
                measurements = ActualizedMeasurements
              },
              ActualizedStation = lists:delete(CurrentStation, Monitor#monitor.stations) ++ [NewCurrentStation],

              Monitor#monitor{
                stations = ActualizedStation
              };
            [_] -> ?UNKNOWN_ERROR
          end;
        false -> ?WRONG_TYPE_SPECIFIED_ERROR
      end
  end.

getOneValue(Type, Key, Date, Monitor) ->
  ResultStation = pollution_utils:getStationByKey(Key, Monitor),
  if ResultStation == [] -> ?STATION_NOT_FOUND_ERROR;
    true ->
      H = hd(ResultStation),
      Measurements = H#station.measurements,
      ResultMeasurement = lists:filter(fun(Measurement) ->
        ((Measurement#measurement.date == Date) and (Measurement#measurement.type == Type)) end, Measurements),
      if ResultMeasurement == [] -> ?MEASUREMENT_NOT_FOUND_ERROR;
        true -> hd(ResultMeasurement)
      end
  end.

getStationMean(Type, Key, Monitor) ->
  ResultStation = pollution_utils:getStationByKey(Key, Monitor),
  if ResultStation == [] -> ?STATION_NOT_FOUND_ERROR;
    true ->
      H = hd(ResultStation),
      Measurements = H#station.measurements,
      ResultMeasurement = lists:filter(fun(Measurement) -> (Measurement#measurement.type == Type) end, Measurements),
      if ResultMeasurement == [] -> ?MEASUREMENT_NOT_FOUND_ERROR;
        true ->
          pollution_utils:calculateMean(lists:map(fun(XD) -> XD#measurement.value end, ResultMeasurement))
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