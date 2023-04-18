library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transposed_direct_1_cell is
    generic(WIDTH:natural:=32;
            INTEGER_LENGTH:natural:=11;
            FRACTION_LENGTH:natural:=20;
            Acoeff:std_logic_vector(31 downto 0):=(others=>'0');
            Bcoeff:std_logic_vector(31 downto 0):=(others=>'0')
    );
    Port ( clk_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           en_i : in STD_LOGIC;
           input_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           left_adder_input_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           right_adder_input_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           left_reg_output_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           right_reg_output_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end transposed_direct_1_cell;

architecture Structural of transposed_direct_1_cell is
    constant  A : std_logic_vector(WIDTH - 1 downto 0) := Acoeff;
    constant  B : std_logic_vector(WIDTH - 1 downto 0) := Bcoeff;
    
    signal left_multiplier_to_adder_s : std_logic_vector(WIDTH - 1 downto 0);
    signal right_multiplier_to_adder_s : std_logic_vector(WIDTH - 1 downto 0);
    signal left_adder_to_register_s : std_logic_vector(WIDTH - 1 downto 0);
    signal right_adder_to_register_s : std_logic_vector(WIDTH - 1 downto 0);
begin

--    NonZeroCoeffA:if signed(Acoeff) /= 0 generate
        LeftMultiplier:
        entity work.const_multiplier(Behavioral)
        generic map(WIDTH => WIDTH,
                    INTEGER_LENGTH => INTEGER_LENGTH,
                    FRACTION_LENGTH => FRACTION_LENGTH)
        port map(operand1_i=>input_i,
                 operand2_i=>A,
                 result_o=>left_multiplier_to_adder_s);
        LeftAdder:
        entity work.adder(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(operand1_i => left_multiplier_to_adder_s,
                 operand2_i => left_adder_input_i,
                 result_o => left_adder_to_register_s);
        LeftRegister:
        entity work.data_register_enable(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(clk_i=>clk_i,
                 en_i=>en_i,
                 data_in_i => left_adder_to_register_s,
                 data_out_o => left_reg_output_o,     
                 reset_i => reset_i);   
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
        port map(operand1_i=>input_i,
                 operand2_i=>B,
                 result_o=>right_multiplier_to_adder_s);
        RightAdder:
        entity work.adder(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(operand1_i => right_multiplier_to_adder_s,
                 operand2_i => right_adder_input_i,
                 result_o => right_adder_to_register_s);
        RightRegister:
        entity work.data_register_enable(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(clk_i=>clk_i,
                 en_i=>en_i,
                 data_in_i => right_adder_to_register_s,
                 data_out_o => right_reg_output_o,     
                 reset_i => reset_i); 
end Structural;