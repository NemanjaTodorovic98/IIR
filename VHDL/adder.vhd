library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder is
    generic (WIDTH: natural:=32);
    Port ( operand1_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           operand2_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
--           clk_i : in STD_LOGIC;
--           reset_i : in STD_LOGIC;
           result_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end adder;

architecture Behavioral of adder is

--    attribute use_dsp : string;
--    attribute use_dsp of Behavioral : architecture is "yes";

--    signal operand1_s:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
--    signal operand2_s:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
--    signal result_s:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    
--    signal operand1_next_s:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
--    signal operand2_next_s:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
--    signal result_next_s:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
begin

--    process(clk_i)is
--    begin
--        if(clk_i'event and clk_i = '1') then
--            if(reset_i = '1')then            
--                operand1_next_s <= (others=>'0');
--                operand2_next_s <= (others=>'0');
--                result_next_s <= (others=>'0');
--            else
--                operand1_next_s <= operand1_i;
--                operand2_next_s <= operand1_i;
--                result_next_s <= result_s;
--            end if; 
--        end if;
--    end process;
    
--    operand1_s <= operand1_next_s;
--    operand2_s <= operand2_next_s;
--    result_o <= result_next_s;

--    result_s <= std_logic_vector(signed(operand1_s) + signed(operand2_s));

    result_o <= std_logic_vector(signed(operand1_i) + signed(operand2_i));

end Behavioral;
