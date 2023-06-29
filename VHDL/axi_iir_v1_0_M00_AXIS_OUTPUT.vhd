library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_iir_v1_0_M00_AXIS_OUTPUT is
	generic (

		-- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
	   
	    input_transfer_finished_i : in STD_LOGIC;
	    
	    input_data_valid_i : in STD_LOGIC;
	    
	    reset_ext_i : in STD_LOGIC;
	    
        output_data_i : in STD_LOGIC_VECTOR(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
        
        tstrb_propagate_i : in STD_LOGIC_VECTOR((C_M_AXIS_TDATA_WIDTH/8) - 1 downto 0);

        ready_o : out STD_LOGIC;
        
        output_transfer_finished_o : out STD_LOGIC;
        
		-- Global ports
		M_AXIS_ACLK	: in std_logic;
		-- 
		M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	: in std_logic
	);
end axi_iir_v1_0_M00_AXIS_OUTPUT;

architecture Behavioral of axi_iir_v1_0_M00_AXIS_OUTPUT is

	-- AXI Stream internal signals
	--streaming data valid
	signal axis_tvalid : std_logic := '0';
	--streaming data valid delayed by one clock cycle
	signal axis_tvalid_delay : std_logic := '0';
	--Last of the streaming data 
	signal axis_tlast : std_logic := '0';
	--Last of the streaming data delayed by one clock cycle
	signal axis_tlast_delay	: std_logic := '0';
	
	signal reset_s : std_logic := '0';

begin
	-- I/O Connections assignments

	M_AXIS_TVALID	<= axis_tvalid_delay;
	
	M_AXIS_TLAST	<= axis_tlast_delay;
	M_AXIS_TSTRB	<= tstrb_propagate_i;
                                                                             
	axis_tvalid <= input_data_valid_i;
	                                                                                                                                                         
	axis_tlast <= input_transfer_finished_i;              
	                                                                                               
	-- Delay the axis_tvalid and axis_tlast signal by one clock cycle                                                                                     
	process(M_AXIS_ACLK)                                                                           
	begin                                                                                          
	  if (rising_edge (M_AXIS_ACLK)) then                                                          
	    if(reset_s = '1' or reset_ext_i = '1') then                                                                                                                            
	      axis_tlast_delay <= '0';
	      axis_tvalid_delay <= '0';                                                                 
	    else                                                                                                                                            
	      axis_tlast_delay <= axis_tlast;
	      axis_tvalid_delay <= axis_tvalid;                                                          
	    end if;                                                                                    
	  end if;                                                                                      
	end process;                                                                                   
    
    M_AXIS_TDATA <= output_data_i;
    
    reset_s <= not M_AXIS_ARESETN;
    
    ready_o <= M_AXIS_TREADY;-- and axis_tvalid_delay;
    
    output_transfer_finished_o <= axis_tlast_delay;

end Behavioral;