FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV BOOST_ROOT=/opt/boost_1_64_0
ENV BOOST_INCLUDEDIR=$BOOST_ROOT/include
ENV BOOST_LIBRARYDIR=$BOOST_ROOT/lib
ENV LD_LIBRARY_PATH=$BOOST_LIBRARYDIR:$LD_LIBRARY_PATH

RUN apt-get update && \
    apt-get install -y wget gdebi-core git build-essential libtool autotools-dev automake pkg-config libssl-dev \
                       libevent-dev bsdmainutils python3 libminiupnpc-dev libzmq3-dev ca-certificates curl

# -------- Install Boost 1.64.0 from source --------
WORKDIR /tmp
RUN wget https://archives.boost.io/release/1.64.0/source/boost_1_64_0.tar.gz && \
    tar -xf boost_1_64_0.tar.gz && \
    cd boost_1_64_0 && \
    ./bootstrap.sh --prefix=$BOOST_ROOT --with-libraries=system,filesystem,chrono,program_options,test,thread && \
    ./b2 install link=shared,static threading=multi runtime-link=shared cxxflags="-fPIC -pthread" \
         --prefix=$BOOST_ROOT --with-system --with-filesystem --with-chrono --with-program_options --with-test --with-thread && \
    cd / && rm -rf /tmp/boost_1_64_0*

# -------- Install BerkeleyDB 4.8 packages --------
WORKDIR /tmp
RUN wget https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/db4.8-doc_4.8.30-cosmic4_all.deb && \
    wget https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/db4.8-util_4.8.30-cosmic4_amd64.deb && \
    wget https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/libdb4.8++-dev_4.8.30-cosmic4_amd64.deb && \
    wget https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/libdb4.8++_4.8.30-cosmic4_amd64.deb && \
    wget https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/libdb4.8-dbg_4.8.30-cosmic4_amd64.deb && \
    wget https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/libdb4.8-dev_4.8.30-cosmic4_amd64.deb && \
    wget https://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/libdb4.8-tcl_4.8.30-cosmic4_amd64.deb && \
    wget htts://launchpad.net/~bitcoin/+archive/ubuntu/bitcoin/+build/15598385/+files/libdb4.8_4.8.30-cosmic4_amd64.deb && \
    apt-get install -y ./*.deb && \
    rm -f *.deb

# -------- Clone and Build bitcoinfibre --------
WORKDIR /
RUN git clone https://github.com/bitcoinfibre/bitcoinfibre.git
WORKDIR /bitcoinfibre
RUN ./autogen.sh && ./configure --with-boost=$BOOST_ROOT && make -j"$(nproc)"

# -------- Set default entrypoint --------
ENTRYPOINT ["/bin/bash"]

