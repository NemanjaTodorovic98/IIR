library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity transposed_direct_1_last_cell is
    generic(WIDTH:natural:=16;
            Acoeff:std_logic_vector(31 downto 0);
            Bcoeff:std_logic_vector(31 downto 0)
    );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           input_signal : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           left_reg_output : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0);
           right_reg_output : out STD_LOGIC_VECTOR (2*WIDTH - 1 downto 0)
    );
end transposed_direct_1_last_cell;

architecture Structural of transposed_direct_1_last_cell is

    constant  A : std_logic_vector(WIDTH - 1 downto 0) := Acoeff;
    constant  B : std_logic_vector(WIDTH - 1 downto 0) := Bcoeff;
    
    signal left_multiplier_to_register : std_logic_vector(2*WIDTH - 1 downto 0);
    signal right_multiplier_to_register : std_logic_vector(2*WIDTH - 1 downto 0);

begin

--    NonZeroCoeffA:if signed(Acoeff) /= 0 generate
        LeftMultiplier:
        entity work.const_multiplier(Behavioral)
        generic map(WIDTH => WIDTH)
        port map(operand1=>input_signal,
                 operand2=>A,
                 result=>left_multiplier_to_register);
        LeftRegister:
        entity work.data_register(Behavioral)
        generic map(WIDTH => 2*WIDTH)
        port map(clk=>clk,
                 data_in => left_multiplier_to_register,
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
        generic map(WIDTH => WIDTH)
        port map(operand1=>input_signal,
                 operand2=>B,
                 result=>right_multiplier_to_register);
        RightRegister:
        entity work.data_register(Behavioral)
        generic map(WIDTH => 2*WIDTH)
        port map(clk=>clk,
                 data_in => right_multiplier_to_register,
                 data_out => right_reg_output,     
                 reset => reset); 
end Structural;
