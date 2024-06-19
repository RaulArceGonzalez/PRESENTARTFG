-----------------------------------CNN NETWORK-------------------------------------
--THIS SYSTEM CORRESPONDS TO A CONVOLUTIONAL NEURAL NETWORK WITH DIMENSIONS TO BE SPECIFIED IN THE LIBRARY
--INPUTS
--start_red : start the processing of data
--data_in : data to be processed from the memory
--data_fc : signals that a new data has been processed by the FC network

--OUTPUTS
--data_ready: signal indicating that a data is available on the network
--data_out: data processed by the last layer of the neuron
--address : address to be sent to the memory

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.MATH_REAL.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY CNN_red IS
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
END CNN_red;
ARCHITECTURE Behavioral OF CNN_red IS
    COMPONENT Reg_data
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            data_addr : IN STD_LOGIC;
            data_red : IN STD_LOGIC;
            address_in : IN vector_address(0 TO parallel_data - 1);
            address_out : OUT STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(input_sizeL1 - 1  DOWNTO 0);
            data_out : OUT vector_data_in(0 TO parallel_data - 1));
    END COMPONENT;

    COMPONENT PAR2SER
        GENERIC (input_size : INTEGER := 8);
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR (input_size - 1 DOWNTO 0);
            en_neuron : IN STD_LOGIC;
            bit_select : IN unsigned(log2c(input_size) - 1 DOWNTO 0);
            bit_out : OUT STD_LOGIC);
    END COMPONENT;
    component VOT_PAR2SER
	 Port (
		 serial_out_1 : in STD_LOGIC;
		 serial_out_2 : in STD_LOGIC;
		 serial_out_3 : in STD_LOGIC;
		 serial_out_v : out STD_LOGIC);
end component;

    COMPONENT MAXPOOL_LAYER2
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            index : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0));
    END COMPONENT;
    component VOT_MAXPOOL_LAYER2
Port (
      data_out_1 : in std_logic_vector(input_sizeL1  - 1 downto 0);
      data_out_2 : in std_logic_vector(input_sizeL1  - 1 downto 0);
      data_out_3 : in std_logic_vector(input_sizeL1  - 1 downto 0);
      data_out_v : out std_logic_vector(input_sizeL1  - 1 downto 0));
end component;
    COMPONENT MAXPOOL_L3
        GENERIC (
            input_size : INTEGER := 8;
            weight_size : INTEGER := 8);
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            next_data_pool : IN STD_LOGIC;
            index : STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0));
    END COMPONENT;
    component VOT_MAXPOOL_L3
 generic (
 input_size : integer := 8; 
 weight_size : integer := 8);
Port ( 
      data_out_1 : in STD_LOGIC_VECTOR(input_size - 1 downto 0);
      data_out_2 : in STD_LOGIC_VECTOR(input_size - 1 downto 0);
      data_out_3 : in STD_LOGIC_VECTOR(input_size - 1 downto 0);
      data_out_v : out STD_LOGIC_VECTOR(input_size - 1 downto 0));
end component;
    --Layer 1
    COMPONENT GEN1
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            rst_red : IN STD_LOGIC;
            data_in : IN STD_LOGIC;
            data_zero1 : IN STD_LOGIC;
            data_zero2 : IN STD_LOGIC;
            count : OUT unsigned(log2c(input_sizeL1) - 1 DOWNTO 0);
            mul : OUT STD_LOGIC_VECTOR(log2c(mult1) - 1 DOWNTO 0);
            en_neuron : OUT STD_LOGIC;
            data_out1 : OUT STD_LOGIC;
            data_out2 : OUT STD_LOGIC;
            next_pipeline_step : OUT STD_LOGIC);
    END COMPONENT;
    component VOT_GEN1
	 Port (
		 en_neuron_1 : in std_logic;
		 count_1 : in unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_1: in std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_1: in std_logic; 
		 dato_out2_1 : in std_logic;
		 next_pipeline_step_1 : in std_logic;
		 en_neuron_2 : in std_logic;
		 count_2 : in unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_2: in std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_2: in std_logic; 
		 dato_out2_2 : in std_logic;
		 next_pipeline_step_2 : in std_logic;
		 en_neuron_3 : in std_logic;
		 count_3 : in unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_3: in std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_3: in std_logic; 
		 dato_out2_3 : in std_logic;
		 next_pipeline_step_3 : in std_logic;
		 en_neuron_v : out std_logic;
		 count_v : out unsigned( log2c(input_sizeL1)-1   downto 0);
		 mul_v: out std_logic_vector(log2c(mult1) - 1 downto 0);
		 dato_out1_v: out std_logic; 
		 dato_out2_v : out std_logic;
		 next_pipeline_step_v : out std_logic);
end component;
    COMPONENT INTERFAZ_ET1
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
    END COMPONENT;
    component VOT_INTERFAZ_ET1
	 Port (
		 dato_out_1 : in std_logic;
		 cero_1 : in std_logic;
		 cero2_1 : in std_logic;
		 dato_cero_1 : in std_logic;
		 dato_cero2_1 : in std_logic;
		 dato_addr_1 : in std_logic;
		 address_1 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_1 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 dato_out_2 : in std_logic;
		 cero_2 : in std_logic;
		 cero2_2 : in std_logic;
		 dato_cero_2 : in std_logic;
		 dato_cero2_2 : in std_logic;
		 dato_addr_2 : in std_logic;
		 address_2 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_2 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 dato_out_3 : in std_logic;
		 cero_3 : in std_logic;
		 cero2_3 : in std_logic;
		 dato_cero_3 : in std_logic;
		 dato_cero2_3 : in std_logic;
		 dato_addr_3 : in std_logic;
		 address_3 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_3 : in std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 dato_out_v : out std_logic;
		 cero_v : out std_logic;
		 cero2_v : out std_logic;
		 dato_cero_v : out std_logic;
		 dato_cero2_v : out std_logic;
		 dato_addr_v : out std_logic;
		 address_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0);
		 address2_v : out std_logic_vector(log2c(number_of_inputs + 1) - 1 downto 0));
end component;
    COMPONENT GEN2
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            rst_red : IN STD_LOGIC;
            data_in : IN STD_LOGIC;
            data_zero : IN STD_LOGIC;
            count : OUT unsigned(log2c(input_sizeL2) - 1 DOWNTO 0);
            layer : OUT STD_LOGIC_VECTOR(log2c(number_of_layers2) - 1 DOWNTO 0);
            mul : OUT STD_LOGIC_VECTOR(log2c(mult2) - 1 DOWNTO 0);
            data_out1 : OUT STD_LOGIC;
            data_out2 : OUT STD_LOGIC;
            index : OUT STD_LOGIC;
            en_neuron : OUT STD_LOGIC;
            next_data_pool : OUT STD_LOGIC;
            next_pipeline_step : OUT STD_LOGIC);
    END COMPONENT;
    component VOT_GEN2
	 Port (
		 layer_1 : in std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_1 : in unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_1: in std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_1: in std_logic; 
		 dato_out2_1 : in std_logic;
		 index_1 : in std_logic;
		 en_neurona_1 : in std_logic;
		 next_dato_pool_1 : in std_logic;
		 next_pipeline_step_1 : in std_logic;
		 layer_2 : in std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_2 : in unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_2: in std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_2: in std_logic; 
		 dato_out2_2 : in std_logic;
		 index_2 : in std_logic;
		 en_neurona_2 : in std_logic;
		 next_dato_pool_2 : in std_logic;
		 next_pipeline_step_2 : in std_logic;
		 layer_3 : in std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_3 : in unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_3: in std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_3: in std_logic; 
		 dato_out2_3 : in std_logic;
		 index_3 : in std_logic;
		 en_neurona_3 : in std_logic;
		 next_dato_pool_3 : in std_logic;
		 next_pipeline_step_3 : in std_logic;
		 layer_v : out std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
		 count_v : out unsigned( log2c(input_sizeL2)-1 downto 0);
		 mul_v: out std_logic_vector(log2c(mult2) - 1 downto 0);
		 dato_out1_v: out std_logic; 
		 dato_out2_v : out std_logic;
		 index_v : out std_logic;
		 en_neurona_v : out std_logic;
		 next_dato_pool_v : out std_logic;
		 next_pipeline_step_v : out std_logic);
end component;
    COMPONENT INTERFAZ_ET2 IS
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
    END COMPONENT;
    component VOT_INTERFAZ_ET2
	 Port ( 
		 dato_out_1 : in std_logic;
		 cero_1 : in std_logic;
		 dato_cero_1 : in std_logic;
		 padding_col2_1 : in std_logic;
		 padding_row2_1 : in std_logic;
		 col2_1 : in unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0);
		 p_row2_1: in unsigned( log2c(conv2_padding) downto 0); 
		 p_col2_1 : in unsigned( log2c(conv2_padding) downto 0);  
		 conv2_col_1 : in unsigned(log2c(conv2_column) - 1 downto 0);
		 conv2_fila_1 : in  unsigned(log2c(conv2_row) - 1 downto 0);
		 pool3_col_1 : in unsigned(log2c(pool3_column) - 1 downto 0);
		 pool3_fila_1 : in  unsigned(log2c(pool3_row) - 1 downto 0);
		 dato_out_2 : in std_logic;
		 cero_2 : in std_logic;
		 dato_cero_2 : in std_logic;
		 padding_col2_2 : in std_logic;
		 padding_row2_2 : in std_logic;
		 col2_2 : in unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0);
		 p_row2_2: in unsigned( log2c(conv2_padding) downto 0); 
		 p_col2_2 : in unsigned( log2c(conv2_padding) downto 0);  
		 conv2_col_2 : in unsigned(log2c(conv2_column) - 1 downto 0);
		 conv2_fila_2 : in  unsigned(log2c(conv2_row) - 1 downto 0);
		 pool3_col_2 : in unsigned(log2c(pool3_column) - 1 downto 0);
		 pool3_fila_2 : in  unsigned(log2c(pool3_row) - 1 downto 0);
		 dato_out_3 : in std_logic;
		 cero_3 : in std_logic;
		 dato_cero_3 : in std_logic;
		 padding_col2_3 : in std_logic;
		 padding_row2_3 : in std_logic;
		 col2_3 : in unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0);
		 p_row2_3: in unsigned( log2c(conv2_padding) downto 0); 
		 p_col2_3 : in unsigned( log2c(conv2_padding) downto 0);  
		 conv2_col_3 : in unsigned(log2c(conv2_column) - 1 downto 0);
		 conv2_fila_3 : in  unsigned(log2c(conv2_row) - 1 downto 0);
		 pool3_col_3 : in unsigned(log2c(pool3_column) - 1 downto 0);
		 pool3_fila_3 : in  unsigned(log2c(pool3_row) - 1 downto 0);
		 dato_out_v : out std_logic;
		 cero_v : out std_logic;
		 dato_cero_v : out std_logic;
		 padding_col2_v : out std_logic;
		 padding_row2_v : out std_logic;
		 col2_v : out unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0);
		 p_row2_v: out unsigned( log2c(conv2_padding) downto 0); 
		 p_col2_v : out unsigned( log2c(conv2_padding) downto 0);  
		 conv2_col_v : out unsigned(log2c(conv2_column) - 1 downto 0);
		 conv2_fila_v : out  unsigned(log2c(conv2_row) - 1 downto 0);
		 pool3_col_v : out unsigned(log2c(pool3_column) - 1 downto 0);
		 pool3_fila_v : out  unsigned(log2c(pool3_row) - 1 downto 0));
end component;
    COMPONENT MUX_2
        PORT (
            data_in0 : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
            data_in1 : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
            data_in3 : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
            data_in4 : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
            data_in5 : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
            index : IN STD_LOGIC_VECTOR(log2c(number_of_layers2) - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
    END COMPONENT;
    component VOT_MUX_2
	 Port( 
		 data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0); 
		 data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0); 
		 data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0); 
		 data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits -1  downto 0));
end component;
    --Layer 3
    COMPONENT GEN3
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            rst_red : IN STD_LOGIC;
            data_in_fc : IN STD_LOGIC;
            data_in_cnn : IN STD_LOGIC;
            data_new : OUT STD_LOGIC;
            layer : OUT STD_LOGIC_VECTOR(log2c(number_of_layers3) - 1 DOWNTO 0);
            index : OUT STD_LOGIC;
            next_data_pool : OUT STD_LOGIC);
    END COMPONENT;
    component VOT_GEN3
	 Port (
		 dato_new_1 : in std_logic;
 		 layer_1 : in std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_1 : in std_logic;
		 next_dato_pool_1 : in std_logic;
		 dato_new_2 : in std_logic;
 		 layer_2 : in std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_2 : in std_logic;
		 next_dato_pool_2 : in std_logic;
		 dato_new_3 : in std_logic;
 		 layer_3 : in std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_3 : in std_logic;
		 next_dato_pool_3 : in std_logic;
		 dato_new_v : out std_logic;
 		 layer_v : out std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
		 index_v : out std_logic;
		 next_dato_pool_v : out std_logic);
end component;
    COMPONENT MUX_3
        PORT (
            data_in0 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in1 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in3 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in4 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in5 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in6 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in7 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in8 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in9 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in10 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in11 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in12 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in13 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in14 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            data_in15 : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
            index : IN STD_LOGIC_VECTOR(log2c(number_of_layers3) - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
    END COMPONENT;
    component VOT_MUX_3
	 Port( 
		 data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits -1  downto 0); 
		 data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits -1  downto 0); 
		 data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits -1  downto 0); 
		 data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits -1  downto 0));
end component;
    ----------NEURONS----------------
    ----------PARALLEL NEURONS LAYER 1----------------
