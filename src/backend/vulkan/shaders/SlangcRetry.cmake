# Runs one slangc invocation, retrying it a few times before giving up.
#
# slangc dies intermittently when several copies run at once (0xC0000005, or
# "aborted due to internal error"), only on Windows so far. Serializing all
# 680 blobs costs the better part of an hour, so retry after a growing wait,
# and hold a lock while retrying: the int8 projection_bwd blobs otherwise
# retry together and kill each other every time, while either alone compiles.
#
# The command arrives as one string with '|' between arguments, because -D
# cannot carry a list through to a script.

string(REPLACE "|" ";" _cmd "${SS_CMD}")

# Seconds to wait before each retry; its length sets the retry count.
set(_backoff 2 5 10 20)
list(LENGTH _backoff _retries)
math(EXPR _attempts "${_retries} + 1")

foreach(_attempt RANGE ${_retries})
    if(_attempt GREATER 0)
        file(LOCK "${CMAKE_CURRENT_BINARY_DIR}/slangc_retry.lock" GUARD PROCESS
             TIMEOUT 3600 RESULT_VARIABLE _lock)
    endif()
    execute_process(COMMAND ${_cmd} RESULT_VARIABLE _rv
                    OUTPUT_VARIABLE _out ERROR_VARIABLE _err)
    if(_rv EQUAL 0)
        if(_out)
            message("${_out}")
        endif()
        if(_err)
            message("${_err}")
        endif()
        return()
    endif()
    if(_attempt GREATER 0)
        file(LOCK "${CMAKE_CURRENT_BINARY_DIR}/slangc_retry.lock" RELEASE)
    endif()
    if(_attempt LESS _retries)
        list(GET _backoff ${_attempt} _wait)
        message(STATUS "slangc failed (${_rv}) on ${SS_BLOB}, attempt "
                       "${_attempt}; retrying in ${_wait}s")
        execute_process(COMMAND ${CMAKE_COMMAND} -E sleep ${_wait})
    endif()
endforeach()

message(FATAL_ERROR
        "slangc failed ${_attempts} times on ${SS_BLOB}:\n${_err}${_out}")
