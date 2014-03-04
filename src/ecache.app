{application, ecache,[
	{description, "a cache server of redis cluster"},
  	{vsn, "0.1.0"},
  	{modules, [ 
		ecache_app,
		ecache_main_sup
	]},
  	{registered, [ ecache_main_sup ]},
  	{applications, [kernel, stdlib]},
  	{env, []},
  	{mod, {ecache_app, []}}
]}.
