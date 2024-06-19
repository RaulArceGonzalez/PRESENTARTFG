-----------------------------------ENABLE GENERATOR-------------------------------------
--This module provides the control signal to manage the functioning of the complete fully connected network
--INPUTS
--start_enable : start the processing of data when there is an available data in the CNN network output
--OUTPUTS
--data_fc: signal indicating that a data has been processed by the FC network so that the CNN can send a new one
--bit_select: control signal to select the bit of the input byte to be processed at each moment by the neurons
--en_neuron : signal indicating when the neurons can process an input
--addr_FC :signal to select the weight to be operated at each moment in the fully connected layers of the network
--next_pipeline_step : signal to indicate that a set of input data has been processed by the neurons

--addr_Sm : signal to select the weight to be operated at each moment of the softmax layer of the network
--enable_lastlayer : control isgnal to enable the register of the output layer when the data is calculated
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.tfg_irene_package.ALL;

ENTITY enable_generator IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    rst_red : IN STD_LOGIC;
    start_enable : IN STD_LOGIC;
    data_fc : OUT STD_LOGIC;
    en_neuron : OUT STD_LOGIC;
    addr_FC : OUT STD_LOGIC_VECTOR (log2c(biggest_ROM_size) - 1 DOWNTO 0);
    bit_select : OUT unsigned (log2c(input_size_L1fc) - 1 DOWNTO 0);
    next_pipeline_step : OUT STD_LOGIC;
    addr_Sm : OUT STD_LOGIC_VECTOR(log2c(number_of_outputs_L4fc) - 1 DOWNTO 0);
    exp_Sm : OUT STD_LOGIC;
    inv_Sm : OUT STD_LOGIC;
    sum_finish : OUT STD_LOGIC;
    enable_lastlayer : OUT STD_LOGIC);
