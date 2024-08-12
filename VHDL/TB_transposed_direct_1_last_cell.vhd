library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_transposed_direct_1_last_cell is
--  Port ( );
end TB_transposed_direct_1_last_cell;

architecture Behavioral of TB_transposed_direct_1_last_cell is

    constant LENGTH:natural:= 10;
    constant WIDTH:natural:=32;
    
    type input_stream_t is array (1 to LENGTH) of std_logic_vector(WIDTH - 1 downto 0);
    type adder_input_stream_t is array (1 to LENGTH) of std_logic_vector(WIDTH - 1 downto 0);
    -- 1 - 10
    constant input_stimulus:input_stream_t:=
    (
    "00000000000100000000000000000000",
    "00000000001000000000000000000000",
    "00000000001100000000000000000000",
    "00000000010000000000000000000000",
    "00000000010100000000000000000000",
    "00000000011000000000000000000000", 
    "00000000011100000000000000000000",
    "00000000100000000000000000000000",
    "00000000100100000000000000000000",
    "00000000101000000000000000000000"
    );
    

    constant coefficientA:std_logic_vector(WIDTH - 1 downto 0):= "00000000010100000000000000000000"; --number 5
    constant coefficientB:std_logic_vector(WIDTH - 1 downto 0):= "00000000100001011001100000000000"; --number 8.35
    
    signal clk_i: std_logic;
    signal reset_i: std_logic;
    
    signal input_i: std_logic_vector(WIDTH - 1 downto 0);
    signal output_left_o: std_logic_vector(WIDTH - 1 downto 0);
    signal output_right_o: std_logic_vector(WIDTH - 1 downto 0);
    
begin
    CLOCK: 
    process is
    begin
        clk_i <= '0', '1' after 100 ns;
        wait for 200 ns;
    end process;
    
    RESET: 
    process is
    begin
        reset_i <= '0', '1' after 50ns, '0' after 150ns;
        wait;
    end process;

    INPUT_STIMULI:
    process is
    begin
        for iterator in 1 to LENGTH loop
            wait until falling_edge(clk_i);
            input_i <= input_stimulus(iterator);
        end loop;
    end process;
    
    Cell: entity work.transposed_direct_1_last_cell(Structural)
    generic map(
                WIDTH => WIDTH,
                Acoeff => coefficientA,
                Bcoeff => coefficientB
                )
    port map(
               clk => clk_i,
               reset => reset_i,
               input_signal => input_i,
               left_reg_output => output_left_o,
               right_reg_output => output_right_o
	        );    
        
end Behavioral;
