/*
 *  vga_hardware -- Hardware for vga.
 *
 *  Copyright (C) 2021-2022 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Last update date: 2022.01.19
 *  Description: top module of lcd. 
 */
module lcd(
  input                 sys_clk,    // system clock 50Mhz on board;
  input                 rst_n,      // reset ,low active;
  output  wire          lcd_dclk,   // lcd clock;
  output  wire          lcd_hs,     // lcd horizontal synchronization;
  output  wire          lcd_vs,     // lcd vertical synchronization;  
  output  wire          lcd_de,     // lcd data valid;
  output  wire  [7:0]   lcd_r,      // lcd red;
  output  wire  [7:0]   lcd_g,      // lcd green;
  output  wire  [7:0]   lcd_b       // lcd blue;
);

assign lcd_dclk = ~sys_clk;       // to meet the timing requirements;   

//* tetris_inst
lcd lcd_inst(
  .clk      (video_clk),
  .rst      (~rst_n   ),
  .hs       (lcd_hs   ),
  .vs       (lcd_vs   ),
  .de       (lcd_de   ),
  .rgb_r    (lcd_r    ),
  .rgb_g    (lcd_g    ),
  .rgb_b    (lcd_b    )
);

endmodule