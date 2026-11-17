module uart_tx #(
    parameter integer CLKS_PER_BIT = 434
) (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output wire       tx,
    output reg        tx_busy,
    output reg        tx_done
);

localparam [1:0] TX_IDLE  = 2'b00;
localparam [1:0] TX_START = 2'b01;
localparam [1:0] TX_DATA  = 2'b10;
localparam [1:0] TX_STOP  = 2'b11;

reg [1:0] state;
reg [31:0] clock_count;
reg [2:0] bit_index;
reg [7:0] shift_data;

assign tx = (state == TX_START) ? 1'b0 :
            (state == TX_DATA)  ? shift_data[bit_index] : 1'b1;

always @(posedge clk) begin
    if (reset) begin
        state <= TX_IDLE;
        clock_count <= 0;
        bit_index <= 0;
        shift_data <= 0;
        tx_busy <= 1'b0;
        tx_done <= 1'b0;
    end else begin
        tx_done <= 1'b0;
        case (state)
            TX_IDLE: begin
                clock_count <= 0;
                if (tx_start) begin
                    shift_data <= tx_data;
                    bit_index <= 0;
                    state <= TX_START;
                    tx_busy <= 1'b1;
                end
            end
            TX_START: begin
                if (clock_count == CLKS_PER_BIT - 1) begin
                    clock_count <= 0;
                    state <= TX_DATA;
                end else begin
                    clock_count <= clock_count + 1'b1;
                end
            end
            TX_DATA: begin
                if (clock_count == CLKS_PER_BIT - 1) begin
                    clock_count <= 0;
                    if (bit_index == 3'd7)
                        state <= TX_STOP;
                    else
                        bit_index <= bit_index + 1'b1;
                end else begin
                    clock_count <= clock_count + 1'b1;
                end
            end
            TX_STOP: begin
                if (clock_count == CLKS_PER_BIT - 1) begin
                    clock_count <= 0;
                    state <= TX_IDLE;
                    tx_busy <= 1'b0;
                    tx_done <= 1'b1;
                end else begin
                    clock_count <= clock_count + 1'b1;
                end
            end
            default: begin
                state <= TX_IDLE;
                clock_count <= 0;
                tx_busy <= 1'b0;
            end
        endcase
    end
end

endmodule