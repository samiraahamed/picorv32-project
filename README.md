# PicoRV32 – Minimal RISC-V Core Project

## Description
A step-by-step simulation of a minimal RISC-V CPU core built using Verilog HDL,
inspired by the PicoRV32 architecture optimized for ASIC/FPGA usage.

## Tech Used
- Verilog HDL
- Icarus Verilog (iverilog)
- JDoodle Online Simulator

## Modules
| File | Description |
|------|-------------|
| registers.v | Basic 32-bit register operations |
| alu.v | Arithmetic Logic Unit (ADD SUB AND OR XOR SHL SHR) |
| program_counter.v | PC increments by 4 each clock cycle |
| instruction_memory.v | Fetch real RISC-V encoded instructions |
| register_file.v | 32 registers x0–x31, x0 hardwired to 0 |
| mini_riscv_cpu.v | Full fetch-decode-execute CPU |
| cpu_execution_flow.v | Clock-driven pipeline simulation |

## Learning Outcomes
- RISC-V basics and ISA fundamentals
- Parameterized RTL design
- CPU execution flow Fetch → Decode → Execute → Writeback

## How to Run
```bash
iverilog -o registers registers.v && vvp registers
iverilog -o alu alu.v && vvp alu
iverilog -o cpu mini_riscv_cpu.v && vvp cpu
iverilog -o flow cpu_execution_flow.v && vvp flow
```

## Reference
- [PicoRV32 GitHub](https://github.com/YosysHQ/picorv32)
