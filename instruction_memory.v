module instruction_memory;
  // Memory: 8 locations, each 32-bit wide
  reg [31:0] imem [0:7];
  
  reg [31:0] pc;
  reg [31:0] instruction;
  integer    i;

  initial begin
    // Load RISC-V-like instructions into memory
    imem[0] = 32'h00000013; // NOP       (do nothing)
    imem[1] = 32'h00500093; // ADDI x1, x0, 5   (x1 = 5)
    imem[2] = 32'h00A00113; // ADDI x2, x0, 10  (x2 = 10)
    imem[3] = 32'h002081B3; // ADD  x3, x1, x2  (x3 = x1+x2)
    imem[4] = 32'h00000013; // NOP
    imem[5] = 32'h0000006F; // JAL (jump)
    imem[6] = 32'hDEADBEEF; // custom data
    imem[7] = 32'hCAFEBABE; // custom data

    $display("=== Instruction Memory Fetch ===");
    $display("PC Addr  | Hex Instruction | Description");
    $display("---------|-----------------|------------------");

    // Fetch instructions using PC
    for (i = 0; i < 8; i = i + 1) begin
      pc          = i * 4;           // PC address
      instruction = imem[i];         // fetch instruction

      case(instruction)
        32'h00000013: $display("0x%08h |   0x%08h   | NOP", pc, instruction);
        32'h00500093: $display("0x%08h |   0x%08h   | ADDI x1, x0, 5", pc, instruction);
        32'h00A00113: $display("0x%08h |   0x%08h   | ADDI x2, x0, 10", pc, instruction);
        32'h002081B3: $display("0x%08h |   0x%08h   | ADD  x3, x1, x2", pc, instruction);
        32'h0000006F: $display("0x%08h |   0x%08h   | JAL  (jump)", pc, instruction);
        default:      $display("0x%08h |   0x%08h   | DATA", pc, instruction);
      endcase
    end

    $display("=== Fetch Complete ===");
    $finish;
  end
endmodule
