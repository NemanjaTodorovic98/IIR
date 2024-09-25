module verif_top;

   import uvm_pkg::*;     // import the UVM library
   `include "uvm_macros.svh" // Include the UVM macros

   import iir_test_pkg::*;   

   logic clk;
   logic rst;

   // interface
   iir_if iir_vif(clk, rst);

   // DUT
   axi_iir_v1_0 DUT(
                .s00_axis_input_aclk        ( clk ),
                .s00_axis_input_aresetn     ( rst ),
                .s00_axis_input_tready      ( iir_vif.s00_axis_input_tready ),
                .s00_axis_input_tdata       ( iir_vif.s00_axis_input_tdata ),
                .s00_axis_input_tstrb       ( iir_vif.s00_axis_input_tstrb ),
                .s00_axis_input_tlast       ( iir_vif.s00_axis_input_tlast ),
                .s00_axis_input_tvalid      ( iir_vif.s00_axis_input_tvalid ),
                .m00_axis_output_aclk       ( clk ),
                .m00_axis_output_aresetn    ( rst ),
                .m00_axis_output_tvalid     ( iir_vif.m00_axis_output_tvalid ),
                .m00_axis_output_tdata      ( iir_vif.m00_axis_output_tdata ),
                .m00_axis_output_tstrb      ( iir_vif.m00_axis_output_tstrb ),
                .m00_axis_output_tlast      ( iir_vif.m00_axis_output_tlast ),
                .m00_axis_output_tready     ( iir_vif.m00_axis_output_tready )
                );

   // run test
   initial begin
      // Ubacivanje interfejsa u konfiguracionu bazu podataka      
      uvm_config_db#(virtual iir_if)::set(null, "*", "iir_if", iir_vif);
      run_test();
   end

   // clock init.
   initial begin
      clk <= 0;
      rst <= 0;
      #100 rst <= 1;
   end

   // clock generation
   always #50 clk = ~clk;

endmodule : verif_top
