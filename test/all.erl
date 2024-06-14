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


-define(TargetDir,"proto_service_dir").
-define(Vm,proto_service@c50).
-define(TarFile,"proto_service.tar.gz").
-define(App,"proto_service").
-define(TarSrc,"release"++"/"++?TarFile).
-define(StartCmd,"./"++?TargetDir++"/"++"bin"++"/"++?App).

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    
    ok=setup(),
    ok=load_start_release(),
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
    {ok,P}=python:start([{python,"python3"},{python_path,["py"]}]),
    python:call(P,xx,main,[]),
    44=2+python:call(P,xx,add,[20,22]),
   
    ok.
    
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------


load_start_release()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    %% Delete ad_rel dir used for tar, stop Vm
    file:del_dir_r(?TargetDir),
    rpc:call(?Vm,init,stop,[],3000),
    timer:sleep(2000),
    
    %%
    ok=file:make_dir(?TargetDir),
    []=os:cmd("tar -zxf "++?TarSrc++" -C "++?TargetDir),
    
    %%
    []=os:cmd(?StartCmd++" "++"daemon"),
    timer:sleep(500),
  
    pong=rpc:call(?Vm,rd,ping,[],5000),
    pong=rpc:call(?Vm,log,ping,[],5000),


    AllApps=rpc:call(?Vm,application,which_applications,[],6000),
    io:format("AllApps ~p~n",[{AllApps,?MODULE,?LINE,?FUNCTION_NAME}]),
    {ok,Cwd}=rpc:call(?Vm,file,get_cwd,[],6000),
    io:format("Cwd ~p~n",[{Cwd,?MODULE,?LINE,?FUNCTION_NAME}]),
    {ok,Filenames}=rpc:call(?Vm,file,list_dir,[Cwd],6000),
    io:format("Filenames ~p~n",[{Filenames,?MODULE,?LINE,?FUNCTION_NAME}]),
    AbsName=rpc:call(?Vm,code,where_is_file,["python.beam"],6000),
    io:format("AbsName ~p~n",[{AbsName,?MODULE,?LINE,?FUNCTION_NAME}]),
    
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),

    ok.
    
