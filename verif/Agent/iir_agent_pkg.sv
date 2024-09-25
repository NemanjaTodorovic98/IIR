`ifndef IIR_AGENT_PKG
`define IIR_AGENT_PKG

package iir_agent_pkg;
 
   import uvm_pkg::*;
   `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////
   `include "iir_seq_item.sv"
   `include "iir_sequencer.sv"
   `include "iir_monitor.sv"
   `include "iir_driver.sv"

endpackage

`endif



