# Parameterized Register

The `register` module is a fully synthesizable, parameterized $N$-bit synchronous storage element implemented in Verilog HDL (IEEE 1364-2001). It features a synchronous active-high reset with priority over a synchronous load enable, allowing deterministic data capture and holding operations across digital clock domains. The design serves as a fundamental building block in pipelined CPU datapaths, control registers, and bus buffering stages across FPGA and ASIC architectures.

## File Header

```text
// File name   : register.v
// Title       : Parameterized Register
// Project     : Verilog Works
// Created     : 2026-10-07
// Description : Synthesizable N-bit synchronous register with active-high synchronous reset and load enable
```

## Overview

In digital systems, pipeline registers and intermediate storage elements must guarantee predictable data retention and synchronous state transitions. This module implements an $N$-bit storage register parameterized by bit width (defaulting to 8 bits).

The architecture incorporates two control lines evaluated on the positive edge of the system clock: an active-high synchronous reset (`rst`) and an active-high synchronous load enable (`load`). Synchronous reset ensures clean timing analysis and avoids metastable hazards inherent in asynchronous resets when integrated into high-speed synchronous FPGA and ASIC fabrics.

### Digital Design Principles Utilized

- **Synchronous Datapath Design**: All state updates occur strictly on the positive edge of `clk`.
- **Priority-Driven Control Multiplexing**: Synchronous clear takes precedence over data loading to maintain predictable system recovery.
- **Hardware Parameterization**: Configurable bus width (`WIDTH`) supports diverse datapath widths without source code modification.
- **Dedicated Macro Inference**: Clean behavioral coding enables logic synthesizers to infer hardware flip-flops (`FDRE`) with integrated clock enable and synchronous reset.

---

## Features

- **Verilog-2001 Synthesizable RTL**: Clean, portable register-transfer level code adhering to IEEE 1364-2001 standards.
- **Parameterized Data Width**: Scalable `WIDTH` parameter (defaults to `8`).
- **Synchronous Active-High Reset**: Prioritized synchronous clear overriding load assertions.
- **Synchronous Load Enable**: Gated state latching; retains current output state when deasserted.
- **Zero Latch Inference**: Explicitly specified branches guarantee complete sequential flip-flop inference without combinational latches.
- **Self-Checking Testbench**: Automated testbench with procedural verification tasks and cycle-accurate mismatch reporting.

---

## Architecture

The module samples the parallel data input `data_in` on the rising edge of `clk` when `load` is asserted. The synchronous reset `rst` acts as a high-priority clear that forces all output bits to logic zero on the next active clock edge, irrespective of the `load` input.

```text
                     ┌───────────────────────────────────┐
                     │             register              │
                     │          (WIDTH-bit Reg)          │
                     │                                   │
      data_in[W-1:0] ═══════════════════════════════════════► data_out[W-1:0]
                     │                                   │
         clk ────────┼─► [C]                             │
         rst ────────┼─► [R] Synchronous Priority Clear  │
        load ────────┼─► [CE] Clock Enable Gating        │
                     │                                   │
                     └───────────────────────────────────┘
```

### Datapath & Control Flow

1. **Inputs**: `clk`, `rst`, `load`, and `data_in[WIDTH-1:0]` enter the module boundary.
2. **Control & Decoding**: On each rising edge of `clk`, the synchronous control multiplexer evaluates `rst`. If `rst == 1'b1`, the datapath clears. If `rst == 1'b0` and `load == 1'b1`, `data_in` is gated into the storage elements.
3. **Storage**: Internal state is preserved within $N$ flip-flops.
4. **Outputs**: Output `data_out[WIDTH-1:0]` directly reflects the registered value.

---

## Module Hierarchy

| Module Name | Type | Purpose | Source File |
|-------------|------|---------|-------------|
| `register` | Top / DUT | Synthesizable parameterized register RTL | [`register.v`](register.v) |
| `register_test` | Testbench | Verification harness and self-checking stimulus | [`register_test.v`](register_test.v) |

---

## Interface (Ports & Parameters)

### Parameters

| Parameter | Type | Default Value | Description |
|-----------|------|---------------|-------------|
| `WIDTH` | `integer` | `8` | Bit width of data input (`data_in`) and output (`data_out`) buses |

### Port List

| Port | Direction | Width | Type | Polarity / Trigger | Description |
|------|-----------|-------|------|--------------------|-------------|
| `clk` | Input | `1` | `wire` | Positive Edge | System clock |
| `rst` | Input | `1` | `wire` | Active-High | Synchronous reset (overrides `load`) |
| `load` | Input | `1` | `wire` | Active-High | Synchronous load enable |
| `data_in` | Input | `WIDTH` | `wire` | Level | Parallel data input bus |
| `data_out` | Output | `WIDTH` | `reg` | Clocked (`clk`) | Registered parallel data output bus |

