
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
entity VOT_GEN1 is
	 Port (
		 en_neuron_1 : in std_logic;
		 count_1 : in unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_1: in std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_1: in std_logic; 
		 dato_out2_1 : in std_logic;
		 next_pipeline_step_1 : in std_logic;
		 en_neuron_2 : in std_logic;
		 count_2 : in unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_2: in std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_2: in std_logic; 
		 dato_out2_2 : in std_logic;
		 next_pipeline_step_2 : in std_logic;
		 en_neuron_3 : in std_logic;
		 count_3 : in unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_3: in std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_3: in std_logic; 
		 dato_out2_3 : in std_logic;
		 next_pipeline_step_3 : in std_logic;
		 en_neuron_v : out std_logic;
		 count_v : out unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_v: out std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_v: out std_logic; 
		 dato_out2_v : out std_logic;
		 next_pipeline_step_v : out std_logic);
end VOT_GEN1;
architecture Behavioral of VOT_GEN1 is
Begin 
next_pipeline_step_v <= (next_pipeline_step_1 and next_pipeline_step_2) or (next_pipeline_step_1 and next_pipeline_step_3) or (next_pipeline_step_2 and next_pipeline_step_3);
dato_out2_v <= (dato_out2_1 and dato_out2_2) or (dato_out2_1 and dato_out2_3) or (dato_out2_2 and dato_out2_3);
dato_out1_v <= (dato_out1_1 and dato_out1_2) or (dato_out1_1 and dato_out1_3) or (dato_out1_2 and dato_out1_3);
en_neuron_v <= (en_neuron_1 and en_neuron_2) or (en_neuron_1 and en_neuron_3) or (en_neuron_2 and en_neuron_3);
count_v <= (count_1 and count_2) or (count_1 and count_3) or (count_2 and count_3);
mul_v <= (mul_1 and mul_2) or (mul_1 and mul_3) or (mul_2 and mul_3);
end Behavioral;