--    COMPONENT CONVP11
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            weight : IN signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONVP12
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            weight : IN signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONVP13
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            weight : IN signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONVP14
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            weight : IN signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONVP15
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            weight : IN signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONVP16
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            weight : IN signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
component CONVP11
Port ( data_in : in std_logic;
	     clk : in std_logic;
	     rst : in std_logic;
	     next_pipeline_step : in std_logic;
 	     weight : in signed(weight_sizeL1 - 1 downto 0); 
	     bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
	     data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONVP11
Port ( 
	     data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONVP12
Port ( data_in : in std_logic;
	     clk : in std_logic;
	     rst : in std_logic;
	     next_pipeline_step : in std_logic;
 	     weight : in signed(weight_sizeL1 - 1 downto 0); 
	     bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
	     data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONVP12
Port ( 
	     data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONVP13
Port ( data_in : in std_logic;
	     clk : in std_logic;
	     rst : in std_logic;
	     next_pipeline_step : in std_logic;
 	     weight : in signed(weight_sizeL1 - 1 downto 0); 
	     bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
	     data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONVP13
Port ( 
	     data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONVP14
Port ( data_in : in std_logic;
	     clk : in std_logic;
	     rst : in std_logic;
	     next_pipeline_step : in std_logic;
 	     weight : in signed(weight_sizeL1 - 1 downto 0); 
	     bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
	     data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONVP14
Port ( 
	     data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONVP15
Port ( data_in : in std_logic;
	     clk : in std_logic;
	     rst : in std_logic;
	     next_pipeline_step : in std_logic;
 	     weight : in signed(weight_sizeL1 - 1 downto 0); 
	     bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
	     data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONVP15
Port ( 
	     data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONVP16
Port ( data_in : in std_logic;
	     clk : in std_logic;
	     rst : in std_logic;
	     next_pipeline_step : in std_logic;
 	     weight : in signed(weight_sizeL1 - 1 downto 0); 
	     bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
	     data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONVP16
Port ( 
	     data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
	     data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
    ----------NEURONS LAYER 1----------------
--    COMPONENT CONV11
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult1)))) - 1 DOWNTO 0);
--            weight_out : OUT signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV12
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult1)))) - 1 DOWNTO 0);
--            weight_out : OUT signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV13
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult1)))) - 1 DOWNTO 0);
--            weight_out : OUT signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV14
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult1)))) - 1 DOWNTO 0);
--            weight_out : OUT signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV15
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult1)))) - 1 DOWNTO 0);
--            weight_out : OUT signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV16
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult1)))) - 1 DOWNTO 0);
--            weight_out : OUT signed(weight_sizeL1 - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL1) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT; 
    component CONV11
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);
 		    weight_out : out signed(weight_sizeL1 - 1 downto 0); 
		    bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV11 is
	 Port (
 		    weight_out_1 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_2 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_3 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_v : out signed(weight_sizeL1 - 1 downto 0); 
		    data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONV12
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);
 		    weight_out : out signed(weight_sizeL1 - 1 downto 0); 
		    bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV12 is
	 Port (
 		    weight_out_1 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_2 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_3 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_v : out signed(weight_sizeL1 - 1 downto 0); 
		    data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONV13
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);
 		    weight_out : out signed(weight_sizeL1 - 1 downto 0); 
		    bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV13 is
	 Port (
 		    weight_out_1 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_2 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_3 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_v : out signed(weight_sizeL1 - 1 downto 0); 
		    data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONV14
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);
 		    weight_out : out signed(weight_sizeL1 - 1 downto 0); 
		    bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV14 is
	 Port (
 		    weight_out_1 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_2 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_3 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_v : out signed(weight_sizeL1 - 1 downto 0); 
		    data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONV15
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);
 		    weight_out : out signed(weight_sizeL1 - 1 downto 0); 
		    bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV15 is
	 Port (
 		    weight_out_1 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_2 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_3 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_v : out signed(weight_sizeL1 - 1 downto 0); 
		    data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component CONV16
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult1))))  - 1 downto 0);
 		    weight_out : out signed(weight_sizeL1 - 1 downto 0); 
		    bit_select : in unsigned (log2c(input_sizeL1)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV16 is
	 Port (
 		    weight_out_1 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_2 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_3 : in signed(weight_sizeL1 - 1 downto 0); 
 		    weight_out_v : out signed(weight_sizeL1 - 1 downto 0); 
		    data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
    ----------ReLUs----------------

--    COMPONENT RELUL1
--        PORT (
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            index : IN STD_LOGIC;
--            data_in : IN STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT; 
    component RELUL1
	 Port (clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    index : in std_logic;
		    data_in : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
component VOT_RELUL1 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0));
end component;
    ----------NEURONS LAYER 2----------------
--    COMPONENT CONV21
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV22
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV23
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV24
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV25
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV26
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV27
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV28
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV29
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV210
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV211
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV212
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV213
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV214
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV215
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
--    COMPONENT CONV216
--        PORT (
--            data_in : IN STD_LOGIC;
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            address : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(mult2)))) + INTEGER(ceil(log2(real(number_of_layers2)))) - 1 DOWNTO 0);
--            bit_select : IN unsigned (log2c(input_sizeL2) - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT; 
    component CONV21
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV21 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV22
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV22 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV23
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV23 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV24
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV24 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV25
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV25 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV26
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV26 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV27
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV27 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV28
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV28 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV29
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV29 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV210
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV210 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV211
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV211 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV212
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV212 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV213
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV213 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV214
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV214 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV215
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV215 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component CONV216
	 Port (data_in : in std_logic;
		    clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    address : in std_logic_vector(integer(ceil(log2(real(mult2))))  + integer(ceil(log2(real(number_of_layers2))))  - 1 downto 0);
		    bit_select : in unsigned (log2c(input_sizeL2)-1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_CONV216 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
----------ReLUs----------------

component RELUL2
	 Port (clk : in std_logic;
		    rst : in std_logic;
		    next_pipeline_step : in std_logic;
		    index : in std_logic;
		    data_in : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
component VOT_RELUL2 is
	 Port (
		    data_out_1 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_2 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_3 : in std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
		    data_out_v : out std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0));
end component;
    ----------ReLUs----------------

--    COMPONENT RELUL2
--        PORT (
--            clk : IN STD_LOGIC;
--            rst : IN STD_LOGIC;
--            next_pipeline_step : IN STD_LOGIC;
--            index : IN STD_LOGIC;
--            data_in : IN STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
--            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0));
--    END COMPONENT;
    
    COMPONENT sigmoid_L2 IS
        PORT (
            data_in : IN STD_LOGIC_VECTOR(input_sizeL2 - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_sizeL2 - 1 DOWNTO 0));
    END COMPONENT;
    component VOT_sigmoid_L2 is
	Port ( 
		data_out_1 : in std_logic_vector(input_sizeL2-1 downto 0);
		data_out_2 : in std_logic_vector(input_sizeL2-1 downto 0);
		data_out_3 : in std_logic_vector(input_sizeL2-1 downto 0);
		data_out_v : out std_logic_vector(input_sizeL2-1 downto 0));
end component;
    COMPONENT sigmoid_L3 IS
        PORT (
            data_in : IN STD_LOGIC_VECTOR(input_sizeL3 - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(input_sizeL3 - 1 DOWNTO 0));
    END COMPONENT;
    component VOT_sigmoid_L3 is
	Port ( 
		data_out_1 : in std_logic_vector(input_sizeL3-1 downto 0);
		data_out_2 : in std_logic_vector(input_sizeL3-1 downto 0);
		data_out_3 : in std_logic_vector(input_sizeL3-1 downto 0);
		data_out_v : out std_logic_vector(input_sizeL3-1 downto 0));
end component;
--    --------------AUXILIARY SIGNALS-------------------
--    --INPUT MEMORY
--    SIGNAL address_in : vector_address(0 TO parallel_data - 1);
--    --LAYER 1
--    SIGNAL data_in_1, data_processed1, data_in_gen1, next_pipeline_step1, next_pipeline_step_aux1, zero1, zero1_2, data_new2, data_new_et2, data_zero1, data_zero21, data_addr, en_neuronL1, data_par2serL1_1, data_par2serL1_2 : STD_LOGIC;
--    SIGNAL count1 : unsigned(log2c(input_sizeL1) - 1 DOWNTO 0);
--    SIGNAL mul1 : STD_LOGIC_VECTOR(log2c(mult1) - 1 DOWNTO 0);
--    SIGNAL conv2_col : unsigned(log2c(conv2_column) - 1 DOWNTO 0);
--    SIGNAL conv2_fila : unsigned(log2c(conv2_row) - 1 DOWNTO 0);
--    SIGNAL pool3_col : unsigned(log2c(pool3_column) - 1 DOWNTO 0);
--    SIGNAL pool3_fila : unsigned(log2c(pool3_row) - 1 DOWNTO 0);
--    SIGNAL p_col2 : unsigned(log2c(conv2_padding) DOWNTO 0);
--    SIGNAL p_row2 : unsigned(log2c(conv2_padding) DOWNTO 0);
--    SIGNAL padding_col2, padding_row2, index2 : STD_LOGIC;
--    SIGNAL col2 : unsigned(log2c(column_size2 + 2 * (conv2_padding)) - 1 DOWNTO 0);
--    SIGNAL data_in_layer1 : vector_data_in(0 TO parallel_data - 1);
--    SIGNAL data_in1, data_in21 : STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
--    SIGNAL data_in_filter1, data_in_filter21 : STD_LOGIC;
--    SIGNAL data_in_relu11, data_in_relu12, data_in_relu13, data_in_relu14, data_in_relu15, data_in_relu16 : STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_out_relu11, data_out_relu12, data_out_relu13, data_out_relu14, data_out_relu15, data_out_relu16 : STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_in_relu2_1, data_in_relu2_2, data_in_relu2_3, data_in_relu2_4, data_in_relu2_5, data_in_relu2_6 : STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_out_relu2_1, data_out_relu2_2, data_out_relu2_3, data_out_relu2_4, data_out_relu2_5, data_out_relu2_6 : STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL weight_aux1, weight_aux2, weight_aux3, weight_aux4, weight_aux5, weight_aux6 : signed(weight_sizeL1 - 1 DOWNTO 0);
--    SIGNAL data_max_L1, data_min_L1 : signed(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    --LAYER 2
--    SIGNAL next_pipeline_step_aux2, data_in_2, data_processed2, dato_in_gen2, next_pipeline_step2, zero2, en_neuronL2, next_data_pool2, data_zero2, data_new3, data_new_et3, data_par2serL2 : STD_LOGIC;
--    SIGNAL count2 : unsigned(log2c(input_sizeL2) - 1 DOWNTO 0);
--    SIGNAL mul2 : STD_LOGIC_VECTOR(log2c(mult2) - 1 DOWNTO 0);
--    SIGNAL layer2 : STD_LOGIC_VECTOR(log2c(number_of_layers2) - 1 DOWNTO 0);
--    SIGNAL data_in_pool2, data_out_pool2 : STD_LOGIC_VECTOR (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_pool2, data_act_L2, data_in_layer2 : STD_LOGIC_VECTOR(input_sizeL2 - 1 DOWNTO 0);
--    SIGNAL address_2 : STD_LOGIC_VECTOR (log2c(mult2) + log2c(number_of_layers2) - 1 DOWNTO 0);
--    SIGNAL data_in_filter2, data_out_par2ser2 : STD_LOGIC;
--    SIGNAL data_in_pool2_2 : STD_LOGIC_VECTOR (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_in_relu21, data_in_relu22, data_in_relu23, data_in_relu24, data_in_relu25, data_in_relu26, data_in_relu27, data_in_relu28, data_in_relu29, data_in_relu210, data_in_relu211, data_in_relu212, data_in_relu213, data_in_relu214, data_in_relu215, data_in_relu216 : STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_out_relu21, data_out_relu22, data_out_relu23, data_out_relu24, data_out_relu25, data_out_relu26, data_out_relu27, data_out_relu28, data_out_relu29, data_out_relu210, data_out_relu211, data_out_relu212, data_out_relu213, data_out_relu214, data_out_relu215, data_out_relu216 : STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_max_L2, data_min_L2 : signed(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_in_act2_1, data_in_act2_2, data_act_L2_1, data_act_L2_2 : STD_LOGIC_VECTOR(input_sizeL2 - 1 DOWNTO 0);
--    --LAYER3
--    SIGNAL index3, next_data_pool3, data_processed3 : STD_LOGIC;
--    SIGNAL layer3 : STD_LOGIC_VECTOR(log2c(number_of_layers3) - 1 DOWNTO 0);
--    SIGNAL data_in_pool3, data_out_pool3 : STD_LOGIC_VECTOR (input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);
--    SIGNAL data_in_act3, data_act_L3, data_pool3 : STD_LOGIC_VECTOR (input_size_L1fc - 1 DOWNTO 0);
    --------------AUXILIARY SIGNALS-------------------
--INPUT MEMORY
signal address_in_1 :  vector_address(0 to parallel_data - 1);
signal address_in_2 :  vector_address(0 to parallel_data - 1);
signal address_in_3 :  vector_address(0 to parallel_data - 1);
signal address_in :  vector_address(0 to parallel_data - 1);
--LAYER 1
signal data_in_1, data_processed1, data_in_gen1, next_pipeline_step1, next_pipeline_step_aux1, zero1,zero1_2, data_new2, data_new_et2, data_zero1, data_zero21, data_addr, en_neuronL1, data_par2serL1_1, data_par2serL1_2: std_logic;
signal count1 : unsigned(log2c(input_sizeL1) - 1 downto 0 );
signal mul1 : std_logic_vector(log2c(mult1) - 1 downto 0);
signal  data_processed1_1, data_in_gen1_1, next_pipeline_step_aux1_1, zero111_1,zero1_2_1, data_new2_1, data_new_et2_1, data_zero1_1, data_zero21_1, data_addr_1, en_neuronL1_1, data_par2serL1_1_1, data_par2serL1_2_1: std_logic;
signal count1_1 : unsigned(log2c(input_sizeL1) - 1 downto 0 );
signal mul1_1 : std_logic_vector(log2c(mult1) - 1 downto 0);
signal  data_processed1_2, data_in_gen1_2, next_pipeline_step_aux1_2, zero111_2,zero1_2_2, data_new2_2, data_new_et2_2, data_zero1_2, data_zero21_2, data_addr_2, en_neuronL1_2, data_par2serL1_1_2, data_par2serL1_2_2: std_logic;
signal count1_2 : unsigned(log2c(input_sizeL1) - 1 downto 0 );
signal mul1_2 : std_logic_vector(log2c(mult1) - 1 downto 0);
signal  data_processed1_3, data_in_gen1_3, next_pipeline_step_aux1_3, zero111_3,zero1_2_3, data_new2_3, data_new_et2_3, data_zero1_3, data_zero21_3, data_addr_3, en_neuronL1_3, data_par2serL1_1_3, data_par2serL1_2_3: std_logic;
signal count1_3 : unsigned(log2c(input_sizeL1) - 1 downto 0 );
signal mul1_3 : std_logic_vector(log2c(mult1) - 1 downto 0);
signal conv2_col_1 : unsigned(log2c(conv2_column) - 1 downto 0);
signal conv2_fila_1 : unsigned(log2c(conv2_row) - 1 downto 0);
signal pool3_col_1 : unsigned(log2c(pool3_column) - 1 downto 0);
signal pool3_fila_1 : unsigned(log2c(pool3_row) - 1 downto 0);
signal p_col2_1 : unsigned( log2c(conv2_padding) downto 0); 
signal p_row2_1 : unsigned( log2c(conv2_padding) downto 0); 
signal padding_col2_1, padding_row2_1, index2_1 : std_logic; 
signal col2_1 :  unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0); 
signal conv2_col_2 : unsigned(log2c(conv2_column) - 1 downto 0);
signal conv2_fila_2 : unsigned(log2c(conv2_row) - 1 downto 0);
signal pool3_col_2 : unsigned(log2c(pool3_column) - 1 downto 0);
signal pool3_fila_2 : unsigned(log2c(pool3_row) - 1 downto 0);
signal p_col2_2 : unsigned( log2c(conv2_padding) downto 0); 
signal p_row2_2 : unsigned( log2c(conv2_padding) downto 0); 
signal padding_col2_2, padding_row2_2, index2_2 : std_logic; 
signal col2_2 :  unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0); 
signal conv2_col_3 : unsigned(log2c(conv2_column) - 1 downto 0);
signal conv2_fila_3 : unsigned(log2c(conv2_row) - 1 downto 0);
signal pool3_col_3 : unsigned(log2c(pool3_column) - 1 downto 0);
signal pool3_fila_3 : unsigned(log2c(pool3_row) - 1 downto 0);
signal p_col2_3 : unsigned( log2c(conv2_padding) downto 0); 
signal p_row2_3 : unsigned( log2c(conv2_padding) downto 0); 
signal padding_col2_3, padding_row2_3, index2_3 : std_logic; 
signal col2_3 :  unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0); 
signal conv2_col : unsigned(log2c(conv2_column) - 1 downto 0);
signal conv2_fila : unsigned(log2c(conv2_row) - 1 downto 0);
signal pool3_col : unsigned(log2c(pool3_column) - 1 downto 0);
signal pool3_fila : unsigned(log2c(pool3_row) - 1 downto 0);
signal p_col2 : unsigned( log2c(conv2_padding) downto 0); 
signal p_row2 : unsigned( log2c(conv2_padding) downto 0); 
signal padding_col2, padding_row2, index2 : std_logic; 
signal col2 :  unsigned(log2c(column_size2 + 2*(conv2_padding)) - 1 downto 0); 
signal data_in_layer1 : vector_data_in(0 to parallel_data - 1);
signal data_in1, data_in21 : std_logic_vector(input_sizeL1 - 1 downto 0);
signal data_in_filter1, data_in_filter21 : std_logic;
signal data_in_relu11 , data_in_relu12, data_in_relu13, data_in_relu14, data_in_relu15, data_in_relu16: std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu11 , data_out_relu12, data_out_relu13, data_out_relu14, data_out_relu15, data_out_relu16: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_relu2_1 , data_in_relu2_2, data_in_relu2_3, data_in_relu2_4, data_in_relu2_5, data_in_relu2_6: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu2_1 , data_out_relu2_2, data_out_relu2_3, data_out_relu2_4, data_out_relu2_5, data_out_relu2_6: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal weight_aux1 , weight_aux2, weight_aux3, weight_aux4, weight_aux5, weight_aux6: signed(weight_sizeL1 - 1 downto 0);
signal data_in_relu11_1 , data_in_relu12_1, data_in_relu13_1, data_in_relu14_1, data_in_relu15_1, data_in_relu16_1: std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu11_1 , data_out_relu12_1, data_out_relu13_1, data_out_relu14_1, data_out_relu15_1, data_out_relu16_1: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_relu2_1_1 , data_in_relu2_2_1, data_in_relu2_3_1, data_in_relu2_4_1, data_in_relu2_5_1, data_in_relu2_6_1: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu2_1_1 , data_out_relu2_2_1, data_out_relu2_3_1, data_out_relu2_4_1, data_out_relu2_5_1, data_out_relu2_6_1: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal weight_aux1_1 , weight_aux2_1, weight_aux3_1, weight_aux4_1, weight_aux5_1, weight_aux6_1: signed(weight_sizeL1 - 1 downto 0);
signal data_in_relu11_2 , data_in_relu12_2, data_in_relu13_2, data_in_relu14_2, data_in_relu15_2, data_in_relu16_2: std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu11_2 , data_out_relu12_2, data_out_relu13_2, data_out_relu14_2, data_out_relu15_2, data_out_relu16_2: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_relu2_1_2 , data_in_relu2_2_2, data_in_relu2_3_2, data_in_relu2_4_2, data_in_relu2_5_2, data_in_relu2_6_2: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu2_1_2 , data_out_relu2_2_2, data_out_relu2_3_2, data_out_relu2_4_2, data_out_relu2_5_2, data_out_relu2_6_2: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal weight_aux1_2 , weight_aux2_2, weight_aux3_2, weight_aux4_2, weight_aux5_2, weight_aux6_2: signed(weight_sizeL1 - 1 downto 0);
signal data_in_relu11_3 , data_in_relu12_3, data_in_relu13_3, data_in_relu14_3, data_in_relu15_3, data_in_relu16_3: std_logic_vector(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu11_3 , data_out_relu12_3, data_out_relu13_3, data_out_relu14_3, data_out_relu15_3, data_out_relu16_3: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_relu2_1_3 , data_in_relu2_2_3, data_in_relu2_3_3, data_in_relu2_4_3, data_in_relu2_5_3, data_in_relu2_6_3: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_out_relu2_1_3 , data_out_relu2_2_3, data_out_relu2_3_3, data_out_relu2_4_3, data_out_relu2_5_3, data_out_relu2_6_3: STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal weight_aux1_3 , weight_aux2_3, weight_aux3_3, weight_aux4_3, weight_aux5_3, weight_aux6_3: signed(weight_sizeL1 - 1 downto 0);
signal data_max_L1, data_min_L1 : signed(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
--LAYER 2
 signal next_pipeline_step_aux2_1, data_processed2_1, zero2_1, en_neuronL2_1, next_data_pool2_1, data_zero2_1, data_new3_1, data_new_et3_1, data_par2serL2_1 : std_logic;
signal count2_1 : unsigned(log2c(input_sizeL2) - 1 downto 0 );
signal mul2_1 : std_logic_vector(log2c(mult2) - 1 downto 0);
signal layer2_1 : std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
signal data_in_pool2_11 , data_out_pool2_1: std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_pool2_1: std_logic_vector(input_sizeL2 - 1 downto 0);
 signal next_pipeline_step_aux2_2, data_processed2_2, zero2_2, en_neuronL2_2, next_data_pool2_2, data_zero2_2, data_new3_2, data_new_et3_2, data_par2serL2_2 : std_logic;
signal count2_2 : unsigned(log2c(input_sizeL2) - 1 downto 0 );
signal mul2_2 : std_logic_vector(log2c(mult2) - 1 downto 0);
signal layer2_2 : std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
signal data_in_pool2_22 , data_out_pool2_2: std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_pool2_2: std_logic_vector(input_sizeL2 - 1 downto 0);
 signal next_pipeline_step_aux2_3, data_processed2_3, zero2_3, en_neuronL2_3, next_data_pool2_3, data_zero2_3, data_new3_3, data_new_et3_3, data_par2serL2_3 : std_logic;
signal count2_3 : unsigned(log2c(input_sizeL2) - 1 downto 0 );
signal mul2_3 : std_logic_vector(log2c(mult2) - 1 downto 0);
signal layer2_3 : std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
signal data_in_pool2_33 , data_out_pool2_3: std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_pool2_3: std_logic_vector(input_sizeL2 - 1 downto 0);
 signal next_pipeline_step_aux2,data_in_2, data_processed2, dato_in_gen2, next_pipeline_step2, zero2, en_neuronL2, next_data_pool2, data_zero2, data_new3, data_new_et3, data_par2serL2 : std_logic;
signal count2 : unsigned(log2c(input_sizeL2) - 1 downto 0 );
signal mul2 : std_logic_vector(log2c(mult2) - 1 downto 0);
signal layer2 : std_logic_vector(log2c(number_of_layers2) - 1 downto 0);
signal data_in_pool2 , data_out_pool2: std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_pool2, data_in_layer2: std_logic_vector(input_sizeL2 - 1 downto 0);
signal address_2 : std_logic_vector ( log2c(mult2) + log2c(number_of_layers2) - 1 downto 0);
signal data_in_filter2, data_out_par2ser2: std_logic;
signal data_in_pool2_2:  std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_pool2_2_1:  std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_pool2_2_2:  std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_pool2_2_3:  std_logic_vector (input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_relu21 , data_in_relu21_1 , data_in_relu21_2 , data_in_relu21_3 , data_in_relu22, data_in_relu22_1, data_in_relu22_2, data_in_relu22_3, data_in_relu23, data_in_relu23_1, data_in_relu23_2, data_in_relu23_3, data_in_relu24, data_in_relu24_1, data_in_relu24_2, data_in_relu24_3, data_in_relu25, data_in_relu25_1, data_in_relu25_2, data_in_relu25_3, data_in_relu26, data_in_relu26_1, data_in_relu26_2, data_in_relu26_3, data_in_relu27, data_in_relu27_1, data_in_relu27_2, data_in_relu27_3, data_in_relu28, data_in_relu28_1, data_in_relu28_2, data_in_relu28_3, data_in_relu29, data_in_relu29_1, data_in_relu29_2, data_in_relu29_3, data_in_relu210, data_in_relu210_1, data_in_relu210_2, data_in_relu210_3, data_in_relu211, data_in_relu211_1, data_in_relu211_2, data_in_relu211_3, data_in_relu212, data_in_relu212_1, data_in_relu212_2, data_in_relu212_3, data_in_relu213, data_in_relu213_1, data_in_relu213_2, data_in_relu213_3, data_in_relu214, data_in_relu214_1, data_in_relu214_2, data_in_relu214_3, data_in_relu215, data_in_relu215_1, data_in_relu215_2, data_in_relu215_3, data_in_relu216, data_in_relu216_1, data_in_relu216_2, data_in_relu216_3: std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
signal data_out_relu21 , data_out_relu21_1 , data_out_relu21_2 , data_out_relu21_3 , data_out_relu22, data_out_relu22_1, data_out_relu22_2, data_out_relu22_3, data_out_relu23, data_out_relu23_1, data_out_relu23_2, data_out_relu23_3, data_out_relu24, data_out_relu24_1, data_out_relu24_2, data_out_relu24_3, data_out_relu25, data_out_relu25_1, data_out_relu25_2, data_out_relu25_3, data_out_relu26, data_out_relu26_1, data_out_relu26_2, data_out_relu26_3, data_out_relu27, data_out_relu27_1, data_out_relu27_2, data_out_relu27_3, data_out_relu28, data_out_relu28_1, data_out_relu28_2, data_out_relu28_3, data_out_relu29, data_out_relu29_1, data_out_relu29_2, data_out_relu29_3, data_out_relu210, data_out_relu210_1, data_out_relu210_2, data_out_relu210_3, data_out_relu211, data_out_relu211_1, data_out_relu211_2, data_out_relu211_3, data_out_relu212, data_out_relu212_1, data_out_relu212_2, data_out_relu212_3, data_out_relu213, data_out_relu213_1, data_out_relu213_2, data_out_relu213_3, data_out_relu214, data_out_relu214_1, data_out_relu214_2, data_out_relu214_3, data_out_relu215, data_out_relu215_1, data_out_relu215_2, data_out_relu215_3, data_out_relu216, data_out_relu216_1, data_out_relu216_2, data_out_relu216_3: std_logic_vector(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 downto 0);
signal data_max_L2, data_min_L2 : signed(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 downto 0);
signal data_in_act2_1, data_in_act2_2, data_act_L2_1, data_act_L2_2  : std_logic_vector(input_sizeL2 - 1 downto 0); 
signal  data_act_L2_1_1, data_act_L2_2_1  : std_logic_vector(input_sizeL2 - 1 downto 0); 
signal  data_act_L2_1_2, data_act_L2_2_2  : std_logic_vector(input_sizeL2 - 1 downto 0); 
signal  data_act_L2_1_3, data_act_L2_2_3  : std_logic_vector(input_sizeL2 - 1 downto 0); 
--LAYER3
signal index3, next_data_pool3, data_processed3 : std_logic;
signal layer3 : std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
signal data_in_pool3, data_out_pool3 : std_logic_vector (input_sizeL2 + weight_sizeL2 + n_extra_bits- 1 downto 0);
signal data_in_act3,data_act_L3, data_pool3, data_out_buff : std_logic_vector (input_size_L1fc - 1 downto 0);
signal index3_1, next_data_pool3_1, data_processed3_1 : std_logic;
signal layer3_1 : std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
signal data_in_pool3_1, data_out_pool3_1 : std_logic_vector (input_sizeL2 + weight_sizeL2 + n_extra_bits- 1 downto 0);
signal data_act_L3_1, data_pool3_1 : std_logic_vector (input_size_L1fc - 1 downto 0);
signal index3_2, next_data_pool3_2, data_processed3_2 : std_logic;
signal layer3_2 : std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
signal data_in_pool3_2, data_out_pool3_2 : std_logic_vector (input_sizeL2 + weight_sizeL2 + n_extra_bits- 1 downto 0);
signal data_act_L3_2, data_pool3_2 : std_logic_vector (input_size_L1fc - 1 downto 0);
signal index3_3, next_data_pool3_3, data_processed3_3 : std_logic;
signal layer3_3 : std_logic_vector(log2c(number_of_layers3) - 1 downto 0);
signal data_in_pool3_3, data_out_pool3_3 : std_logic_vector (input_sizeL2 + weight_sizeL2 + n_extra_bits- 1 downto 0);
signal data_act_L3_3, data_pool3_3 : std_logic_vector (input_size_L1fc - 1 downto 0);
signal data_out_1 : STD_LOGIC_VECTOR(input_size_L1fc - 1 downto 0);
signal data_out_2 : STD_LOGIC_VECTOR(input_size_L1fc - 1 downto 0);
signal data_out_3 : STD_LOGIC_VECTOR(input_size_L1fc - 1 downto 0);
BEGIN
    --INPUT MEMORY
    --Manage the retrieval of data form the memory, receives addresses from the interface of the first layer and sends data to the first set of neurons
    REG_DATOS : Reg_data
    PORT MAP(
        clk => clk,
        rst => rst,
        data_addr => data_addr,
        data_red => data_in_gen1,
        address_in => address_in,
        address_out => address,
        data_in => data_in,
        data_out => data_in_layer1
    );
    ----LAYER 1
    --We generate control signals when a new data needs to be processed in the first layer
    data_in_1 <= data_new2 OR data_processed1 OR next_pipeline_step_aux1;
--    GEN_ENABLE : GEN1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        rst_red => rst_red,
--        data_in => data_in_gen1,
--        count => count1,
--        mul => mul1,
--        en_neuron => en_neuronL1,
--        data_zero1 => data_zero1,
--        data_zero2 => data_zero21,
--        data_out1 => data_processed1,
--        data_out2 => data_new_et2,
--        next_pipeline_step => next_pipeline_step_aux1
--    );
    GEN_ENABLE_1: GEN1 
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  data_in => data_in_gen1,
  count => count1_1,
  mul => mul1_1,
  en_neuron => en_neuronL1_1,
  data_zero1 => data_zero1_1,
  data_zero2 => data_zero21_1,
  data_out1 => data_processed1_1,
  data_out2 => data_new_et2_1,
  next_pipeline_step => next_pipeline_step_aux1_1
);
GEN_ENABLE_2: GEN1 
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  data_in => data_in_gen1,
  count => count1_2,
  mul => mul1_2,
  en_neuron => en_neuronL1_2,
  data_zero1 => data_zero1_2,
  data_zero2 => data_zero21_2,
  data_out1 => data_processed1_2,
  data_out2 => data_new_et2_2,
  next_pipeline_step => next_pipeline_step_aux1_2
);
GEN_ENABLE_3: GEN1 
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  data_in => data_in_gen1,
  count => count1_3,
  mul => mul1_3,
  en_neuron => en_neuronL1_3,
  data_zero1 => data_zero1_3,
  data_zero2 => data_zero21_3,
  data_out1 => data_processed1_3,
  data_out2 => data_new_et2_3,
  next_pipeline_step => next_pipeline_step_aux1_3
);
VOTADOR_GEN1 : VOT_GEN1
   port map(
		 en_neuron_1 => en_neuronL1_1,
		 count_1 => count1_1,
		 mul_1 => mul1_1,
		 dato_out1_1 => data_processed1_1,
		 dato_out2_1 => data_new_et2_1,
		 next_pipeline_step_1 => next_pipeline_step_aux1_1,
		 en_neuron_2 => en_neuronL1_2,
		 count_2 => count1_2,
		 mul_2 => mul1_2,
		 dato_out1_2 => data_processed1_2,
		 dato_out2_2 => data_new_et2_2,
		 next_pipeline_step_2 => next_pipeline_step_aux1_2,
		 en_neuron_3 => en_neuronL1_3,
		 count_3 => count1_3,
		 mul_3 => mul1_3,
		 dato_out1_3 => data_processed1_3,
		 dato_out2_3 => data_new_et2_3,
		 next_pipeline_step_3 => next_pipeline_step_aux1_3,
		 en_neuron_v => en_neuronL1,
		 count_v => count1,
		 mul_v => mul1,
		 dato_out1_v => data_processed1, 
		 dato_out2_v => data_new_et2,
		 next_pipeline_step_v => next_pipeline_step_aux1);
    --Signal to notify the neurons that a filter sweep is completed
    next_pipeline_step1 <= next_pipeline_step_aux1 OR data_new_et2;
--    INTERFAZ_1 : INTERFAZ_ET1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        rst_red => rst_red,
--        data_in => data_in_1,
--        data_addr => data_addr,
--        address => address_in(0),
--        zero => zero1,
--        address2 => address_in(1),
--        zero2 => zero1_2,
--        data_out => data_in_gen1,
--        col2 => col2,
--        data_zero1 => data_zero1,
--        data_zero2 => data_zero21,
--        p_row2 => p_row2,
--        p_col2 => p_col2,
--        conv2_col => conv2_col,
--        conv2_fila => conv2_fila,
--        pool3_col => pool3_col,
--        pool3_fila => pool3_fila,
--        padding_col2 => padding_col2,
--        padding_row2 => padding_row2
--    );
    INTERFAZ_1_1: INTERFAZ_ET1
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  data_in => data_in_1,
  data_addr => data_addr_1,
  address => address_in_1(0),
  zero => zero111_1,
  address2 => address_in_1(1),
  zero2 => zero1_2_1,
  data_out => data_in_gen1_1,
  col2 => col2,
  data_zero1 => data_zero1_1,
  data_zero2 => data_zero21_1,
  p_row2 => p_row2, 
  p_col2 => p_col2 , 
  conv2_col => conv2_col, 
  conv2_fila => conv2_fila, 
  pool3_col => pool3_col,
  pool3_fila => pool3_fila, 
  padding_col2 => padding_col2,
   padding_row2 => padding_row2 
);
INTERFAZ_1_2: INTERFAZ_ET1
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  data_in => data_in_1,
  data_addr => data_addr_2,
  address => address_in_2(0),
  zero => zero111_2,
  address2 => address_in_2(1),
  zero2 => zero1_2_2,
  data_out => data_in_gen1_2,
  col2 => col2,
  data_zero1 => data_zero1_2,
  data_zero2 => data_zero21_2,
  p_row2 => p_row2, 
  p_col2 => p_col2 , 
  conv2_col => conv2_col, 
  conv2_fila => conv2_fila, 
  pool3_col => pool3_col,
  pool3_fila => pool3_fila, 
  padding_col2 => padding_col2,
   padding_row2 => padding_row2 
);
INTERFAZ_1_3: INTERFAZ_ET1
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  data_in => data_in_1,
  data_addr => data_addr_3,
  address => address_in_3(0),
  zero => zero111_3,
  address2 => address_in_3(1),
  zero2 => zero1_2_3,
  data_out => data_in_gen1_3,
  col2 => col2,
  data_zero1 => data_zero1_3,
  data_zero2 => data_zero21_3,
  p_row2 => p_row2, 
  p_col2 => p_col2 , 
  conv2_col => conv2_col, 
  conv2_fila => conv2_fila, 
  pool3_col => pool3_col,
  pool3_fila => pool3_fila, 
  padding_col2 => padding_col2,
   padding_row2 => padding_row2 
);
VOTADOR_INTERFAZ1 : VOT_INTERFAZ_ET1
   port map(
		 dato_out_1 => data_in_gen1_1,
		 cero_1 => zero111_1,
		 cero2_1 => zero1_2_1,
		 dato_cero_1 => data_zero1_1,
		 dato_cero2_1 => data_zero21_1,
		 dato_addr_1 => data_addr_1,
		 address_1 => address_in_1(0),
		 address2_1 => address_in_1(1),
		 dato_out_2 => data_in_gen1_2,
		 cero_2 => zero111_2,
		 cero2_2 => zero1_2_2,
		 dato_cero_2 => data_zero1_2,
		 dato_cero2_2 => data_zero21_2,
		 dato_addr_2 => data_addr_2,
		 address_2 => address_in_2(0),
		 address2_2 => address_in_2(1),
		 dato_out_3 => data_in_gen1_3,
		 cero_3 => zero111_3,
		 cero2_3 => zero1_2_3,
		 dato_cero_3 => data_zero1_3,
		 dato_cero2_3 => data_zero21_3,
		 dato_addr_3 => data_addr_3,
		 address_3 => address_in_3(0),
		 address2_3 => address_in_3(1),
		 dato_out_v => data_in_gen1,
		 cero_v => zero1,
		 cero2_v => zero1_2,
		 dato_cero_v => data_zero1,
		 dato_cero2_v => data_zero21,
		 dato_addr_v => data_addr,
		 address_v => address_in(0),
		 address2_v => address_in(1));
		 
    --Data to be processed by the first layer of the network coming from the memory, if we are in the padding zone of the inpit matrix we send directly a zero
    data_in1 <= data_in_layer1(0) WHEN (zero1 = '0') ELSE
        (OTHERS => '0');
    data_in21 <= data_in_layer1(1) WHEN (zero1_2 = '0') ELSE
        (OTHERS => '0');

    --Converts the input from parallel to serial
