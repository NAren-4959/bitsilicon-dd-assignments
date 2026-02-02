MODULE=stopwatch_top
RTL_DIR=../rtl

.PHONY: all clean

all:
	verilator -Wall --cc --exe --build main.cpp \
	$(RTL_DIR)/$(MODULE).v \
	$(RTL_DIR)/control_fsm.v \
	$(RTL_DIR)/seconds_counter.v \
	$(RTL_DIR)/minutes_counter.v \
	-I$(RTL_DIR) \
	--top-module $(MODULE)

clean:
	rm -rf obj_dir