%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 14:07
%%%-------------------------------------------------------------------
-module(pollutionTest).
-author("ajris").

-include("../src/pollution.hrl").
-include_lib("eunit/include/eunit.hrl").


-define(FirstStationName, "name1").
-define(SecondStationName, "name2").
-define(FirstCoords, {0.0, 0.0}).
-define(SecondCoords, {1.0, 1.0}).
-define(FirstDateTime, {{1998, 09, 17}, {22, 40, 00}}).
-define(SecondDateTime, {{2019, 09, 17}, {22, 40, 00}}).
-define(FirstType, pm10).
-define(SecondType, pm25).
-define(FirstValue, 5).

create_monitor_test() ->
  ?assertEqual(#monitor{}, pollution:createMonitor()).

add_same_name_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertError("That station exists", pollution:addStation(?FirstStationName, ?SecondCoords, Monitor1)).

add_same_coords_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertError("That station exists", pollution:addStation(?SecondStationName, ?FirstCoords, Monitor1)).

add_new_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addStation(?SecondStationName, ?SecondCoords, Monitor1),

  ?assertEqual(2, length(Monitor2#monitor.stations)).

add_new_measurement_by_coords_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  Stations = Monitor2#monitor.stations,
  FirstStation = hd(Stations),
  FirstValue = hd(FirstStation#station.measurements),

  ?assertEqual(1, length(FirstStation#station.measurements)),
  ?assertEqual(?FirstValue, FirstValue#measurement.value),
  ?assertEqual(?FirstType, FirstValue#measurement.type),
  ?assertEqual(?FirstDateTime, FirstValue#measurement.date).

add_new_measurement_by_name_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstStationName, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  Stations = Monitor2#monitor.stations,
  FirstStation = hd(Stations),
  FirstValue = hd(FirstStation#station.measurements),

  ?assertEqual(1, length(FirstStation#station.measurements)),
  ?assertEqual(?FirstValue, FirstValue#measurement.value),
  ?assertEqual(?FirstType, FirstValue#measurement.type),
  ?assertEqual(?FirstDateTime, FirstValue#measurement.date).

add_new_measurement_by_name_to_not_existing_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertError("Coudln't find that station with provided Name", pollution:addValue(?SecondStationName, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1)).

add_new_measurement_by_coords_to_not_existing_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertError("Coudln't find that station with provided X and Y", pollution:addValue(?SecondCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1)).

remove_measurement_by_coords_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  ?assertEqual(Monitor1, pollution:removeValue(?FirstCoords, ?FirstDateTime, ?FirstType, Monitor2)).

remove_measurement_by_name_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  ?assertEqual(Monitor1, pollution:removeValue(?FirstStationName, ?FirstDateTime, ?FirstType, Monitor2)).

remove_not_existing_measurement_by_name_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  ?assertError("No measurement found", pollution:removeValue(?FirstStationName, ?SecondDateTime, ?FirstType, Monitor2)),
  ?assertError("No measurement found", pollution:removeValue(?FirstStationName, ?FirstDateTime, ?SecondType, Monitor2)),
  ?assertError("Coudln't find that station with provided Name", pollution:removeValue(?SecondStationName, ?FirstDateTime, ?FirstType, Monitor2)).

remove_not_existing_measurement_by_coords_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  ?assertError("No measurement found", pollution:removeValue(?FirstCoords, ?SecondDateTime, ?FirstType, Monitor2)),
  ?assertError("No measurement found", pollution:removeValue(?FirstCoords, ?FirstDateTime, ?SecondType, Monitor2)),
  ?assertError("Coudln't find that station with provided X and Y", pollution:removeValue(?SecondCoords, ?FirstDateTime, ?FirstType, Monitor2)).