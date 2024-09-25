library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity axi_iir_v1_0 is
	generic (
        WIDTH: natural := 32;
        FILTER_ORDER: natural := 2;
        INTEGER_LENGTH: natural := 11;
        FRACTION_LENGTH: natural := 20
	);
	port (

		-- Ports of Axi Slave Bus Interface S00_AXIS_INPUT
		s00_axis_input_aclk   	: in std_logic;
		s00_axis_input_aresetn	: in std_logic;
		s00_axis_input_tready	: out std_logic;
		s00_axis_input_tdata	: in std_logic_vector(WIDTH-1 downto 0);
		s00_axis_input_tstrb	: in std_logic_vector((WIDTH/8)-1 downto 0);
		s00_axis_input_tlast	: in std_logic;
		s00_axis_input_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS_OUTPUT
		m00_axis_output_aclk    : in std_logic;
		m00_axis_output_aresetn	: in std_logic;
		m00_axis_output_tvalid	: out std_logic;
		m00_axis_output_tdata	: out std_logic_vector(WIDTH-1 downto 0);
		m00_axis_output_tstrb	: out std_logic_vector((WIDTH/8)-1 downto 0);
		m00_axis_output_tlast	: out std_logic;
		m00_axis_output_tready	: in std_logic
	);
end axi_iir_v1_0;

architecture arch_imp of axi_iir_v1_0 is

--    constant Acoeff_array:logic_vector_array_type_fixed:= 
--    (
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000"
--    );
    
--    constant Bcoeff_array:logic_vector_array_type_fixed:= 
--    (
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
--        x"00100000", x"00100000", x"00100000", x"00100000",x"00100000"
--    );
    
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

    signal ready_s : std_logic;
    signal input_data_valid_s : std_logic;
    signal input_transfer_finished_s : std_logic;
    
    signal input_data_s: std_logic_vector(WIDTH - 1 downto 0);
    signal output_data_s: std_logic_vector(WIDTH - 1 downto 0);
    signal input_data_to_filter_s : std_logic_vector(WIDTH - 1 downto 0);
    signal output_data_from_filter_s : std_logic_vector(WIDTH - 1 downto 0);
    
    signal reset_s : std_logic;
begin

-- Instantiation of Axi Bus Interface S00_AXIS_INPUT
AXI_STREAM_INPUT : entity work.axi_iir_v1_0_S00_AXIS_INPUT(Behavioral)
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> WIDTH
	)
	port map (
	    ready_i                   => ready_s,
        input_data_o              => input_data_s,
        input_data_valid_o        => input_data_valid_s,
        input_transfer_finished_o => input_transfer_finished_s,
        reset_o               => reset_s,
        
		S_AXIS_ACLK	    => s00_axis_input_aclk,
		S_AXIS_ARESETN	=> s00_axis_input_aresetn,
		S_AXIS_TREADY	=> s00_axis_input_tready,
		S_AXIS_TDATA	=> s00_axis_input_tdata,
		S_AXIS_TSTRB	=> s00_axis_input_tstrb,
		S_AXIS_TLAST	=> s00_axis_input_tlast,
		S_AXIS_TVALID	=> s00_axis_input_tvalid
	);

-- Instantiation of Axi Bus Interface M00_AXIS_OUTPUT
AXI_STREAM_OUTPUT : entity work.axi_iir_v1_0_M00_AXIS_OUTPUT(Behavioral)
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> WIDTH
	)
	port map (
	   	input_transfer_finished_i  => input_transfer_finished_s,
	    input_data_valid_i         => input_data_valid_s,
        output_data_i              => output_data_s,
        tstrb_propagate_i          => s00_axis_input_tstrb,
        ready_o                    => ready_s,
        
		M_AXIS_ACLK	    => m00_axis_output_aclk,
		M_AXIS_ARESETN	=> m00_axis_output_aresetn,
		M_AXIS_TVALID	=> m00_axis_output_tvalid,
		M_AXIS_TDATA	=> m00_axis_output_tdata,
		M_AXIS_TSTRB	=> m00_axis_output_tstrb,
		M_AXIS_TLAST	=> m00_axis_output_tlast,
		M_AXIS_TREADY	=> m00_axis_output_tready
	);

IIR_filter: entity work.transposed_direct_1(Mixed)
    Generic map (FILTER_ORDER => FILTER_ORDER,
                 WIDTH => WIDTH,
                 INTEGER_LENGTH => INTEGER_LENGTH,
                 FRACTION_LENGTH => FRACTION_LENGTH,
                 Acoeff_array => Acoeff_array,
                 Bcoeff_array => Bcoeff_array)
    Port map ( clk_i => s00_axis_input_aclk,
               reset_i => reset_s,
               input_i => input_data_to_filter_s,
               output_o => output_data_from_filter_s);

MEMORY_SUBSYSEM: entity work.memory_subsys(Structural)
    Generic Map(WIDTH => WIDTH)
    Port Map(
            clk_i => s00_axis_input_aclk,
            reset_i => reset_s,
            input_data_wen_i => input_data_valid_s,
            input_data_i => input_data_s,
            input_data_o => input_data_to_filter_s,
            output_data_i => output_data_from_filter_s,
            output_data_o => output_data_s
         );

    
end arch_imp;
