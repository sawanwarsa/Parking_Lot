module tb;
    parameter max_spots = 4;
    parameter width = 3;

    reg clk = 0, reset;
    reg car_in, car_out;
    wire [width-1:0] count, available;
    wire full, empty;

    parking_lot #(.max_spots(max_spots), .width(width)) park (
        .clk(clk),
        .reset(reset),
        .car_in(car_in),
        .car_out(car_out),
        .count(count),
        .available(available),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        // Reset
        reset = 1; car_in = 0; car_out = 0;
        #10 reset = 0;

        // Car 1 enters
        #10 car_in = 1;
        #10 car_in = 0;

        // Car 2 enters
        #10 car_in = 1;
        #10 car_in = 0;

        // Car 3 enters
        #10 car_in = 1;
        #10 car_in = 0;

        // Car 4 enters -> lot should be FULL now (max_spots = 4)
        #10 car_in = 1;
        #10 car_in = 0;

        // Try a 5th car -> should be REJECTED (lot full)
        #10 car_in = 1;
        #10 car_in = 0;

        // One car exits
        #10 car_out = 1;
        #10 car_out = 0;

        // Empty the lot completely
        #10 car_out = 1;
        #10 car_out = 0;
        #10 car_out = 1;
        #10 car_out = 0;
        #10 car_out = 1;
        #10 car_out = 0;

        // Try to exit again -> should be IGNORED (lot empty)
        #10 car_out = 1;
        #10 car_out = 0;

        #20 $finish;
    end

    always @(posedge clk) begin
        $display("Time=%0t | car_in=%b car_out=%b | count=%0d available=%0d full=%b empty=%b",
                   $time, car_in, car_out, count, available, full, empty);
    end

endmodule
