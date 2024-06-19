--------------------------CONV MODULE------------------------------------
-- This module performs the convolution function which consists of the addition of each multiplication of a signal by its corresponding weight,
-- depending on the position of the filter window. It is performed by adding a 1 each time the input pulse indicates that the signal is not 
-- zero. 
---INPUTS
-- data_in : each bit of the input data.
-- address : indicates which part of the filter we are calculating to select the corresponding weight, it will have size conv_col * conv_row * number_of_layers
-- next_pipeline_step : notifies when a filter convolution is finished and moves on to the next one.
-- bit select : indicates which bit of the input data we are receiving at each moment.
---OUTPUTS
-- data_out : the output is the accumulation of the input signals multiplied by the respective filters (convolution).
-- weight : weight corresponding to the part of the filter we are currently calculating. as this layer is parallelized we transmit the weight to the parallel neurons.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;
ENTITY CONV25 IS
	PORT (
		data_in : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		next_pipeline_step : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
		bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
END CONV25;
ARCHITECTURE Behavioral OF CONV25 IS
	SIGNAL weight : signed(weight_sizeL2 - 1 DOWNTO 0);
	SIGNAL mac_out_next, mac_out_reg : signed (input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0) := "000000000000000000"; -- signals to compute the convolution, we add extra bits for precision.
	SIGNAL mux_out3 : signed (input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_sizeL2 + input_sizeL2 - 2 DOWNTO 0); -- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (rst = '0') THEN
				mac_out_reg <= "000000000000000000";
				shifted_weight_reg <= (OTHERS => '0');
			ELSE
				mac_out_reg <= mac_out_next;
				shifted_weight_reg <= shifted_weight_next;
			END IF;
		END IF;
	END PROCESS;

	-- Weight extension
	extended_weight <= resize(weight, weight_sizeL2 + input_sizeL2 - 1); -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).

	-- Shift block --
	mux_out1 <= extended_weight WHEN (bit_select = "000") ELSE -- Each time a new signal is received (bit_select = 0) we reset the shifted weight.
		shifted_weight_reg;
	shifted_weight_next <= mux_out1(weight_sizeL2 + input_sizeL2 - n_extra_bits DOWNTO 0) & '0'; -- Logic Shift Left

	-- Addition block
	PROCESS (data_in, mux_out1) --If the input bit is 1 we add the shifted weight to the accumulated result. 
	BEGIN
		IF (data_in = '1') THEN
			mux_out2 <= mux_out1;
		ELSE
			mux_out2 <= (OTHERS => '0');
		END IF;
	END PROCESS;
	mux_out3 <= resize(mux_out2, input_sizeL2 + weight_sizeL2 + n_extra_bits);

	PROCESS (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3) --if next_pipeline_step = '1' it means that the convolution is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.
	BEGIN
		IF (next_pipeline_step = '1') THEN
			mac_out_next <= "000000000000000000"; --We add the bias_term as an offset at the beggining of each convolution.
		ELSE
			mac_out_next <= mac_out_reg + mux_out3;
		END IF;
	END PROCESS;
	data_out <= STD_LOGIC_VECTOR(mac_out_reg);
	WITH address SELECT weight <=
		"1111101" WHEN "00000000", -- 1 
		"1111111" WHEN "00000001", -- 2 
		"0000000" WHEN "00000010", -- 3 
		"0000000" WHEN "00000011", -- 4 
		"0000000" WHEN "00000100", -- 5 
		"0000000" WHEN "00000101", -- 6 
		"1111110" WHEN "00001000", -- 7 
		"0000000" WHEN "00001001", -- 8 
		"0000000" WHEN "00001010", -- 9 
		"0000000" WHEN "00001011", -- 10 
		"0000000" WHEN "00001100", -- 11 
		"1111101" WHEN "00001101", -- 12 
		"0000000" WHEN "00010000", -- 13 
		"1111111" WHEN "00010001", -- 14 
		"0000000" WHEN "00010010", -- 15 
		"0000001" WHEN "00010011", -- 16 
		"0000001" WHEN "00010100", -- 17 
		"1111110" WHEN "00010101", -- 18 
		"1111100" WHEN "00011000", -- 19 
		"1111111" WHEN "00011001", -- 20 
		"1111111" WHEN "00011010", -- 21 
		"1111111" WHEN "00011011", -- 22 
		"1111101" WHEN "00011100", -- 23 
		"1111111" WHEN "00011101", -- 24 
		"0000001" WHEN "00100000", -- 25 
		"0000010" WHEN "00100001", -- 26 
		"0000010" WHEN "00100010", -- 27 
		"0000001" WHEN "00100011", -- 28 
		"0000000" WHEN "00100100", -- 29 
		"1111010" WHEN "00100101", -- 30 
		"1111110" WHEN "00101000", -- 31 
		"0000001" WHEN "00101001", -- 32 
		"0000001" WHEN "00101010", -- 33 
		"0000010" WHEN "00101011", -- 34 
		"1111011" WHEN "00101100", -- 35 
		"0000100" WHEN "00101101", -- 36 
		"0000010" WHEN "00110000", -- 37 
		"0000010" WHEN "00110001", -- 38 
		"0000011" WHEN "00110010", -- 39 
		"0000011" WHEN "00110011", -- 40 
		"1111111" WHEN "00110100", -- 41 
		"1111111" WHEN "00110101", -- 42 
		"0000000" WHEN "00111000", -- 43 
		"0000000" WHEN "00111001", -- 44 
		"1111001" WHEN "00111010", -- 45 
		"1111011" WHEN "00111011", -- 46 
		"1111110" WHEN "00111100", -- 47 
		"0000010" WHEN "00111101", -- 48 
		"1111011" WHEN "01000000", -- 49 
		"1111101" WHEN "01000001", -- 50 
		"1111101" WHEN "01000010", -- 51 
		"1111111" WHEN "01000011", -- 52 
		"1111011" WHEN "01000100", -- 53 
		"0000011" WHEN "01000101", -- 54 
		"0000011" WHEN "01001000", -- 55 
		"0000100" WHEN "01001001", -- 56 
		"0001001" WHEN "01001010", -- 57 
		"0001000" WHEN "01001011", -- 58 
		"0000011" WHEN "01001100", -- 59 
		"1110111" WHEN "01001101", -- 60 
		"1111111" WHEN "01010000", -- 61 
		"0000010" WHEN "01010001", -- 62 
		"0000110" WHEN "01010010", -- 63 
		"0000011" WHEN "01010011", -- 64 
		"0000000" WHEN "01010100", -- 65 
		"0000000" WHEN "01010101", -- 66 
		"0000100" WHEN "01011000", -- 67 
		"0000100" WHEN "01011001", -- 68 
		"0000011" WHEN "01011010", -- 69 
		"0000010" WHEN "01011011", -- 70 
		"0000010" WHEN "01011100", -- 71 
		"1111010" WHEN "01011101", -- 72 
		"1111001" WHEN "01100000", -- 73 
		"1111010" WHEN "01100001", -- 74 
		"1110010" WHEN "01100010", -- 75 
		"1110011" WHEN "01100011", -- 76 
		"1110110" WHEN "01100100", -- 77 
		"0001010" WHEN "01100101", -- 78 
		"1110000" WHEN "01101000", -- 79 
		"1111001" WHEN "01101001", -- 80 
		"1111110" WHEN "01101010", -- 81 
		"0000000" WHEN "01101011", -- 82 
		"1110110" WHEN "01101100", -- 83 
		"0000110" WHEN "01101101", -- 84 
		"0000110" WHEN "01110000", -- 85 
		"0000101" WHEN "01110001", -- 86 
		"0001010" WHEN "01110010", -- 87 
		"0000111" WHEN "01110011", -- 88 
		"0001000" WHEN "01110100", -- 89 
		"1110011" WHEN "01110101", -- 90 
		"0000001" WHEN "01111000", -- 91 
		"0000100" WHEN "01111001", -- 92 
		"0000101" WHEN "01111010", -- 93 
		"0000101" WHEN "01111011", -- 94 
		"0000011" WHEN "01111100", -- 95 
		"0000000" WHEN "01111101", -- 96 
		"0000110" WHEN "10000000", -- 97 
		"0000001" WHEN "10000001", -- 98 
		"0000000" WHEN "10000010", -- 99 
		"1111101" WHEN "10000011", -- 100 
		"0000011" WHEN "10000100", -- 101 
		"1111110" WHEN "10000101", -- 102 
		"1111001" WHEN "10001000", -- 103 
		"1110111" WHEN "10001001", -- 104 
		"1101110" WHEN "10001010", -- 105 
		"1110001" WHEN "10001011", -- 106 
		"1110011" WHEN "10001100", -- 107 
		"0001011" WHEN "10001101", -- 108 
		"1110011" WHEN "10010000", -- 109 
		"1111011" WHEN "10010001", -- 110 
		"0000001" WHEN "10010010", -- 111 
		"1111111" WHEN "10010011", -- 112 
		"1111101" WHEN "10010100", -- 113 
		"0000010" WHEN "10010101", -- 114 
		"0000111" WHEN "10011000", -- 115 
		"0000100" WHEN "10011001", -- 116 
		"0001001" WHEN "10011010", -- 117 
		"0000111" WHEN "10011011", -- 118 
		"0001001" WHEN "10011100", -- 119 
		"1110110" WHEN "10011101", -- 120 
		"0000000" WHEN "10100000", -- 121 
		"0000100" WHEN "10100001", -- 122 
		"0000111" WHEN "10100010", -- 123 
		"0000011" WHEN "10100011", -- 124 
		"0000011" WHEN "10100100", -- 125 
		"1111101" WHEN "10100101", -- 126 
		"0000011" WHEN "10101000", -- 127 
		"1111110" WHEN "10101001", -- 128 
		"1111101" WHEN "10101010", -- 129 
		"1111010" WHEN "10101011", -- 130 
		"1111111" WHEN "10101100", -- 131 
		"0000000" WHEN "10101101", -- 132 
		"1110011" WHEN "10110000", -- 133 
		"1110110" WHEN "10110001", -- 134 
		"1110010" WHEN "10110010", -- 135 
		"1110100" WHEN "10110011", -- 136 
		"1110000" WHEN "10110100", -- 137 
		"0001100" WHEN "10110101", -- 138 
		"1111001" WHEN "10111000", -- 139 
		"1111101" WHEN "10111001", -- 140 
		"0000001" WHEN "10111010", -- 141 
		"0000010" WHEN "10111011", -- 142 
		"1111101" WHEN "10111100", -- 143 
		"0000000" WHEN "10111101", -- 144 
		"0000010" WHEN "11000000", -- 145 
		"0000010" WHEN "11000001", -- 146 
		"0000101" WHEN "11000010", -- 147 
		"0000011" WHEN "11000011", -- 148 
		"0000011" WHEN "11000100", -- 149 
		"1111011" WHEN "11000101", -- 150 
		"0000000" WHEN OTHERS;
END Behavioral;