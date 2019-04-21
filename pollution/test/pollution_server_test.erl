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

-include("../src/pollution_header.hrl").
-include("pollution_test_header.hrl").
-include_lib("eunit/include/eunit.hrl").

integration_test() ->
  pollution_server:start(),
  pollution_server:addStation(?FirstStationName, ?FirstCoords),
  pollution_server:addStation(?SecondStationName, ?SecondCoords),
  pollution_server:addValue(?FirstStationName, ?FirstDateTime, ?FirstType, ?FirstValue),
  pollution_server:addValue(?FirstCoords, ?SecondDateTime, ?FirstType, ?SecondValue),
  pollution_server:addValue(?SecondStationName, ?FirstDateTime, ?FirstType, ?FirstValue),
  pollution_server:addValue(?SecondCoords, ?SecondDateTime, ?SecondType, ?SecondValue),
  ?assertEqual(7.5, pollution_server:getStationMean(?FirstCoords, ?FirstType)),
  ?assertEqual(20/3, pollution_server:getDailyMean(?FirstType, ?FirstDateTime)),
  ?assertEqual(2.0, pollution_server:getDailyAverageDataCount(?FirstDateTime)),
  ?assertEqual(#measurement{date = ?FirstDateTime,type = ?FirstType,value = ?FirstValue}, pollution_server:getOneValue(?FirstStationName, ?FirstDateTime, ?FirstType)),
  pollution_server:removeValue(?FirstCoords, ?SecondDateTime, ?FirstType),
  ?assertEqual(10/2, pollution_server:getDailyMean(?FirstType, ?FirstDateTime)),

  pollution_server:stop().