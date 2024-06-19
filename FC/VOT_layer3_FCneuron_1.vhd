library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity VOT_layer3_FCneuron_1 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end VOT_layer3_FCneuron_1 ;

architecture Behavioral of VOT_layer3_FCneuron_1 is
begin
neuron_mac_v <= (neuron_mac_1 and neuron_mac_2) or (neuron_mac_1 and neuron_mac_3) or (neuron_mac_2 and neuron_mac_3);
end Behavioral;

