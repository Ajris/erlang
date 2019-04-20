%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Apr 2019 13:51
%%%-------------------------------------------------------------------
-author("ajris").

-record(monitor, {stations = []}).
-record(station, {name, coords, measurements = []}).
-record(measurement, {date, type, value}).
-record(coords, {x, y}).