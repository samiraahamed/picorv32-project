module registers;
  reg [31:0] x1, x2, x3;  // 32-bit registers (like RISC-V has 32 registers)
  
  initial begin
    x1 = 32'd10;           // x1 = 10
    x2 = 32'd20;           // x2 = 20
    x3 = x1 + x2;          // x3 = x1 + x2
    
    $display("x1 = %0d", x1);
    $display("x2 = %0d", x2);
    $display("x3 = x1 + x2 = %0d", x3);
    $finish;
  end
endmodule
