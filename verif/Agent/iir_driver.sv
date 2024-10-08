`ifndef IIR_DRIVER_SV
`define IIR_DRIVER_SV
class iir_driver extends uvm_driver#(iir_seq_item);

   `uvm_component_utils(iir_driver)
   virtual interface iir_if vif;
   function new(string name = "iir_driver", uvm_component parent = null);
      super.new(name,parent);

   endfunction // new
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual iir_if)::get(null, "*", "iir_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction : build_phase
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
   endfunction : connect_phase
   
   task main_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);	 
            seq_item_port.get_next_item(req);
            
            //`uvm_info(get_type_name(),$sformatf("Driver sending...\n%s", req.sprint()),UVM_HIGH)
            vif.s00_axis_input_tdata = req.s00_in_tdata;	 
            vif.s00_axis_input_tlast = req.s00_in_tlast;
            vif.s00_axis_input_tvalid = req.s00_in_tvalid;  
            vif.s00_axis_input_tstrb = req.s00_in_tstrb;
            vif.m00_axis_output_tready = req.m00_in_tready;

            seq_item_port.item_done();         
        end 
   endtask : main_phase

endclass : iir_driver

`endif