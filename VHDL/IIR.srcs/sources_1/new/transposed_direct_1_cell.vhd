library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transposed_direct_1_cell is
    generic(WIDTH:natural:=64;
            INTEGER_LENGTH:natural:=23;
            FRACTION_LENGTH:natural:=40;
            Acoeff:std_logic_vector(63 downto 0):=(others=>'0');
            Bcoeff:std_logic_vector(63 downto 0):=(others=>'0')
    );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           input_signal : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           left_adder_input : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           right_adder_input : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           left_reg_output : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           right_reg_output : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end transposed_direct_1_cell;

architecture Structural of transposed_direct_1_cell is
    constant  A : std_logic_vector(WIDTH - 1 downto 0) := Acoeff;
    constant  B : std_logic_vector(WIDTH - 1 downto 0) := Bcoeff;
    
    signal left_multiplier_to_adder : std_logic_vector(WIDTH - 1 downto 0);
    signal right_multiplier_to_adder : std_logic_vector(WIDTH - 1 downto 0);
    signal left_adder_to_register : std_logic_vector(WIDTH - 1 downto 0);
    signal right_adder_to_register : std_logic_vector(WIDTH - 1 downto 0);
begin

--    NonZeroCoeffA:if signed(Acoeff) /= 0 generate
        LeftMultiplier:
        entity work.const_multiplier(Behavioral)
        generic map(WIDTH => WIDTH,
                    INTEGER_LENGTH => INTEGER_LENGTH,
                    FRACTION_LENGTH => FRACTION_LENGTH)
        port map(operand1=>input_signal,
                 operand2=>A,
                 result=>left_multiplier_to_adder);
        LeftAdder:
        entity work.adder(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(operand1 => left_multiplier_to_adder,
                 operand2 => left_adder_input,
                 result => left_adder_to_register);
        LeftRegister:
        entity work.data_register(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(clk=>clk,
                 data_in => left_adder_to_register,
                 data_out => left_reg_output,     
                 reset => reset);   
--    else generate
--        LeftRegister:
--        entity work.data_register(Behavioral)
--        generic map(WIDTH => 32)
--        port map(clk=>clk,
--                 data_in => left_adder_input,
--                 data_out => left_reg_output,     
--                 reset => reset);                
--    end generate;           
 
        RightMultiplier:
        entity work.const_multiplier(Behavioral)
        generic map(WIDTH => WIDTH,
                    INTEGER_LENGTH => INTEGER_LENGTH,
                    FRACTION_LENGTH => FRACTION_LENGTH)
        port map(operand1=>input_signal,
                 operand2=>B,
                 result=>right_multiplier_to_adder);
        RightAdder:
        entity work.adder(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(operand1 => right_multiplier_to_adder,
                 operand2 => right_adder_input,
                 result => right_adder_to_register);
        RightRegister:
        entity work.data_register(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(clk=>clk,
                 data_in => right_adder_to_register,
                 data_out => right_reg_output,     
                 reset => reset); 
end Structural;