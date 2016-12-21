;
; Support for interprocess communication / shared variables with Redis
;
; See http://redis.io/
;
/loaded __tf_util_redis__

/def -q redisEscape = \
    /let _val=%{1}%;\
    /test _val := strcat(char(34), _val, char(34))%;\
    /result _val%;\

/def -q redisCmd = \
;    /echo Params: %{-1}%;\
    /let _result=$(/quote -S -decho !redis-cli %{*})%;\
    /result _result

/def redisGet = \
    /result redisCmd("GET", {1})

/def redisLIndex = \
    /result redisCmd("LINDEX", {1}, {2})

/def redisLLen = \
    /result redisCmd("LLEN", {1})

/def redisSet = \
    /result redisCmd("SET", {1}, redisEscape({2}))

/def redisIsSet = \
    /result redisCmd("EXISTS", {1})

/def redisLPush = \
    /result redisCmd("LPUSH", {1}, redisEscape({2}))

/def redisRPush = \
    /result redisCmd("RPUSH", {1}, redisEscape({2})

/def redisLRange = \
    /result redisCmd("LRANGE", {1}, {2}, {3--1})

/def redisDel = \
    /result redisCmd("DEL", {1})

/def redisRename = \
    /result redisCmd("RENAME", {1}, {2})

