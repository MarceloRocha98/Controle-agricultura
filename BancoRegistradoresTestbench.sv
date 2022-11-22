`timescale 1ns/1ps
`define TCK 10
`define KMAX 10

module R4B_sim();
  reg C, Clr, CE, S;
  reg [3:0]I0, I1, Q;
  integer k;
  
  R4B UUT(S, C, CE, Clr, I0, I1, Q);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
    $timeformat(-9, 0, "ns", 3);
    $monitor("Time %t: k=%2d Clr=%b CE=%b => Q=%4b", $time, k, Clr, CE, Q);

    #50;

      for (k=0; k<=`KMAX; k=k+1) begin
            C = 1; #(`TCK/2);
            C = 0; #(`TCK/2);
      end // end for
	$finish;
    
  end // initial
  
    always@(*) begin
   
    Clr <=0;
      if(k==0) S<=0;
      if(k==0) I0 <= 4'b1010;
      if(k==0) I1 <= 4'b1011;
      if(k==9) S <=1'b0;
      
    if(k>=0 && k<1) Clr <=1;
      if(k>1 && k<=6) I0 <=4'b1111;
      if(k>1 && k<=6) I1 <=4'b1110;
    if(k==0) CE<=1;
      if(k>0 && k<7) CE<= #(`TCK) 0;
      if(k==6) CE<= #(`TCK) 1;
      if(k==7) S <= 1;
      if(k==8) I0 <=4'b0001;
      if(k>6) I1<= 4'b0110;

  end // always
  
  
endmodule // R4B_sim