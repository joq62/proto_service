%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%% 
%%% @end
%%% Created : 18 Apr 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(proto). 
  
-behaviour(gen_server).
%%--------------------------------------------------------------------
%% Include 
%%
%%--------------------------------------------------------------------

-include("log.api").

-include("proto.hrl").
-include("proto.rd").



%% API
-export([
	 %% CRUD
	 create/2,
	 read/1,
	 update/2,
	 delete/1,
	 get_all/0
	]).

%% OaM 
-export([


	]).

%% admin

-export([
	 ping/0,
	 stop/0
	]).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3, format_status/2]).

-define(SERVER, ?MODULE).
	

-record(state, {
	
	       }).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
-spec create(Key :: atom(),Value :: term()) -> ok | Error::term().
create(Key,Value)-> 
    gen_server:call(?SERVER, {create,Key,Value},infinity).

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
-spec read(Key :: atom()) -> {ok,Value ::term()} | Error::term().
read(Key)-> 
    gen_server:call(?SERVER, {read,Key},infinity).

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
-spec update(Key :: atom(),NewValue :: term()) -> ok | Error::term().
update(Key,NewValue)-> 
    gen_server:call(?SERVER, {update,Key,NewValue},infinity).

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
-spec delete(Key :: atom()) -> ok | Error::term().
delete(Key)-> 
    gen_server:call(?SERVER, {delete,Key},infinity).
%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
-spec get_all() -> KeyValues::term() | Error::term().
get_all()-> 
    gen_server:call(?SERVER, {get_all},infinity).

%%--------------------------------------------------------------------
%% @doc
%% 
%% @end
%%--------------------------------------------------------------------
-spec ping() -> pong | Error::term().
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> {ok, Pid :: pid()} |
	  {error, Error :: {already_started, pid()}} |
	  {error, Error :: term()} |
	  ignore.
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


%stop()-> gen_server:cast(?SERVER, {stop}).
stop()-> gen_server:stop(?SERVER).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%% @end
%%--------------------------------------------------------------------
-spec init(Args :: term()) -> {ok, State :: term()} |
	  {ok, State :: term(), Timeout :: timeout()} |
	  {ok, State :: term(), hibernate} |
	  {stop, Reason :: term()} |
	  ignore.

init([]) ->
    
    {ok, #state{
	   
	    
	   },0}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request :: term(), From :: {pid(), term()}, State :: term()) ->
	  {reply, Reply :: term(), NewState :: term()} |
	  {reply, Reply :: term(), NewState :: term(), Timeout :: timeout()} |
	  {reply, Reply :: term(), NewState :: term(), hibernate} |
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: term(), Reply :: term(), NewState :: term()} |
	  {stop, Reason :: term(), NewState :: term()}.