--    CONVERTERL1 : PAR2SER
--    GENERIC MAP(input_size => input_sizeL1)
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        en_neuron => en_neuronL1,
--        data_in => data_in1,
--        bit_select => count1,
--        bit_out => data_par2serL1_1
--    );
--    CONVERTERL1_2 : PAR2SER
--    GENERIC MAP(input_size => input_sizeL1)
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        en_neuron => en_neuronL1,
--        data_in => data_in21,
--        bit_select => count1,
--        bit_out => data_par2serL1_2
--    );
CONVERTERL1_1 : PAR2SER
generic map (input_size => input_sizeL1)
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL1,
  data_in => data_in1,
  bit_select => count1,
  bit_out => data_par2serL1_1_1);
CONVERTERL1_2 : PAR2SER
generic map (input_size => input_sizeL1)
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL1,
  data_in => data_in1,
  bit_select => count1,
  bit_out => data_par2serL1_1_2);
CONVERTERL1_3 : PAR2SER
generic map (input_size => input_sizeL1)
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL1,
  data_in => data_in1,
  bit_select => count1,
  bit_out => data_par2serL1_1_3);
VOTADOR_PAR2SERL1 : VOT_PAR2SER
   port map(
		 serial_out_1 => data_par2serL1_1_1,
		 serial_out_2 => data_par2serL1_1_2,
		 serial_out_3 => data_par2serL1_1_3,
		 serial_out_v => data_par2serL1_1);
