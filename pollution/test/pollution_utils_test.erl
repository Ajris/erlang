%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 22:17
%%%-------------------------------------------------------------------
-module(pollution_utils_test).
-author("ajris").

-include("../src/pollution_header.hrl").
-include("pollution_test_header.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(LIST, [1, 2, 3]).

calculate_mean_empty_list_test() ->
  ?assertEqual(?EMPTY_ERROR, pollution_utils:calculateMean([])).

calculate_mean_list_test() ->
  ?assertEqual(2.0, pollution_utils:calculateMean(?LIST)).

is_measurement_type_test() ->
  ?assertEqual(true, pollution_utils:isMeasurementType(?PM10)),
  ?assertEqual(true, pollution_utils:isMeasurementType(?PM25)),
  ?assertEqual(true, pollution_utils:isMeasurementType(?TEMP)),
  ?assertEqual(false, pollution_utils:isMeasurementType(notInMeasurementType)).

is_day_equal_test() ->
  ?assertEqual(true, pollution_utils:isDayEqual(?FirstDateTime, ?SecondDateTime)),
  ?assertEqual(false, pollution_utils:isDayEqual(?FirstDateTime, {{1998, 10, 17},{}})).

get_station_by_key_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertEqual(1, pollution_utils:getStationsByKey(?FirstStationName, Monitor1)),
  ?assertEqual(1, pollution_utils:getStationsByKey(?FirstCoords, Monitor1)),
  ?assertEqual(0, pollution_utils:getStationsByKey(?SecondCoords, Monitor1)),
  ?assertEqual(0, pollution_utils:getStationsByKey(?SecondStationName, Monitor1)).

%%getStationsByKey(Key, Monitor) ->
%%  case Key of
%%    {X, Y} ->
%%      Result = lists:filter(fun(Station) ->
%%        (Station#station.stationCoordinates == {X, Y}) end, Monitor#monitor.stations);
%%    Name ->
%%      Result = lists:filter(fun(Station) -> (Station#station.stationName == Name) end, Monitor#monitor.stations)
%%  end,
%%  Result.
%%
%%getStationsByNameAndPosition(Name, {X, Y}, Monitor) ->
%%  Result = lists:filter(fun(Station) ->
%%    (Station#station.stationCoordinates == {X, Y}) or (Station#station.stationName == Name) end, Monitor#monitor.stations),
%%  Result.
%%
%%getMeasurementsByDateAndType(Date, Type, Station) ->
%%  Measurements = Station#station.measurements,
%%  Result = lists:filter(fun(Measurement) ->
%%    (Measurement#measurement.date == Date) and (Measurement#measurement.type == Type) end, Measurements),
%%  Result.
%%
%%getMeasurementsByType(Type, Station) ->
%%  Measurements = Station#station.measurements,
%%  Result = lists:filter(fun(Measurement) -> (Measurement#measurement.type == Type) end, Measurements),
%%  Result.