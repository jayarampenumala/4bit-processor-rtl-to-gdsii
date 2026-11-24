module regfile (
    input        clk,
    input        rst,
    input        we,
    input  [1:0] waddr,
    input  [3:0] wdata,
    input  [1:0] raddr1,
    input  [1:0] raddr2,
    output [3:0] rdata1,
    output [3:0] rdata2
);
    reg [3:0] regs [0:3];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1)
                regs[i] <= 4'b0000;
        end else if (we) begin
            regs[waddr] <= wdata;
        end
    end

    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
endmodule
