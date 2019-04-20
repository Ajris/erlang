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
  ?assertEqual(false, pollution_utils:isDayEqual(?FirstDateTime, {{1998, 10, 17}, {}})).

get_stations_by_key_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertEqual(1, length(pollution_utils:getStationsByKey(?FirstStationName, Monitor1))),
  ?assertEqual(1, length(pollution_utils:getStationsByKey(?FirstCoords, Monitor1))),
  ?assertEqual(0, length(pollution_utils:getStationsByKey(?SecondCoords, Monitor1))),
  ?assertEqual(0, length(pollution_utils:getStationsByKey(?SecondStationName, Monitor1))).

get_stations_by_name_and_position_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertEqual(1, length(pollution_utils:getStationsByNameAndPosition(?SecondStationName, ?FirstCoords, Monitor1))),
  ?assertEqual(1, length(pollution_utils:getStationsByNameAndPosition(?FirstStationName, ?SecondCoords, Monitor1))),
  ?assertEqual(0, length(pollution_utils:getStationsByNameAndPosition(?SecondStationName, ?SecondCoords, Monitor1))).

get_measurements_by_date_and_type_test() ->
  M1 = #measurement{date = ?FirstDateTime, type = ?FirstType},
  M2 = #measurement{date = ?SecondDateTime, type = ?FirstType},
  Station = #station{measurements = [M1, M2]},

  ?assertEqual(1, length(pollution_utils:getMeasurementsByDateAndType(?FirstDateTime, ?FirstType, Station))),
  ?assertEqual(0, length(pollution_utils:getMeasurementsByDateAndType(?SecondDateTime, ?SecondType, Station))).

get_measurements_by_type_test() ->
  M1 = #measurement{type = ?FirstType},
  M2 = #measurement{type = ?FirstType},
  Station = #station{measurements = [M1, M2]},

  ?assertEqual(2, length(pollution_utils:getMeasurementsByType(?FirstType, Station))),
  ?assertEqual(0, length(pollution_utils:getMeasurementsByType(?SecondType, Station))).