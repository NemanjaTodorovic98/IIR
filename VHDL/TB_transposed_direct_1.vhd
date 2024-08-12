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
   
    constant WIDTH:natural:=64;
    
    constant FILTER_ORDER:natural:=8;
    
    constant INTEGER_LENGTH:natural:= 23;
    
    constant FRACTION_LENGTH:natural:= 40;
    
    constant Coef_A : logic_vector_array_type_fixed := 
    (
        "0000000000000000000000010000000000000000000000000000000000000000",
        "0000000000000000000001001010010000110100000010010010000011110011",
        "1111111111111111111101001111011111101000010000110000001100100001",
        "0000000000000000000100001101011111010010001010011001111110011100",
        "1111111111111111111011100010110011010101110001010100000011001111",
        "0000000000000000000011010100110101101011101000101011000010011100",
        "1111111111111111111110010010101110100101001000011110100011011001",
        "0000000000000000000000100011011011010111001110010111101001100000",
        "1111111111111111111111111010011000001010011010011111110101111110"
    );
    
    constant Coef_B : logic_vector_array_type_fixed :=
    (     
        "0000000000000000000000000000000000001000010001101101001110110100",
        "0000000000000000000000000000000001000010001101101001110110011100",
        "0000000000000000000000000000000011100111101111110010011110100011",
        "0000000000000000000000000000000111001111011111100100111101000101",
        "0000000000000000000000000000001001000011010111011110001100010110",
        "0000000000000000000000000000000111001111011111100100111101000101",
        "0000000000000000000000000000000011100111101111110010011110100011",
        "0000000000000000000000000000000001000010001101101001110110011100",
        "0000000000000000000000000000000000001000010001101101001110110100"
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
        variable clk_edges : natural := 0;
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
               clk => clk_s,
               reset => reset_s,
               en => en_s,
               input => input_s,
               output => output_s
	        );            
end Behavioral;
