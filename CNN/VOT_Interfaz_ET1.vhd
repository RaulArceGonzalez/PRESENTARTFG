
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VOT_INTERFAZ_ET1 is
Port (
		 dato_out_1 : in std_logic;
		 cero_1 : in std_logic;
		 cero2_1 : in std_logic;
		 dato_cero_1 : in std_logic;
		 dato_cero2_1 : in std_logic;
		 dato_addr_1 : in std_logic;
		 address_1 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_1 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 dato_out_2 : in std_logic;
		 cero_2 : in std_logic;
		 cero2_2 : in std_logic;
		 dato_cero_2 : in std_logic;
		 dato_cero2_2 : in std_logic;
		 dato_addr_2 : in std_logic;
		 address_2 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_2 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 dato_out_3 : in std_logic;
		 cero_3 : in std_logic;
		 cero2_3 : in std_logic;
		 dato_cero_3 : in std_logic;
		 dato_cero2_3 : in std_logic;
		 dato_addr_3 : in std_logic;
		 address_3 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_3 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 dato_out_v : out std_logic;
		 cero_v : out std_logic;
		 cero2_v : out std_logic;
		 dato_cero_v : out std_logic;
		 dato_cero2_v : out std_logic;
		 dato_addr_v : out std_logic;
		 address_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0));
end VOT_Interfaz_ET1;
architecture Behavioral of VOT_Interfaz_ET1 is

begin
dato_out_v <= (dato_out_1 and dato_out_2) or (dato_out_1 and dato_out_3) or (dato_out_2 and dato_out_3);
cero_v <= (cero_1 and cero_2) or (cero_1 and cero_3) or (cero_2 and cero_3);
cero2_v <= (cero2_1 and cero2_2) or (cero2_1 and cero2_3) or (cero2_2 and cero2_3);
dato_cero_v <= (dato_cero_1 and dato_cero_2) or (dato_cero_1 and dato_cero_3) or (dato_cero_2 and dato_cero_3);
dato_cero2_v <= (dato_cero2_1 and dato_cero2_2) or (dato_cero2_1 and dato_cero2_3) or (dato_cero2_2 and dato_cero2_3);
dato_addr_v <= (dato_addr_1 and dato_addr_2) or (dato_addr_1 and dato_addr_3) or (dato_addr_2 and dato_addr_3);
address_v <= (address_1 and address_2) or (address_1 and address_3) or (address_2 and address_3);
address2_v <= (address2_1 and address2_2) or (address2_1 and address2_3) or (address2_2 and address2_3);
end Behavioral;
