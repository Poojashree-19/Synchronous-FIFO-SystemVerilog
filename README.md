# Parameterized Synchronous FIFO using SystemVerilog

## Overview

This project implements a **Parameterized Synchronous FIFO (First-In First-Out)** in **SystemVerilog**. The FIFO is designed using a modular RTL architecture with configurable **data width** and **FIFO depth**. Each module was verified individually using dedicated testbenches before integrating the complete FIFO. A self-checking top-level testbench verifies the overall functionality, including overflow and underflow conditions.

---

# Features

- Parameterized Data Width
- Parameterized FIFO Depth
- Modular RTL Design
- Synchronous FIFO Architecture
- Separate Read and Write Pointer Modules
- Full and Empty Flag Generation
- Overflow Protection
- Underflow Protection
- Individual Module Verification
- Self-Checking Top-Level Testbench
- Waveform Generation (VCD)
- SystemVerilog Assertions (SVA)

---

# Project Structure

```
Parameterized_Synchronous_FIFO
│
├── RTL
│   ├── fifo_memory.sv
│   ├── write_pointer.sv
│   ├── read_pointer.sv
│   ├── fifo_control.sv
│   └── fifo_top.sv
│
├── Testbenches
│   ├── fifo_memory_tb.sv
│   ├── write_pointer_tb.sv
│   ├── read_pointer_tb.sv
│   ├── fifo_control_tb.sv
│   └── fifo_top_tb.sv
│
├── Waveforms
│   ├── fifo_memory.vcd
│   ├── write_pointer.vcd
│   ├── read_pointer.vcd
│   ├── fifo_control.vcd
│   └── fifo_top_tb.vcd
│
├── Images
│   ├── fifo_memory_waveform.png
│   ├── write_pointer_waveform.png
│   ├── read_pointer_waveform.png
│   ├── fifo_control_waveform.png
│   └── fifo_top_waveform.png
│
├── fifo_assertions.sv
│
└── README.md
```

---

# Design Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| DATA_WIDTH | Width of each FIFO data word | 8 bits |
| DEPTH | Number of FIFO memory locations | 8 |

---

# RTL Modules

## fifo_memory

- Stores FIFO data.
- Performs synchronous write operations.
- Provides combinational read access.
- Prevents writes when the FIFO is full.

---

## write_pointer

- Maintains the FIFO write address.
- Increments only when:
  - `wr_en = 1`
  - `full = 0`

---

## read_pointer

- Maintains the FIFO read address.
- Increments only when:
  - `rd_en = 1`
  - `empty = 0`

---

## fifo_control

Generates FIFO status signals:

- Full
- Empty

using the read and write pointers.

---

## fifo_top

Top-level module integrating:

- FIFO Memory
- Write Pointer
- Read Pointer
- FIFO Control

---

# FIFO Operation

## Write Operation

A write occurs only when:

- Write Enable (`wr_en`) is HIGH
- FIFO is **not Full**

The incoming data is written into memory and the write pointer increments.

---

## Read Operation

A read occurs only when:

- Read Enable (`rd_en`) is HIGH
- FIFO is **not Empty**

The data is read from memory and the read pointer increments.

---

# Full Condition

The FIFO becomes **Full** when:

- The address bits of the write and read pointers are equal.
- The most significant (wrap) bits are different.

---

# Empty Condition

The FIFO becomes **Empty** when:

- The write pointer equals the read pointer.

---

# Verification

Each RTL module was verified independently using dedicated testbenches before top-level integration.

## Module-Level Verification

- ✅ fifo_memory_tb
- ✅ write_pointer_tb
- ✅ read_pointer_tb
- ✅ fifo_control_tb

---

## Top-Level Verification

The complete FIFO was verified using a **self-checking SystemVerilog testbench**.

### Test Cases Performed

- ✅ Reset Verification
- ✅ Write Operation
- ✅ Read Operation
- ✅ FIFO Order Verification
- ✅ Full Flag Verification
- ✅ Empty Flag Verification
- ✅ Overflow Test
- ✅ Underflow Test

---

# Simulation Results

```
PASS COUNT : 8
FAIL COUNT : 0

ALL TESTS PASSED!
```

---

# Waveforms

Waveforms were generated and verified for:

- fifo_memory
- write_pointer
- read_pointer
- fifo_control
- fifo_top

using **EPWave / GTKWave**.

---

# Sample Waveforms

## FIFO Memory

*(Insert waveform image here)*

## Write Pointer

*(Insert waveform image here)*

## Read Pointer

*(Insert waveform image here)*

## FIFO Control

*(Insert waveform image here)*

## Top-Level FIFO

*(Insert waveform image here)*

---

# Limitations

The current implementation has the following limitations:

- Supports FIFO depths that are **powers of two (2ⁿ)** (e.g., 4, 8, 16, 32, ...).
- Implements a **single-clock synchronous FIFO**.
- Supports one read operation and one write operation per clock cycle.
- Provides **Full** and **Empty** status flags only.
- Does not implement Almost-Full or Almost-Empty flags.
- Uses a **combinational read path** and a **synchronous write path**.

---

# Future Enhancements

- Support arbitrary (non-power-of-two) FIFO depths.
- Implement an Asynchronous FIFO using separate read and write clocks.
- Add Almost-Full and Almost-Empty status flags.
- Develop a constrained-random/UVM-based verification environment.
- Add functional and code coverage.
- Support AXI-Stream interface.

---

# Tools Used

- **Language:** SystemVerilog
- **Simulator:** Icarus Verilog
- **Waveform Viewer:** EPWave / GTKWave
- **Development Platform:** EDA Playground
- **Version Control:** Git & GitHub

---

# Key Learning Outcomes

Through this project, the following concepts were implemented and verified:

- Parameterized RTL Design
- Modular Hardware Design
- FIFO Memory Architecture
- Pointer-Based Addressing
- Full and Empty Flag Generation
- Self-Checking Verification
- Overflow and Underflow Handling
- SystemVerilog Assertions (SVA)
- Waveform Analysis and Debugging

---

# Author

**Poojashree DH**

Electrical Engineering Student  
PES University

GitHub: **https://github.com/Poojashree-19**
