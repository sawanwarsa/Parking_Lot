module parking_lot #(
    parameter max_spots = 4,
    parameter width = 3
)(
    input clk, reset,
    input car_in, car_out,
    output reg  [width-1:0] count,
    output wire [width-1:0] available,
    output wire full, empty
);

    reg car_in_d, car_out_d;

    // Edge detection - remember previous cycle's sensor values
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            car_in_d  <= 0;
            car_out_d <= 0;
        end else begin
            car_in_d  <= car_in;
            car_out_d <= car_out;
        end
    end

    wire car_in_pulse  = car_in  & ~car_in_d;   // rising edge -> one car entering
    wire car_out_pulse = car_out & ~car_out_d;  // rising edge -> one car exiting

    // Combinational logic
    assign full      = (count == max_spots);
    assign empty     = (count == 0);
    assign available = (max_spots - count);

    // Counter with entry/exit guards
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else begin
            case ({car_in_pulse, car_out_pulse})
                2'b10: if (!full)  count <= count + 1;  // entry only, reject if full
                2'b01: if (!empty) count <= count - 1;  // exit only, ignore if empty
                2'b11: count <= count;                   // simultaneous in+out -> net zero
                default: count <= count;                 // no activity
            endcase
        end
    end

endmodule
