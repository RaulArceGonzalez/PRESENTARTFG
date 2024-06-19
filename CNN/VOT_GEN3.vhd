library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
entity VOT_GEN3 is
	 Port ( 
		 dato_new_1 : in std_logic;
 		 layer_1 : in std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_1 : in std_logic;
		 next_dato_pool_1 : in std_logic;
		 dato_new_2 : in std_logic;
 		 layer_2 : in std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_2 : in std_logic;
		 next_dato_pool_2 : in std_logic;
		 dato_new_3 : in std_logic;
 		 layer_3 : in std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_3 : in std_logic;
		 next_dato_pool_3 : in std_logic;
		 dato_new_v : out std_logic;
 		 layer_v : out std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_v : out std_logic;
		 next_dato_pool_v : out std_logic);
end VOT_GEN3; 
architecture Behavioral of VOT_GEN3 is
begin
next_dato_pool_v <= (next_dato_pool_1 and next_dato_pool_2) or (next_dato_pool_1 and next_dato_pool_3) or (next_dato_pool_2 and next_dato_pool_3);
dato_new_v <= (dato_new_1 and dato_new_2) or (dato_new_1 and dato_new_3) or (dato_new_2 and dato_new_3);
index_v <= (index_1 and index_2) or (index_1 and index_3) or (index_2 and index_3);
layer_v <= (layer_1 and layer_2) or (layer_1 and layer_3) or (layer_2 and layer_3);
end Behavioral;
