# APB-Verification

This project demonstrates the **Design and Verification of an APB (Advanced Peripheral Bus) Slave** using Verilog/SystemVerilog. It includes:

-  RTL Design (`apb_slave.sv`)
-  Testbench with tasks (`apb_tb.sv`)
-  Protocol Assertions (`apb_assertions.sv`)
-  Functional Coverage (`apb_coverage.sv`)

---

##  Protocol Summary – AMBA APB

- AMBA APB is a simple **low-power, low-complexity** bus for register-mapped peripherals.
- It uses a **handshake-based protocol** with signals like `PADDR`, `PWDATA`, `PWRITE`, `PSEL`, `PENABLE`, and `PREADY`.

---

##  RTL Design (`apb_slave.sv`)

Implements a slave with 8 x 32-bit registers:
- Responds to both **read and write** operations
- Always ready (`PREADY = 1`)
- Address decoding via `PADDR[4:2]`

---

##  Testbench (`apb_tb.sv`)

- Generates **valid APB read/write transactions**
- Uses `apb_write()` and `apb_read()` tasks
- Writes to registers and reads them back to verify correctness
- `$display` shows the transaction flow

---

##  Assertions (`apb_assertions.sv`)

- Checks protocol correctness:
  - `PENABLE` only asserted when `PSEL` is high
  - `PWRITE` remains stable during a write
  - `PREADY` always high (as per this RTL)
  - `PRDATA` is valid during read

---

##  Functional Coverage (`apb_coverage.sv`)

- Covers:
  - All **8 addresses** (0x00 to 0x1C)
  - Variety of **write data patterns**
  - Both **read and write operations**
- Ensures protocol exercised thoroughly

---

## 🧠 Key Learnings

- Protocol-level DV for AMBA APB
- Assertion-based verification
- Functional coverage using SystemVerilog
- Writing reusable test tasks
- Clean, synthesizable RTL design


