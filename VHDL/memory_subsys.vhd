library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_subsys is
    Generic(WIDTH:natural:=32);
    Port(
            clk_i : in STD_LOGIC;
            reset_int_i : in STD_LOGIC;
            reset_ext_i : in STD_LOGIC;
            
            input_data_wen_i : in STD_LOGIC;
            
            input_data_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            input_data_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0); 
            
            output_data_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            output_data_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0) 
         );
end memory_subsys;

architecture Structural of memory_subsys is

    signal reset_s : std_logic;

begin

    reset_s <= reset_int_i or reset_ext_i;
    
    INPUT_DATA_REG:
    entity work.data_register_enable(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(
                clk_i => clk_i,
                en_i => input_data_wen_i,
                data_in_i => input_data_i,
                data_out_o => input_data_o,
                reset_i => reset_s
             );
    
    OUTPUT_REG:
    entity work.data_register(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(
                clk_i => clk_i,
                data_in_i => output_data_i,
                data_out_o => output_data_o,
                reset_i => reset_s
             );             
end Structural;
