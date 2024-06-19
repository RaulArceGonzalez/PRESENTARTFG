LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY Reg_softmax_1 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(input_size_L4fc - 1 DOWNTO 0);
        index : IN unsigned(log2c(number_of_outputs_L4fc) - 1 DOWNTO 0);
        data_out : OUT vector_sm(number_of_outputs_L4fc - 1 DOWNTO 0)
    );
END Reg_softmax_1;

ARCHITECTURE Behavioral OF Reg_softmax_1 IS
    SIGNAL data_next, data_reg : vector_sm(number_of_outputs_L4fc - 1 DOWNTO 0) := (OTHERS => (OTHERS => '0'));
BEGIN
    -- Register
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                data_reg <= (OTHERS => (OTHERS => '0'));
            ELSE
                FOR i IN 0 TO number_of_outputs_L4fc - 1 LOOP
                    data_reg(i) <= data_next(i);
                END LOOP;
            END IF;
        END IF;
    END PROCESS;

    -- Input process
    PROCESS (data_in, index, data_next, data_reg)
    BEGIN
        FOR i IN 0 TO number_of_outputs_L4fc - 1 LOOP
            IF (i = index) THEN
                data_next(to_integer(index)) <= data_in;
            ELSE
                data_next(i) <= data_reg(i);
            END IF;
        END LOOP;
    END PROCESS;

    -- Output assignment
    data_out <= data_reg;
END Behavioral;