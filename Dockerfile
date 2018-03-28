FROM ubuntu:latest

RUN \
    apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        cmake \
        doxygen \
        git \
        libboost-all-dev \
        libreadline-dev \
        libssl-dev \
        libtool \
        ncurses-dev \
        pbzip2 \
        pkg-config \
        python3 \
        python3-dev \
        python3-jinja2 \
        python3-pip \
        nginx \
        fcgiwrap \
        s3cmd \
        awscli \
        jq \
        wget \
        gdb

RUN mkdir -p /home/coengineerd

ADD . /home/coengineerd

RUN \
    cd /home/coengineerd && \
	rm -rf build/ && \
    mkdir -p build && \
    cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_STEEM_TESTNET=OFF \
        -DLOW_MEMORY_NODE=OFF \
        .. && \
    make -j${nproc}

RUN \
    cd /home/coengineerd && \
    mkdir -p bin && \
    cd bin && \
    cp ../build/programs/coengineerd/coengineerd . && \
    cp ../build/programs/cli_wallet/cli_wallet . && \
    mkdir -p witness_node_data_dir

ADD ./server.pem /home/coengineerd/bin/
ADD ./wallet.json /home/coengineerd/bin/
ADD ./config.ini /home/coengineerd/bin/witness_node_data_dir/
ADD ./programs/coengineerd/coengineer.json /home/coengineerd/bin/

RUN cd /home/coengineerd/bin/ && ./coengineerd & ./cli_wallet
