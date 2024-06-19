--------------------REGISTER LAST LAYER MODULE----------------------
--This module stores the output data from the neurons until the network is done processing.
--INPUTS
--data_in : output from the neurons
--next_pipeline_step : control signal to know when the data is to be sent
--OUTPUTS
--data_in : output data of the network
--finish : signal to notify that the network is done processing data

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Register_FCLast IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        next_pipeline_step : IN STD_LOGIC;
        data_in : IN vector_sm(0 TO number_of_outputs_L4fc - 1);
        start_threshold : OUT STD_LOGIC;
        data_out : OUT vector_sm_signed(0 TO number_of_outputs_L4fc - 1));
END Register_FCLast;

ARCHITECTURE Behavioral OF Register_FCLast IS
    SIGNAL finish_reg, finish_next : STD_LOGIC := '0';

BEGIN

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (rst = '0') THEN
                data_out <= (OTHERS => (OTHERS => '0'));
                finish_reg <= '0';
            ELSE
                finish_reg <= finish_next;
                IF (next_pipeline_step = '1') THEN
                    FOR i IN 0 TO number_of_outputs_L4fc - 1 LOOP
                        data_out(i) <= signed(data_in(i));
                    END LOOP;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    PROCESS (finish_next, next_pipeline_step)
    BEGIN
        IF (next_pipeline_step = '1') THEN
            finish_next <= '1';
        ELSE
            finish_next <= '0';
        END IF;
    END PROCESS;

    start_threshold <= finish_reg;
END Behavioral;