CONVERTERL1_2_1 : PAR2SER
generic map (input_size => input_sizeL1)
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL1,
  data_in => data_in21,
  bit_select => count1,
  bit_out => data_par2serL1_2_1
);
CONVERTERL1_2_2 : PAR2SER
generic map (input_size => input_sizeL1)
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL1,
  data_in => data_in21,
  bit_select => count1,
  bit_out => data_par2serL1_2_2
);
CONVERTERL1_2_3 : PAR2SER
generic map (input_size => input_sizeL1)
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL1,
  data_in => data_in21,
  bit_select => count1,
  bit_out => data_par2serL1_2_3
);
VOTADOR_PAR2SERL1_2 : VOT_PAR2SER
   port map(
		 serial_out_1 => data_par2serL1_2_1,
		 serial_out_2 => data_par2serL1_2_2,
		 serial_out_3 => data_par2serL1_2_3,
		 serial_out_v => data_par2serL1_2);
		 
    --Data sent to the neurons, we only send it when the neurons can process it (enable neuron = 1)
    data_in_filter1 <= data_par2serL1_1 WHEN (en_neuronL1 = '1') ELSE
        '0';
    data_in_filter21 <= data_par2serL1_2 WHEN (en_neuronL1 = '1') ELSE
        '0';
      CONV1_1_1 : CONV11
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux1_1,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu11_1);
CONV1_1_2 : CONV11
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux1_2,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu11_2);
CONV1_1_3 : CONV11
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux1_3,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu11_3);
VOTADOR_CONV1_1 : VOT_CONV11
   port map(
 		    weight_out_1 => weight_aux1_1, 
 		    weight_out_2 => weight_aux1_2, 
 		    weight_out_3 => weight_aux1_3, 
 		    weight_out_v => weight_aux1, 
		    data_out_1 => data_in_relu11_1,
		    data_out_2 => data_in_relu11_2,
		    data_out_3 => data_in_relu11_3,
		    data_out_v => data_in_relu11);
RELU1_1_1 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu11,
    index => index2,
    data_out => data_out_relu11_1);  
RELU1_1_2 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu11,
    index => index2,
    data_out => data_out_relu11_2);  
RELU1_1_3 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu11,
    index => index2,
    data_out => data_out_relu11_3);  
