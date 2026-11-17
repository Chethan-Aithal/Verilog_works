module digital_stopwatch #(
    parameter integer CLOCK_FREQ_HZ = 50000000
) (
    input wire clk,
    input wire reset,
    input wire start,
    input wire stop,
    output reg [5:0] seconds,
    output reg running
);
    reg [31:0] divider_count;

    always @(posedge clk) begin
        if (reset) begin
            divider_count <= 0;
            seconds <= 0;
            running <= 1'b0;
        end else begin
            if (stop) begin
                running <= 1'b0;
                divider_count <= 0;
            end else if (start) begin
                running <= 1'b1;
                if (divider_count == CLOCK_FREQ_HZ - 1) begin
                    divider_count <= 0;
                    if (seconds == 6'd59)
                        seconds <= 0;
                    else
                        seconds <= seconds + 1'b1;
                end else begin
                    divider_count <= divider_count + 1'b1;
                end
            end else if (running) begin
                if (divider_count == CLOCK_FREQ_HZ - 1) begin
                    divider_count <= 0;
                    if (seconds == 6'd59)
                        seconds <= 0;
                    else
                        seconds <= seconds + 1'b1;
                end else begin
                    divider_count <= divider_count + 1'b1;
                end
            end
        end
    end
endmodule