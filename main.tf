;;
;; tf-util/main.tf
;;
/loaded __tf_util_main__

/require tf-util/loader.tf

/require tf-util/variables.tf
/require tf-util/events.tf
/require tf-util/logging.tf
/require tf-util/containers.tf
/def strltrim = \
    /let _string=%{1}%;\
    /let _removeChars=%{2}%;\
    /if (_removeChars =~ "") \
        /test _removeChars := " "%;\
    /endif%;\
    /let _i=0%;\
    /let _len=$[strlen(_string)]%;\
    /while (_i < _len & strchr(_string, _removeChars, _i) == _i)\
        /test ++_i%;\
    /done%;\
    /result substr(_string, _i)

/def strrtrim = \
    /let _string=%{1}%;\
    /let _removeChars=%{2}%;\
    /if (_removeChars =~ "") \
        /test _removeChars := " "%;\
    /endif%;\
    /let _len=$[strlen(_string)]%;\
    /let _i=$[_len-1]%;\
    /while (_i >= 0 & strchr(substr(_string, _i, 1), _removeChars) == 0)\
        /test --_i%;\
    /done%;\
    /if (_i < 0) \
        /result ""%;\
    /else \
        /result substr(_string, 0, _i+1)%;\
    /endif

/def strtrim = \
    /result strrtrim(strltrim({1}, {2}), {2})

/def strLTest = \
    /let _test=%{1}%;\
    /let _result=$[strltrim(_test)]%;\
    /let _passed=$[_result =~ {2} ? "OK" : "Failed"]%;\
    /echo strltrim($[_test]) -> (%{_result}) [%{_passed}]

/def strRTest = \
    /let _test=%{1}%;\
    /let _result=$[strrtrim(_test)]%;\
    /let _passed=$[_result =~ {2} ? "OK" : "Failed"]%;\
    /echo strrtrim($[_test]) -> (%{_result}) [%{_passed}]

/def strTest = \
    /let _test=%{1}%;\
    /let _result=$[strtrim(_test)]%;\
    /let _passed=$[_result =~ {2} ? "OK" : "Failed"]%;\
    /echo strtrim($[_test]) -> (%{_result}) [%{_passed}]

;/test strLTest("", "")
;/test strLTest("  ", "")
;/test strLTest("foo bar", "foo bar")
;/test strLTest("   foo bar", "foo bar")
;/test strLTest("foo bar   ", "foo bar   ")
;/test strLTest("    foo bar  ", "foo bar  ")
;
;/test strRTest("", "")
;/test strRTest("  ", "")
;/test strRTest("foo bar", "foo bar")
;/test strRTest("   foo bar", "   foo bar")
;/test strRTest("foo bar   ", "foo bar")
;/test strRTest("    foo bar  ", "    foo bar")
;
;/test strTest("", "")
;/test strTest("  ", "")
;/test strTest("foo bar", "foo bar")
;/test strTest("   foo bar", "foo bar")
;/test strTest("foo bar   ", "foo bar")
;/test strTest("    foo bar  ", "foo bar")
;

/registerModule util tf-util/main.tf tf-util/list-macros.tf
/registerModule loader tf-util/loader.tf
/registerModule containers tf-util/containers.tf
/registerModule events tf-util/events.tf
/registerModule logging tf-util/logging.tf
/registerModule redis tf-util/redis.tf
/registerModule unittest tf-util/unit-test.tf
/registerModule variables tf-util/variables.tf

