library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity const_multiplier is
    generic(WIDTH:natural:=32);
    Port ( operand1 : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           operand2 : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           result : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0));
end const_multiplier;

architecture Behavioral of const_multiplier is

begin

    result <= std_logic_vector(signed(operand1) * signed(operand2));
    
end Behavioral;
