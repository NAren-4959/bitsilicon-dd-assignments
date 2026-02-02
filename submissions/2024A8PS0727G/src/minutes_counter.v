module minutes_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       sync_reset,   // User reset button
    input  wire       en,
    input  wire       sec_max_tick, // From seconds counter
    output reg  [7:0] min_count     // CHANGED: 8 bits for 0-99
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min_count <= 0;
        end else if (sync_reset) begin
            min_count <= 0;         // User button clears count
        end else if (en && sec_max_tick) begin
            if (min_count == 99)    // CHANGED: Rollover at 99
                min_count <= 0;
            else
                min_count <= min_count + 1;
        end
    end
endmodule