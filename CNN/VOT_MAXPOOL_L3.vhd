library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;
entity VOT_MAXPOOL_L3 is
 generic (
 input_size : integer := 8; 
 weight_size : integer := 8);
Port (
      data_out_1 : in STD_LOGIC_VECTOR(input_size - 1 downto 0);
      data_out_2 : in STD_LOGIC_VECTOR(input_size - 1 downto 0);
      data_out_3 : in STD_LOGIC_VECTOR(input_size - 1 downto 0);
      data_out_v : out STD_LOGIC_VECTOR(input_size - 1 downto 0));
end VOT_MAXPOOL_L3;

architecture Behavioral of VOT_MAXPOOL_L3 is
begin
data_out_v <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);
end Behavioral;
