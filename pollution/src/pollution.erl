%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2019 23:11
%%%-------------------------------------------------------------------
-module(pollution).
-author("ajris").

%% API
-export([createMonitor/0]).
-export([addStation/3]).
-export([addValue/5]).
-export([removeValue/4]).
-export([getOneValue/4]).
-export([getStationMean/3]).
-export([getDailyMean/3]).
-export([getDailyAverageDataCount/3]).



createMonitor() ->
  erlang:error(not_implemented).