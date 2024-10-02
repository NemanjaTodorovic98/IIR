`ifndef IIR_SIMPLE_SEQ_SV
 `define IIR_SIMPLE_SEQ_SV

class iir_simple_seq extends iir_base_seq;

   `uvm_object_utils(iir_simple_seq)
   
   int trans_count = 10;
   logic [31:0] sys_input[0:9] =
//   '{32'h00100000,
//     32'h00200000,
//     32'h00300000,
//     32'h00400000,
//     32'h00500000,
//     32'h00600000,
//     32'h00700000,
//     32'h00800000,
//     32'h00900000,
//     32'h00A00000};
          '{32'b00000000000001000111111101101110,
            32'b00000000000010001010001000000000,
            32'b00000000000011000001001001010101,
            32'b00000000000011101000100101101111,
            32'b00000000000011111101010001100110,
            32'b00000000000011111101100010001011,
            32'b00000000000011101001010110000111,
            32'b00000000000011000010010101101000,
            32'b00000000000010001011101010000011,
            32'b00000000000001001001101101100111};
   function new(string name = "iir_simple_seq");
      super.new(name);
   endfunction
   
    virtual task body();
      // simple example - just send one item
      iir_seq_item iir_item;
      
      
      		  // prvi korak kreiranje transakcije
		  iir_item = iir_seq_item::type_id::create("iir_item");
          // drugi korak - start
          start_item(iir_item);
          // treci korak priprema
          // po potrebi moguce prosiriti sa npr. inline ogranicenjima
          iir_item.s00_in_tdata = '0;
          iir_item.s00_in_tlast = 0;
          iir_item.s00_in_tvalid = 0; 
          iir_item.m00_in_tready = 0;
          iir_item.s00_in_tstrb = 4'b0000;
          // cetvrti korak - finish
          finish_item(iir_item);
          
      
      for ( int i = 1; i <= trans_count; i++) begin 
		  // prvi korak kreiranje transakcije
		  iir_item = iir_seq_item::type_id::create("iir_item");
          // drugi korak - start
          start_item(iir_item);
          // treci korak priprema
          // po potrebi moguce prosiriti sa npr. inline ogranicenjima
          assert (iir_item.randomize() );
          
          //iir_item.s00_in_tdata &= 32'b10000000011111111111111111111111;
          iir_item.s00_in_tdata = sys_input[i-1];
          if(i == trans_count)
            iir_item.s00_in_tlast = 1;
          else
            iir_item.s00_in_tlast = 0;
          iir_item.s00_in_tvalid = 1; 
          iir_item.m00_in_tready = 1;
          iir_item.s00_in_tstrb = 4'b1111;
          // cetvrti korak - finish
          finish_item(iir_item);
       end   
      
   endtask : body

endclass : iir_simple_seq

`endif
