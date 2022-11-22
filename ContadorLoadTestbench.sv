`timescale 1ns/1ps
`define TCK 100
`define KMAX 20

module ContLd_sim( );
	reg Ck, Clr, CE, L;
  reg [3:0] I;
 	wire RC;
  wire [3:0] Q;
  integer k;
  
  ContLd UUT(Ck, Clr, CE, L, I, Q, RC);
  
      initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        $timeformat(-9, 0, "ns", 3);
        $monitor("Tempo = %3t: k=%2d Clr=%b Q=%4b RC=%1b", $time, k, Clr, Q, RC);
        #0;
        
        I = 4'b0011;
        CE=0;
        k=-1;
        Ck=0; #(`TCK);
        
        for (k=0; k<=`KMAX; k=k+1) begin
          Ck = 1; #(`TCK/2);
          Ck = 0; #(`TCK/2);
        end // end for
	$finish;
    end //initial
  
  
  always@(*) begin
   
    Clr <=0;
    L <=0;
    if(k>=0 && k<1) Clr <=1;
    if(k>=0 && k<1) L <=3;
    if(k==0) CE<=1;
    if(k==3) CE<= #10 0;
    if(k==3) CE<= #(`TCK - 20) 1;
     if(k==4) CE<= #40 0;
    if(k==5) CE<=1;
  end // always
  

endmodule // end ContLd_sim