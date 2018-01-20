#!/bin/bash
set -ex

mkdir -p ~/fpga
cd ~/fpga
git clone https://github.com/cliffordwolf/icestorm.git icestorm
cd icestorm
git checkout 14b44ca866665352e7146778bb932e45b5fdedbd
make -j$(nproc)
make install
make DESTDIR=~/fpga/out install

cd ~/fpga
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
git checkout a32dd2c137b2bb6ba6704b25109790ac76bc2f45
make -j$(nproc)
make install
make DESTDIR=~/fpga/out install

cd ~/fpga
git clone https://github.com/cliffordwolf/yosys.git yosys
cd yosys
git checkout 1f6e8f86c516f37f1d93e91c46fe427f7a646b15
make -j$(nproc)
make install
make DESTDIR=~/fpga/out install

cd ~/fpga
git clone http://git.veripool.org/git/verilator verilator
cd verilator
git checkout verilator_3_916
autoconf
./configure
make
make install
make DESTDIR=~/fpga/out install

cd ~/fpga
git clone https://github.com/steveicarus/iverilog.git iverilog
cd iverilog
git checkout v10_2
autoconf
./configure
make
make install
make DESTDIR=~/fpga/out install