---

## RTL Implementation Details

### Sequential vs. Combinational Separation

The design uses a single sequential `always @(posedge clk)` block. There is no unclocked combinational feedback:

```verilog
always @(posedge clk) begin
    if (rst)
        data_out <= 0;
    else if (load)
        data_out <= data_in;
    else 
        data_out <= data_out; 
end
```

### Assignment Discipline

- Non-blocking assignments (`<=`) are used exclusively inside the sequential `always` block to prevent simulation-synthesis mismatches and eliminate race conditions.

### Defensive Coding & Latch Prevention

- The priority logic is fully specified across all branches (`rst`, `load`, and `else`).
- Explicit assignment `data_out <= data_out` in the `else` branch documents the hold condition and guarantees the synthesizer does not infer unintended latches.

---

## Verification

The verification environment is implemented in [`register_test.v`](register_test.v) as a self-checking testbench.

### Clock & Reset Generation

- **Clock Period**: 10 ns (50 MHz equivalent toggle rate):
  ```verilog
  initial repeat (5) begin #5 clk = 1; #5 clk = 0; end
  ```
- **Sampling Discipline**: Inputs are driven and outputs are verified on `@(negedge clk)` to avoid setup/hold race conditions with the DUT's active rising edge.

### Stimulus Applied

1. **Pattern 1**: `rst = 0`, `load = 1`, `data_in = 8'h55` &rarr; verifies alternating bit pattern `01010101`.
2. **Pattern 2**: `rst = 0`, `load = 1`, `data_in = 8'hAA` &rarr; verifies inverted pattern `10101010`.
3. **Pattern 3**: `rst = 0`, `load = 1`, `data_in = 8'hFF` &rarr; verifies full bus assertion `11111111`.
4. **Reset Override**: `rst = 1`, `load = 1`, `data_in = 8'hFF` &rarr; verifies synchronous clear takes priority over load assertion, driving output to `8'h00`.

### Monitoring & Self-Checking

A procedural `expect` task performs automated checking:

```verilog
task expect;
    input [WIDTH-1:0] exp_out;
    if (data_out !== exp_out) begin
        $display("TEST FAILED");
        $display("At time %0d rst=%b load=%b data_in=%b data_out=%b", $time, rst, load, data_in, data_out);
        $display("data_out should be %b", exp_out);
        $finish;
    end else begin
        $display("At time %0d rst=%b load=%b data_in=%b data_out=%b", $time, rst, load, data_in, data_out);
    end
endtask
```

---

## Simulation Results

### Timing Waveforms

![Simulation Waveform](simulation_waveform.png)

*Figure 1: Behavioral simulation waveform showing clock transitions, data loading at 15 ns, 25 ns, and 35 ns, followed by synchronous reset clearing the output to 00h at 45 ns.*

### Console Verification Logs

![Console Output](simulation_console_log.png)

*Figure 2: Simulator console output demonstrating zero-error automated testbench completion with all assertions verified.*

---

## Schematics

### Elaborated RTL Schematic

![Elaborated Schematic](elaborated_schematic.png)

*Figure 3: AMD Vivado elaborated design schematic showing the inferred `RTL_REG_SYNC` primitive with clock, reset, and load control lines.*

### Synthesized Gate-Level Design

![Synthesized Design](synthesized_schematic.png)

*Figure 4: Post-synthesis technology schematic targeting FPGA fabric, demonstrating direct mapping to 8 parallel `FDRE` flip-flop primitives with dedicated `CE` and `R` pins.*

---

## How to Run Simulation

### Using Icarus Verilog (iverilog)

```bash
# Compile design and testbench
iverilog -g2001 -o register_sim.out register.v register_test.v

# Execute simulation
vvp register_sim.out
```

### Using AMD Vivado (xsim batch mode)

```bash
# Analyze Verilog sources
xvlog register.v register_test.v

# Elaborate testbench snapshot
xelab register_test -s register_snapshot

# Run simulation to completion
xsim register_snapshot -R
```

---

## Technologies

- **Hardware Description Language**: Verilog HDL (IEEE 1364-2001)
- **RTL Synthesis & Static Timing Analysis**: AMD Vivado Design Suite
- **Logic Simulator**: AMD Vivado Simulator (XSim) / Icarus Verilog
- **Target Technology**: FPGA / ASIC-oriented synchronous primitives (`FDRE`)

---

## Contributing

Contributions focusing on parameterization, testbench automation, formal assertions, or FPGA implementation are welcome:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes
4. Verify simulation passes with 0 errors
5. Submit a Pull Request

---

&copy; Chethan Aithal. All rights reserved.

## Author

**Chethan Aithal**
