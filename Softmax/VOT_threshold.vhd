library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;


entity VOT_threshold is
    Port (
	      y_out_1 : in unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish_1 : in std_logic;
	      y_out_2 : in unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish_2 : in std_logic;
	      y_out_3 : in unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish_3 : in std_logic;
	      y_out : out unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish : out std_logic);
end VOT_threshold;

architecture Behavioral of VOT_threshold is
begin
y_out <= (y_out_1 and y_out_2) or (y_out_1 and y_out_3) or (y_out_2 and y_out_3);
finish <= (finish_1 and finish_2) or (finish_1 and finish_3) or (finish_2 and finish_3);
end Behavioral;
