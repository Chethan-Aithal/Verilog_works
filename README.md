# Verilog Works

> A collection of synthesizable Verilog HDL and RTL design projects exploring digital logic design, sequential datapaths, finite state machines, memory architectures, arithmetic units, and hardware verification.

## About

This repository serves as an RTL design and digital electronics portfolio. Each project is implemented in synthesizable Verilog HDL, accompanied by targeted testbenches, behavioral simulation waveforms, elaborated RTL schematics, and technology-mapped synthesis results.

All designs adhere to standard RTL design practices, including clean synchronous clocking, explicit reset methodologies, parameterization, and self-checking simulation verification.

---

## Projects Directory

### RTL Fundamentals & Datapath Routing

| Project | Description | Key Concepts | Implementation & Verification |
|---------|-------------|--------------|-------------------------------|
| [Parameterized Register](./Parameterized_Register/) | Parameterized $N$-bit synchronous storage register with prioritized synchronous reset and load enable | Parameterization, Sequential Logic, Priority Decoding, Clock Gating Enable | Elaborated, Synthesized (FDRE), Verified (XSim) |
| [Parameterized 2-to-1 Multiplexer](./Parameterized_2to1_Multiplexer/) | Parameterized $N$-bit combinational 2-to-1 bus multiplexer with zero-latch decoding | Parameterization, Combinational Logic, Bus Steering, LUT3 Mapping | Elaborated, Synthesized (LUT3), Verified (XSim) |

### Timers & Sequential Datapaths

| Project | Description | Key Concepts | Implementation & Verification |
|---------|-------------|--------------|-------------------------------|
| [Digital Stopwatch](./Digital_Stopwatch/) | Precision digital stopwatch with 32-bit parameterized integer frequency prescaler, start/stop hold logic, and 6-bit modulo-60 seconds counter | Clock Prescaling, Modulo-60 Counter, Run/Hold State Gating, Priority Control | Elaborated, Verified (XSim) |

### FSM & Control Design

| Project | Description | Key Concepts | Implementation & Verification |
|---------|-------------|--------------|-------------------------------|
| [Parameterized Traffic Light Controller](./Traffic_Light_Controller/) | Parameterized 3-state Moore Finite State Machine managing intersection signals with custom cycle duration timers | Moore FSM, State Transition Logic, Parameterized Counters, Glitch-Free Outputs | Elaborated, Synthesized (FDRE/LUT), Verified (XSim) |

### Serial Communication & Interfaces

| Project | Description | Key Concepts | Implementation & Verification |
|---------|-------------|--------------|-------------------------------|
| [UART Full-Duplex Transceiver](./UART_Transceiver/) | Parameterized 8-N-1 UART transmitter and receiver subsystem with midpoint oversampling and loopback self-checking | Asynchronous Serialization, Midpoint Bit Sampling, 8-N-1 Protocol, FSM Handshaking | Elaborated, Verified (XSim) |

### Arithmetic & Datapath Units

| Project | Description | Key Concepts | Implementation & Verification |
|---------|-------------|--------------|-------------------------------|
| [Parameterized ALU](./Parameterized_ALU/) | Parameterized $N$-bit multi-operation Arithmetic Logic Unit with zero-condition detection flag | Arithmetic Addition, Bitwise Logic (AND/XOR), Zero Flag, CARRY4 & LUT6 Mapping | Elaborated, Synthesized (CARRY4/LUT6), Verified (XSim) |
| [4-Bit Combinational ALU](./ALU_4Bit/) | 4-bit combinational Arithmetic Logic Unit executing addition, subtraction, AND, and OR with wrap-around verification | Combinational Logic, Case Decoding, Modulo-$2^4$ Arithmetic, LUT Mapping | Elaborated, Synthesized (LUT), Verified (XSim) |
| [2x2 Matrix Multiplier (Shared Datapath)](./Matrix_Multiplier_2x2/) | Area-optimized $2 \times 2$ matrix multiplier utilizing a time-multiplexed shared hardware multiplier across 8 calculation cycles | Resource-Sharing Multiplier, Time-Multiplexed DSP, 17-Bit Accumulation, Handshaking | Elaborated, Verified (XSim) |

---

## Repository Structure

