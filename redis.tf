;
; Support for interprocess communication / shared variables with Redis
;
; See http://redis.io/
;
/loaded __tf_util_redis__

/def -q redisCmd = \
    /let _result=$(/quote -S -decho !redis-cli %{*})%;\
    /result _result

/def redisGet = \
    /result redisCmd("get", {1})

/def redisSet = \
    /result redisCmd("set", {1}, {2})

/def redisIsSet = \
    /result redisCmd("exists", {1})

