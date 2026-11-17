module traffic_light_controller #(
    parameter integer GREEN_CYCLES = 5,
    parameter integer YELLOW_CYCLES = 2,
    parameter integer RED_CYCLES = 5
) (
    input  wire clk,
    input  wire reset,
    output reg  green,
    output reg  yellow,
    output reg  red
);

localparam [1:0] GREEN_STATE  = 2'b00;
localparam [1:0] YELLOW_STATE = 2'b01;
localparam [1:0] RED_STATE    = 2'b10;

reg [1:0] state;
reg [31:0] cycle_count;

always @(*) begin
    green = 1'b0;
    yellow = 1'b0;
    red = 1'b0;

    case (state)
        GREEN_STATE:  green = 1'b1;
        YELLOW_STATE: yellow = 1'b1;
        RED_STATE:    red = 1'b1;
        default:      green = 1'b1;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= GREEN_STATE;
        cycle_count <= 0;
    end else begin
        case (state)
            GREEN_STATE: begin
                if (cycle_count == GREEN_CYCLES - 1) begin
                    cycle_count <= 0;
                    state <= YELLOW_STATE;
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                end
            end
            YELLOW_STATE: begin
                if (cycle_count == YELLOW_CYCLES - 1) begin
                    cycle_count <= 0;
                    state <= RED_STATE;
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                end
            end
            RED_STATE: begin
                if (cycle_count == RED_CYCLES - 1) begin
                    cycle_count <= 0;
                    state <= GREEN_STATE;
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                end
            end
            default: begin
                state <= GREEN_STATE;
                cycle_count <= 0;
            end
        endcase
    end
end

endmodule
