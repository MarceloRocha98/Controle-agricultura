`timescale 1ns/1ps
`define TCK 100
`define KMAX 20

module Temp_uc_sim( );
	reg Ck, RC, St, Clr;
 	wire Ld, R, CE;

  integer k;
  
  Temp_uc UUT(Clr, Ck, RC, St, CE, Ld, R);
  
      initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        $timeformat(-9, 0, "ns", 3);
        $monitor("Tempo = %3t: k=%2d St=%1b Ld=%1b R=%1b", $time, k, St, Ld, R);
        #0;
        
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
 	RC <=0;
    St <=0;
    if(k>=0 && k<1) St <=1;
    if(k==2) St <= 0;
    if(k==10) RC <= #(`TCK - 20) 1;
    if(k==12) RC<= #40 0;
    if(k==14) St<=1;
    if(k==17) St<=0;
    if(k==18) RC<=1;
  end // always
  

endmodule // end ContLd_sim