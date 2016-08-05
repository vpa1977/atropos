#!/bin/bash
# This script installs all the software in the ../software
# directory into the ../bin directory. It also installs
# Atropos from pypi.
# Prerequisites:
# 1. python 3.3+ (we recommend Anaconda)
# 2. cython 0.24+ ('conda install cython' or 'pip install cython')
# 3. modern C++ compiler (we use homebrew/linuxbrew to install gcc 5.1)
# 4. To install SeqPurge, you need
# * Qt 5.3+ with xmlpatterns and mysql packages
# * git
# * cmake

root=`pwd`
mkdir ../software/build
automake_dir=/usr/local/Cellar/automake/1.15/share/automake-1.15

# Install modified ART
mkdir ../software/build/art &&
    cd ../software/build/art &&
    cp ../../art_illumina_src151.tar.gz . &&
    tar -xzf art_illumina_src151.tar.gz &&
    cp ../../art_illumina_src151-adapter-enabled.tar.gz . &&
    tar -xzf art_illumina_src151-adapter-enabled.tar.gz &&
    cd art_illumina_dir &&
    for f in config.sub config.guess install-sh depcomp missing INSTALL
    do
    rm $f
    ln -s $automake_dir/$f .
    done &&
    ./configure --prefix $root &&
    make &&
    make install &&
    cd ../../../scripts

# Install version of Atropos on which manuscript is based
pip install atropos==1.0

# Install Skewer
mkdir ../software/build/skewer &&
    cd ../software/build/skewer &&
    cp ../../skewer_2016.08.04.zip . &&
    unzip skewer_2016.08.04.zip &&
    cd skewer-master &&
    sed -i -e 's/\/usr\/local\/bin/..\/..\/..\/bin/' Makefile &&
    make &&
    make install

# Install SeqPurge
mkdir ../software/build/seqpurge &&
    cd ../software/build/seqpurge &&
    cp ../../ngs-bits_2016.08.04.zip . &&
    unzip ngs-bits_2016.08.04.zip &&
    cd ngs-bits &&
    make build_3rdparty &&
    make build_tools_release