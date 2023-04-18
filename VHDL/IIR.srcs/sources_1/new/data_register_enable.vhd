library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_register_enable is
    generic (WIDTH: natural:=32);
    Port( 
            clk_i : in STD_LOGIC;
            en_i : in STD_LOGIC;
            data_in_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
            data_out_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
            reset_i : in STD_LOGIC
         );
end data_register_enable;

architecture Behavioral of data_register_enable is
    signal data_out_next_s:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
begin

    process(clk_i)is
    begin
        if(clk_i'event and clk_i = '1') then
            if(reset_i = '1')then
                data_out_next_s <= (others=>'0');
            elsif(en_i = '1')then
                data_out_next_s <= data_in_i;
            end if; 
        end if;
    end process;
    
    data_out_o <= data_out_next_s;
    
end Behavioral;

