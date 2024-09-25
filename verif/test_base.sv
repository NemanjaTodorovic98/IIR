`ifndef TEST_BASE_SV
 `define TEST_BASE_SV

 class test_base extends uvm_test;

   `uvm_component_utils(test_base)

   iir_driver drv;
   iir_sequencer seqr;
   iir_seq_item seq_item1;
   function new(string name = "test_base", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      drv = iir_driver::type_id::create("drv", this);      
      seqr = iir_sequencer::type_id::create("seqr", this);      
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction : connect_phase

endclass : test_base

`endif
