module cpu_execution_flow;

  parameter DATA_WIDTH = 32;
  parameter NUM_REGS   = 32;
  parameter MEM_DEPTH  = 16;

  reg [DATA_WIDTH-1:0] imem [0:MEM_DEPTH-1];
  reg [DATA_WIDTH-1:0] regs [0:NUM_REGS-1];
  reg [DATA_WIDTH-1:0] pc;
  reg                  clk;

  // Pipeline stage registers
  reg [DATA_WIDTH-1:0] fetched_instr;
  reg [DATA_WIDTH-1:0] alu_result, imm;
  reg [6:0]  opcode, funct7;
  reg [4:0]  rd, rs1, rs2;
  reg [2:0]  funct3;
  reg [7:0]  cycle;
  integer    i;

  // ── Clock Generator ──────────────────────────────
  initial clk = 0;
  always #5 clk = ~clk;   // toggle every 5 time units

  // ── Load Program ─────────────────────────────────
  task load_program;
    begin
      imem[0] = 32'h00500093;  // ADDI x1, x0, 5
      imem[1] = 32'h00300113;  // ADDI x2, x0, 3
      imem[2] = 32'h002081B3;  // ADD  x3, x1, x2
      imem[3] = 32'h40308233;  // SUB  x4, x1, x3
      imem[4] = 32'h00408333;  // ADD  x6, x1, x4
      imem[5] = 32'h006081B3;  // ADD  x3, x1, x6
    end
  endtask

  // ── STAGE 1: Fetch ───────────────────────────────
  task stage_fetch;
    begin
      fetched_instr = imem[pc >> 2];
      $display("  [FETCH]   PC=0x%02h → Instr=0x%08h", pc, fetched_instr);
    end
  endtask

  // ── STAGE 2: Decode ──────────────────────────────
  task stage_decode;
    begin
      opcode = fetched_instr[6:0];
      rd     = fetched_instr[11:7];
      funct3 = fetched_instr[14:12];
      rs1    = fetched_instr[19:15];
      rs2    = fetched_instr[24:20];
      funct7 = fetched_instr[31:25];
      imm    = {{20{fetched_instr[31]}}, fetched_instr[31:20]};

      case(opcode)
        7'b0110011: $display("  [DECODE]  R-type  | rd=x%0d rs1=x%0d rs2=x%0d funct7=0x%02h",
                      rd, rs1, rs2, funct7);
        7'b0010011: $display("  [DECODE]  I-type  | rd=x%0d rs1=x%0d imm=%0d",
                      rd, rs1, $signed(imm));
        default:    $display("  [DECODE]  UNKNOWN | opcode=0x%02h", opcode);
      endcase
    end
  endtask

  // ── STAGE 3: Execute ─────────────────────────────
  task stage_execute;
    begin
      case(opcode)
        7'b0110011: begin
          alu_result = (funct7==7'h20) ?
                       regs[rs1] - regs[rs2] :
                       regs[rs1] + regs[rs2];
          if (rd != 0) regs[rd] = alu_result;
          $display("  [EXECUTE] x%0d = x%0d %s x%0d = %0d",
            rd, rs1,
            (funct7==7'h20) ? "-" : "+",
            rs2, $signed(regs[rd]));
        end
        7'b0010011: begin
          alu_result = regs[rs1] + imm;
          if (rd != 0) regs[rd] = alu_result;
          $display("  [EXECUTE] x%0d = x%0d + %0d = %0d",
            rd, rs1, $signed(imm), $signed(regs[rd]));
        end
      endcase
      $display("  [WRITEBK] x%0d written ✓", rd);
    end
  endtask

  // ── Main Simulation ──────────────────────────────
  initial begin
    for (i = 0; i < NUM_REGS; i = i + 1) regs[i] = 0;
    pc    = 0;
    cycle = 0;
    load_program;

    $display("╔══════════════════════════════════════════╗");
    $display("║     PicoRV32 - CPU Execution Flow        ║");
    $display("╚══════════════════════════════════════════╝");

    repeat(6) begin
      @(posedge clk);   // wait for clock rising edge
      cycle = cycle + 1;
      $display("┌──────────────────────────────────────────┐");
      $display("│  CYCLE %0d                                 │", cycle);
      $display("└──────────────────────────────────────────┘");

      stage_fetch;
      stage_decode;
      stage_execute;
      pc = pc + 4;
      $display("");
    end

    $display("╔══════════════════════════════════════════╗");
    $display("║         Final Register State             ║");
    $display("╚══════════════════════════════════════════╝");
    for (i = 0; i <= 6; i = i + 1)
      $display("  x%0d = %0d", i, $signed(regs[i]));

    $display("");
    $display("╔══════════════════════════════════════════╗");
    $display("║   PicoRV32 Project Complete! Well Done!  ║");
    $display("╚══════════════════════════════════════════╝");
    $finish;
  end

endmodule
