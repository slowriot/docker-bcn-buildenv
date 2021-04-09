FROM debian:buster

RUN apt-get -y update
RUN apt-get -y install wget apt-utils gnupg

# Add LLVM repos and key (for clang-11)
RUN echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-11 main" >> /etc/apt/sources.list
RUN echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-11 main" >> /etc/apt/sources.list
RUN wget --version
RUN wget -O /etc/llvm-snapshot.gpg.key https://apt.llvm.org/llvm-snapshot.gpg.key
RUN apt-key add /etc/llvm-snapshot.gpg.key

RUN apt-get -y update

# BCHN build requirements
RUN apt-get -y install python3 ccache bsdmainutils build-essential libssl-dev libevent-dev cmake libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libdb-dev libdb++-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev python3-zmq

# Fetch ninja >= 1.10 to get the restat tool
RUN apt-get -y install wget unzip
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.0/ninja-linux.zip
RUN unzip ninja-linux.zip
RUN cp ./ninja /usr/local/bin/ninja
RUN cp ./ninja /usr/bin/ninja
RUN ninja --version
RUN ninja -t restat

# Make sure UTF-8 isn't borked
RUN apt-get -y install locales
RUN export LANG=en_US.UTF-8
RUN export LANGUAGE=en_US:en
RUN export LC_ALL=en_US.UTF-8
RUN echo "en_US UTF-8" > /etc/locale.gen
# Add de_DE.UTF-8 for specific JSON number formatting unit tests
RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
# Generate all locales
RUN locale-gen

# Support windows build
RUN apt-get -y install g++-mingw-w64-x86-64 curl automake autoconf libtool pkg-config
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix
RUN update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix

# Support ARM build
RUN apt-get -y install autoconf automake curl g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf gperf pkg-config

# Support AArch64 build
RUN apt-get -y install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu qemu-user-static

# Support OSX build
RUN apt-get -y install python3-setuptools

# Support clang build
RUN apt-get -y install clang-11

# Add tools for static checking & Gitlab CI processing of results
RUN apt-get -y install git python3-dev python3-pip python3-scipy clang-format-11 arcanist xmlstarlet php-codesniffer shellcheck nodejs npm
RUN npm install npm@latest -g
RUN npm install -g markdownlint-cli

# Linter dependencies
RUN pip3 install --no-cache-dir flake8 mypy yamllint

# Clean up cache
RUN apt-get clean
