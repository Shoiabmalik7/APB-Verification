module apb_coverage (
  input logic        PCLK,
  input logic        PRESETn,
  input logic        PSEL,
  input logic        PENABLE,
  input logic        PWRITE,
  input logic [3:0]  PADDR,
  input logic [31:0] PWDATA
);

  // Clocking block
  default clocking cb @(posedge PCLK); endclocking

  // Covergroup definition
  covergroup apb_cov @(posedge PCLK);
    // Cover read and write operations
    cp_rw_type : coverpoint PWRITE {
      bins write = {1};
      bins read  = {0};
    }

    // Cover address range (only when valid transaction)
    cp_address : coverpoint PADDR iff (PSEL && PENABLE) {
      bins addr_bins[] = {[0:7]};  // 8 word addresses (0x00, 0x04, ..., 0x1C)
    }

    // Cover diverse data patterns
    cp_data : coverpoint PWDATA iff (PSEL && PENABLE && PWRITE) {
      bins all_zeros = {32'h00000000};
      bins all_ones  = {32'hFFFFFFFF};
      bins pattern1  = {32'hCAFEBABE};
      bins pattern2  = {32'h12345678};
      bins others    = default;
    }
  endgroup

  // Instantiate and sample the covergroup
  apb_cov cg_inst = new();

  always @(posedge PCLK)
    if (PRESETn) cg_inst.sample();

endmodule
