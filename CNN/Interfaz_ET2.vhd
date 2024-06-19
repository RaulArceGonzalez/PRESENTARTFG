--------------------INTERFACE LAYER 2----------------------
--This module indicates the position of the filters to calculate the data we need in the input matrix
--INPUTS
--p_rowx, p_colx : signals indicating the amount of padding that affects each of the convolutional filter architecture
--padding_col, padding_row : signals indicating whether the column/row position will be miscalculated due to padding
--data_in : signal indicating the need to compute a new data in this layer
--OUTPUTS
--poolx_col : signal indicating the position of the columns of the filter pool of the current layerst
--poolx_row : signal indicating the position of the rows of the filter pool of the current layers
--convx_col : signal indicating the position of the columns of the convolution filter of the current layer
--convx_row : signal indicating the position of the rows of the convolution filter of the current layer
--zero,: signal that is kept at 1 or zero depending if the data to process is in padding zone or not, it is passed to a multiplexer at the input of the par2ser converter.
--dato_out : signal indicating if a new data is needed, it is passed to the generator of the previous layer.
--data_zero : signals to indicate that the data to be processed is a zero from the padding zone

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY INTERFAZ_ET2 IS
   PORT (
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      rst_red : IN STD_LOGIC;
      data_in : IN STD_LOGIC;
      zero : OUT STD_LOGIC;
      data_zero : OUT STD_LOGIC;
      data_out : OUT STD_LOGIC;
      padding_col2 : OUT STD_LOGIC;
      padding_row2 : OUT STD_LOGIC;
      col2 : OUT unsigned(log2c(column_size2 + 2 * (conv2_padding)) - 1 DOWNTO 0);
      p_row2 : OUT unsigned(log2c(conv2_padding) DOWNTO 0);
      p_col2 : OUT unsigned(log2c(conv2_padding) DOWNTO 0);
      conv2_col : OUT unsigned(log2c(conv2_column) - 1 DOWNTO 0);
      conv2_fila : OUT unsigned(log2c(conv2_row) - 1 DOWNTO 0);
      pool3_col : OUT unsigned(log2c(pool3_column) - 1 DOWNTO 0);
      pool3_fila : OUT unsigned(log2c(pool3_row) - 1 DOWNTO 0));
