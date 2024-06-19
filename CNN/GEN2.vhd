----------------------------GENERATOR LAYER 2----------------------------
--This module is in charge of producing all the control signals of its layer, which allow to synchronize the operation of all the modules.
--INPUTS
--data_in : indicates that there is a data to be processed in the layer.
--data_zero : indicates if the data to be processed corresponds to a zero from the padding layer of the input image
--OUTPUTS
--layer : indicates the layer of the matrix resulting from the previous stage that we are processing at this moment.
--mul : indicates the multiplication of the filter that we are performing at that moment.
--count : counter from 0 to 2^(signal length) + 2 that we pass to the serial parallel converter to encode the signal.
--data_out1 : signal notifying that the processing of a data in this layer is finished
--data_out2 : signal notifying that a data is available to process in the next layer
--index: signal that is passed to the relu module to transmit the stored data.
--en_neuron: signal that is kept at 1 when the neuron is receiving data, it is passed to a multiplexer at the output of the par2ser converter because it would send a pulse out of time. 
--next_dato_pool: indicates that there is new data to process from the pool module. 
--next_pipeline_step: indicates that it has finished processing a data in the convolution.

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY GEN2 IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    rst_red : IN STD_LOGIC;
    data_in : IN STD_LOGIC;
    data_zero : IN STD_LOGIC;
    count : OUT unsigned(log2c(input_sizeL2) - 1 DOWNTO 0);
    layer : OUT STD_LOGIC_VECTOR(log2c(number_of_layers2) - 1 DOWNTO 0);
    mul : OUT STD_LOGIC_VECTOR(log2c(mult2) - 1 DOWNTO 0);
    data_out1 : OUT STD_LOGIC;
    data_out2 : OUT STD_LOGIC;
    index : OUT STD_LOGIC;
    en_neuron : OUT STD_LOGIC;
    next_data_pool : OUT STD_LOGIC;
    next_pipeline_step : OUT STD_LOGIC);
