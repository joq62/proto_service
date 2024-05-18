-module(py).
-export([hello/1]).

hello(Name) ->
    % Spawn the hello.py script and open communication channels
    Port = open_port({spawn, "python3 -u py/hello.py"},
                     [{packet, 1}, binary, use_stdio]),
    % Convert the tuple {hello, Name} to external term format
  %  Port ! {self(), {hello, Name}},
    Port ! {self(),{hello, term_to_binary(Name)}},
    receive
        {Port, {data, Data}} ->
            io:format("Received from Python: ~p~n", [Data])
    end,
    % Close the port
    Port ! {self(), close},
    receive
        {Port, closed} ->
            ok
    end.
