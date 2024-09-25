`ifndef IIR_TEST_PKG_SV
 `define IIR_TEST_PKG_SV

package iir_test_pkg;

   import uvm_pkg::*;      // import the UVM library   
 `include "uvm_macros.svh" // Include the UVM macros

   import iir_agent_pkg::*;
   import iir_seq_pkg::*;

 `include "test_base.sv"
 `include "test_simple.sv"
 `include "test_simple_2.sv"
 
endpackage : iir_test_pkg
`include "iir_if.sv"  

`endif

