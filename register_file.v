module register_file;
  reg [31:0] regs [0:31];   // 32 registers, each 32-bit
  integer i;

  // Write to register (x0 is always 0, ignore writes)
  task write_reg;
    input [4:0]  rd;    // destination register number
    input [31:0] data;  // value to write
    begin
      if (rd != 0)            // x0 is hardwired to 0
        regs[rd] = data;
      $display("  WRITE: x%0d = %0d", rd, data);
    end
  endtask

  // Read from register
  task read_reg;
    input [4:0] rs;     // source register number
    begin
      $display("  READ : x%0d = %0d", rs, regs[rs]);
    end
  endtask

  initial begin
    // Initialize all registers to 0
    for (i = 0; i < 32; i = i + 1)
      regs[i] = 32'd0;

    $display("=== Register File Simulation ===");
    $display("");

    // --- Write values ---
    $display("--- Writing to Registers ---");
    write_reg(5'd0,  32'd99);   // try writing to x0 (should stay 0)
    write_reg(5'd1,  32'd5);    // x1 = 5
    write_reg(5'd2,  32'd10);   // x2 = 10
    write_reg(5'd3,  32'd0);    // x3 = 0 (will hold result)

    $display("");

    // --- Compute ADD using register values ---
    $display("--- Computing ADD x3 = x1 + x2 ---");
    regs[3] = regs[1] + regs[2];
    $display("  x3 = x1 + x2 = %0d + %0d = %0d", regs[1], regs[2], regs[3]);

    $display("");

    // --- Read values ---
    $display("--- Reading Registers ---");
    read_reg(5'd0);   // should print 0 (hardwired)
    read_reg(5'd1);
    read_reg(5'd2);
    read_reg(5'd3);

    $display("");

    // --- Dump all registers ---
    $display("--- Full Register Dump ---");
    for (i = 0; i < 8; i = i + 1)
      $display("  x%0d = %0d", i, regs[i]);

    $display("");
    $display("=== Register File Complete ===");
    $finish;
  end
endmodule
