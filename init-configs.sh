bdep deinit -a && bdep config remove -a
rm -rf build-* .bdep test-*

common_flags=-Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic

bpkg create -d ./build-common   cc config.cxx=clang++ config.c=clang
bpkg create -d ./build-debug    cc config.cxx=clang++ config.c=clang "config.cc.coptions=-g -Og $common_flags" config.install.root=./install/debug
bpkg create -d ./build-release  cc config.cxx=clang++ config.c=clang "config.cc.coptions=-O2 $common_flags" config.install.root=./install/release

bdep init --empty

bdep config add ./build-debug @debug --default --forward
bdep config add ./build-release @release
bdep config add ./build-common @common

bdep config link @debug @common
bdep config link @release @common

bpkg add -d ./build-common https://queue.stage.build2.org/1
bpkg fetch -d ./build-common --trust EC:50:13:E2:3D:F7:92:B4:50:0B:BF:2A:1F:7D:31:04:C6:57:6F:BC:BE:04:2E:E0:58:14:FA:66:66:21:1F:14
bpkg pkg-fetch -d ./build-common libboost-graph/1.76.0
bpkg pkg-fetch -d ./build-common libboost-container/1.76.0
bpkg pkg-fetch -d ./build-common libboost-accumulators/1.76.0
bpkg pkg-fetch -d ./build-common libboost-array/1.76.0


bdep init @debug @release
bdep test @debug @release
b install: build-debug/aaa/
b install: build-release/aaa/

#####
# NOTES:
# 1. why do we get libicu?
# 2. `bdep status @common` says nothing is initialized there, which is true. I have to `bdep status @debug -r` to see the dependency tree, but right now it's unreadable.
# 3. For that kind of setup (where we want some dependencies to be built once for all and shared), having to specify the specific versions of these special dependencies is a bit problematic for maintenance.
#    I don't know if there is a way to make bpkg work with the constraints of projects without projects being initialized? Or at least a way to fetch package with a constraint expression instead of a version?
#
