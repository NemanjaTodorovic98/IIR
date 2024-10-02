class iir_monitor extends uvm_monitor;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

   uvm_analysis_port #(iir_seq_item) item_collected_port;

   `uvm_component_utils_begin(iir_monitor)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   // The virtual interface used to drive and view HDL signals.
   virtual interface iir_if vif;

   // current transaction
   iir_seq_item curr_it;

   // coverage can go here
   // ...

   function new(string name = "iir_monitor", uvm_component parent = null);
      super.new(name,parent);
      item_collected_port = new("item_collected_port", this);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual iir_if)::get(null, "*", "iir_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      
   endfunction : connect_phase

   task main_phase(uvm_phase phase);
       forever begin
           @(posedge vif.clk);
           curr_it = iir_seq_item::type_id::create("curr_it", this);
    
           curr_it.s00_in_tdata = vif.s00_axis_input_tdata;
           curr_it.s00_in_tstrb = vif.s00_axis_input_tstrb;
           curr_it.s00_in_tlast = vif.s00_axis_input_tlast;
           curr_it.s00_in_tvalid = vif.s00_axis_input_tvalid;
           
           curr_it.m00_out_tdata = vif.m00_axis_output_tdata;
           curr_it.m00_in_tready = vif.m00_axis_output_tready;
           
           `uvm_info(get_type_name(), $sformatf("Monitor sends: DUT in = %h, DUT out = %h", curr_it.s00_in_tdata, curr_it.m00_out_tdata), UVM_HIGH);
           
           item_collected_port.write(curr_it);
       end
   endtask : main_phase

endclass : iir_monitor
