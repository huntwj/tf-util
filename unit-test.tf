;
; tf-util/unit-test.tf
;
; Some basic unit test facilities to help make sure code does what we think it does.
;
/loaded __tf_util__unit_test__

/require tf-util/list-macros.tf
/require lisp.tf

/def tfunit_declareGroup = \
    /test setVar("tfunit.runGroup", {1})

/def tfunit_endGroup = \
    /test setVar("tfunit.runGroup", "")

/def assert = \
    /test tfunit_assertTrue({1}, {2})

/def tfunit_assertTrue = \
    /let _success=%{1}%;\
    /let _message=%{2}%;\
    /let _testGroup=$[getVar("tfunit.currentGroup.name")]%;\
    /let _testName=$[getVar("tfunit.currentTest.name")]%;\
    /if (_success) \
        /tfunit_assertSuccess%;\
    /else \
        /test tfunit_assertFailed(1, 0, _message)%;\
    /endif

/def tfunit_assertStrEqual = \
    /let _expected=%{1}%;\
    /let _observed=%{2}%;\
    /let _message=%{-2}%;\
    /let _testGroup=$[getVar("tfunit.currentGroup.name")]%;\
    /let _testName=$[getVar("tfunit.currentTest.name")]%;\
    /if (_expected =~ _observed) \
        /tfunit_assertSuccess%;\
    /else \
        /test tfunit_assertFailed(_expected, _observed, _message)%;\
    /endif

/def tfunit_assertEqual = \
    /let _expected=%{1}%;\
    /let _observed=%{2}%;\
    /let _message=%{-2}%;\
    /let _testGroup=$[getVar("tfunit.currentGroup.name")]%;\
    /let _testName=$[getVar("tfunit.currentTest.name")]%;\
    /if (_expected == _observed) \
        /tfunit_assertSuccess%;\
    /else \
        /test tfunit_assertFailed(_expected, _observed, _message)%;\
    /endif

/def -i tfunit_assertSuccess = \
    /let _count=tfunit.currentTest.assertCount%;\
    /test setVar(_count, getVar(_count)+1)

/def -i tfunit_assertFailed = \
    /let _aCount=tfunit.currentTest.assertCount%;\
    /let _fCount=tfunit.currentTest.failCount%;\
    /let _failMsgs=tfunit.currentTest.failMessages%;\
    /test setVar(_aCount, getVar(_aCount)+1)%;\
    /test setVar(_fCount, getVar(_fCount)+1)%;\
    /let _msg=Expected: '%{1}', Observed: '%{2}', : %{3}%;\
    /test setVar(_failMsgs, strcat(getVar(_failMsgs), " ", textencode(_msg)))

/util_watchVar tfunit.runGroup tfunit_groupChanged

/def -i tfunit_groupChanged = \
;    /echo group changed: '%{1}' -> '%{2}'%;\
    /let _group=%{1}%;\
    /let _newGroup=%{2}%;\
    /if (_newGroup =~ "") \
        /tfunit_testGroup %{_group}%;\
    /endif%;\
    /test echo("==========")%;\
    /test 1

/def tfunit_testGroup = \
    /let _group=%{1}%;\
    /test setVar("tfunit.currentGroup.name", _group)%;\
    /echo Running Test Group: %{_group}%;\
    /let _tests=$(/list_macros test_%{_group}_)%;\
    /mapcar /tfunit_runTest %{_tests}

/def -i tfunit_runTest = \
    /let _test=%{1}%;\
    /tfunit_resetCurrentTest %{_test}%;\
    /%{_test}%;\
    /tfunit_analyzeTestResults

/def -i tfunit_analyzeTestResults = \
    /let _shortName=$[tfunit_testShortName(getVar("tfunit.currentTest.name"))]%;\
    /let _total=$[getVar("tfunit.currentTest.assertCount")]%;\
    /let _failed=$[getVar("tfunit.currentTest.failCount")]%;\
    /let _success=$[_total - _failed]%;\
    /if (_failed) \
        /test echo(strcat("  [ @{Cred}FAILED@{n} ] ", _shortName, " - ( ", _success, "/", _total, " passed )"), "", 1)%;\
        /tfunit_dumpReasons $[getVar("tfunit.currentTest.failMessages")]%;\
    /else \
        /test echo(strcat("  [   @{Cgreen}Ok@{n}   ] ", _shortName, " - ( ", _success, "/", _total, " passed )"), "", 1)%;\
    /endif

/def -i tfunit_testShortName = \
    /let _test=%{1}%;\
    /let _regex=$[strcat("^test_", getVar("tfunit.currentGroup.name"), "_(.*)$")]%;\
    /test regmatch(_regex, _test)%;\
    /result replace("_", " ", {P1})%;\


/def -i tfunit_resetCurrentTest = \
    /let _test=%{1}%;\
    /test setVar("tfunit.currentTest.assertCount", 0)%;\
    /test setVar("tfunit.currentTest.failCount", 0)%;\
    /test setVar("tfunit.currentTest.name", _test)%;\
    /test setVar("tfunit.currentTest.failMessages", "")

/def -i tfunit_dumpReasons = \
    /while ({#}) \
        /let _reason=$[textdecode({1})]%;\
        /test echo(strcat("             - ", _reason))%;\
        /shift%;\
    /done

