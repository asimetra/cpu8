# 8-bit CPU — Icarus Verilog build
#
#   make                 run every testbench in tb/ and report PASS/FAIL
#   make sim TB=register8   run one testbench (prints its $display output)
#   make wave TB=register8  run it, then open the waveform in GTKWave
#   make lint            elaborate everything in rtl/ with all warnings
#   make clean

IVERILOG ?= iverilog
VVP      ?= vvp
GTKWAVE  ?= gtkwave

# -y rtl: a testbench pulls in only the modules it uses, found by file name
IVFLAGS := -g2012 -Wall -Wno-timescale -Irtl -Itb -yrtl

BUILD   := build
TBS     := $(patsubst tb/%.v,%,$(wildcard tb/tb_*.v))
SOURCES := $(wildcard rtl/*.v rtl/*.vh tb/*.vh)

# TB=register8 and TB=tb_register8 both work
T := tb_$(patsubst tb_%,%,$(TB))

.PHONY: all test sim wave lint clean check-tb
.SECONDARY:

all: test

$(BUILD):
	@mkdir -p $@

$(BUILD)/%.vvp: tb/%.v $(SOURCES) | $(BUILD)
	$(IVERILOG) $(IVFLAGS) -s $* -o $@ $<

test: $(addprefix $(BUILD)/,$(addsuffix .vvp,$(TBS)))
	@if [ -z "$(TBS)" ]; then echo "no tb_*.v in tb/"; exit 0; fi; \
	pass=0; fail=0; \
	for t in $(TBS); do \
	  if (cd $(BUILD) && $(VVP) -n $$t.vvp > $$t.log 2>&1) \
	     && ! grep -q '^ERROR' $(BUILD)/$$t.log; then \
	    echo "  PASS  $$t"; pass=$$((pass+1)); \
	  else \
	    echo "  FAIL  $$t   -> $(BUILD)/$$t.log"; fail=$$((fail+1)); \
	  fi; \
	done; \
	echo "$$pass passed, $$fail failed"; [ $$fail -eq 0 ]

check-tb:
	@if [ -z "$(TB)" ]; then echo "usage: make $(MAKECMDGOALS) TB=<module>"; exit 1; fi
	@if [ ! -f tb/$(T).v ]; then echo "tb/$(T).v not found"; exit 1; fi

sim: check-tb $(BUILD)/$(T).vvp
	cd $(BUILD) && $(VVP) -n $(T).vvp

# A layout saved from GTKWave as waves/<tb>.gtkw is reopened with the dump
wave: sim
	$(GTKWAVE) $(BUILD)/$(T).vcd $(wildcard waves/$(T).gtkw) &

lint:
	@if [ -z "$(wildcard rtl/*.v)" ]; then echo "no .v files in rtl/"; exit 0; fi; \
	$(IVERILOG) $(IVFLAGS) -o /dev/null $(wildcard rtl/*.v)

clean:
	rm -rf $(BUILD)
