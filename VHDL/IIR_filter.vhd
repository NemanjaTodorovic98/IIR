library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

entity IIR_filter is
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
           reset_i : in STD_LOGIC;
           input_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           output_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
           
end IIR_filter;

architecture Structural of IIR_filter is

begin 
    INST:
    entity work.transposed_direct_1(Mixed)
    generic map(FILTER_ORDER => FILTER_ORDER,
                WIDTH => WIDTH,
                INTEGER_LENGTH => INTEGER_LENGTH,
                FRACTION_LENGTH => FRACTION_LENGTH,
                Acoeff_array => Acoeff_array,
                Bcoeff_array => Bcoeff_array)
    Port map(  clk_i => clk_i,
               reset_i => reset_i,
               input_i => input_i,
               output_o => output_o);
end Structural;
