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
%%  pollution_server:addStation(?SecondStationName, ?SecondCoords),
%%  pollution_server:addValue(?FirstStationName, ?FirstDateTime, ?FirstType, ?FirstValue),
%%  pollution_server:addValue(?FirstCoords, ?SecondDateTime, ?SecondType, ?SecondValue),
%%  pollution_server:addValue(?SecondStationName, ?FirstDateTime, ?FirstType, ?FirstValue),
%%  pollution_server:addValue(?SecondCoords, ?SecondDateTime, ?SecondType, ?SecondValue),

%%  ?assertEqual(5.0, pollution_server:getStationMean(?FirstStationName, ?FirstType)),

  pollution_server:stop().