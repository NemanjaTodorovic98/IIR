library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.txt_util.all;
use work.types.all;

entity TB_transposed_direct_1 is
--  Port ( );
end TB_transposed_direct_1;

architecture Behavioral of TB_transposed_direct_1 is
   
    constant WIDTH:natural:=32;
    
    constant FILTER_ORDER:natural:=8;
    
    constant Coef_A : logic_vector_array_type_fixed := 
    (
        "00000000000100000000000000000000",
        "11111111101101011011110010111111",
        "00000000101100001000000101111100",
        "11111110111100101000001011011101",
        "00000001000111010011001010100100",
        "11111111001010110010100101000110",
        "00000000011011010100010110101110",
        "11111111110111001001001010001100",
        "00000000000001011001111101011001"
    );
    
    constant Coef_B : logic_vector_array_type_fixed :=
    (     
        "00000000000000000000000010000100",
        "00000000000000000000010000100011",
        "00000000000000000000111001111100",
        "00000000000000000001110011111000",
        "00000000000000000010010000110110",
        "00000000000000000001110011111000",
        "00000000000000000000111001111100",
        "00000000000000000000010000100011",
        "00000000000000000000000010000100"
    );
    
    file input_test_vector : text open read_mode is "C:\Users\Nemanja\Desktop\IIR filter\SystemInput.txt";
    file expected_results : text open read_mode is "C:\Users\Nemanja\Desktop\IIR filter\SystemOutput.txt";
    
    signal clk_i: std_logic;
    signal reset_i: std_logic;
    
    signal input : std_logic_vector(WIDTH - 1 downto 0);
    signal output : std_logic_vector(WIDTH - 1 downto 0);
    signal expected : std_logic_vector(WIDTH - 1 downto 0);

    
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
        variable file_line : line;
    begin
        input <= (others=>'0');
        wait until falling_edge(clk_i);
        while not endfile(input_test_vector) loop
            readline(input_test_vector,file_line);
            input <= to_std_logic_vector(string(file_line));
            wait until falling_edge(clk_i);
        end loop;
    end process;
    
    EXPECTED_RESULT:
    process is
        variable file_line : line;
    begin
        expected <= (others=>'0');
        wait until falling_edge(clk_i);
        while not endfile(expected_results) loop
            readline(expected_results,file_line);
            expected <= to_std_logic_vector(string(file_line));
            wait until falling_edge(clk_i);
        end loop;
    end process;
    
    FILTER: entity work.transposed_direct_1(Mixed)
    generic map(
                FILTER_ORDER => FILTER_ORDER,
                WIDTH => WIDTH,
                Acoeff_array => Coef_A,
                Bcoeff_array => Coef_B
                )
    port map(
               clk => clk_i,
               reset => reset_i,
               input => input,
               output => output
	        );            
end Behavioral;
