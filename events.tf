;;
;; tf-util/events.tf
;;
/loaded __tf_util_events__

/require lisp.tf

/def event_addListener = \
    /util_addListener

/def -i util_addListener = \
    /let _event=$[textencode({1})]%;\
    /let _callback=$[textencode({2})]%;\
    /let _tmp=%;\
    /test _tmp := strcat(util_event_%{_event}, ' ', _callback)%;\
    /set util_event_%{_event}=$(/unique %{_tmp})

/def event_removeListener = /util_removeListener %{*}
/def -i util_removeListener = \
    /let _event=$[textencode({1})]%;\
    /let _callback=$[textencode({2})]%;\
    /let _tmp=%;\
    /test _tmp := util_event_%{_event}%;\
    /let _newVal=$(/remove %{_callback} %{_tmp})%;\
    /if (regmatch("^\s*$", _newVal)) \
        /unset util_event_%{_event}%;\
    /else \
        /set util_event_%{_event}=%{_newVal}%;\
    /endif

/def event_fire = \
    /util_fireEvent %{*}

/def -i util_fireEvent = \
    /let _event=$[textencode({1})]%;\
    /let _params=%{-1}%;\
    /let _p1=%{2}%;\
    /let _p2=%{3}%;\
    /let _p3=%{4}%;\
    /let _p4=%{5}%;\
    /let _p5=%{6}%;\
    /let _p6=%{7}%;\
    /let _p7=%{8}%;\
    /let _p8=%{9}%;\
    /let _list=%;\
    /test _list := util_event_%{_event}%;\
    /let _count=$(/length %{_list})%;\
    /while (_count > 0) \
        /let _callback=$(/car %{_list})%;\
        /let _list=$(/cdr %{_list})%;\
        /test _callback := textdecode(_callback)%;\
        /test %{_callback}(_p1, _p2, _p3, _p4, _p5, _p6, _p7, _p8)%;\
        /let _count=$(/length %{_list})%;\
    /done

/def -h"DISCONNECT {*}" util_t_notifyDisconnect = \
    /event_fire connection.disconnected %{*} %{P0}

/def -h"CONNECT {*}" util_t_notifyConnect = \
    /event_fire connection.connected %{*} %{P0}
