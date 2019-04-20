%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 13:51
%%%-------------------------------------------------------------------
-author("ajris").

-record(station, {stationName, stationCoordinates, measurements = []}).
-record(measurement, {date, type, value}).
-record(monitor, {stations = []}).