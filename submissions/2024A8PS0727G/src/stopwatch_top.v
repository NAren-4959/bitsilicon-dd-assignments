module stopwatch_top (
    input  wire       clk,
    input  wire       rst_n,      // Active-low system reset
    input  wire       start,      // Single-cycle start pulse
    input  wire       stop,       // Single-cycle stop pulse
    input  wire       reset,      // Synchronous reset button
    output wire [7:0] minutes,    // 8 bits for 0-99 range
    output wire [5:0] seconds,    // 0-59 range
    output wire [1:0] status      // 00=IDLE, 01=RUNNING, 10=PAUSED
);

    // Internal Signals
    wire enable_signal;     // From FSM to Counters
    wire max_tick_signal;   // From Seconds -> Minutes
    wire tick_enable;       // 1Hz Pulse
    
    // --- Internal Tick Generation ---
    // PARAMETER: Change '5' to '50000000' before submitting if required, 
    // but keep as 5 for your simulation screenshot.
    parameter TICK_LIMIT = 5; 
    reg [31:0] tick_count;
    reg        tick_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick_count <= 0;
            tick_reg   <= 0;
        end else if (enable_signal) begin
            if (tick_count >= TICK_LIMIT - 1) begin
                tick_count <= 0;
                tick_reg   <= 1;
            end else begin
                tick_count <= tick_count + 1;
                tick_reg   <= 0;
            end
        end
    end
    assign tick_enable = tick_reg;

    // --- Module Instantiations ---
    
    control_fsm fsm_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .sync_reset (reset),    
        .start      (start),
        .stop       (stop),
        .en         (enable_signal),
        .status     (status)
    );

    seconds_counter sec_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .sync_reset (reset),
        .en         (enable_signal),
        .tick       (tick_enable),
        .sec_count  (seconds),
        .max_tick   (max_tick_signal)
    );

    minutes_counter min_inst (
        .clk          (clk),
        .rst_n        (rst_n),
        .sync_reset   (reset),
        .en           (enable_signal),
        .sec_max_tick (max_tick_signal),
        .min_count    (minutes)
    );

endmodule