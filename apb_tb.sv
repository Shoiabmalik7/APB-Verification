`timescale 1ns/1ps
module apb_tb;

  // Clock and Reset
  logic PCLK;
  logic PRESETn;

  // APB Signals
  logic [3:0]  PADDR;
  logic [31:0] PWDATA;
  logic        PWRITE;
  logic        PSEL;
  logic        PENABLE;
  logic [31:0] PRDATA;
  logic        PREADY;

  // Instantiate the DUT
  apb_slave dut (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PWRITE(PWRITE),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PRDATA(PRDATA),
    .PREADY(PREADY)
  );

  // Clock Generation
  initial PCLK = 0;
  always #5 PCLK = ~PCLK; // 100 MHz clock

  // Reset
  initial begin
    PRESETn = 0;
    #20;
    PRESETn = 1;
  end

  // APB Write Task
  task apb_write(input [3:0] addr, input [31:0] data);
    begin
      @(posedge PCLK);
      PADDR   = addr;
      PWDATA  = data;
      PWRITE  = 1;
      PSEL    = 1;
      PENABLE = 0;

      @(posedge PCLK);
      PENABLE = 1;

      @(posedge PCLK);
      PSEL    = 0;
      PENABLE = 0;
      $display("Write: Addr = %0h, Data = %0h", addr, data);
    end
  endtask

  // APB Read Task
  task apb_read(input [3:0] addr);
    begin
      @(posedge PCLK);
      PADDR   = addr;
      PWRITE  = 0;
      PSEL    = 1;
      PENABLE = 0;

      @(posedge PCLK);
      PENABLE = 1;

      @(posedge PCLK);
      PSEL    = 0;
      PENABLE = 0;
      $display("Read: Addr = %0h, Data = %0h", addr, PRDATA);
    end
  endtask

  // Test Sequence
  initial begin
    // Initialize inputs
    PADDR = 0; PWDATA = 0; PWRITE = 0;
    PSEL = 0; PENABLE = 0;

    // Wait for reset to complete
    @(posedge PRESETn);

    // Write to 3 registers
    apb_write(4'h0, 32'hCAFEBABE);
    apb_write(4'h4, 32'hFACEFACE);
    apb_write(4'h8, 32'h12345678);

    // Read back
    apb_read(4'h0);
    apb_read(4'h4);
    apb_read(4'h8);

    #20;
    $finish;
  end

endmodule
