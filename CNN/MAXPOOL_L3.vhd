-----------------------------------------MAXPOOL ----------------------------------------------------------
--This module is going to perform the MaxPool operation, which consists of calculating the maximum of a set of data.
--This is achieved by comparing the input with the data already recorded, if it is greater the input is stored and if not it is discarded.
--INPUTS
--data_in: data processed by the convolution layer and relu, coming from the multiplexer. 
--next_data_pool : signal indicating when the processing of a filter pass is finished
--index : siganl indicating that there is data avaiable to be processed
--OUTPUTS
--data_out: output signal, one output for each filter pass that corresponds to the highest data of those recorded

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;
ENTITY MAXPOOL_L3 IS
   GENERIC (
      input_size : INTEGER := 8;
      weight_size : INTEGER := 8);
   PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      next_data_pool : IN STD_LOGIC;
      index : STD_LOGIC;
      data_in : IN STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
      data_out : OUT STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0));
END MAXPOOL_L3;

ARCHITECTURE Behavioral OF MAXPOOL_L3 IS
   SIGNAL data_reg, data_reg2, data_next : STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0) := (OTHERS => '0');
   -- Register 
BEGIN
   PROCESS (clk)
   BEGIN
      IF (clk'event AND clk = '1') THEN
         IF (rst = '0') THEN
            data_reg <= (OTHERS => '0');
            data_reg2 <= (OTHERS => '0');
         ELSE
            data_reg <= data_next;
            IF (next_data_pool = '1') THEN --when the generator's pool signal is activated we send the output data
               data_reg2 <= data_reg;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   -- Next-state logic 

   PROCESS (index, data_reg, data_in) -- Comparison between the stored data and the incoming one, we keep the biggest. We perfomr this operation only when the index signal is activated, signaling that there's new data available.
   BEGIN
      IF (index = '1') THEN
         IF (data_in > data_reg) THEN
            data_next <= data_in;
         ELSE
            data_next <= data_reg;
         END IF;
      ELSE
         data_next <= (OTHERS => '0');
      END IF;
   END PROCESS;

   --Output logic 

   data_out <= data_reg;
END Behavioral;