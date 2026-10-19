# cpu8

An 8-bit CPU in Verilog, built up from a single register to a working computer.
Simulated with Icarus Verilog, waveforms viewed in GTKWave.

## Setup

```bash
sudo dnf install iverilog gtkwave
```

## Layout

- `rtl/` — hardware modules, one per file; the file name matches the module name
- `tb/` — testbenches named `tb_<module>.v`; shared helpers in `tb/test_utils.vh`
- `waves/` — saved GTKWave layouts (`tb_<module>.gtkw`)

## Usage

```bash
make                     # run every testbench, print PASS/FAIL
make sim TB=register8    # run one testbench
make wave TB=register8   # run it and open the waveform
make lint                # compile everything in rtl/ with warnings
make clean
```
