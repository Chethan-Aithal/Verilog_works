module uart_rx #(
    parameter integer CLKS_PER_BIT = 434
) (
    input  wire       clk,
    input  wire       reset,
    input  wire       rx,
    output reg  [7:0] rx_data,
    output reg        rx_valid,
    output reg        rx_busy
);

localparam [1:0] RX_IDLE  = 2'b00;
localparam [1:0] RX_START = 2'b01;
localparam [1:0] RX_DATA  = 2'b10;
localparam [1:0] RX_STOP  = 2'b11;

reg [1:0] state;
reg [31:0] clock_count;
reg [2:0] bit_index;
reg [7:0] shift_data;

always @(posedge clk) begin
    if (reset) begin
        state <= RX_IDLE;
        clock_count <= 0;
        bit_index <= 0;
        shift_data <= 0;
        rx_data <= 0;
        rx_valid <= 1'b0;
        rx_busy <= 1'b0;
    end else begin
        rx_valid <= 1'b0;
        case (state)
            RX_IDLE: begin
                clock_count <= 0;
                if (rx == 1'b0) begin
                    state <= RX_START;
                    rx_busy <= 1'b1;
                end
            end
            RX_START: begin
                if (clock_count == (CLKS_PER_BIT / 2) - 1) begin
                    clock_count <= 0;
                    if (rx == 1'b0) begin
                        state <= RX_DATA;
                        bit_index <= 0;
                    end else begin
                        state <= RX_IDLE;
                        rx_busy <= 1'b0;
                    end
                end else begin
                    clock_count <= clock_count + 1'b1;
                end
            end
            RX_DATA: begin
                if (clock_count == CLKS_PER_BIT - 1) begin
                    clock_count <= 0;
                    shift_data[bit_index] <= rx;
                    if (bit_index == 3'd7)
                        state <= RX_STOP;
                    else
                        bit_index <= bit_index + 1'b1;
                end else begin
                    clock_count <= clock_count + 1'b1;
                end
            end
            RX_STOP: begin
                if (clock_count == CLKS_PER_BIT - 1) begin
                    clock_count <= 0;
                    state <= RX_IDLE;
                    rx_busy <= 1'b0;
                    if (rx == 1'b1) begin
                        rx_data <= shift_data;
                        rx_valid <= 1'b1;
                    end
                end else begin
                    clock_count <= clock_count + 1'b1;
                end
            end
            default: begin
                state <= RX_IDLE;
                clock_count <= 0;
                rx_busy <= 1'b0;
            end
        endcase
    end
end

endmodule