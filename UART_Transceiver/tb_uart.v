`timescale 1ns/1ps

module tb_uart;

reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;
wire tx_line;
wire tx_busy;
wire tx_done;
wire [7:0] rx_data;
wire rx_valid;
wire rx_busy;
integer errors;

uart_tx #(
    .CLKS_PER_BIT(8)
) transmitter (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx_line),
    .tx_busy(tx_busy),
    .tx_done(tx_done)
);

uart_rx #(
    .CLKS_PER_BIT(8)
) receiver (
    .clk(clk),
    .reset(reset),
    .rx(tx_line),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .rx_busy(rx_busy)
);

always #5 clk = ~clk;

task send_and_check;
    input [7:0] value;
    begin
        @(negedge clk);
        tx_data = value;
        tx_start = 1'b1;
        @(negedge clk);
        tx_start = 1'b0;

        wait (rx_valid == 1'b1);
        #1;
        if (rx_data !== value) begin
            $display("FAIL: sent=%h received=%h", value, rx_data);
            errors = errors + 1;
        end else begin
            $display("PASS: sent=%h received=%h", value, rx_data);
        end
        if (!tx_done)
            wait (tx_done == 1'b1);
        @(posedge clk);
        #1;
    end
endtask

initial begin
    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 0;
    errors = 0;

    repeat (3) @(posedge clk);
    #1 reset = 0;

    send_and_check(8'hA5);
    send_and_check(8'h3C);
    send_and_check(8'h00);
    send_and_check(8'hFF);

    if (errors == 0)
        $display("UART LOOPBACK TEST PASSED");
    else
        $display("UART LOOPBACK TEST FAILED: %0d error(s)", errors);
    $finish;
end

endmodule