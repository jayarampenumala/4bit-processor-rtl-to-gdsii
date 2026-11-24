module cpu_tb;
    reg clk = 0, rst;
    wire halt;
    wire [3:0] pc_out, alu_out;

    cpu_top uut (.clk(clk), .rst(rst), .halt(halt), .pc_out(pc_out), .alu_out(alu_out));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_tb);
        rst = 1; #22 rst = 0;
        wait (halt == 1);
        #20;
        $display("R0=%0d R1=%0d R2=%0d R3=%0d", uut.rf.regs[0], uut.rf.regs[1], uut.rf.regs[2], uut.rf.regs[3]);
        $display("MEM[0]=%0d  PC=%0d  halt=%b", uut.mem.ram[0], pc_out, halt);
        if (uut.rf.regs[0] == 8 && uut.rf.regs[1] == 0 && uut.rf.regs[3] == 8 && uut.mem.ram[0] == 8)
            $display("CPU TEST PASSED");
        else
            $display("CPU TEST FAILED");
        $finish;
    end

    initial begin
        #5000 $display("TIMEOUT: halt raaledu");
        $finish;
    end
endmodule
