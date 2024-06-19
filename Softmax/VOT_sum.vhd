library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity VOT_sum is
	 Port ( 
        neuron_mac_1 : in std_logic_vector (input_size_L4fc-1 downto 0);
        neuron_mac_2 : in std_logic_vector (input_size_L4fc-1 downto 0);
        neuron_mac_3 : in std_logic_vector (input_size_L4fc-1 downto 0);
        neuron_mac_v : out std_logic_vector (input_size_L4fc-1 downto 0));
end VOT_sum;

architecture Behavioral of VOT_sum is

begin
neuron_mac_v <= (neuron_mac_1 and neuron_mac_2) or (neuron_mac_1 and neuron_mac_3) or (neuron_mac_2 and neuron_mac_3);
end Behavioral;

