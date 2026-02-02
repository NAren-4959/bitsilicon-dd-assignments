`timescale 1ns/1ps

module tb_stopwatch;

    // Inputs
    reg clk;
    reg rst_n;
    reg start;
    reg stop;
    reg reset;

    // Outputs
    wire [7:0] minutes;
    wire [5:0] seconds;
    wire [1:0] status;

    // Instantiate Top Module
    stopwatch_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .stop(stop),
        .reset(reset),
        .minutes(minutes),
        .seconds(seconds),
        .status(status)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Test Sequence
    initial begin
        $dumpfile("stopwatch.vcd");
        $dumpvars(0, tb_stopwatch);

        rst_n = 0; start = 0; stop = 0; reset = 0;
        #20 rst_n = 1; // Release System Reset
        #10;

        // 1. Start
        start = 1; #10 start = 0;
        #200; // Let it count

        // 2. Pause
        stop = 1; #10 stop = 0;
        #50;

        // 3. Resume
        start = 1; #10 start = 0;
        #200;
        
        // 4. Reset Button
        reset = 1; #10 reset = 0;
        #50;

        $finish;
    end
    
    // Console Monitor
    initial begin
        $monitor("Time=%0t | State=%b | Min=%d | Sec=%d", $time, status, minutes, seconds);
    end

endmodule