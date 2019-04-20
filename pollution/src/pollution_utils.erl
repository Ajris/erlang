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
-export([isMeasurementType/1]).
-export([isDayEqual/2]).

calculateMean([]) -> ?EMPTY_ERROR;
calculateMean(Values) -> lists:sum(Values) / length(Values).

isMeasurementType(V) -> lists:member(V, ?MEASUREMENT_TYPES).

isDayEqual({FirstDate, _}, {SecondDate, _}) -> FirstDate == SecondDate.