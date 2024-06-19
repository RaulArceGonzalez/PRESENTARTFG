--------------------PAR2SER MODULE----------------------
--This module transforms the parallel input signal into a serial output.
--INPUTS
--data_in : input to convert
--bit_select : auxiliary signal to choose the bit corresponding to each moment
--en_neuron : auxiliary signal to know when the input data is valid
--OUTPUTS
--bit_out : converted signal
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY PAR2SER IS
  GENERIC (input_size : INTEGER := 8); --number of bits of the input signals
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in : IN STD_LOGIC_VECTOR (input_size - 1 DOWNTO 0);
    en_neuron : IN STD_LOGIC;
    bit_select : IN unsigned(log2c(input_size) - 1 DOWNTO 0);
    bit_out : OUT STD_LOGIC);
END PAR2SER;
ARCHITECTURE Behavioral OF PAR2SER IS
  SIGNAL data_in_reg, data_in_next : STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
BEGIN

  --Register
  PROCESS (clk)
  BEGIN
    IF (clk'event AND clk = '1') THEN
      IF (rst = '0') THEN
        data_in_reg <= (OTHERS => '0');
      ELSE
        data_in_reg <= data_in_next;
      END IF;
    END IF;
  END PROCESS;

  --Next state logic
  PROCESS (bit_select, data_in, data_in_reg, en_neuron, data_in_next)
  BEGIN
    IF (bit_select = 0 AND en_neuron = '1') THEN
      data_in_next <= data_in;
    ELSE
      data_in_next <= data_in_reg;
    END IF;
  END PROCESS;

  --Output logic
  bit_out <= data_in_next(to_integer(bit_select));
END Behavioral;