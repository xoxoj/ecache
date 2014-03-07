-module(ecache_client).
-include("ecache_thrift.hrl").
-export([test/2]).

p(X)->
	io:format("in the p() ~w~n", [X]),
	ok.

test(IP,Arr)->
	Port = 9090,
	{ok, Client0} = thrift_client_util:new(IP, Port, ecache_thrift, []),
	%%io:format("~n Client0 : ~p~n", [Client0]),
	{Client1, Res} =  thrift_client:call(Client0, cmd, [Arr]),
	%%io:format(" the Res is ~p~n", [Res]),
	%%io:format("~n Client1 : ~p~n", [Client1]),
	p(Res),
	%%io:format("the Client0 == Client1: ~p~n", [Client0 == Client1]),
	thrift_client:close(Client1),
	ok.
