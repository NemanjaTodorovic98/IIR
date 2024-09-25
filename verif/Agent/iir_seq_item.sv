`ifndef IIR_SEQ_ITEM_SV
 `define IIR_SEQ_ITEM_SV

class iir_seq_item extends uvm_sequence_item;

   rand logic [31:0] s00_in_tdata;
   logic [3:0] s00_in_tstrb;
   logic s00_in_tlast;
   logic s00_in_tvalid;
   
   logic m00_in_tready;
   
   `uvm_object_utils_begin(iir_seq_item)
   `uvm_object_utils_end

   function new (string name = "iir_seq_item");
      super.new(name);
   endfunction // new

endclass : iir_seq_item

`endif
