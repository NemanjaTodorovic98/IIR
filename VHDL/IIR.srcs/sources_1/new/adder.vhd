library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder is
    generic (WIDTH: natural:=32);
    Port ( operand1_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           operand2_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           result_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end adder;

architecture Behavioral of adder is
begin

    result_o <= std_logic_vector(signed(operand1_i) + signed(operand2_i));

end Behavioral;
