rm -rf ebin/*
mkdir ebin
erlc -o ebin src/*.erl
cp src/ecache.app ebin/ecache.app
