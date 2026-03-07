# Pipelined RISC-V Core

A 5-stage pipelined RV32I core , targeting the Tang Nano 20K FPGA.

## Project Goals

1. ~~Build a working single-cycle RV32I core~~
2. ~~Add 5-stage pipeline~~
3. Integrate with SoC

## Current Status

**Phase 2 - Pipelined Core** ✓

![Pipeline Diagram](docs/Pipelined_riscv.png)

## Project Structure

```shell
rtl/        - Verilog source files
test/       - Cocotb tests
docs/       - Documentation and diagrams
```

## Architecture

**Pipeline Stages:** IF → ID → EX → MEM → WB

**Hazard Handling:**

- Data hazards: forwarding from EX/MEM stages
- Load-use hazards: stall
- Control hazards: flush on branch/jump

## Target Hardware

Tang Nano 20K (Gowin GW2AR-18)

## Running Tests

See [test.md](test/test.md) for instructions.
