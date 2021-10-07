
rmdir /S /Q build-common
rmdir /S /Q build-debug
rmdir /S /Q build-release
rmdir /S /Q ".bdep"
rmdir /S /Q install

set common_flags="/W4"

bdep init --empty

bdep config create ./build-common   @common  cc config.cxx=cl --no-default
bdep config create ./build-debug    @debug   cc config.cxx=cl "config.cc.coptions=/Od /Zi %common_flags%" "config.cc.loptions=/DEBUG" config.install.root=./install/debug --default
bdep config create ./build-release  @release cc config.cxx=cl "config.cc.coptions=/O2 %common_flags%" config.install.root=./install/release

bdep config link @debug @common
bdep config link @release @common

bdep init @debug { @common }+ { ?libboost-graph ?libboost-container ?libboost-accumulators ?libboost-array ?fmt }
bdep init @release
bdep update @debug @release
bdep test @debug @release
REM b install: build-debug/aaa/     !config.install.root=./install/debug
REM b install: build-release/aaa/   !config.install.root=./install/release
