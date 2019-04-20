%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 14:07
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("ajris").

-include("../src/pollution.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(FirstStationName, "name1").
-define(SecondStationName, "name2").
-define(FirstCoords, {0.0, 0.0}).
-define(SecondCoords, {1.0, 1.0}).
-define(FirstDateTime, {{1998, 09, 17}, {22, 40, 00}}).
-define(SecondDateTime, {{1998, 09, 17}, {22, 00, 00}}).
-define(FirstType, pm10).
-define(SecondType, pm25).
-define(FirstValue, 5).
-define(SecondValue, 10).

create_monitor_test() ->
  ?assertEqual(#monitor{}, pollution:createMonitor()).

add_same_name_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertEqual(?STATION_ALREADY_EXIST_ERROR, pollution:addStation(?FirstStationName, ?SecondCoords, Monitor1)).

add_same_coords_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertEqual(?STATION_ALREADY_EXIST_ERROR, pollution:addStation(?SecondStationName, ?FirstCoords, Monitor1)).

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

  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:addValue(?SecondStationName, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1)).

add_new_measurement_by_coords_to_not_existing_station_test() ->
  Monitor = pollution:createMonitor(),

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),

  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:addValue(?SecondCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1)).

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

  ?assertEqual(?MEASUREMENT_NOT_FOUND_ERROR, pollution:removeValue(?FirstStationName, ?SecondDateTime, ?FirstType, Monitor2)),
  ?assertEqual(?MEASUREMENT_NOT_FOUND_ERROR, pollution:removeValue(?FirstStationName, ?FirstDateTime, ?SecondType, Monitor2)),
  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:removeValue(?SecondStationName, ?FirstDateTime, ?FirstType, Monitor2)).

remove_not_existing_measurement_by_coords_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  ?assertEqual(?MEASUREMENT_NOT_FOUND_ERROR, pollution:removeValue(?FirstCoords, ?SecondDateTime, ?FirstType, Monitor2)),
  ?assertEqual(?MEASUREMENT_NOT_FOUND_ERROR, pollution:removeValue(?FirstCoords, ?FirstDateTime, ?SecondType, Monitor2)),
  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:removeValue(?SecondCoords, ?FirstDateTime, ?FirstType, Monitor2)).

get_one_existing_value_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),
  Station = #station{stationName = ?FirstStationName, stationCoordinates = ?FirstCoords},

  Measurement = pollution:getOneValue(?FirstType, Station, ?FirstDateTime, Monitor2),
  ?assertEqual(?FirstValue, Measurement#measurement.value),
  ?assertEqual(?FirstType, Measurement#measurement.type),
  ?assertEqual(?FirstDateTime, Measurement#measurement.date).

get_one_not_existing_value_test() ->
  Monitor = pollution:createMonitor(),
  CurrentStation = #station{stationName = ?FirstStationName, stationCoordinates = ?FirstCoords},
  WrongNameStation = #station{stationName = ?SecondStationName, stationCoordinates = ?FirstCoords},
  WrongCoordsStation = #station{stationName = ?FirstStationName, stationCoordinates = ?SecondCoords},

  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:getOneValue(?FirstType, WrongNameStation, ?FirstDateTime, Monitor2)),
  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:getOneValue(?FirstType, WrongCoordsStation, ?FirstDateTime, Monitor2)),
  ?assertEqual(?MEASUREMENT_NOT_FOUND_ERROR, pollution:getOneValue(?FirstType, CurrentStation, ?SecondDateTime, Monitor2)),
  ?assertEqual(?MEASUREMENT_NOT_FOUND_ERROR, pollution:getOneValue(?SecondType, CurrentStation, ?FirstDateTime, Monitor2)).

get_station_mean_existing_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),
  Monitor3 = pollution:addValue(?FirstCoords, ?SecondDateTime, ?FirstType, ?SecondValue, Monitor2),
  Station = #station{stationName = ?FirstStationName, stationCoordinates = ?FirstCoords},

  ?assertEqual(7.5,pollution:getStationMean(?FirstType, Station, Monitor3)).

get_station_mean_not_existing_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  CurrentStation = #station{stationName = ?FirstStationName, stationCoordinates = ?FirstCoords},
  WrongNameStation = #station{stationName = ?SecondStationName, stationCoordinates = ?FirstCoords},
  WrongCoordsStation = #station{stationName = ?FirstStationName, stationCoordinates = ?SecondCoords},

  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:getStationMean(?FirstType, WrongNameStation, Monitor2)),
  ?assertEqual(?STATION_NOT_FOUND_ERROR, pollution:getStationMean(?FirstType, WrongCoordsStation, Monitor2)),
  ?assertEqual(?MEASUREMENT_NOT_FOUND_ERROR, pollution:getStationMean(?SecondType, CurrentStation, Monitor2)).

get_daily_mean_existing_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addStation(?SecondStationName, ?SecondCoords, Monitor1),
  Monitor3 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor2),
  Monitor4 = pollution:addValue(?FirstCoords, ?SecondDateTime, ?FirstType, ?SecondValue, Monitor3),

  ?assertEqual(7.5,pollution:getDailyMean(?FirstType, ?FirstDateTime, Monitor4)).

get_daily_mean_not_existing_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),

  ?assertEqual(?EMPTY_ERROR, pollution:getDailyMean(?FirstType, {{2010, 11, 11}, {11, 11, 11}}, Monitor2)),
  ?assertEqual(?EMPTY_ERROR, pollution:getDailyMean(?SecondType, ?FirstDateTime, Monitor2)).

get_daily_average_data_count_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue, Monitor1),
  Monitor3 = pollution:addValue(?FirstCoords, ?SecondDateTime, ?FirstType, ?SecondValue, Monitor2),

  ?assertEqual(2.0,pollution:getDailyAverageDataCount(?FirstDateTime, Monitor3)).