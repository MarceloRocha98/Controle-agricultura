
`timescale 1ns/1ps
`define TCK 100
`define KMAX 13



module Process_FSM_sim( );
	reg Clr, Ck, H1, RC, R;
 	wire O5, O6, St, S;

  integer k;
  
  Process_FSM UUT(Clr, Ck, H1, RC, R, O5, O6, St, S);
  
      initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1);
        $timeformat(-9, 0, "ns", 3);
        $monitor("Tempo = %3t: k=%2d St=%1b Clr=%1b H1=%1b RC=%1b R=%1b O5=%1b O6=%1b St=%1b S=%1b", $time, k, St, Clr, Ck, H1, RC, R, O5, O6, St, S);
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
    H1 <=0;
    RC <=0;
    R <=0;
    
    if(k==1) Clr<=1;
    if(k>=2) Clr <=0;
    
    if(k>=4) H1 <=1;
    if(k==5) H1<=0;
    
    if(k>=6) R<=1;
    
    if(k>=8) RC <=1;
    if(k>=8) R <=0;

    if(k==8) RC <= #(`TCK - 20) 0;
    
    if(k==12) RC<=1;
    if(k==12) R<=0;
    
    
    
  end // always
  

endmodule // end ContLd_sim