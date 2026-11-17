`timescale 1ns/1ps

module tb_digital_stopwatch;
    reg clk;
    reg reset;
    reg start;
    reg stop;
    wire [5:0] seconds;
    wire running;
    integer errors;

    digital_stopwatch #(
        .CLOCK_FREQ_HZ(4)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .seconds(seconds),
        .running(running)
    );

    always #5 clk = ~clk;

    task step_clock;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task check_seconds;
        input [5:0] expected;
        begin
            if (seconds !== expected) begin
                $display("FAIL: seconds=%0d expected=%0d", seconds, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: seconds=%0d", seconds);
            end
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        stop = 0;
        errors = 0;

        step_clock;
        step_clock;
        reset = 0;

        @(negedge clk);
        start = 1;
        step_clock;
        @(negedge clk);
        start = 0;

        repeat (3) step_clock;
        check_seconds(6'd1);

        @(negedge clk);
        stop = 1;
        step_clock;
        @(negedge clk);
        stop = 0;

        repeat (8) step_clock;
        check_seconds(6'd1);

        @(negedge clk);
        start = 1;
        step_clock;
        @(negedge clk);
        start = 0;

        repeat (3) step_clock;
        check_seconds(6'd2);

        @(negedge clk);
        reset = 1;
        step_clock;
        @(negedge clk);
        reset = 0;

        check_seconds(6'd0);

        if (errors == 0)
            $display("STOPWATCH TEST PASSED");
        else
            $display("STOPWATCH TEST FAILED: %0d error(s)", errors);

        $finish;
    end
endmodule