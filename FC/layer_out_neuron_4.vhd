--------------------------LAST LAYER NEURON MODULE------------------------------------
-- This module is part of the implementation of the softmax function, it performs the multiplication of each element by the inverse of the summatory, thus making the division
-- It is performed by adding a 1 each time the input pulse indicates that the signal is not zero. 
---INPUTS
-- data_in : each bit of the input data, which corresponds to the inverse of the summatory .
-- weight : the result of the exponential for each output
-- next_pipeline_step : notifies when the input data has been processed and moves on to the next.
-- bit select : indicates which bit of the input data we are receiving at each moment.
---OUTPUTS
-- neuron_mac : the output is the result of the division, which represents the probability of each different output.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY layer_out_neuron_4 IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		data_in_bit : IN STD_LOGIC;
		bit_select : IN unsigned (log2c(input_size_L4fc) - 1 DOWNTO 0);
		weight : IN signed(input_size_L4fc - 1 DOWNTO 0);
		next_pipeline_step : IN STD_LOGIC;
		neuron_mac : OUT STD_LOGIC_VECTOR (input_size_L4fc - 1 DOWNTO 0));
END layer_out_neuron_4;

ARCHITECTURE Behavioral OF layer_out_neuron_4 IS

	SIGNAL mac_out_next, mac_out_reg, mux_out3 : signed (input_size_L4fc + weight_size_L4fc + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0'); --We add extra bits for precision.
	SIGNAL mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_size_L4fc + input_size_L4fc - 2 DOWNTO 0);
	-- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".

BEGIN

	-- Register --
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (rst = '0') THEN
				mac_out_reg <= (OTHERS => '0');
				shifted_weight_reg <= (OTHERS => '0');
			ELSE
				mac_out_reg <= mac_out_next;
				shifted_weight_reg <= shifted_weight_next;
			END IF;
		END IF;
	END PROCESS;

	-- Weight extension
	extended_weight <= resize(weight, weight_size_L4fc + input_size_L4fc - 1); -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).

	-- Shift block --
	mux_out1 <= extended_weight WHEN (bit_select = "000") ELSE
		shifted_weight_reg;

	shifted_weight_next <= mux_out1(weight_size_L4fc + input_size_L4fc - n_extra_bits DOWNTO 0) & '0'; -- Logic Shift Left

	-- Addition block
	PROCESS (data_in_bit, mux_out1) --If the input bit is 1 we add the shifted weight to the accumulated result.  
	BEGIN
		IF (data_in_bit = '1') THEN
			mux_out2 <= mux_out1;
		ELSE
			mux_out2 <= (OTHERS => '0');
		END IF;
	END PROCESS;
	mux_out3 <= resize(mux_out2, input_size_L4fc + weight_size_L4fc + n_extra_bits);

	PROCESS (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3) --if next_pipeline_step = '1' it means that the MAAC operation is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.
	BEGIN
		IF (next_pipeline_step = '1') THEN
			mac_out_next <= (OTHERS => '0'); --We add the bias_term as an offset at the beggining of each operation.
		ELSE
			mac_out_next <= mac_out_reg + mux_out3;
		END IF;
	END PROCESS;
	neuron_mac <= STD_LOGIC_VECTOR(mac_out_next(fractional_size_L4fc + weight_size_L4fc - 1 DOWNTO fractional_size_L4fc));
END Behavioral;