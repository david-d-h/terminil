-module(terminil_ffi).
-export([enable_raw_mode/0, read/0]).

enable_raw_mode() ->
    case shell:start_interactive({noshell, raw}) of
        {error, already_started} -> error;
        ok -> ok
    end.

read() -> io:get_chars("", 1).
