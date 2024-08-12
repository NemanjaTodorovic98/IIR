library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.txt_util.all;
use work.types.all;

entity TB_adder is
--  Port ( );
end TB_adder;

architecture Behavioral of TB_adder is

    constant LENGTH:natural:= 5;
    constant WIDTH:natural:= 64;
    constant INTEGER_LENGTH:natural:= 23;
    constant FRACTION_LENGTH:natural:= 40;
    
    type input_stream_t is array (1 to LENGTH) of std_logic_vector(WIDTH - 1 downto 0);

    file op1_vector : text open read_mode is "C:\Users\Nemanja\Desktop\IIR filter\Operand1.txt";
    file op2_vector : text open read_mode is "C:\Users\Nemanja\Desktop\IIR filter\Operand2.txt";
    file expected_results : text open read_mode is "C:\Users\Nemanja\Desktop\IIR filter\ResultAddition.txt";
       
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
    
    UUT: entity work.adder(Behavioral)
    generic map(
                WIDTH => WIDTH
                )
    port map(operand1 => op1,
             operand2 => op2,
             result => result
	        );    
	        
end Behavioral;
