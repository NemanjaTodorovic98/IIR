class iir_scoreboard extends uvm_scoreboard;

   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

   // This TLM port is used to connect the scoreboard to the monitor
   uvm_analysis_imp#(iir_seq_item, iir_scoreboard) item_collected_imp;

   parameter int FILTER_ORDER = 8;
   parameter logic signed [31:0] coeff_A [0:FILTER_ORDER] =
           '{32'b00000000000100000000000000000000,
             32'b00000000010010100100001101000001,
             32'b11111111010011110111111010000100,
             32'b00000001000011010111110100100011,
             32'b11111110111000101100110101011100,
             32'b00000000110101001101011010111010,
             32'b11111111100100101011101001010010,
             32'b00000000001000110110110101110100,
             32'b11111111111110100110000010100111};
       
   parameter logic signed [31:0] coeff_B [0:FILTER_ORDER] =
          '{32'b00000000000000000000000010000100,
            32'b00000000000000000000010000100011,
            32'b00000000000000000000111001111100,
            32'b00000000000000000001110011111000,
            32'b00000000000000000010010000110110,
            32'b00000000000000000001110011111000,
            32'b00000000000000000000111001111100,
            32'b00000000000000000000010000100011,
            32'b00000000000000000000000010000100};
   
   logic signed [31:0] x_in [0:FILTER_ORDER] = '{default: 32'd0}; 
   logic signed [31:0] y_out [0:FILTER_ORDER] = '{default: 32'd0};
   
   int delay_cycle_count;
   int num_of_tr;

   `uvm_component_utils_begin(iir_scoreboard)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "iir_scoreboard", uvm_component parent = null);
      super.new(name,parent);
      item_collected_imp = new("item_collected_imp", this);
   endfunction : new

   function write (iir_seq_item tr);
      iir_seq_item tr_clone;
      logic signed [31:0] output_sum = '0;
      $cast(tr_clone, tr.clone());
      if(checks_enable) begin
         
         `uvm_info(get_type_name(), $sformatf("Input: %h",(tr_clone.s00_in_tdata)), UVM_HIGH);
         
         if(tr_clone.s00_in_tvalid == 1'b1) begin
             
             delay_cycle_count++;
             
             //Shift input samples
             for(int i = FILTER_ORDER; i > 0; i--)
                x_in[i] = x_in[i-1];
             
             x_in[0] = tr_clone.s00_in_tdata;
             
             //Shift output samples
             for(int i = FILTER_ORDER; i > 0; i--)
                y_out[i] = y_out[i-1];
             
             for(int i = 0; i <= FILTER_ORDER; i++)
             begin
                output_sum += fixed_point_multiplication(coeff_B[i], x_in[i]);
                `uvm_info(get_type_name(), $sformatf("%h  *  %h  =  %h", coeff_B[i], x_in[i], fixed_point_multiplication(coeff_B[i], x_in[i])), UVM_HIGH);
             end
             `uvm_info(get_type_name(), $sformatf("output_sum =  %h", output_sum), UVM_HIGH);
             for(int i = 1; i <= FILTER_ORDER; i++)
             begin  
                output_sum += fixed_point_multiplication(coeff_A[i], y_out[i]);
                `uvm_info(get_type_name(), $sformatf("%h  *  %h  =  %h", coeff_A[i], y_out[i], fixed_point_multiplication(coeff_A[i], y_out[i])), UVM_HIGH);
             end
             `uvm_info(get_type_name(), $sformatf("output_sum =  %h", output_sum), UVM_HIGH);
             y_out[0] = output_sum;
    
             for(int i = 0; i <= FILTER_ORDER; i++)begin
                `uvm_info(get_type_name(), $sformatf("output[%d] =  %h", i, y_out[i]), UVM_HIGH);
                `uvm_info(get_type_name(), $sformatf("input[%d] =  %h", i, x_in[i]), UVM_HIGH);
             end
             
             if(delay_cycle_count == 2)begin
                 delay_cycle_count = 1;
                 compare_results:assert(y_out[2] == tr_clone.m00_out_tdata)
                 begin
                    `uvm_info(get_type_name(), "Check succesfull - outputs match", UVM_HIGH);
                 end
                 else
                 begin
                    `uvm_error(get_type_name(), $sformatf("Outputs mismatch: dut = %h, ref_model = %h", (tr_clone.m00_out_tdata), (y_out[2])));
                 end
             end            
         end
         else
         begin
            delay_cycle_count = 0;
         end 
         
         
         //`uvm_info(get_type_name(), "Received seq item:", UVM_HIGH);   
         //tr_clone.print(); 
         ++num_of_tr;
      end
   endfunction : write

   function void report_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("IIR scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
   endfunction : report_phase

   function string print_fixedpoint(logic [31:0] x);
        string formatted_string;
        int signed_integer_part;  // Signed integer part
        real fractional_value;    // Real value of the fractional part
        
        // Extract and sign-extend the integer part
        signed_integer_part = $signed(x) >>> 20;
        
        // Extract and normalize the fractional part
        fractional_value = (x[19:0]) / (1 << 20);
        
        formatted_string = $sformatf("%f", signed_integer_part + fractional_value);
        return formatted_string;
   endfunction : print_fixedpoint
   
   function logic signed [31 : 0] fixed_point_multiplication(logic signed [31:0] op1, logic signed [31:0] op2);
        logic signed [63:0] product;
        logic signed [31:0] shifted_product;
        
        product = op1 * op2;
        shifted_product = product >>> 20;
        
        return shifted_product;
   endfunction : fixed_point_multiplication
endclass : iir_scoreboard
