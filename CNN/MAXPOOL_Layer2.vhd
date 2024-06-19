-----------------------------------------MODULO MAXPOOL LAYER 1 ----------------------------------------------------------
--This module is going to perform the MaxPool operation, which consists of calculating the maximum of a set of data.
--This is achieved by comparing the input with the data already recorded, if it is greater the input is stored and if not it is discarded.
--INPUTS
--data_in, data_in2 : data processed by the convolution layer and relu, coming from the multiplexer. In this layer we received two because the convolution operation is parallelized.
--index : signal indicating that there is data available to be processed
--OUTPUTS
--data_out: output signal, one output for each filter pass that corresponds to the highest data of those recorded
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MAXPOOL_LAYER2 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        index : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
        data_in2 : IN STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0)
    );
END MAXPOOL_LAYER2;

ARCHITECTURE Behavioral OF MAXPOOL_LAYER2 IS
    SIGNAL data_out_reg, data_aux, data_out_next : STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                data_out_reg <= (OTHERS => '0');
            ELSE
                data_out_reg <= data_out_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (index, data_in, data_in2, data_aux)
    BEGIN
        IF (index = '1') THEN
            IF (data_in > data_in2) THEN
                data_aux <= data_in;
            ELSE
                data_aux <= data_in2;
            END IF;
        ELSE
            data_aux <= (OTHERS => '0');
        END IF;
    END PROCESS;

    PROCESS (index, data_aux, data_out_next, data_out_reg)
    BEGIN
        IF (index = '1') THEN
            IF (data_aux > data_out_reg) THEN
                data_out_next <= data_aux;
            ELSE
                data_out_next <= data_out_reg;
            END IF;
        ELSE
            data_out_next <= (OTHERS => '0');
        END IF;
    END PROCESS;

    data_out <= data_out_reg;
END Behavioral;