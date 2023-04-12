library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity const_multiplier is
    generic(WIDTH:natural:=64;
            INTEGER_LENGTH:natural:=23;
            FRACTION_LENGTH:natural:=40);
    Port ( operand1 : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           operand2 : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           result : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end const_multiplier;

architecture Behavioral of const_multiplier is

    signal temp_result : std_logic_vector(2 * WIDTH - 1 downto 0);

begin

    temp_result <= std_logic_vector(signed(operand1) * signed(operand2));
    
    result <= temp_result(2*WIDTH - 1) & temp_result(2*WIDTH - 3 - INTEGER_LENGTH downto 2 * WIDTH - 3 - 2*INTEGER_LENGTH - FRACTION_LENGTH + 1); 
    
end Behavioral;
