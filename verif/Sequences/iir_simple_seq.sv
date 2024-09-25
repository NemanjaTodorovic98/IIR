`ifndef IIR_SIMPLE_SEQ_SV
 `define IIR_SIMPLE_SEQ_SV

class iir_simple_seq extends iir_base_seq;

   `uvm_object_utils(iir_simple_seq)
   
   int trans_count = 20;

   function new(string name = "iir_seq");
      super.new(name);
   endfunction
   
    virtual task body();
      // simple example - just send one item
      iir_seq_item iir_item;
      // prvi korak kreiranje transakcije
      iir_item = iir_seq_item::type_id::create("iir_item");
      
      for ( int i = 1; i <= trans_count; i++) begin 
          // drugi korak - start
          start_item(iir_item);
          // treci korak priprema
          // po potrebi moguce prosiriti sa npr. inline ogranicenjima
          assert (iir_item.randomize() );
          if(i == trans_count)
            iir_item.s00_in_tlast = 1;
          else
            iir_item.s00_in_tlast = 0;
          iir_item.s00_in_tvalid = 1; 
          // cetvrti korak - finish
          finish_item(iir_item);
       end   
      
   endtask : body

endclass : iir_simple_seq

`endif
