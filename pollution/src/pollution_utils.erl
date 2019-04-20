%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 21:07
%%%-------------------------------------------------------------------
-module(pollution_utils).
-author("ajris").

-include("pollution.hrl").

%% API
-export([calculateMean/1]).
-export([isGoodType/1]).
-export([isDayEqual/2]).

calculateMean([]) -> ?EMPTY_ERROR;
calculateMean(Values) -> lists:sum(Values) / length(Values).

isGoodType(pm10) -> true;
isGoodType(pm25) -> true;
isGoodType(temp) -> true;
isGoodType(_) -> false.

isDayEqual({FirstDate, _}, {SecondDate, _}) ->
  FirstDate == SecondDate.