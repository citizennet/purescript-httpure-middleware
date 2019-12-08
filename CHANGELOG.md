# Changelog

# Unreleased

# 1.2.0 - 2019-12-08

## Added

* `HTTPure.Middleware.LogLifecycle` - codifies lifecycle functions for logging
* `HTTPure.Middleware.LogTime` - codifies time data around a request
* `HTTPure.Middleware.Middleware` - a type synonym for middlewares
* `HTTPure.Middleware.log` - generalizes the previous log middlewares to allow any output
* `HTTPure.Middleware.logWithTime` - provides a simplification for logging with time
* `HTTPure.Middleware.timeout` - aborts requests if they take too long

## Fixed

* Lock down `purescript-httpure` version - `purescript-httpure` allows breaking changes in patch versions which conflicts with SemVer caret

# 1.1.0 - 2019-04-25

## Added

* `HTTPure.Middleware.developmentLogFormat` - uses a non-standard log format that is more verbose and easier to read

# 1.0.0 - 2019-04-23

Initial release.

## Added

* `HTTPure.Middleware.commonLogFormat` - following the Apache common log format
* `HTTPure.Middleware.combinedLogFormat` - Following the Apache combined log format