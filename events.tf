;;
;; tf-util/events.tf
;;
/loaded __tf_util_events__

/load lisp.tf

/def util_addListener = \
    /let _event=$[textencode({1})]%;\
    /let _callback=$[textencode({2})]%;\
    /let _tmp=%;\
    /test _tmp := strcat(util_event_%{_event}, ' ', _callback)%;\
    /set util_event_%{_event}=$(/unique %{_tmp})

/def util_removeListener = \
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

/def util_fireEvent = \
    /let _event=$[textencode({1})]%;\
    /let _params=%{-1}%;\
    /let _list=%;\
    /test _list := util_event_%{_event}%;\
    /let _count=$(/length %{_list})%;\
    /while (_count > 0) \
        /let _callback=$(/car %{_list})%;\
        /let _list=$(/cdr %{_list})%;\
        /test _callback := textdecode(_callback)%;\
        /%{_callback} %{_params}%;\
        /let _count=$(/length %{_list})%;\
    /done

/def -h"DISCONNECT {*}" util_t_notifyDisconnect = \
    /util_fireEvent connection.disconnected %{*} %{P0}

/def -h"CONNECT {*}" util_t_notifyConnect = \
    /util_fireEvent connection.connected %{*} %{P0}

