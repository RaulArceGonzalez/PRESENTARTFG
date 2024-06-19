------ MUX ---------
--This module selects the output signal to transmit each of the output signals of the filters of one layer as an input signal to the filters of the next layer.
--as input signal to the filters of the next layer. In this way we transmit the result matrix to the next layer.
--INPUTS
--data_inx : output signal of the convolutional filter, one for each filter
--index: signal that selects the output signal, its value goes from 0 to the number of layers.
--OUTPUTS
--data_out : selected output signal 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.tfg_irene_package.ALL;

ENTITY MUX_3 IS
	PORT (
		data_in0 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in1 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in2 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in3 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in4 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in5 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in6 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in7 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in8 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in9 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in10 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in11 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in12 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in13 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in14 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		data_in15 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
		index : IN STD_LOGIC_VECTOR(log2c(number_of_layers3) - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
END MUX_3;
ARCHITECTURE Behavioral OF MUX_3 IS
SIGNAL data_out_1, data_out_2,data_out_3 : STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
BEGIN
	    data_out_1 <= data_in0 WHEN index = "0000" ELSE
		data_in1 WHEN index = "0001" ELSE
		data_in2 WHEN index = "0010" ELSE
		data_in3 WHEN index = "0011" ELSE
		data_in4 WHEN index = "0100" ELSE
		data_in5 WHEN index = "0101" ELSE
		data_in6 WHEN index = "0110" ELSE
		data_in7 WHEN index = "0111" ELSE
		data_in8 WHEN index = "1000" ELSE
		data_in9 WHEN index = "1001" ELSE
		data_in10 WHEN index = "1010" ELSE
		data_in11 WHEN index = "1011" ELSE
		data_in12 WHEN index = "1100" ELSE
		data_in13 WHEN index = "1101" ELSE
		data_in14 WHEN index = "1110" ELSE
		data_in15 WHEN index = "1111" ELSE
		(OTHERS => '0');
		data_out_2 <= data_in0 WHEN index = "0000" ELSE
		data_in1 WHEN index = "0001" ELSE
		data_in2 WHEN index = "0010" ELSE
		data_in3 WHEN index = "0011" ELSE
		data_in4 WHEN index = "0100" ELSE
		data_in5 WHEN index = "0101" ELSE
		data_in6 WHEN index = "0110" ELSE
		data_in7 WHEN index = "0111" ELSE
		data_in8 WHEN index = "1000" ELSE
		data_in9 WHEN index = "1001" ELSE
		data_in10 WHEN index = "1010" ELSE
		data_in11 WHEN index = "1011" ELSE
		data_in12 WHEN index = "1100" ELSE
		data_in13 WHEN index = "1101" ELSE
		data_in14 WHEN index = "1110" ELSE
		data_in15 WHEN index = "1111" ELSE
		(OTHERS => '0');
		data_out_3 <= data_in0 WHEN index = "0000" ELSE
		data_in1 WHEN index = "0001" ELSE
		data_in2 WHEN index = "0010" ELSE
		data_in3 WHEN index = "0011" ELSE
		data_in4 WHEN index = "0100" ELSE
		data_in5 WHEN index = "0101" ELSE
		data_in6 WHEN index = "0110" ELSE
		data_in7 WHEN index = "0111" ELSE
		data_in8 WHEN index = "1000" ELSE
		data_in9 WHEN index = "1001" ELSE
		data_in10 WHEN index = "1010" ELSE
		data_in11 WHEN index = "1011" ELSE
		data_in12 WHEN index = "1100" ELSE
		data_in13 WHEN index = "1101" ELSE
		data_in14 WHEN index = "1110" ELSE
		data_in15 WHEN index = "1111" ELSE
		(OTHERS => '0');
		data_out <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);
END Behavioral;