handle_call({create,Key,Value}, _From, State) ->
  %  io:format(" ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    Result=try lib_kvs:create(Key,Value) of
	       ok->
		   ok;
	       {error,Reason}->
		   {error,Reason}
	   catch
	       Event:Reason:Stacktrace ->
		   {Event,Reason,Stacktrace,?MODULE,?LINE}
	   end,
    Reply=case Result of
	      ok->
		  ok;
	      ErrorEvent->
		  ?LOG2_WARNING("Failed to create ",[Key,Value,ErrorEvent]),
		  ?LOG_WARNING("Failed to create ",[Key,Value,ErrorEvent]),
		  ErrorEvent
	  end,
    {reply, Reply, State};
handle_call({update,Key,NewValue}, _From, State) ->
  %  io:format(" ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    Result=try lib_kvs:update(Key,NewValue) of
	       ok->
		   ok;
	       {error,Reason}->
		   {error,Reason}
	   catch
	       Event:Reason:Stacktrace ->
		   {Event,Reason,Stacktrace,?MODULE,?LINE}
	   end,
    Reply=case Result of
	      ok->
		  ok;
	      ErrorEvent->
		  ?LOG2_WARNING("Failed to create ",[Key,NewValue,ErrorEvent]),
		  ?LOG_WARNING("Failed to create ",[Key,NewValue,ErrorEvent]),
		  ErrorEvent
	  end,
    {reply, Reply, State};
handle_call({delete,Key}, _From, State) ->
  %  io:format(" ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    Result=try lib_kvs:delete(Key) of
	       ok->
		   ok;
	       {error,Reason}->
		   {error,Reason}
	   catch
	       Event:Reason:Stacktrace ->
		   {Event,Reason,Stacktrace,?MODULE,?LINE}
	   end,
    Reply=case Result of
	      ok->
		  ok;
	      ErrorEvent->
		  ?LOG2_WARNING("Failed to do read",[Key,ErrorEvent]),
		  ?LOG_WARNING("Failed to do read",[Key,ErrorEvent]),
		  ErrorEvent
	  end,
    {reply, Reply, State};

handle_call({read,Key}, _From, State) ->
  %  io:format(" ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    Result=try lib_kvs:read(Key) of
	       {ok,R}->
		   {ok,R};
	       {error,Reason}->
		   {error,Reason}
	   catch
	       Event:Reason:Stacktrace ->
		   {Event,Reason,Stacktrace,?MODULE,?LINE}
	   end,
    Reply=case Result of
	      {ok,Value}->
		  {ok,Value};
	      ErrorEvent->
		  ?LOG2_WARNING("Failed to do read",[Key,ErrorEvent]),
		  ?LOG_WARNING("Failed to do read",[Key,ErrorEvent]),
		  ErrorEvent
	  end,
    {reply, Reply, State};

handle_call({get_all}, _From, State) ->
  %  io:format(" ~p~n",[{?FUNCTION_NAME,?MODULE,?LINE}]),
    Result=try lib_kvs:get_all() of
	       {ok,R}->
		   {ok,R};
	       {error,Reason}->
		   {error,Reason}
	   catch
	       Event:Reason:Stacktrace ->
		   {Event,Reason,Stacktrace,?MODULE,?LINE}
	   end,
    Reply=case Result of
	      {ok,KeyValues}->
		  {ok,KeyValues};
	      ErrorEvent->
		  ?LOG2_WARNING("Failed to get_all",[ErrorEvent]),
		  ?LOG_WARNING("Failed to get_all",[ErrorEvent]),
		  ErrorEvent
	  end,
    {reply, Reply, State};


handle_call({ping}, _From, State) ->
    Reply=pong,
    {reply, Reply, State};

handle_call(UnMatchedSignal, From, State) ->
    io:format("unmatched_signal ~p~n",[{UnMatchedSignal, From,?MODULE,?LINE}]),
    Reply = {error,[unmatched_signal,UnMatchedSignal, From]},
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%% @end
%%--------------------------------------------------------------------

handle_cast({stop}, State) ->
    
    {stop,normal,ok,State};

handle_cast(UnMatchedSignal, State) ->
    ?LOG2_WARNING("Unmatched signal",[UnMatchedSignal]),
    ?LOG_WARNING("unmatched signal ",[UnMatchedSignal]),
    io:format("unmatched_signal ~p~n",[{UnMatchedSignal,?MODULE,?LINE}]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_info(Info :: timeout() | term(), State :: term()) ->
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: normal | term(), NewState :: term()}.


handle_info(timeout, State) ->
      
    [rd:add_local_resource(ResourceType,Resource)||{ResourceType,Resource}<-?LocalResourceTuples],
    [rd:add_target_resource_type(TargetType)||TargetType<-?TargetTypes],
    rd:trade_resources(),
    timer:sleep(2000),
  

    ?LOG2_NOTICE("Started",[]),
    ?LOG_NOTICE("Started",[]),
    {noreply, State};


handle_info(Info, State) ->
    ?LOG2_WARNING("Unmatched signal",[Info]),
    ?LOG_WARNING("unmatched signal ",[Info]),
    io:format("unmatched_signal ~p~n",[{Info,?MODULE,?LINE}]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason :: normal | shutdown | {shutdown, term()} | term(),
		State :: term()) -> any().
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%% @end
%%--------------------------------------------------------------------
-spec code_change(OldVsn :: term() | {down, term()},
		  State :: term(),
		  Extra :: term()) -> {ok, NewState :: term()} |
	  {error, Reason :: term()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called for changing the form and appearance
%% of gen_server status when it is returned from sys:get_status/1,2
%% or when it appears in termination error logs.
%% @end
%%--------------------------------------------------------------------
-spec format_status(Opt :: normal | terminate,
		    Status :: list()) -> Status :: term().
format_status(_Opt, Status) ->
    Status.

%%%===================================================================
%%% Internal functions
%%%===================================================================
