`ifndef IIR_IF_SV
 `define IIR_IF_SV

interface iir_if (input clk, input rst);

   parameter WIDTH = 32;
   parameter FILTER_ORDER = 2;
   parameter INTEGER_LENGTH = 11;
   parameter FRACTION_LENGTH = 20;
   
   //AXI Slave (input)
   logic                    s00_axis_input_aclk;
   logic                    s00_axis_input_aresetn;
   logic                    s00_axis_input_tready;
   logic[WIDTH-1 : 0]       s00_axis_input_tdata;
   logic[(WIDTH/8)-1 : 0]   s00_axis_input_tstrb;
   logic                    s00_axis_input_tlast;
   logic                    s00_axis_input_tvalid;
   
   //AXI Master (output)
   logic                    m00_axis_output_aclk;
   logic                    m00_axis_output_aresetn;
   logic                    m00_axis_output_tvalid;
   logic[WIDTH-1 : 0]       m00_axis_output_tdata;
   logic[(WIDTH/8)-1 : 0]   m00_axis_output_tstrb;
   logic                    m00_axis_output_tlast;
   logic                    m00_axis_output_tready;

endinterface : iir_if

`endif
