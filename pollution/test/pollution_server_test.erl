%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 22:17
%%%-------------------------------------------------------------------
-module(pollution_server_test).
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

integration_test() ->
  pollution_server:start(),
  pollution_server:addStation(?FirstStationName, ?FirstCoords),
  pollution_server:addValue(?FirstStationName, ?FirstDateTime, ?FirstType, ?FirstValue),
  pollution_server:addValue(?FirstCoords, ?FirstDateTime, ?FirstType, ?FirstValue),
  pollution_server:removeValue(?FirstStationName, ?FirstDateTime, ?FirstType),
  pollution_server:removeValue(?FirstCoords, ?FirstDateTime, ?FirstType),
  pollution_server:getOneValue(?FirstStationName, ?FirstDateTime, ?FirstType),
  pollution_server:getStationMean(?FirstStationName, ?FirstDateTime, ?FirstType),
  pollution_server:getDailyMean(?FirstStationName, ?FirstDateTime, ?FirstType),
  pollution_server:getDailyAverageDataCount(?FirstStationName, ?FirstDateTime, ?FirstType),
  pollution_server:stop().