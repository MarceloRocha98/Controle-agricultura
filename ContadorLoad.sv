// contador com load
module ContLd(
  input Ck, Clr, CE, L,
  input [3:0] I,
  output [3:0] Q,
  output RC
);
  reg [3:0] qr;
  
  always@(posedge Ck or posedge Clr) begin
    if(Clr) qr <=4'b1111;
    else if (~CE) qr<=qr;
    else if (L) qr <= I; 
    else qr<= qr-1;
  end
  
  assign RC = CE & (Q == 4'b0000);
  assign Q = qr;
  
  
endmodule // end ContLd