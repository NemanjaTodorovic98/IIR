library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    generic (WIDTH: natural:=32);
    Port ( clk_i : in STD_LOGIC;
           in_transfer_done_i : in STD_LOGIC;
           out_transfer_done_i : in STD_LOGIC;
           reset_o : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

begin

    reset_o <= '1' when in_transfer_done_i = '1' and out_transfer_done_i = '1' else '0';
    
end Behavioral;
