----------------------------GENERATOR LAYER 1----------------------------
--This module is in charge of producing all the control signals of its layer, which allow to synchronize the operation of all the modules.
--INPUTS
--dato_in : indicates that there is a data to be processed in the layer
--data_zero1 : indicates that the data to be processed by the first set of neurons is a zero from the padding zone.
--data_zero2 : indicates that the data to be processed by the second set of neurons is a zero from the padding zone.

--OUTPUTS
--mul : indicates the multiplication of the filter we are performing at the moment
--count : counter from 0 to 2^(signal length) + 2 that we pass to the serial parallel converter to encode the signal.
--en_neuron : inidcates when the neuron is processing a valid input
--data_out1 : signal that notifies that the processing of a data in this layer is finished.
--data_out2 : signal notifying that a data is available for processing in the next layer
--next_pipeline_step: indicates that the processing of a data in the convolution has been completed

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY GEN1 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        rst_red : IN STD_LOGIC;
        data_in : IN STD_LOGIC;
        data_zero1 : IN STD_LOGIC;
        data_zero2 : IN STD_LOGIC;
        count : OUT unsigned(log2c(input_sizeL1) - 1 DOWNTO 0);
        mul : OUT STD_LOGIC_VECTOR(log2c(mult1) - 1 DOWNTO 0);
        en_neuron : OUT STD_LOGIC;
        data_out1 : OUT STD_LOGIC;
        data_out2 : OUT STD_LOGIC;
        next_pipeline_step : OUT STD_LOGIC);
END GEN1;
ARCHITECTURE Behavioral OF GEN1 IS
    TYPE state_type IS (idle, s_wait, s0, s1, s2);
    --REGISTERS
    SIGNAL state_reg, state_next : state_type;
    SIGNAL count_reg, count_next : unsigned(log2c(input_sizeL1) - 1 + log2c(mult1) + log2c(pool2_size) DOWNTO 0) := (OTHERS => '0');
    SIGNAL next_pipeline_step_reg, next_pipeline_step_next, data2_reg, data2_next, data_reg, data_next : STD_LOGIC;
    --CONSTANTS
    SIGNAL data_max : unsigned(log2c(input_sizeL1) - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    --Register
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                count_reg <= (OTHERS => '0');
                state_reg <= idle;
                data_reg <= '0';
                data2_reg <= '0';
                next_pipeline_step_reg <= '0';
            ELSE
                state_reg <= state_next;
                next_pipeline_step_reg <= next_pipeline_step_next;
                data_reg <= data_next;
                data2_reg <= data2_next;
                count_reg <= count_next;
            END IF;
        END IF;
    END PROCESS;
    --Next-state logic 
    PROCESS (rst_red, data_zero1, data_zero2, state_reg, data_reg, data_max, data_in, count_reg, next_pipeline_step_reg, data2_reg)
    BEGIN
        count_next <= count_reg;
        state_next <= state_reg;
        next_pipeline_step_next <= next_pipeline_step_reg;
        data_next <= data_reg;
        data2_next <= data2_reg;
        en_neuron <= '0';
        CASE state_reg IS
            WHEN idle => --Reset state
                data_next <= '0';
                data2_next <= '0';
                next_pipeline_step_next <= '0';
                count_next <= (OTHERS => '0');
                state_next <= s_wait;
            WHEN s_wait => --Wait for a new data to be processed
                next_pipeline_step_next <= '0';
                data_next <= '0';
                data2_next <= '0';
                IF (data_in = '1') THEN --When new data is availale to be processed if both of them are zero we don't have to do the MAAC operation as the result will be direclty zero if one of them is not zero we move to the processing state.
                    IF (data_zero1 = '1' AND data_zero2 = '1') THEN
                        state_next <= s2;
                    ELSE
                        state_next <= s0;
                    END IF;
                END IF;
                IF (rst_red = '1') THEN
                    state_next <= idle;
                END IF;
            WHEN s0 =>
                state_next <= s1;
            WHEN s1 =>
                next_pipeline_step_next <= '0';
                data_next <= '0';
                en_neuron <= '1';
                IF (count_reg(log2c(input_sizeL1) - 1 DOWNTO 0) = count1_max) THEN
                    IF ((count_reg(log2c(mult1) + log2c(input_sizeL1) - 1 DOWNTO log2c(input_sizeL1)) = mult1 - 1)) THEN
                        data_next <= '0';
                    ELSE
                        data_next <= '1';
                    END IF;
                    count_next <= count_reg + 1;
                ELSIF (count_reg(log2c(input_sizeL1) - 1 DOWNTO 0) = data_max) THEN
                    IF (count_reg(log2c(mult1) + log2c(input_sizeL1) - 1 DOWNTO log2c(input_sizeL1)) = mult1 - 1) THEN
                        IF (count_reg(log2c(input_sizeL1) - 1 + log2c(mult1) + log2c(pool2_size) DOWNTO log2c(mult1) + log2c(input_sizeL1)) = pool2_size - 1) THEN
                            data2_next <= '1';
                        ELSE
                            next_pipeline_step_next <= '1';
                        END IF;
                        count_next <= count_reg + 57;
                    ELSE
                        count_next <= count_reg + 1;
                    END IF;
                    state_next <= s_wait;
                ELSE
                    count_next <= count_reg + 1;
                END IF;

            WHEN s2 =>
                next_pipeline_step_next <= '0';
                data_next <= '0';
                data2_next <= '0';
                IF (count_reg(log2c(mult1) + log2c(input_sizeL1) - 1 DOWNTO log2c(input_sizeL1)) = mult1 - 1) THEN
                    IF (count_reg(log2c(input_sizeL1) - 1 + log2c(mult1) + log2c(pool2_size) DOWNTO log2c(mult1) + log2c(input_sizeL1)) = pool2_size - 1) THEN
                        data2_next <= '1';
                    ELSE
                        next_pipeline_step_next <= '1';
                    END IF;
                    count_next <= count_reg + 64;
                ELSE
                    data_next <= '1';
                    count_next <= count_reg + 8; --As the data input is zero we don't need to process it so we move directly to the next data
                END IF;
                state_next <= s_wait;
        END CASE;
    END PROCESS;
    --Constants
    data_max <= (OTHERS => '1');

    --Output logic
    data_out1 <= data_reg;
    data_out2 <= data2_reg;
    count <= count_reg(log2c(input_sizeL1) - 1 DOWNTO 0);
    mul <= STD_LOGIC_VECTOR(count_reg(log2c(mult1) + log2c(input_sizeL1) - 1 DOWNTO log2c(input_sizeL1)));
    next_pipeline_step <= next_pipeline_step_reg;
END Behavioral;