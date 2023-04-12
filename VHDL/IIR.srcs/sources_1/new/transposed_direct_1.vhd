library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity transposed_direct_1 is
    generic(FILTER_ORDER:natural:=3;
            WIDTH:natural:=64;
            INTEGER_LENGTH:natural:=23;
            FRACTION_LENGTH:natural:=40;
            Acoeff_array:logic_vector_array_type_fixed:= 
            (
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000"
            );
            Bcoeff_array:logic_vector_array_type_fixed:= 
            (
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000",
                x"0000010000000000"
            )
           );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           output : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end transposed_direct_1;

architecture Mixed of transposed_direct_1 is
    
    type logic_vector_array_type is array (1 to FILTER_ORDER) of std_logic_vector(WIDTH - 1 downto 0);
    
    signal left_network_output : logic_vector_array_type;
    signal right_network_output : logic_vector_array_type;
    
    signal input_vertical : std_logic_vector(WIDTH - 1 downto 0);
    signal multiplier_to_output_adder : std_logic_vector(WIDTH - 1 downto 0); 
    
begin
    
    INPUT_ADDER:
    entity work.adder(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(operand1=>input,
             operand2=>left_network_output(1),
             result=>input_vertical);
             
    MULTIPLIER:
    entity work.const_multiplier(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(operand1=>input_vertical,
             operand2=>Bcoeff_array(0),
             result=>multiplier_to_output_adder);
             
    OUTPUT_ADDER:
    entity work.adder(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(operand1=>multiplier_to_output_adder,
             operand2=>right_network_output(1),
             result=>output);
             
    GENERATE_NETWORK:
    for iterator in 1 to FILTER_ORDER - 1 generate
        REGULAR_CELL:
        entity work.transposed_direct_1_cell(Structural)
        generic map(WIDTH => WIDTH,
                    Acoeff => Acoeff_array(iterator),
                    Bcoeff => Bcoeff_array(iterator)
                    )
        port map(clk => clk,
                 reset => reset,
                 input_signal => input_vertical,
                 left_adder_input => left_network_output(iterator + 1),
                 right_adder_input => right_network_output(iterator + 1),
                 left_reg_output => left_network_output(iterator),
                 right_reg_output => right_network_output(iterator)
                 );           
    end generate;
    
    LAST_CELL:
    entity work.transposed_direct_1_last_cell(Structural)
    generic map(WIDTH => WIDTH,
                Acoeff => Acoeff_array(FILTER_ORDER),
                Bcoeff => Bcoeff_array(FILTER_ORDER)
                )
                
    port map(clk => clk,
             reset => reset,
             input_signal => input_vertical,
             left_reg_output => left_network_output(FILTER_ORDER),
             right_reg_output => right_network_output(FILTER_ORDER)
             );           
end Mixed;
