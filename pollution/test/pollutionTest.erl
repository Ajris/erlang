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

