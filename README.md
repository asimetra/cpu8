# cpu8

An 8-bit CPU in Verilog, built up from a single register to a working computer.
Simulated with Icarus Verilog, waveforms viewed in GTKWave.

## Setup

```bash
sudo dnf install iverilog gtkwave
```

## Layout

- `rtl/` — hardware modules, one per file; the file name matches the module name
- `tb/` — testbenches, named `tb_<module>.v`

## Usage

```bash
make sim TB=register8    # compile and run tb/tb_register8.v
make wave TB=register8   # same, then open the waveform in GTKWave
make clean
```
