`timescale 1ns/1ps

module tb_matrix_multiplier_2x2;

reg clk;
reg reset;
reg start;
reg [7:0] a00, a01, a10, a11;
reg [7:0] b00, b01, b10, b11;
wire [16:0] c00, c01, c10, c11;
wire busy;
wire done;
integer errors;

matrix_multiplier_2x2_shared dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .a00(a00), .a01(a01), .a10(a10), .a11(a11),
    .b00(b00), .b01(b01), .b10(b10), .b11(b11),
    .c00(c00), .c01(c01), .c10(c10), .c11(c11),
    .busy(busy),
    .done(done)
);

always #5 clk = ~clk;

task launch_operation;
    begin
        @(negedge clk);
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;
        wait (done == 1'b1);
        #1;
    end
endtask

task check_outputs;
    input [16:0] expected_c00;
    input [16:0] expected_c01;
    input [16:0] expected_c10;
    input [16:0] expected_c11;
    begin
        if ((c00 !== expected_c00) || (c01 !== expected_c01) ||
            (c10 !== expected_c10) || (c11 !== expected_c11)) begin
            $display("FAIL: C00=%0d C01=%0d C10=%0d C11=%0d", c00, c01, c10, c11);
            $display("Expected: C00=%0d C01=%0d C10=%0d C11=%0d",
                     expected_c00, expected_c01, expected_c10, expected_c11);
            errors = errors + 1;
        end else begin
            $display("PASS: C00=%0d C01=%0d C10=%0d C11=%0d", c00, c01, c10, c11);
        end
    end
endtask

initial begin
    clk = 0;
    reset = 1;
    start = 0;
    errors = 0;
    a00 = 0; a01 = 0; a10 = 0; a11 = 0;
    b00 = 0; b01 = 0; b10 = 0; b11 = 0;

    repeat (2) @(posedge clk);
    #1 reset = 0;

    a00 = 8'd1; a01 = 8'd2;
    a10 = 8'd3; a11 = 8'd4;
    b00 = 8'd5; b01 = 8'd6;
    b10 = 8'd7; b11 = 8'd8;
    launch_operation;
    check_outputs(17'd19, 17'd22, 17'd43, 17'd50);

    a00 = 8'hFF; a01 = 8'hFF;
    a10 = 8'hFF; a11 = 8'hFF;
    b00 = 8'hFF; b01 = 8'hFF;
    b10 = 8'hFF; b11 = 8'hFF;
    launch_operation;
    check_outputs(17'd130050, 17'd130050, 17'd130050, 17'd130050);

    if (errors == 0)
        $display("MATRIX MULTIPLIER TEST PASSED");
    else
        $display("MATRIX MULTIPLIER TEST FAILED: %0d error(s)", errors);
    $finish;
end

endmodule
