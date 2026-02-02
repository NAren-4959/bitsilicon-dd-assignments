#include "Vstopwatch_top.h"
#include "verilated.h"
#include <iostream>

// Current simulation time
vluint64_t main_time = 0;

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vstopwatch_top* top = new Vstopwatch_top;

    // Initialize Inputs
    top->clk = 0;
    top->rst_n = 0;
    top->start = 0;
    top->stop = 0;
    top->reset = 0;

    // Simulate for 1000 clock cycles
    while (!Verilated::gotFinish() && main_time < 1000) {
        // Toggle Clock
        top->clk = !top->clk;
        
        // Release Reset at time 10
        if (main_time == 10) top->rst_n = 1;

        // Press Start at time 20
        if (main_time == 20) top->start = 1;
        if (main_time == 22) top->start = 0; // Single cycle pulse

        // Evaluate model
        top->eval();

        // Read Outputs every 10 cycles (on positive edge)
        if (top->clk == 1 && (main_time % 10 == 0)) {
            printf("Time: %02d:%02d | Status: %d\n", 
                   top->minutes, top->seconds, top->status);
        }

        main_time++;
    }

    top->final();
    delete top;
    return 0;
}