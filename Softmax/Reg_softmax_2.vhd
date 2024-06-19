LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY Reg_softmax_2 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(input_size_L4fc - 1 DOWNTO 0);
        reg_Sm : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(input_size_L4fc - 1 DOWNTO 0)
    );
END Reg_softmax_2;

ARCHITECTURE Behavioral OF Reg_softmax_2 IS
    SIGNAL data_next, data_reg : STD_LOGIC_VECTOR(input_size_L4fc - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    -- Register
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                data_reg <= (OTHERS => '0');
            ELSE
                data_reg <= data_next;
            END IF;
        END IF;
    END PROCESS;

    -- Input process
    PROCESS (data_in, reg_Sm, data_next, data_reg)
    BEGIN
        IF (reg_Sm = '1') THEN
            data_next <= data_in;
        ELSE
            data_next <= data_reg;
        END IF;
    END PROCESS;

    -- Output assignment
    data_out <= data_reg;
END Behavioral;