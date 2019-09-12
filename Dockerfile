FROM ubuntu:16.04

LABEL authors="CBICA_UPenn <software@cbica.upenn.edu>"

# update
RUN apt-get update  

#general dependencies
RUN add-apt-repository -y ppa:no1wantdthisname/ppa; \
    apt-get install -y \
    build-essential \
    mesa-utils \
    freeglut3-dev \
    wget \
    unzip \
    doxygen \
    -qq \
    gcc-5 \
    g++-5 \
    make \
    libgl-dev \
    python3-pip \
    python-numpy \
    dos2unix \
    libxkbcommon-x11-0 \
    libnss3 \
    libxcomposite-dev \
    libxcursor-dev \
    libxrender-dev \
    libxtst-dev \
    libasound2 \
    libdbus-1-dev \
    libegl-mesa0 \
    libglib2.0-dev \
    libxext6 \
    libfreetype6 \
    aptitude \
    nodejs \
    npm; \
    aptitude install libxft-dev; \
    if [ ! -d "`pwd`/cmake-3.12.4-Linux-x86_64" ] ; then wget https://cmake.org/files/v3.12/cmake-3.12.4-Linux-x86_64.tar.gz && tar -xf cmake-3.12.4-Linux-x86_64.tar.gz && rm -rf cmake-3.12.4-Linux-x86_64.tar.gz; fi \
    export PATH=`pwd`/cmake-3.12.4-Linux-x86_64/bin:$PATH; \
    export GIT_LFS_SKIP_SMUDGE=1; \
    apt-get update && \
    apt-get install -y sudo curl git && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    sudo apt-get install git-lfs; \
    git lfs install; \
    if [ ! -d "`pwd`/CaPTk" ] ; then git clone "https://github.com/CBICA/CaPTk.git"; fi \
    cd CaPTk; \
    rm -rf *.bin; \
    git submodule init; \
    git submodule update; \
    echo "=== Starting CaPTk Superbuild ===" && \
    mkdir bin && cd bin && \
    if [ ! -d "`pwd`/externalApps" ] ; then wget https://github.com/CBICA/CaPTk/raw/master/binaries/precompiledApps/linux.zip -O binaries_linux.zip; fi \
    if [ ! -d "`pwd`/qt" ] ; then wget https://github.com/CBICA/CaPTk/raw/master/binaries/qt_5.12.1/linux.zip -O qt.zip; fi \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./install_libs -Wno-dev .. && \
    make && \
    rm -rf qt.zip && \
    echo "=== Building CaPTk ===" && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./install/appdir/usr/bin -Wno-dev .. && \
    make install/strip -j2; \
    cd .. && export PKG_FAST_MODE=1 && export PKG_COPY_QT_LIBS=1; \
    ./scripts/captk-pkg

# define entry point
ENTRYPOINT ["/CaPTk/bin/install/appdir/usr/bin/CaPTk"]
