library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity VOT_sigmoidFCL2 is
	Port ( 
		 data_out_1 : in std_logic_vector(input_size_L2fc-1 downto 0);
		 data_out_2 : in std_logic_vector(input_size_L2fc-1 downto 0);
		 data_out_3 : in std_logic_vector(input_size_L2fc-1 downto 0);
		data_out_v : out std_logic_vector(input_size_L2fc-1 downto 0));
end VOT_sigmoidFCL2;

architecture Behavioral of VOT_sigmoidFCL2 is

Begin
data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);
end Behavioral;

