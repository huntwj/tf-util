;
; list-macros
;
; Returns a list of macros matching a given regular expression.
;
/loaded __tf_util__list_macros__

/def list_macros = \
    /let _pattern=%{*}%;\
    /let _rawList=$(/list -s -mregexp %{_pattern})%;\
    /let _list=$(/util_simplifyMacroList %{_rawList})%;\
    /result _list

/def -i util_simplifyMacroList = \
    /let _result=%;\
    /while ({#}) \
; Skip macro number and % delimiters
        /shift%;\
        /shift%;\
        /if (_result =~ "") \
            /test _result := {1}%;\
        /else \
            /test _result := strcat(_result, " ", {1})%;\
        /endif%;\
        /shift%;\
    /done%;\
    /result _result


