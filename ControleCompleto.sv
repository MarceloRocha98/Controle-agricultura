
// registradores 

module R4B(
  input S, C, CE, Clr,
  input [3:0] I0, I1,
  output[3:0] Q
);
  reg [3:0] qout, q0, q1;
  
  always @(posedge C or posedge Clr) begin
    if(Clr) begin
    	q0<=0; q1<=0;
    end
    else if (~CE) begin
    	q0<=q0; q1<=q1;
    end
    else begin
    	q0<=I0; q1<=I1;
    end
  end // always
   
  always @(*) begin
    case(S)
      1'b0: qout = q0;
      1'b1: qout = q1;
    endcase
  end // always
  
  assign Q = qout;
  
endmodule // R4B

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

// unidade de controle do temporizador
module Temp_uc(
	input Clr, Ck, RC, St,
  	output CE,Ld, R
);
  reg [1:0] Sreg, Snext; // estado atual e estado seguinte
  reg  [3:0] outr ;  // saidas
  
  always @(*) begin
    case(Sreg)
      2'b00: begin // State = 00
        if(~St) begin
          Snext = 2'b00;
         outr = 3'b000;
        end
        
        else begin
            Snext = 2'b01;
        	outr = 3'b010;
        end
        
      end
      
      2'b01: begin // State = 01
        Snext = 2'b10;
        outr = 3'b101;
      end
      
      2'b10: begin // State = 10
        if(~RC) begin
          Snext = 2'b10;
          outr = 3'b101;
        end
        else begin
        	Snext = 2'b00;
          	outr = 3'b100;
        end
      end
      
      default: begin
        Snext = 2'b00;
        outr = 3'b000;
      end
      
    endcase
    
  end // always
  
  always@(posedge Ck or posedge Clr) begin // atualizacao do estado atual
    if(Clr) Sreg <= 2'b00;
    else Sreg <= Snext;
  end
  
  assign {CE, Ld, R} = outr;
//   assign S = Sreg;
  
endmodule // temp_uc

// controle de inicializacao
module Init_FSM(
  input Ck, Clr, St, I1, I2, I3, I4,
  	output O1, O2, O3, O4, H1
);
  reg [2:0] Sreg, Snext; // estado atual e estado seguinte
  reg  [4:0] outr ;  // saidas
  
  always @(*) begin
    case(Sreg)
      3'b000: begin // State = 000
        if(~St) begin
          Snext = 3'b000;
         outr = 5'b00000;
        end
        
        else begin
            Snext = 3'b001;
        	outr = 5'b00000;
        end
        
      end
      
      3'b001: begin // State = 001
        if(~I1) begin
        Snext = 3'b001;
          outr = 5'b10000;
        end
        else if(I1 && I2 && I3 && I4) begin
          Snext = 3'b000;
          outr = 5'b00001;
        end // tudo ok
        else if (I1 && I2 && I3 && ~I4) begin
          Snext = 3'b100;
          outr = 5'b00010;
        end // I1, I2 e I3 ok e i4 n ok
        else if (I1 && I2) begin
          Snext = 3'b011;
          outr = 5'b00100;
        end // i1 e i2 ok
        else begin
        Snext = 3'b010;
        outr = 5'b00000; 	
        end // end else
       
      end // end state 001
      
      3'b010: begin // State = 010
        if(~I1) begin
          Snext = 3'b001;
          outr = 5'b10000;
        end
        else if(~I2) begin
        	Snext = 3'b010;
          	outr = 5'b01000;
        end // end ~I2
        else if(I1 && I2 && I3 && I4) begin
          Snext = 3'b000;
          outr = 5'b00001;
        end // tudo ok
        else if(I1 && I2 && I3 && ~I4) begin
          Snext = 3'b100;
          outr = 5'b00010;
        end // i1,i2 e i3 ok
        else begin
        	Snext = 2'b011;
          	outr = 5'b00100;
        end //end else
        
      end // end state 010
      
      3'b011: begin // State = 011
        if(~I1) begin
          Snext = 3'b001;
          outr = 5'b10000;
        end // end ~I1
        else if(~I2) begin
        	Snext = 3'b010;
          	outr = 5'b01000;
        end // end ~I2
        else if(~I3) begin
        	Snext = 3'b011;
          	outr = 5'b00100;
        end // end ~I3
        else if(I1 && I2 && I3 && I4) begin
          Snext = 3'b000;
          outr = 5'b00001;
        end // tudo ok
        else begin
        	Snext = 3'b100;
          	outr = 5'b00010;
        end // end else
      end // end state 011
        
       3'b100: begin // state 100
          if(~I1) begin
            Snext = 3'b001;
            outr = 5'b10000;
          end // end ~I1
          else if(~I2) begin
              Snext = 3'b010;
              outr = 5'b01000;
          end // end ~I2
          else if(~I3) begin
              Snext = 3'b011;
              outr = 5'b00100;
          end // end ~I3
         else if(~I4) begin
         	Snext = 3'b100;
           	outr = 5'b00010;
         end // end ~I4
          else begin
              Snext = 3'b000;
              outr = 5'b00001;
          end // end else
         	
       end //  end state 100
        
      
      default: begin
        Snext = 3'b000;
        outr = 5'b00000;
      end
      
    endcase
    
  end // always
  
  always@(posedge Ck or posedge Clr) begin // atualizacao do estado atual
    if(Clr) Sreg <= 3'b000;
    else Sreg <= Snext;
  end
  
  assign {O1, O2, O3, O4, H1} = outr;
