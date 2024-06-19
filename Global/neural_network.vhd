-----------------------------------------MODULE Neural Network----------------------------------------------------------
--Global module of the system
--INPUTS
--data_in : If we are using the mock_memory for testing this input is not used
--address : If we are using the mock_memory for testing this input is not used
--start   : If we want an automatic start this signal is not used, for a manual start uncomment the lines of code of the start signal in the controller
--OUTPUTS
--finish   : signals that the system is finished
--en_riscv : signals that the systems is processing
--y        : output if the system
--an,seg   : control signals for the LEDs
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY neural_network IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        en_riscv : OUT STD_LOGIC;
        an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        y : OUT STD_LOGIC_VECTOR(log2c(number_of_outputs_L3fc) - 1 DOWNTO 0);
        finish : OUT STD_LOGIC
    );
END neural_network;
ARCHITECTURE Behavioral OF neural_network IS
    -- Component declaration --
    COMPONENT CNN_red IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            rst_red : IN STD_LOGIC;
            start_red : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
            data_fc : IN STD_LOGIC;
            data_ready : OUT STD_LOGIC;
            address : OUT STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_size_L1fc - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT FC IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            rst_red : IN STD_LOGIC;
            start_enable : IN STD_LOGIC;
            data_fc : OUT STD_LOGIC;
            finish : OUT STD_LOGIC;
            x : IN STD_LOGIC_VECTOR(input_size_L1fc - 1 DOWNTO 0);
            y : OUT unsigned(log2c(number_of_outputs_L3fc) - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT controller IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            rst_red : OUT STD_LOGIC;
            en_riscv : OUT STD_LOGIC;
            finish_red : IN STD_LOGIC;
            y_red : IN unsigned(log2c(number_of_outputs_L3fc) - 1 DOWNTO 0);
            start_red : OUT STD_LOGIC;
            finish : OUT STD_LOGIC;
            y : OUT unsigned(log2c(number_of_outputs_L3fc) - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT Mock_Memory IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT LED IS
        PORT (
            clk : IN STD_LOGIC;
            y : IN unsigned(log2c(number_of_outputs_L3fc) - 1 DOWNTO 0);
            an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL data_ready, data_fc, finish_red, start_red : STD_LOGIC;
    SIGNAL address_byte : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL address_buff : STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 DOWNTO 0);
    SIGNAL data_in : STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
    SIGNAL data_in_red : STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
    SIGNAL output_sm_red, output_sm_buff : vector_sm_signed(0 TO number_of_outputs_L3fc - 1);
    SIGNAL y_red, y_buff : unsigned(0 TO log2c(number_of_outputs_L3fc) - 1);
    SIGNAL x_reg, x_next : STD_LOGIC_VECTOR(input_size_L1fc - 1 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR(input_size_L1fc - 1 DOWNTO 0);
    SIGNAL rst_cnn, rst_red : STD_LOGIC;
BEGIN
    CNN_network : CNN_red
    PORT MAP(
        clk => clk,
        rst => rst,
        rst_red => rst_red,
        address => address_buff,
        data_fc => data_fc,
        data_in => data_in,
        data_ready => data_ready,
        start_red => start_red,
        data_out => data_out
    );
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (rst = '0') THEN
                x_reg <= (OTHERS => '0');
            ELSE
                x_reg <= x_next;
            END IF;
        END IF;
    END PROCESS;

    x_next <= data_out;
    FC_network : FC
    PORT MAP(
        clk => clk,
        rst => rst,
        rst_red => rst_red,
        start_enable => data_ready,
        data_fc => data_fc,
        finish => finish_red,
        x => x_reg,
        y => y_red
    );
    control : controller
    PORT MAP(
        clk => clk,
        rst => rst,
        en_riscv => en_riscv,
        start_red => start_red,
        finish_red => finish_red,
        finish => finish,
        y_red => y_red,
        rst_red => rst_red,
        y => y_buff
    );
    y <= STD_LOGIC_VECTOR(y_buff);
    Mem_Prueba : Mock_Memory
    PORT MAP(
        clk => clk,
        rst => rst,
        address => address_buff,
        data_out => data_in
    );
    LED_OUT : LED
    PORT MAP(
        clk => clk,
        y => y_buff,
        an => an,
        seg => seg
    );

END Behavioral;