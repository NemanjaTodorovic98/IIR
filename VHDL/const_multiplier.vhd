library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity const_multiplier is
    generic(WIDTH:natural:=32;
            INTEGER_LENGTH:natural:=11;
            FRACTION_LENGTH:natural:=20);
    Port ( operand1_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           operand2_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           result_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end const_multiplier;

architecture Behavioral of const_multiplier is

begin

    process(operand1_i, operand2_i)
        variable operand1_signed : signed(WIDTH-1 downto 0);
        variable operand2_signed : signed(WIDTH-1 downto 0);
        variable product : signed(2*WIDTH-1 downto 0);
        variable shifted_product : signed(WIDTH-1 downto 0);
    begin
        operand1_signed := signed(operand1_i);
        operand2_signed := signed(operand2_i);
        product := operand1_signed * operand2_signed;

        shifted_product := shift_right(product, FRACTION_LENGTH)(WIDTH-1 downto 0);
        result_o <= std_logic_vector(shifted_product);
    end process;
    
end Behavioral;
