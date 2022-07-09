INCS	:= -I. -I./server_api/ -I../difftest_pb -I/usr/local/include -L/usr/local/lib -lprotobuf
FLAGS	:= -Wall -Og -g
CFLAGS  :=  $(FLAGS)

main: ./build/main.o ./build/machine.o ./build/memory.o ./build/registers.o ./build/isa.o ./build/alu.o ./build/mmio.o ./build/server_api.o ./build/difftest.pb.o
	g++ $^ $(INCS) $(CFLAGS) -o $@

./build/%.o:%.cpp
	g++ $(INCS) $(CFLAGS) -c $^ -o $@

./build/%.o:./server_api/%.cpp
	g++ $(INCS) $(CFLAGS) -c $^ -o $@

./build/%.o:../difftest_pb/%.cc
	g++ $(INCS) $(CFLAGS) -c $^ -o $@

trace-firmware:
	 ./main -e ../firmware/firmware.elf -t "trace"

test-firmware:
	./main -e ../firmware/firmware.elf -t ""

test-R-type:
	./main -e ../testcase/R_type/R_type.elf -t ""
test-I-type:
	./main -e ../testcase/I_type/I_type.elf -t ""
test-S-type: 
	./main -e ../testcase/S_type/S_type.elf -t ""
test-U-type:
	./main -e ../testcase/U_type/U_type.elf -t ""
test-B-type:
	./main -e ../testcase/B_type/B_type.elf -t ""
test-J-type:
	./main -e ../testcase/J_type/J_type.elf -t ""

gdb:
	cat settings.gdb
	gdb -q main -x settings.gdb
clean:
	rm -f main trace build/*

.PHONY:clean test-R-type test-I-type test-S-type test-U-type test-B-type test-J-type gdb