# PicoRV32 – Minimal RISC-V Core Project Report

## 📌 Project Overview
| Field | Details |
|---|---|
| **Project Name** | PicoRV32 – Minimal RISC-V Core |
| **Difficulty** | Intermediate |
| **Estimated Time** | 12–18 Days |
| **Tech Used** | Verilog HDL |
| **Tools** | Icarus Verilog, JDoodle Online Simulator |
| **Reference** | [YosysHQ/picorv32](https://github.com/YosysHQ/picorv32) |

---

## 📖 Description
This project involves analyzing and simulating a compact RISC-V CPU core
optimized for simplicity, inspired by the PicoRV32 architecture used in
ASIC/FPGA designs. The entire CPU was built step by step from scratch using
Verilog HDL, simulated using JDoodle online Verilog simulator.

---

## 🎯 Learning Outcomes
- ✅ RISC-V basics and ISA fundamentals
- ✅ Parameterized RTL design using `parameter` and `$clog2`
- ✅ CPU execution flow — Fetch → Decode → Execute → Writeback

---

## 🏗️ Project Architecture
Program Counter (PC)
↓
Instruction Memory (imem[])
↓
Instruction Decoder (opcode, rd, rs1, rs2, funct3, funct7)
↓
ALU (ADD, SUB, AND, OR, XOR, SHL, SHR)
↓
Register File (x0–x31, x0 hardwired to 0)
↓
Writeback to Register

---

## 📁 Module Descriptions

### 1. `registers.v` — Basic Registers
Demonstrates 32-bit register declaration and arithmetic operations.
```verilog
reg [31:0] x1, x2, x3;
x3 = x1 + x2;
```
**Output:**
x1 = 10
x2 = 20
x3 = x1 + x2 = 30

---

### 2. `alu.v` — Arithmetic Logic Unit
Implements all core ALU operations used in RISC-V.

| Operation | Symbol | Result (a=15, b=10) |
|---|---|---|
| ADD | + | 25 |
| SUB | - | 5 |
| AND | & | 10 |
| OR | \| | 15 |
| XOR | ^ | 5 |
| SHL | << | 30 |
| SHR | >> | 7 |

---

### 3. `program_counter.v` — Program Counter
Shows how PC increments by 4 bytes each clock cycle.

**Output:**
Cycle 1 | 0x00000004 | Instr #1
Cycle 2 | 0x00000008 | Instr #2
Cycle 3 | 0x0000000c | Instr #3

---

### 4. `instruction_memory.v` — Instruction Memory
Stores real RISC-V 32-bit encoded instructions and fetches them using PC.

| PC Address | Hex Instruction | Description |
|---|---|---|
| 0x00000000 | 0x00000013 | NOP |
| 0x00000004 | 0x00500093 | ADDI x1, x0, 5 |
| 0x00000008 | 0x00a00113 | ADDI x2, x0, 10 |
| 0x0000000c | 0x002081b3 | ADD x3, x1, x2 |

---

### 5. `register_file.v` — Register File
Implements all 32 RISC-V registers (x0–x31) with x0 hardwired to zero.

**Key Feature:** Writing 99 to x0 has no effect — it stays 0.
WRITE: x0 = 99  → READ: x0 = 0  ✓ (hardwired zero)
WRITE: x1 = 5   → READ: x1 = 5  ✓
WRITE: x2 = 10  → READ: x2 = 10 ✓

---

### 6. `mini_riscv_cpu.v` — Mini RISC-V CPU
Combines all modules into a working CPU that executes 8 instructions.

**Program Executed:**
ADDI x1, x0, 5     → x1 = 5
ADDI x2, x0, 10    → x2 = 10
ADD  x3, x1, x2    → x3 = 15
ADDI x4, x0, 20    → x4 = 20
SUB  x5, x4, x1    → x5 = 15
ADD  x6, x3, x5    → x6 = 30
ADDI x7, x0, 7     → x7 = 7
ADD  x8, x6, x7    → x8 = 37

---

### 7. `cpu_execution_flow.v` — CPU Execution Flow
Clock-driven pipeline showing each stage per cycle.

**Sample Cycle Output:**
CYCLE 1
[FETCH]   PC=0x00 → Instr=0x00500093
[DECODE]  I-type  | rd=x1 rs1=x0 imm=5
[EXECUTE] x1 = x0 + 5 = 5
[WRITEBK] x1 written ✓

---

## 📊 Final CPU Register State

| Register | Value | Operation |
|---|---|---|
| x0 | 0 | Hardwired zero |
| x1 | 5 | ADDI x0 + 5 |
| x2 | 3 | ADDI x0 + 3 |
| x3 | 7 | ADD x1 + x6 |
| x4 | -3 | SUB x1 - x3 |
| x5 | 0 | Unused |
| x6 | 2 | ADD x1 + x4 |

---

## 🔑 Key Concepts Learned

| Concept | Description |
|---|---|
| `reg [31:0]` | 32-bit register declaration |
| `parameter` | Configurable design values |
| `$clog2()` | Auto bit-width calculation |
| `posedge clk` | Clock-driven execution |
| `task` | Reusable code blocks |
| `case` | Instruction decoder |
| `$signed()` | Signed number display |
| `imm` | Sign-extended immediate |

---

## ✅ Simulation Results Summary

| Module | Status | Key Result |
|---|---|---|
| registers.v | ✅ Pass | x3 = 30 |
| alu.v | ✅ Pass | All 7 ops correct |
| program_counter.v | ✅ Pass | PC+4 each cycle |
| instruction_memory.v | ✅ Pass | All 8 fetches correct |
| register_file.v | ✅ Pass | x0 stays 0 |
| mini_riscv_cpu.v | ✅ Pass | x8 = 37 |
| cpu_execution_flow.v | ✅ Pass | 6 cycles complete |

---


