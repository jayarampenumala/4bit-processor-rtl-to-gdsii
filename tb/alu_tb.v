module alu_tb;
    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] result;
    wire zero, carry;

    alu uut (.a(a), .b(b), .op(op), .result(result), .zero(zero), .carry(carry));

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
        a = 4'd5; b = 4'd3;
        op = 3'b000; #10 $display("ADD: %d + %d = %d carry=%b", a, b, result, carry);
        op = 3'b001; #10 $display("SUB: %d - %d = %d", a, b, result);
        op = 3'b010; #10 $display("AND: %b", result);
        op = 3'b011; #10 $display("OR : %b", result);
        op = 3'b100; #10 $display("XOR: %b", result);
        op = 3'b101; #10 $display("NOT: %b", result);
        op = 3'b110; #10 $display("MOV: %d", result);
        a = 4'd9; b = 4'd9; op = 3'b001; #10 $display("SUB: zero flag=%b", zero);
        a = 4'd15; b = 4'd1; op = 3'b000; #10 $display("ADD overflow: result=%d carry=%b", result, carry);
        $finish;
    end
endmodule
