library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_subsys is
    Generic(WIDTH:natural:=32);
    Port(
            clk_i : in STD_LOGIC;
            reset_i : in STD_LOGIC;
            reg_data_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            input_data_wr_i : in STD_LOGIC;
            command_wr_i : in STD_LOGIC;
            
            output_i : in STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            output_axi_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            
            input_data_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            input_data_axi_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            
            command_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            command_axi_o : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
            
            ready_i : in STD_LOGIC;
            ready_axi_o : out STD_LOGIC
            
         );
end memory_subsys;

architecture Structural of memory_subsys is

    signal input_data_reg_output_s : std_logic_vector(WIDTH - 1 downto 0);
    signal command_reg_output_s : std_logic_vector(WIDTH - 1 downto 0);

begin

    INPUT_DATA_REG:
    entity work.data_register_enable(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(
                clk_i => clk_i,
                en_i => input_data_wr_i,
                data_in_i => reg_data_i,
                data_out_o => input_data_reg_output_s,
                reset_i => reset_i
             );

    input_data_axi_o <= input_data_reg_output_s; 
    input_data_o <= input_data_reg_output_s;
    
    COMMAND_REG:
    entity work.data_register_enable(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(
                clk_i => clk_i,
                en_i => command_wr_i,
                data_in_i => reg_data_i,
                data_out_o => command_reg_output_s,
                reset_i => reset_i
             );

    command_axi_o <= command_reg_output_s;
    command_o <= command_reg_output_s;
    
    OUTPUT_REG:
    entity work.data_register(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(
                clk_i => clk_i,
                data_in_i => output_i,
                data_out_o => output_axi_o,
                reset_i => reset_i
             );
             
    READY_REG:
    entity work.data_register(Behavioral)
    generic map(WIDTH => WIDTH)
    port map(
                clk_i => clk_i,
                data_in_i => ready_i,
                data_out_o => ready_axi_o,
                reset_i => reset_i
             );
             
end Structural;
