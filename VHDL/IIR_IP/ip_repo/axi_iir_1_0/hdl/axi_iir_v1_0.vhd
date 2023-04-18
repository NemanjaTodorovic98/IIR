library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity axi_iir_v1_0 is
	generic (
        FILTER_ORDER:natural:=3;
        WIDTH:natural:=32;
        INTEGER_LENGTH:natural:=11;
        FRACTION_LENGTH:natural:=20;
        Acoeff_array:logic_vector_array_type_fixed:= 
        (
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000"
        );
        Bcoeff_array:logic_vector_array_type_fixed:= 
        (
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000",
            x"00100000", x"00100000", x"00100000", x"00100000",x"00100000"
        );
		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 8
	);
	port (
        DEBUG_input : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
        DEBUG_output : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
        DEBUG_command : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
        DEBUG_ready : out STD_LOGIC;   
	      
		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic
	);
end axi_iir_v1_0;

architecture arch_imp of axi_iir_v1_0 is

    signal reg_data_s : STD_LOGIC_VECTOR(C_S00_AXI_DATA_WIDTH - 1 downto 0);
    signal input_data_wr_s : STD_LOGIC;
    signal command_wr_s : STD_LOGIC;
    signal input_data_axi_s : STD_LOGIC_VECTOR(C_S00_AXI_DATA_WIDTH - 1 downto 0);
    signal command_axi_s : STD_LOGIC_VECTOR(C_S00_AXI_DATA_WIDTH - 1 downto 0);
    signal status_axi_s : STD_LOGIC;
    
    signal output_axi_s : STD_LOGIC_VECTOR(C_M00_AXIS_TDATA_WIDTH - 1 downto 0);
    signal ready_axi_s : STD_LOGIC;
    
    signal reset_s : STD_LOGIC;
    signal input_s : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal output_s : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
    signal command_s : STD_LOGIC_VECTOR(WIDTH - 1 downto 0);
     
begin

-- Instantiation of Axi Bus Interface S00_AXI
axi_iir_v1_0_S00_AXI_inst : entity work.axi_iir_v1_0_S00_AXI(arch_imp)
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	
	    reg_data_o => reg_data_s,
        input_data_wr_o => input_data_wr_s,
        command_wr_o => command_wr_s,
        input_data_axi_i => input_data_axi_s,
        command_axi_i => command_axi_s,
        status_axi_i => status_axi_s,
        
		S_AXI_ACLK	    => s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	    => s00_axi_wdata,
		S_AXI_WSTRB	    => s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP  	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	    => s00_axi_rdata,
		S_AXI_RRESP	    => s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

-- Instantiation of Axi Bus Interface M00_AXIS
axi_iir_v1_0_M00_AXIS_inst : entity work.axi_iir_v1_0_M00_AXIS(implementation)
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	        => C_M00_AXIS_START_COUNT
	)
	port map (
	    output_axi_i => output_axi_s,
        ready_axi_o => ready_axi_s,

		M_AXIS_ACLK	    => m00_axis_aclk,
		M_AXIS_ARESETN	=> m00_axis_aresetn,
		M_AXIS_TVALID	=> m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TSTRB	=> m00_axis_tstrb,
		M_AXIS_TLAST	=> m00_axis_tlast,
		M_AXIS_TREADY	=> m00_axis_tready
	);

    IIR_filter:entity work.IIR_filter(Structural)
    generic map(FILTER_ORDER => FILTER_ORDER,
                WIDTH => WIDTH,
                INTEGER_LENGTH => INTEGER_LENGTH,
                FRACTION_LENGTH => FRACTION_LENGTH,
                Acoeff_array => Acoeff_array,
                Bcoeff_array => Bcoeff_array
                )
    port map(
            clk_i => s00_axi_aclk,
            input_i => input_s,
            command_i => command_s,
            output_o => output_s,
            reset_o => reset_s
            );
            
    MEMORY_SUBSYS:entity work.memory_subsys(Structural)
    Generic map(WIDTH => WIDTH)
    Port map(
            clk_i => s00_axi_aclk,
            reset_i => reset_s,
            reg_data_i => reg_data_s,
            input_data_wr_i => input_data_wr_s,
            command_wr_i => command_wr_s,
            output_i => output_s,
            output_axi_o => output_axi_s,
            input_data_o => input_s,
            input_data_axi_o => input_data_axi_s,
            command_o => command_s,
            command_axi_o => command_axi_s,
            ready_i => ready_axi_s,
            ready_axi_o => status_axi_s      
         );
    
    DEBUG_input <= input_s;
    DEBUG_output <= output_s;
    DEBUG_command <= command_s;
    DEBUG_ready <= ready_axi_s;
       
end arch_imp;
