library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_register is
    generic (WIDTH: natural:=32);
    Port( 
            clk : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
            data_out : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
            reset : in STD_LOGIC
         );
end data_register;

architecture Behavioral of data_register is
    signal data_out_next:STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
begin

    process(clk)is
    begin
        if(clk'event and clk = '1') then
            if(reset = '1')then
                data_out_next <= (others=>'0');
            else
                data_out_next <= data_in;
            end if; 
        end if;
    end process;
    
    data_out <= data_out_next;
    
end Behavioral;
