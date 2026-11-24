module alu (
    input  [3:0] a, b,
    input  [2:0] op,
    output reg [3:0] result,
    output zero,
    output reg carry
);
    always @(*) begin
        carry = 1'b0;
        case (op)
            3'b000: {carry, result} = a + b;   // ADD
            3'b001: {carry, result} = a - b;   // SUB
            3'b010: result = a & b;            // AND
            3'b011: result = a | b;            // OR
            3'b100: result = a ^ b;            // XOR
            3'b101: result = ~a;               // NOT
            3'b110: result = b;                // MOV
            default: result = 4'b0000;
        endcase
    end
    assign zero = (result == 4'b0000);
endmodule
