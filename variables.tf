;;
;; General variable utilities
;;

; These functions provide variables that can have global defaults as well as
; user-specific overrides.
/def util_declareVar = \
    /let _varName=%{1}%;\
    /let _globalVar=$[util_globalVarName(_varName)]%;\
    /let _defaultValue=%{2}%;\
;    /echo Declaring variable %{_varName} (%{_globalVar}) with default %{_defaultValue}%;\
    /test %_globalVar := _defaultValue

/def util_getVar = \
    /let _varName=%{1}%;\
; TODO: Check to see if a user variable exists.
    /let _globalVar=$[util_globalVarName(_varName)]%;\
;    /echo Requesting value for %{_varName}%;\
    /return %{_globalVar}

/def util_globalVarName = \
    /let _varName=%{1}%;\
    /let _globalName=var_global_$[textencode(_varName)]%;\
    /return _globalName
