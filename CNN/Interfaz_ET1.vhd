--------------------INTERFACE LAYER 1----------------------
--This module indicates the address of the input RAM data we need, the operation is identical
--to the interfaces of the other stages but in this case the address is also calculated, in addition we do not send data_zero
--because the generator of this stage will have to process a data independently if it is zero or if it comes from the RAM.
--INPUTS
--p_rowx, p_colx : signals indicating the amount of padding that affects each of the convolutional filter architecture
--padding_col, padding_row : signals indicating whether the column/row position will be miscalculated due to padding
--data_in : signal indicating the need to compute a new data in this layer
--poolx_col : signal indicating the position of the columns of the filter pool of the following layers, if there is no other layer this input signal does not exist
--poolx_row : signal indicating the position of the rows of the filter pool of the following layers, if there is no other layer this input signal does not exist
--convx_col : signal indicating the position of the columns of the convolution filter of the next layer, if there is no other layer this input signal does not exist
--convx_row : signal indicating the position of the rows of the convolution filter of the next layer, if there is no other layer this input signal does not exist.
--OUTPUTS
--zero, zero2 : signal that is kept at 1 or zero depending if the data to process is in padding zone or not, it is passed to a multiplexer at the input of the par2ser converter.
--dato_out : signal indicating if a new data is needed, it is passed to the generator of the previous layer.
--address, address2 : address of the required data in RAM
--data_zero1, data_zero2 : signals to indicate that the data to be processed is a zero from the padding zone

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY INTERFAZ_ET1 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        rst_red : IN STD_LOGIC;
        data_in : IN STD_LOGIC;
        padding_col2 : IN STD_LOGIC;
        padding_row2 : IN STD_LOGIC;
        col2 : IN unsigned(log2c(column_size2 + 2 * (conv2_padding)) - 1 DOWNTO 0);
        p_row2 : IN unsigned(log2c(conv2_padding) DOWNTO 0);
        p_col2 : IN unsigned(log2c(conv2_padding) DOWNTO 0);
        conv2_col : IN unsigned(log2c(conv2_column) - 1 DOWNTO 0);
        conv2_fila : IN unsigned(log2c(conv2_row) - 1 DOWNTO 0);
        pool3_col : IN unsigned(log2c(pool3_column) - 1 DOWNTO 0);
        pool3_fila : IN unsigned(log2c(pool3_row) - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC;
        zero : OUT STD_LOGIC;
        zero2 : OUT STD_LOGIC;
        data_zero1 : OUT STD_LOGIC;
        data_zero2 : OUT STD_LOGIC;
        data_addr : OUT STD_LOGIC;
        address : OUT STD_LOGIC_VECTOR(log2c(number_of_inputs + 1) - 1 DOWNTO 0);
        address2 : OUT STD_LOGIC_VECTOR(log2c(number_of_inputs + 1) - 1 DOWNTO 0));
