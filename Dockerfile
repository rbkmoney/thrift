# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#

# Goal: provide a thrift-compiler Docker image
#
# Usage:
#   docker run --rm -v ${PWD}:${PWD} --workdir ${PWD} rbkmoney/thrift-compiler $*
#
# further details on docker for thrift is here build/docker/
#
# TODO: push to apache/thrift-compiler instead of thrift/thrift-compiler

FROM debian:jessie
MAINTAINER Mayorov Andrey <a.mayorov@rbkmoney.com>

ENV DEBIAN_FRONTEND noninteractive

ADD . /thrift

RUN \
    DEPS="make curl openssl ca-certificates" \
    BUILD_DEPS="flex bison g++ cmake" \
    && apt-get update && apt-get install -y --no-install-recommends ${DEPS} ${BUILD_DEPS} \
    && mkdir /tmp/cmake-build && cd /tmp/cmake-build \
    && cmake \
       -DBUILD_COMPILER=ON \
       -DBUILD_LIBRARIES=OFF \
       -DBUILD_TESTING=OFF \
       -DBUILD_EXAMPLES=OFF \
       /thrift \
    && cmake --build . --config Release \
    && make install \
    && rm -rf /thrift \
    && apt-get purge -y --auto-remove ${BUILD_DEPS} \
    && apt-get clean \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

ENV GOVERSION "1.6"
RUN \
    curl -k -sSL "https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
    && tar xzf /tmp/go.tar.gz -C /tmp \
    && cp /tmp/go/bin/gofmt /usr/bin/gofmt \
    && rm -rf /tmp/*

CMD ["thrift", "-help"]
