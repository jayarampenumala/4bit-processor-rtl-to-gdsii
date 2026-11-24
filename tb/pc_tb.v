module pc_tb;
    reg clk = 0, rst, inc, load;
    reg [3:0] load_addr;
    wire [3:0] pc_out;

    pc uut (.clk(clk), .rst(rst), .inc(inc), .load(load), .load_addr(load_addr), .pc_out(pc_out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("pc.vcd");
        $dumpvars(0, pc_tb);
        rst = 1; inc = 0; load = 0; load_addr = 0;
        #12 rst = 0;

        inc = 1; #30 $display("After 3 increments: PC=%d (expect 3)", pc_out);
        inc = 0; #10 $display("Hold (inc=0): PC=%d (expect 3)", pc_out);
        load = 1; load_addr = 4'd10; #10 load = 0;
        $display("After jump: PC=%d (expect 10)", pc_out);
        inc = 1; #10 $display("Increment after jump: PC=%d (expect 11)", pc_out);
        rst = 1; #10 rst = 0; inc = 0;
        $display("After reset: PC=%d (expect 0)", pc_out);
        $finish;
    end
endmodule
