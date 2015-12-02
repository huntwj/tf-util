;;
;; General variable utilities
;;

; These functions provide variables that can have global defaults as well as
; user-specific overrides.
/def util_declareVar = \
    /let _varName=%{1}%;\
    /let _defaultValue=%{2}%;\
    /echo Declaring variable %{_varName} with default %{_defaultValue}

/def util_getVar = \
    /let _varName=%{1}%;\
    /echo Requesting value for %{_varName}