```text
Verilog_works/
├── README.md                              # Repository portfolio landing page
├── Parameterized_Register/                # Parameterized N-bit synchronous register
│   ├── README.md                          # Detailed project documentation
│   ├── register.v                         # Synthesizable RTL design
│   ├── register_test.v                    # Self-checking testbench
│   ├── elaborated_schematic.png           # RTL elaborated schematic
│   ├── synthesized_schematic.png          # Post-synthesis gate-level schematic (FDRE)
│   ├── simulation_waveform.png            # Functional simulation waveform
│   └── simulation_console_log.png         # Testbench verification log
├── Parameterized_2to1_Multiplexer/        # Parameterized 2-to-1 bus multiplexer
│   ├── README.md                          # Detailed project documentation
│   ├── multiplexor.v                      # Synthesizable RTL design
│   ├── multiplexor_test.v                 # Self-checking testbench
│   ├── elaborated_schematic.png           # RTL elaborated schematic
│   ├── synthesized_schematic.png          # Post-synthesis gate-level schematic (LUT3)
│   ├── simulation_waveform.png            # Functional simulation waveform
│   └── simulation_console_log.png         # Testbench verification log
├── Digital_Stopwatch/                     # Precision digital stopwatch & prescaler
│   ├── README.md                          # Detailed project documentation
│   ├── digital_stopwatch.v                # Synthesizable RTL design
│   ├── tb_digital_stopwatch.v             # Self-checking testbench
│   ├── elaborated_schematic.png           # RTL elaborated schematic
│   ├── simulation_waveform.png            # Functional simulation waveform
│   └── simulation_console_log.png         # Testbench verification log
├── Traffic_Light_Controller/              # Parameterized 3-state Moore FSM
│   ├── README.md                          # Detailed project documentation
│   ├── traffic_light_controller.v         # Synthesizable RTL design
│   ├── tb_traffic_light_controller.v      # Self-checking testbench
│   ├── elaborated_schematic.png           # RTL elaborated schematic
│   ├── synthesized_schematic.png          # Post-synthesis gate-level schematic
│   ├── simulation_waveform.png            # Functional simulation waveform
│   └── simulation_console_log.png         # Testbench verification log
├── UART_Transceiver/                      # Full-Duplex UART Transmitter & Receiver
│   ├── README.md                          # Detailed project documentation
│   ├── uart_tx.v                          # Synthesizable UART transmitter RTL
│   ├── uart_rx.v                          # Synthesizable UART receiver RTL
│   ├── tb_uart.v                          # Self-checking loopback testbench
│   ├── elaborated_schematic.png           # RTL elaborated schematic
│   ├── simulation_waveform.png            # Functional simulation waveform
│   └── simulation_console_log.png         # Testbench verification log
├── Parameterized_ALU/                     # Parameterized N-bit Arithmetic Logic Unit
│   ├── README.md                          # Detailed project documentation
│   ├── alu.v                              # Synthesizable RTL design
│   ├── alu_test.v                         # Self-checking testbench
│   ├── elaborated_schematic.png           # RTL elaborated schematic
│   ├── synthesized_schematic.png          # Post-synthesis gate-level schematic (CARRY4/LUT6)
│   └── simulation_waveform.png            # Functional simulation waveform
├── ALU_4Bit/                              # 4-bit Combinational Arithmetic Logic Unit
│   ├── README.md                          # Detailed project documentation
│   ├── alu_4bit.v                         # Synthesizable RTL design
│   ├── tb_alu_4bit.v                      # Self-checking testbench
│   ├── elaborated_schematic.png           # RTL elaborated schematic
│   ├── synthesized_schematic.png          # Post-synthesis gate-level schematic
│   ├── simulation_waveform.png            # Functional simulation waveform
│   └── simulation_console_log.png         # Testbench verification log
└── Matrix_Multiplier_2x2/                 # 2x2 Matrix Multiplier (Shared Multiplier)
    ├── README.md                          # Detailed project documentation
    ├── matrix_multiplier_2x2_shared.v     # Synthesizable matrix multiplier RTL
    ├── tb_matrix_multiplier_2x2.v         # Self-checking testbench
    ├── elaborated_schematic.png           # RTL elaborated schematic
    ├── simulation_waveform_overview.png   # Full calculation waveform
    └── simulation_waveform_handshake.png  # Handshake timing detail waveform
```

---

## Design & Verification Flow

1. **RTL Modeling**: Written in Verilog HDL (IEEE 1364-2001) targeting synthesizable synchronous and combinational architectures.
2. **Behavioral Simulation**: Verified using testbenches with self-checking assertions and automated reporting.
3. **RTL Elaboration & Synthesis**: Synthesized using AMD/Xilinx Vivado to verify technology mapping, resource utilization, and primitive inference (e.g., `FDRE`, `LUT3`, `CARRY4`, `LUT6`).

---

## Tools & Technologies

- **Hardware Description Language**: Verilog HDL
- **EDA & Synthesis Suite**: AMD/Xilinx Vivado Design Suite
- **Logic Simulator**: Vivado Simulator (XSim) / Icarus Verilog
- **Target Logic**: FPGA / ASIC synthesizable RTL architectures
