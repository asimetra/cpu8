IVFLAGS = -g2012 -Wall -I rtl -y rtl

sim:
	mkdir -p build
	iverilog $(IVFLAGS) tb/tb_$(TB).v -o build/tb_$(TB).vvp 
	cd build && vvp tb_$(TB).vvp

wave: sim
	gtkwave build/tb_$(TB).vcd

clean:
	rm -rf build
