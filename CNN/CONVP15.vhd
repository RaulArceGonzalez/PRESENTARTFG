--------------------------MODULO CONV------------------------------------
--Este modulo realiza la función de convolución que cosiste en la suma de cada multiplicación de una señal por su peso correspondiente
--según en que posición de la ventana del filtro se encuentra, se realiza sumando un 1 cada vez que el pulso de entrada indique que la señal no 
--es nula. Además si el pulso de entrada indica que la señal es negativa se invertirá el peso.
---ENTRADAS
-- data_in : los datos de entrada uno por uno como un pulso en serie
-- mul : indica en que parte del filtro nos encontramos, tendrá tamaño conv_col * conv_row * number_of_layers
-- weight : peso correspondiente a la parte del filtro en la que nos encontremos
-- next_pipeline_step : notifica de cuando termina una pasada del filtro y se pasa a la siguiente
---SALIDAS
--data_out : como salida se produce la acumulación de las señales de entrada multiplicadas por sus respectivos filtros
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY CONVP15 IS
	PORT (
		data_in : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		next_pipeline_step : IN STD_LOGIC;
		weight : IN signed(weight_sizeL1 - 1 DOWNTO 0);
		bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
END CONVP15;
ARCHITECTURE Behavioral OF CONVP15 IS
	SIGNAL mac_out_next, mac_out_reg : signed (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0) := "111111100001000000"; --se añade precisión hasta llegar al doble de decimales que para el LSB 
	SIGNAL mux_out3 : signed (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0'); --se añade precisión hasta llegar al doble de decimales que para el LSB 
	SIGNAL mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_sizeL1 + input_sizeL1 - 2 DOWNTO 0); -- Solo se necesita desplazar (input_size-1) veces - ej: 7 desplazamientos si input_size = 8, por eso el "-2".
BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (rst = '0') THEN
				mac_out_reg <= "111111100001000000";
				shifted_weight_reg <= (OTHERS => '0');
			ELSE
				mac_out_reg <= mac_out_next;
				shifted_weight_reg <= shifted_weight_next;
			END IF;
		END IF;
	END PROCESS;
	-- Weight extension
	extended_weight <= resize(weight, weight_sizeL1 + input_sizeL1 - 1); -- La señal se deplaza (input_size-1) veces => (input_size-1) bits adicionales.
	-- Shift block --
	mux_out1 <= extended_weight WHEN (bit_select = "000") ELSE
		shifted_weight_reg;
	shifted_weight_next <= mux_out1(weight_sizeL1 + input_sizeL1 - n_extra_bits DOWNTO 0) & '0'; -- Logic Shift Left
	-- Addition block
	PROCESS (data_in, mux_out1)
	BEGIN
		IF (data_in = '1') THEN
			mux_out2 <= mux_out1;
		ELSE
			mux_out2 <= (OTHERS => '0');
		END IF;
	END PROCESS;
	mux_out3 <= resize(mux_out2, input_sizeL1 + weight_sizeL1 + n_extra_bits);
	PROCESS (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3) --si la señal next-pipeline_step esta activa reseteamos el registro, si no lo es acumulamos el valor de las sumas
	BEGIN
		IF (next_pipeline_step = '1') THEN
			mac_out_next <= "111111100001000000"; --Añadimos el bias_term como offset al principio de cada operación MAAC
		ELSE
			mac_out_next <= mac_out_reg + mux_out3;
		END IF;
	END PROCESS;
	data_out <= STD_LOGIC_VECTOR(mac_out_reg);
END Behavioral;