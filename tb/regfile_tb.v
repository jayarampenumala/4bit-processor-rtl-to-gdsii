module regfile_tb;
    reg clk = 0, rst, we;
    reg [1:0] waddr, raddr1, raddr2;
    reg [3:0] wdata;
    wire [3:0] rdata1, rdata2;

    regfile uut (.clk(clk), .rst(rst), .we(we), .waddr(waddr), .wdata(wdata),
                 .raddr1(raddr1), .raddr2(raddr2), .rdata1(rdata1), .rdata2(rdata2));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, regfile_tb);
        rst = 1; we = 0; waddr = 0; wdata = 0; raddr1 = 0; raddr2 = 0;
        #12 rst = 0;

        // Write R0=5, R1=3, R2=9, R3=15
        we = 1;
        waddr = 0; wdata = 4'd5;  #10;
        waddr = 1; wdata = 4'd3;  #10;
        waddr = 2; wdata = 4'd9;  #10;
        waddr = 3; wdata = 4'd15; #10;
        we = 0;

        // Read back
        raddr1 = 0; raddr2 = 1; #10 $display("R0=%d R1=%d (expect 5 3)", rdata1, rdata2);
        raddr1 = 2; raddr2 = 3; #10 $display("R2=%d R3=%d (expect 9 15)", rdata1, rdata2);

        // Write disabled test: we=0, should not change R0
        waddr = 0; wdata = 4'd7; #10;
        raddr1 = 0; #10 $display("R0=%d (expect 5, we=0)", rdata1);

        // Reset test
        rst = 1; #10 rst = 0;
        raddr1 = 0; raddr2 = 3; #10 $display("After reset: R0=%d R3=%d (expect 0 0)", rdata1, rdata2);
        $finish;
    end
endmodule
