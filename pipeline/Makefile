
all: sim_verilator
TOP_MODULE=cpu
gtk:
	gtkwave.exe waveform.vcd > /dev/null &


# verilator option
# WARE_IGNORE = --Wno-width --Wno-stmtdly --Wno-initialdly --Wno-combdly --Wno-unoptflat --Wno-pinmissing
WARE_IGNORE = --Wno-width --Wno-unpacked
VERILATOR_OPTIONS = --top-module cpu -sv --trace-structs --trace-params --cc --trace $(WARE_IGNORE) $(RTL_SRC) -y ./src 
CXX	:= g++
CPP_SRC := ./tb/sim_main.cpp
RTL_SRC =$(wildcard ./include/*.sv) $(wildcard ./src/*.sv) 
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e " s/^.*=\s*//"')
VROOT   := $(VERILATOR_ROOT)
INCS	:= -I./obj_dir/ -I$(VROOT)/include -I./tb -I./tb/client_api -I../difftest_pb -I/usr/local/include -L/usr/local/lib -lprotobuf
FLAGS	:= -Wall -Og -g -DROOT_VERILATOR
CFLAGS  :=  $(FLAGS)
# Compile RTL
compile_verilator : 
	verilator $(VERILATOR_OPTIONS)

obj_dir:  $(RTL_SRC)
	make compile_verilator --no-print-directory

obj_dir/Vcpu__ALL.a: obj_dir/Vcpu.mk obj_dir
	make -C obj_dir -f Vcpu.mk Vcpu__ALL.a
obj_dir/verilated.o: obj_dir/Vcpu.mk | obj_dir
	@if [ ! -d obj_dir ] ; then \
	  make compile_verilator --no-print-directory; \
	fi
	make -C obj_dir -f Vcpu.mk verilated.o
obj_dir/verilated_vcd_c.o: obj_dir/Vcpu.mk | obj_dir
	@if [ ! -d obj_dir ] ; then \
	  make compile_verilator --no-print-directory; \
	fi
	make -C obj_dir -f Vcpu.mk verilated_vcd_c.o

sim_main:
	make sim_verilator --no-print-directory

sim_verilator : obj_dir/sim_main.o obj_dir/difftest.pb.o obj_dir/client_api.o obj_dir/Vcpu__ALL.a obj_dir/verilated.o obj_dir/verilated_vcd_c.o
	g++ -std=c++11 $^ $(CFLAGS) $(INCS) -o ./sim_main

# obj_dir/sim_main.o: ./tb/sim_main.cpp
obj_dir/%.o: ./tb/%.cpp | obj_dir
	$(CXX) $(CFLAGS) $(INCS) -c $< -o $@

obj_dir/%.o: ./tb/client_api/%.cpp | obj_dir
	$(CXX) $(CFLAGS) $(INCS) -c $< -o $@

obj_dir/%.o: ../difftest_pb/%.cc | obj_dir
	$(CXX) $(CFLAGS) $(INCS) -c $< -o $@

# ---- Clean ----

clean:
	rm -f *.vcd
	rm -rf obj_dir
.PHONY: rtlsim run all
