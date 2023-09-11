`timescale 1ns / 1ps
module lab3_example(
    input button,
    output [7:0] led,
    input sys_clkn,
    input sys_clkp  
    );

    reg [2:0] light_1 = 3'b001;
    reg [2:0] light_2 = 3'b100;
    reg [1:0] light_3 = 2'b10;
    reg push_button = 0;
    reg [7:0] led_register = 0;
    reg [3:0] button_reg;    
    wire clk;
    reg [31:0] clkdiv;
    reg [31:0] t=0;
    reg slow_clk;
    reg [23:0] Time_const=1;
    reg [7:0] counter;              
 
localparam Red = 3'b100;
localparam Green = 3'b001;
localparam Yellow = 3'b010; 
localparam Off = 2'b10;   
localparam On = 2'b01; 

    IBUFGDS osc_clk(
        .O(clk),
        .I(sys_clkp),
        .IB(sys_clkn)
    );
    
initial begin
    clkdiv = 0;
    slow_clk = 0;
end
      

assign led={light_3,light_2,light_1};
    
always @(posedge clk) begin
    push_button <= button;
    t<=t+1'b1;
        case (light_1)
            Red: begin
                if (t==9*Time_const && light_3 == On) begin
                    light_2 <= Green;
                    light_3 <= Off;
                    t<=0;
                end
                if (t==9*Time_const && light_3 == Off ) begin
                    light_2 <= Yellow;
                end
                if (t==14*Time_const) begin
                    if (push_button==0) begin
                        light_1 <= Green;
                        light_2 <= Red;
                        t<=0;
                    end
                    else begin
                        light_2 <= Red;
                        light_3 <= On;
                    end    
                end
                if (t==24*Time_const) begin
                    light_3 <= Off;
                    //push_button<=Off;
                    light_1 <= Green;
                    t<=0;
                end
            end
            Green: begin
                if (t==9*Time_const) begin
                    light_1 <=Yellow;
                    t<=0;
                end
            end
            Yellow: begin
                if (t==4*Time_const) begin
                    if (push_button==0) begin
                        light_1 <=Red;
                        light_2 <= Green;
                        t<=0;
                    end
                    else begin
                        light_1 <=Red;
                        light_3 <= On;
                        t <=0;
                    end    
                end
  
            end
      endcase            
end
         
    
endmodule
