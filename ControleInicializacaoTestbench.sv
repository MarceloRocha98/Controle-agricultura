
`timescale 1ns/1ps
`define TCK 100
`define KMAX 30



module Init_FSM_sim( );
	reg Ck, Clr, St, I1, I2, I3, I4;
 	wire O1, O2, O3, O4, H1;

  integer k;
  
  Init_FSM UUT(Ck, Clr, St, I1, I2, I3, I4,O1, O2, O3, O4, H1);
  
      initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        $timeformat(-9, 0, "ns", 3);
        $monitor("Tempo = %3t: k=%2d St=%1b Clr=%1b I1=%1b I2=%1b I3=%1b I4=%1b O1=%1b O2=%1b O3=%1b O4=%1b", $time, k, St, Clr,I1, I2, I3, I4, O1, O2, O3, O4, H1);
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
    St <=0;
    I1 <=0;
    I2 <=0;
    I3 <=0;
    I4 <=0;
    
    if(k>=0 && k<1) St <=1;
    if(k==2) St <= 0;
    if(k==3) I1 <=1;
    if(k>=9) I2 <= 1;
    if(k==6) I1<=0;
    if(k>=7) I1<=1;
    if(k>=11) I3 <=1;
    if(k>=13) I4<=1;
    if(k==17) St <=1;
    if(k==20) St<=0;
  end // always
  

endmodule // end ContLd_sim