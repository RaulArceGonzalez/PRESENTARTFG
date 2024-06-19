----------------------------CONTROLLER----------------------------
-- These module is a controller of the entire neural network
--INPUTS
--start : signals for the entire system to start
--finish_red : signals that the system has finished
--y_red : output of the neural network
--OUTPUTS
--rst_red : signal to reset the red after processing an image
--start_red : signal for the system to start,  we generate it from the processor so it is only send when the system is not already functioning
--finish : signals that the system has finished.
--en_riscv :  signal that notifies to the cpu that the system is functioning
--y : output of the neural network

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY controller IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        rst_red : OUT STD_LOGIC;
        en_riscv : OUT STD_LOGIC;
        finish_red : IN STD_LOGIC;
        y_red : IN unsigned(log2c(number_of_outputs_L4fc) - 1 DOWNTO 0);
        start_red : OUT STD_LOGIC;
        finish : OUT STD_LOGIC;
        y : OUT unsigned(log2c(number_of_outputs_L4fc) - 1 DOWNTO 0)
    );
END controller;

ARCHITECTURE Behavioral OF controller IS
    TYPE state_type IS (idle, espera, infer, result);

    --Registers
    SIGNAL state_reg, state_next : state_type;
    SIGNAL finish_reg, finish_next, en_riscv_reg, en_riscv_next, rst_reg, rst_next : STD_LOGIC;
    SIGNAL y_reg, y_next : unsigned(0 TO log2c(number_of_outputs_L4fc) - 1);

    SIGNAL output_sm_reg, output_sm_next : vector_sm_signed(0 TO number_of_outputs_L2fc - 1);
BEGIN
    --Register
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                state_reg <= idle;
                en_riscv_reg <= '0';
                y_reg <= (OTHERS => '0');
                finish_reg <= '0';
                rst_reg <= '0';
                output_sm_reg <= (OTHERS => (OTHERS => '0'));
            ELSE
                state_reg <= state_next;
                y_reg <= y_next;
                finish_reg <= finish_next;
                en_riscv_reg <= en_riscv_next;
                rst_reg <= rst_next;
                output_sm_reg <= output_sm_next;
            END IF;
        END IF;
    END PROCESS;
    PROCESS (finish_red, y_red, state_reg, y_reg, finish_reg, rst_reg, en_riscv_reg)
    BEGIN
        state_next <= state_reg;
        y_next <= y_reg;
        finish_next <= finish_reg;
        en_riscv_next <= en_riscv_reg;
        start_red <= '0';
        rst_next <= rst_reg;
        CASE state_reg IS
            WHEN idle =>
                y_next <= (OTHERS => '0');
                finish_next <= '0';
                en_riscv_next <= '0';
                state_next <= espera;
                rst_next <= '0';
            WHEN espera =>
                rst_next <= '0';
                finish_next <= '0';
                state_next <= infer;
                start_red <= '1';
            WHEN infer =>
                start_red <= '0';
                IF (finish_red = '1') THEN
                    rst_next <= '1';
                    state_next <= result;
                    finish_next <= '1';
                    en_riscv_next <= '0';
                END IF;
            WHEN result =>
                y_next <= y_red;
                en_riscv_next <= '0';
                state_next <= espera;
                rst_next <= '0';
                finish_next <= '0';
        END CASE;
    END PROCESS;
    y <= y_reg;
    en_riscv <= en_riscv_reg;
    finish <= finish_reg;
    rst_red <= rst_reg;
END Behavioral;