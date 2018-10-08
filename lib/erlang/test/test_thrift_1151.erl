-module(test_thrift_1151).

-include("gen-erlang/thrift1151_thrift.hrl").

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

unmatched_struct_test() ->
  S1 = #{'$struct' => 'StructC', x => #{'$struct' => 'StructB', x => 1}},
  {ok, Transport} = thrift_memory_buffer:new(),
  {ok, Protocol} = thrift_binary_protocol:new(Transport),
  ?assertEqual(
    {Protocol, {error, {invalid, [x], #{'$struct' => 'StructB', x => 1}}}},
    thrift_protocol:write(
      Protocol,
      {{struct, struct, {thrift1151_thrift, 'StructC'}}, S1}
    )
  ).



-endif.
