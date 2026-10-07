# Verilog Works

> A collection of synthesizable Verilog HDL and RTL design projects exploring digital logic design, sequential datapaths, finite state machines, memory architectures, arithmetic units, and hardware verification.

## About

This repository serves as an RTL design and digital electronics portfolio. Each project is implemented in synthesizable Verilog HDL, accompanied by targeted testbenches, behavioral simulation waveforms, elaborated RTL schematics, and technology-mapped synthesis results.

All designs adhere to standard RTL design practices, including clean synchronous clocking, explicit reset methodologies, parameterization, and self-checking simulation verification.

---

## Projects Directory

### RTL Fundamentals

| Project | Description | Key Concepts | Implementation & Verification |
|---------|-------------|--------------|-------------------------------|
| [Parameterized Register](./Parameterized_Register/) | Parameterized $N$-bit synchronous storage register with prioritized synchronous reset and load enable | Parameterization, Sequential Logic, Priority Decoding, Clock Gating Enable | Elaborated, Synthesized (FDRE), Verified (XSim) |

---

## Repository Structure

```text
Verilog_works/
├── README.md                          # Repository portfolio landing page
└── Parameterized_Register/            # Parameterized N-bit synchronous register
    ├── README.md                      # Detailed project documentation
    ├── register.v                     # Synthesizable RTL design
    ├── register_test.v                # Self-checking testbench
    ├── elaborated_schematic.png       # RTL elaborated schematic
    ├── synthesized_schematic.png      # Post-synthesis gate-level schematic
    ├── simulation_waveform.png        # Functional simulation waveform
    └── simulation_console_log.png     # Testbench verification log
```

---

## Design & Verification Flow

1. **RTL Modeling**: Written in Verilog HDL (IEEE 1364-2001) targeting synthesizable synchronous architectures.
2. **Behavioral Simulation**: Verified using testbenches with self-checking assertions and automated reporting.
3. **RTL Elaboration & Synthesis**: Synthesized using AMD/Xilinx Vivado to verify technology mapping, resource utilization, and primitive inference (e.g., `FDRE`, `LUT`).

---

## Tools & Technologies

- **Hardware Description Language**: Verilog HDL
- **EDA & Synthesis Suite**: AMD/Xilinx Vivado Design Suite
- **Logic Simulator**: Vivado Simulator (XSim)
- **Target Logic**: FPGA / ASIC synthesizable RTL architectures