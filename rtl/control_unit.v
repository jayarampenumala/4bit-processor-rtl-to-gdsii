module control_unit (
    input        clk,
    input        rst,
    input  [3:0] opcode,
    input        zero_flag,
    output reg   ir_load,
    output reg   pc_inc,
    output reg   pc_load,
    output reg   reg_we,
    output reg   mem_we,
    output reg   flag_we,
    output reg [1:0] wsel,     // 0=ALU, 1=immediate, 2=memory
    output reg [2:0] alu_op,
    output reg   halt
);
    localparam FETCH = 2'd0, EXEC = 2'd1, HALT_S = 2'd2;
    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) state <= FETCH;
        else     state <= next_state;
    end

    always @(*) begin
        ir_load = 0; pc_inc = 0; pc_load = 0; reg_we = 0;
        mem_we = 0; flag_we = 0; wsel = 2'd0; alu_op = 3'b000;
        halt = 0; next_state = state;

        case (state)
            FETCH: begin
                ir_load = 1;
                pc_inc  = 1;
                next_state = EXEC;
            end
            EXEC: begin
                next_state = FETCH;
                case (opcode)
                    4'b0001: begin alu_op = 3'b000; reg_we = 1; flag_we = 1; end // ADD
                    4'b0010: begin alu_op = 3'b001; reg_we = 1; flag_we = 1; end // SUB
                    4'b0011: begin alu_op = 3'b010; reg_we = 1; flag_we = 1; end // AND
                    4'b0100: begin alu_op = 3'b011; reg_we = 1; flag_we = 1; end // OR
                    4'b0101: begin alu_op = 3'b100; reg_we = 1; flag_we = 1; end // XOR
                    4'b0110: begin alu_op = 3'b101; reg_we = 1; flag_we = 1; end // NOT
                    4'b0111: begin alu_op = 3'b110; reg_we = 1; flag_we = 1; end // MOV
                    4'b1000: begin wsel = 2'd1; reg_we = 1; pc_inc = 1; end      // LDI
                    4'b1001: begin wsel = 2'd2; reg_we = 1; end                  // LD
                    4'b1010: begin mem_we = 1; end                               // ST
                    4'b1011: begin pc_load = 1; end                              // JMP
                    4'b1100: begin                                               // JZ
                        if (zero_flag) pc_load = 1;
                        else           pc_inc  = 1;
                    end
                    4'b1111: next_state = HALT_S;                                // HALT
                    default: ;                                                   // NOP
                endcase
            end
            HALT_S: begin
                halt = 1;
                next_state = HALT_S;
            end
            default: next_state = FETCH;
        endcase
    end
endmodule
