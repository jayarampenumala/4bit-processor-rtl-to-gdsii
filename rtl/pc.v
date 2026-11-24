module pc (
    input        clk,
    input        rst,
    input        inc,
    input        load,
    input  [3:0] load_addr,
    output reg [3:0] pc_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 4'b0000;
        else if (load)
            pc_out <= load_addr;
        else if (inc)
            pc_out <= pc_out + 1'b1;
    end
endmodule