VOTADOR_RELU1_1 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu11_1,
		    data_out_2 => data_out_relu11_2,
		    data_out_3 => data_out_relu11_3,
		    data_out_v => data_out_relu11);
CONV1_2_1 : CONV12
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux2_1,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu12_1);
CONV1_2_2 : CONV12
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux2_2,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu12_2);
CONV1_2_3 : CONV12
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux2_3,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu12_3);
VOTADOR_CONV1_2 : VOT_CONV12
   port map(
 		    weight_out_1 => weight_aux2_1, 
 		    weight_out_2 => weight_aux2_2, 
 		    weight_out_3 => weight_aux2_3, 
 		    weight_out_v => weight_aux2, 
		    data_out_1 => data_in_relu12_1,
		    data_out_2 => data_in_relu12_2,
		    data_out_3 => data_in_relu12_3,
		    data_out_v => data_in_relu12);
RELU1_2_1 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu12,
    index => index2,
    data_out => data_out_relu12_1);  
RELU1_2_2 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu12,
    index => index2,
    data_out => data_out_relu12_2);  
RELU1_2_3 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu12,
    index => index2,
    data_out => data_out_relu12_3);  
VOTADOR_RELU1_2 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu12_1,
		    data_out_2 => data_out_relu12_2,
		    data_out_3 => data_out_relu12_3,
		    data_out_v => data_out_relu12);
CONV1_3_1 : CONV13
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux3_1,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu13_1);
CONV1_3_2 : CONV13
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux3_2,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu13_2);
CONV1_3_3 : CONV13
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux3_3,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu13_3);
VOTADOR_CONV1_3 : VOT_CONV13
   port map(
 		    weight_out_1 => weight_aux3_1, 
 		    weight_out_2 => weight_aux3_2, 
 		    weight_out_3 => weight_aux3_3, 
 		    weight_out_v => weight_aux3, 
		    data_out_1 => data_in_relu13_1,
		    data_out_2 => data_in_relu13_2,
		    data_out_3 => data_in_relu13_3,
		    data_out_v => data_in_relu13);
RELU1_3_1 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu13,
    index => index2,
    data_out => data_out_relu13_1);  
RELU1_3_2 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu13,
    index => index2,
    data_out => data_out_relu13_2);  
RELU1_3_3 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu13,
    index => index2,
    data_out => data_out_relu13_3);  
VOTADOR_RELU1_3 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu13_1,
		    data_out_2 => data_out_relu13_2,
		    data_out_3 => data_out_relu13_3,
		    data_out_v => data_out_relu13);
CONV1_4_1 : CONV14
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux4_1,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu14_1);
CONV1_4_2 : CONV14
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux4_2,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu14_2);
CONV1_4_3 : CONV14
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux4_3,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu14_3);
VOTADOR_CONV1_4 : VOT_CONV14
   port map(
 		    weight_out_1 => weight_aux4_1, 
 		    weight_out_2 => weight_aux4_2, 
 		    weight_out_3 => weight_aux4_3, 
 		    weight_out_v => weight_aux4, 
		    data_out_1 => data_in_relu14_1,
		    data_out_2 => data_in_relu14_2,
		    data_out_3 => data_in_relu14_3,
		    data_out_v => data_in_relu14);
RELU1_4_1 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu14,
    index => index2,
    data_out => data_out_relu14_1);  
RELU1_4_2 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu14,
    index => index2,
    data_out => data_out_relu14_2);  
RELU1_4_3 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu14,
    index => index2,
    data_out => data_out_relu14_3);  
VOTADOR_RELU1_4 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu14_1,
		    data_out_2 => data_out_relu14_2,
		    data_out_3 => data_out_relu14_3,
		    data_out_v => data_out_relu14);
CONV1_5_1 : CONV15
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux5_1,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu15_1);
CONV1_5_2 : CONV15
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux5_2,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu15_2);
CONV1_5_3 : CONV15
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux5_3,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu15_3);
VOTADOR_CONV1_5 : VOT_CONV15
   port map(
 		    weight_out_1 => weight_aux5_1, 
 		    weight_out_2 => weight_aux5_2, 
 		    weight_out_3 => weight_aux5_3, 
 		    weight_out_v => weight_aux5, 
		    data_out_1 => data_in_relu15_1,
		    data_out_2 => data_in_relu15_2,
		    data_out_3 => data_in_relu15_3,
		    data_out_v => data_in_relu15);
RELU1_5_1 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu15,
    index => index2,
    data_out => data_out_relu15_1);  
RELU1_5_2 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu15,
    index => index2,
    data_out => data_out_relu15_2);  
RELU1_5_3 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu15,
    index => index2,
    data_out => data_out_relu15_3);  
VOTADOR_RELU1_5 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu15_1,
		    data_out_2 => data_out_relu15_2,
		    data_out_3 => data_out_relu15_3,
		    data_out_v => data_out_relu15);
CONV1_6_1 : CONV16
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux6_1,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu16_1);
CONV1_6_2 : CONV16
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux6_2,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu16_2);
CONV1_6_3 : CONV16
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter1,
    weight_out => weight_aux6_3,
    address => mul1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu16_3);
VOTADOR_CONV1_6 : VOT_CONV16
   port map(
 		    weight_out_1 => weight_aux6_1, 
 		    weight_out_2 => weight_aux6_2, 
 		    weight_out_3 => weight_aux6_3, 
 		    weight_out_v => weight_aux6, 
		    data_out_1 => data_in_relu16_1,
		    data_out_2 => data_in_relu16_2,
		    data_out_3 => data_in_relu16_3,
		    data_out_v => data_in_relu16);
RELU1_6_1 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu16,
    index => index2,
    data_out => data_out_relu16_1);  
RELU1_6_2 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu16,
    index => index2,
    data_out => data_out_relu16_2);  
RELU1_6_3 : RELUL1
port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu16,
    index => index2,
    data_out => data_out_relu16_3);  
VOTADOR_RELU1_6 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu16_1,
		    data_out_2 => data_out_relu16_2,
		    data_out_3 => data_out_relu16_3,
		    data_out_v => data_out_relu16);
CONVP1_1_1 : CONVP11
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_1_1);
CONVP1_1_2 : CONVP11
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_1_2);
CONVP1_1_3 : CONVP11
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux1,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_1_3);
VOTADOR_CONVP1_1 : VOT_CONVP11
   port map(
	     data_out_1 => data_in_relu2_1_1,
	     data_out_2 => data_in_relu2_1_2,
	     data_out_3 => data_in_relu2_1_3,
	     data_out_v => data_in_relu2_1);
RELUP11_1 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_1,
    index => index2,
    data_out => data_out_relu2_1_1);  
RELUP11_2 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_1,
    index => index2,
    data_out => data_out_relu2_1_2);  
RELUP11_3 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_1,
    index => index2,
    data_out => data_out_relu2_1_3);  
VOTADOR_RELUP1_1 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu2_1_1,
		    data_out_2 => data_out_relu2_1_2,
		    data_out_3 => data_out_relu2_1_3,
		    data_out_v => data_out_relu2_1);
CONVP1_2_1 : CONVP12
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux2,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_2_1);
CONVP1_2_2 : CONVP12
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux2,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_2_2);
CONVP1_2_3 : CONVP12
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux2,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_2_3);
VOTADOR_CONVP1_2 : VOT_CONVP12
   port map(
	     data_out_1 => data_in_relu2_2_1,
	     data_out_2 => data_in_relu2_2_2,
	     data_out_3 => data_in_relu2_2_3,
	     data_out_v => data_in_relu2_2);
RELUP12_1 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_2,
    index => index2,
    data_out => data_out_relu2_2_1);  
RELUP12_2 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_2,
    index => index2,
    data_out => data_out_relu2_2_2);  
RELUP12_3 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_2,
    index => index2,
    data_out => data_out_relu2_2_3);  
VOTADOR_RELUP1_2 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu2_2_1,
		    data_out_2 => data_out_relu2_2_2,
		    data_out_3 => data_out_relu2_2_3,
		    data_out_v => data_out_relu2_2);
CONVP1_3_1 : CONVP13
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux3,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_3_1);
CONVP1_3_2 : CONVP13
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux3,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_3_2);
CONVP1_3_3 : CONVP13
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux3,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_3_3);
VOTADOR_CONVP1_3 : VOT_CONVP13
   port map(
	     data_out_1 => data_in_relu2_3_1,
	     data_out_2 => data_in_relu2_3_2,
	     data_out_3 => data_in_relu2_3_3,
	     data_out_v => data_in_relu2_3);
RELUP13_1 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_3,
    index => index2,
    data_out => data_out_relu2_3_1);  
RELUP13_2 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_3,
    index => index2,
    data_out => data_out_relu2_3_2);  
RELUP13_3 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_3,
    index => index2,
    data_out => data_out_relu2_3_3);  
VOTADOR_RELUP1_3 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu2_3_1,
		    data_out_2 => data_out_relu2_3_2,
		    data_out_3 => data_out_relu2_3_3,
		    data_out_v => data_out_relu2_3);
CONVP1_4_1 : CONVP14
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux4,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_4_1);
CONVP1_4_2 : CONVP14
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux4,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_4_2);
CONVP1_4_3 : CONVP14
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux4,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_4_3);
VOTADOR_CONVP1_4 : VOT_CONVP14
   port map(
	     data_out_1 => data_in_relu2_4_1,
	     data_out_2 => data_in_relu2_4_2,
	     data_out_3 => data_in_relu2_4_3,
	     data_out_v => data_in_relu2_4);
RELUP14_1 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_4,
    index => index2,
    data_out => data_out_relu2_4_1);  
RELUP14_2 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_4,
    index => index2,
    data_out => data_out_relu2_4_2);  
RELUP14_3 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_4,
    index => index2,
    data_out => data_out_relu2_4_3);  
VOTADOR_RELUP1_4 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu2_4_1,
		    data_out_2 => data_out_relu2_4_2,
		    data_out_3 => data_out_relu2_4_3,
		    data_out_v => data_out_relu2_4);
CONVP1_5_1 : CONVP15
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux5,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_5_1);
CONVP1_5_2 : CONVP15
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux5,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_5_2);
CONVP1_5_3 : CONVP15
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux5,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_5_3);
VOTADOR_CONVP1_5 : VOT_CONVP15
   port map(
	     data_out_1 => data_in_relu2_5_1,
	     data_out_2 => data_in_relu2_5_2,
	     data_out_3 => data_in_relu2_5_3,
	     data_out_v => data_in_relu2_5);
RELUP15_1 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_5,
    index => index2,
    data_out => data_out_relu2_5_1);  
RELUP15_2 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_5,
    index => index2,
    data_out => data_out_relu2_5_2);  
RELUP15_3 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_5,
    index => index2,
    data_out => data_out_relu2_5_3);  
VOTADOR_RELUP1_5 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu2_5_1,
		    data_out_2 => data_out_relu2_5_2,
		    data_out_3 => data_out_relu2_5_3,
		    data_out_v => data_out_relu2_5);
CONVP1_6_1 : CONVP16
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux6,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_6_1);
CONVP1_6_2 : CONVP16
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux6,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_6_2);
CONVP1_6_3 : CONVP16
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter21,
    weight => weight_aux6,
    bit_select => count1,
    next_pipeline_step => next_pipeline_step1,
    data_out => data_in_relu2_6_3);
VOTADOR_CONVP1_6 : VOT_CONVP16
   port map(
	     data_out_1 => data_in_relu2_6_1,
	     data_out_2 => data_in_relu2_6_2,
	     data_out_3 => data_in_relu2_6_3,
	     data_out_v => data_in_relu2_6);
RELUP16_1 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_6,
    index => index2,
    data_out => data_out_relu2_6_1);  
RELUP16_2 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_6,
    index => index2,
    data_out => data_out_relu2_6_2);  
RELUP16_3 : RELUL1
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step1,
    data_in => data_in_relu2_6,
    index => index2,
    data_out => data_out_relu2_6_3);  
VOTADOR_RELUP1_6 : VOT_RELUL1
   port map(
		    data_out_1 => data_out_relu2_6_1,
		    data_out_2 => data_out_relu2_6_2,
		    data_out_3 => data_out_relu2_6_3,
		    data_out_v => data_out_relu2_6);
--    CONV1_1 : CONV11
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter1,
--        weight_out => weight_aux1,
--        address => mul1,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu11);
--    RELU1_1 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu11,
--        index => index2,
--        data_out => data_out_relu11);
--    CONV1_2 : CONV12
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter1,
--        weight_out => weight_aux2,
--        address => mul1,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu12);
--    RELU1_2 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu12,
--        index => index2,
--        data_out => data_out_relu12);
--    CONV1_3 : CONV13
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter1,
--        weight_out => weight_aux3,
--        address => mul1,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu13);
--    RELU1_3 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu13,
--        index => index2,
--        data_out => data_out_relu13);
--    CONV1_4 : CONV14
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter1,
--        weight_out => weight_aux4,
--        address => mul1,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu14);
--    RELU1_4 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu14,
--        index => index2,
--        data_out => data_out_relu14);
--    CONV1_5 : CONV15
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter1,
--        weight_out => weight_aux5,
--        address => mul1,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu15);
--    RELU1_5 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu15,
--        index => index2,
--        data_out => data_out_relu15);
--    CONV1_6 : CONV16
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter1,
--        weight_out => weight_aux6,
--        address => mul1,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu16);
--    RELU1_6 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu16,
--        index => index2,
--        data_out => data_out_relu16);
--    CONVP1_1 : CONVP11
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter21,
--        weight => weight_aux1,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu2_1);
--    RELUP11 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu2_1,
--        index => index2,
--        data_out => data_out_relu2_1);
--    CONVP1_2 : CONVP12
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter21,
--        weight => weight_aux2,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu2_2);
--    RELUP12 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu2_2,
--        index => index2,
--        data_out => data_out_relu2_2);
--    CONVP1_3 : CONVP13
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter21,
--        weight => weight_aux3,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu2_3);
--    RELUP13 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu2_3,
--        index => index2,
--        data_out => data_out_relu2_3);
--    CONVP1_4 : CONVP14
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter21,
--        weight => weight_aux4,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu2_4);
--    RELUP14 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu2_4,
--        index => index2,
--        data_out => data_out_relu2_4);
--    CONVP1_5 : CONVP15
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter21,
--        weight => weight_aux5,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu2_5);
--    RELUP15 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu2_5,
--        index => index2,
--        data_out => data_out_relu2_5);
--    CONVP1_6 : CONVP16
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter21,
--        weight => weight_aux6,
--        bit_select => count1,
--        next_pipeline_step => next_pipeline_step1,
--        data_out => data_in_relu2_6);
--    RELUP16 : RELUL1
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step1,
--        data_in => data_in_relu2_6,
--        index => index2,
--        data_out => data_out_relu2_6);
    
    ----LAYER 2
    --We generate control signals when a new data needs to be processed in the second layer
    data_in_2 <= start_red OR next_pipeline_step_aux2 OR data_processed2 OR data_processed3;
