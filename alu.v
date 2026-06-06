module ALU;
  reg [31:0] a, b;
  reg [2:0]  op;        // operation selector
  reg [31:0] result;

  initial begin
    a = 32'd15;
    b = 32'd10;

    // ADD
    op = 3'b000; result = a + b;
    $display("ADD : %0d + %0d = %0d", a, b, result);

    // SUB
    op = 3'b001; result = a - b;
    $display("SUB : %0d - %0d = %0d", a, b, result);

    // AND
    op = 3'b010; result = a & b;
    $display("AND : %0d & %0d = %0d", a, b, result);

    // OR
    op = 3'b011; result = a | b;
    $display("OR  : %0d | %0d = %0d", a, b, result);

    // XOR
    op = 3'b100; result = a ^ b;
    $display("XOR : %0d ^ %0d = %0d", a, b, result);

    // Shift Left
    op = 3'b101; result = a << 1;
    $display("SHL : %0d << 1 = %0d", a, result);

    // Shift Right
    op = 3'b110; result = a >> 1;
    $display("SHR : %0d >> 1 = %0d", a, result);

    $finish;
  end
endmodule
