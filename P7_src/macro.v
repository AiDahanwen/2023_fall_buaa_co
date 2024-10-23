`define CODE_IDENTIFY   \
	wire [5:0] op = Instr[31:26]; \
	wire [5:0] funct = Instr[5:0]; \
	wire [4:0] rtt = Instr[20:16]; \
	wire [4:0] rss = Instr[25:21]; \
	wire [4:0] rdd = Instr[15:11]; \
	/* R_type*/ \
	wire R_type = (op == 6'b000000); \
	wire add = R_type & (funct == 6'b100000); \
	wire sub = R_type & (funct == 6'b100010); \
	wire and_ = R_type & (funct == 6'b100100); \
	wire sll = R_type & (funct == 6'b000000); \
	wire addu = R_type & (funct == 6'b100001); \
	wire subu = R_type & (funct == 6'b100011); \
	wire or_ = R_type & (funct == 6'b100101); \
	wire slt = R_type & (funct == 6'b101010); \
	wire sltu = R_type & (funct == 6'b101011);\
	wire shamt = sll; \
	/*mult-div*/\
	wire mult = R_type & (funct == 6'b011000);\
	wire multu = R_type & (funct == 6'b011001);\
	wire div = R_type & (funct == 6'b011010);\
	wire divu = R_type & (funct == 6'b011011);\
	wire mfhi = R_type & (funct == 6'b010000);\
	wire mflo = R_type & (funct == 6'b010010);\
	wire mthi = R_type & (funct == 6'b010001);\
	wire mtlo = R_type & (funct == 6'b010011);\
	/* I_type*/ \
	wire ori = (op == 6'b001101); \
	wire addi = (op == 6'b001000); \
	wire andi = (op == 6'b001100);\
	wire lui = (op == 6'b001111); \
	wire addiu = (op == 6'b001001);\
	wire I_type = ori | lui | addiu | addi | andi; \
	/* Write */ \
	wire sw = (op == 6'b101011); \
	wire sh = (op == 6'b101001); \
	wire sb = (op == 6'b101000); \
	wire sc = (op == 6'b111000);\
	wire write = sw | sh | sb | sc; \
	/* Load */ \
	wire lw = (op == 6'b100011); \
	wire lh = (op == 6'b100001); \
	wire lb = (op == 6'b100000); \
	wire lbu = (op == 6'b100100); \
	wire lhu = (op == 6'b100101); \
	wire ll = (op == 6'b110000);\
	wire load = lw | lh | lb | lbu | lhu | ll ; \
	/* Branch */ \
	wire beq = (op == 6'b000100); \
	wire bne = (op == 6'b000101); \
	wire bgezal = (op == 6'b000001) && (rtt == 5'b10001); \
	wire bslt = R_type & (funct == 6'b101100);\
	wire branch = beq | bne | bgezal | bslt; \
	wire branchTwo = beq | bne | bslt; \
	/* Jump */ \
	wire jal = (op == 6'b000011); \
	wire jr = R_type & (funct == 6'b001000); \
	wire jalr = R_type & (funct == 6'b001001); \
	wire j = (op == 6'b000010); \
	wire jump1 = jal | j; \
	wire jump2 = jr | jalr; \
	wire J_write = jal | jalr; \
	wire ra = jal | bgezal;\
	/* CP0 */ \
	wire cop0 = (op == 6'b010000);\
	wire mfc0 = cop0 && (rss == 5'b00000); \
	wire mtc0 = cop0 && (rss == 5'b00100); \
	wire syscall = R_type && (funct == 6'b001100);\
	wire eret = cop0 && (funct == 6'b011000);
	
`define OP_DEFINE   \
	/* ALU_op */ \
	localparam add_op = 5'b00000; \
	localparam sub_op = 5'b00001; \
	localparam or_op  = 5'b00010; \
	localparam lui_op = 5'b00011; \
	localparam sll_op = 5'b00100; \
	localparam and_op = 5'b00101;\
	localparam slt_op = 5'b00110;\
   localparam sltu_op = 5'b00111;\
	localparam mult_op = 5'b01000;\
   localparam multu_op = 5'b01001;\
	localparam div_op = 5'b01010;\
	localparam divu_op = 5'b01011;\
	localparam mfhi_op = 5'b01100;\
	localparam mflo_op = 5'b01101;\
	localparam mthi_op = 5'b01110;\
	localparam mtlo_op = 5'b01111;\
	/* compare_op */ \
	localparam beq_op = 5'b00000; \
	localparam bne_op = 5'b00001; \
	localparam bgezal_op = 5'b00010;\
	localparam bslt_op = 5'b00011;
	
`define DM_BEGIN  32'h0000_0000
`define DM_END    32'h0000_2FFF
`define T0_BEGIN  32'h0000_7F00
`define T0_END    32'h0000_7F0B
`define T1_BEGIN  32'h0000_7F10
`define T1_END    32'h0000_7F1B
`define INT_BEGIN 32'h0000_7F20
`define INT_END   32'h0000_7F23

`define DM_sel    3'b001
`define T0_sel    3'b010
`define T1_sel    3'b011
`define INT_sel   3'b100

`define AdEL    5'd4
`define Int     5'd0
`define AdES    5'd5
`define Syscall 5'd8
`define RI      5'd10
`define Ov      5'd12