`timescale 1ns/1ps
module apb_slave #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 32)(
    input  logic                  PCLK,
    input  logic                  PRESETn,
    input  logic [ADDR_WIDTH-1:0] PADDR,
    input  logic [DATA_WIDTH-1:0] PWDATA,
    input  logic                  PWRITE,
    input  logic                  PSEL,
    input  logic                  PENABLE,
    output logic [DATA_WIDTH-1:0] PRDATA,
    output logic                  PREADY
);

    // 8 x 32-bit registers (0x00 to 0x1C)
    logic [DATA_WIDTH-1:0] regs [0:7];

    // Always ready (could add delay for realism)
    assign PREADY = 1'b1;

    always_ff @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            for (int i = 0; i < 8; i++) begin
                regs[i] <= 0;
            end
        end else if (PSEL && PENABLE) begin
            if (PWRITE) begin
                regs[PADDR[4:2]] <= PWDATA;
            end
        end
    end

    always_comb begin
        if (PSEL && !PWRITE) begin
            PRDATA = regs[PADDR[4:2]];
        end else begin
            PRDATA = 32'hDEADBEEF;
        end
    end

endmodule
