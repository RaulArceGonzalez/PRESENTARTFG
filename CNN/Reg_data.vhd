--This module is necessary because the calculation of the first convolutional filter is parallelized and therefore we need to input signals from the memory,
--this module manages the output of address to the memory and stores the signals coming from it until they can be processed by the system
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Reg_data IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_addr : IN STD_LOGIC;
        data_red : IN STD_LOGIC;
        address_in : IN vector_address(0 TO parallel_data - 1);
        address_out : OUT STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 DOWNTO 0);
        data_in : IN STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
        data_out : OUT vector_data_in(0 TO parallel_data - 1));
END Reg_data;
ARCHITECTURE Behavioral OF Reg_data IS
    SIGNAL data_reg, data_next : vector_data_in(0 TO parallel_data - 1);
    SIGNAL data_red_reg, data_red_next : vector_data_in(0 TO parallel_data - 1) := (OTHERS => (OTHERS => '0'));
    SIGNAL address_reg, address_next : STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL c_reg, c_next, c2_reg, c2_next : unsigned(0 DOWNTO 0) := "0";
BEGIN

    --Register
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                FOR i IN 0 TO parallel_data - 1 LOOP
                    data_reg(i) <= (OTHERS => '0');
                END LOOP;
                address_reg <= (OTHERS => '0');
                c_reg <= "0";
                c2_reg <= "0";
            ELSE
                c_reg <= c_next;
                c2_reg <= c2_next;
                address_reg <= address_next;
                data_reg <= data_next;
            END IF;
        END IF;
    END PROCESS;
    --Next state logic
    PROCESS (data_red, c_reg, c2_reg, data_addr, data_in, address_in, address_reg, data_reg)
    BEGIN
        FOR i IN 0 TO parallel_data - 1 LOOP
            -- when each of the control signals (data_red for data and data_addr for addresses) is activated, we change the value of the index to process the data in order
            IF data_red = '1' THEN
                c_next <= "1";
            ELSE
                c_next <= "0";
            END IF;
            IF data_addr = '1' THEN
                c2_next <= "1";
            ELSE
                c2_next <= "0";
            END IF;
            IF (i = c_reg) THEN
                data_next(to_integer(c_reg)) <= data_in;
            ELSE
                data_next(i) <= data_reg(i);
            END IF;
            address_next <= address_in(to_integer(c2_reg));
        END LOOP;
    END PROCESS;

    --Output logic
    data_out <= data_reg;
    address_out <= address_reg;

END Behavioral;