END Interfaz_ET1;
ARCHITECTURE Behavioral OF Interfaz_ET1 IS
    TYPE state_type IS (idle, s_wait, s0, s1, s2);
    SIGNAL state_reg, state_next : state_type;
    SIGNAL col_reg, col_next : unsigned(log2c(column_limit1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL row_reg, row_next : unsigned(log2c(row_limit1) DOWNTO 0) := (OTHERS => '0');
    SIGNAL sum_row2, sum_col2 : unsigned(bits_sum1_et1 DOWNTO 0) := (OTHERS => '0');
    --Layer 1
    SIGNAL conv1_col_reg, conv1_col_next : unsigned(log2c(conv1_column) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL conv1_row_reg, conv1_row_next : unsigned(log2c(conv1_row) - 1 DOWNTO 0) := (OTHERS => '0');
    --signal count_layer_reg, count_layer_next :  unsigned(log2c(number_of_layers1) - 1 downto 0) := (others => '0');
    -- Layer 2
    --signal pool2_col_reg, pool2_col_next : unsigned(log2c(pool2_column) - 1 downto 0) := (others => '0');
    SIGNAL pool2_row_reg, pool2_row_next : unsigned(log2c(pool2_row) - 1 DOWNTO 0) := (OTHERS => '0');
    --REGISTERS
    SIGNAL address_reg, address_next : unsigned(log2c(column_limit1) + log2c(column_limit1) + 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL address2_reg, address2_next : unsigned(log2c(row_limit1) + log2c(row_limit1) + 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL condition0, condition1, first_reg, first_next, data_out_reg, data_out_next, zero_reg, zero_next, zero2_reg, zero2_next, data_zero1_reg, data_zero1_next, data_zero2_reg, data_zero2_next, data_addr_next, data_addr_reg : STD_LOGIC := '0';
    SIGNAL p_flag_reg, p_flag_next, c_reg, c_next : STD_LOGIC := '0';
    SIGNAL stride1 : unsigned(stride2_et1 - 1 DOWNTO 0);

BEGIN
    PROCESS (clk)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (rst = '0') THEN
                state_reg <= idle;
            ELSE
                state_reg <= state_next;
                col_reg <= col_next;
                row_reg <= row_next;
                data_zero1_reg <= data_zero1_next;
                data_zero2_reg <= data_zero2_next;
                --pool2_col_reg <= pool2_col_next;
                pool2_row_reg <= pool2_row_next;
                conv1_col_reg <= conv1_col_next;
                conv1_row_reg <= conv1_row_next;
                --count_layer_reg <= count_layer_next;
                address_reg <= address_next;
                address2_reg <= address2_next;
                first_reg <= first_next;
                data_out_reg <= data_out_next;
                zero_reg <= zero_next;
                zero2_reg <= zero2_next;
                p_flag_reg <= p_flag_next;
                data_addr_reg <= data_addr_next;
                c_reg <= c_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (p_flag_reg)
    BEGIN
        IF (p_flag_reg = '1') THEN
        ELSE
        END IF;
    END PROCESS;
    PROCESS (condition0, condition1, c_reg, rst_red, data_zero1_reg, data_zero2_reg, p_flag_reg, col2, padding_row2, padding_col2, zero_reg, zero2_reg, address_next, address_reg, address2_reg, data_out_reg, conv1_col_reg, conv1_row_reg, pool2_row_reg, row_reg, col_reg, data_in, col_next, row_next, first_reg, state_reg, address2_next, data_addr_reg, sum_row2, sum_col2, stride1, p_row2, p_col2, conv2_col, conv2_fila, pool3_col, pool3_fila)
    BEGIN
        data_addr_next <= data_addr_reg;
        state_next <= state_reg;
        col_next <= col_reg;
        row_next <= row_reg;
        conv1_col_next <= conv1_col_reg;
        conv1_row_next <= conv1_row_reg;
        p_flag_next <= p_flag_reg;
        --count_layer_next <= count_layer_reg;
        --pool2_col_next <= pool2_col_reg;
        pool2_row_next <= pool2_row_reg;
        address_next <= address_reg;
        address2_next <= address2_reg;
        first_next <= first_reg;
        data_out_next <= data_out_reg;
        zero_next <= zero_reg;
        zero2_next <= zero2_reg;
        data_zero1_next <= data_zero1_reg;
        data_zero2_next <= data_zero2_reg;
        sum_row2 <= unsigned(stride1 * p_row2);
        sum_col2 <= unsigned(stride1 * p_col2);
        c_next <= c_reg;
        condition0 <= '0';
        condition1 <= '0';
        CASE state_reg IS
            WHEN idle =>
                col_next <= (OTHERS => '0');
                row_next <= (OTHERS => '0');
                data_zero1_next <= '0';
                data_zero2_next <= '0';
                conv1_col_next <= (OTHERS => '0');
                conv1_row_next <= (OTHERS => '0');
                --count_layer_next <= (others => '0');
                --pool2_col_next <= (others => '0');
                pool2_row_next <= (OTHERS => '0');
                address_next <= (OTHERS => '0');
                address2_next <= (OTHERS => '0');
                zero_next <= '0';
                zero2_next <= '0';
                first_next <= '0';
                data_out_next <= '0';
                state_next <= s_wait;
                p_flag_next <= '0';
                data_addr_next <= '0';
            WHEN s_wait =>

                data_out_next <= '0';
                data_zero1_next <= '0';
                data_zero2_next <= '0';
                IF (data_in = '1') THEN --We calculate the direction of the memory we need at each stage
                    p_flag_next <= '1';
                    state_next <= s0;
                END IF;
                IF (rst_red = '1') THEN
                    state_next <= idle;
                END IF;
            WHEN s0 =>
                --if((padding_row2 = '0' and padding_col2 = '0'))then 
                --condition0 <= '1';
                --else
                --condition0 <= '0';
                --end if;
                --if((padding_row2 = '1' or padding_col2 = '1')) then
                --condition1 <= '1';
                --else
                --condition1 <= '0';
                --end if;
                p_flag_next <= '0';
                IF (first_reg = '0') THEN
                    first_next <= '1';
                    state_next <= s1;
                    zero_next <= '1';
                ELSE
                    IF (conv1_col_reg /= conv1_column - 1) THEN
                        col_next <= col_reg + loop_columns1_1;
                        conv1_col_next <= conv1_col_reg + 1;
                    ELSE
                        conv1_col_next <= (OTHERS => '0');
                        IF (conv1_row_reg /= (conv1_row - 1)) THEN
                            col_next <= col_reg - loop_columns1_2;
                            row_next <= row_reg + loop_rows1_1;
                            conv1_row_next <= conv1_row_reg + 1;
                        ELSE
                            conv1_row_next <= (OTHERS => '0');
                            --                if(count_layer_reg /= number_of_layers1 - 1) then
                            --                    col_next <= col_reg - loop_columns1_2;
                            --                   row_next <= row_reg - loop_rows1_2;
                            --                    count_layer_next <= count_layer_reg + 1;
                            --                else
                            --                    count_layer_next <= (others => '0');
                            IF (pool2_row_reg /= (pool2_row - 1)) THEN
                                col_next <= col_reg - loop_columns1_4;
                                row_next <= row_reg - loop_rows1_3;
                                pool2_row_next <= pool2_row_reg + 1;
                            ELSE
                                pool2_row_next <= (OTHERS => '0');
                                --              if(padding_col2 = '1' and padding_row2 = '1') then
                                --                 row_next <= (others => '0');
                                --                 col_next <= (others => '0');
                                --              else
                                IF ((conv2_col /= 0)) THEN
                                    row_next <= row_reg - loop_rows1_4;
                                    col_next <= col_reg - loop_columns1_5;
                                ELSE
                                    IF (conv2_fila /= 0) THEN
                                        row_next <= row_reg - loop_rows1_5;
                                        col_next <= col_reg - loop_columns1_6 + sum_col2;
                                    ELSE
                                        IF (pool3_col /= 0) THEN
                                            row_next <= row_reg - loop_rows1_6 + sum_row2;
                                            col_next <= col_reg - loop_columns1_7 + sum_col2;
                                        ELSE
                                            IF (pool3_fila /= 0) THEN
                                                row_next <= row_reg - loop_rows1_7 + sum_row2;
                                                col_next <= col_reg - loop_columns1_8 + sum_col2;
                                            ELSE
                                                IF ((col_reg /= (column_limit1 - 1 - stride1_et1))) THEN
                                                    col_next <= col_reg - loop_columns1_9 + sum_col2;
                                                    row_next <= row_reg - loop_rows1_8 + sum_row2;
                                                ELSE
                                                    row_next <= row_reg - loop_rows1_9 + sum_row2;
                                                    col_next <= (OTHERS => '0');
                                                    IF (row_reg = row_limit1) THEN
                                                        row_next <= (OTHERS => '0');
                                                        --end if;
                                                        --end if;
                                                    END IF;
                                                END IF;
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                        IF (padding_row2 /= '0') THEN
                            row_next <= (OTHERS => '0');
                        END IF;
                        IF (padding_col2 /= '0') THEN
                            col_next <= (OTHERS => '0');
                        END IF;
                    END IF;
                    address_next <= col_next + (row_size1 * row_next);
                    address2_next <= col_next + (row_size1 * row_next);
                    state_next <= s1;
                END IF;
            WHEN s1 =>
                IF ((conv1_padding > col_reg) OR (col_reg >= column_size1 + conv1_padding) OR (conv1_padding > row_reg) OR (row_reg >= row_size1 + conv1_padding)) THEN
                    zero_next <= '1';
                    data_zero1_next <= '1';
                ELSE
                    zero_next <= '0';
                    address_next <= address_reg - (conv1_padding + (row_size1 * conv1_padding));
                END IF;
                IF ((conv1_padding > (col_reg + stride1_et1)) OR ((col_reg + stride1_et1) >= column_size1 + conv1_padding) OR (conv1_padding > row_reg) OR (row_reg >= row_size1 + conv1_padding)) THEN
                    zero2_next <= '1';
                    data_zero2_next <= '1';
                ELSE
                    zero2_next <= '0';
                    address2_next <= address2_reg - (conv1_padding + (row_size1 * conv1_padding)) + stride1_et1;
                END IF;
                data_addr_next <= '1';
                state_next <= s2;
            WHEN s2 =>
                c_next <= '1';
                IF (c_reg = '1') THEN
                    c_next <= '0';
                    state_next <= s_wait;
                    data_out_next <= '1';
                END IF;
                data_addr_next <= '0';
        END CASE;
    END PROCESS;
    stride1 <= to_unsigned(stride2_et1, stride2_et1);

    -- Output signals
    address <= STD_LOGIC_VECTOR(address_reg(log2c(number_of_inputs + 1) - 1 DOWNTO 0)) WHEN zero_reg = '0' ELSE
        (OTHERS => '0');
    address2 <= STD_LOGIC_VECTOR(address2_reg(log2c(number_of_inputs + 1) - 1 DOWNTO 0)) WHEN zero2_reg = '0' ELSE
        (OTHERS => '0');
    data_out <= data_out_reg;
    zero <= zero_reg;
    zero2 <= zero2_reg;
    data_zero1 <= data_zero1_reg;
    data_zero2 <= data_zero2_reg;
    data_addr <= data_addr_reg;
END Behavioral;