END enable_generator;
ARCHITECTURE Behavioral OF enable_generator IS
  TYPE state_type IS (idle, s_wait, s0, s_fc, s_sm_1, s_sm_2);
  SIGNAL state_reg, state_next : state_type;
  ---Layer 1
  SIGNAL max_cnt : unsigned(log2c(input_size_L1fc) - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_layer_reg, cnt_layer_next : unsigned(log2c(number_of_layers3) - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cnt_reg, cnt_next : unsigned (log2c(input_size_L1fc) + log2c(biggest_ROM_size) - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL next_pipeline_step_reg, next_pipeline_step_next : STD_LOGIC;
  SIGNAL cnt_layerFC_reg, cnt_layerFC_next : unsigned (log2c(number_of_neurons_L2fc) - 1 DOWNTO 0) := (OTHERS => '0');
  --Softmax
  SIGNAL count_next, count_reg : unsigned (log2c(number_of_outputs_L4fc) - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL c_reg, c_next : unsigned(1 DOWNTO 0);
  SIGNAL enable_lastlayer_reg, enable_lastlayer_next, first_step_reg, first_step_next, sum_finish_reg, sum_finish_next : STD_LOGIC := '0';

BEGIN

  --State and data registers
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF (rst = '0') THEN
        cnt_reg <= (OTHERS => '0');
        count_reg <= (OTHERS => '0');
        next_pipeline_step_reg <= '0';
        cnt_layer_reg <= (OTHERS => '0');
        cnt_layerFC_reg <= (OTHERS => '0');
        sum_finish_reg <= '0';
        c_reg <= (OTHERS => '0');
      ELSE
        cnt_reg <= cnt_next;
        cnt_layer_reg <= cnt_layer_next;
        cnt_layerFC_reg <= cnt_layerFC_next;
        count_reg <= count_next;
        state_reg <= state_next;
        next_pipeline_step_reg <= next_pipeline_step_next;
        enable_lastlayer_reg <= enable_lastlayer_next;
        first_step_reg <= first_step_next;
        sum_finish_reg <= sum_finish_next;
        c_reg <= c_next;
      END IF;
    END IF;
  END PROCESS;
  --Next state logic
  PROCESS (rst_red, first_step_reg, sum_finish_reg, enable_lastlayer_reg, max_cnt, state_reg, cnt_reg, start_enable, count_reg, next_pipeline_step_reg, c_reg, cnt_layerFC_reg, cnt_layer_reg)
  BEGIN
    cnt_next <= cnt_reg;
    count_next <= count_reg;
    state_next <= state_reg;
    next_pipeline_step_next <= next_pipeline_step_reg;
    enable_lastlayer_next <= enable_lastlayer_reg;
    cnt_layer_next <= cnt_layer_reg;
    cnt_layerFC_next <= cnt_layerFC_reg;
    first_step_next <= first_step_reg;
    en_neuron <= '0';
    sum_finish_next <= sum_finish_reg;
    data_fc <= '0';
    c_next <= c_reg;
    exp_Sm <= '0';
    inv_Sm <= '0';

    CASE state_reg IS
      WHEN idle =>
        data_fc <= '0';
        sum_finish_next <= '0';
        cnt_next <= (OTHERS => '0');
        cnt_layer_next <= (OTHERS => '0');
        cnt_layerFC_next <= "0000010";
        count_next <= (OTHERS => '0');
        next_pipeline_step_next <= '0';
        state_next <= s_wait;
        enable_lastlayer_next <= '0';
        first_step_next <= '1';
        c_next <= (OTHERS => '0');
      WHEN s_wait =>
        sum_finish_next <= '0';
        data_fc <= '0';
        next_pipeline_step_next <= '0';
        enable_lastlayer_next <= '0';
        count_next <= (OTHERS => '0');
        IF (start_enable = '1') THEN --When there is new data available to be processed by the network we generate the corresponding control signals
          state_next <= s0; --The first stage corresponds to the first layer of the FC which is responsible for processing the data coming from the CNN
        END IF;
        IF (rst_red = '1') THEN
          state_next <= idle;
        END IF;
      WHEN s0 =>
        IF (cnt_reg(log2c(input_size_L1fc) - 1 DOWNTO 0) = max_cnt) THEN --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one
          IF (cnt_reg(log2c(input_size_L1fc) + log2c(biggest_ROM_size) - 1 DOWNTO log2c(input_size_L1fc)) = biggest_ROM_size - 1) THEN --When the counter reaches the biggest value of the ROM all the inputs of the FC network have been processed
            next_pipeline_step_next <= '1'; --We notify the neurons of the inner layer that all the data  has been processed
            state_next <= s_fc; --We now generate the control signal for the output layer
            cnt_next <= (OTHERS => '0');
          ELSE
            cnt_next <= cnt_reg + 1;
            IF (cnt_layer_reg = number_of_layers3 - 1) THEN --If there are still data available from the cnn (Every data calculated by each of the neurons) then we activate the signal data_fc else we wait for new data to be available
              cnt_layer_next <= (OTHERS => '0');
            ELSE
              data_fc <= '1';
              cnt_layer_next <= cnt_layer_reg + 1;
            END IF;
            state_next <= s_wait;
            en_neuron <= '1';
          END IF;
        ELSE
          cnt_next <= cnt_reg + 1;
          en_neuron <= '1';
        END IF;
      WHEN s_fc =>
        next_pipeline_step_next <= '0'; --We notify the neurons of the inner layer that all the data  has been processed
        IF (cnt_reg(log2c(input_size_L1fc) - 1 DOWNTO 0) = max_cnt) THEN --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one
          IF (cnt_reg(log2c(input_size_L1fc) + log2c(number_of_neurons_L1fc) - 1 DOWNTO log2c(input_size_L1fc)) = number_of_neurons_L1fc - 1) THEN --When the counter reaches the number of neurons in hte second layer we can move to the next one
            next_pipeline_step_next <= '1'; --We notify the neurons of the inner layer that all the data  has been processed
            IF (cnt_layerFC_reg > layers_fc - 2) THEN --We repeat this step as long as there are layers in the FC network that have not been processed
              state_next <= s_sm_1;
              cnt_layerFC_next <= (OTHERS => '0');
              next_pipeline_step_next <= '1'; --We notify the neurons of the inner layer that all the data  has been processed
            ELSE
              cnt_layerFC_next <= cnt_layerFC_reg + 1;
            END IF;
            cnt_next <= (OTHERS => '0');
          ELSE
            cnt_next <= cnt_reg + 1;
            en_neuron <= '1';
          END IF;
        ELSE
          cnt_next <= cnt_reg + 1;
          en_neuron <= '1';
        END IF;
      WHEN s_sm_1 =>
        data_fc <= '0';
        next_pipeline_step_next <= '0';
        IF (first_step_reg = '1') THEN
          cnt_next <= (OTHERS => '0');
          first_step_next <= '0';
        ELSE
          IF (c_reg = 0) THEN
            cnt_next <= (OTHERS => '0');
            c_next <= c_reg + 1;
            exp_Sm <= '1';
          ELSE
            IF (cnt_reg(log2c(input_size_L4fc) - 1 DOWNTO 0) = max_cnt) THEN --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one
              IF (count_reg = number_of_outputs_L4fc - 1) THEN --As this is the last layer the number of data to be processed is equal to the number of outputs, once this is processed we activate the enable of the last register and wait 
                sum_finish_next <= '1';
                count_next <= (OTHERS => '0');
                first_step_next <= '1';
                inv_Sm <= '1';
                state_next <= s_sm_2;
              ELSE
                count_next <= count_reg + 1;
                c_next <= (OTHERS => '0');
              END IF;
              cnt_next <= (OTHERS => '0');
              en_neuron <= '0';
            ELSE
              en_neuron <= '1';
              cnt_next <= cnt_reg + 1;
            END IF;
          END IF;
        END IF;
      WHEN s_sm_2 =>
        sum_finish_next <= '0';
        next_pipeline_step_next <= '0';

        IF (first_step_reg = '1') THEN
          cnt_next <= (OTHERS => '0');
          first_step_next <= '0';
        ELSE
          IF (cnt_reg(log2c(input_size_L4fc) - 1 DOWNTO 0) = max_cnt) THEN --When the counter reaches the max_cnt value the processing of the data is completed and we move to the next one
            state_next <= s_wait;
            enable_lastlayer_next <= '1';
            cnt_next <= (OTHERS => '0');
            en_neuron <= '0';
          ELSE
            cnt_next <= cnt_reg + 1;
            en_neuron <= '1';
          END IF;
        END IF;
    END CASE;
  END PROCESS;

  --Output logic
  max_cnt <= (OTHERS => '1'); --Maximum value of the count
  bit_select <= cnt_reg(log2c(input_size_L1fc) - 1 DOWNTO 0); --assignment of the bits corresponding to the count
  addr_FC <= STD_LOGIC_VECTOR(cnt_reg(log2c(input_size_L1fc) + log2c(biggest_ROM_size) - 1 DOWNTO log2c(input_size_L1fc)));
  addr_Sm <= STD_LOGIC_VECTOR(count_reg);
  next_pipeline_step <= next_pipeline_step_reg;
  enable_lastlayer <= enable_lastlayer_reg;
  sum_finish <= sum_finish_reg;
END Behavioral;