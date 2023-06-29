library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_iir_v1_0_S00_AXIS_INPUT is
	generic (
		-- AXI4Stream sink: Data Width
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
        ready_i : in STD_LOGIC;
        reset_int_i : in STD_LOGIC;
        
        input_data_o : out STD_LOGIC_VECTOR(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        input_data_valid_o : out STD_LOGIC;
        input_transfer_finished_o : out STD_LOGIC;
        reset_ext_o : out STD_LOGIC;

		-- AXI4Stream sink: Clock
		S_AXIS_ACLK	: in std_logic;
		-- AXI4Stream sink: Reset
		S_AXIS_ARESETN	: in std_logic;
		-- Ready to accept data in
		S_AXIS_TREADY	: out std_logic;
		-- Data in
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		-- Byte qualifier
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- Indicates boundary of last packet
		S_AXIS_TLAST	: in std_logic;
		-- Data is in valid
		S_AXIS_TVALID	: in std_logic
	);
end axi_iir_v1_0_S00_AXIS_INPUT;

architecture Behavioral of axi_iir_v1_0_S00_AXIS_INPUT is
    
    signal input_transfer_finished_s : std_logic := '0';
    
begin

	S_AXIS_TREADY <=  ready_i;

    TRANSFER_ENDED:process(S_AXIS_ACLK) is
    begin
        if(rising_edge(S_AXIS_ACLK)) then
            if (not S_AXIS_ARESETN = '1' or reset_int_i = '1') then
                input_transfer_finished_s <= '0';
            elsif (S_AXIS_TLAST = '1') then
                input_transfer_finished_s <= '1'; 
            end if;
        end if;
    end process;
    
    input_transfer_finished_o <= input_transfer_finished_s;

    input_data_o <= S_AXIS_TDATA;
    input_data_valid_o <= S_AXIS_TVALID;
    
    reset_ext_o <= not S_AXIS_ARESETN;
    
end Behavioral;
