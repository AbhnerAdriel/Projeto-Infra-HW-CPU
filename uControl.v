module uControl(
    input clk,
    input reset,
    input eqf,
    input gtf,
    input ov,
    input div0,
    input [5:0] funct,
    input [5:0] opCode,
    output reg MemCtrl,
    output reg PCCtrl,
    output reg MDCtrl,
    output reg SECtrl,
    output reg ShiftSrc,
    output reg ShiftAmt,
    output reg ShiftMem,
    output reg IRWrite,
    output reg RegWrite,
    output reg ALUOutCtrl,
    output reg EPCCtrl,
    output reg HILOWrite,
    output reg XchgTempWrite,
    output reg [1:0] IorD,
    output reg [1:0] ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [1:0] RegDst,
    output reg [1:0] LSCtrl,
    output reg [1:0] SSCtrl,
    output reg [1:0] ExcptCtrl,
    output reg [1:0] MemAddrCtrl,
    output reg [1:0] MemDataSrc,
    output reg [2:0] ShiftCtrl,
    output reg [2:0] PCSrc,
    output reg [2:0] ALUCtrl,
    output reg [3:0] DataSrc,
    output reg start,
    output reg [5:0] currentState
);

    localparam S_FETCH_ADDR      = 6'd0;
    localparam S_FETCH_WAIT      = 6'd1;
    localparam S_FETCH_LOAD      = 6'd2;
    localparam S_DECODE          = 6'd3;
    localparam S_ALU_EXEC        = 6'd4;
    localparam S_R_WRITE         = 6'd5;
    localparam S_I_WRITE         = 6'd6;
    localparam S_SLT_WRITE       = 6'd7;
    localparam S_SHIFT_LOAD      = 6'd8;
    localparam S_SHIFT_EXEC      = 6'd9;
    localparam S_SHIFT_WAIT      = 6'd10;
    localparam S_SHIFT_WRITE     = 6'd11;
    localparam S_MEM_ADDR        = 6'd12;
    localparam S_MEM_READ        = 6'd13;
    localparam S_MEM_WAIT        = 6'd14;
    localparam S_MEM_LOAD_WRITE  = 6'd15;
    localparam S_MEM_STORE       = 6'd16;
    localparam S_BRANCH          = 6'd17;
    localparam S_JUMP            = 6'd18;
    localparam S_JAL             = 6'd19;
    localparam S_JR              = 6'd20;
    localparam S_MD_START        = 6'd21;
    localparam S_MD_WAIT         = 6'd22;
    localparam S_HILO_SAVE       = 6'd23;
    localparam S_MFHI_WRITE      = 6'd24;
    localparam S_MFLO_WRITE      = 6'd25;
    localparam S_SRAM_ADDR       = 6'd26;
    localparam S_SRAM_READ       = 6'd27;
    localparam S_SRAM_WAIT       = 6'd28;
    localparam S_SRAM_LOAD       = 6'd29;
    localparam S_SRAM_EXEC       = 6'd30;
    localparam S_SRAM_SHIFT_WAIT = 6'd31;
    localparam S_SRAM_WRITE      = 6'd32;
    localparam S_XCHG_READ_RS    = 6'd33;
    localparam S_XCHG_LATCH_RS   = 6'd34;
    localparam S_XCHG_READ_RT    = 6'd35;
    localparam S_XCHG_LATCH_RT   = 6'd36;
    localparam S_XCHG_WRITE_RT   = 6'd37;
    localparam S_XCHG_WRITE_RS   = 6'd38;
    localparam S_EXC_OPCODE      = 6'd39;
    localparam S_EXC_OPCODE_WAIT = 6'd40;
    localparam S_EXC_OVERFLOW    = 6'd41;
    localparam S_EXC_OVF_WAIT    = 6'd42;
    localparam S_EXC_DIV0        = 6'd43;
    localparam S_EXC_DIV0_WAIT   = 6'd44;
    localparam S_EXC_SET_PC      = 6'd45;
    localparam S_RTE             = 6'd46;
    localparam S_MEM_CAPTURE     = 6'd47;
    localparam S_SRAM_CAPTURE    = 6'd48;
    localparam S_XCHG_WAIT_RS    = 6'd49;
    localparam S_XCHG_WAIT_RT    = 6'd50;
    localparam S_EXC_CAPTURE     = 6'd51;

    localparam ALU_LOAD = 3'b000;
    localparam ALU_ADD  = 3'b001;
    localparam ALU_SUB  = 3'b010;
    localparam ALU_AND  = 3'b011;
    localparam ALU_CMP  = 3'b111;

    localparam ADD  = {1'b0, 6'h20};
    localparam ANDD = {1'b0, 6'h24};
    localparam DIV  = {1'b0, 6'h1a};
    localparam MULT = {1'b0, 6'h18};
    localparam JR   = {1'b0, 6'h08};
    localparam MFHI = {1'b0, 6'h10};
    localparam MFLO = {1'b0, 6'h12};
    localparam SLL  = {1'b0, 6'h00};
    localparam SLLV = {1'b0, 6'h04};
    localparam SLT  = {1'b0, 6'h2a};
    localparam SRA  = {1'b0, 6'h03};
    localparam SRAV = {1'b0, 6'h07};
    localparam SUB  = {1'b0, 6'h22};
    localparam XCHG = {1'b0, 6'h05};
    localparam RTE  = {1'b0, 6'h13};
    localparam SRL  = {1'b0, 6'h02};

    localparam ADDI = {1'b1, 6'h08};
    localparam BEQ  = {1'b1, 6'h04};
    localparam BNE  = {1'b1, 6'h05};
    localparam SRAM = {1'b1, 6'h01};
    localparam LB   = {1'b1, 6'h20};
    localparam LUI  = {1'b1, 6'h0f};
    localparam LW   = {1'b1, 6'h23};
    localparam SB   = {1'b1, 6'h28};
    localparam SW   = {1'b1, 6'h2b};

    localparam J    = {1'b1, 6'h02};
    localparam JAL  = {1'b1, 6'h03};

    wire [6:0] op = (opCode == 6'b000000) ? {1'b0, funct} : {1'b1, opCode};

    reg [5:0] nextState;
    reg [5:0] mdCounter;

    initial begin
        currentState = S_FETCH_ADDR;
        mdCounter = 6'd0;
        MemCtrl = 1'b0;
        PCCtrl = 1'b0;
        MDCtrl = 1'b0;
        SECtrl = 1'b0;
        ShiftSrc = 1'b0;
        ShiftAmt = 1'b0;
        ShiftMem = 1'b0;
        IRWrite = 1'b0;
        RegWrite = 1'b0;
        ALUOutCtrl = 1'b0;
        EPCCtrl = 1'b0;
        HILOWrite = 1'b0;
        XchgTempWrite = 1'b0;
        IorD = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b00;
        RegDst = 2'b00;
        LSCtrl = 2'b00;
        SSCtrl = 2'b00;
        ExcptCtrl = 2'b00;
        MemAddrCtrl = 2'b00;
        MemDataSrc = 2'b00;
        ShiftCtrl = 3'b000;
        PCSrc = 3'b000;
        ALUCtrl = ALU_LOAD;
        DataSrc = 4'b0000;
        start = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currentState <= S_FETCH_ADDR;
            mdCounter <= 6'd0;
        end else begin
            currentState <= nextState;

            if (currentState == S_MD_START)
                mdCounter <= 6'd0;
            else if (currentState == S_MD_WAIT && mdCounter < 6'd40)
                mdCounter <= mdCounter + 6'd1;
        end
    end

    always @* begin
        MemCtrl = 1'b0;
        PCCtrl = 1'b0;
        MDCtrl = 1'b0;
        SECtrl = 1'b0;
        ShiftSrc = 1'b0;
        ShiftAmt = 1'b0;
        ShiftMem = 1'b0;
        IRWrite = 1'b0;
        RegWrite = 1'b0;
        ALUOutCtrl = 1'b0;
        EPCCtrl = 1'b0;
        HILOWrite = 1'b0;
        XchgTempWrite = 1'b0;
        IorD = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b00;
        RegDst = 2'b00;
        LSCtrl = 2'b00;
        SSCtrl = 2'b00;
        ExcptCtrl = 2'b00;
        MemAddrCtrl = 2'b00;
        MemDataSrc = 2'b00;
        ShiftCtrl = 3'b000;
        PCSrc = 3'b000;
        ALUCtrl = ALU_LOAD;
        DataSrc = 4'b0000;
        start = 1'b0;
        nextState = currentState;

        case (currentState)
            S_FETCH_ADDR: begin
                IorD = 2'b00;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b01;
                ALUCtrl = ALU_ADD;
                nextState = S_FETCH_WAIT;
            end

            S_FETCH_WAIT: begin
                IorD = 2'b00;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b01;
                ALUCtrl = ALU_ADD;
                nextState = S_FETCH_LOAD;
            end

            S_FETCH_LOAD: begin
                IorD = 2'b00;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b01;
                ALUCtrl = ALU_ADD;
                PCSrc = 3'b000;
                PCCtrl = 1'b1;
                IRWrite = 1'b1;
                nextState = S_DECODE;
            end

            S_DECODE: begin
                SECtrl = 1'b1;
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b11;
                ALUCtrl = ALU_ADD;
                ALUOutCtrl = 1'b1;

                case (op)
                    ADD, ANDD, SUB, ADDI: nextState = S_ALU_EXEC;
                    SLT:                  nextState = S_SLT_WRITE;
                    SLL, SLLV, SRA, SRAV, SRL: nextState = S_SHIFT_LOAD;
                    LB, LW, SB, SW:       nextState = S_MEM_ADDR;
                    BEQ, BNE:             nextState = S_BRANCH;
                    J:                    nextState = S_JUMP;
                    JAL:                  nextState = S_JAL;
                    JR:                   nextState = S_JR;
                    MULT, DIV:            nextState = S_MD_START;
                    MFHI:                 nextState = S_MFHI_WRITE;
                    MFLO:                 nextState = S_MFLO_WRITE;
                    LUI:                  nextState = S_I_WRITE;
                    SRAM:                 nextState = S_SRAM_ADDR;
                    XCHG:                 nextState = S_XCHG_READ_RS;
                    RTE:                  nextState = S_RTE;
                    default:              nextState = S_EXC_OPCODE;
                endcase
            end

            S_ALU_EXEC: begin
                ALUSrcA = 2'b01;
                ALUSrcB = (op == ADDI) ? 2'b10 : 2'b00;
                SECtrl = (op == ADDI);

                case (op)
                    ADD, ADDI: ALUCtrl = ALU_ADD;
                    SUB:       ALUCtrl = ALU_SUB;
                    ANDD:      ALUCtrl = ALU_AND;
                    default:   ALUCtrl = ALU_LOAD;
                endcase

                ALUOutCtrl = 1'b1;

                if ((op == ADD || op == ADDI || op == SUB) && ov)
                    nextState = S_EXC_OVERFLOW;
                else if (op == ADDI)
                    nextState = S_I_WRITE;
                else
                    nextState = S_R_WRITE;
            end

            S_R_WRITE: begin
                RegDst = 2'b01;
                DataSrc = 4'b0000;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_I_WRITE: begin
                RegDst = 2'b00;
                RegWrite = 1'b1;
                if (op == LUI)
                    DataSrc = 4'b0110;
                else
                    DataSrc = 4'b0000;
                nextState = S_FETCH_ADDR;
            end

            S_SLT_WRITE: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b00;
                ALUCtrl = ALU_CMP;
                RegDst = 2'b01;
                DataSrc = 4'b0100;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_SHIFT_LOAD: begin
                ShiftSrc = !(op == SLLV || op == SRAV);
                ShiftAmt = (op == SLL || op == SRA || op == SRL);
                ShiftCtrl = 3'b001;
                nextState = S_SHIFT_EXEC;
            end

            S_SHIFT_EXEC: begin
                ShiftSrc = !(op == SLLV || op == SRAV);
                ShiftAmt = (op == SLL || op == SRA || op == SRL);
                if (op == SLL || op == SLLV)
                    ShiftCtrl = 3'b010;
                else if (op == SRA || op == SRAV)
                    ShiftCtrl = 3'b100;
                else
                    ShiftCtrl = 3'b011;
                nextState = S_SHIFT_WAIT;
            end

            S_SHIFT_WAIT: begin
                ShiftSrc = !(op == SLLV || op == SRAV);
                ShiftAmt = (op == SLL || op == SRA || op == SRL);
                ShiftCtrl = 3'b000;
                nextState = S_SHIFT_WRITE;
            end

            S_SHIFT_WRITE: begin
                RegDst = 2'b01;
                DataSrc = 4'b1000;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_MEM_ADDR: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b10;
                SECtrl = 1'b1;
                ALUCtrl = ALU_ADD;
                ALUOutCtrl = 1'b1;
                nextState = S_MEM_READ;
            end

            S_MEM_READ: begin
                IorD = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_MEM_WAIT;
            end

            S_MEM_WAIT: begin
                IorD = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_MEM_CAPTURE;
            end

            S_MEM_CAPTURE: begin
                IorD = 2'b10;
                MemCtrl = 1'b0;
                if (op == LB || op == LW)
                    nextState = S_MEM_LOAD_WRITE;
                else
                    nextState = S_MEM_STORE;
            end

            S_MEM_LOAD_WRITE: begin
                RegDst = 2'b00;
                DataSrc = 4'b0001;
                LSCtrl = (op == LB) ? 2'b00 : 2'b10;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_MEM_STORE: begin
                IorD = 2'b10;
                MemCtrl = 1'b1;
                SSCtrl = (op == SB) ? 2'b00 : 2'b10;
                nextState = S_FETCH_ADDR;
            end

            S_BRANCH: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b00;
                ALUCtrl = ALU_CMP;
                PCSrc = 3'b001;
                PCCtrl = ((op == BEQ && eqf) || (op == BNE && !eqf));
                nextState = S_FETCH_ADDR;
            end

            S_JUMP: begin
                PCSrc = 3'b010;
                PCCtrl = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_JAL: begin
                PCSrc = 3'b010;
                PCCtrl = 1'b1;
                RegDst = 2'b11;
                DataSrc = 4'b1001;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_JR: begin
                ALUSrcA = 2'b01;
                ALUCtrl = ALU_LOAD;
                PCSrc = 3'b000;
                PCCtrl = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_MD_START: begin
                MDCtrl = (op == DIV);
                start = 1'b1;
                nextState = S_MD_WAIT;
            end

            S_MD_WAIT: begin
                MDCtrl = (op == DIV);
                if (op == DIV && div0)
                    nextState = S_EXC_DIV0;
                else if (mdCounter >= 6'd40)
                    nextState = S_HILO_SAVE;
                else
                    nextState = S_MD_WAIT;
            end

            S_HILO_SAVE: begin
                MDCtrl = (op == DIV);
                HILOWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_MFHI_WRITE: begin
                RegDst = 2'b01;
                DataSrc = 4'b0010;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_MFLO_WRITE: begin
                RegDst = 2'b01;
                DataSrc = 4'b0011;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_SRAM_ADDR: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b10;
                SECtrl = 1'b1;
                ALUCtrl = ALU_ADD;
                ALUOutCtrl = 1'b1;
                nextState = S_SRAM_READ;
            end

            S_SRAM_READ: begin
                IorD = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_SRAM_WAIT;
            end

            S_SRAM_WAIT: begin
                IorD = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_SRAM_CAPTURE;
            end

            S_SRAM_CAPTURE: begin
                IorD = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_SRAM_LOAD;
            end

            S_SRAM_LOAD: begin
                ShiftSrc = 1'b1;
                ShiftMem = 1'b1;
                ShiftCtrl = 3'b001;
                nextState = S_SRAM_EXEC;
            end

            S_SRAM_EXEC: begin
                ShiftSrc = 1'b1;
                ShiftMem = 1'b1;
                ShiftCtrl = 3'b100;
                nextState = S_SRAM_SHIFT_WAIT;
            end

            S_SRAM_SHIFT_WAIT: begin
                ShiftSrc = 1'b1;
                ShiftMem = 1'b1;
                ShiftCtrl = 3'b000;
                nextState = S_SRAM_WRITE;
            end

            S_SRAM_WRITE: begin
                RegDst = 2'b00;
                DataSrc = 4'b1000;
                RegWrite = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_XCHG_READ_RS: begin
                MemAddrCtrl = 2'b01;
                MemCtrl = 1'b0;
                nextState = S_XCHG_WAIT_RS;
            end

            S_XCHG_WAIT_RS: begin
                MemAddrCtrl = 2'b01;
                MemCtrl = 1'b0;
                nextState = S_XCHG_LATCH_RS;
            end

            S_XCHG_LATCH_RS: begin
                MemAddrCtrl = 2'b01;
                MemCtrl = 1'b0;
                XchgTempWrite = 1'b1;
                nextState = S_XCHG_READ_RT;
            end

            S_XCHG_READ_RT: begin
                MemAddrCtrl = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_XCHG_WAIT_RT;
            end

            S_XCHG_WAIT_RT: begin
                MemAddrCtrl = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_XCHG_LATCH_RT;
            end

            S_XCHG_LATCH_RT: begin
                MemAddrCtrl = 2'b10;
                MemCtrl = 1'b0;
                nextState = S_XCHG_WRITE_RT;
            end

            S_XCHG_WRITE_RT: begin
                MemAddrCtrl = 2'b10;
                MemDataSrc = 2'b01;
                MemCtrl = 1'b1;
                nextState = S_XCHG_WRITE_RS;
            end

            S_XCHG_WRITE_RS: begin
                MemAddrCtrl = 2'b01;
                MemDataSrc = 2'b10;
                MemCtrl = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_EXC_OPCODE: begin
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b01;
                ALUCtrl = ALU_SUB;
                EPCCtrl = 1'b1;
                IorD = 2'b11;
                ExcptCtrl = 2'b00;
                nextState = S_EXC_OPCODE_WAIT;
            end

            S_EXC_OPCODE_WAIT: begin
                IorD = 2'b11;
                ExcptCtrl = 2'b00;
                nextState = S_EXC_CAPTURE;
            end

            S_EXC_OVERFLOW: begin
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b01;
                ALUCtrl = ALU_SUB;
                EPCCtrl = 1'b1;
                IorD = 2'b11;
                ExcptCtrl = 2'b01;
                nextState = S_EXC_OVF_WAIT;
            end

            S_EXC_OVF_WAIT: begin
                IorD = 2'b11;
                ExcptCtrl = 2'b01;
                nextState = S_EXC_CAPTURE;
            end

            S_EXC_DIV0: begin
                ALUSrcA = 2'b00;
                ALUSrcB = 2'b01;
                ALUCtrl = ALU_SUB;
                EPCCtrl = 1'b1;
                IorD = 2'b11;
                ExcptCtrl = 2'b10;
                nextState = S_EXC_DIV0_WAIT;
            end

            S_EXC_DIV0_WAIT: begin
                IorD = 2'b11;
                ExcptCtrl = 2'b10;
                nextState = S_EXC_CAPTURE;
            end

            S_EXC_CAPTURE: begin
                IorD = 2'b11;
                nextState = S_EXC_SET_PC;
            end

            S_EXC_SET_PC: begin
                LSCtrl = 2'b00;
                PCSrc = 3'b011;
                PCCtrl = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            S_RTE: begin
                PCSrc = 3'b100;
                PCCtrl = 1'b1;
                nextState = S_FETCH_ADDR;
            end

            default: begin
                nextState = S_FETCH_ADDR;
            end
        endcase
    end
endmodule
