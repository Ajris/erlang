%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 21:07
%%%-------------------------------------------------------------------
-module(pollution_utils).
-author("ajris").

-include("pollution.hrl").

%% API
-export([calculateMean/1]).
-export([isMeasurementType/1]).
-export([isDayEqual/2]).
-export([getStationByKey/2]).
-export([getStationByKeys/3]).

calculateMean([]) -> ?EMPTY_ERROR;
calculateMean(Values) -> lists:sum(Values) / length(Values).

isMeasurementType(V) -> lists:member(V, ?MEASUREMENT_TYPES).

isDayEqual({FirstDate, _}, {SecondDate, _}) -> FirstDate == SecondDate.

getStationByKey(Key, Monitor) ->
  case Key of
    {X, Y} ->
      Result = lists:filter(fun(Station) ->
        (Station#station.stationCoordinates == {X, Y}) end, Monitor#monitor.stations);
    Name ->
      Result = lists:filter(fun(Station) -> (Station#station.stationName == Name) end, Monitor#monitor.stations)
  end,
  Result.

getStationByKeys(Name, {X, Y}, Monitor) ->
  Result = lists:filter(fun(Station) ->
    (Station#station.stationCoordinates == {X, Y}) or (Station#station.stationName == Name) end, Monitor#monitor.stations),
  Result.