//   assign S = Sreg;
  
endmodule // temp_uc

// controle de processo
module Process_FSM(
	input Clr, Ck, H1, RC, R,
  	output O5, O6, St, S
);
  reg [1:0] Snext, Sreg;
  reg [3:0] outr; 
  
  always@(*)begin
    case(Sreg)
      2'b00: begin // state 00
        outr = 4'b0000;
        
        if(H1&&~R) Snext = 2'b01;
        else Snext = Sreg;
        
      end //end state 00
      
      2'b01: begin // state 01
        outr = 4'b1010;
        
        if(RC && ~R) Snext = 2'b10;
        else Snext = Sreg;
        
      end //end state 01
      
      2'b10: begin // state 10
        outr = 4'b0011;
        if(RC) Snext = 2'b11;
        else Snext = Sreg;
      end //end state 10
      
      2'b11: begin // state 11
      	outr = 4'b0100;
        Snext = 2'b00;
      end// end state 11
      
    endcase //endcase
      
   end // end always
      
      always@(posedge Ck or posedge Clr) begin
        if (Clr) Sreg<=2'b00;
        else Sreg <=Snext;
      end // end always
      
   assign {O5, O6, St, S} = outr;
      
endmodule // Process_FSM

// controle de funcionamento

module Operation_FSM(
	input Clr, Ck, H1, O6, I5, I6, I7,
  	output O7, O8, O9
);
  reg [2:0] Snext, Sreg;
  reg [2:0] outr;
  parameter [2:0] idle=3'b000, FS1=3'b001, FS2=3'b010, FS3=3'b011, FS4=3'b100;
  
  always @(*) begin
    case (Sreg)
      idle: begin // state 000
        outr = 3'b000;
        if(H1 && ~O6) begin
          Snext = FS1;
        end // h1
        else Snext = Sreg;
      end // end state 000
      
      FS1: begin //  state 001
        if(~O6 && I7) begin
        	Snext = FS2;
          	outr = 3'b000;
        end // ~O6 && I7
        else begin
          	Snext = FS1;
          	outr = 3'b100;
        end // end else
      end // end state 001
      
      FS2: begin // state 010
        if(O6) begin
          	Snext = idle;
          	outr = 3'b000;
        end // O6
        else if(~I7) begin
          	Snext = FS1;
          	outr = 3'b100;
        end // ~I7
        else if(I6) begin
          	Snext = FS3;
          	outr = 3'b000;
        end // I6
        else begin
          	Snext = FS2;
          	outr = 3'b001;
        end // else
        
      end //end state 010
      
      FS3: begin // state 011
        if(O6) begin
          	Snext = idle;
          	outr = 3'b000;
        end // O6
        else if(~I7) begin
          	Snext = FS1;
          	outr = 3'b100;
        end // ~I7
        else if (~I6) begin
          	Snext = FS2;
          	outr = 3'b001;
        end // ~i6
        else if(I5 && I6 && I7) begin
          	Snext = FS4;
          	outr = 3'b000;
        end // I5,I6,I7 ok
        else begin
          	Snext = FS3;
          	outr = 3'b010;
        end // else
        
      end // state 011
      
      FS4: begin // state 100
        if(O6) begin
          	Snext = idle;
          	outr = 3'b000;
        end // O6
        else if(~I7) begin
          	Snext = FS1;
          	outr = 3'b100;
        end // ~I7
        else if (~I6) begin
          	Snext = FS2;
          	outr = 3'b001;
        end // ~i6
        else if(~I5) begin
          	Snext = FS3;
          	outr = 3'b000;
        end // ~I5
        
      end // end state 100
      
    endcase // endcase
  end // end always
  
  
  always @(posedge Ck or posedge Clr) begin
    if(Clr) Sreg <= idle;
    else Sreg <= Snext;
    
  end // end always
  
  
  assign {O7,O8,O9} = outr;
  
  
endmodule // operation fsm







