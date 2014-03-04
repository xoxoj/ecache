-module(ecache_server).
-include("ecache_thrift.hrl").
-export([start/0, handle_function/2, cmd/1, stop/1]).


cmd(Args)->
	{ok,Pid} = ecache_main:start(),
	{ok,Result} = ecache_main:cmd(Pid,Args),
	ecache_main:stop(Pid),
	case is_binary(Result) of 
		true->
			[Result];
		false->
			Result
	end.

start()->
	start(9090).

start(Port)->
	Handler = ?MODULE,
	thrift_socket_server:start([{handler, Handler},
				    {service, ecache_thrift},
				    {port, Port},
				    {name, ecache_server}]).

stop(Server)->
	thrift_socket_server:stop(Server).


handle_function(Function, Args) ->
	case Function of
		cmd ->
			{reply, cmd(Args)};
		_ ->
			error
	end.