END Interfaz_ET2;
ARCHITECTURE Behavioral OF Interfaz_ET2 IS
   TYPE state_type IS (idle, s_wait, s0, s1, s2);
   SIGNAL state_reg, state_next : state_type;
   SIGNAL p_col_aux : unsigned(log2c(column_size2) - 1 DOWNTO 0);
   SIGNAL p_row_aux : unsigned(log2c(row_size2) - 1 DOWNTO 0);
   SIGNAL p_row_reg, p_row_next : unsigned(log2c(conv2_padding) DOWNTO 0);
   SIGNAL p_col_reg, p_col_next : unsigned(log2c(conv2_padding) DOWNTO 0);
   SIGNAL col_reg, col_next : unsigned(log2c(column_size2 + 2 * (conv2_padding)) - 1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL row_reg, row_next : unsigned(log2c(row_size2 + 2 * (conv2_padding)) - 1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL c_col_reg, c_col_next, c_row_reg, c_row_next, flag_reg, flag_next : STD_LOGIC := '0';

   --Layer 2
   SIGNAL conv2_col_reg, conv2_col_next : unsigned(log2c(conv2_column) - 1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL conv2_row_reg, conv2_row_next : unsigned(log2c(conv2_row) - 1 DOWNTO 0) := (OTHERS => '0');
   -- Layer 3
   SIGNAL pool3_col_reg, pool3_col_next : unsigned(log2c(pool3_column) - 1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL pool3_row_reg, pool3_row_next : unsigned(log2c(pool3_row) - 1 DOWNTO 0) := (OTHERS => '0');

   --Registers
   SIGNAL first_reg, first_next, zero_reg, zero_next, data_zero_reg, data_zero_next, data_out_reg, data_out_next : STD_LOGIC;

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
            pool3_col_reg <= pool3_col_next;
            pool3_row_reg <= pool3_row_next;
            conv2_col_reg <= conv2_col_next;
            conv2_row_reg <= conv2_row_next;
            p_row_reg <= p_row_next;
            p_col_reg <= p_col_next;
            first_reg <= first_next;
            zero_reg <= zero_next;
            c_col_reg <= c_col_next;
            c_row_reg <= c_row_next;
            data_out_reg <= data_out_next;
            data_zero_reg <= data_zero_next;
            flag_reg <= flag_next;
         END IF;
      END IF;
   END PROCESS;
   PROCESS (rst_red, data_out_reg, data_zero_reg, flag_reg, c_col_reg, c_row_reg, p_row_aux, p_col_aux, p_row_reg, p_col_reg, conv2_col_next, conv2_row_next, conv2_col_reg, conv2_row_reg, pool3_col_next, pool3_col_reg, pool3_row_reg, pool3_row_next, zero_reg, first_reg, state_reg, row_reg, col_reg, data_in, col_next, row_next, p_row_next, p_col_next)

   BEGIN
      state_next <= state_reg;
      col_next <= col_reg;
      row_next <= row_reg;
      p_col_next <= p_col_reg;
      p_row_next <= p_row_reg;
      conv2_col_next <= conv2_col_reg;
      conv2_row_next <= conv2_row_reg;
      pool3_col_next <= pool3_col_reg;
      pool3_row_next <= pool3_row_reg;
      first_next <= first_reg;
      zero_next <= zero_reg;
      c_col_next <= c_col_reg;
      c_row_next <= c_row_reg;
      p_row_aux <= (OTHERS => '0');
      p_col_aux <= (OTHERS => '0');
      flag_next <= flag_reg;
      data_zero_next <= '0';
      data_out_next <= '0';

      CASE state_reg IS
         WHEN idle =>
            data_out_next <= '0';
            data_zero_next <= '0';
            col_next <= (OTHERS => '0');
            row_next <= (OTHERS => '0');
            p_row_aux <= (OTHERS => '0');
            p_col_aux <= (OTHERS => '0');
            conv2_col_next <= (OTHERS => '0');
            conv2_row_next <= (OTHERS => '0');
            pool3_col_next <= (OTHERS => '0');
            pool3_row_next <= (OTHERS => '0');
            first_next <= '1';
            state_next <= s_wait;
            p_row_next <= (OTHERS => '0');
            p_col_next <= (OTHERS => '0');
            zero_next <= '0';
            c_col_next <= '0';
            c_row_next <= '0';
            flag_next <= '0';
         WHEN s_wait =>
            p_row_next <= (OTHERS => '0');
            p_col_next <= (OTHERS => '0');
            data_out_next <= '0';
            data_zero_next <= '0';
            c_col_next <= '0';
            c_row_next <= '0';
            IF (data_in = '1') THEN
               state_next <= s0;
               flag_next <= '0';
            END IF;
            IF (rst_red = '1') THEN
               state_next <= idle;
            END IF;
         WHEN s0 =>
            IF (first_reg = '1') THEN
               first_next <= '0';
               zero_next <= '0';
               data_out_next <= '1';
               data_zero_next <= '0';
            ELSE
               IF (conv2_col_reg /= conv2_column - 1) THEN --If the filter sweep has not finished running through the colums, we add one to the columns.
                  col_next <= col_reg + loop_columns2_1;
                  conv2_col_next <= conv2_col_reg + 1;
               ELSE
                  conv2_col_next <= (OTHERS => '0');
                  IF (conv2_row_reg /= (conv2_row - 1)) THEN --If the filter sweep  has not finished running trhough the rows, we add one to the row and return the original value to the columns.
                     col_next <= col_reg - loop_columns2_2;
                     row_next <= row_reg + loop_rows2_1;
                     conv2_row_next <= conv2_row_reg + 1;
                  ELSE
                     conv2_row_next <= (OTHERS => '0');
                     IF (pool3_col_reg /= pool3_column - 1) THEN
                        row_next <= row_reg - loop_rows2_2;
                        col_next <= col_reg - loop_columns2_3;
                        pool3_col_next <= pool3_col_reg + 1;
                     ELSE
                        pool3_col_next <= (OTHERS => '0');
                        IF (pool3_row_reg /= (pool3_row - 1)) THEN
                           row_next <= row_reg - loop_rows2_3;
                           col_next <= col_reg - loop_columns2_4;
                           pool3_row_next <= pool3_row_reg + 1;
                        ELSE
                           pool3_row_next <= (OTHERS => '0');
                           IF (col_reg /= column_limit2 - 1) THEN
                              row_next <= row_reg - loop_rows2_4;
                              col_next <= col_reg - loop_columns2_5;
                           ELSE
                              row_next <= row_reg - loop_rows2_5;
                              col_next <= (OTHERS => '0');
                              IF (row_reg = row_limit2) THEN
                                 row_next <= (OTHERS => '0');
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
            state_next <= s1;
         WHEN s1 =>
            data_out_next <= '1';
            data_zero_next <= '0';
            zero_next <= '0';
            state_next <= s2;
         WHEN s2 =>
            data_zero_next <= '0';
            state_next <= s_wait;
      END CASE;
   END PROCESS;
   -- Output signals
   col2 <= col_reg;
   conv2_col <= conv2_col_reg;
   conv2_fila <= conv2_row_reg;
   pool3_col <= pool3_col_reg;
   pool3_fila <= pool3_row_reg;
   zero <= zero_reg;
   p_col2 <= p_col_reg;
   p_row2 <= p_row_reg;
   padding_col2 <= c_col_reg;
   padding_row2 <= c_row_reg;
   data_out <= data_out_reg;
   data_zero <= data_zero_reg;
END Behavioral;