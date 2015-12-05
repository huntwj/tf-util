;;
;; General variable utilities
;;
/loaded __tf_util_variables__

/require textutil.tf

; These functions provide variables that can have global defaults as well as
; user-specific overrides.
/def util_declareVar = \
    /let _varName=%{1}%;\
    /let _globalVar=$[util_globalVarName(_varName)]%;\
    /let _defaultValue=%{2}%;\
    /test %_globalVar := _defaultValue

;
; Get the current value of a "dynamic" variable. The order of lookup
; is "user" then "global".
;
; TODO: Make this work with arbitrary lookup depth based on the value of some
;       config variable.
;
/def util_getVar = \
    /let _varName=%{1}%;\
    /let _userVarName=$[util_userVarName(_varName)]%;\
    /if (util_isSet(_userVarName)) \
        /return %{_userVarName}%;\
    /endif%;\
    /let _globalVar=$[util_globalVarName(_varName)]%;\
    /return %{_globalVar}

;
; Set a "dynamic variable". This should only change the top scope. Currently
; that is "user".
;
/def util_setVar = \
    /let _varName=%{1}%;\
    /let _value=%{-1}%;\
    /let _userVarName=$[util_userVarName(_varName)]%;\
    /let _userVarValue=%;\
    /let _userVarValue=%;\
    /test _userVarValue := %{_userVarName}%;\
    /if (_value !~ _userVarValue) \
        /test util_fireEvent(strcat("var.change_", _varName), _userVarValue, _value)%;\
    /endif%;\
    /test %{_userVarName} := _value

;
; Convert a user-land variable name into its actual global default variable 
; name.
;
/def -i util_globalVarName = \
    /let _varName=%{1}%;\
    /let _globalName=var_global_$[textencode(_varName)]%;\
    /return _globalName

;
; Convert a user-land variable name into its actual user variable name.
;
/def -i util_userVarName = \
    /let _varName=%{1}%;\
    /let _userVarName=var_user_$[textencode(_varName)]%;\
    /return _userVarName

;
; Load custom variable overrides from a given file.
;
; /util_loadVars Elowen
;    -- loads the variables stored in %{TF_NPM_ROOT}/data/variables/Elowen.tf
;
/def util_loadVars = \
    /let _filename=$[util_customVarFilename({1})]%;\
    /let _handle=$[tfopen(_filename,"r")]%;\
    /if (_handle != -1) \
        /util_unset $(/listvar -mregexp -s ^var_user_)%;\
        /test tfclose(_handle)%;\
        /load -q %{_filename}%;\
        /echo Loaded user variables from '%{_filename}'%;\
    /else \
        /echo Could not open file '%{_filename}'. Load aborted.%;\
    /endif

;
; Save custom variable overrides to a given file.
;
; /util_saveVars Elowen
;    -- saves the variables stored in the "user" scope to the file
;       %{TF_NPM_ROOT}/data/variables/Elowen.tf
/def util_saveVars = \
    /let _filename=$[util_customVarFilename({1})]%;\
    /listvar -mregexp ^var_user_ %| /writefile %{_filename}%;\
    /echo Saved user variables into '%{_filename}'

;
; Get the fully qualified filename from a simple name
;
/def -i util_customVarFilename = \
    /let _filename=%{TF_NPM_ROOT}/data/variables/%{1}.tf%;\
    /return _filename

;
; Unset all variables passed in as parameters.
;
/def util_unset = \
    /while ({#}) \
        /unset %{1}%;\
        /shift%;\
    /done

;
; Determine if a variable with the given name exists.
;
/def util_isSet = \
    /let _varName=%{1}%;\
    /let _results=$(/listvar -msimple -s %_varName)%;\
    /return _results !~ ""

;
; Watch for changes to a variable
;
/def util_watchVar = \
    /let _varName=%{1}%;\
    /let _callback=%{2}%;\
    /util_addListener var.change_%{_varName} %{_callback}

;
; Remove a watch callback for a variable
;
/def util_unwatchVar = \
    /let _varName=%{1}%;\
    /let _callback=%{2}%;\
    /util_removeListener var.change_%{_varName} %{_callback}

