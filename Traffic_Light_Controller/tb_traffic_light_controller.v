`timescale 1ns/1ps

module tb_traffic_light_controller;

reg clk;
reg reset;
wire green;
wire yellow;
wire red;
integer errors;

traffic_light_controller #(
    .GREEN_CYCLES(3),
    .YELLOW_CYCLES(2),
    .RED_CYCLES(4)
) dut (
    .clk(clk),
    .reset(reset),
    .green(green),
    .yellow(yellow),
    .red(red)
);

always #5 clk = ~clk;

task step_clock;
    begin
        @(posedge clk);
        #1;
    end
endtask

task check_lights;
    input expected_green;
    input expected_yellow;
    input expected_red;
    begin
        if ({green, yellow, red} !== {expected_green, expected_yellow, expected_red}) begin
            $display("FAIL: lights=%b%b%b expected=%b%b%b", green, yellow, red,
                     expected_green, expected_yellow, expected_red);
            errors = errors + 1;
        end else begin
            $display("PASS: lights=%b%b%b", green, yellow, red);
        end
    end
endtask

initial begin
    clk = 0;
    reset = 1;
    errors = 0;

    step_clock;
    step_clock;
    check_lights(1'b1, 1'b0, 1'b0);
    reset = 0;

    step_clock;
    check_lights(1'b1, 1'b0, 1'b0);
    step_clock;
    check_lights(1'b1, 1'b0, 1'b0);
    step_clock;
    check_lights(1'b0, 1'b1, 1'b0);
    step_clock;
    check_lights(1'b0, 1'b1, 1'b0);
    step_clock;
    check_lights(1'b0, 1'b0, 1'b1);
    step_clock;
    step_clock;
    step_clock;
    check_lights(1'b0, 1'b0, 1'b1);
    step_clock;
    check_lights(1'b1, 1'b0, 1'b0);

    if (errors == 0)
        $display("TRAFFIC LIGHT TEST PASSED");
    else
        $display("TRAFFIC LIGHT TEST FAILED: %0d error(s)", errors);
    $finish;
end

endmodule
