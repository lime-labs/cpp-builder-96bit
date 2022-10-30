#!/bin/bash

scl enable devtoolset-8 bash

# create link from cmake to cmake3
ln -s /usr/bin/cmake3 /usr/bin/cmake

cd /tmp/

# gRPC
git clone https://github.com/grpc/grpc.git --depth 1 --branch v1.27.x
cd grpc/
git submodule update --init
mkdir cmake-build
cd cmake-build/
cmake .. -DBUILD_SHARED_LIBS=ON \
-DgRPC_INSTALL=ON \
-DgRPC_BUILD_TESTS=OFF \
-DgRPC_BUILD_CSHARP_EXT=OFF \
-DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
-DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
-DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
-DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
-DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
-DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
-DgRPC_BACKWARDS_COMPATIBILITY_MODE=ON \
-DgRPC_ZLIB_PROVIDER=package \
-DgRPC_SSL_PROVIDER=package
make -j`nproc`
make install

cd ../../

# ccprestsdk
git clone https://github.com/microsoft/cpprestsdk.git
cd cpprestsdk
mkdir build && cd build
cmake .. -DCPPREST_EXCLUDE_WEBSOCKETS=ON
make -j$(nproc) && make install

cd ../../

# vcpkg
git clone https://github.com/Microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh

# etcd
git clone https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3.git
cd etcd-cpp-apiv3
mkdir build && cd build
cmake ..
make -j$(nproc) && make install

#cleanup
cd ../../
rm -rf grpc cpprestsdk vcpkg