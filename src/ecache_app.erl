-module(ecache_app).
-behaviour(application).

-export([start/2, stop/1]).

-define(log_file,"ecache_app").
-define(log_level,debug).
%% ====================================================================
%% API functions
%% ====================================================================
-export([]).

%% ====================================================================
%% Behavioural functions
%% ====================================================================
-spec start(Type :: normal | {takeover, Node} | {failover, Node}, Args :: term()) ->
	{ok, Pid :: pid()} | {ok, Pid :: pid(), State :: term()} | {error, Reason :: term()}.
start(Type, StartArgs) ->
	[T1,T2,_] = tuple_to_list(os:timestamp()),
	Now = integer_to_list(T1)++integer_to_list(T2),
	application:start(log4erl),
	sharded_eredis:start(),
	sharded_eredis:q(["SET", <<"heart_beat">>, Now]),
	ecache_server:start(),
	log4erl:add_file_appender(ecache_server, {".", ?log_file, {size, 1000000000}, 4, "log", ?log_level,"%j %T [%L] %l%n"}),  
	log4erl:info("ecache start at :::> ~p",[Now]),
	{ok,Cookie} = application:get_env(sharded_eredis,erlang_cookie),
	log4erl:debug("ecache cookie :::> ~p",[Cookie]),
	erlang:set_cookie(node(),Cookie),
	case ecache_main_sup:start_link() of 
		{ok,Pid} ->
			{ok,Pid};
		Other ->
			{error,Other}
	end.

-spec stop(State :: term()) ->  Any :: term().
stop(State) ->
    ok.

%% ====================================================================
%% Internal functions
%% ====================================================================
