%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 13:51
%%%-------------------------------------------------------------------
-author("ajris").

-type coords() :: {float(), float()}.
-type measurementType() :: pm10 | pm25 | temp.

-record(station, {stationName, stationCoordinates :: coords(), measurements = [] :: [measurement()]}).
-record(measurement, {date :: calendar:datetime(), type::measurementType(), value::float()}).

-type measurement() :: #measurement{}.
-type station() :: #station{}.

-record(monitor, {stations = [] :: [station()]}).