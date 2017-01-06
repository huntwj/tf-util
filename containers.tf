;
; tf-util/containers.tf
;
; Some simple data structures to use.
;
; Queue
;
; Stack
;
; Dequeue
;
; Both queues and stacks are implemented in terms of dequeues and can
; be used interchangably. Queue and stack functions are simply ways
; to clarify intent.
;
; Dequeues are implemented as strings with each value textencoded 
; and separated by spaces. For search simplicity and speed, the queue 
; values should always begin and end with a space.
;
; Note that storing the empty string in any of these data structures
; is not supported.
;

/require -q tf-util/variables.tf
/require -q tf-util/unit-test.tf

/def dequeue_init = \
    /let _queueName=%{1}%;\
    /test setVar(_queueName, " ")

/def dequeue_length = \
    /let _queueName=%{1}%;\
    /let _queueData=$[getVar(_queueName)]%;\
    /result strlen(_queueData) - strlen(replace(" ", "", _queueData)) - 1

/def dequeue_append = \
    /let _queueName=%{1}%;\
    /let _queueData=$[getVar(_queueName)]%;\
    /let _val=%{2}%;\
    /let _encodedVal=$[textencode(_val)]%;\
    /if (strlen(_queueData) == 0) \
        /test _queueData := " "%;\
    /endif%;\
    /let _newQueueData=$[strcat(_queueData, _encodedVal, " ")]%;\
    /test setVar(_queueName, _newQueueData)

/def dequeue_popFirst = \
    /let _queueName=%{1}%;\
    /let _queueData=$[getVar(_queueName)]%;\
    /if (strlen(_queueData) <= 1) \
        /result ""%;\
    /endif%;\
    /let _endIdx=$[strstr(_queueData, " ", 1)]%;\
;    /if (assert(_endIdx != -1, "Invalid dequeue data structure."))\
;        /result ""%;\
;    /endif%;\
    /let _retVal=$[textdecode(substr(_queueData, 1, _endIdx - 1))]%;\
    /let _newQueueData=$[substr(_queueData, _endIdx)]%;\
    /test setVar(_queueName, _newQueueData)%;\
    /result _retVal


/def dequeue_popLast = \
    /let _queueName=%{1}%;\
    /let _queueData=$[getVar(_queueName)]%;\
    /if (strlen(_queueData) <= 1) \
        /result ""%;\
    /endif%;\
    /let _startIdx=$[strrchr(_queueData, " ", strlen(_queueData)-2)]%;\
;    /if (assert(_endIdx != -1, "Invalid dequeue data structure."))\
;        /result ""%;\
;    /endif%;\
    /let _retVal=$[textdecode(substr(_queueData, _startIdx + 1, strlen(_queueData) - _startIdx - 2))]%;\
    /let _newQueueData=$[substr(_queueData, 0, _startIdx + 1)]%;\
    /test setVar(_queueName, _newQueueData)%;\
    /result _retVal

; Queue aliases
;
; These don't add funcitonality but given meaningful aliases.

/def queue_init = \
    /test dequeue_init({1})

/def queue_push = \
    /test dequeue_append({1}, {2})

/def queue_pop = \
    /let _queueName=%{1}%;\
    /result dequeue_popFirst({_queueName})

/def queue_length = \
    /result dequeue_length({1})

; Stack aliases
;
; These don't add funcitonality but given meaningful aliases.

/def stack_init = \
    /test dequeue_init({1})

/def stack_push = \
    /test dequeue_append({1}, {2})

/def stack_pop = \
    /let _stackName=%{1}%;\
    /result dequeue_popLast({_stackName})

/def stack_length = \
    /result dequeue_length({1})


/tfunit_declareGroup tf_util_container

/def test_tf_util_container_Basic_Dequeue = \
    /dequeue_init testQueue%;\
    /let _first=$[dequeue_popFirst("testQueue")]%;\
    /test tfunit_assertStrEqual("", _first, "New queue should be empty.")%;\
    /dequeue_append testQueue first%;\
    /let _len=$[dequeue_length("testQueue")]%;\
    /test tfunit_assertEqual(1, _len, "Queue length should be 1 after initial append.")%;\
    /let _first=$[dequeue_popFirst("testQueue")]%;\
    /test tfunit_assertStrEqual("first", _first, "New queue should be empty.")%;\
    /let _len=$[dequeue_length("testQueue")]%;\
    /test tfunit_assertEqual(0, _len, "Queue length should be 1 after initial append.")

/def test_tf_util_container_Init_Resets_Dequeue = \
    /dequeue_init testQueue%;\
    /test dequeue_append("testQueue", "first item")%;\
    /let _len=$[dequeue_length("testQueue")]%;\
    /test tfunit_assertEqual(1, _len, "Queue should have one item after append.")%;\
    /test dequeue_init("testQueue")%;\
    /test _len := dequeue_length("testQueue")%;\
    /test tfunit_assertEqual(0, _len, "Queue should have one item after append.")

/def test_tf_util_container_Dequeue_Handles_Data_With_Spaces = \
    /dequeue_init testQueue%;\
    /test dequeue_append("testQueue", "first item")%;\
    /test dequeue_append("testQueue", "second item")%;\
    /test dequeue_append("testQueue", "third item")%;\
    /let _next=$[dequeue_popFirst("testQueue")]%;\
    /test tfunit_assertStrEqual("first item", _next, "popFirst should preserve spaces")%;\
    /let _next=$[dequeue_popLast("testQueue")]%;\
    /test tfunit_assertStrEqual("third item", _next, "popLast should preserve spaces")

/def test_tf_util_container_Queue_Ordering = \
    /queue_init testQueue%;\
    /queue_push testQueue first%;\
    /queue_push testQueue second%;\
    /queue_push testQueue third%;\
    /let _next=$[queue_pop("testQueue")]%;\
    /test tfunit_assertStrEqual("first", _next, "Queues should be first-in/first-out")%;\
    /test _next := queue_pop("testQueue")%;\
    /test tfunit_assertStrEqual("second", _next, "Queues should be first-in/first-out")%;\
    /test _next := queue_pop("testQueue")%;\
    /test tfunit_assertStrEqual("third", _next, "Queues should be first-in/first-out")%;\
    /test _next := queue_pop("testQueue")

/def test_tf_util_container_Stack_Ordering = \
    /stack_init teststack%;\
    /stack_push teststack first%;\
    /stack_push teststack second%;\
    /stack_push teststack third%;\
    /let _next=$[stack_pop("teststack")]%;\
    /test tfunit_assertStrEqual("third", _next, "stacks should be first-in/first-out")%;\
    /test _next := stack_pop("teststack")%;\
    /test tfunit_assertStrEqual("second", _next, "stacks should be first-in/first-out")%;\
    /test _next := stack_pop("teststack")%;\
    /test tfunit_assertStrEqual("first", _next, "stacks should be first-in/first-out")%;\
    /test _next := stack_pop("teststack")


/tfunit_endGroup

