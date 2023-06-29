library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use work.types.all;
use work.txt_util.all;

entity TB_axi_iir_v1_0 is
--  Port ( );
end TB_axi_iir_v1_0;

architecture Behavioral of TB_axi_iir_v1_0 is
    
    constant CLOCK_PERIOD:time:= 200ns;

    constant WIDTH:natural:=32;
    
    constant FILTER_ORDER:natural:=8;
    
    constant INTEGER_LENGTH:natural:= 11;
    
    constant FRACTION_LENGTH:natural:= 20;
    
    constant Acoeff_array:logic_vector_array_type_fixed:= 
    (
        "00000000000100000000000000000000", 
        "00000000010010100100001101000001", 
        "11111111010011110111111010000100", 
        "00000001000011010111110100100011",
        "11111110111000101100110101011100",
        "00000000110101001101011010111010", 
        "11111111100100101011101001010010", 
        "00000000001000110110110101110100",
        "11111111111110100110000010100111",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000"
    );
    constant Bcoeff_array:logic_vector_array_type_fixed:= 
    (
        "00000000000000000000000010000100", 
        "00000000000000000000010000100011", 
        "00000000000000000000111001111100", 
        "00000000000000000001110011111000",
        "00000000000000000010010000110110",
        "00000000000000000001110011111000", 
        "00000000000000000000111001111100", 
        "00000000000000000000010000100011", 
        "00000000000000000000000010000100",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000"
    );

    -- Parameters of Axi-Stream Slave Bus Interface S00_AXI
    constant C_S00_AXIS_INPUT_TDATA_WIDTH : integer := 32;
    -- Parameters of Axi-Stream Master Bus Interface M00_AXIS
    constant C_M00_AXIS_OUTPUT_TDATA_WIDTH : integer := 32;
    
    -- Ports of Axi Slave Bus Interface S00_AXIS_INPUT
    signal s00_axis_input_aclk_s	: std_logic;
    signal s00_axis_input_aresetn_s	: std_logic;
    signal s00_axis_input_tready_s	: std_logic;
    signal s00_axis_input_tdata_s	: std_logic_vector(C_S00_AXIS_INPUT_TDATA_WIDTH-1 downto 0);
    signal s00_axis_input_tstrb_s	: std_logic_vector((C_S00_AXIS_INPUT_TDATA_WIDTH/8)-1 downto 0);
    signal s00_axis_input_tlast_s	: std_logic;
    signal s00_axis_input_tvalid_s	: std_logic;
    
    -- Ports of Axi-Stream Master Bus Interface M00_AXIS_OUTPUT
    signal m00_axis_output_aclk_s    : std_logic;
    signal m00_axis_output_aresetn_s : std_logic;
    signal m00_axis_output_tvalid_s  : std_logic;
    signal m00_axis_output_tdata_s	 : std_logic_vector(C_M00_AXIS_OUTPUT_TDATA_WIDTH-1 downto 0);
    signal m00_axis_output_tstrb_s	 : std_logic_vector((C_M00_AXIS_OUTPUT_TDATA_WIDTH/8)-1 downto 0);
    signal m00_axis_output_tlast_s   : std_logic;
    signal m00_axis_output_tready_s  : std_logic;
    
    file input_test_vector : text open read_mode is "C:\Users\Nemanja\Desktop\IIR filter\SystemInput.txt";
    file expected_results : text open read_mode is "C:\Users\Nemanja\Desktop\IIR filter\SystemOutput.txt";
    
    signal clk_s: std_logic;
    
    signal input_s : std_logic_vector(WIDTH - 1 downto 0);
    signal output_s : std_logic_vector(WIDTH - 1 downto 0);
    signal expected_s : std_logic_vector(WIDTH - 1 downto 0);
    
    signal INPUT_DEBUG : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal OUTPUT_DEBUG : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);

begin

    CLOCK: process
    begin
        clk_s <= '0', '1' after CLOCK_PERIOD/2;
        wait for CLOCK_PERIOD;
    end process;
    
    s00_axis_input_aclk_s <= clk_s;
    m00_axis_output_aclk_s <= clk_s;
    
    s00_axis_input_aresetn_s <= '0', '1' after CLOCK_PERIOD;
    m00_axis_output_aresetn_s <= '1';
    s00_axis_input_tstrb_s <= "1111";
    
    INPUT_GENERATION:process
        variable file_line : line;
    begin
        s00_axis_input_tvalid_s <= '0';
        wait for CLOCK_PERIOD;
        --wait until s00_axis_input_tready_s = '1';
        while not endfile(input_test_vector) loop
            --wait until s00_axis_input_tready_s = '1';
            readline(input_test_vector,file_line);
            input_s <= to_std_logic_vector(string(file_line));
            s00_axis_input_tdata_s <= to_std_logic_vector(string(file_line));          
--            s00_axis_input_tready_s
            s00_axis_input_tvalid_s	<= '1';
            wait until falling_edge(clk_s);
        end loop;
    end process;
    
    END_INPUT_STREAM:s00_axis_input_tlast_s <= '0', '1' after 20*CLOCK_PERIOD;

    EXPECTED_OUTPUT:process
        variable file_line : line;
    begin
        expected_s <= (others=>'0');
        wait for 2*CLOCK_PERIOD;
        wait until rising_edge(clk_s);
        while not endfile(expected_results) loop
            readline(expected_results,file_line);
            expected_s <= to_std_logic_vector(string(file_line));
            wait until rising_edge(clk_s);
        end loop;
    end process;
    
    m00_axis_output_tready_s <= '1';
    output_s <= m00_axis_output_tdata_s;

    DUT:entity work.axi_iir_v1_0(arch_imp)
    generic map(
                    FILTER_ORDER => FILTER_ORDER,
                    WIDTH => WIDTH,
                    INTEGER_LENGTH => INTEGER_LENGTH,
                    FRACTION_LENGTH => FRACTION_LENGTH
	            )
	port map(
                -- Ports of Axi Slave Bus Interface S00_AXIs
                s00_axis_input_aclk => s00_axis_input_aclk_s,
                s00_axis_input_aresetn => s00_axis_input_aresetn_s,
                s00_axis_input_tready => s00_axis_input_tready_s,
                s00_axis_input_tdata => s00_axis_input_tdata_s,
                s00_axis_input_tstrb => s00_axis_input_tstrb_s,
                s00_axis_input_tlast => s00_axis_input_tlast_s,
                s00_axis_input_tvalid => s00_axis_input_tvalid_s,

                -- Ports of Axi Master Bus Interface M00_AXIS
                m00_axis_output_aclk => m00_axis_output_aclk_s,
                m00_axis_output_aresetn => m00_axis_output_aresetn_s,
                m00_axis_output_tvalid => m00_axis_output_tvalid_s,
                m00_axis_output_tdata => m00_axis_output_tdata_s,
                m00_axis_output_tstrb => m00_axis_output_tstrb_s,
                m00_axis_output_tlast => m00_axis_output_tlast_s,
                m00_axis_output_tready => m00_axis_output_tready_s
	        );
    
end Behavioral;
