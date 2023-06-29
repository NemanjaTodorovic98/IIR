library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity transposed_direct_1 is
    generic(FILTER_ORDER:natural:=3;
            WIDTH:natural:=32;
            INTEGER_LENGTH:natural:=11;
            FRACTION_LENGTH:natural:=20;
            Acoeff_array:logic_vector_array_type_fixed:= 
            (
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000"
            );
            Bcoeff_array:logic_vector_array_type_fixed:= 
            (
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
                x"00100000", x"00100000", x"00100000", x"00100000",x"00100000"
            )
           );
    Port ( clk_i : in STD_LOGIC;
           reset_int_i : in STD_LOGIC;
           reset_ext_i : in STD_LOGIC;
           input_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           output_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end transposed_direct_1;

architecture Mixed of transposed_direct_1 is
    
    type logic_vector_array_type is array (1 to FILTER_ORDER) of std_logic_vector(WIDTH - 1 downto 0);
    
    signal left_network_output_s : logic_vector_array_type;
    signal right_network_output_s : logic_vector_array_type;
    
    signal input_vertical_s : std_logic_vector(WIDTH - 1 downto 0);
    signal multiplier_to_output_adder_s : std_logic_vector(WIDTH - 1 downto 0); 
    
    signal reset_s : std_logic;

begin
    
    reset_s <= reset_int_i or reset_ext_i;
    
    INPUT_ADDER:
    entity work.adder(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(operand1_i=>input_i,
             operand2_i=>left_network_output_s(1),
--             clk_i => clk_i,
--             reset_i => reset_s,
             result_o=>input_vertical_s);
             
    MULTIPLIER:
    entity work.const_multiplier(Behavioral)
    generic map(WIDTH => WIDTH,
                INTEGER_LENGTH => INTEGER_LENGTH,
                FRACTION_LENGTH => FRACTION_LENGTH)
    port map(operand1_i=>input_vertical_s,
             operand2_i=>Bcoeff_array(0),
             result_o=>multiplier_to_output_adder_s);
             
    OUTPUT_ADDER:
    entity work.adder(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(operand1_i=>multiplier_to_output_adder_s,
             operand2_i=>right_network_output_s(1),
--             clk_i => clk_i,
--             reset_i => reset_s,
             result_o=>output_o);           

    GENERATE_NETWORK:
    for iterator in 1 to FILTER_ORDER - 1 generate
        REGULAR_CELL:
        entity work.transposed_direct_1_cell(Structural)
        generic map(WIDTH => WIDTH,
                    Acoeff => Acoeff_array(iterator),
                    Bcoeff => Bcoeff_array(iterator)
                    )
        port map(clk_i => clk_i,
                 reset_i => reset_s,
                 input_i => input_vertical_s,
                 left_adder_input_i => left_network_output_s(iterator + 1),
                 right_adder_input_i => right_network_output_s(iterator + 1),
                 left_reg_output_o => left_network_output_s(iterator),
                 right_reg_output_o => right_network_output_s(iterator)
                 );           
    end generate;
    
    LAST_CELL:
    entity work.transposed_direct_1_last_cell(Structural)
    generic map(WIDTH => WIDTH,
                Acoeff => Acoeff_array(FILTER_ORDER),
                Bcoeff => Bcoeff_array(FILTER_ORDER)
                )
                
    port map(clk_i => clk_i,
             reset_i => reset_s,
             input_i => input_vertical_s,
             left_reg_output_o => left_network_output_s(FILTER_ORDER),
             right_reg_output_o => right_network_output_s(FILTER_ORDER)
             );           
end Mixed;
