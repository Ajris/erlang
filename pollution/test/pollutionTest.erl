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

create_monitor_test() ->
  ?assertEqual(#monitor{}, pollution:createMonitor()).

add_same_name_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation("name1", {0.0, 0.0}, Monitor),
  ?assertError("That station exists",pollution:addStation("name1", {0.0, 1.0}, Monitor1)).

add_same_coords_station_test() ->
  Monitor = pollution:createMonitor(),
  Monitor1 = pollution:addStation("name1", {0.0, 0.0}, Monitor),
  ?assertError("That station exists",pollution:addStation("name2", {0.0, 0.0}, Monitor1)).