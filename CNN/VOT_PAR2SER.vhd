library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
entity VOT_PAR2SER is
Port ( 
		 serial_out_1 : in STD_LOGIC;
		 serial_out_2 : in STD_LOGIC;
		 serial_out_3 : in STD_LOGIC;
		 serial_out_v : out STD_LOGIC);
end VOT_PAR2SER; 
architecture Behavioral of VOT_PAR2SER is
begin 

serial_out_v <= (serial_out_1 and serial_out_2) or (serial_out_1 and serial_out_3) or (serial_out_2 and serial_out_3);
end Behavioral;