END GEN2;
ARCHITECTURE Behavioral OF GEN2 IS
  TYPE state_type IS (idle, s_wait, s0, s1);
  SIGNAL state_reg, state_next : state_type;
  --REGISTERS

  SIGNAL index_reg, index_next : unsigned (log2c(pool2_size) + 1 DOWNTO 0);
  SIGNAL count_reg, count_next : unsigned(log2c(input_sizeL2) - 1 + log2c(mult2) + log2c(pool3_size) + log2c(number_of_layers2) DOWNTO 0) := (OTHERS => '0');
  SIGNAL next_data_pool_reg, next_data_pool_next, next_pipeline_step_reg, next_pipeline_step_next, data_reg, data_next, data2_reg, data2_next : STD_LOGIC;

  --CONSTANTS
  SIGNAL data_max : unsigned(log2c(input_sizeL2) - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN

  --Register
  PROCESS (clk)
  BEGIN
    IF (clk'event AND clk = '1') THEN
      IF (rst = '0') THEN
        count_reg <= (OTHERS => '0');
        index_reg <= (OTHERS => '0');
        state_reg <= idle;
        next_data_pool_reg <= '0';
        data2_reg <= '0';
        data_reg <= '0';
      ELSE
        index_reg <= index_next;
        state_reg <= state_next;
        next_data_pool_reg <= next_data_pool_next;
        next_pipeline_step_reg <= next_pipeline_step_next;
        data_reg <= data_next;
        data2_reg <= data2_next;
        IF (index_reg > pool2_size - 1) THEN
          count_reg <= count_next;
        END IF;
      END IF;
    END IF;
  END PROCESS;
  --Next-state logic
  PROCESS (rst_red, data_zero, data_max, state_reg, index_reg, data_in, count_reg, next_data_pool_reg, next_pipeline_step_reg, data2_reg, data_reg)
  BEGIN
    count_next <= count_reg;
    index_next <= index_reg;
    state_next <= state_reg;
    next_data_pool_next <= next_data_pool_reg;
    next_pipeline_step_next <= next_pipeline_step_reg;
    data_next <= data_reg;
    data2_next <= data2_reg;
    en_neuron <= '0';
    index <= '0';
    CASE state_reg IS
      WHEN idle => --Reset state
        next_data_pool_next <= '0';
        next_pipeline_step_next <= '0';
        en_neuron <= '0';
        index <= '0';
        data_next <= '0';
        count_next <= (OTHERS => '0');
        index_next <= (OTHERS => '0');
        state_next <= s_wait;
        data2_next <= '0';
      WHEN s_wait =>
        next_data_pool_next <= '0';
        data2_next <= '0';
        index <= '0';
        data_next <= '0';
        next_pipeline_step_next <= '0';
        IF (data_in = '1') THEN --When new data is availale to be processed if it's zero we don't have to do the MAAC operation as the result will be direclty zero if is not zero we move to the processing state.
          state_next <= s0;
        END IF;
        IF (data_zero = '1') THEN
          state_next <= s1;
        END IF;
        IF (rst_red = '1') THEN
          state_next <= idle;
        END IF;

      WHEN s0 => --Generates control signals for processing a non-zero data
        --ReLU and Pool control signals

        IF (index_reg /= pool2_size + 1) THEN --index signal takes care of passing the data from the relu to the pool, counts up to the number of cycles equal to the size of the filter pool, and then sends a 1 in the nex_data_pool signal.
          index_next <= index_reg + 1;
          IF (index_reg < pool2_size) THEN
            index <= '1';
          ELSE
            en_neuron <= '1';
          END IF;
        ELSE
          en_neuron <= '1';
        END IF;
        IF (index_reg = pool2_size - 1 AND next_data_pool_reg = '0') THEN --notifies the maxPool module that the data has been processed
          next_data_pool_next <= '1';
        END IF;
        --Conv control signals

        IF (count_reg(log2c(input_sizeL2) - 1 DOWNTO 0) = data_max) THEN --One data is processed
          IF (count_reg(log2c(number_of_layers2) + log2c(input_sizeL2) - 1 DOWNTO log2c(input_sizeL2)) = number_of_layers2 - 1) THEN --All the data available from the neurons in the last layers has been processed              
            IF (count_reg(log2c(mult2) + log2c(number_of_layers2) + log2c(input_sizeL2) - 1 DOWNTO log2c(number_of_layers2) + log2c(input_sizeL2)) = mult2 - 1) THEN --One filter pass is processed    
              IF (count_reg(log2c(input_sizeL2) - 1 + log2c(mult2) + log2c(number_of_layers2) + log2c(pool3_size) DOWNTO log2c(number_of_layers2) + log2c(mult2) + log2c(input_sizeL2)) = pool3_size - 1) THEN --One new data is available to be processed by the third layer
                data2_next <= '1'; --We notify the next layer that there is a new data available
                count_next <= (OTHERS => '0'); --add 1 if it is a power of 2, otherwise calculate the number needed to saturate the next bit.
              ELSE
                count_next <= count_reg + 465; --add 1 if it is a power of 2, otherwise calculate the number needed to saturate the next bit.
                next_pipeline_step_next <= '1'; --We notify the neurons that the data is processed and start a new filter pass
              END IF;
            ELSE
              count_next <= count_reg + 17; --add 1 if it is a power of 2, otherwise calculate the number needed to saturate the next bit.
            END IF;
            data_next <= '1';
            state_next <= s_wait;
          ELSE
            count_next <= count_reg + 1;
          END IF;
          index_next <= (OTHERS => '0');
        ELSE
          count_next <= count_reg + 1;
        END IF;
      WHEN s1 =>
        -- ReLU and Pool control signals
        IF (index_reg /= pool2_size + 1) THEN
          index_next <= index_reg + 1;
          IF (index_reg < pool2_size) THEN
            index <= '1';
          END IF;
        ELSE
          en_neuron <= '1';
        END IF;
        IF (index_reg = pool2_size - 1 AND next_data_pool_reg = '0') THEN
          next_data_pool_next <= '1';
        END IF;

        -- Conv control signals
        IF (count_reg(log2c(number_of_layers2) + log2c(input_sizeL2) - 1 DOWNTO log2c(input_sizeL2)) = number_of_layers2 - 1) THEN
          IF (count_reg(log2c(mult2) + log2c(number_of_layers2) + log2c(input_sizeL2) - 1 DOWNTO log2c(number_of_layers2) + log2c(input_sizeL2)) = mult2 - 1) THEN
            IF (count_reg(log2c(input_sizeL2) - 1 + log2c(mult2) + log2c(number_of_layers2) + log2c(pool3_size) DOWNTO log2c(number_of_layers2) + log2c(mult2) + log2c(input_sizeL2)) = pool3_size - 1) THEN
              data2_next <= '1';
              count_next <= (OTHERS => '0');
            ELSE
              count_next <= count_reg + 472;
              next_pipeline_step_next <= '1';
            END IF;
          ELSE
            data_next <= '1';
            count_next <= count_reg + 24;
          END IF;
          index_next <= (OTHERS => '0');
          state_next <= s_wait;
        ELSE
          count_next <= count_reg + 8;
        END IF;
    END CASE;
  END PROCESS;
  --constants

  data_max <= (OTHERS => '1'); --Max count value

  --output logic

  count <= count_reg(log2c(input_sizeL2) - 1 DOWNTO 0);
  mul <= STD_LOGIC_VECTOR(count_reg(log2c(mult2) + log2c(number_of_layers2) + log2c(input_sizeL2) - 1 DOWNTO log2c(number_of_layers2) + log2c(input_sizeL2)));
  layer <= STD_LOGIC_VECTOR(count_reg(log2c(number_of_layers2) + log2c(input_sizeL2) - 1 DOWNTO log2c(input_sizeL2)));
  next_pipeline_step <= next_pipeline_step_reg;
  next_data_pool <= next_data_pool_reg;
  data_out1 <= data_reg WHEN data2_reg = '0' ELSE
    '0';
  data_out2 <= data2_reg;
END Behavioral;