# tf-util

General utility modules and functions for TinyFugue

This library provides supplemental functionality that I would have liked to
see included in the built-in libraries.

## Modules

- [containers.tf](#user-content-containerstf) - stacks/queues/dequeues
- [events.tf](#user-content-eventstf) - event firing mechanism
- [list-macros.tf](#user-content-list-macrostf) - list/filter macros and functions based on regex
- [loader.tf](#user-content-loadertf) - module loading/tracking mechnism
- [logging.tf](#user-content-loggingtf) - debugging and logging functions
- [redis.tf](#user-content-redistf) - Redis server integration
- [unit-test.tf](#user-content-unit-testtf) - unit testing implementing in TinyFugue scripting
- [variables.tf](#user-content-variablestf) - user variables with default values.

## main.tf

Main entry point. This provides /requires for all modules in this library.

## containers.tf

Support for stacks, queues, and dequeues.

It's actually all just dequeues with stack and queue convenience functions
mapped to their dequeue implementations.

### Dequeue functions

- `dequeue_init(queueName)`

  Create a user variable for a dequeue container. Clobbers any existing data
  in that variable.

- `dequeue_length(queueName)`

  Return the number of elements in a container.

- `dequeue_append(queueName, value)`

  Add an element to the end of the dequeue.

- (TODO) `dequeue_prepend(queueName, value)`

  Add an element to the beginning of the dequeue.

- `dequeue_popFirst(queueName)`

  Remove the first element in the dequeue and return it.

- `dequeue_popLast(queueName)`

  Remove the last element in the dequeue and return it.

### Aliases

- `stack_init(...)`

  Alias for `dequeue_init(...)`

- `stack_length(...)`

  Alias for `dequeue_length(...)`

- `stack_push(...)`

  Alias for `dequeue_append(...)`

- `stack_pop(...)`

  Alias for `dequeue_popLast(...)`

- `queue_init(...)`

  Alias for `dequeue_init(...)`

- `queue_length(...)`

  Alias for `dequeue_length(...)`

- `queue_push(...)`

  Alias for `dequeue_append(...)`

- `queue_pop(...)`

  Alias for `dequeue_popFirst(...)`

## events.tf

Basic event firing and observing mechanism.

This is great for decoupling bits of code. Events should be named with just
letters and periods. The order in which event listeners are called is
undefined.

- `event_addListener(eventName, callbackMacroName)`

  Add a listener function to be called when the event is fired.

- `event_removeListener(eventName, callbackMacroName)`

  Remove a listener function from the list of callbacks for a given event.

- `event_fire(eventName, parametersForCallback, ...)

  Fire an event and pass the given parameters to each registered callback.

## list-macros.tf

## loader.tf

## logging.tf

- `list_macros(regex)`

  Return a space-delimited list of macros matching the given regular expression.

## redis.tf

- `redis<Command>(parameters)`

  Send the given command to the Redis server. Many basic commands are
  supported. See source for exhaustive list.

## unit-test.tf

- `tfunit_declareGroup(groupName)`

  Declare of a group of unit tests that will be run together.

- `tfunit_endGroup()`

  Ends the current group of unit tests and runs them.

- `tfunit_assertTrue(value, message)`
- `tfunit_assertEqual(expected, observed, message)`
- `tfunit_assertStrEqual(expected, observed, message)`

  Basic assert messages. StrEqual uses the `=~` operator while Equal uses `==`.

- `tfunit_testGroup(groupName)`

  Run the unit tests in the named test group.

## variables.tf

It may seem redundant, but providing a more robust system for managing
variables can be a great way to provide flexibility in handling variable
persistence and events.

- `declareVar(varName, default)`

  Declare a variable and make it available possibly with a default value. 
  This is non-destructive if the variable already exists.

- `setVar(varName, newValue)`

  Change the value of a given variable

- `getVar(varName)`

  Get the current effective value of the variable.

- `saveVars(filename)`
- `loadVars(filename)`

  Save/Load all user-land variables to a file in `TF_NPM_ROOT/data/variables`.

- `watchVar(varName, callback)`
- `unwatchVar(varName, callback)`

  Watch or unwatch for changes in a variable. The callback should be of the
  signature `callback(oldVal, newVal). The callback cannot prevent the change
  from occurring.

