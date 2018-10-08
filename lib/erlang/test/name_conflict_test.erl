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

-module(name_conflict_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

-include("gen-erlang/name_conflict_test_thrift.hrl").

struct_info_test_() ->
  [
    {"using extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, double, single, undefined},
        {2, undefined, double, integer, undefined}
      ]},
      name_conflict_test_thrift:struct_info(using)
    )},
    {"delegate extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, string, partial, undefined},
        {2, undefined, {struct, struct, {name_conflict_test_thrift, delegate}}, delegate, undefined}
      ]},
      name_conflict_test_thrift:struct_info(delegate)
    )},
    {"get extended definition", ?_assertEqual(
      {struct, struct, [{1, undefined, bool, sbyte, undefined}]},
      name_conflict_test_thrift:struct_info(get)
    )},
    {"partial extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, {struct, struct, {name_conflict_test_thrift, using}}, using, undefined},
        {2, undefined, bool, read, undefined},
        {3, undefined, bool, write, undefined}
      ]},
      name_conflict_test_thrift:struct_info(partial)
    )},
    {"ClassAndProp extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, bool, 'ClassAndProp', undefined},
        {2, undefined, bool, 'ClassAndProp_', undefined},
        {3, undefined, bool, 'ClassAndProp__', undefined},
        {4, undefined, bool, 'ClassAndProper', undefined}
      ]},
      name_conflict_test_thrift:struct_info('ClassAndProp')
    )},
    {"second_chance extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, bool, 'SECOND_CHANCE', undefined},
        {2, undefined, bool, 'SECOND_CHANCE_', undefined},
        {3, undefined, bool, 'SECOND_CHANCE__', undefined},
        {4, undefined, bool, 'SECOND_CHANCES', undefined}
      ]},
      name_conflict_test_thrift:struct_info(second_chance)
    )},
    {"NOW_EAT_THIS extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, bool, now_eat_this, undefined},
        {2, undefined, bool, now_eat_this_, undefined},
        {3, undefined, bool, now_eat_this__, undefined},
        {4, undefined, bool, now_eat_this_and_this, undefined}
      ]},
      name_conflict_test_thrift:struct_info('NOW_EAT_THIS')
    )},
    {"TheEdgeCase extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, bool, theEdgeCase, undefined},
        {2, undefined, bool, theEdgeCase_, undefined},
        {3, undefined, bool, theEdgeCase__, undefined},
        {4, undefined, bool, 'TheEdgeCase', undefined},
        {5, undefined, bool, 'TheEdgeCase_', undefined},
        {6, undefined, bool, 'TheEdgeCase__', undefined}
      ]},
      name_conflict_test_thrift:struct_info('TheEdgeCase')
    )},
    {"Tricky_ extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, bool, tricky, undefined},
        {2, undefined, bool, 'Tricky', undefined}
      ]},
      name_conflict_test_thrift:struct_info('Tricky_')
    )},
    {"Nested extended definition", ?_assertEqual(
      {struct, struct, [
        {1, undefined, {struct, struct, {
          name_conflict_test_thrift,
          'ClassAndProp'
        }}, 'ClassAndProp', undefined},
        {2, undefined, {struct, struct, {
          name_conflict_test_thrift,
          second_chance
        }}, second_chance, undefined},
        {3, undefined, {struct, struct, {
          name_conflict_test_thrift,
          'NOW_EAT_THIS'
        }}, 'NOW_EAT_THIS', undefined},
        {4, undefined, {struct, struct, {
          name_conflict_test_thrift,
          'TheEdgeCase'
        }}, 'TheEdgeCase', undefined},
        {5, undefined, {struct, struct, {
          name_conflict_test_thrift,
          'Tricky_'
        }}, 'Tricky_', undefined},
        {6, undefined, {struct, struct, {
          name_conflict_test_thrift,
          'Nested'
        }}, 'Nested', undefined}
      ]},
      name_conflict_test_thrift:struct_info('Nested')
    )},
    {"Problem_ extended definition", ?_assertEqual(
      {struct, exception, [
        {1, undefined, bool, problem, undefined},
        {2, undefined, bool, 'Problem', undefined}
      ]},
      name_conflict_test_thrift:struct_info('Problem_')
    )}
  ].

service_info_test_() ->
  [
    {"event params", ?_assertEqual(
      {struct, struct, [{1, undefined, {struct, struct, {name_conflict_test_thrift, partial}}, 'get', undefined}]},
      name_conflict_test_thrift:function_info(extern, event, params_type)
    )},
    {"event reply", ?_assertEqual(
      {struct, struct, {name_conflict_test_thrift, delegate}},
      name_conflict_test_thrift:function_info(extern, event, reply_type)
    )},
    {"event exceptions", ?_assertEqual(
      {struct, struct, []},
      name_conflict_test_thrift:function_info(extern, event, exceptions)
    )},
    {"Foo params", ?_assertEqual(
      {struct, struct, [{1, undefined, {struct, struct, {name_conflict_test_thrift, 'Nested'}}, 'Foo_args', undefined}]},
      name_conflict_test_thrift:function_info(extern, 'Foo', params_type)
    )},
    {"Foo reply", ?_assertEqual(
      {struct, struct, []},
      name_conflict_test_thrift:function_info(extern, 'Foo', reply_type)
    )},
    {"Foo exceptions", ?_assertEqual(
      {struct, struct, [{1, undefined, {struct, exception, {name_conflict_test_thrift, 'Problem_'}}, 'Foo_result', undefined}]},
      name_conflict_test_thrift:function_info(extern, 'Foo', exceptions)
    )}
  ].