--    GEN_ENABLE2 : GEN2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        rst_red => rst_red,
--        layer => layer2,
--        data_in => data_new_et2,
--        count => count2,
--        mul => mul2,
--        data_zero => data_zero2,
--        en_neuron => en_neuronL2,
--        index => index2,
--        next_data_pool => next_data_pool2,
--        data_out1 => data_processed2,
--        data_out2 => data_new_et3,
--        next_pipeline_step => next_pipeline_step_aux2
--    );
    GEN_ENABLE2_1: GEN2 
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  layer => layer2_1,
  data_in => data_new_et2,
  count => count2_1,
  mul => mul2_1,
  data_zero => data_zero2,
  en_neuron => en_neuronL2_1,
  index => index2_1,
  next_data_pool => next_data_pool2_1,
  data_out1 => data_processed2_1,
  data_out2 => data_new_et3_1,
  next_pipeline_step => next_pipeline_step_aux2_1
);
GEN_ENABLE2_2: GEN2 
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  layer => layer2_2,
  data_in => data_new_et2,
  count => count2_2,
  mul => mul2_2,
  data_zero => data_zero2,
  en_neuron => en_neuronL2_2,
  index => index2_2,
  next_data_pool => next_data_pool2_2,
  data_out1 => data_processed2_2,
  data_out2 => data_new_et3_2,
  next_pipeline_step => next_pipeline_step_aux2_2
);
GEN_ENABLE2_3: GEN2 
port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  layer => layer2_3,
  data_in => data_new_et2,
  count => count2_3,
  mul => mul2_3,
  data_zero => data_zero2,
  en_neuron => en_neuronL2_3,
  index => index2_3,
  next_data_pool => next_data_pool2_3,
  data_out1 => data_processed2_3,
  data_out2 => data_new_et3_3,
  next_pipeline_step => next_pipeline_step_aux2_3
);
VOTADOR_GEN2 : VOT_GEN2
   port map(
		 layer_1 => layer2_1,
		 count_1 => count2_1,
		 mul_1 => mul2_1,
		 dato_out1_1 => data_processed2_1, 
		 dato_out2_1 => data_new_et3_1,
		 index_1 => index2_1,
		 en_neurona_1 => en_neuronL2_1,
		 next_dato_pool_1 => next_data_pool2_1,
		 next_pipeline_step_1 => next_pipeline_step_aux2_1,
		 layer_2 => layer2_2,
		 count_2 => count2_2,
		 mul_2 => mul2_2,
		 dato_out1_2 => data_processed2_2, 
		 dato_out2_2 => data_new_et3_2,
		 index_2 => index2_2,
		 en_neurona_2 => en_neuronL2_2,
		 next_dato_pool_2 => next_data_pool2_2,
		 next_pipeline_step_2 => next_pipeline_step_aux2_2,
		 layer_3 => layer2_3,
		 count_3 => count2_3,
		 mul_3 => mul2_3,
		 dato_out1_3 => data_processed2_3, 
		 dato_out2_3 => data_new_et3_3,
		 index_3 => index2_3,
		 en_neurona_3 => en_neuronL2_3,
		 next_dato_pool_3 => next_data_pool2_3,
		 next_pipeline_step_3 => next_pipeline_step_aux2_3,
		 layer_v => layer2,
		 count_v => count2,
		 mul_v => mul2,
		 dato_out1_v => data_processed2, 
		 dato_out2_v => data_new_et3,
		 index_v => index2,
		 en_neurona_v => en_neuronL2,
		 next_dato_pool_v => next_data_pool2,
		 next_pipeline_step_v => next_pipeline_step_aux2);
    --Signal to notify the neurons that a filter sweep is completed
    next_pipeline_step2 <= next_pipeline_step_aux2 OR data_new_et3;

    --For each new data processed we calculate the position of the filters;
--    INTERFAZ_2 : INTERFAZ_ET2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        rst_red => rst_red,
--        zero => zero2,
--        data_in => data_in_2,
--        data_out => data_new2,
--        data_zero => data_zero2,
--        col2 => col2,
--        padding_col2 => padding_col2,
--        padding_row2 => padding_row2,
--        p_row2 => p_row2,
--        p_col2 => p_col2,
--        conv2_col => conv2_col,
--        conv2_fila => conv2_fila,
--        pool3_col => pool3_col,
--        pool3_fila => pool3_fila);
    INTERFAZ_2_1: INTERFAZ_ET2
Port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  zero => zero2_1,
  data_in => data_in_2,
  data_out => data_new2_1,
  data_zero => data_zero2_1,
  col2 => col2_1,
  padding_col2 => padding_col2_1, 
  padding_row2 => padding_row2_1, 
  p_row2 => p_row2_1, 
  p_col2 => p_col2_1, 
  conv2_col => conv2_col_1, 
  conv2_fila => conv2_fila_1, 
  pool3_col => pool3_col_1, 
  pool3_fila => pool3_fila_1);
INTERFAZ_2_2: INTERFAZ_ET2
Port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  zero => zero2_2,
  data_in => data_in_2,
  data_out => data_new2_2,
  data_zero => data_zero2_2,
  col2 => col2_2,
  padding_col2 => padding_col2_2, 
  padding_row2 => padding_row2_2, 
  p_row2 => p_row2_2, 
  p_col2 => p_col2_2, 
  conv2_col => conv2_col_2, 
  conv2_fila => conv2_fila_2, 
  pool3_col => pool3_col_2, 
  pool3_fila => pool3_fila_2);
INTERFAZ_2_3: INTERFAZ_ET2
Port map(
  clk => clk,
  rst => rst,
  rst_red => rst_red,
  zero => zero2_3,
  data_in => data_in_2,
  data_out => data_new2_3,
  data_zero => data_zero2_3,
  col2 => col2_3,
  padding_col2 => padding_col2_3, 
  padding_row2 => padding_row2_3, 
  p_row2 => p_row2_3, 
  p_col2 => p_col2_3, 
  conv2_col => conv2_col_3, 
  conv2_fila => conv2_fila_3, 
  pool3_col => pool3_col_3, 
  pool3_fila => pool3_fila_3);
VOTADOR_INTERFAZ2 : VOT_INTERFAZ_ET2
   port map(
		 dato_out_1 => data_new2_1,
		 cero_1 => zero2_1,
		 dato_cero_1 => data_zero2_1,
		 padding_col2_1 => padding_col2_1,
		 padding_row2_1 => padding_row2_1,
		 col2_1 => col2_1,
		 p_row2_1 => p_row2_1,
		 p_col2_1 => p_col2_1,
		 conv2_col_1 => conv2_col_1,
		 conv2_fila_1 => conv2_fila_1,
		 pool3_col_1 => pool3_col_1,
		 pool3_fila_1 => pool3_fila_1,
		 dato_out_2 => data_new2_2,
		 cero_2 => zero2_2,
		 dato_cero_2 => data_zero2_2,
		 padding_col2_2 => padding_col2_2,
		 padding_row2_2 => padding_row2_2,
		 col2_2 => col2_2,
		 p_row2_2 => p_row2_2,
		 p_col2_2 => p_col2_2,
		 conv2_col_2 => conv2_col_2,
		 conv2_fila_2 => conv2_fila_2,
		 pool3_col_2 => pool3_col_2,
		 pool3_fila_2 => pool3_fila_2,
		 dato_out_3 => data_new2_3,
		 cero_3 => zero2_3,
		 dato_cero_3 => data_zero2_3,
		 padding_col2_3 => padding_col2_3,
		 padding_row2_3 => padding_row2_3,
		 col2_3 => col2_3,
		 p_row2_3 => p_row2_3,
		 p_col2_3 => p_col2_3,
		 conv2_col_3 => conv2_col_3,
		 conv2_fila_3 => conv2_fila_3,
		 pool3_col_3 => pool3_col_3,
		 pool3_fila_3 => pool3_fila_3,
		 dato_out_v => data_new2,
		 cero_v => zero2,
		 dato_cero_v => data_zero2,
		 padding_col2_v => padding_col2,
		 padding_row2_v => padding_row2,
		 col2_v => col2,
		 p_row2_v => p_row2,
		 p_col2_v => p_col2,
		 conv2_col_v => conv2_col,
		 conv2_fila_v => conv2_fila,
		 pool3_col_v => pool3_col,
		 pool3_fila_v => pool3_fila);
		 
    MUX2 : MUX_2
    PORT MAP(
        data_in0 => data_out_relu11,
        data_in1 => data_out_relu12,
        data_in2 => data_out_relu13,
        data_in3 => data_out_relu14,
        data_in4 => data_out_relu15,
        data_in5 => data_out_relu16,
        index => layer2,
        data_out => data_in_pool2);
    MUX22 : MUX_2
    PORT MAP(
        data_in0 => data_out_relu2_1,
        data_in1 => data_out_relu2_2,
        data_in2 => data_out_relu2_3,
        data_in3 => data_out_relu2_4,
        data_in4 => data_out_relu2_5,
        data_in5 => data_out_relu2_6,
        index => layer2,
        data_out => data_in_pool2_2);



    data_max_L1(weight_sizeL1 + fractional_size_L1 + n_extra_bits + 1 DOWNTO w_fractional_sizeL1 + fractional_size_L1 + 1) <= (OTHERS => '0');
    data_max_L1(w_fractional_sizeL1 + fractional_size_L1 DOWNTO w_fractional_sizeL1) <= (OTHERS => '1');
    data_max_L1(w_fractional_sizeL1 - 1 DOWNTO 0) <= (OTHERS => '0');

    data_min_L1(weight_sizeL1 + fractional_size_L1 + n_extra_bits + 1 DOWNTO w_fractional_sizeL1 + fractional_size_L1 + 1) <= (OTHERS => '1');
    data_min_L1(w_fractional_sizeL1 + fractional_size_L1 DOWNTO 0) <= (OTHERS => '0');

    PROCESS (data_in_act2_1, data_min_L1, data_max_L1, data_in_pool2)
    BEGIN
        IF (signed(data_in_pool2) >= data_max_L1) THEN
            data_in_act2_1(input_size_L1fc - 1) <= '0';
            data_in_act2_1(input_size_L1fc - 2 DOWNTO 0) <= (OTHERS => '1');
        ELSIF (signed(data_in_pool2) <= data_min_L1) THEN
            data_in_act2_1(input_size_L1fc - 1) <= '1';
            data_in_act2_1(input_size_L1fc - 2 DOWNTO 0) <= (OTHERS => '0');
        ELSE
            data_in_act2_1 <= data_in_pool2(w_fractional_sizeL1 + input_sizeL2 - 1 DOWNTO w_fractional_sizeL1);
        END IF;
    END PROCESS;

    PROCESS (data_in_act2_2, data_min_L1, data_max_L1, data_in_pool2_2)
    BEGIN
        IF (signed(data_in_pool2_2) >= data_max_L1) THEN
            data_in_act2_2(input_size_L1fc - 1) <= '0';
            data_in_act2_2(input_size_L1fc - 2 DOWNTO 0) <= (OTHERS => '1');
        ELSIF (signed(data_in_pool2_2) <= data_min_L1) THEN
            data_in_act2_2(input_size_L1fc - 1) <= '1';
            data_in_act2_2(input_size_L1fc - 2 DOWNTO 0) <= (OTHERS => '0');
        ELSE
            data_in_act2_2 <= data_in_pool2_2(w_fractional_sizeL1 + input_sizeL2 - 1 DOWNTO w_fractional_sizeL1);
        END IF;
    END PROCESS;

    --Layer 2 MaxPool filter
    --It receives two input data because the process is parallelized
--    Sigmoid_functionL2 : sigmoid_L2
--    PORT MAP(
--        data_in => data_in_act2_1,
--        data_out => data_act_L2_1);
--    Sigmoid_functionL2_2 : sigmoid_L2
--    PORT MAP(
--        data_in => data_in_act2_2,
--        data_out => data_act_L2_2);
    Sigmoid_functionL2_1 : sigmoid_L2
  port map(
  data_in => data_in_act2_1,
  data_out => data_act_L2_1_1);
Sigmoid_functionL2_2 : sigmoid_L2
  port map(
  data_in => data_in_act2_1,
  data_out => data_act_L2_1_2);
Sigmoid_functionL2_3 : sigmoid_L2
  port map(
  data_in => data_in_act2_1,
  data_out => data_act_L2_1_3);
VOTADOR_sigmoid_L2 : VOT_sigmoid_L2
  port map(
		data_out_1 => data_act_L2_1_1,
		data_out_2 => data_act_L2_1_2,
		data_out_3 => data_act_L2_1_3,
		data_out_v => data_act_L2_1);
