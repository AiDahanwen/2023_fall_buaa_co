`define CODE_IDENTIFY   \
	wire [5:0] op = Instr[31:26]; \
	wire [5:0] funct = Instr[5:0]; \
	wire [4:0] rtt = Instr[20:16]; \
	/* R_type*/ \
	wire R_type = (op == 6'b000000); \
	wire add = R_type & (funct == 6'b100000); \
	wire sub = R_type & (funct == 6'b100010); \
	wire sll = R_type & (funct == 6'b000000); \
	wire addu = R_type & (funct == 6'b100001); \
	wire shamt = sll; \
	/* I_type*/ \
	wire ori = (op == 6'b001101); \
	wire addi = (op == 6'b001000); \
	wire lui = (op == 6'b001111); \
	wire addiu = (op == 6'b001001);\
	wire I_type = ori | lui | addiu | addi; \
	/* Write */ \
	wire sw = (op == 6'b101011); \
	wire sh = (op == 6'b101001); \
	wire sb = (op == 6'b101000); \
	wire write = sw | sh | sb; \
	/* Load */ \
	wire lw = (op == 6'b100011); \
	wire lh = (op == 6'b100001); \
	wire lb = (op == 6'b100000); \
	wire lbu = (op == 6'b100100); \
	wire lhu = (op == 6'b100101); \
	wire load = lw | lh | lb | lbu | lhu; \
	wire half = lh | lhu | sh; \
	wire bytes = lb | lbu | sb; \
	/* Branch */ \
	wire beq = (op == 6'b000100); \
	wire bne = (op == 6'b000101); \
	wire bgezal = (op == 6'b000001) && (rtt == 5'b10001); \
	wire branch = beq | bne | bgezal; \
	/* Jump*/ \
	wire jal = (op == 6'b000011); \
	wire jr = R_type & (funct == 6'b001000); \
	wire jalr = R_type & (funct == 6'b001001); \
	wire j = (op == 6'b000010); \
	wire jump1 = jal | j; \
	wire jump2 = jr | jalr; \
	wire J_write = jal | jalr; \
	wire ra = jal | bgezal;
	
`define OP_DEFINE   \
	/* ALU_op */ \
	localparam add_op = 5'b00000; \
	localparam addi_op = 5'b00000; \
	localparam addiu_op = 5'b00000; \
	localparam sub_op = 5'b00001; \
	localparam sw_op = 5'b00000; \
	localparam lw_op = 5'b00000; \
	localparam sll_op = 5'b00100; \
	localparam or_op = 5'b00010; \
	localparam lui_op = 5'b00011; \
	/* compare_op */ \
	localparam beq_op = 5'b00000; \
	localparam bne_op = 5'b00001; \
	localparam bgezal_op = 5'b00010;