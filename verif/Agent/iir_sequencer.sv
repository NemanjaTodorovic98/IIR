`ifndef IIR_SEQUENCER_SV
 `define IIR_SEQUENCER_SV

class iir_sequencer extends uvm_sequencer#(iir_seq_item);

   `uvm_component_utils(iir_sequencer)

   function new(string name = "iir_sequencer", uvm_component parent = null);
      super.new(name,parent);
   endfunction

endclass : iir_sequencer

`endif

