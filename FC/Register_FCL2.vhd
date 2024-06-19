--------------------------REGISTER------------------------------------
-- This module regster the results from the neurons of one layer of the FC and stores them until they are sent to the following layer
---INPUTS
-- data_in :Results of the MAAC operations of this layer.
-- next_pipeline_step : notifies when the input data has been processed and is sent to the following layer
---OUTPUTS
-- data_out : Data sent to the next layer.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Register_FCL2 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_in : IN vector_L2fc_activations(0 TO number_of_inputs_L3fc - 1);
        next_pipeline_step : IN STD_LOGIC;
        data_out : OUT vector_L2fc_activations(0 TO number_of_inputs_L3fc - 1));
END Register_FCL2;

ARCHITECTURE Behavioral OF Register_FCL2 IS

BEGIN

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (rst = '0') THEN
                data_out <= (OTHERS => (OTHERS => '0'));
            ELSIF (next_pipeline_step = '1') THEN
                data_out <= data_in;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;