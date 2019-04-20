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

create_monitor_test() ->
  ?assertEqual(#monitor{}, pollution:createMonitor()).

add_same_name_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  ?assertError("That station exists",pollution:addStation(?FirstStationName, ?SecondCoords, Monitor1)).

add_same_coords_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  ?assertError("That station exists",pollution:addStation(?SecondStationName, ?FirstCoords, Monitor1)).

add_new_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation(?FirstStationName, ?FirstCoords, Monitor),
  Monitor2 = pollution:addStation(?SecondStationName, ?SecondCoords, Monitor1),
  ?assertEqual(2, length(Monitor2#monitor.stations)).

%%add_new_value_test() ->
%%  Monitor = pollution:createMonitor(),
%%  Monitor1 = pollution:addStation("name1", {0.0, 0.0}, Monitor),
%%  Monitor2 = pollution:addValue({0.0, 0.0}, calendar:local_time(), pm10, 5, Monitor1),
%%  Stations = Monitor2#monitor.stations,
%%  Measurement
%%  FirstStation = hd(Stations),
%%  ?assertEqual(1, length(FirstStation#station.measurements)),
%%  ?assertEqual(1, length(FirstStation#station.measurements)),
%%  ?assertEqual(1, length(FirstStation#station.measurements)),
%%  ?assertEqual(1, length(FirstStation#station.measurements)).