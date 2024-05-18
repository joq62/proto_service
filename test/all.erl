%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(all).      
 
-export([start/0]).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(LocalResourceTuples,[{log2,{log2,node()}}]).
-define(TargetTypes,[log2]).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    
    ok=setup(),
    ok=py_test(),
%    ok=normal_test(),
 
 
    io:format("Test OK !!! ~p~n",[?MODULE]),
   % timer:sleep(1000),
   % init:stop(),
    ok.


%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
py_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    {ok,P}=python:start([{python,"python3"}]),
    python:call(P,xx,main,[]),
    44=2+python:call(P,xx,add,[20,22]),
    
    ok.
    
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
normal_test()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),


    ok.
    


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),


    {ok,_}=log:start_link(),
    pong=log:ping(),
    {ok,_}=rd:start_link(),
    pong=rd:ping(),

    [rd:add_local_resource(ResourceType,Resource)||{ResourceType,Resource}<-?LocalResourceTuples],
    [rd:add_target_resource_type(TargetType)||TargetType<-?TargetTypes],
    rd:trade_resources(),
    timer:sleep(3000),

    {ok,_}=log2:start_link(),
    pong=log2:ping(),
    {ok,_}=proto:start_link(),
     pong=proto:ping(),
    ok.
    
