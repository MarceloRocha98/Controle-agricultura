// Code your testbench here
// or browse Examples

`timescale 1ns/1ps
`define TCK 100
`define KMAX 30

// FALTA FAZER O TESTBENCH DO Init_FSM p validar o modulo

module Operation_FSM_sim( );
	reg Clr, Ck, H1, O6, I5, I6, I7;
 	wire  O7, O8, O9;

  integer k;
  
  Operation_FSM UUT(Clr, Ck, H1, O6, I5, I6, I7, O7, O8, O9);
  
      initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        $timeformat(-9, 0, "ns", 3);
        $monitor("Tempo = %3t: Ck:%1b k=%2d Clr=%1b H1=%1b O6=%1b I5=%1b I6=%1b I7=%1b O7=%1b O8=%1b O9=%1b", $time, Ck, k, Clr, H1, O6, I5, I6, I7, O7, O8, O9);
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
    O6 <=1;
    I5 <=0;
    I6 <=0;
    I7 <=0;
    H1 <=0;
    
    if(k<=1) Clr<=1;
    if(k>=2) Clr <=0;
    if(k>=4) H1<=1;
    if(k>=5) O6<=0;
    
    if(k>=7) I7<=1;
    if(k>=9) I6<=1;
    if(k>=10) I7<=0;
    if(k>=12) I7<=1;
    if(k>=15) I5 <=1;
    
    if(k>=16) I6<=0;
    if(k>=23) I6<=1;
    if(k>=18 && k<=21) I7<=0;
    if(k>=21) I7<=1;
    
    
  end // always
  

endmodule // end ContLd_sim