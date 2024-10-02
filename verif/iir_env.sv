`ifndef IIR_ENV_SV
 `define IIR_ENV_SV

class iir_env extends uvm_env;

   iir_agent agent;
   iir_config cfg;
   iir_scoreboard scbd;
   
   virtual interface iir_if vif;
   
   `uvm_component_utils (iir_env)

   function new(string name = "iir_env", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      /************Geting from configuration database*******************/
      if (!uvm_config_db#(virtual iir_if)::get(this, "", "iir_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      
      if(!uvm_config_db#(iir_config)::get(this, "", "iir_config", cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
      /*****************************************************************/


      /************Setting to configuration database********************/
      uvm_config_db#(iir_config)::set(this, "agent", "iir_config", cfg);
      uvm_config_db#(virtual iir_if)::set(this, "agent", "iir_if", vif);
      /*****************************************************************/
      agent = iir_agent::type_id::create("agent", this);
      scbd = iir_scoreboard::type_id::create("scbd", this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      agent.mon.item_collected_port.connect(scbd.item_collected_imp);
   endfunction
   
endclass : iir_env

`endif
