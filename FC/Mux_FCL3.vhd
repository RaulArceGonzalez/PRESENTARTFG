--------------------MULTIPLEXER MODULE----------------------
--This module selects the data to be sent at each moments to the neurons in the layer, it also saturates the inputdata if its to big or to small
--INPUTS
--data_in : output from the neurons
--ctrl : control signal to know which data is to be sent
--mac_max, mac_min : maximum and minimum value that each input data can take (stauration values)
--OUTPUTS
--data_out : input data send to the following layer
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Mux_FCL3 IS
    PORT (
        data_in : IN vector_L3fc_activations(0 TO number_of_inputs_L4fc - 1);
        ctrl : IN STD_LOGIC_VECTOR(log2c(number_of_outputs_L3fc) - 1 DOWNTO 0);
        mac_max : IN signed (input_size_L4fc + weight_size_L4fc + n_extra_bits - 1 DOWNTO 0);
        mac_min : IN signed (input_size_L4fc + weight_size_L4fc + n_extra_bits - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(input_size_L4fc - 1 DOWNTO 0));
END Mux_FCL3;
ARCHITECTURE Behavioral OF Mux_FCL3 IS

    SIGNAL index : unsigned (log2c(number_of_outputs_L3fc) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out_pre_1,data_out_pre_2,data_out_pre_3 : STD_LOGIC_VECTOR(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out_buff : STD_LOGIC_VECTOR(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out_1,data_out_2,data_out_3 : STD_LOGIC_VECTOR(input_size_L4fc - 1 DOWNTO 0);
    
BEGIN

    index <= unsigned(ctrl);

    PROCESS (data_in, index)
    BEGIN
        IF (index < number_of_outputs_L3fc) THEN
            data_out_pre_1 <= data_in(to_integer(index));
        ELSE
            data_out_pre_1(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1) <= '1';
            data_out_pre_1(input_size_L3fc + weight_size_L3fc + n_extra_bits - 2 DOWNTO 0) <= (OTHERS => '0');
        END IF;

    END PROCESS;
    PROCESS (data_in, index)
    BEGIN
        IF (index < number_of_outputs_L3fc) THEN
            data_out_pre_2 <= data_in(to_integer(index));
        ELSE
            data_out_pre_2(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1) <= '1';
            data_out_pre_2(input_size_L3fc + weight_size_L3fc + n_extra_bits - 2 DOWNTO 0) <= (OTHERS => '0');
        END IF;

    END PROCESS;
    PROCESS (data_in, index)
    BEGIN
        IF (index < number_of_outputs_L3fc) THEN
            data_out_pre_3 <= data_in(to_integer(index));
        ELSE
            data_out_pre_3(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1) <= '1';
            data_out_pre_3(input_size_L3fc + weight_size_L3fc + n_extra_bits - 2 DOWNTO 0) <= (OTHERS => '0');
        END IF;

    END PROCESS;
    -- Selection of the output value taking into account the saturation values
    PROCESS (mac_max, mac_min, data_out_pre_1, data_out_buff)
    BEGIN
        data_out_buff <= "00" & data_out_pre_1(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1 DOWNTO 2);
        IF (signed(data_out_pre_1) >= mac_max) THEN
            data_out_1(input_size_L4fc - 1) <= '0';
            data_out_1(input_size_L4fc - 2 DOWNTO 0) <= (OTHERS => '1');
        ELSIF (signed(data_out_pre_1) <= mac_min) THEN
            data_out_1(input_size_L4fc - 1) <= '0';
            data_out_1(input_size_L4fc - 2 DOWNTO 0) <= (OTHERS => '0');
        ELSE
            data_out_1 <= data_out_buff(w_fractional_size_L3fc + input_size_L4fc - 1 DOWNTO w_fractional_size_L3fc);
        END IF;
    END PROCESS;
    PROCESS (mac_max, mac_min, data_out_pre_2, data_out_buff)
    BEGIN
        data_out_buff <= "00" & data_out_pre_2(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1 DOWNTO 2);
        IF (signed(data_out_pre_2) >= mac_max) THEN
            data_out_2(input_size_L4fc - 1) <= '0';
            data_out_2(input_size_L4fc - 2 DOWNTO 0) <= (OTHERS => '1');
        ELSIF (signed(data_out_pre_2) <= mac_min) THEN
            data_out_2(input_size_L4fc - 1) <= '0';
            data_out_2(input_size_L4fc - 2 DOWNTO 0) <= (OTHERS => '0');
        ELSE
            data_out_2 <= data_out_buff(w_fractional_size_L3fc + input_size_L4fc - 1 DOWNTO w_fractional_size_L3fc);
        END IF;
    END PROCESS;
    PROCESS (mac_max, mac_min, data_out_pre_3, data_out_buff)
    BEGIN
        data_out_buff <= "00" & data_out_pre_3(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1 DOWNTO 2);
        IF (signed(data_out_pre_3) >= mac_max) THEN
            data_out_3(input_size_L4fc - 1) <= '0';
            data_out_3(input_size_L4fc - 2 DOWNTO 0) <= (OTHERS => '1');
        ELSIF (signed(data_out_pre_3) <= mac_min) THEN
            data_out_3(input_size_L4fc - 1) <= '0';
            data_out_3(input_size_L4fc - 2 DOWNTO 0) <= (OTHERS => '0');
        ELSE
            data_out_3 <= data_out_buff(w_fractional_size_L3fc + input_size_L4fc - 1 DOWNTO w_fractional_size_L3fc);
        END IF;
    END PROCESS;
    data_out <= (data_out_1 and data_out_2) or (data_out_1 and data_out_3) or (data_out_2 and data_out_3);
END Behavioral;