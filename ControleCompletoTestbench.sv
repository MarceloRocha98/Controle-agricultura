
`timescale 1ns/1ps
`define TCK 100
`define KMAX 60


module union_sim( );
	reg Ck, Clr, Start , I1, I2, I3, I4, I5, I6, I7;
  	reg [3:0] V0, V1;
 	wire  Q,CE, Ld, R, O1, O2, O3, O4, O5, O6, H1, RC, St;
    wire[3:0] I;

  integer k;
  
  Init_FSM UUT1(Ck, Clr, Start, I1, I2, I3, I4,O1, O2, O3, O4, H1);
  Process_FSM UUT2(Clr, Ck, H1, RC, R, O5, O6, St, S);
  Operation_FSM UUT3(Clr, Ck, H1, O6, I5, I6, I7, O7, O8, O9);
  
  Temp_uc UUT4(Clr, Ck, RC, St, CE, Ld, R);
  ContLd UUT5(Ck, Clr, CE, Ld, I, Q, RC);
  R4B UUT6(S, Ck, CE, Clr, V0, V1, I);
  
      initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        $timeformat(-9, 0, "ns", 3);
//         $monitor("Tempo = %3t: k=%2d St=%1b Clr=%1b I1=%1b I2=%1b I3=%1b I4=%1b O1=%1b O2=%1b O3=%1b O4=%1b", $time, k, St, Clr,I1, I2, I3, I4, O1, O2, O3, O4, H1);
        #0;
        
        k=-1;
        Ck=0; #(`TCK);
		V0 = 4'b1000;
        V1 = 4'b1100;
        
        for (k=0; k<=`KMAX; k=k+1) begin
          Ck = 1; #(`TCK/2);
          Ck = 0; #(`TCK/2);
        end // end for
	$finish;
    end //initial
  
  always@(*) begin
    Clr <=0;
    Start <=0;
    I1 <=0;
    I2 <=0;
    I3 <=0;
    I4 <=0;
    I5 <=0;
    I6 <=0;
    I7 <=0;
    V0 = 4'b1111;
    V1 = 4'b0110;
    
    if(k==1 ) Clr <=1;
    if(k==3) Start <=1;
    if(k>=5) I1 <=1;
    if(k>=7) I2 <=1;
    if(k>=9) I3<=1;
    if(k>=11) I4<=1;
    
    if(k>=15) I7 <=1;
    if(k>=19) I6<=1;
    if(k>=23) I5<=1;
    
    if(k>=25 && k<=35) I5<=0;
    if(k>=26 && k<=33) I6<=0;
    if(k>=27 && k<=31) I7<=0;
    

  end // always
  
  

endmodule // end ContLd_sim