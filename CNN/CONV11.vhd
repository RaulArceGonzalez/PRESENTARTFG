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
ENTITY CONV11 IS
	PORT (
		data_in : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		next_pipeline_step : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult1)))) - 1 DOWNTO 0);
		weight_out : OUT signed(weight_sizeL1 - 1 DOWNTO 0);
		bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
END CONV11;
ARCHITECTURE Behavioral OF CONV11 IS
	SIGNAL weight : signed(weight_sizeL1 - 1 DOWNTO 0);
	SIGNAL mac_out_next, mac_out_reg : signed (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0) := "111111100000000000"; -- signals to compute the convolution, we add extra bits for precision.
	SIGNAL mux_out3 : signed (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_sizeL1 + input_sizeL1 - 2 DOWNTO 0); -- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (rst = '0') THEN
				mac_out_reg <= "111111100000000000";
				shifted_weight_reg <= (OTHERS => '0');
			ELSE
				mac_out_reg <= mac_out_next;
				shifted_weight_reg <= shifted_weight_next;
			END IF;
		END IF;
	END PROCESS;

	-- Weight extension
	extended_weight <= resize(weight, weight_sizeL1 + input_sizeL1 - 1); -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).

	-- Shift block --
	mux_out1 <= extended_weight WHEN (bit_select = "000") ELSE -- Each time a new signal is received (bit_select = 0) we reset the shifted weight.
		shifted_weight_reg;
	shifted_weight_next <= mux_out1(weight_sizeL1 + input_sizeL1 - n_extra_bits DOWNTO 0) & '0'; -- Logic Shift Left

	-- Addition block
	PROCESS (data_in, mux_out1) --If the input bit is 1 we add the shifted weight to the accumulated result. 
	BEGIN
		IF (data_in = '1') THEN
			mux_out2 <= mux_out1;
		ELSE
			mux_out2 <= (OTHERS => '0');
		END IF;
	END PROCESS;
	mux_out3 <= resize(mux_out2, input_sizeL1 + weight_sizeL1 + n_extra_bits);

	PROCESS (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3) --if next_pipeline_step = '1' it means that the convolution is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.
	BEGIN
		IF (next_pipeline_step = '1') THEN
			mac_out_next <= "111111100000000000"; --We add the bias_term as an offset at the beggining of each convolution.
		ELSE
			mac_out_next <= mac_out_reg + mux_out3;
		END IF;
	END PROCESS;
	data_out <= STD_LOGIC_VECTOR(mac_out_reg);
	WITH address SELECT weight <=
		"1111001" WHEN "00000", -- 0
		"0001000" WHEN "00001", -- 1
		"0001011" WHEN "00010", -- 2
		"0000110" WHEN "00011", -- 3
		"1111010" WHEN "00100", -- 4
		"0001001" WHEN "00101", -- 5
		"0011101" WHEN "00110", -- 6
		"0011110" WHEN "00111", -- 7
		"0011010" WHEN "01000", -- 8
		"0001110" WHEN "01001", -- 9
		"0001100" WHEN "01010", -- 10
		"0011011" WHEN "01011", -- 11
		"0011000" WHEN "01100", -- 12
		"0001110" WHEN "01101", -- 13
		"0001011" WHEN "01110", -- 14
		"0000000" WHEN "01111", -- 15
		"0001011" WHEN "10000", -- 16
		"0000011" WHEN "10001", -- 17
		"1111011" WHEN "10010", -- 18
		"1110001" WHEN "10011", -- 19
		"1110100" WHEN "10100", -- 20
		"1110101" WHEN "10101", -- 21
		"1101100" WHEN "10110", -- 22
		"1100111" WHEN "10111", -- 23
		"1011110" WHEN "11000", -- 24
		"0000000" WHEN OTHERS;
	weight_out <= weight;
END Behavioral;