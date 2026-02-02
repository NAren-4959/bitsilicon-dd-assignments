module control_fsm (
    input  wire       clk,
    input  wire       rst_n,      // Async System Reset
    input  wire       sync_reset, // Sync User Reset Button
    input  wire       start,
    input  wire       stop,
    output reg        en,
    output reg  [1:0] status      // 00=IDLE, 01=RUNNING, 10=PAUSED
);

    // State Encoding
    localparam [1:0] IDLE = 2'b00, RUNNING = 2'b01, PAUSED = 2'b10;
    reg [1:0] state, next_state;

    // Output the state directly
    always @(*) status = state;

    // State Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else if (sync_reset) begin
            state <= IDLE; // User reset button forces IDLE
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = state;
        en = 0;

        case (state)
            IDLE: begin
                en = 0;
                if (start) next_state = RUNNING;
            end

            RUNNING: begin
                en = 1;
                if (stop) next_state = PAUSED;
            end

            PAUSED: begin
                en = 0;
                if (start) next_state = RUNNING;
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule