--------------------------FC NEURON MODULE------------------------------------
-- This module performs the MAAC operation which consists of the addition of each multiplication of a signal by its corresponding weight.
-- It is performed by adding a 1 each time the input pulse indicates that the signal is not zero. 
---INPUTS
-- data_in : each bit of the input data.
-- rom_addr : indicates which weight to operate with, corresponding to the input_data
-- next_pipeline_step : notifies when all the input data has been processed and moves on to the next set of data.
-- bit select : indicates which bit of the input data we are receiving at each moment.
---OUTPUTS
-- neuron_mac : the output is the accumulation of the input signals multiplied by the respective weights.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY layer2_FCneuron_26 IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		data_in_bit : IN STD_LOGIC;
		next_pipeline_step : IN STD_LOGIC;
		bit_select : IN unsigned (log2c(input_size_L2fc) - 1 DOWNTO 0);
		rom_addr : IN STD_LOGIC_VECTOR (log2c(number_of_layers3) + log2c(result_size) - 1 DOWNTO 0);
		neuron_mac : OUT STD_LOGIC_VECTOR (input_size_L2fc + weight_size_L2fc + n_extra_bits - 1 DOWNTO 0));
END layer2_FCneuron_26;

ARCHITECTURE Behavioral OF layer2_FCneuron_26 IS

	SIGNAL mac_out_next, mac_out_reg : signed (input_size_L2fc + weight_size_L2fc + n_extra_bits - 1 DOWNTO 0) := "0000000000000000000"; --We add extra bits for precision.
	SIGNAL mux_out3 : signed (input_size_L2fc + weight_size_L2fc + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL weight, aux_weight : signed (weight_size_L2fc - 1 DOWNTO 0);
	SIGNAL mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_size_L2fc + input_size_L2fc - 2 DOWNTO 0);
	-- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".

BEGIN

	-- Register --
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (rst = '0') THEN
				mac_out_reg <= "0000000000000000000";
				shifted_weight_reg <= (OTHERS => '0');
			ELSE
				mac_out_reg <= mac_out_next;
				shifted_weight_reg <= shifted_weight_next;
			END IF;
		END IF;
	END PROCESS;

	-- Weight extension
	extended_weight <= resize(weight, weight_size_L2fc + input_size_L2fc - 1); -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).

	-- Shift block --
	mux_out1 <= extended_weight WHEN (bit_select = "000") ELSE
		shifted_weight_reg;

	shifted_weight_next <= mux_out1(weight_size_L2fc + input_size_L2fc - n_extra_bits DOWNTO 0) & '0'; -- Logic Shift Left

	-- Addition block
	PROCESS (data_in_bit, mux_out1) --If the input bit is 1 we add the shifted weight to the accumulated result.  
	BEGIN
		IF (data_in_bit = '1') THEN
			mux_out2 <= mux_out1;
		ELSE
			mux_out2 <= (OTHERS => '0');
		END IF;
	END PROCESS;
	mux_out3 <= resize(mux_out2, input_size_L2fc + weight_size_L2fc + n_extra_bits);

	PROCESS (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3) --if next_pipeline_step = '1' it means that the MAAC operation is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.
	BEGIN
		IF (next_pipeline_step = '1') THEN
			mac_out_next <= "0000000000000000000"; --We add the bias_term as an offset at the beggining of each operation.
		ELSE
			mac_out_next <= mac_out_reg + mux_out3;
		END IF;
	END PROCESS;
	neuron_mac <= STD_LOGIC_VECTOR(mac_out_reg);
	-- ROM --
	WITH rom_addr SELECT weight <=

		"00000000" WHEN "000000000", -- Weight 0  
		"00000000" WHEN "000000001", -- Weight 1  
		"00001000" WHEN "000000010", -- Weight 2  
		"00000000" WHEN "000000011", -- Weight 3  
		"00000000" WHEN "000000100", -- Weight 4  
		"00000000" WHEN "000000101", -- Weight 5  
		"00000000" WHEN "000000110", -- Weight 6  
		"00000000" WHEN "000000111", -- Weight 7  
		"00000000" WHEN "000001000", -- Weight 8  
		"00000000" WHEN "000001001", -- Weight 9  
		"00000000" WHEN "000001010", -- Weight 10  
		"11111000" WHEN "000001011", -- Weight 11  
		"00000000" WHEN "000001100", -- Weight 12  
		"00001000" WHEN "000001101", -- Weight 13  
		"00000000" WHEN "000001110", -- Weight 14  
		"11111000" WHEN "000001111", -- Weight 15  
		"00000000" WHEN "000010000", -- Weight 16  
		"00000000" WHEN "000010001", -- Weight 17  
		"11111000" WHEN "000010010", -- Weight 18  
		"00001000" WHEN "000010011", -- Weight 19  
		"11111000" WHEN "000010100", -- Weight 20  
		"00000000" WHEN "000010101", -- Weight 21  
		"00000000" WHEN "000010110", -- Weight 22  
		"11111000" WHEN "000010111", -- Weight 23  
		"11111000" WHEN "000011000", -- Weight 24  
		"00001000" WHEN "000011001", -- Weight 25  
		"11111000" WHEN "000011010", -- Weight 26  
		"00000000" WHEN "000011011", -- Weight 27  
		"00000000" WHEN "000011100", -- Weight 28  
		"00001000" WHEN "000011101", -- Weight 29  
		"00000000" WHEN "000011110", -- Weight 30  
		"00001000" WHEN "000011111", -- Weight 31  
		"00000000" WHEN "000100000", -- Weight 32  
		"11111000" WHEN "000100001", -- Weight 33  
		"00000000" WHEN "000100010", -- Weight 34  
		"00001000" WHEN "000100011", -- Weight 35  
		"00000000" WHEN "000100100", -- Weight 36  
		"00000000" WHEN "000100101", -- Weight 37  
		"00001000" WHEN "000100110", -- Weight 38  
		"00000000" WHEN "000100111", -- Weight 39  
		"00001000" WHEN "000101000", -- Weight 40  
		"00000000" WHEN "000101001", -- Weight 41  
		"00000000" WHEN "000101010", -- Weight 42  
		"00001000" WHEN "000101011", -- Weight 43  
		"00000000" WHEN "000101100", -- Weight 44  
		"00000000" WHEN "000101101", -- Weight 45  
		"00000000" WHEN "000101110", -- Weight 46  
		"11111000" WHEN "000101111", -- Weight 47  
		"11111000" WHEN "000110000", -- Weight 48  
		"00000000" WHEN "000110001", -- Weight 49  
		"00000000" WHEN "000110010", -- Weight 50  
		"00000000" WHEN "000110011", -- Weight 51  
		"00000000" WHEN "000110100", -- Weight 52  
		"11111000" WHEN "000110101", -- Weight 53  
		"00000000" WHEN "000110110", -- Weight 54  
		"00001000" WHEN "000110111", -- Weight 55  
		"00000000" WHEN "000111000", -- Weight 56  
		"00000000" WHEN "000111001", -- Weight 57  
		"00000000" WHEN "000111010", -- Weight 58  
		"00000000" WHEN "000111011", -- Weight 59  
		"00000000" WHEN "000111100", -- Weight 60  
		"00000000" WHEN "000111101", -- Weight 61  
		"00000000" WHEN "000111110", -- Weight 62  
		"00000000" WHEN "000111111", -- Weight 63  
		"11111000" WHEN "001000000", -- Weight 64  
		"11111000" WHEN "001000001", -- Weight 65  
		"00010000" WHEN "001000010", -- Weight 66  
		"00000000" WHEN "001000011", -- Weight 67  
		"11111000" WHEN "001000100", -- Weight 68  
		"00001000" WHEN "001000101", -- Weight 69  
		"00000000" WHEN "001000110", -- Weight 70  
		"00000000" WHEN "001000111", -- Weight 71  
		"00000000" WHEN "001001000", -- Weight 72  
		"00000000" WHEN "001001001", -- Weight 73  
		"00000000" WHEN "001001010", -- Weight 74  
		"00000000" WHEN "001001011", -- Weight 75  
		"00000000" WHEN "001001100", -- Weight 76  
		"11111000" WHEN "001001101", -- Weight 77  
		"00000000" WHEN "001001110", -- Weight 78  
		"00000000" WHEN "001001111", -- Weight 79  
		"11111000" WHEN "001010000", -- Weight 80  
		"00000000" WHEN "001010001", -- Weight 81  
		"00000000" WHEN "001010010", -- Weight 82  
		"00000000" WHEN "001010011", -- Weight 83  
		"00000000" WHEN "001010100", -- Weight 84  
		"00000000" WHEN "001010101", -- Weight 85  
		"00000000" WHEN "001010110", -- Weight 86  
		"00000000" WHEN "001010111", -- Weight 87  
		"00001000" WHEN "001011000", -- Weight 88  
		"00000000" WHEN "001011001", -- Weight 89  
		"00001000" WHEN "001011010", -- Weight 90  
		"00000000" WHEN "001011011", -- Weight 91  
		"00000000" WHEN "001011100", -- Weight 92  
		"00000000" WHEN "001011101", -- Weight 93  
		"00000000" WHEN "001011110", -- Weight 94  
		"00000000" WHEN "001011111", -- Weight 95  
		"00000000" WHEN "001100000", -- Weight 96  
		"00010000" WHEN "001100001", -- Weight 97  
		"00000000" WHEN "001100010", -- Weight 98  
		"00000000" WHEN "001100011", -- Weight 99  
		"00001000" WHEN "001100100", -- Weight 100  
		"00000000" WHEN "001100101", -- Weight 101  
		"00000000" WHEN "001100110", -- Weight 102  
		"00000000" WHEN "001100111", -- Weight 103  
		"11111000" WHEN "001101000", -- Weight 104  
		"00000000" WHEN "001101001", -- Weight 105  
		"11111000" WHEN "001101010", -- Weight 106  
		"00000000" WHEN "001101011", -- Weight 107  
		"00000000" WHEN "001101100", -- Weight 108  
		"11111000" WHEN "001101101", -- Weight 109  
		"00000000" WHEN "001101110", -- Weight 110  
		"00000000" WHEN "001101111", -- Weight 111  
		"00000000" WHEN "001110000", -- Weight 112  
		"00000000" WHEN "001110001", -- Weight 113  
		"00000000" WHEN "001110010", -- Weight 114  
		"00001000" WHEN "001110011", -- Weight 115  
		"11110000" WHEN "001110100", -- Weight 116  
		"00000000" WHEN "001110101", -- Weight 117  
		"00000000" WHEN "001110110", -- Weight 118  
		"11111000" WHEN "001110111", -- Weight 119  
		"00000000" WHEN OTHERS;
END Behavioral;