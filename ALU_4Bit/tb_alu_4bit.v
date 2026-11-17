`timescale 1ns/1ps

module tb_alu_4bit;

reg [3:0] A;
reg [3:0] B;
reg [1:0] op;
wire [3:0] result;
integer errors;

alu_4bit dut (
    .A(A),
    .B(B),
    .op(op),
    .result(result)
);

task check_operation;
    input [3:0] a_value;
    input [3:0] b_value;
    input [1:0] operation;
    input [3:0] expected;
    begin
        A = a_value;
        B = b_value;
        op = operation;
        #10;
        if (result !== expected) begin
            $display("FAIL: A=%h B=%h op=%b result=%h expected=%h", A, B, op, result, expected);
            errors = errors + 1;
        end else begin
            $display("PASS: A=%h B=%h op=%b result=%h", A, B, op, result);
        end
    end
endtask

initial begin
    errors = 0;
    A = 0;
    B = 0;
    op = 0;

    check_operation(4'd3,  4'd2, 2'b00, 4'd5);
    check_operation(4'd15, 4'd1, 2'b00, 4'd0);
    check_operation(4'd9,  4'd4, 2'b01, 4'd5);
    check_operation(4'd0,  4'd1, 2'b01, 4'd15);
    check_operation(4'b1010, 4'b1100, 2'b10, 4'b1000);
    check_operation(4'b0110, 4'b0011, 2'b10, 4'b0010);
    check_operation(4'b1010, 4'b0101, 2'b11, 4'b1111);
    check_operation(4'b0001, 4'b0010, 2'b11, 4'b0011);

    if (errors == 0)
        $display("ALU TEST PASSED");
    else
        $display("ALU TEST FAILED: %0d error(s)", errors);
    $finish;
end

endmodule