Sigmoid_functionL2_2_1 : sigmoid_L2
  port map(
  data_in => data_in_act2_2,
  data_out => data_act_L2_2_1);
Sigmoid_functionL2_2_2 : sigmoid_L2
  port map(
  data_in => data_in_act2_2,
  data_out => data_act_L2_2_2);
Sigmoid_functionL2_2_3 : sigmoid_L2
  port map(
  data_in => data_in_act2_2,
  data_out => data_act_L2_2_3);
VOTADOR_sigmoid_L2_2 : VOT_sigmoid_L2
  port map(
		data_out_1 => data_act_L2_2_1,
		data_out_2 => data_act_L2_2_2,
		data_out_3 => data_act_L2_2_3,
		data_out_v => data_act_L2_2);
    --Send the data to the neurons when we are not in padding zone, else send address_in
--    POOL2 : MAXPOOL_LAYER2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        index => index2,
--        data_in => data_act_L2_1,
--        data_in2 => data_act_L2_2,
--        data_out => data_pool2);
    POOL2_1 : MAXPOOL_LAYER2
port map(
  clk => clk,
  rst => rst,
  index => index2,
  data_in => data_act_L2_1,
  data_in2 => data_act_L2_2,
  data_out => data_pool2_1);
POOL2_2 : MAXPOOL_LAYER2
port map(
  clk => clk,
  rst => rst,
  index => index2,
  data_in => data_act_L2_1,
  data_in2 => data_act_L2_2,
  data_out => data_pool2_2);
POOL2_3 : MAXPOOL_LAYER2
port map(
  clk => clk,
  rst => rst,
  index => index2,
  data_in => data_act_L2_1,
  data_in2 => data_act_L2_2,
  data_out => data_pool2_3);
VOTADOR_POOL2 : VOT_MAXPOOL_LAYER2
   port map(
      data_out_1 => data_pool2_1,
      data_out_2 => data_pool2_2,
      data_out_3 => data_pool2_3,
      data_out_v => data_pool2);
    --Send the data to the neurons when we are not in padding zone, else send zero
    data_in_layer2 <= data_pool2 WHEN (zero2 = '0') ELSE
        (OTHERS => '0');

    --Convert the data from parallel to serial
--    CONVERSORL2 : par2ser
--    GENERIC MAP(input_size => input_sizeL2)
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        en_neuron => en_neuronL2,
--        data_in => data_in_layer2,
--        bit_select => count2,
--        bit_out => data_par2serL2
--    );
    CONVERSORL2_1 : par2ser  
 generic map (input_size => input_sizeL2) 
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL2,
  data_in => data_in_layer2,
  bit_select => count2,
  bit_out => data_par2serL2_1
);
CONVERSORL2_2 : par2ser  
 generic map (input_size => input_sizeL2) 
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL2,
  data_in => data_in_layer2,
  bit_select => count2,
  bit_out => data_par2serL2_2
);
CONVERSORL2_3 : par2ser  
 generic map (input_size => input_sizeL2) 
port map(
  clk => clk,
  rst => rst,
  en_neuron => en_neuronL2,
  data_in => data_in_layer2,
  bit_select => count2,
  bit_out => data_par2serL2_3
);
VOTADOR_PAR2SER_2 : VOT_PAR2SER
   port map(
		 serial_out_1 => data_par2serL2_1,
		 serial_out_2 => data_par2serL2_2,
		 serial_out_3 => data_par2serL2_3,
		 serial_out_v => data_par2serL2);
		 
    --Data sent to the neurons, we only send it when the neurons can process it (enable neuron = 1)
    data_in_filter2 <= data_par2serL2 WHEN en_neuronL2 = '1' ELSE
        '0';

    --Control signal to select the corresponding weight at each multiplication
    address_2 <= mul2 & layer2;

    --Neurons layer 2 + ReLu
--    CONV_21 : CONV21
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu21);
--    RELU_21 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu21,
--        index => index3,
--        data_out => data_out_relu21);
--    CONV_22 : CONV22
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu22);
--    RELU_22 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu22,
--        index => index3,
--        data_out => data_out_relu22);
--    CONV_23 : CONV23
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu23);
--    RELU_23 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu23,
--        index => index3,
--        data_out => data_out_relu23);
--    CONV_24 : CONV24
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu24);
--    RELU_24 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu24,
--        index => index3,
--        data_out => data_out_relu24);
--    CONV_25 : CONV25
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu25);
--    RELU_25 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu25,
--        index => index3,
--        data_out => data_out_relu25);
--    CONV_26 : CONV26
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu26);
--    RELU_26 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu26,
--        index => index3,
--        data_out => data_out_relu26);
--    CONV_27 : CONV27
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu27);
--    RELU_27 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu27,
--        index => index3,
--        data_out => data_out_relu27);
--    CONV_28 : CONV28
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu28);
--    RELU_28 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu28,
--        index => index3,
--        data_out => data_out_relu28);
--    CONV_29 : CONV29
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu29);
--    RELU_29 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu29,
--        index => index3,
--        data_out => data_out_relu29);
--    CONV_210 : CONV210
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu210);
--    RELU_210 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu210,
--        index => index3,
--        data_out => data_out_relu210);
--    CONV_211 : CONV211
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu211);
--    RELU_211 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu211,
--        index => index3,
--        data_out => data_out_relu211);
--    CONV_212 : CONV212
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu212);
--    RELU_212 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu212,
--        index => index3,
--        data_out => data_out_relu212);
--    CONV_213 : CONV213
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu213);
--    RELU_213 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu213,
--        index => index3,
--        data_out => data_out_relu213);
--    CONV_214 : CONV214
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu214);
--    RELU_214 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu214,
--        index => index3,
--        data_out => data_out_relu214);
--    CONV_215 : CONV215
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu215);
--    RELU_215 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu215,
--        index => index3,
--        data_out => data_out_relu215);
--    CONV_216 : CONV216
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        data_in => data_in_filter2,
--        address => address_2,
--        bit_select => count2,
--        next_pipeline_step => next_pipeline_step2,
--        data_out => data_in_relu216);
--    RELU_216 : RELUL2
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        next_pipeline_step => next_pipeline_step2,
--        data_in => data_in_relu216,
--        index => index3,
--        data_out => data_out_relu216);
CONV_21_1 : CONV21
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu21_1);
CONV_21_2 : CONV21
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu21_2);
CONV_21_3 : CONV21
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu21_3);
VOTADOR_CONV21 : VOT_CONV21
   port map(
		    data_out_1 => data_in_relu21_1,
		    data_out_2 => data_in_relu21_2,
		    data_out_3 => data_in_relu21_3,
		    data_out_v => data_in_relu21);
RELU_21_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu21,
    index => index3,
    data_out => data_out_relu21_1);  
RELU_21_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu21,
    index => index3,
    data_out => data_out_relu21_2);  
RELU_21_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu21,
    index => index3,
    data_out => data_out_relu21_3);  
VOTADOR_RELU2_1 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu21_1,
		    data_out_2 => data_out_relu21_2,
		    data_out_3 => data_out_relu21_3,
		    data_out_v => data_out_relu21);
CONV_22_1 : CONV22
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu22_1);
CONV_22_2 : CONV22
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu22_2);
CONV_22_3 : CONV22
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu22_3);
VOTADOR_CONV22 : VOT_CONV22
   port map(
		    data_out_1 => data_in_relu22_1,
		    data_out_2 => data_in_relu22_2,
		    data_out_3 => data_in_relu22_3,
		    data_out_v => data_in_relu22);
RELU_22_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu22,
    index => index3,
    data_out => data_out_relu22_1);  
RELU_22_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu22,
    index => index3,
    data_out => data_out_relu22_2);  
RELU_22_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu22,
    index => index3,
    data_out => data_out_relu22_3);  
VOTADOR_RELU2_2 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu22_1,
		    data_out_2 => data_out_relu22_2,
		    data_out_3 => data_out_relu22_3,
		    data_out_v => data_out_relu22);
CONV_23_1 : CONV23
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu23_1);
CONV_23_2 : CONV23
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu23_2);
CONV_23_3 : CONV23
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu23_3);
VOTADOR_CONV23 : VOT_CONV23
   port map(
		    data_out_1 => data_in_relu23_1,
		    data_out_2 => data_in_relu23_2,
		    data_out_3 => data_in_relu23_3,
		    data_out_v => data_in_relu23);
RELU_23_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu23,
    index => index3,
    data_out => data_out_relu23_1);  
RELU_23_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu23,
    index => index3,
    data_out => data_out_relu23_2);  
RELU_23_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu23,
    index => index3,
    data_out => data_out_relu23_3);  
VOTADOR_RELU2_3 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu23_1,
		    data_out_2 => data_out_relu23_2,
		    data_out_3 => data_out_relu23_3,
		    data_out_v => data_out_relu23);
CONV_24_1 : CONV24
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu24_1);
CONV_24_2 : CONV24
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu24_2);
CONV_24_3 : CONV24
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu24_3);
VOTADOR_CONV24 : VOT_CONV24
   port map(
		    data_out_1 => data_in_relu24_1,
		    data_out_2 => data_in_relu24_2,
		    data_out_3 => data_in_relu24_3,
		    data_out_v => data_in_relu24);
RELU_24_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu24,
    index => index3,
    data_out => data_out_relu24_1);  
RELU_24_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu24,
    index => index3,
    data_out => data_out_relu24_2);  
RELU_24_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu24,
    index => index3,
    data_out => data_out_relu24_3);  
VOTADOR_RELU2_4 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu24_1,
		    data_out_2 => data_out_relu24_2,
		    data_out_3 => data_out_relu24_3,
		    data_out_v => data_out_relu24);
CONV_25_1 : CONV25
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu25_1);
CONV_25_2 : CONV25
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu25_2);
CONV_25_3 : CONV25
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu25_3);
VOTADOR_CONV25 : VOT_CONV25
   port map(
		    data_out_1 => data_in_relu25_1,
		    data_out_2 => data_in_relu25_2,
		    data_out_3 => data_in_relu25_3,
		    data_out_v => data_in_relu25);
RELU_25_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu25,
    index => index3,
    data_out => data_out_relu25_1);  
RELU_25_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu25,
    index => index3,
    data_out => data_out_relu25_2);  
RELU_25_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu25,
    index => index3,
    data_out => data_out_relu25_3);  
VOTADOR_RELU2_5 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu25_1,
		    data_out_2 => data_out_relu25_2,
		    data_out_3 => data_out_relu25_3,
		    data_out_v => data_out_relu25);
CONV_26_1 : CONV26
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu26_1);
CONV_26_2 : CONV26
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu26_2);
CONV_26_3 : CONV26
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu26_3);
VOTADOR_CONV26 : VOT_CONV26
   port map(
		    data_out_1 => data_in_relu26_1,
		    data_out_2 => data_in_relu26_2,
		    data_out_3 => data_in_relu26_3,
		    data_out_v => data_in_relu26);
RELU_26_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu26,
    index => index3,
    data_out => data_out_relu26_1);  
RELU_26_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu26,
    index => index3,
    data_out => data_out_relu26_2);  
RELU_26_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu26,
    index => index3,
    data_out => data_out_relu26_3);  
VOTADOR_RELU2_6 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu26_1,
		    data_out_2 => data_out_relu26_2,
		    data_out_3 => data_out_relu26_3,
		    data_out_v => data_out_relu26);
CONV_27_1 : CONV27
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu27_1);
CONV_27_2 : CONV27
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu27_2);
CONV_27_3 : CONV27
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu27_3);
VOTADOR_CONV27 : VOT_CONV27
   port map(
		    data_out_1 => data_in_relu27_1,
		    data_out_2 => data_in_relu27_2,
		    data_out_3 => data_in_relu27_3,
		    data_out_v => data_in_relu27);
RELU_27_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu27,
    index => index3,
    data_out => data_out_relu27_1);  
RELU_27_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu27,
    index => index3,
    data_out => data_out_relu27_2);  
RELU_27_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu27,
    index => index3,
    data_out => data_out_relu27_3);  
VOTADOR_RELU2_7 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu27_1,
		    data_out_2 => data_out_relu27_2,
		    data_out_3 => data_out_relu27_3,
		    data_out_v => data_out_relu27);
CONV_28_1 : CONV28
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu28_1);
CONV_28_2 : CONV28
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu28_2);
CONV_28_3 : CONV28
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu28_3);
VOTADOR_CONV28 : VOT_CONV28
   port map(
		    data_out_1 => data_in_relu28_1,
		    data_out_2 => data_in_relu28_2,
		    data_out_3 => data_in_relu28_3,
		    data_out_v => data_in_relu28);
RELU_28_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu28,
    index => index3,
    data_out => data_out_relu28_1);  
RELU_28_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu28,
    index => index3,
    data_out => data_out_relu28_2);  
RELU_28_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu28,
    index => index3,
    data_out => data_out_relu28_3);  
VOTADOR_RELU2_8 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu28_1,
		    data_out_2 => data_out_relu28_2,
		    data_out_3 => data_out_relu28_3,
		    data_out_v => data_out_relu28);
CONV_29_1 : CONV29
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu29_1);
CONV_29_2 : CONV29
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu29_2);
CONV_29_3 : CONV29
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu29_3);
VOTADOR_CONV29 : VOT_CONV29
   port map(
		    data_out_1 => data_in_relu29_1,
		    data_out_2 => data_in_relu29_2,
		    data_out_3 => data_in_relu29_3,
		    data_out_v => data_in_relu29);
RELU_29_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu29,
    index => index3,
    data_out => data_out_relu29_1);  
RELU_29_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu29,
    index => index3,
    data_out => data_out_relu29_2);  
RELU_29_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu29,
    index => index3,
    data_out => data_out_relu29_3);  
