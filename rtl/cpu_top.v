module cpu_top (
    input        clk,
    input        rst,
    output       halt,
    output [3:0] pc_out,
    output [3:0] alu_out
);
    // Instruction register
    reg  [7:0] ir;
    wire [7:0] idata;
    wire [3:0] opcode = ir[7:4];
    wire [1:0] rd     = ir[3:2];
    wire [1:0] rs     = ir[1:0];

    // Control signals
    wire ir_load, pc_inc, pc_load, reg_we, mem_we, flag_we, halt_w;
    wire [1:0] wsel;
    wire [2:0] alu_op;

    // Datapath wires
    wire [3:0] rdata1, rdata2, alu_result, drdata;
    wire alu_zero, alu_carry;
    reg  zero_flag, carry_flag;

    wire [3:0] wdata = (wsel == 2'd1) ? idata[3:0] :
                       (wsel == 2'd2) ? drdata      : alu_result;

    always @(posedge clk or posedge rst) begin
        if (rst) ir <= 8'h00;
        else if (ir_load) ir <= idata;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin zero_flag <= 0; carry_flag <= 0; end
        else if (flag_we) begin zero_flag <= alu_zero; carry_flag <= alu_carry; end
    end

    control_unit cu (.clk(clk), .rst(rst), .opcode(opcode), .zero_flag(zero_flag),
        .ir_load(ir_load), .pc_inc(pc_inc), .pc_load(pc_load), .reg_we(reg_we),
        .mem_we(mem_we), .flag_we(flag_we), .wsel(wsel), .alu_op(alu_op), .halt(halt_w));

    pc pc0 (.clk(clk), .rst(rst), .inc(pc_inc), .load(pc_load),
        .load_addr(idata[3:0]), .pc_out(pc_out));

    memory mem (.clk(clk), .iaddr(pc_out), .idata(idata),
        .dwe(mem_we), .daddr(rdata2), .dwdata(rdata1), .drdata(drdata));

    regfile rf (.clk(clk), .rst(rst), .we(reg_we), .waddr(rd), .wdata(wdata),
        .raddr1(rd), .raddr2(rs), .rdata1(rdata1), .rdata2(rdata2));

    alu alu0 (.a(rdata1), .b(rdata2), .op(alu_op),
        .result(alu_result), .zero(alu_zero), .carry(alu_carry));

    assign halt    = halt_w;
    assign alu_out = alu_result;
endmodule
