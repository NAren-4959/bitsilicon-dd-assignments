// seconds counter
module seconds_counter(
  input wire clk,
  input wire rst_n, // Active low reset
  input wire en, // signal from FSM saying the clock moves
  input wire tick, // seconds tick
  output reg[5:0] sec_count, // 0-59
  output wire max_tick // tells mintue counter to move
);
  assign max_tick = (sec_count == 59 && tick && en);
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sec_count<=0;
    end else if( en && tick ) begin
      if (sec_count==59)
        sec_count<=0;
      else
        sec_count<=sec_count+1;
    end
  end
endmodule
      