VOTADOR_RELU2_9 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu29_1,
		    data_out_2 => data_out_relu29_2,
		    data_out_3 => data_out_relu29_3,
		    data_out_v => data_out_relu29);
CONV_210_1 : CONV210
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu210_1);
CONV_210_2 : CONV210
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu210_2);
CONV_210_3 : CONV210
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu210_3);
VOTADOR_CONV210 : VOT_CONV210
   port map(
		    data_out_1 => data_in_relu210_1,
		    data_out_2 => data_in_relu210_2,
		    data_out_3 => data_in_relu210_3,
		    data_out_v => data_in_relu210);
RELU_210_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu210,
    index => index3,
    data_out => data_out_relu210_1);  
RELU_210_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu210,
    index => index3,
    data_out => data_out_relu210_2);  
RELU_210_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu210,
    index => index3,
    data_out => data_out_relu210_3);  
VOTADOR_RELU2_10 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu210_1,
		    data_out_2 => data_out_relu210_2,
		    data_out_3 => data_out_relu210_3,
		    data_out_v => data_out_relu210);
CONV_211_1 : CONV211
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu211_1);
CONV_211_2 : CONV211
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu211_2);
CONV_211_3 : CONV211
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu211_3);
VOTADOR_CONV211 : VOT_CONV211
   port map(
		    data_out_1 => data_in_relu211_1,
		    data_out_2 => data_in_relu211_2,
		    data_out_3 => data_in_relu211_3,
		    data_out_v => data_in_relu211);
RELU_211_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu211,
    index => index3,
    data_out => data_out_relu211_1);  
RELU_211_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu211,
    index => index3,
    data_out => data_out_relu211_2);  
RELU_211_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu211,
    index => index3,
    data_out => data_out_relu211_3);  
VOTADOR_RELU2_11 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu211_1,
		    data_out_2 => data_out_relu211_2,
		    data_out_3 => data_out_relu211_3,
		    data_out_v => data_out_relu211);
CONV_212_1 : CONV212
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu212_1);
CONV_212_2 : CONV212
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu212_2);
CONV_212_3 : CONV212
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu212_3);
VOTADOR_CONV212 : VOT_CONV212
   port map(
		    data_out_1 => data_in_relu212_1,
		    data_out_2 => data_in_relu212_2,
		    data_out_3 => data_in_relu212_3,
		    data_out_v => data_in_relu212);
RELU_212_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu212,
    index => index3,
    data_out => data_out_relu212_1);  
RELU_212_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu212,
    index => index3,
    data_out => data_out_relu212_2);  
RELU_212_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu212,
    index => index3,
    data_out => data_out_relu212_3);  
VOTADOR_RELU2_12 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu212_1,
		    data_out_2 => data_out_relu212_2,
		    data_out_3 => data_out_relu212_3,
		    data_out_v => data_out_relu212);
CONV_213_1 : CONV213
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu213_1);
CONV_213_2 : CONV213
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu213_2);
CONV_213_3 : CONV213
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu213_3);
VOTADOR_CONV213 : VOT_CONV213
   port map(
		    data_out_1 => data_in_relu213_1,
		    data_out_2 => data_in_relu213_2,
		    data_out_3 => data_in_relu213_3,
		    data_out_v => data_in_relu213);
RELU_213_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu213,
    index => index3,
    data_out => data_out_relu213_1);  
RELU_213_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu213,
    index => index3,
    data_out => data_out_relu213_2);  
RELU_213_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu213,
    index => index3,
    data_out => data_out_relu213_3);  
VOTADOR_RELU2_13 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu213_1,
		    data_out_2 => data_out_relu213_2,
		    data_out_3 => data_out_relu213_3,
		    data_out_v => data_out_relu213);
CONV_214_1 : CONV214
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu214_1);
CONV_214_2 : CONV214
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu214_2);
CONV_214_3 : CONV214
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu214_3);
VOTADOR_CONV214 : VOT_CONV214
   port map(
		    data_out_1 => data_in_relu214_1,
		    data_out_2 => data_in_relu214_2,
		    data_out_3 => data_in_relu214_3,
		    data_out_v => data_in_relu214);
RELU_214_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu214,
    index => index3,
    data_out => data_out_relu214_1);  
RELU_214_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu214,
    index => index3,
    data_out => data_out_relu214_2);  
RELU_214_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu214,
    index => index3,
    data_out => data_out_relu214_3);  
VOTADOR_RELU2_14 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu214_1,
		    data_out_2 => data_out_relu214_2,
		    data_out_3 => data_out_relu214_3,
		    data_out_v => data_out_relu214);
CONV_215_1 : CONV215
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu215_1);
CONV_215_2 : CONV215
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu215_2);
CONV_215_3 : CONV215
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu215_3);
VOTADOR_CONV215 : VOT_CONV215
   port map(
		    data_out_1 => data_in_relu215_1,
		    data_out_2 => data_in_relu215_2,
		    data_out_3 => data_in_relu215_3,
		    data_out_v => data_in_relu215);
RELU_215_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu215,
    index => index3,
    data_out => data_out_relu215_1);  
RELU_215_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu215,
    index => index3,
    data_out => data_out_relu215_2);  
RELU_215_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu215,
    index => index3,
    data_out => data_out_relu215_3);  
VOTADOR_RELU2_15 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu215_1,
		    data_out_2 => data_out_relu215_2,
		    data_out_3 => data_out_relu215_3,
		    data_out_v => data_out_relu215);
CONV_216_1 : CONV216
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu216_1);
CONV_216_2 : CONV216
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu216_2);
CONV_216_3 : CONV216
port map(
    clk => clk,
    rst => rst,
    data_in => data_in_filter2,
    address => address_2,
    bit_select => count2,
    next_pipeline_step => next_pipeline_step2,
    data_out => data_in_relu216_3);
VOTADOR_CONV216 : VOT_CONV216
   port map(
		    data_out_1 => data_in_relu216_1,
		    data_out_2 => data_in_relu216_2,
		    data_out_3 => data_in_relu216_3,
		    data_out_v => data_in_relu216);
RELU_216_1 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu216,
    index => index3,
    data_out => data_out_relu216_1);  
RELU_216_2 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu216,
    index => index3,
    data_out => data_out_relu216_2);  
RELU_216_3 : RELUL2
 port map(
    clk => clk,
    rst => rst,
    next_pipeline_step => next_pipeline_step2,
    data_in => data_in_relu216,
    index => index3,
    data_out => data_out_relu216_3);  
VOTADOR_RELU2_16 : VOT_RELUL2
   port map(
		    data_out_1 => data_out_relu216_1,
		    data_out_2 => data_out_relu216_2,
		    data_out_3 => data_out_relu216_3,
		    data_out_v => data_out_relu216);
    --Layer4
    --In the last layer we only have a MaxPool filter, therefore we only generate the control signals for said filters and the control signals for communicating with the FC network
--    GENERADOR3 : GEN3
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        rst_red => rst_red,
--        data_in_fc => data_fc,
--        data_in_cnn => data_new_et3,
--        data_new => data_processed3,
--        layer => layer3,
--        index => index3,
--        next_data_pool => next_data_pool3);
    
    GENERADOR3_1 : GEN3
port map(
     clk => clk,
     rst => rst,
     rst_red => rst_red,
     data_in_fc => data_fc,
     data_in_cnn => data_new_et3,
     data_new => data_processed3_1,
     layer => layer3_1,
     index => index3_1,
     next_data_pool => next_data_pool3_1);

GENERADOR3_2 : GEN3
port map(
     clk => clk,
     rst => rst,
     rst_red => rst_red,
     data_in_fc => data_fc,
     data_in_cnn => data_new_et3,
     data_new => data_processed3_2,
     layer => layer3_2,
     index => index3_2,
     next_data_pool => next_data_pool3_2);

GENERADOR3_3 : GEN3
port map(
     clk => clk,
     rst => rst,
     rst_red => rst_red,
     data_in_fc => data_fc,
     data_in_cnn => data_new_et3,
     data_new => data_processed3_3,
     layer => layer3_3,
     index => index3_3,
     next_data_pool => next_data_pool3_3);

VOTADOR_GEN3 : VOT_GEN3
   port map(
		 dato_new_1 => data_processed3_1,
 		 layer_1 => layer3_1,
		 index_1 => index3_1,
		 next_dato_pool_1 => next_data_pool3_1,
		 dato_new_2 => data_processed3_2,
 		 layer_2 => layer3_2,
		 index_2 => index3_2,
		 next_dato_pool_2 => next_data_pool3_2,
		 dato_new_3 => data_processed3_3,
 		 layer_3 => layer3_3,
		 index_3 => index3_3,
		 next_dato_pool_3 => next_data_pool3_3,
		 dato_new_v => data_processed3,
 		 layer_v => layer3,
		 index_v => index3,
		 next_dato_pool_v => next_data_pool3);
    
    --This signal is sent to the FC network to notify when a valid output data is sent by the last MaxPool filter of the network
    data_ready <= next_data_pool3;

    MUX3 : MUX_3
    PORT MAP(
        data_in0 => data_out_relu21,
        data_in1 => data_out_relu22,
        data_in2 => data_out_relu23,
        data_in3 => data_out_relu24,
        data_in4 => data_out_relu25,
        data_in5 => data_out_relu26,
        data_in6 => data_out_relu27,
        data_in7 => data_out_relu28,
        data_in8 => data_out_relu29,
        data_in9 => data_out_relu210,
        data_in10 => data_out_relu211,
        data_in11 => data_out_relu212,
        data_in12 => data_out_relu213,
        data_in13 => data_out_relu214,
        data_in14 => data_out_relu215,
        data_in15 => data_out_relu216,
        index => layer3,
        data_out => data_in_pool3);

    data_max_L2(weight_sizeL2 + fractional_size_L1fc + n_extra_bits + 1 DOWNTO w_fractional_sizeL2 + fractional_size_L1fc + 1) <= (OTHERS => '0');
    data_max_L2(w_fractional_sizeL2 + fractional_size_L1fc DOWNTO w_fractional_sizeL2) <= (OTHERS => '1');
    data_max_L2(w_fractional_sizeL2 - 1 DOWNTO 0) <= (OTHERS => '0');

    data_min_L2(weight_sizeL2 + fractional_size_L1fc + n_extra_bits + 1 DOWNTO w_fractional_sizeL2 + fractional_size_L1fc + 1) <= (OTHERS => '1');
    data_min_L2(w_fractional_sizeL2 + fractional_size_L1fc DOWNTO 0) <= (OTHERS => '0');

    PROCESS (data_in_act3, data_min_L2, data_max_L2, data_in_pool3)
    BEGIN
        IF (signed(data_in_pool3) >= data_max_L2) THEN
            data_in_act3(input_size_L1fc - 1) <= '0';
            data_in_act3(input_size_L1fc - 2 DOWNTO 0) <= (OTHERS => '1');
        ELSIF (signed(data_in_pool3) <= data_min_L2) THEN
            data_in_act3(input_size_L1fc - 1) <= '1';
            data_in_act3(input_size_L1fc - 2 DOWNTO 0) <= (OTHERS => '0');
        ELSE
            data_in_act3 <= data_in_pool3(w_fractional_sizeL2 + input_size_L1fc - 1 DOWNTO w_fractional_sizeL2);
        END IF;
    END PROCESS;

--    Sigmoid_functionL3 : sigmoid_L3
--    PORT MAP(
--        data_in => data_in_act3,
--        data_out => data_act_L3); 
    Sigmoid_functionL3_1 : sigmoid_L3
  port map(
  data_in => data_in_act3,
  data_out => data_act_L3_1);
Sigmoid_functionL3_2 : sigmoid_L3
  port map(
  data_in => data_in_act3,
  data_out => data_act_L3_2);
Sigmoid_functionL3_3 : sigmoid_L3
  port map(
  data_in => data_in_act3,
  data_out => data_act_L3_3);
VOTADOR_sigmoid_L3 : VOT_sigmoid_L3
  port map(
		data_out_1 => data_act_L3_1,
		data_out_2 => data_act_L3_2,
		data_out_3 => data_act_L3_3,
		data_out_v => data_act_L3);
		
    --Layer 3 MaxPool filter 
--    POOL3 : MAXPOOL_L3
--    GENERIC MAP(input_size => input_sizeL2, weight_size => weight_sizeL2)
--    PORT MAP(
--        clk => clk,
--        rst => rst,
--        index => index3,
--        data_in => data_act_L3,
--        next_data_pool => next_data_pool3,
--        data_out => data_out);

    POOL3_1 : MAXPOOL_L3
 generic map (input_size => input_sizeL2, weight_size => weight_sizeL2)
   port map(
   clk => clk,
   rst => rst,
   index => index3,
   data_in => data_act_L3,
   next_data_pool  => next_data_pool3,
   data_out =>  data_out_1); 
POOL3_2 : MAXPOOL_L3
 generic map (input_size => input_sizeL2, weight_size => weight_sizeL2)
   port map(
   clk => clk,
   rst => rst,
   index => index3,
   data_in => data_act_L3,
   next_data_pool  => next_data_pool3,
   data_out =>  data_out_2); 
POOL3_3 : MAXPOOL_L3
 generic map (input_size => input_sizeL2, weight_size => weight_sizeL2)
   port map(
   clk => clk,
   rst => rst,
   index => index3,
   data_in => data_act_L3,
   next_data_pool  => next_data_pool3,
   data_out =>  data_out_3); 
VOTADOR_MAXPOOL_L3 : VOT_MAXPOOL_L3
 generic map (input_size => input_sizeL2, weight_size => weight_sizeL2)
   port map(
      data_out_1 =>  data_out_1,
      data_out_2 =>  data_out_2,
      data_out_3 =>  data_out_3,
      data_out_v =>  data_out);
      
END Behavioral;