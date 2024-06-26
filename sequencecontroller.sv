timeunit 1ns;
timeprecision 1ps;
// Code your design here
package typedefs;
    typedef enum logic [2:0] {
        HLT = 3'b000,
        SKZ,
        ADD,
        AND,
        XOR,
        LDA,
        STO,
        JMP
    } opcode_t;

    typedef enum logic [2:0] {
        INST_ADDR = 3'b000,
        INST_FETCH,
        INST_LOAD,
        IDLE,
        OP_ADDR,
        OP_FETCH,
        ALU_OP,
        STORE
    } state_t;
endpackage : typedefs

import typedefs::*;
module seqCntlr (
  				output logic      load_ac ,
                output logic      mem_rd  ,
                output logic      mem_wr  ,
                output logic      inc_pc  ,
                output logic      load_pc ,
                output logic      load_ir ,
                output logic      halt    ,
                input  opcode_t   opcode  , 
                input   logic          zero    ,
                input   logic          clk     ,
                input   logic          rst_ 
);
 
  
  state_t state;
  logic ALUOP;

  always_ff @(posedge clk or negedge rst_) begin
    if(!rst_)
      begin
        state = INST_FETCH;
        load_ac = 0;
		mem_rd  = 0;
		mem_wr =  0;
		inc_pc  = 0;
		load_pc = 0;
		load_ir = 0;
		halt    = 0;
      end
    else
      begin
       case (state)
	INST_ADDR: begin
		load_ac = 0;
		mem_rd  = 0;
		mem_wr =  0;
		inc_pc  = 0;
		load_pc = 0;
		load_ir = 0;
		halt    = 0;
		state = INST_FETCH;
		end
	INST_FETCH: begin
      
		load_ac = 0;
		mem_rd  = 1;
		mem_wr =  0;
		inc_pc  = 0;
		load_pc = 0;
		load_ir = 0;
		halt    = 0;
		state = INST_LOAD;
		end
	INST_LOAD: begin
		load_ac = 0;
		mem_rd  = 1;
		mem_wr =  0;
		inc_pc  = 0;
		load_pc = 0;
		load_ir = 1;
		halt    = 0;
		state = IDLE;
		end
	IDLE: begin
		load_ac = 0;
		mem_rd  = 1;
		mem_wr =  0;
		inc_pc  = 0;
		load_pc = 0;
		load_ir = 1;
		halt    = 0;
		state = OP_ADDR;
		end
	OP_ADDR: begin
		load_ac = 0;
		mem_rd  = 0;
		mem_wr =  0;
		inc_pc  = 1;
		load_pc = 0;
		load_ir = 0;
		halt    = HLT;
		state = OP_FETCH;
		end
	OP_FETCH: begin
		load_ac = 0;
      if((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA))
			ALUOP  = 1;
		else
			ALUOP  = 0;
		mem_rd  = ALUOP;
		mem_wr =  0;
		inc_pc  = 0;
		load_pc = 0;
		load_ir = 0;
		halt    = 0;
		state = ALU_OP;
		end
	ALU_OP: begin
		
		if((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA))
			ALUOP  = 1;
		else
			ALUOP  = 0;
		load_ac = ALUOP;
		mem_rd  = ALUOP;
		mem_wr =  0;
		inc_pc  = SKZ && zero;
		load_pc = JMP;
		load_ir = 0;
		halt    = 0;
		state = STORE;
		end
	STORE: begin
		
		if((opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA))
			ALUOP  = 1;
		else
			ALUOP  = 0;
		load_ac = ALUOP;
		mem_rd  = ALUOP;
		mem_wr =  STO;
		inc_pc  = JMP;
		load_pc = JMP;
		load_ir = 0;
		halt    = 0;
		state = STORE;
		end
	default:
		$display("wrong case is provided");
	endcase
      end
  end

endmodule
