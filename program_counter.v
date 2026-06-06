module program_counter;
  reg [31:0] pc;        // 32-bit Program Counter
  reg        clk;       // clock signal
  integer    i;

  initial begin
    pc  = 32'h00000000; // start at address 0
    clk = 0;

    $display("--- Program Counter Simulation ---");
    $display("Cycle | PC Address | Instruction #");
    $display("------|------------|---------------");

    // Simulate 6 clock cycles
    for (i = 0; i < 6; i = i + 1) begin
      #1 clk = ~clk;             // toggle clock
      pc = pc + 4;               // PC jumps by 4 bytes each cycle
      $display("  %0d   | 0x%08h |   Instr #%0d", i+1, pc, (pc/4));
    end

    $display("--- Simulation Complete ---");
    $finish;
  end
endmodule
