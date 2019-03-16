%%%-------------------------------------------------------------------
%%% @author ajris
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2019 13:25
%%%-------------------------------------------------------------------
-module(onp).
-author("ajris").

%% API
-export([onp/1]).

% 1 + 2 * 3 - 4 / 5 + 6
%	1 2 3 * 4 5 / - 6 + +

%1 + 2 + 3 + 4 + 5 + 6 * 7
%1 2 + 3 + 4 + 5 + 6 7 * +

%( (4 + 7) / 3 ) * (2 - 19)
%	4 7 + 3 / 2 19 - *

%17 * (31 + 4) / ( (26 - 15) * 2 - 22 ) - 1
%17 31 4 + 26 15 - 2 * 22 - / 1 - *

calculate([], Stack) -> hd(Stack);

calculate(["+" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [hd(StackTail) + StackHead | tl(StackTail)],
  calculate(T, Numbers);
calculate(["*" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [hd(StackTail) * StackHead | tl(StackTail)],
  calculate(T, Numbers);
calculate(["^" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [math:pow(hd(StackTail), StackHead) | tl(StackTail)],
  calculate(T, Numbers);
calculate(["-" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [hd(StackTail) - StackHead | tl(StackTail)],
  calculate(T, Numbers);
calculate(["/" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [hd(StackTail) / StackHead | tl(StackTail)],
  calculate(T, Numbers);
calculate(["sqrt" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [math:sqrt(StackHead) | StackTail],
  calculate(T, Numbers);
calculate(["sin" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [math:sin(StackHead) | StackTail],
  calculate(T, Numbers);
calculate(["tan" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [math:tan(StackHead) | StackTail],
  calculate(T, Numbers);
calculate(["ctg" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [1 / math:tan(StackHead) | StackTail],
  calculate(T, Numbers);
calculate(["cos" | T], Stack) ->
  [StackHead | StackTail] = Stack,
  Numbers = [math:cos(StackHead) | StackTail],
  calculate(T, Numbers);

calculate([H | T], Stack) ->
  Numbers = [list_to_float(H) | Stack],
  calculate(T, Numbers).


onp(Input) ->
  A = string:tokens(Input, " "),
  calculate(A, []);
onp([]) -> io:format("This is the end").