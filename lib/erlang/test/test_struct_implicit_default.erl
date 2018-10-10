%%
%% Licensed to the Apache Software Foundation (ASF) under one
%% or more contributor license agreements. See the NOTICE file
%% distributed with this work for additional information
%% regarding copyright ownership. The ASF licenses this file
%% to you under the Apache License, Version 2.0 (the
%% "License"); you may not use this file except in compliance
%% with the License. You may obtain a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied. See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%

-module(test_struct_implicit_default).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

-include("gen-erlang/implicit_default_thrift.hrl").

-define(THRIFT_TYPE, {struct, struct, {implicit_default_thrift, 'HereIAm'}}).

encode_decode_default_test() ->
  {ok, Transport} = thrift_memory_buffer:new(),
  {ok, Protocol0} = thrift_binary_protocol:new(Transport),
  InitialData = implicit_default_thrift:struct_new('HereIAm', #{name => <<"Test">>}),
  {Protocol1, ok} = thrift_protocol:write(Protocol0, {?THRIFT_TYPE, InitialData}),
  {_Protocol2, {ok, RoundtripData}} = thrift_protocol:read(Protocol1, ?THRIFT_TYPE),
  ?_assertMatch(InitialData, RoundtripData).


implicit_default_test() ->
  {ok, Transport} = thrift_memory_buffer:new(),
  {ok, Protocol0} = thrift_binary_protocol:new(Transport),
  InitialData = implicit_default_thrift:struct_new('HereIAm',
    #{age => undefined, name => <<"Jóhansson">>}),
  {Protocol1, ok} = thrift_protocol:write(Protocol0, {?THRIFT_TYPE, InitialData}),
  {_Protocol2, {ok, RoundtripData}} = thrift_protocol:read(Protocol1, ?THRIFT_TYPE),
  Map = #{name => <<"Jóhansson">>, age => 42, '$struct' => 'HereIAm'},
  ?_assertMatch(InitialData, RoundtripData).

-endif.
