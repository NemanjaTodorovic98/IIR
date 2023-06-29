library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity const_multiplier is
    generic(WIDTH:natural:=32;
            INTEGER_LENGTH:natural:=11;
            FRACTION_LENGTH:natural:=20);
    Port ( operand1_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           operand2_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           result_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end const_multiplier;

architecture Behavioral of const_multiplier is

--    attribute use_dsp : string;
--    attribute use_dsp of Behavioral : architecture is "yes";

    signal temp_result_s : std_logic_vector(2 * WIDTH - 1 downto 0);

begin

    temp_result_s <= std_logic_vector(signed(operand1_i) * signed(operand2_i));
    
    result_o <= temp_result_s(2*WIDTH - 1) & temp_result_s(2*WIDTH - 3 - INTEGER_LENGTH downto 2 * WIDTH - 3 - 2*INTEGER_LENGTH - FRACTION_LENGTH + 1); 
    
end Behavioral;
