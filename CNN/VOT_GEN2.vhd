library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
entity VOT_GEN2 is
 Port ( 
		 layer_1 : in std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_1 : in unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_1: in std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_1: in std_logic; 
		 dato_out2_1 : in std_logic;
		 index_1 : in std_logic;
		 en_neurona_1 : in std_logic;
		 next_dato_pool_1 : in std_logic;
		 next_pipeline_step_1 : in std_logic;
		 layer_2 : in std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_2 : in unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_2: in std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_2: in std_logic; 
		 dato_out2_2 : in std_logic;
		 index_2 : in std_logic;
		 en_neurona_2 : in std_logic;
		 next_dato_pool_2 : in std_logic;
		 next_pipeline_step_2 : in std_logic;
		 layer_3 : in std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_3 : in unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_3: in std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_3: in std_logic; 
		 dato_out2_3 : in std_logic;
		 index_3 : in std_logic;
		 en_neurona_3 : in std_logic;
		 next_dato_pool_3 : in std_logic;
		 next_pipeline_step_3 : in std_logic;
		 layer_v : out std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_v : out unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_v: out std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_v: out std_logic; 
		 dato_out2_v : out std_logic;
		 index_v : out std_logic;
		 en_neurona_v : out std_logic;
		 next_dato_pool_v : out std_logic;
		 next_pipeline_step_v : out std_logic);
end VOT_GEN2; 
architecture Behavioral of VOT_GEN2 is
begin

next_dato_pool_v <= (next_dato_pool_1 and next_dato_pool_2) or (next_dato_pool_1 and next_dato_pool_3) or (next_dato_pool_2 and next_dato_pool_3);
next_pipeline_step_v <= (next_pipeline_step_1 and next_pipeline_step_2) or (next_pipeline_step_1 and next_pipeline_step_3) or (next_pipeline_step_2 and next_pipeline_step_3);
dato_out2_v <= (dato_out2_1 and dato_out2_2) or (dato_out2_1 and dato_out2_3) or (dato_out2_2 and dato_out2_3);
dato_out1_v <= (dato_out1_1 and dato_out1_2) or (dato_out1_1 and dato_out1_3) or (dato_out1_2 and dato_out1_3);
en_neurona_v <= (en_neurona_1 and en_neurona_2) or (en_neurona_1 and en_neurona_3) or (en_neurona_2 and en_neurona_3);
count_v <= (count_1 and count_2) or (count_1 and count_3) or (count_2 and count_3);
mul_v <= (mul_1 and mul_2) or (mul_1 and mul_3) or (mul_2 and mul_3);
index_v <= (index_1 and index_2) or (index_1 and index_3) or (index_2 and index_3);
layer_v <= (layer_1 and layer_2) or (layer_1 and layer_3) or (layer_2 and layer_3);
end Behavioral;
