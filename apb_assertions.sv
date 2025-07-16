module apb_assertions (
    input logic PCLK,
    input logic PRESETn,

    input logic        PSEL,
    input logic        PENABLE,
    input logic        PWRITE,
    input logic [31:0] PRDATA,
    input logic        PREADY
);

    // Default clocking block
    default clocking cb @(posedge PCLK); endclocking

    // Assertion 1: PENABLE must not be high without PSEL
    apb_enable_without_psel: assert property (
        @(posedge PCLK) disable iff (!PRESETn)
        !(PENABLE && !PSEL)
    ) else $error("Violation: PENABLE went high without PSEL!");

    // Assertion 2: Write operation must occur only when PWRITE is 1
    apb_write_validity: assert property (
        @(posedge PCLK) disable iff (!PRESETn)
        (PSEL && PENABLE && PWRITE) |-> ##1 $stable(PWRITE)
    ) else $error("Violation: Write occurred with invalid PWRITE signal!");

    // Assertion 3: PREADY should always be high
    apb_pready_always: assert property (
        @(posedge PCLK) disable iff (!PRESETn)
        PREADY
    ) else $error("Violation: PREADY should always be 1!");

    // Assertion 4: PRDATA should be stable during read
    apb_prdata_check: assert property (
        @(posedge PCLK) disable iff (!PRESETn)
        (PSEL && !PWRITE) |-> $isunknown(PRDATA) == 0
    ) else $error("Violation: PRDATA was unknown during read!");

endmodule
