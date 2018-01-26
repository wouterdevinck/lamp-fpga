#!/bin/bash
set -ex

mkdir -p ~/fpga

cd ~/fpga
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
git checkout 479467a50da0bd604a52116dcefbacf36bc601bd
make -j$(nproc)
make install # because chipdb needed by arachne
make DESTDIR=~/fpga/out install

cd ~/fpga
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
git checkout 4b5fee9dbba1abaa5d4743a5b9daa8b58a0e9dcf
make -j$(nproc)
make DESTDIR=~/fpga/out install

cd ~/fpga
git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
git checkout 1d8161b432fd5bc7fc03c21033f90d2a80cf741f
make -j$(nproc)
make DESTDIR=~/fpga/out install

cd ~/fpga
git clone http://git.veripool.org/git/verilator verilator
cd verilator
git checkout verilator_3_916
autoconf
./configure --prefix=`echo ~/fpga/out`
make
make install

cd ~/fpga
git clone https://github.com/steveicarus/iverilog.git iverilog
cd iverilog
git checkout v10_2
autoconf
./configure --prefix=`echo ~/fpga/out`
make
make install