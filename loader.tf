; tf-util/loader.tf
;
; Loader/reloader mechanism for modules
;
; /registerModule <moduleName> <moduleFile>
;
; /reloadModule <moduleName1> <moduleName2> ...
; /reloadAll
; /rl <-> /reloadAll
/loaded __tf_util__loader__

/require lisp.tf

/def registerModule = \
    /let _moduleName=%{1}%;\
    /let _moduleFile=%{2}%;\
    /let _encodedName=$[textencode(_moduleName)]%;\
    /let _varName=moduleLoader_%{_encodedName}%;\
    /let _value=%;\
    /test _value := %{_varName}%;\
    /set tfutil_loader_moduleList=$(/unique %{tfutil_loader_moduleList} %{_moduleName})%;\
    /let _newList=%;\
    /test _newList := strcat(_value, " ", _moduleFile)%;\
    /let _newList=$(/unique %{_newList})%;\
    /test %{_varName} := _newList

/def reloadModule = \
    /let _quiet=%;\
    /if ({1} =~ "-q") \
        /test _quiet := 1%;\
        /shift%;\
    /else \
        /test _quiet := 0%;\
    /endif%;\
    /let _moduleName=%{1}%;\
    /let _encodedName=$[textencode(_moduleName)]%;\
    /let _varName=moduleLoader_%{_encodedName}%;\
    /let _value=%;\
    /test _value := %{_varName}%;\
    /if (_quiet) \
        /mapcar /tfutil_loader_quietLoad %{_value}%;\
    /else \
        /mapcar /load %{_value}%;\
    /endif

/def -i tfutil_loader_quietLoad = \
    /load -q %{*}

/def rl = \
    /if ({1} =~ "-q") \
        /let _quiet=-q %;\
        /shift%;\
    /else \
        /let _quiet=%;\
    /endif%;\
    /if ({#} == 0) \
        /let _len=$(/length %{tfutil_loader_moduleList})%;\
        /if (_len > 0) \
            /rl %{_quiet} %{tfutil_loader_moduleList}%;\
        /else \
            /echo No modules loaded.%;\
        /endif%;\
    /else \
        /while ({#}) \
            /reloadModule %{_quiet} %{1}%;\
            /shift%;\
        /done%;\
    /endif

/def reloadAll = \
    /rl

/def listModules = \
    /let _modules=$(/unique %{tfutil_loader_moduleList})%;\
    /set tfutil_loader_moduleList=%{_modules}%;\
    /echo%;\
    /echo Currently available modules:%;\
    /echo ====================%;\
    /echo %{_modules}%;\
    /echo ====================%;\
    /echo $(/length %{_modules}) module(s) loaded.


