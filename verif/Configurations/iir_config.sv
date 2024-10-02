class iir_config extends uvm_object;

   uvm_active_passive_enum is_active = UVM_PASSIVE;
   
   `uvm_object_utils_begin (iir_config)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
   `uvm_object_utils_end

   function new(string name = "iir_config");
      super.new(name);
   endfunction

endclass : iir_config
