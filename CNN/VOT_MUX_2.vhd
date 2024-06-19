library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.tfg_irene_package.all;

entity  VOT_MUX_2 is
	Port( 
		 data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0); 
		 data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0); 
		 data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0); 
		 data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0));
end VOT_MUX_2; 
architecture Behavioral of VOT_MUX_2 is
begin
data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);
end Behavioral;

