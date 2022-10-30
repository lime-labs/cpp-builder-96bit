FROM oraclelinux:7-slim

RUN mkdir /app

COPY entrypoint.sh install-grpc-cpprestsdk-vcpkg-etcd.sh /app/

RUN yum install -y oraclelinux-release-el7 oracle-softwarecollection-release-el7
RUN /usr/bin/ol_yum_configure.sh
RUN yum-config-manager --enable software_collections
RUN yum-config-manager --enable ol7_latest ol7_optional_latest
RUN yum install -y scl-utils

RUN yum install -y https://repo.ius.io/ius-release-el7.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum -y group install "Development Tools" && yum remove -y git

RUN yum install -y devtoolset-8 devtoolset-8-libstdc++-devel devtoolset-8-libstdc++-devel.i686 which zip unzip tar bzip2 curl wget mc vim git236 cmake3 \
    perl-IPC-Cmd.noarch libgcc libgcc.i686 glibc.i686 glibc-devel glibc-devel.i686 libzip-devel libzip-devel.i686 zlib-devel zlib-devel.i686 \
    libstdc++.i686 libstdc++ gmp-devel gmp-devel.i686 mpfr-devel mpfr-devel.i686 libmpc-devel libmpc-devel.i686

# etcd dependencies
RUN yum install -y boost-devel boost-devel.i686 openssl-devel openssl-devel.i686

# more libs
RUN /app/install-grpc-cpprestsdk-vcpkg-etcd.sh

# cleanup
RUN yum clean all && rm -rf /var/cache/yum

WORKDIR /code

ENTRYPOINT [ "/app/entrypoint.sh" ]