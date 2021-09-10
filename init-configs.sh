# bdep deinit -a && bdep config remove -a
rm -rf build-*/ .bdep/ install/

common_flags=-Wall -Wextra -Wshadow -Wnon-virtual-dtor -pedantic

bdep init --empty

bdep config create ./build-common   @common  cc config.cxx=clang++ config.c=clang --no-default
bdep config create ./build-debug    @debug   cc config.cxx=clang++ config.c=clang "config.cc.coptions=-g -Og $common_flags" config.install.root=./install/debug --default
bdep config create ./build-release  @release cc config.cxx=clang++ config.c=clang "config.cc.coptions=-O2 $common_flags" config.install.root=./install/release

bdep config link @debug @common
bdep config link @release @common

bdep init @debug { @common }+ { ?libboost-graph ?libboost-container ?libboost-accumulators ?libboost-array ?fmt }
bdep init @release
bdep test @debug @release
b install: build-debug/aaa/
b install: build-release/aaa/

#####
# NOTES:
# 1. why do we get libicu? ANSWER: because boost.graph depends on a myriad of libs for no good reason and among them some libs require ICU.
# 2. FIXED: `bdep status @common` says nothing is initialized there, which is true. I have to `bdep status @debug -r` to see the dependency tree, but right now it's unreadable.
#    SOLUTION: build2 now allows `bpkg status --all -d build-config/` which shows the actual dependencies there, not only the initialized projects.
# 3. FIXED: For that kind of setup (where we want some dependencies to be built once for all and shared), having to specify the specific versions of these special dependencies is a bit problematic for maintenance.
#    I don't know if there is a way to make bpkg work with the constraints of projects without projects being initialized? Or at least a way to fetch package with a constraint expression instead of a version?
#    SOLUTION: use `bdep build --dependency --configure-only`, the first flag makes the build command do nothing until the packages are actually used by some other project, the second makes sure we don't build yet.
