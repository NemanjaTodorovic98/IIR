library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.txt_util.all;
use work.types.all;

entity TB_const_multiplier is
--  Port ( );
end TB_const_multiplier;

architecture Behavioral of TB_const_multiplier is

    constant WIDTH:natural:= 32;
    constant INTEGER_LENGTH:natural:= 11;
    constant FRACTION_LENGTH:natural:= 20;

    file op1_vector : text open read_mode is "D:\Project\IIR\Operand1.txt";
    file op2_vector : text open read_mode is "D:\Project\IIR\Operand2.txt";
    file expected_results : text open read_mode is "D:\Project\IIR\ResultMultiplication.txt";
       
    signal op1: std_logic_vector(WIDTH - 1 downto 0);
    signal op2: std_logic_vector(WIDTH - 1 downto 0);
    signal result : std_logic_vector(WIDTH - 1 downto 0);
    signal expected : std_logic_vector(WIDTH - 1 downto 0);
 
begin

    INPUT_STIMULI:
    process is
        variable file_line_op1 : line;
        variable file_line_op2 : line;
    begin
        op1 <= (others=>'0');
        op2 <= (others=>'0');
        while not endfile(op2_vector) loop
            readline(op1_vector,file_line_op1);
            readline(op2_vector,file_line_op2);
            op1 <= to_std_logic_vector(string(file_line_op1));
            op2 <= to_std_logic_vector(string(file_line_op2));
            wait for 200ns;
        end loop;
        wait;
    end process;
    
    EXPECTED_RESULT:
    process is
        variable file_line : line;
    begin
        expected <= (others=>'0');
        while not endfile(expected_results) loop
            readline(expected_results,file_line);
            expected <= to_std_logic_vector(string(file_line));
            wait for 200ns;
        end loop;
        wait;
    end process;
    
    UUT: entity work.const_multiplier(Behavioral)
    generic map(
                WIDTH => WIDTH,
                INTEGER_LENGTH => INTEGER_LENGTH,
                FRACTION_LENGTH => FRACTION_LENGTH
                )
    port map(operand1_i => op1,
             operand2_i => op2,
             result_o => result
	        );    
	        
end Behavioral;
