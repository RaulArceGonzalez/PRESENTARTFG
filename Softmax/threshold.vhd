LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY threshold IS
    PORT (
        clk : STD_LOGIC;
        rst : STD_LOGIC;
        y_in : IN vector_sm_signed(0 TO number_of_outputs_L4fc - 1);
        start : IN STD_LOGIC;
        y_out : OUT unsigned(log2c(number_of_outputs_L4fc) - 1 DOWNTO 0);
        finish : OUT STD_LOGIC
    );
END threshold;

ARCHITECTURE Behavioral OF threshold IS
    TYPE state_type IS (idle, s_wait, s0);
    SIGNAL state_reg, state_next : state_type;
    SIGNAL data_reg, data_next : signed(input_size_L4fc - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL c_reg, c_next, c_aux_reg, c_aux_next : unsigned(log2c(number_of_outputs_L4fc) - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                c_reg <= (OTHERS => '0');
                data_reg <= (OTHERS => '0');
                state_reg <= idle;
                c_aux_reg <= (OTHERS => '0');
            ELSE
                data_reg <= data_next;
                c_reg <= c_next;
                state_reg <= state_next;
                c_aux_reg <= c_aux_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (state_reg, data_reg, y_in, start, c_reg, c_aux_reg)
    BEGIN
        c_next <= c_reg;
        data_next <= data_reg;
        state_next <= state_reg;
        c_aux_next <= c_aux_reg;
        CASE state_reg IS
            WHEN idle =>
                finish <= '0';
                data_next <= (OTHERS => '0');
                c_next <= (OTHERS => '0');
                state_next <= s_wait;
            WHEN s_wait =>
                finish <= '0';
                IF (start = '1') THEN
                    state_next <= s0;
                END IF;
            WHEN s0 =>
                IF (y_in(to_integer(c_reg)) > data_reg) THEN
                    data_next <= y_in(to_integer(c_reg));
                    c_aux_next <= c_reg;
                ELSE
                    data_next <= data_reg;
                END IF;
                IF (c_reg = number_of_outputs_L4fc - 1) THEN
                    data_next <= (OTHERS => '0');
                    c_next <= (OTHERS => '0');
                    finish <= '1';
                    state_next <= s_wait;
                ELSE
                    c_next <= c_reg + 1;
                    finish <= '0';
                END IF;
        END CASE;
    END PROCESS;

    y_out <= c_aux_reg;

END Behavioral;