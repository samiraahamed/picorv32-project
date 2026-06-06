module mini_riscv_cpu;

  // ── Memory & Registers ──────────────────────────
  reg [31:0] imem [0:15];   // instruction memory
  reg [31:0] regs [0:31];   // 32 registers
  reg [31:0] pc;            // program counter
  integer    i;

  // ── Instruction fields ──────────────────────────
  reg [31:0] instr;
  reg [6:0]  opcode;
  reg [4:0]  rd, rs1, rs2;
  reg [2:0]  funct3;
  reg [6:0]  funct7;
  reg [31:0] imm;
  reg [31:0] alu_result;

  // ── Load Program into Memory ────────────────────
  task load_program;
    begin
      // ADDI x1, x0, 5    → x1 = 5
      imem[0]  = 32'h00500093;
      // ADDI x2, x0, 10   → x2 = 10
      imem[1]  = 32'h00A00113;
      // ADD  x3, x1, x2   → x3 = x1 + x2
      imem[2]  = 32'h002081B3;
      // ADDI x4, x0, 20   → x4 = 20
      imem[3]  = 32'h01400213;
      // SUB  x5, x4, x1   → x5 = x4 - x1
      imem[4]  = 32'h401202B3;
      // ADD  x6, x3, x5   → x6 = x3 + x5
      imem[5]  = 32'h00518333;
      // ADDI x7, x0, 7    → x7 = 7
      imem[6]  = 32'h00700393;
      // ADD  x8, x6, x7   → x8 = x6 + x7
      imem[7]  = 32'h00730433;
    end
  endtask

  // ── Execute One Instruction ─────────────────────
  task execute;
    begin
      // Fetch
      instr  = imem[pc >> 2];

      // Decode fields
      opcode = instr[6:0];
      rd     = instr[11:7];
      funct3 = instr[14:12];
      rs1    = instr[19:15];
      rs2    = instr[24:20];
      funct7 = instr[31:25];
      imm    = {{20{instr[31]}}, instr[31:20]};

      // Execute
      case (opcode)

        7'b0110011: begin  // R-type: ADD, SUB
          if (funct7 == 7'h00)
            alu_result = regs[rs1] + regs[rs2];   // ADD
          else if (funct7 == 7'h20)
            alu_result = regs[rs1] - regs[rs2];   // SUB
          if (rd != 0) regs[rd] = alu_result;
          $display("PC=0x%02h | R-type  | x%0d = x%0d %s x%0d = %0d",
            pc, rd, rs1,
            (funct7==7'h20) ? "-" : "+",
            rs2, regs[rd]);
        end

        7'b0010011: begin  // I-type: ADDI
          alu_result = regs[rs1] + imm;
          if (rd != 0) regs[rd] = alu_result;
          $display("PC=0x%02h | ADDI    | x%0d = x%0d + %0d = %0d",
            pc, rd, rs1, imm, regs[rd]);
        end

        default: $display("PC=0x%02h | UNKNOWN | opcode=0x%02h", pc, opcode);
      endcase

      // Advance PC
      pc = pc + 4;
    end
  endtask

  // ── Main Simulation ─────────────────────────────
  initial begin
    // Init
    for (i = 0; i < 32; i = i + 1) regs[i] = 0;
    pc = 0;
    load_program;

    $display("=========================================");
    $display("     Mini RISC-V CPU Simulation");
    $display("=========================================");
    $display("PC       | Type    | Operation");
    $display("---------|---------|-----------------------");

    // Run 8 instructions
    repeat(8) execute;

    $display("=========================================");
    $display("         Final Register State");
    $display("=========================================");
    for (i = 0; i <= 8; i = i + 1)
      $display("  x%0d\t= %0d", i, regs[i]);

    $display("=========================================");
    $display("  CPU Simulation Complete!");
    $display("=========================================");
    $finish;
  end

endmodule
