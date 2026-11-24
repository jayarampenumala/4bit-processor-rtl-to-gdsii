module memory (
    input        clk,
    input  [3:0] iaddr,
    output reg [7:0] idata,
    input        dwe,
    input  [3:0] daddr,
    input  [3:0] dwdata,
    output [3:0] drdata
);
    reg [3:0] ram [0:15];

    always @(*) begin
        case (iaddr)
            4'h0: idata = 8'h80;  // LDI R0, 5
            4'h1: idata = 8'h05;
            4'h2: idata = 8'h84;  // LDI R1, 3
            4'h3: idata = 8'h03;
            4'h4: idata = 8'h11;  // ADD R0, R1
            4'h5: idata = 8'hA2;  // ST MEM[R2] = R0
            4'h6: idata = 8'h9E;  // LD R3 = MEM[R2]
            4'h7: idata = 8'h25;  // SUB R1, R1
            4'h8: idata = 8'hC0;  // JZ 12
            4'h9: idata = 8'h0C;
            4'hA: idata = 8'h8C;  // LDI R3, 15 (skipped)
            4'hB: idata = 8'h0F;
            4'hC: idata = 8'hF0;  // HALT
            default: idata = 8'h00;
        endcase
    end

    assign drdata = ram[daddr];

    always @(posedge clk) begin
        if (dwe)
            ram[daddr] <= dwdata;
    end
endmodule
