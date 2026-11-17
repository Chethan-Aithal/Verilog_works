module matrix_multiplier_2x2_shared (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [7:0] a00,
    input  wire [7:0] a01,
    input  wire [7:0] a10,
    input  wire [7:0] a11,
    input  wire [7:0] b00,
    input  wire [7:0] b01,
    input  wire [7:0] b10,
    input  wire [7:0] b11,
    output reg  [16:0] c00,
    output reg  [16:0] c01,
    output reg  [16:0] c10,
    output reg  [16:0] c11,
    output reg        busy,
    output reg        done
);

reg [3:0] operation_index;
reg [16:0] partial_sum;
reg [7:0] operand_a;
reg [7:0] operand_b;
wire [15:0] shared_product;

assign shared_product = operand_a * operand_b;

always @(*) begin
    operand_a = 8'd0;
    operand_b = 8'd0;
    case (operation_index)
        4'd0: begin operand_a = a00; operand_b = b00; end
        4'd1: begin operand_a = a01; operand_b = b10; end
        4'd2: begin operand_a = a00; operand_b = b01; end
        4'd3: begin operand_a = a01; operand_b = b11; end
        4'd4: begin operand_a = a10; operand_b = b00; end
        4'd5: begin operand_a = a11; operand_b = b10; end
        4'd6: begin operand_a = a10; operand_b = b01; end
        4'd7: begin operand_a = a11; operand_b = b11; end
        default: begin operand_a = 8'd0; operand_b = 8'd0; end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        operation_index <= 0;
        partial_sum <= 0;
        c00 <= 0;
        c01 <= 0;
        c10 <= 0;
        c11 <= 0;
        busy <= 1'b0;
        done <= 1'b0;
    end else begin
        done <= 1'b0;
        if (!busy) begin
            if (start) begin
                operation_index <= 0;
                partial_sum <= 0;
                busy <= 1'b1;
            end
        end else begin
            case (operation_index)
                4'd0: begin
                    partial_sum <= {1'b0, shared_product};
                    operation_index <= 4'd1;
                end
                4'd1: begin
                    c00 <= partial_sum + {1'b0, shared_product};
                    operation_index <= 4'd2;
                end
                4'd2: begin
                    partial_sum <= {1'b0, shared_product};
                    operation_index <= 4'd3;
                end
                4'd3: begin
                    c01 <= partial_sum + {1'b0, shared_product};
                    operation_index <= 4'd4;
                end
                4'd4: begin
                    partial_sum <= {1'b0, shared_product};
                    operation_index <= 4'd5;
                end
                4'd5: begin
                    c10 <= partial_sum + {1'b0, shared_product};
                    operation_index <= 4'd6;
                end
                4'd6: begin
                    partial_sum <= {1'b0, shared_product};
                    operation_index <= 4'd7;
                end
                4'd7: begin
                    c11 <= partial_sum + {1'b0, shared_product};
                    operation_index <= 0;
                    busy <= 1'b0;
                    done <= 1'b1;
                end
                default: begin
                    operation_index <= 0;
                    busy <= 1'b0;
                end
            endcase
        end
    end
end

endmodule
