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

integration_tesst() ->
  pollution_server:start(),
  pollution_server:addStation(?FirstStationName, ?FirstCoords),
  pollution_server:addValue(?FirstStationName, ?FirstDateTime, ?FirstType, ?FirstValue),
  ?assertEqual(5.0, pollution_server:getStationMean(?FirstStationName, ?FirstType)),
  pollution_server:stop().