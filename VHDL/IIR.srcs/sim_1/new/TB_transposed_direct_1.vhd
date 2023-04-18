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
    
    constant INTEGER_LENGTH:natural:= 11;
    
    constant FRACTION_LENGTH:natural:= 20;
    
    constant Coef_A : logic_vector_array_type_fixed := 
    (
        "00000000000100000000000000000000",
        "00000000010010100100001101000001",
        "11111111010011110111111010000100",
        "00000001000011010111110100100011",
        "11111110111000101100110101011100",
        "00000000110101001101011010111010",
        "11111111100100101011101001010010",
        "00000000001000110110110101110100",
        "11111111111110100110000010100111"
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
    
    signal clk_s: std_logic;
    signal reset_s: std_logic;
    signal en_s: std_logic;
    
    signal input_s : std_logic_vector(WIDTH - 1 downto 0);
    signal output_s : std_logic_vector(WIDTH - 1 downto 0);
    signal expected_s : std_logic_vector(WIDTH - 1 downto 0);

    
begin
    CLOCK: 
    process is
    begin
        clk_s <= '0', '1' after 100 ns;
        wait for 200 ns;
    end process;
    
    RESET: 
    process is
    begin
        reset_s <= '0', '1' after 50ns, '0' after 150ns;
        wait;
    end process;
    
    ENABLE:
    process is
        begin
        en_s <= '0', '1' after 150ns;
        wait;
    end process;

    INPUT_STIMULI:
    process is
        variable file_line : line;
    begin
        input_s <= (others=>'0');
        wait for 200ns;
        wait until falling_edge(clk_s);
        while not endfile(input_test_vector) loop
            readline(input_test_vector,file_line);
            input_s <= to_std_logic_vector(string(file_line));
            wait until falling_edge(clk_s);
        end loop;
    end process;
    
    EXPECTED_RESULT:
    process is
        variable file_line : line;
    begin
        expected_s <= (others=>'0');
        wait for 400ns;
        wait until rising_edge(clk_s);
        while not endfile(expected_results) loop
            readline(expected_results,file_line);
            expected_s <= to_std_logic_vector(string(file_line));
            wait until rising_edge(clk_s);
        end loop;
    end process;
    
    DATA_PATH: entity work.transposed_direct_1(Mixed)
    generic map(
                FILTER_ORDER => FILTER_ORDER,
                WIDTH => WIDTH,
                INTEGER_LENGTH => INTEGER_LENGTH,
                FRACTION_LENGTH => FRACTION_LENGTH,
                Acoeff_array => Coef_A,
                Bcoeff_array => Coef_B
                )
    port map(
               clk_i => clk_s,
               reset_i => reset_s,
               en_i => en_s,
               input_i => input_s,
               output_o => output_s
	        );            
end Behavioral;
