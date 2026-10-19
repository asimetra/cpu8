IVFLAGS = -g2012 -Wall -I rtl -y rtl

sim:
	mkdir -p build
	iverilog $(IVFLAGS) -o build/tb_$(TB).vvp tb/tb_$(TB).v
	cd build && vvp tb_$(TB).vvp

wave: sim
	gtkwave build/tb_$(TB).vcd

clean:
	rm -rf build
