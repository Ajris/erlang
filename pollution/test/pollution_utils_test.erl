%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 22:17
%%%-------------------------------------------------------------------
-module(pollution_utils_test).
-author("ajris").

-include("../src/pollution.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(LIST, [1, 2, 3]).
-define(FirstDateTime, {{1998, 09, 17}, {22, 40, 00}}).
-define(SecondDateTime, {{1998, 09, 17}, {22, 00, 00}}).

calculate_mean_empty_list_test() ->
  ?assertEqual(?EMPTY_ERROR, pollution_utils:calculateMean([])).

calculate_mean_list_test() ->
  ?assertEqual(?EMPTY_ERROR, pollution_utils:calculateMean(?LIST)).

is_measurement_type_test() ->
  ?assertEqual(true, pollution_utils:isMeasurementType(?PM10)),
  ?assertEqual(true, pollution_utils:isMeasurementType(?PM25)),
  ?assertEqual(true, pollution_utils:isMeasurementType(?TEMP)),
  ?assertEqual(false, pollution_utils:isMeasurementType(notInMeasurementType)).

is_day_equal_test() ->
  ?assertEqual(true, pollution_utils:isDayEqual(?FirstDateTime, ?SecondDateTime)),
  ?assertEqual(false, pollution_utils:isDayEqual(?FirstDateTime, {{1998, 10, 17},{}})).