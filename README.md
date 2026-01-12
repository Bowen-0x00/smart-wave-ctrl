# SV Smart Wave

[中文版本 (Chinese Version)](README_zh.md)

A lightweight, plug-and-play SystemVerilog module for precise FSDB waveform control.

## Features
- **Effortless Makefile Integration**: Control complex waveform dumping using simple `make` parameters.
- **Precision Time Windows**: Start and stop dumping at specific simulation times with `START` and `END`.
- **Performance Optimized**: Control hierarchy depth with `DEPTH` to prevent massive FSDB files.
- **Zero-Overhead**: Uses standard SystemVerilog `plusargs`, requiring no PLI/VPI C code.

## File Structure
- `src/smart_wave_ctrl.sv`: Core waveform control module.
- `tb/`: Testbench files including top-level and dummy DUT.
- `cfg/wave_list.f`: Example configuration for signal list dumping.
- `Makefile`: Script for VCS compilation and simulation automation.

## Integration
1. Add `src/smart_wave_ctrl.sv` to your project filelist.
2. Instantiate `smart_wave_ctrl` in your testbench top module.

```systemverilog
module tb_top;
    // ...
    smart_wave_ctrl u_wave_ctrl();
    // ...
endmodule
```

## Usage

### 1. Basic Simulation
Run the simulation with default dumping (Depth 1, IOs and top-level signals only).
```bash
make sim
```
![Basic Simulation](images/sim.png)
> [!NOTE]
> This command translates to: `./simv +fsdb_on +dump_depth=1`.

### 2. Time Window Control
Specify a surgical time window for the waveform dump.
```bash
make sim START=100 END=200
```
![Time Window Simulation](images/sim_list_100_200.png)
> [!TIP]
> This uses `+dump_start` and `+dump_end` simulation arguments internally.

### 3. Full Hierarchy Dump
Record all hierarchical signals in the design. **Use with caution** as this can produce very large files.
```bash
make sim_all
```
![Full Hierarchy Simulation](images/sim_all.png)
> [!NOTE]
> This runs with `+dump_view=all +dump_depth=0`.

### 4. Signal List Dump
Use an external configuration file `cfg/wave_list.f` to define specific scopes.
```bash
make sim_list
```
![List-based Simulation](images/sim_list.png)
> [!NOTE]
> This uses `+dump_view=list +dump_list=cfg/wave_list.f`.

## Quick Start Summary
```bash
make compile      # Compile with VCS
make sim          # Run default sim
make sim_all      # Run full hierarchy dump
make verdi        # Open waveform with Verdi
```

## License
MIT or Apache-2.0
