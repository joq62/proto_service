all:
	#INFO: no_ebin_commit STARTED
	#INFO: Cleaning up to prepare build STARTED	 
	#INFO: Deleting crash reports
	rm -rf erl_cra* rebar3_crashreport_GLURK;
	#INFO: Deleting euinit test applications dirs
	rm -rf Mnesia* log resource_discovery etcd;
	rm -rf inventory;
	rm -rf host_specs catalog application_dir deployment_specs deployment_specs_test catalog_specs_test catalog_specs;
	rm -rf doc;
	rm -rf Mnesia.*;
	rm -rf test_ebin;
	#INFO: Deleting tilde files and beams
	rm -rf *~ */*~ */*/*~;
	rm -rf src/*.beam src/*/*.beam;
	rm -rf test/*.beam test/*/*.beam;
	rm -rf *.beam;
	#INFO: Deleting files and dirs created during builds
	rm -rf _build;
	rm -rf ebin;
	rm -rf rebar.lock
	#INFO: Deleting files and dirs created during execution/runtime 
	rm -rf logs;
	rm -rf *_a;
	rm -rf __pycache__ proto_service_dir; 
	#INFO: Compile application		
	rm -rf release;
	mkdir release;
	rebar3 compile
	rebar3 release;
	rebar3 as prod tar;
	cp _build/prod/rel/proto_service/proto_service-0.1.0.tar.gz release/proto_service.tar.gz;
	rm -rf _build*;
	git status
	echo Ok there you go!
build:
	#INFO: with_ebin_commit STARTED
	#INFO: Cleaning up to prepare build STARTED	 
	#INFO: Deleting crash reports
	rm -rf erl_cra* rebar3_crashreport_GLURK;
	#INFO: Deleting euinit test applications dirs
	rm -rf Mnesia* log resource_discovery etcd;
	rm -rf inventory;
	rm -rf host_specs catalog application_dir deployment_specs_test deployment_specs catalog_specs_test catalog_specs;
	rm -rf doc;
	rm -rf Mnesia.*;
	rm -rf test_ebin;
	#INFO: Deleting tilde files and beams
	rm -rf *~ */*~ */*/*~;
	rm -rf src/*.beam src/*/*.beam;
	rm -rf test/*.beam test/*/*.beam;
	rm -rf *.beam;
	#INFO: Deleting files and dirs created during builds
	rm -rf _build;
	rm -rf ebin;
	rm -rf rebar.lock
	#INFO: Deleting files and dirs created during execution/runtime 
	rm -rf logs;
	rm -rf *_a;
	rm -rf _build;
	#INFO: Compile application	
	rebar3 compile;
	rm -rf _build*;
	git status
	#INFO: build ENDED SUCCESSFUL
clean:
	#INFO: clean STARTED
	#INFO: Cleaning up to prepare build STARTED	 
	#INFO: Deleting crash reports
	rm -rf erl_cra* rebar3_crashreport_*;
	#INFO: Deleting euinit test applications dirs
	rm -rf Mnesia.* log resource_discovery etcd;
	rm -rf inventory;
	rm -rf catalog host_specs application_dir deployment_specs_test deployment_specs catalog_specs_test catalog_specs;
	rm -rf test_ebin;
	#INFO: Deleting tilde files and beams
	rm -rf *~ */*~ */*/*~;
	rm -rf src/*.beam src/*/*.beam;
	rm -rf test/*.beam test/*/*.beam;
	rm -rf *.beam;
	#INFO: Deleting files and dirs created during builds
	rm -rf _build;
	rm -rf ebin;
	rm -rf rebar.lock
	#INFO: Deleting files and dirs created during execution/runtime 
	rm -rf logs;
	rm -rf *_a;
	#INFO: clean ENDED SUCCESSFUL
eunit: 
	#INFO: eunit STARTED
	#INFO: Cleaning up to prepare build STARTED	 
	#INFO: Deleting crash reports
	rm -rf erl_cra* rebar3_crashreport_GLURK;
	#INFO: Deleting euinit test applications dirs
	rm -rf Mnesia.* log resource_discovery etcd;
	rm -rf inventory;
	rm -rf host_specs  catalog application_dir deployment_specs_test deployment_specs catalog_specs_test catalog_specs;
	rm -rf doc;
	rm -rf test_ebin;
	#INFO: Deleting tilde files and beams
	rm -rf src/*.beam src/*/*.beam;
	rm -rf test/*.beam test/*/*.beam;
	rm -rf *.beam;
	#INFO: Deleting files and dirs created during builds
	rm -rf _build;
	rm -rf ebin;
	rm -rf rebar.lock
	#INFO: Deleting files and dirs created during execution/runtime 
	rm -rf logs;
	rm -rf *_a;
	#INFO: Creating eunit test code using test_ebin dir;
	mkdir test_ebin;
	cp test/*.app test_ebin;
	#rm test/dependent_apps.erl;
	#cp /home/joq62/erlang/dev_support/dependent_apps.erl test;
	erlc -I include -I /home/joq62/erlang/include -o test_ebin test/*.erl;
	#INFO: Creating Common applications needed for testing
	#INFO: Compile application
	rm -rf release;
	mkdir release;
	rebar3 compile
	rebar3 release;
	rebar3 as prod tar;
	cp _build/prod/rel/proto_service/proto_service-0.1.0.tar.gz release/proto_service.tar.gz;
	rm -rf _build*;
	git status
	echo Ok there you go!
	#INFO: Starts the eunit testing .................
	erl -pa ebin -pa priv\
	 -pa test_ebin -pa py\
	 -pa _build/default/lib/*/ebin\
	 -sname proto_service_a\
	 -run $(m) start\
	 -setcookie a
