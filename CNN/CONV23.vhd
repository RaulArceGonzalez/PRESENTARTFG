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
ENTITY CONV23 IS
	PORT (
		data_in : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		next_pipeline_step : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
		bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
END CONV23;
ARCHITECTURE Behavioral OF CONV23 IS
	SIGNAL weight : signed(weight_sizeL2 - 1 DOWNTO 0);
	SIGNAL mac_out_next, mac_out_reg : signed (input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0) := "111111111110000000"; -- signals to compute the convolution, we add extra bits for precision.
	SIGNAL mux_out3 : signed (input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_sizeL2 + input_sizeL2 - 2 DOWNTO 0); -- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (rst = '0') THEN
				mac_out_reg <= "111111111110000000";
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
			mac_out_next <= "111111111110000000"; --We add the bias_term as an offset at the beggining of each convolution.
		ELSE
			mac_out_next <= mac_out_reg + mux_out3;
		END IF;
	END PROCESS;
	data_out <= STD_LOGIC_VECTOR(mac_out_reg);
	WITH address SELECT weight <=
		"0000000" WHEN "00000000", -- 1 
		"1111111" WHEN "00000001", -- 2 
		"0000000" WHEN "00000010", -- 3 
		"0000000" WHEN "00000011", -- 4 
		"0000001" WHEN "00000100", -- 5 
		"1111100" WHEN "00000101", -- 6 
		"0000000" WHEN "00001000", -- 7 
		"1111111" WHEN "00001001", -- 8 
		"1111101" WHEN "00001010", -- 9 
		"1111111" WHEN "00001011", -- 10 
		"1111111" WHEN "00001100", -- 11 
		"0000000" WHEN "00001101", -- 12 
		"1111010" WHEN "00010000", -- 13 
		"1111101" WHEN "00010001", -- 14 
		"1111001" WHEN "00010010", -- 15 
		"1111011" WHEN "00010011", -- 16 
		"1111100" WHEN "00010100", -- 17 
		"0000010" WHEN "00010101", -- 18 
		"0000000" WHEN "00011000", -- 19 
		"1111110" WHEN "00011001", -- 20 
		"1111100" WHEN "00011010", -- 21 
		"1111011" WHEN "00011011", -- 22 
		"0000000" WHEN "00011100", -- 23 
		"0000000" WHEN "00011101", -- 24 
		"0000000" WHEN "00100000", -- 25 
		"1111111" WHEN "00100001", -- 26 
		"1111101" WHEN "00100010", -- 27 
		"1111010" WHEN "00100011", -- 28 
		"0000010" WHEN "00100100", -- 29 
		"1111100" WHEN "00100101", -- 30 
		"0000110" WHEN "00101000", -- 31 
		"0000000" WHEN "00101001", -- 32 
		"0000011" WHEN "00101010", -- 33 
		"0000001" WHEN "00101011", -- 34 
		"0000100" WHEN "00101100", -- 35 
		"1111001" WHEN "00101101", -- 36 
		"0000000" WHEN "00110000", -- 37 
		"1111100" WHEN "00110001", -- 38 
		"1111100" WHEN "00110010", -- 39 
		"1111100" WHEN "00110011", -- 40 
		"1111110" WHEN "00110100", -- 41 
		"1111101" WHEN "00110101", -- 42 
		"1111010" WHEN "00111000", -- 43 
		"1110111" WHEN "00111001", -- 44 
		"1110101" WHEN "00111010", -- 45 
		"1110101" WHEN "00111011", -- 46 
		"1111100" WHEN "00111100", -- 47 
		"0000001" WHEN "00111101", -- 48 
		"1110000" WHEN "01000000", -- 49 
		"1110101" WHEN "01000001", -- 50 
		"1110001" WHEN "01000010", -- 51 
		"1110111" WHEN "01000011", -- 52 
		"1110001" WHEN "01000100", -- 53 
		"0000100" WHEN "01000101", -- 54 
		"1110010" WHEN "01001000", -- 55 
		"1110100" WHEN "01001001", -- 56 
		"1110110" WHEN "01001010", -- 57 
		"1111000" WHEN "01001011", -- 58 
		"1110100" WHEN "01001100", -- 59 
		"0000101" WHEN "01001101", -- 60 
		"1111000" WHEN "01010000", -- 61 
		"1111000" WHEN "01010001", -- 62 
		"1110111" WHEN "01010010", -- 63 
		"1110101" WHEN "01010011", -- 64 
		"1111000" WHEN "01010100", -- 65 
		"0000011" WHEN "01010101", -- 66 
		"1111000" WHEN "01011000", -- 67 
		"1111000" WHEN "01011001", -- 68 
		"1111000" WHEN "01011010", -- 69 
		"1111001" WHEN "01011011", -- 70 
		"1111000" WHEN "01011100", -- 71 
		"0000010" WHEN "01011101", -- 72 
		"1111010" WHEN "01100000", -- 73 
		"1111100" WHEN "01100001", -- 74 
		"0000001" WHEN "01100010", -- 75 
		"0000000" WHEN "01100011", -- 76 
		"1111000" WHEN "01100100", -- 77 
		"0000010" WHEN "01100101", -- 78 
		"0000001" WHEN "01101000", -- 79 
		"0000011" WHEN "01101001", -- 80 
		"0000110" WHEN "01101010", -- 81 
		"0000011" WHEN "01101011", -- 82 
		"0000000" WHEN "01101100", -- 83 
		"1111111" WHEN "01101101", -- 84 
		"0000010" WHEN "01110000", -- 85 
		"0000011" WHEN "01110001", -- 86 
		"0000011" WHEN "01110010", -- 87 
		"0000011" WHEN "01110011", -- 88 
		"0000000" WHEN "01110100", -- 89 
		"1111010" WHEN "01110101", -- 90 
		"1111011" WHEN "01111000", -- 91 
		"1111011" WHEN "01111001", -- 92 
		"0000001" WHEN "01111010", -- 93 
		"0000000" WHEN "01111011", -- 94 
		"1111000" WHEN "01111100", -- 95 
		"0000010" WHEN "01111101", -- 96 
		"0000000" WHEN "10000000", -- 97 
		"0000011" WHEN "10000001", -- 98 
		"0000111" WHEN "10000010", -- 99 
		"0000101" WHEN "10000011", -- 100 
		"0000001" WHEN "10000100", -- 101 
		"1111111" WHEN "10000101", -- 102 
		"0001010" WHEN "10001000", -- 103 
		"0000110" WHEN "10001001", -- 104 
		"0001100" WHEN "10001010", -- 105 
		"0000111" WHEN "10001011", -- 106 
		"0001100" WHEN "10001100", -- 107 
		"1111000" WHEN "10001101", -- 108 
		"0001111" WHEN "10010000", -- 109 
		"0001000" WHEN "10010001", -- 110 
		"0001011" WHEN "10010010", -- 111 
		"0000110" WHEN "10010011", -- 112 
		"0001110" WHEN "10010100", -- 113 
		"1110101" WHEN "10010101", -- 114 
		"0000110" WHEN "10011000", -- 115 
		"0000011" WHEN "10011001", -- 116 
		"0000001" WHEN "10011010", -- 117 
		"0000011" WHEN "10011011", -- 118 
		"0000101" WHEN "10011100", -- 119 
		"1111011" WHEN "10011101", -- 120 
		"0001100" WHEN "10100000", -- 121 
		"0001001" WHEN "10100001", -- 122 
		"0001011" WHEN "10100010", -- 123 
		"0001001" WHEN "10100011", -- 124 
		"0001100" WHEN "10100100", -- 125 
		"1110111" WHEN "10100101", -- 126 
		"0001100" WHEN "10101000", -- 127 
		"0001001" WHEN "10101001", -- 128 
		"0001010" WHEN "10101010", -- 129 
		"0001001" WHEN "10101011", -- 130 
		"0001101" WHEN "10101100", -- 131 
		"1110101" WHEN "10101101", -- 132 
		"0001000" WHEN "10110000", -- 133 
		"0000101" WHEN "10110001", -- 134 
		"0000010" WHEN "10110010", -- 135 
		"0000010" WHEN "10110011", -- 136 
		"0000111" WHEN "10110100", -- 137 
		"1111100" WHEN "10110101", -- 138 
		"0000011" WHEN "10111000", -- 139 
		"0000000" WHEN "10111001", -- 140 
		"1111101" WHEN "10111010", -- 141 
		"1111101" WHEN "10111011", -- 142 
		"0000100" WHEN "10111100", -- 143 
		"1111111" WHEN "10111101", -- 144 
		"1111100" WHEN "11000000", -- 145 
		"1111100" WHEN "11000001", -- 146 
		"1111010" WHEN "11000010", -- 147 
		"1111001" WHEN "11000011", -- 148 
		"1111101" WHEN "11000100", -- 149 
		"0000000" WHEN "11000101", -- 150 
		"0000000" WHEN OTHERS;
END Behavioral;