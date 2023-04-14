library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity IIR_filter is
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
    Port ( clk_i : in STD_LOGIC;
           input_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           command_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           output_i : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end IIR_filter;

architecture Structural of IIR_filter is

    signal reset_s : STD_LOGIC;
    signal en_s : STD_LOGIC;

begin
    
    DATA_PATH:
    entity work.transposed_direct_1(Mixed)
    generic map(FILTER_ORDER => FILTER_ORDER,
                WIDTH => WIDTH,
                INTEGER_LENGTH => INTEGER_LENGTH,
                FRACTION_LENGTH => FRACTION_LENGTH,
                Acoeff_array => Acoeff_array,
                Bcoeff_array => Bcoeff_array)
    Port map(  clk => clk_i,
               reset => reset_s,
               en => en_s,
               input => input_i,
               output => output_i);
               
    CONTROL_PATH:
    entity work.control_unit(Behavioral)
    generic map(WIDTH => WIDTH)
    Port map(  clk_i => clk_i,
               command_i => command_i,
               en_o => en_s,
               reset_o => reset_s);

end Structural;
