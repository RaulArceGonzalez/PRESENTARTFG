------------------------- RELU MODULE LAYER 1------------------------------------
--This module is in charge of performing the ReLU operation, it stores the necessary data for the Pool layer of the next filter.
--Data is stored if  is positive, if it is negative a zero is stored instead.
--INPUTS
--next_pipeline_step : signal indicating when we have finished a filter pass and new data is available for filter pooling
--data_in : as input receives the output of the convolutional operation
--index : this signal is used to transmit all the stored data from the relu to the next layer, when it needs to be processed.
--OUTPUTS
--data_out : sends the stored signals with ReLU applied, once the next layer notifies that it can process them.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY RELUL1 IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		next_pipeline_step : IN STD_LOGIC;
		index : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
END RELUL1;
ARCHITECTURE Behavioral OF RELUL1 IS
	SIGNAL c_aux : STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL data_reg, data_next : vector_reluL1(0 TO pool2_size - 1);
	SIGNAL index2_reg, index2_next : unsigned(pool2_row - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
	--Register
	PROCESS (clk)
	BEGIN
		IF (clk'event AND clk = '1') THEN
			IF (rst = '0') THEN
				FOR i IN 0 TO pool2_size - 1 LOOP
					data_reg(i) <= (OTHERS => '0');
				END LOOP;
				index2_reg <= (OTHERS => '0');
			ELSE
				index2_reg <= index2_next;
				IF (next_pipeline_step = '1') THEN
					FOR i IN 0 TO pool2_size - 1 LOOP
						data_reg(i) <= data_next(i);
					END LOOP;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	--Next state logic

	PROCESS (index, index2_reg, index2_next) --if index = 1 (the output data of the layer has been calculated) we increment index2 to send the array of  data stored in ReLu (if index has not reached its limit).
	BEGIN
		IF (index = '1') THEN
			IF (index2_reg = pool2_row - 1) THEN
				index2_next <= (OTHERS => '0');
			ELSE
				index2_next <= index2_reg + 1;
			END IF;
		ELSE
			index2_next <= index2_reg;
		END IF;
	END PROCESS;

	PROCESS (data_in, c_aux)
	BEGIN
		c_aux <= data_in;
	END PROCESS;

	PROCESS (data_reg, c_aux, data_next) --we store incoming data in consecutive order
	BEGIN
		FOR i IN pool2_size - 1 DOWNTO 0 LOOP
			IF (i = pool2_size - 1) THEN
				data_next(i) <= c_aux;
			ELSE
				data_next(i) <= data_reg(i + 1);
			END IF;
		END LOOP;
	END PROCESS;

	--Output logic

	data_out <= data_reg(to_integer(index2_reg));

END Behavioral;