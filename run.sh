rm -rf ebin/*
mkdir ebin
erlc -o ebin src/*.erl
cp src/ecache.app ebin/ecache.app
erl -sname ecache@localhost -config ecache.config -noshell -pa ebin/ -s ecache_run start & 
