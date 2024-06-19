------------------------------GENERATOR LAYER 3 ----------------------------
--This module is in charge of producing all the control signals of its layer, which allow to synchronize the operation of all the modules.
--INPUTS
--data_in_cnn : indicates that there is a data to be processed from the cnn last layer.
--data_in_fc : indicates that a data has been processed by the FC network.
--OUTPUTS
--data_new : indicates that the cnn can process a new data
--layer : indicates the layer of the matrix resulting from the previous stage that we are processing at this moment.
--index: signal that is passed to the relu module to transmit the stored data.
--next_dato_pool: indicates that there is new data from process to the pool module. 
--index: señal que se le pasa al modulo relu para que transmita los datos almacenados
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY GEN3 IS
   PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      rst_red : IN STD_LOGIC;
      data_in_fc : IN STD_LOGIC;
      data_in_cnn : IN STD_LOGIC;
      data_new : OUT STD_LOGIC;
      layer : OUT STD_LOGIC_VECTOR(log2c(number_of_layers3) - 1 DOWNTO 0);
      index : OUT STD_LOGIC;
      next_data_pool : OUT STD_LOGIC);
END GEN3;
ARCHITECTURE Behavioral OF GEN3 IS
   TYPE state_type IS (idle, s_wait, s0, s1);
   SIGNAL state_reg, state_next : state_type;
   --REGISTERS
   SIGNAL index_reg, index_next : unsigned (log2c(pool3_size) + 1 DOWNTO 0);
   SIGNAL count_reg, count_next : unsigned(log2c(result_size) + log2c(number_of_layers3) - 1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL next_data_pool_reg, next_data_pool_next, first_reg, first_next : STD_LOGIC := '0';
   -- Register 
BEGIN
   PROCESS (clk)
   BEGIN
      IF (clk'event AND clk = '1') THEN
         IF (rst = '0') THEN
            index_reg <= (OTHERS => '0');
            state_reg <= idle;
            next_data_pool_reg <= '0';
            count_reg <= (OTHERS => '0');
         ELSE
            index_reg <= index_next;
            state_reg <= state_next;
            next_data_pool_reg <= next_data_pool_next;
            count_reg <= count_next;
            first_reg <= first_next;
         END IF;
      END IF;
   END PROCESS;
   --Next-state logic 
   PROCESS (rst_red, state_reg, index_reg, data_in_fc, data_in_cnn, count_reg, next_data_pool_reg, first_reg)
   BEGIN
      first_next <= first_reg;
      count_next <= count_reg;
      index_next <= index_reg;
      state_next <= state_reg;
      next_data_pool_next <= next_data_pool_reg;
      data_new <= '0';
      index <= '0';
      CASE state_reg IS
         WHEN idle =>
            next_data_pool_next <= '0';
            index <= '0';
            count_next <= (OTHERS => '0');
            index_next <= (OTHERS => '0');
            state_next <= s_wait;
            first_next <= '1';
         WHEN s_wait =>
            next_data_pool_next <= '0';
            index <= '0';
            IF (data_in_fc = '1' OR data_in_cnn = '1') THEN
               index_next <= (OTHERS => '0');
               state_next <= s0;
               IF (data_in_cnn = '1' AND count_reg(log2c(result_size) + log2c(number_of_layers3) - 1 DOWNTO log2c(number_of_layers3)) /= result_size - 2) THEN
                  data_new <= '1';
               END IF;
            END IF;
            IF (rst_red = '1') THEN
               state_next <= idle;
            END IF;
         WHEN s0 =>
            IF (count_reg(log2c(number_of_layers3) - 1 DOWNTO 0) = number_of_layers3 - 1) THEN
               count_next <= count_reg + 1;
            ELSE
               IF (first_reg = '0') THEN
                  count_next <= count_reg + 1;
               ELSE
                  first_next <= '0';
               END IF;
            END IF;
            state_next <= s1;
         WHEN s1 =>

            --Control signals for Relu and MaxPool

            IF (index_reg /= pool3_size) THEN --index signal takes care of passing the data from the relu to the pool, counts up to the number of cycles equal to the size of the filter pool, and then sends a 1 in the nex_data_pool signal.
               index_next <= index_reg + 1;
               IF (index_reg < pool3_size) THEN
                  index <= '1';
               ELSE
                  index <= '0';
               END IF;
            END IF;
            IF (index_reg = pool3_size - 1 AND next_data_pool_reg = '0') THEN --signal notifying the MAXPOOL module that the data is being processed
               next_data_pool_next <= '1';
               state_next <= s_wait;
            END IF;

      END CASE;
   END PROCESS;

   --Output logic
   layer <= STD_LOGIC_VECTOR(count_reg(log2c(number_of_layers3) - 1 DOWNTO 0));
   next_data_pool <= next_data_pool_reg;
END Behavioral;