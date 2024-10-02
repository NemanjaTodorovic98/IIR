`ifndef IIR_SEQ_ITEM_SV
 `define IIR_SEQ_ITEM_SV

   parameter WIDTH = 32;

class iir_seq_item extends uvm_sequence_item;

   rand logic [WIDTH - 1:0] s00_in_tdata;
   logic [3:0] s00_in_tstrb;
   logic s00_in_tlast;
   logic s00_in_tvalid;
   
   logic m00_in_tready;
   logic[WIDTH-1 : 0] m00_out_tdata;
   
   `uvm_object_utils_begin(iir_seq_item)
    `uvm_field_int(s00_in_tdata, UVM_DEFAULT)
    `uvm_field_int(s00_in_tstrb, UVM_DEFAULT)
    `uvm_field_int(s00_in_tlast, UVM_DEFAULT)
    `uvm_field_int(s00_in_tvalid, UVM_DEFAULT)
    `uvm_field_int(m00_in_tready, UVM_DEFAULT)
    `uvm_field_int(m00_out_tdata, UVM_DEFAULT)
   `uvm_object_utils_end

   function new (string name = "iir_seq_item");
      super.new(name);
   endfunction // new

endclass : iir_seq_item

`endif
