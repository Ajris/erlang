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

-define(STATION_NOT_FOUND_ERROR, stationNotFoundError).
-define(STATION_ALREADY_EXIST_ERROR, stationAlreadyExistError).
-define(UNKNOWN_ERROR, unknownError).
-define(WRONG_TYPE_SPECIFIED_ERROR, wrongTypeSpecifiedError).
-define(MEASUREMENT_NOT_FOUND_ERROR, measurementNotFoundError).
-define(EMPTY_ERROR, emptyError).

-define(SPECIFIED_EXCEPTIONS, [?STATION_ALREADY_EXIST_ERROR, ?STATION_ALREADY_EXIST_ERROR, ?UNKNOWN_ERROR,
  ?WRONG_TYPE_SPECIFIED_ERROR, ?MEASUREMENT_NOT_FOUND_ERROR, ?EMPTY_ERROR]).