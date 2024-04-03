FROM centos:centos7

RUN yum -y update && yum -y install make gcc openssl-devel libffi-devel bzip2-devel perl-core pcre-devel zlib-devel && yum clean all

RUN mkdir -p /usr/src/openssl 
WORKDIR /usr/src/openssl 

RUN curl -L https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz | tar xz --strip-components=1 
RUN ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic && make -j$(nproc) && make install

RUN mkdir -p /usr/src/python
WORKDIR /usr/src/python

RUN curl -L https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz | tar xz --strip-components=1 
RUN ./configure --with-openssl=/usr && make -j$(nproc) && make install

RUN python3 --version | grep 3.12
RUN python3 -m ensurepip && python3 -m pip --version

RUN python3 -m ensurepip --upgrade && python3 -m pip install setuptools
