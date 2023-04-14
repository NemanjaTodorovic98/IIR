library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    generic (WIDTH: natural:=32);
    Port ( clk_i : in STD_LOGIC;
           command_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           en_o : out STD_LOGIC;
           reset_o : out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

    constant start_cmd : std_logic_vector(1 downto 0) := "01"; 
    constant stop_cmd : std_logic_vector(1 downto 0) := "11";  

    type state_type is (Initialize, Run, Idle, Undefined);
    
    signal current_state_s : state_type := Idle;
    signal next_state_s : state_type;
    
    signal command_reg_s : std_logic_vector (WIDTH - 1 downto 0);
    signal command_s : std_logic_vector (1 downto 0);  

begin
  
    STATE_MACHINE:
    process(current_state_s) is
    begin
        case current_state_s is
        
            when Initialize =>  
                en_o <= '0';
                reset_o <= '1';
                          
                case command_s is
                    when start_cmd =>
                        next_state_s <= Run;  
                    when stop_cmd =>
                        next_state_s <= Idle;
                    when others =>
                        next_state_s <= Undefined;
                end case;             
                
            when Run =>
                en_o <= '1';
                reset_o <= '0';
                
                case command_s is
                    when start_cmd =>
                        next_state_s <= Run;  
                    when stop_cmd =>
                        next_state_s <= Idle;
                    when others =>
                        next_state_s <= Undefined;  
                end case;         
                    
            when Idle =>
                en_o <= '0';
                reset_o <= '0';
                
                case command_s is
                    when start_cmd =>
                        next_state_s <= Initialize;  
                    when stop_cmd =>
                        next_state_s <= Idle;
                    when others =>
                        next_state_s <= Undefined;
                end case;             
                                        
            when others => 
                en_o <= '0';
                reset_o <= '0';
                next_state_s <= Undefined;
        end case;       
    end process;

    STATE_REGISTER:
    process(clk_i) is
    begin
        if(clk_i'event and clk_i = '1')then
            current_state_s <= next_state_s;           
        end if;
    end process;
    
    COMMAND_REGISTER:
    process(clk_i) is
    begin
        if(clk_i'event and clk_i = '1')then
            command_reg_s <= command_i;
        else
            command_reg_s <= command_reg_s;
        end if;
    end process;
    
    command_s <= command_reg_s(1 downto 0);
    

end Behavioral;
