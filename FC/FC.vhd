-----------------------------------FC NETWORK-------------------------------------
--THIS SYSTEM CORRESPONDS TO A CONVOLUTIONAL NEURAL NETWORK WITH DIMENSIONS TO BE SPECIFIED IN THE LIBRARY
--INPUTS
--start_red : start the processing of data
--data_in : data to be processed from the memory
--data_fc : signals that a new data has been processed by the FC network

--OUTPUTS
--data_ready: signal indicating that a data is available on the network
--data_out: data processed by the last layer of the neuron
--address : address to be sent to the memory

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FC is
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            rst_red : in std_logic;
            start_enable : in STD_LOGIC;
            data_fc : out std_logic;
            finish : out std_logic;
            x : in STD_LOGIC_VECTOR(input_size_L1fc - 1 downto 0);
            output_sm : out vector_sm_signed(0 to 10 - 1);
            y : out unsigned(log2c(10) - 1 downto 0)
        );
end FC;

architecture Behavioral of FC is  

--Component declaration 

--COMMOM MODULES
component enable_generator is
    Port ( clk : in std_logic;
           rst : in std_logic;
           rst_red : in std_logic;
           start_enable : in std_logic;
           data_fc : out std_logic;
           en_neuron : out std_logic;
           addr_FC : out std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);
           bit_select : out unsigned(log2c(input_size_L1fc)-1 downto 0);
           next_pipeline_step: out std_logic;
           addr_Sm : out std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
           exp_Sm: out std_logic;
           inv_Sm: out std_logic;
           sum_finish: out std_logic;
           enable_lastlayer : out STD_LOGIC);
end component;
component VOT_enable_generator is
    Port ( 
           data_fc_1 : in std_logic;
           en_neuron_1 : in std_logic;
           addr_FC_1 : in std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);
           bit_select_1 : in unsigned(log2c(input_size_L1fc)-1 downto 0);
           next_pipeline_step_1: in std_logic;
           addr_Sm_1 : in std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
           exp_Sm_1: in std_logic;
           inv_Sm_1: in std_logic;
           sum_finish_1: in std_logic;
           enable_lastlayer_1 : in STD_LOGIC;
           data_fc_2 : in std_logic;
           en_neuron_2 : in std_logic;
           addr_FC_2 : in std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);
           bit_select_2 : in unsigned(log2c(input_size_L1fc)-1 downto 0);
           next_pipeline_step_2: in std_logic;
           addr_Sm_2 : in std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
           exp_Sm_2: in std_logic;
           inv_Sm_2: in std_logic;
           sum_finish_2: in std_logic;
           enable_lastlayer_2 : in STD_LOGIC;
           data_fc_3 : in std_logic;
           en_neuron_3 : in std_logic;
           addr_FC_3 : in std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);
           bit_select_3 : in unsigned(log2c(input_size_L1fc)-1 downto 0);
           next_pipeline_step_3: in std_logic;
           addr_Sm_3 : in std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
           exp_Sm_3: in std_logic;
           inv_Sm_3: in std_logic;
           sum_finish_3: in std_logic;
           enable_lastlayer_3 : in STD_LOGIC;
           data_fc : out std_logic;
           en_neuron : out std_logic;
           addr_FC : out std_logic_vector(log2c(biggest_ROM_size)-1 downto 0);
           bit_select : out unsigned(log2c(input_size_L1fc)-1 downto 0);
           next_pipeline_step: out std_logic;
           addr_Sm : out std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
           exp_Sm: out std_logic;
           inv_Sm: out std_logic;
           sum_finish: out std_logic;
           enable_lastlayer : out STD_LOGIC);
end component;
-- Activation function
--component activation_function is
    --Port ( x : in STD_LOGIC_VECTOR (input_size_fc-1 downto 0);
           --y : out STD_LOGIC_VECTOR (input_size_fc-1 downto 0));
--end component;
---Par2ser converters
component PAR2SER
generic (input_size : integer := 8);    --number of bits of the input data
  Port ( clk : in std_logic;
         rst : in std_logic;
         data_in : in std_logic_vector (input_size-1 downto 0);
         en_neuron : in std_logic;
         bit_select : in unsigned( log2c(input_size) - 1 downto 0);
         bit_out : out std_logic);
end component;
component VOT_PAR2SER is
	 Port (
		 serial_out_1 : in STD_LOGIC;
		 serial_out_2 : in STD_LOGIC;
		 serial_out_3 : in STD_LOGIC;
		 serial_out_v : out STD_LOGIC);
end component;

component bit_mux is
generic (input_size : integer := 8);    --number of bits of the input data
  Port ( data_in : in std_logic_vector (input_size-1 downto 0);
         bit_select : in unsigned (log2c(input_size)-1 downto 0);
         bit_out : out std_logic);
end component;

---Layer 1 Modules
component Register_FCL1 is
Port ( data_in : in vector_L1fc_activations(0 to number_of_inputs_L2fc-1);
       clk : in std_logic;
       rst : in std_logic;
       next_pipeline_step : in std_logic;
       data_out : out vector_L1fc_activations(0 to number_of_inputs_L2fc-1));
end component;
component VOT_Register_FCL1 is
Port ( 
       data_out_1 : in vector_L1fc_activations(0 to number_of_inputs_L2fc-1);
       data_out_2 : in vector_L1fc_activations(0 to number_of_inputs_L2fc-1);
       data_out_3 : in vector_L1fc_activations(0 to number_of_inputs_L2fc-1);
       data_out_v : out vector_L1fc_activations(0 to number_of_inputs_L2fc-1));
end component;
component Mux_FCL1 is
Port ( data_in : in vector_L1fc_activations(0 to number_of_inputs_L2fc-1);
       ctrl : in std_logic_vector(log2c(number_of_outputs_L1fc) - 1 downto 0 );
       mac_max : in signed (input_size_L2fc+weight_size_L2fc+n_extra_bits-1 downto 0);
       mac_min : in signed (input_size_L2fc+weight_size_L2fc+n_extra_bits-1 downto 0);
       data_out : out std_logic_vector(input_size_L2fc-1 downto 0));
end component;
-- Layer 1 neurons declaration --
--component layer1_FCneuron_1 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_2 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_3 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_4 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_5 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_6 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_7 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_8 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_9 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_10 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_11 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_12 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_13 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_14 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_15 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_16 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_17 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_18 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_19 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_20 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_21 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_22 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_23 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_24 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_25 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_26 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_27 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_28 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_29 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_30 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_31 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_32 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_33 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_34 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_35 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_36 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_37 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_38 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_39 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_40 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_41 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_42 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_43 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_44 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_45 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_46 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_47 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_48 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_49 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_50 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_51 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_52 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_53 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_54 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_55 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_56 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_57 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_58 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_59 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_60 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_61 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_62 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_63 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_64 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_65 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_66 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_67 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_68 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_69 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_70 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_71 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_72 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_73 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_74 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_75 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_76 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_77 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_78 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_79 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_80 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_81 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_82 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_83 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_84 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_85 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_86 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_87 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_88 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_89 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_90 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_91 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_92 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_93 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_94 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_95 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_96 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_97 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_98 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_99 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_100 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_101 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_102 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_103 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_104 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_105 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_106 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_107 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_108 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_109 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_110 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_111 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_112 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_113 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_114 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_115 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_116 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_117 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_118 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_119 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;component layer1_FCneuron_120 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
--end component ;
component layer1_FCneuron_1 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_1 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_2 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_2 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_3 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_3 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_4 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_4 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_5 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_5 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_6 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_6 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_7 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_7 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_8 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_8 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_9 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_9 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_10 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_10 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_11 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_11 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_12 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_12 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_13 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_13 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_14 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_14 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_15 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_15 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_16 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_16 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_17 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_17 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_18 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_18 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_19 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_19 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_20 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_20 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_21 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_21 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_22 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_22 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_23 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_23 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_24 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_24 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_25 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_25 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_26 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_26 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_27 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_27 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_28 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_28 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_29 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_29 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_30 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_30 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_31 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_31 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_32 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_32 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_33 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_33 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_34 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_34 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_35 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_35 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_36 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_36 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_37 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_37 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_38 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_38 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_39 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_39 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_40 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_40 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_41 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_41 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_42 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_42 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_43 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_43 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_44 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_44 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_45 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_45 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_46 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_46 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_47 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_47 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_48 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_48 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_49 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_49 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_50 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_50 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_51 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_51 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_52 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_52 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_53 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_53 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_54 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_54 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_55 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_55 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_56 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_56 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_57 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_57 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_58 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_58 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_59 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_59 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_60 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_60 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_61 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_61 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_62 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_62 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_63 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_63 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_64 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_64 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_65 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_65 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_66 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_66 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_67 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_67 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_68 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_68 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_69 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_69 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_70 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_70 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_71 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_71 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_72 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_72 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_73 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_73 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_74 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_74 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_75 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_75 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_76 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_76 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_77 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_77 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_78 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_78 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_79 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_79 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_80 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_80 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_81 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_81 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_82 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_82 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_83 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_83 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_84 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_84 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_85 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_85 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_86 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_86 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_87 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_87 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_88 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_88 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_89 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_89 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_90 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_90 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_91 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_91 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_92 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_92 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_93 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_93 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_94 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_94 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_95 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_95 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_96 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_96 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_97 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_97 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_98 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_98 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_99 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_99 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_100 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_100 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_101 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_101 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_102 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_102 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_103 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_103 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_104 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_104 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_105 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_105 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_106 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_106 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_107 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_107 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_108 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_108 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_109 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_109 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_110 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_110 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_111 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_111 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_112 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_112 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_113 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_113 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_114 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_114 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_115 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_115 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_116 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_116 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_117 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_117 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_118 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_118 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_119 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_119 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;component layer1_FCneuron_120 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L1fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer1_FCneuron_120 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L1fc+weight_size_L1fc + n_extra_bits-1 downto 0));
end component ;
--Activation function for each layer
component sigmoidFCL1 is
	Port ( 
		data_in : in std_logic_vector(input_size_L1fc-1 downto 0); 
		data_out : out std_logic_vector(input_size_L1fc-1 downto 0));
end component;
component VOT_sigmoidFCL1 is
	Port ( 
		data_out_1 : in std_logic_vector(input_size_L1fc-1 downto 0);
		data_out_2 : in std_logic_vector(input_size_L1fc-1 downto 0);
		data_out_3 : in std_logic_vector(input_size_L1fc-1 downto 0);
		data_out_v : out std_logic_vector(input_size_L1fc-1 downto 0));
end component;
---Layer 2 Modules
component Register_FCL2 is
Port ( data_in : in vector_L2fc_activations(0 to number_of_inputs_L3fc-1);
       clk : in std_logic;
       rst : in std_logic;
       next_pipeline_step : in std_logic;
       data_out : out vector_L2fc_activations(0 to number_of_inputs_L3fc-1));
end component;
component VOT_Register_FCL2 is
Port ( 
       data_out_1 : in vector_L2fc_activations(0 to number_of_inputs_L3fc-1);
       data_out_2 : in vector_L2fc_activations(0 to number_of_inputs_L3fc-1);
       data_out_3 : in vector_L2fc_activations(0 to number_of_inputs_L3fc-1);
       data_out_v : out vector_L2fc_activations(0 to number_of_inputs_L3fc-1));
end component;
component Mux_FCL2 is
Port ( data_in : in vector_L2fc_activations(0 to number_of_inputs_L3fc-1);
       ctrl : in std_logic_vector(log2c(number_of_outputs_L2fc) - 1 downto 0 );
       mac_max : in signed (input_size_L3fc+weight_size_L3fc+n_extra_bits-1 downto 0);
       mac_min : in signed (input_size_L3fc+weight_size_L3fc+n_extra_bits-1 downto 0);
       data_out : out std_logic_vector(input_size_L3fc-1 downto 0));
end component;
-- Layer 2 neurons declaration --
--component layer2_FCneuron_1 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_2 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_3 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_4 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_5 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_6 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_7 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_8 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_9 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_10 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_11 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_12 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_13 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_14 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_15 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_16 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_17 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_18 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_19 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_20 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_21 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_22 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_23 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_24 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_25 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_26 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_27 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_28 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_29 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_30 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_31 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_32 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_33 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_34 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_35 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_36 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_37 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_38 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_39 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_40 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_41 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_42 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_43 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_44 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_45 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_46 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_47 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_48 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_49 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_50 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_51 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_52 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_53 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_54 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_55 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_56 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_57 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_58 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_59 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_60 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_61 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_62 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_63 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_64 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_65 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_66 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_67 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_68 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_69 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_70 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_71 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_72 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_73 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_74 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_75 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_76 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_77 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_78 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_79 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_80 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_81 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_82 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_83 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;component layer2_FCneuron_84 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
--end component ;
component layer2_FCneuron_1 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_1 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_2 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_2 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_3 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_3 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_4 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_4 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_5 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_5 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_6 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_6 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_7 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_7 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_8 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_8 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_9 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_9 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_10 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_10 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_11 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_11 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_12 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_12 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_13 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_13 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_14 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_14 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_15 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_15 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_16 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_16 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_17 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_17 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_18 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_18 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_19 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_19 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_20 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_20 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_21 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_21 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_22 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_22 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_23 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_23 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_24 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_24 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_25 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_25 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_26 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_26 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_27 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_27 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_28 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_28 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_29 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_29 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_30 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_30 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_31 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_31 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_32 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_32 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_33 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_33 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_34 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_34 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_35 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_35 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_36 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_36 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_37 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_37 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_38 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_38 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_39 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_39 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_40 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_40 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_41 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_41 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_42 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_42 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_43 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_43 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_44 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_44 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_45 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_45 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_46 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_46 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_47 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_47 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_48 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_48 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_49 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_49 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_50 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_50 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_51 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_51 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_52 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_52 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_53 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_53 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_54 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_54 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_55 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_55 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_56 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_56 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_57 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_57 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_58 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_58 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_59 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_59 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_60 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_60 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_61 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_61 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_62 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_62 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_63 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_63 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_64 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_64 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_65 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_65 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_66 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_66 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_67 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_67 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_68 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_68 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_69 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_69 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_70 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_70 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_71 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_71 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_72 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_72 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_73 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_73 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_74 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_74 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_75 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_75 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_76 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_76 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_77 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_77 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_78 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_78 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_79 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_79 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_80 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_80 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_81 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_81 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_82 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_82 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_83 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_83 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;component layer2_FCneuron_84 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L2fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer2_FCneuron_84 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L2fc+weight_size_L2fc + n_extra_bits-1 downto 0));
end component ;
--Activation function for each layer
component sigmoidFCL2 is
	Port ( 
		data_in : in std_logic_vector(input_size_L2fc-1 downto 0); 
		data_out : out std_logic_vector(input_size_L2fc-1 downto 0));
end component;
component VOT_sigmoidFCL2 is
	Port ( 
		data_out_1 : in std_logic_vector(input_size_L2fc-1 downto 0);
		data_out_2 : in std_logic_vector(input_size_L2fc-1 downto 0);
		data_out_3 : in std_logic_vector(input_size_L2fc-1 downto 0);
		data_out_v : out std_logic_vector(input_size_L2fc-1 downto 0));
end component;

---Layer 3 Modules
component Register_FCL3 is
Port ( data_in : in vector_L3fc_activations(0 to number_of_inputs_L4fc-1);
       clk : in std_logic;
       rst : in std_logic;
       next_pipeline_step : in std_logic;
       data_out : out vector_L3fc_activations(0 to number_of_inputs_L4fc-1));
end component;
component VOT_Register_FCL3 is
Port ( 
       data_out_1 : in vector_L3fc_activations(0 to number_of_inputs_L4fc-1);
       data_out_2 : in vector_L3fc_activations(0 to number_of_inputs_L4fc-1);
       data_out_3 : in vector_L3fc_activations(0 to number_of_inputs_L4fc-1);
       data_out_v : out vector_L3fc_activations(0 to number_of_inputs_L4fc-1));
end component;
component Mux_FCL3 is
Port ( data_in : in vector_L3fc_activations(0 to number_of_inputs_L4fc-1);
       ctrl : in std_logic_vector(log2c(number_of_outputs_L3fc) - 1 downto 0 );
       mac_max : in signed (input_size_L4fc+weight_size_L4fc+n_extra_bits-1 downto 0);
       mac_min : in signed (input_size_L4fc+weight_size_L4fc+n_extra_bits-1 downto 0);
       data_out : out std_logic_vector(input_size_L4fc-1 downto 0));
end component;
-- Layer 3 neurons declaration --
--component layer3_FCneuron_1 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_2 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_3 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_4 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_5 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_6 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_7 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_8 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_9 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;component layer3_FCneuron_10 is
--	Port ( clk : in std_logic;
--		rst : in std_logic;
--		data_in_bit : in std_logic;
--		next_pipeline_step : in std_logic;
--		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
--		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
--		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
--end component ;
component layer3_FCneuron_1 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_1 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_2 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_2 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_3 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_3 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_4 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_4 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_5 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_5 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_6 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_6 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_7 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_7 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_8 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_8 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_9 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_9 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;component layer3_FCneuron_10 is
	Port ( clk : in std_logic;
		rst : in std_logic;
		data_in_bit : in std_logic;
		next_pipeline_step : in std_logic;
		bit_select : in unsigned (log2c(input_size_L3fc)-1 downto 0);
		rom_addr : in std_logic_vector(log2c(biggest_ROM_size) - 1 downto 0);
		neuron_mac : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
component VOT_layer3_FCneuron_10 is
	Port ( 
		 neuron_mac_1 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_2 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_3 : in std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0);
		 neuron_mac_v : out std_logic_vector(input_size_L3fc+weight_size_L3fc + n_extra_bits-1 downto 0));
end component ;
--Softmax Layer
component exponential is
Port (  data_in : in std_logic_vector (input_size_L4fc-1 downto 0);
        data_out : out std_logic_vector (input_size_L4fc-1 downto 0));
end component;
component VOT_exponential is
Port (  
        data_out_1 : in std_logic_vector (input_size_L4fc-1 downto 0);
        data_out_2 : in std_logic_vector (input_size_L4fc-1 downto 0);
        data_out_3 : in std_logic_vector (input_size_L4fc-1 downto 0);
        data_out_v : out std_logic_vector (input_size_L4fc-1 downto 0));
end component;
component Reg_softmax_1 is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       data_in : in std_logic_vector(input_size_L4fc - 1 downto 0);
       index : in unsigned(log2c(number_of_outputs_L4fc) - 1 downto 0 );
       data_out : out vector_sm(number_of_outputs_L4fc - 1 downto 0));
end component;
component VOT_Reg_softmax_1 is
Port ( 
       data_out_1 : in vector_sm(number_of_outputs_L4fc - 1 downto 0);
       data_out_2 : in vector_sm(number_of_outputs_L4fc - 1 downto 0);
       data_out_3 : in vector_sm(number_of_outputs_L4fc - 1 downto 0);
       data_out_v : out vector_sm(number_of_outputs_L4fc - 1 downto 0));
end component;
component inverse is
Port ( data_in : in std_logic_vector (input_size_L4fc-1 downto 0);
       data_out : out std_logic_vector (input_size_L4fc-1 downto 0)
    );
end component;
component VOT_inverse is
Port ( 
       data_out_1 : in std_logic_vector (input_size_L4fc-1 downto 0);
       data_out_2 : in std_logic_vector (input_size_L4fc-1 downto 0);
       data_out_3 : in std_logic_vector (input_size_L4fc-1 downto 0);
       data_out_v : out std_logic_vector (input_size_L4fc-1 downto 0)
    );
end component;
component Reg_softmax_2 is
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       data_in : in std_logic_vector(input_size_L4fc - 1 downto 0);
       reg_Sm : in std_logic;
       data_out : out std_logic_vector(input_size_L4fc - 1 downto 0) 
);
end component;
component VOT_Reg_softmax_2 is
Port (  
       data_out_1 : in std_logic_vector(input_size_L4fc - 1 downto 0); 
       data_out_2 : in std_logic_vector(input_size_L4fc - 1 downto 0); 
       data_out_3 : in std_logic_vector(input_size_L4fc - 1 downto 0); 
       data_out_v : out std_logic_vector(input_size_L4fc - 1 downto 0) 
);
end component;

component sum is
Port (  clk : in std_logic;
        rst : in std_logic;
        data_in_bit : in std_logic;
        next_pipeline_step : in std_logic;
        bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
        neuron_mac : out std_logic_vector (input_size_L4fc-1 downto 0)
    );
end component;
component VOT_sum is
Port (  
        neuron_mac_1 : in std_logic_vector (input_size_L4fc-1 downto 0);
        neuron_mac_2 : in std_logic_vector (input_size_L4fc-1 downto 0);
        neuron_mac_3 : in std_logic_vector (input_size_L4fc-1 downto 0);
        neuron_mac_v : out std_logic_vector (input_size_L4fc-1 downto 0)
    );
end component;

-- Softmax layer Neurons declaration --
--component layer_out_neuron_1 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_2 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_3 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_4 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_5 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_6 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_7 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_8 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_9 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;component layer_out_neuron_10 is
--	Port ( clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		data_in_bit : in STD_LOGIC;
--		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
--		weight : in signed(input_size_L4fc-1 downto 0);
--		next_pipeline_step : in std_logic;
--		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
--end component;
component layer_out_neuron_1 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_1 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_2 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_2 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_3 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_3 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_4 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_4 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_5 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_5 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_6 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_6 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_7 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_7 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_8 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_8 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_9 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_9 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;component layer_out_neuron_10 is
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		data_in_bit : in STD_LOGIC;
		bit_select : in unsigned (log2c(input_size_L4fc)-1 downto 0);
		weight : in signed(input_size_L4fc-1 downto 0);
		next_pipeline_step : in std_logic;
		neuron_mac : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
component VOT_layer_out_neuron_10 is
	Port ( 
		 neuron_mac_1 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_2 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_3 : in STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0);
		 neuron_mac_v : out STD_LOGIC_VECTOR (input_size_L4fc-1 downto 0));
end component;
-- Last register and threshold function
component Register_FCLast is
	Port ( 
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		next_pipeline_step : in STD_LOGIC;
		data_in : in vector_sm(0 to number_of_outputs_L4fc-1);
		start_threshold : out std_logic;
		data_out : out vector_sm_signed(0 to number_of_outputs_L4fc-1));
end component;

component VOT_Register_FCLast is
	Port ( 
		 start_threshold_1 : in std_logic;
		 data_out_1 : in vector_sm_signed(0 to number_of_outputs_L4fc-1);
		 start_threshold_2 : in std_logic;
		 data_out_2 : in vector_sm_signed(0 to number_of_outputs_L4fc-1);
		 start_threshold_3 : in std_logic;
		 data_out_3 : in vector_sm_signed(0 to number_of_outputs_L4fc-1);
		 start_threshold : out std_logic;
		 data_out : out vector_sm_signed(0 to number_of_outputs_L4fc-1));
end component;

component threshold is
	Port ( clk : std_logic;
	      rst : std_logic;
	      y_in : in vector_sm_signed(0 to number_of_outputs_L4fc-1);
	      start : in std_logic;
	      y_out : out unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish : out std_logic);
end component;
component VOT_threshold is
	Port ( 
	      y_out_1 : in unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish_1 : in std_logic;
	      y_out_2 : in unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish_2 : in std_logic;
	      y_out_3 : in unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish_3 : in std_logic;
	      y_out : out unsigned(log2c(number_of_outputs_L4fc) -1 downto 0);
	      finish : out std_logic);
end component;

--------------AUXILIARY SIGNALS-------------------
-- GLOBAL SIGNALS --
--signal bit_select :  unsigned (log2c(input_size_L1fc)-1 downto 0);
--signal rom_addr_FC: STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);
--signal rom_addr_Sm : std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
--signal next_pipeline_step, enable_lastlayer, en_neuron :  STD_LOGIC;

---- LAYER 1 SIGNALS --
--signal data_in_register_L1 : vector_L1FC(0 to number_of_inputs-1);
--signal bit_selected_L1, data_inL1 : STD_LOGIC := '0';
--signal ctrl_muxL1 : std_logic_vector(log2c(number_of_outputs_L1fc) - 1 downto 0 );
--signal layer_1_neurons_mac : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
--signal data_out_register_L1 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
--signal data_out_multiplexer_L1, data_in_L2: STD_LOGIC_VECTOR(input_size_L2fc-1 downto 0);
---- Signs with the maximum and maximum values that neuron_mac can take --
--signal mac_max_L1, mac_min_L1 : signed (input_size_L2fc+weight_size_L2fc+n_extra_bits-1 downto 0) := (others => '0');
---- LAYER 2 SIGNALS --
--signal data_in_register_L2 : vector_L2FC(0 to number_of_inputs-1);
--signal bit_selected_L2, data_inL2 : STD_LOGIC := '0';
--signal ctrl_muxL2 : std_logic_vector(log2c(number_of_outputs_L2fc) - 1 downto 0 );
--signal layer_2_neurons_mac : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
--signal data_out_register_L2 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
--signal data_out_multiplexer_L2, data_in_L3: STD_LOGIC_VECTOR(input_size_L3fc-1 downto 0);
---- Signs with the maximum and maximum values that neuron_mac can take --
--signal mac_max_L2, mac_min_L2 : signed (input_size_L3fc+weight_size_L3fc+n_extra_bits-1 downto 0) := (others => '0');
---- LAYER 3 SIGNALS --
--signal data_in_register_L3 : vector_L3FC(0 to number_of_inputs-1);
--signal bit_selected_L3, data_inL3 : STD_LOGIC := '0';
--signal ctrl_muxL3 : std_logic_vector(log2c(number_of_outputs_L3fc) - 1 downto 0 );
--signal layer_3_neurons_mac : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
--signal data_out_register_L3 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
--signal data_out_multiplexer_L3, data_in_L4: STD_LOGIC_VECTOR(input_size_L4fc-1 downto 0);
---- Signs with the maximum and maximum values that neuron_mac can take --
--signal mac_max_L3, mac_min_L3 : signed (input_size_L4fc+weight_size_L4fc+n_extra_bits-1 downto 0) := (others => '0');

----SOFTMAX SIGNALS
--signal data_out_exponential, data_in_inverse, inverse_result,data_inverse_reg, sum_expo, data_in_sum : std_logic_vector(input_size_L4fc - 1 downto 0);
--signal bit_selected_sum,sum_finish, bit_selected_softmax, start_th, exp_Sm, inv_Sm : std_logic;
--signal data_in_softmax : vector_sm(number_of_inputs_L4fc - 1 downto 0);
---- OUTER LAYER SIGNALS --
--signal layer_out_neurons_mac : vector_sm(0 to number_of_outputs_L4fc - 1);
--signal data_out_register_L_out : vector_sm_signed(0 to number_of_outputs_L4fc - 1);
--------------AUXILIARY SIGNALS-------------------
-- GLOBAL SIGNALS --
signal bit_select_1 :  unsigned (log2c(input_size_L1fc)-1 downto 0);
signal rom_addr_FC_1: STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);
signal rom_addr_Sm_1 : std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
signal next_pipeline_step_1, enable_lastlayer_1, en_neuron_1 :  STD_LOGIC;
signal bit_select_2 :  unsigned (log2c(input_size_L1fc)-1 downto 0);
signal rom_addr_FC_2: STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);
signal rom_addr_Sm_2 : std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
signal next_pipeline_step_2, enable_lastlayer_2, en_neuron_2 :  STD_LOGIC;
signal bit_select_3 :  unsigned (log2c(input_size_L1fc)-1 downto 0);
signal rom_addr_FC_3: STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);
signal rom_addr_Sm_3 : std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
signal next_pipeline_step_3, enable_lastlayer_3, en_neuron_3 :  STD_LOGIC;
signal bit_select :  unsigned (log2c(input_size_L1fc)-1 downto 0);
signal rom_addr_FC: STD_LOGIC_VECTOR (log2c(biggest_ROM_size)-1 downto 0);
signal rom_addr_Sm : std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0 );
signal next_pipeline_step, enable_lastlayer, en_neuron :  STD_LOGIC;

-- LAYER 1 SIGNALS --
signal bit_selected_L1_1 : STD_LOGIC := '0';
signal layer_1_neurons_mac_1 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_register_L1_1 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_multiplexer_L1_1, data_in_L2_1: STD_LOGIC_VECTOR(input_size_L2fc-1 downto 0);
signal bit_selected_L1_2 : STD_LOGIC := '0';
signal layer_1_neurons_mac_2 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_register_L1_2 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_multiplexer_L1_2, data_in_L2_2: STD_LOGIC_VECTOR(input_size_L2fc-1 downto 0);
signal bit_selected_L1_3 : STD_LOGIC := '0';
signal layer_1_neurons_mac_3 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_register_L1_3 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_multiplexer_L1_3, data_in_L2_3: STD_LOGIC_VECTOR(input_size_L2fc-1 downto 0);
signal data_in_register_L1 : vector_L1FC(0 to number_of_inputs-1);
signal bit_selected_L1, data_inL1 : STD_LOGIC := '0';
signal ctrl_muxL1 : std_logic_vector(log2c(number_of_outputs_L1fc) - 1 downto 0 );
signal layer_1_neurons_mac : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_register_L1 : vector_L1FC_activations(0 to number_of_inputs_L2fc - 1);
signal data_out_multiplexer_L1, data_in_L2: STD_LOGIC_VECTOR(input_size_L2fc-1 downto 0);
-- Signs with the maximum and maximum values that neuron_mac can take --
signal mac_max_L1, mac_min_L1 : signed (input_size_L2fc+weight_size_L2fc+n_extra_bits-1 downto 0) := (others => '0');
-- LAYER 2 SIGNALS --
signal bit_selected_L2_1 : STD_LOGIC := '0';
signal layer_2_neurons_mac_1 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_register_L2_1 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_multiplexer_L2_1, data_in_L3_1: STD_LOGIC_VECTOR(input_size_L3fc-1 downto 0);
signal bit_selected_L2_2 : STD_LOGIC := '0';
signal layer_2_neurons_mac_2 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_register_L2_2 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_multiplexer_L2_2, data_in_L3_2: STD_LOGIC_VECTOR(input_size_L3fc-1 downto 0);
signal bit_selected_L2_3 : STD_LOGIC := '0';
signal layer_2_neurons_mac_3 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_register_L2_3 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_multiplexer_L2_3, data_in_L3_3: STD_LOGIC_VECTOR(input_size_L3fc-1 downto 0);
signal data_in_register_L2 : vector_L2FC(0 to number_of_inputs-1);
signal bit_selected_L2, data_inL2 : STD_LOGIC := '0';
signal ctrl_muxL2 : std_logic_vector(log2c(number_of_outputs_L2fc) - 1 downto 0 );
signal layer_2_neurons_mac : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_register_L2 : vector_L2FC_activations(0 to number_of_inputs_L3fc - 1);
signal data_out_multiplexer_L2, data_in_L3: STD_LOGIC_VECTOR(input_size_L3fc-1 downto 0);
-- Signs with the maximum and maximum values that neuron_mac can take --
signal mac_max_L2, mac_min_L2 : signed (input_size_L3fc+weight_size_L3fc+n_extra_bits-1 downto 0) := (others => '0');
-- LAYER 3 SIGNALS --
signal bit_selected_L3_1 : STD_LOGIC := '0';
signal layer_3_neurons_mac_1 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_register_L3_1 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_multiplexer_L3_1, data_in_L4_1: STD_LOGIC_VECTOR(input_size_L4fc-1 downto 0);
signal bit_selected_L3_2 : STD_LOGIC := '0';
signal layer_3_neurons_mac_2 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_register_L3_2 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_multiplexer_L3_2, data_in_L4_2: STD_LOGIC_VECTOR(input_size_L4fc-1 downto 0);
signal bit_selected_L3_3 : STD_LOGIC := '0';
signal layer_3_neurons_mac_3 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_register_L3_3 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_multiplexer_L3_3, data_in_L4_3: STD_LOGIC_VECTOR(input_size_L4fc-1 downto 0);
signal data_in_register_L3 : vector_L3FC(0 to number_of_inputs-1);
signal bit_selected_L3, data_inL3 : STD_LOGIC := '0';
signal ctrl_muxL3 : std_logic_vector(log2c(number_of_outputs_L3fc) - 1 downto 0 );
signal layer_3_neurons_mac : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_register_L3 : vector_L3FC_activations(0 to number_of_inputs_L4fc - 1);
signal data_out_multiplexer_L3, data_in_L4: STD_LOGIC_VECTOR(input_size_L4fc-1 downto 0);
-- Signs with the maximum and maximum values that neuron_mac can take --
signal mac_max_L3, mac_min_L3 : signed (input_size_L4fc+weight_size_L4fc+n_extra_bits-1 downto 0) := (others => '0');

--SOFTMAX SIGNALS
signal data_out_exponential_1, inverse_result_1,data_inverse_reg_1, sum_expo_1, data_in_sum_1 : std_logic_vector(input_size_L4fc - 1 downto 0);
signal bit_selected_sum_1,sum_finish_1, bit_selected_softmax_1, start_th_1, exp_Sm_1, inv_Sm_1 : std_logic;
signal data_in_softmax_1 : vector_sm(number_of_inputs_L4fc - 1 downto 0);
signal layer_out_neurons_mac_1 : vector_sm(0 to number_of_outputs_L4fc - 1);
signal data_out_register_L_out_1 : vector_sm_signed(0 to number_of_outputs_L4fc - 1);
signal data_out_exponential_2, inverse_result_2,data_inverse_reg_2, sum_expo_2, data_in_sum_2 : std_logic_vector(input_size_L4fc - 1 downto 0);
signal bit_selected_sum_2,sum_finish_2, bit_selected_softmax_2, start_th_2, exp_Sm_2, inv_Sm_2 : std_logic;
signal data_in_softmax_2 : vector_sm(number_of_inputs_L4fc - 1 downto 0);
signal layer_out_neurons_mac_2 : vector_sm(0 to number_of_outputs_L4fc - 1);
signal data_out_register_L_out_2 : vector_sm_signed(0 to number_of_outputs_L4fc - 1);
signal data_out_exponential_3, inverse_result_3,data_inverse_reg_3, sum_expo_3, data_in_sum_3 : std_logic_vector(input_size_L4fc - 1 downto 0);
signal bit_selected_sum_3,sum_finish_3, bit_selected_softmax_3, start_th_3, exp_Sm_3, inv_Sm_3 : std_logic;
signal data_in_softmax_3 : vector_sm(number_of_inputs_L4fc - 1 downto 0);
signal layer_out_neurons_mac_3 : vector_sm(0 to number_of_outputs_L4fc - 1);
signal data_out_register_L_out_3 : vector_sm_signed(0 to number_of_outputs_L4fc - 1);
signal data_out_exponential, data_in_inverse, inverse_result,data_inverse_reg, sum_expo, data_in_sum : std_logic_vector(input_size_L4fc - 1 downto 0);
signal bit_selected_sum,sum_finish, bit_selected_softmax, start_th, exp_Sm, inv_Sm : std_logic;
signal data_in_softmax : vector_sm(number_of_inputs_L4fc - 1 downto 0);
-- OUTER LAYER SIGNALS --
signal layer_out_neurons_mac : vector_sm(0 to number_of_outputs_L4fc - 1);
signal data_out_register_L_out : vector_sm_signed(0 to number_of_outputs_L4fc - 1);
signal y_1 : unsigned(log2c(number_of_outputs_L4fc) - 1 downto 0);
signal finish_1,data_fc_1 : std_logic;
signal y_2 : unsigned(log2c(number_of_outputs_L4fc) - 1 downto 0);
signal finish_2,data_fc_2 : std_logic;
signal y_3 : unsigned(log2c(number_of_outputs_L4fc) - 1 downto 0);
signal finish_3,data_fc_3 : std_logic;
begin

--Generates the control signal to manage the complete FC network
--ENABLE : enable_generator
--port map ( clk => clk,
--           rst => rst,
--           rst_red => rst_red,
--           start_enable => start_enable,
--           bit_select => bit_select,
--           en_neuron => en_neuron,
--           sum_finish => sum_finish,
--           data_fc => data_fc,
--           addr_FC => rom_addr_FC,
--           addr_Sm => rom_addr_Sm,
--           exp_Sm => exp_Sm,
--           inv_Sm => inv_Sm,
--           enable_lastlayer => enable_lastlayer,
--           next_pipeline_step => next_pipeline_step);
ENABLE_1 : enable_generator
port map ( clk => clk,
           rst => rst,
           rst_red => rst_red,
           start_enable => start_enable,
           bit_select => bit_select_1,
           en_neuron => en_neuron_1,
           sum_finish => sum_finish_1,
           data_fc => data_fc_1,
           addr_FC => rom_addr_FC_1,
           addr_Sm => rom_addr_Sm_1,
           exp_Sm => exp_Sm_1,
           inv_Sm => inv_Sm_1,
           enable_lastlayer => enable_lastlayer_1,
           next_pipeline_step => next_pipeline_step_1);

ENABLE_2 : enable_generator
port map ( clk => clk,
           rst => rst,
           rst_red => rst_red,
           start_enable => start_enable,
           bit_select => bit_select_2,
           en_neuron => en_neuron_2,
           sum_finish => sum_finish_2,
           data_fc => data_fc_2,
           addr_FC => rom_addr_FC_2,
           addr_Sm => rom_addr_Sm_2,
           exp_Sm => exp_Sm_2,
           inv_Sm => inv_Sm_2,
           enable_lastlayer => enable_lastlayer_2,
           next_pipeline_step => next_pipeline_step_2);

ENABLE_3 : enable_generator
port map ( clk => clk,
           rst => rst,
           rst_red => rst_red,
           start_enable => start_enable,
           bit_select => bit_select_3,
           en_neuron => en_neuron_3,
           sum_finish => sum_finish_3,
           data_fc => data_fc_3,
           addr_FC => rom_addr_FC_3,
           addr_Sm => rom_addr_Sm_3,
           exp_Sm => exp_Sm_3,
           inv_Sm => inv_Sm_3,
           enable_lastlayer => enable_lastlayer_3,
           next_pipeline_step => next_pipeline_step_3);

VOT_ENABLE : VOT_enable_generator
port map ( 
           data_fc_1 => data_fc_1,
           en_neuron_1 => en_neuron_1,
           addr_FC_1 => rom_addr_FC_1,
           bit_select_1 => bit_select_1,
           next_pipeline_step_1 => next_pipeline_step_1,
           addr_Sm_1 => rom_addr_Sm_1,
           exp_Sm_1 => exp_Sm_1,
           inv_Sm_1 => inv_Sm_1,
           sum_finish_1 => sum_finish_1,
           enable_lastlayer_1 => enable_lastlayer_1,
           data_fc_2 => data_fc_2,
           en_neuron_2 => en_neuron_2,
           addr_FC_2 => rom_addr_FC_2,
           bit_select_2 => bit_select_2,
           next_pipeline_step_2 => next_pipeline_step_2,
           addr_Sm_2 => rom_addr_Sm_2,
           exp_Sm_2 => exp_Sm_2,
           inv_Sm_2 => inv_Sm_2,
           sum_finish_2 => sum_finish_2,
           enable_lastlayer_2 => enable_lastlayer_2,
           data_fc_3 => data_fc_3,
           en_neuron_3 => en_neuron_3,
           addr_FC_3 => rom_addr_FC_3,
           bit_select_3 => bit_select_3,
           next_pipeline_step_3 => next_pipeline_step_3,
           addr_Sm_3 => rom_addr_Sm_3,
           exp_Sm_3 => exp_Sm_3,
           inv_Sm_3 => inv_Sm_3,
           sum_finish_3 => sum_finish_3,
           enable_lastlayer_3 => enable_lastlayer_3,
           data_fc => data_fc,
           en_neuron => en_neuron,
           addr_FC => rom_addr_FC,
           bit_select => bit_select,
           next_pipeline_step => next_pipeline_step,
           addr_Sm => rom_addr_Sm,
           exp_Sm => exp_Sm,
           inv_Sm => inv_Sm,
           sum_finish => sum_finish,
           enable_lastlayer => enable_lastlayer);
--Conversion of the input data from the CNN from parallel to serial, we need to use PAR2SER instead of BitMux because the influx of data is not constant
--PAR2SER_L1: PAR2SER
--generic map (input_size => input_size_L1fc)
--port map ( clk => clk,
--           rst => rst,
--           data_in => x,
--           en_neuron => en_neuron,
--           bit_select => bit_select,
--           bit_out => bit_selected_L1);
PAR2SER_L1_1: PAR2SER
generic map (input_size => input_size_L1fc)
port map ( clk => clk,
           rst => rst,
           data_in => x,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L1_1);

PAR2SER_L1_2: PAR2SER
generic map (input_size => input_size_L1fc)
port map ( clk => clk,
           rst => rst,
           data_in => x,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L1_2);

PAR2SER_L1_3: PAR2SER
generic map (input_size => input_size_L1fc)
port map ( clk => clk,
           rst => rst,
           data_in => x,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L1_3);

VOT_PAR2SER_L1: VOT_PAR2SER 
port map ( 
		 serial_out_1 => bit_selected_L1_1,
		 serial_out_2 => bit_selected_L1_2,
		 serial_out_3 => bit_selected_L1_3,
		 serial_out_v => bit_selected_L1);
--Data is sent from the parallel to serial converter when en_neuron = 1 and the neurons can process it
 data_inL1 <= bit_selected_L1 when (en_neuron = '1') else '0';
-- Layer 1 Neurons instantiation
--LAYER_1_NEU_1: layer1_FCneuron_1
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(0));
--LAYER_1_NEU_2: layer1_FCneuron_2
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(1));
--LAYER_1_NEU_3: layer1_FCneuron_3
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(2));
--LAYER_1_NEU_4: layer1_FCneuron_4
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(3));
--LAYER_1_NEU_5: layer1_FCneuron_5
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(4));
--LAYER_1_NEU_6: layer1_FCneuron_6
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(5));
--LAYER_1_NEU_7: layer1_FCneuron_7
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(6));
--LAYER_1_NEU_8: layer1_FCneuron_8
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(7));
--LAYER_1_NEU_9: layer1_FCneuron_9
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(8));
--LAYER_1_NEU_10: layer1_FCneuron_10
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(9));
--LAYER_1_NEU_11: layer1_FCneuron_11
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(10));
--LAYER_1_NEU_12: layer1_FCneuron_12
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(11));
--LAYER_1_NEU_13: layer1_FCneuron_13
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(12));
--LAYER_1_NEU_14: layer1_FCneuron_14
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(13));
--LAYER_1_NEU_15: layer1_FCneuron_15
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(14));
--LAYER_1_NEU_16: layer1_FCneuron_16
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(15));
--LAYER_1_NEU_17: layer1_FCneuron_17
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(16));
--LAYER_1_NEU_18: layer1_FCneuron_18
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(17));
--LAYER_1_NEU_19: layer1_FCneuron_19
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(18));
--LAYER_1_NEU_20: layer1_FCneuron_20
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(19));
--LAYER_1_NEU_21: layer1_FCneuron_21
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(20));
--LAYER_1_NEU_22: layer1_FCneuron_22
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(21));
--LAYER_1_NEU_23: layer1_FCneuron_23
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(22));
--LAYER_1_NEU_24: layer1_FCneuron_24
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(23));
--LAYER_1_NEU_25: layer1_FCneuron_25
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(24));
--LAYER_1_NEU_26: layer1_FCneuron_26
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(25));
--LAYER_1_NEU_27: layer1_FCneuron_27
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(26));
--LAYER_1_NEU_28: layer1_FCneuron_28
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(27));
--LAYER_1_NEU_29: layer1_FCneuron_29
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(28));
--LAYER_1_NEU_30: layer1_FCneuron_30
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(29));
--LAYER_1_NEU_31: layer1_FCneuron_31
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(30));
--LAYER_1_NEU_32: layer1_FCneuron_32
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(31));
--LAYER_1_NEU_33: layer1_FCneuron_33
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(32));
--LAYER_1_NEU_34: layer1_FCneuron_34
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(33));
--LAYER_1_NEU_35: layer1_FCneuron_35
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(34));
--LAYER_1_NEU_36: layer1_FCneuron_36
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(35));
--LAYER_1_NEU_37: layer1_FCneuron_37
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(36));
--LAYER_1_NEU_38: layer1_FCneuron_38
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(37));
--LAYER_1_NEU_39: layer1_FCneuron_39
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(38));
--LAYER_1_NEU_40: layer1_FCneuron_40
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(39));
--LAYER_1_NEU_41: layer1_FCneuron_41
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(40));
--LAYER_1_NEU_42: layer1_FCneuron_42
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(41));
--LAYER_1_NEU_43: layer1_FCneuron_43
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(42));
--LAYER_1_NEU_44: layer1_FCneuron_44
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(43));
--LAYER_1_NEU_45: layer1_FCneuron_45
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(44));
--LAYER_1_NEU_46: layer1_FCneuron_46
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(45));
--LAYER_1_NEU_47: layer1_FCneuron_47
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(46));
--LAYER_1_NEU_48: layer1_FCneuron_48
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(47));
--LAYER_1_NEU_49: layer1_FCneuron_49
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(48));
--LAYER_1_NEU_50: layer1_FCneuron_50
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(49));
--LAYER_1_NEU_51: layer1_FCneuron_51
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(50));
--LAYER_1_NEU_52: layer1_FCneuron_52
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(51));
--LAYER_1_NEU_53: layer1_FCneuron_53
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(52));
--LAYER_1_NEU_54: layer1_FCneuron_54
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(53));
--LAYER_1_NEU_55: layer1_FCneuron_55
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(54));
--LAYER_1_NEU_56: layer1_FCneuron_56
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(55));
--LAYER_1_NEU_57: layer1_FCneuron_57
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(56));
--LAYER_1_NEU_58: layer1_FCneuron_58
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(57));
--LAYER_1_NEU_59: layer1_FCneuron_59
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(58));
--LAYER_1_NEU_60: layer1_FCneuron_60
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(59));
--LAYER_1_NEU_61: layer1_FCneuron_61
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(60));
--LAYER_1_NEU_62: layer1_FCneuron_62
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(61));
--LAYER_1_NEU_63: layer1_FCneuron_63
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(62));
--LAYER_1_NEU_64: layer1_FCneuron_64
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(63));
--LAYER_1_NEU_65: layer1_FCneuron_65
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(64));
--LAYER_1_NEU_66: layer1_FCneuron_66
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(65));
--LAYER_1_NEU_67: layer1_FCneuron_67
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(66));
--LAYER_1_NEU_68: layer1_FCneuron_68
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(67));
--LAYER_1_NEU_69: layer1_FCneuron_69
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(68));
--LAYER_1_NEU_70: layer1_FCneuron_70
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(69));
--LAYER_1_NEU_71: layer1_FCneuron_71
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(70));
--LAYER_1_NEU_72: layer1_FCneuron_72
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(71));
--LAYER_1_NEU_73: layer1_FCneuron_73
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(72));
--LAYER_1_NEU_74: layer1_FCneuron_74
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(73));
--LAYER_1_NEU_75: layer1_FCneuron_75
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(74));
--LAYER_1_NEU_76: layer1_FCneuron_76
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(75));
--LAYER_1_NEU_77: layer1_FCneuron_77
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(76));
--LAYER_1_NEU_78: layer1_FCneuron_78
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(77));
--LAYER_1_NEU_79: layer1_FCneuron_79
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(78));
--LAYER_1_NEU_80: layer1_FCneuron_80
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(79));
--LAYER_1_NEU_81: layer1_FCneuron_81
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(80));
--LAYER_1_NEU_82: layer1_FCneuron_82
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(81));
--LAYER_1_NEU_83: layer1_FCneuron_83
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(82));
--LAYER_1_NEU_84: layer1_FCneuron_84
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(83));
--LAYER_1_NEU_85: layer1_FCneuron_85
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(84));
--LAYER_1_NEU_86: layer1_FCneuron_86
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(85));
--LAYER_1_NEU_87: layer1_FCneuron_87
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(86));
--LAYER_1_NEU_88: layer1_FCneuron_88
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(87));
--LAYER_1_NEU_89: layer1_FCneuron_89
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(88));
--LAYER_1_NEU_90: layer1_FCneuron_90
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(89));
--LAYER_1_NEU_91: layer1_FCneuron_91
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(90));
--LAYER_1_NEU_92: layer1_FCneuron_92
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(91));
--LAYER_1_NEU_93: layer1_FCneuron_93
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(92));
--LAYER_1_NEU_94: layer1_FCneuron_94
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(93));
--LAYER_1_NEU_95: layer1_FCneuron_95
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(94));
--LAYER_1_NEU_96: layer1_FCneuron_96
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(95));
--LAYER_1_NEU_97: layer1_FCneuron_97
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(96));
--LAYER_1_NEU_98: layer1_FCneuron_98
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(97));
--LAYER_1_NEU_99: layer1_FCneuron_99
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(98));
--LAYER_1_NEU_100: layer1_FCneuron_100
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(99));
--LAYER_1_NEU_101: layer1_FCneuron_101
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(100));
--LAYER_1_NEU_102: layer1_FCneuron_102
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(101));
--LAYER_1_NEU_103: layer1_FCneuron_103
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(102));
--LAYER_1_NEU_104: layer1_FCneuron_104
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(103));
--LAYER_1_NEU_105: layer1_FCneuron_105
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(104));
--LAYER_1_NEU_106: layer1_FCneuron_106
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(105));
--LAYER_1_NEU_107: layer1_FCneuron_107
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(106));
--LAYER_1_NEU_108: layer1_FCneuron_108
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(107));
--LAYER_1_NEU_109: layer1_FCneuron_109
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(108));
--LAYER_1_NEU_110: layer1_FCneuron_110
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(109));
--LAYER_1_NEU_111: layer1_FCneuron_111
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(110));
--LAYER_1_NEU_112: layer1_FCneuron_112
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(111));
--LAYER_1_NEU_113: layer1_FCneuron_113
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(112));
--LAYER_1_NEU_114: layer1_FCneuron_114
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(113));
--LAYER_1_NEU_115: layer1_FCneuron_115
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(114));
--LAYER_1_NEU_116: layer1_FCneuron_116
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(115));
--LAYER_1_NEU_117: layer1_FCneuron_117
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(116));
--LAYER_1_NEU_118: layer1_FCneuron_118
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(117));
--LAYER_1_NEU_119: layer1_FCneuron_119
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(118));
--LAYER_1_NEU_120: layer1_FCneuron_120
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => data_inL1,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_1_neurons_mac(119));
LAYER_1_NEU_1_1: layer1_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(0));
LAYER_1_NEU_1_2: layer1_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(0));
LAYER_1_NEU_1_3: layer1_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(0));
VOT_LAYER_1_NEU_1 : VOT_layer1_FCneuron_1 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(0),
		 neuron_mac_2 => layer_1_neurons_mac_2(0),
		 neuron_mac_3 => layer_1_neurons_mac_3(0),
		 neuron_mac_v => layer_1_neurons_mac(0));
LAYER_1_NEU_2_1: layer1_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(1));
LAYER_1_NEU_2_2: layer1_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(1));
LAYER_1_NEU_2_3: layer1_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(1));
VOT_LAYER_1_NEU_2 : VOT_layer1_FCneuron_2 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(1),
		 neuron_mac_2 => layer_1_neurons_mac_2(1),
		 neuron_mac_3 => layer_1_neurons_mac_3(1),
		 neuron_mac_v => layer_1_neurons_mac(1));
LAYER_1_NEU_3_1: layer1_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(2));
LAYER_1_NEU_3_2: layer1_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(2));
LAYER_1_NEU_3_3: layer1_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(2));
VOT_LAYER_1_NEU_3 : VOT_layer1_FCneuron_3 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(2),
		 neuron_mac_2 => layer_1_neurons_mac_2(2),
		 neuron_mac_3 => layer_1_neurons_mac_3(2),
		 neuron_mac_v => layer_1_neurons_mac(2));
LAYER_1_NEU_4_1: layer1_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(3));
LAYER_1_NEU_4_2: layer1_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(3));
LAYER_1_NEU_4_3: layer1_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(3));
VOT_LAYER_1_NEU_4 : VOT_layer1_FCneuron_4 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(3),
		 neuron_mac_2 => layer_1_neurons_mac_2(3),
		 neuron_mac_3 => layer_1_neurons_mac_3(3),
		 neuron_mac_v => layer_1_neurons_mac(3));
LAYER_1_NEU_5_1: layer1_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(4));
LAYER_1_NEU_5_2: layer1_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(4));
LAYER_1_NEU_5_3: layer1_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(4));
VOT_LAYER_1_NEU_5 : VOT_layer1_FCneuron_5 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(4),
		 neuron_mac_2 => layer_1_neurons_mac_2(4),
		 neuron_mac_3 => layer_1_neurons_mac_3(4),
		 neuron_mac_v => layer_1_neurons_mac(4));
LAYER_1_NEU_6_1: layer1_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(5));
LAYER_1_NEU_6_2: layer1_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(5));
LAYER_1_NEU_6_3: layer1_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(5));
VOT_LAYER_1_NEU_6 : VOT_layer1_FCneuron_6 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(5),
		 neuron_mac_2 => layer_1_neurons_mac_2(5),
		 neuron_mac_3 => layer_1_neurons_mac_3(5),
		 neuron_mac_v => layer_1_neurons_mac(5));
LAYER_1_NEU_7_1: layer1_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(6));
LAYER_1_NEU_7_2: layer1_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(6));
LAYER_1_NEU_7_3: layer1_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(6));
VOT_LAYER_1_NEU_7 : VOT_layer1_FCneuron_7 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(6),
		 neuron_mac_2 => layer_1_neurons_mac_2(6),
		 neuron_mac_3 => layer_1_neurons_mac_3(6),
		 neuron_mac_v => layer_1_neurons_mac(6));
LAYER_1_NEU_8_1: layer1_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(7));
LAYER_1_NEU_8_2: layer1_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(7));
LAYER_1_NEU_8_3: layer1_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(7));
VOT_LAYER_1_NEU_8 : VOT_layer1_FCneuron_8 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(7),
		 neuron_mac_2 => layer_1_neurons_mac_2(7),
		 neuron_mac_3 => layer_1_neurons_mac_3(7),
		 neuron_mac_v => layer_1_neurons_mac(7));
LAYER_1_NEU_9_1: layer1_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(8));
LAYER_1_NEU_9_2: layer1_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(8));
LAYER_1_NEU_9_3: layer1_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(8));
VOT_LAYER_1_NEU_9 : VOT_layer1_FCneuron_9 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(8),
		 neuron_mac_2 => layer_1_neurons_mac_2(8),
		 neuron_mac_3 => layer_1_neurons_mac_3(8),
		 neuron_mac_v => layer_1_neurons_mac(8));
LAYER_1_NEU_10_1: layer1_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(9));
LAYER_1_NEU_10_2: layer1_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(9));
LAYER_1_NEU_10_3: layer1_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(9));
VOT_LAYER_1_NEU_10 : VOT_layer1_FCneuron_10 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(9),
		 neuron_mac_2 => layer_1_neurons_mac_2(9),
		 neuron_mac_3 => layer_1_neurons_mac_3(9),
		 neuron_mac_v => layer_1_neurons_mac(9));
LAYER_1_NEU_11_1: layer1_FCneuron_11
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(10));
LAYER_1_NEU_11_2: layer1_FCneuron_11
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(10));
LAYER_1_NEU_11_3: layer1_FCneuron_11
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(10));
VOT_LAYER_1_NEU_11 : VOT_layer1_FCneuron_11 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(10),
		 neuron_mac_2 => layer_1_neurons_mac_2(10),
		 neuron_mac_3 => layer_1_neurons_mac_3(10),
		 neuron_mac_v => layer_1_neurons_mac(10));
LAYER_1_NEU_12_1: layer1_FCneuron_12
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(11));
LAYER_1_NEU_12_2: layer1_FCneuron_12
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(11));
LAYER_1_NEU_12_3: layer1_FCneuron_12
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(11));
VOT_LAYER_1_NEU_12 : VOT_layer1_FCneuron_12 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(11),
		 neuron_mac_2 => layer_1_neurons_mac_2(11),
		 neuron_mac_3 => layer_1_neurons_mac_3(11),
		 neuron_mac_v => layer_1_neurons_mac(11));
LAYER_1_NEU_13_1: layer1_FCneuron_13
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(12));
LAYER_1_NEU_13_2: layer1_FCneuron_13
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(12));
LAYER_1_NEU_13_3: layer1_FCneuron_13
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(12));
VOT_LAYER_1_NEU_13 : VOT_layer1_FCneuron_13 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(12),
		 neuron_mac_2 => layer_1_neurons_mac_2(12),
		 neuron_mac_3 => layer_1_neurons_mac_3(12),
		 neuron_mac_v => layer_1_neurons_mac(12));
LAYER_1_NEU_14_1: layer1_FCneuron_14
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(13));
LAYER_1_NEU_14_2: layer1_FCneuron_14
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(13));
LAYER_1_NEU_14_3: layer1_FCneuron_14
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(13));
VOT_LAYER_1_NEU_14 : VOT_layer1_FCneuron_14 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(13),
		 neuron_mac_2 => layer_1_neurons_mac_2(13),
		 neuron_mac_3 => layer_1_neurons_mac_3(13),
		 neuron_mac_v => layer_1_neurons_mac(13));
LAYER_1_NEU_15_1: layer1_FCneuron_15
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(14));
LAYER_1_NEU_15_2: layer1_FCneuron_15
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(14));
LAYER_1_NEU_15_3: layer1_FCneuron_15
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(14));
VOT_LAYER_1_NEU_15 : VOT_layer1_FCneuron_15 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(14),
		 neuron_mac_2 => layer_1_neurons_mac_2(14),
		 neuron_mac_3 => layer_1_neurons_mac_3(14),
		 neuron_mac_v => layer_1_neurons_mac(14));
LAYER_1_NEU_16_1: layer1_FCneuron_16
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(15));
LAYER_1_NEU_16_2: layer1_FCneuron_16
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(15));
LAYER_1_NEU_16_3: layer1_FCneuron_16
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(15));
VOT_LAYER_1_NEU_16 : VOT_layer1_FCneuron_16 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(15),
		 neuron_mac_2 => layer_1_neurons_mac_2(15),
		 neuron_mac_3 => layer_1_neurons_mac_3(15),
		 neuron_mac_v => layer_1_neurons_mac(15));
LAYER_1_NEU_17_1: layer1_FCneuron_17
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(16));
LAYER_1_NEU_17_2: layer1_FCneuron_17
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(16));
LAYER_1_NEU_17_3: layer1_FCneuron_17
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(16));
VOT_LAYER_1_NEU_17 : VOT_layer1_FCneuron_17 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(16),
		 neuron_mac_2 => layer_1_neurons_mac_2(16),
		 neuron_mac_3 => layer_1_neurons_mac_3(16),
		 neuron_mac_v => layer_1_neurons_mac(16));
LAYER_1_NEU_18_1: layer1_FCneuron_18
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(17));
LAYER_1_NEU_18_2: layer1_FCneuron_18
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(17));
LAYER_1_NEU_18_3: layer1_FCneuron_18
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(17));
VOT_LAYER_1_NEU_18 : VOT_layer1_FCneuron_18 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(17),
		 neuron_mac_2 => layer_1_neurons_mac_2(17),
		 neuron_mac_3 => layer_1_neurons_mac_3(17),
		 neuron_mac_v => layer_1_neurons_mac(17));
LAYER_1_NEU_19_1: layer1_FCneuron_19
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(18));
LAYER_1_NEU_19_2: layer1_FCneuron_19
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(18));
LAYER_1_NEU_19_3: layer1_FCneuron_19
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(18));
VOT_LAYER_1_NEU_19 : VOT_layer1_FCneuron_19 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(18),
		 neuron_mac_2 => layer_1_neurons_mac_2(18),
		 neuron_mac_3 => layer_1_neurons_mac_3(18),
		 neuron_mac_v => layer_1_neurons_mac(18));
LAYER_1_NEU_20_1: layer1_FCneuron_20
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(19));
LAYER_1_NEU_20_2: layer1_FCneuron_20
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(19));
LAYER_1_NEU_20_3: layer1_FCneuron_20
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(19));
VOT_LAYER_1_NEU_20 : VOT_layer1_FCneuron_20 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(19),
		 neuron_mac_2 => layer_1_neurons_mac_2(19),
		 neuron_mac_3 => layer_1_neurons_mac_3(19),
		 neuron_mac_v => layer_1_neurons_mac(19));
LAYER_1_NEU_21_1: layer1_FCneuron_21
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(20));
LAYER_1_NEU_21_2: layer1_FCneuron_21
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(20));
LAYER_1_NEU_21_3: layer1_FCneuron_21
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(20));
VOT_LAYER_1_NEU_21 : VOT_layer1_FCneuron_21 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(20),
		 neuron_mac_2 => layer_1_neurons_mac_2(20),
		 neuron_mac_3 => layer_1_neurons_mac_3(20),
		 neuron_mac_v => layer_1_neurons_mac(20));
LAYER_1_NEU_22_1: layer1_FCneuron_22
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(21));
LAYER_1_NEU_22_2: layer1_FCneuron_22
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(21));
LAYER_1_NEU_22_3: layer1_FCneuron_22
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(21));
VOT_LAYER_1_NEU_22 : VOT_layer1_FCneuron_22 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(21),
		 neuron_mac_2 => layer_1_neurons_mac_2(21),
		 neuron_mac_3 => layer_1_neurons_mac_3(21),
		 neuron_mac_v => layer_1_neurons_mac(21));
LAYER_1_NEU_23_1: layer1_FCneuron_23
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(22));
LAYER_1_NEU_23_2: layer1_FCneuron_23
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(22));
LAYER_1_NEU_23_3: layer1_FCneuron_23
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(22));
VOT_LAYER_1_NEU_23 : VOT_layer1_FCneuron_23 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(22),
		 neuron_mac_2 => layer_1_neurons_mac_2(22),
		 neuron_mac_3 => layer_1_neurons_mac_3(22),
		 neuron_mac_v => layer_1_neurons_mac(22));
LAYER_1_NEU_24_1: layer1_FCneuron_24
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(23));
LAYER_1_NEU_24_2: layer1_FCneuron_24
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(23));
LAYER_1_NEU_24_3: layer1_FCneuron_24
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(23));
VOT_LAYER_1_NEU_24 : VOT_layer1_FCneuron_24 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(23),
		 neuron_mac_2 => layer_1_neurons_mac_2(23),
		 neuron_mac_3 => layer_1_neurons_mac_3(23),
		 neuron_mac_v => layer_1_neurons_mac(23));
LAYER_1_NEU_25_1: layer1_FCneuron_25
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(24));
LAYER_1_NEU_25_2: layer1_FCneuron_25
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(24));
LAYER_1_NEU_25_3: layer1_FCneuron_25
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(24));
VOT_LAYER_1_NEU_25 : VOT_layer1_FCneuron_25 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(24),
		 neuron_mac_2 => layer_1_neurons_mac_2(24),
		 neuron_mac_3 => layer_1_neurons_mac_3(24),
		 neuron_mac_v => layer_1_neurons_mac(24));
LAYER_1_NEU_26_1: layer1_FCneuron_26
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(25));
LAYER_1_NEU_26_2: layer1_FCneuron_26
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(25));
LAYER_1_NEU_26_3: layer1_FCneuron_26
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(25));
VOT_LAYER_1_NEU_26 : VOT_layer1_FCneuron_26 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(25),
		 neuron_mac_2 => layer_1_neurons_mac_2(25),
		 neuron_mac_3 => layer_1_neurons_mac_3(25),
		 neuron_mac_v => layer_1_neurons_mac(25));
LAYER_1_NEU_27_1: layer1_FCneuron_27
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(26));
LAYER_1_NEU_27_2: layer1_FCneuron_27
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(26));
LAYER_1_NEU_27_3: layer1_FCneuron_27
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(26));
VOT_LAYER_1_NEU_27 : VOT_layer1_FCneuron_27 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(26),
		 neuron_mac_2 => layer_1_neurons_mac_2(26),
		 neuron_mac_3 => layer_1_neurons_mac_3(26),
		 neuron_mac_v => layer_1_neurons_mac(26));
LAYER_1_NEU_28_1: layer1_FCneuron_28
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(27));
LAYER_1_NEU_28_2: layer1_FCneuron_28
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(27));
LAYER_1_NEU_28_3: layer1_FCneuron_28
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(27));
VOT_LAYER_1_NEU_28 : VOT_layer1_FCneuron_28 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(27),
		 neuron_mac_2 => layer_1_neurons_mac_2(27),
		 neuron_mac_3 => layer_1_neurons_mac_3(27),
		 neuron_mac_v => layer_1_neurons_mac(27));
LAYER_1_NEU_29_1: layer1_FCneuron_29
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(28));
LAYER_1_NEU_29_2: layer1_FCneuron_29
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(28));
LAYER_1_NEU_29_3: layer1_FCneuron_29
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(28));
VOT_LAYER_1_NEU_29 : VOT_layer1_FCneuron_29 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(28),
		 neuron_mac_2 => layer_1_neurons_mac_2(28),
		 neuron_mac_3 => layer_1_neurons_mac_3(28),
		 neuron_mac_v => layer_1_neurons_mac(28));
LAYER_1_NEU_30_1: layer1_FCneuron_30
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(29));
LAYER_1_NEU_30_2: layer1_FCneuron_30
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(29));
LAYER_1_NEU_30_3: layer1_FCneuron_30
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(29));
VOT_LAYER_1_NEU_30 : VOT_layer1_FCneuron_30 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(29),
		 neuron_mac_2 => layer_1_neurons_mac_2(29),
		 neuron_mac_3 => layer_1_neurons_mac_3(29),
		 neuron_mac_v => layer_1_neurons_mac(29));
LAYER_1_NEU_31_1: layer1_FCneuron_31
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(30));
LAYER_1_NEU_31_2: layer1_FCneuron_31
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(30));
LAYER_1_NEU_31_3: layer1_FCneuron_31
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(30));
VOT_LAYER_1_NEU_31 : VOT_layer1_FCneuron_31 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(30),
		 neuron_mac_2 => layer_1_neurons_mac_2(30),
		 neuron_mac_3 => layer_1_neurons_mac_3(30),
		 neuron_mac_v => layer_1_neurons_mac(30));
LAYER_1_NEU_32_1: layer1_FCneuron_32
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(31));
LAYER_1_NEU_32_2: layer1_FCneuron_32
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(31));
LAYER_1_NEU_32_3: layer1_FCneuron_32
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(31));
VOT_LAYER_1_NEU_32 : VOT_layer1_FCneuron_32 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(31),
		 neuron_mac_2 => layer_1_neurons_mac_2(31),
		 neuron_mac_3 => layer_1_neurons_mac_3(31),
		 neuron_mac_v => layer_1_neurons_mac(31));
LAYER_1_NEU_33_1: layer1_FCneuron_33
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(32));
LAYER_1_NEU_33_2: layer1_FCneuron_33
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(32));
LAYER_1_NEU_33_3: layer1_FCneuron_33
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(32));
VOT_LAYER_1_NEU_33 : VOT_layer1_FCneuron_33 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(32),
		 neuron_mac_2 => layer_1_neurons_mac_2(32),
		 neuron_mac_3 => layer_1_neurons_mac_3(32),
		 neuron_mac_v => layer_1_neurons_mac(32));
LAYER_1_NEU_34_1: layer1_FCneuron_34
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(33));
LAYER_1_NEU_34_2: layer1_FCneuron_34
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(33));
LAYER_1_NEU_34_3: layer1_FCneuron_34
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(33));
VOT_LAYER_1_NEU_34 : VOT_layer1_FCneuron_34 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(33),
		 neuron_mac_2 => layer_1_neurons_mac_2(33),
		 neuron_mac_3 => layer_1_neurons_mac_3(33),
		 neuron_mac_v => layer_1_neurons_mac(33));
LAYER_1_NEU_35_1: layer1_FCneuron_35
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(34));
LAYER_1_NEU_35_2: layer1_FCneuron_35
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(34));
LAYER_1_NEU_35_3: layer1_FCneuron_35
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(34));
VOT_LAYER_1_NEU_35 : VOT_layer1_FCneuron_35 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(34),
		 neuron_mac_2 => layer_1_neurons_mac_2(34),
		 neuron_mac_3 => layer_1_neurons_mac_3(34),
		 neuron_mac_v => layer_1_neurons_mac(34));
LAYER_1_NEU_36_1: layer1_FCneuron_36
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(35));
LAYER_1_NEU_36_2: layer1_FCneuron_36
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(35));
LAYER_1_NEU_36_3: layer1_FCneuron_36
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(35));
VOT_LAYER_1_NEU_36 : VOT_layer1_FCneuron_36 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(35),
		 neuron_mac_2 => layer_1_neurons_mac_2(35),
		 neuron_mac_3 => layer_1_neurons_mac_3(35),
		 neuron_mac_v => layer_1_neurons_mac(35));
LAYER_1_NEU_37_1: layer1_FCneuron_37
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(36));
LAYER_1_NEU_37_2: layer1_FCneuron_37
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(36));
LAYER_1_NEU_37_3: layer1_FCneuron_37
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(36));
VOT_LAYER_1_NEU_37 : VOT_layer1_FCneuron_37 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(36),
		 neuron_mac_2 => layer_1_neurons_mac_2(36),
		 neuron_mac_3 => layer_1_neurons_mac_3(36),
		 neuron_mac_v => layer_1_neurons_mac(36));
LAYER_1_NEU_38_1: layer1_FCneuron_38
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(37));
LAYER_1_NEU_38_2: layer1_FCneuron_38
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(37));
LAYER_1_NEU_38_3: layer1_FCneuron_38
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(37));
VOT_LAYER_1_NEU_38 : VOT_layer1_FCneuron_38 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(37),
		 neuron_mac_2 => layer_1_neurons_mac_2(37),
		 neuron_mac_3 => layer_1_neurons_mac_3(37),
		 neuron_mac_v => layer_1_neurons_mac(37));
LAYER_1_NEU_39_1: layer1_FCneuron_39
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(38));
LAYER_1_NEU_39_2: layer1_FCneuron_39
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(38));
LAYER_1_NEU_39_3: layer1_FCneuron_39
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(38));
VOT_LAYER_1_NEU_39 : VOT_layer1_FCneuron_39 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(38),
		 neuron_mac_2 => layer_1_neurons_mac_2(38),
		 neuron_mac_3 => layer_1_neurons_mac_3(38),
		 neuron_mac_v => layer_1_neurons_mac(38));
LAYER_1_NEU_40_1: layer1_FCneuron_40
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(39));
LAYER_1_NEU_40_2: layer1_FCneuron_40
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(39));
LAYER_1_NEU_40_3: layer1_FCneuron_40
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(39));
VOT_LAYER_1_NEU_40 : VOT_layer1_FCneuron_40 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(39),
		 neuron_mac_2 => layer_1_neurons_mac_2(39),
		 neuron_mac_3 => layer_1_neurons_mac_3(39),
		 neuron_mac_v => layer_1_neurons_mac(39));
LAYER_1_NEU_41_1: layer1_FCneuron_41
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(40));
LAYER_1_NEU_41_2: layer1_FCneuron_41
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(40));
LAYER_1_NEU_41_3: layer1_FCneuron_41
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(40));
VOT_LAYER_1_NEU_41 : VOT_layer1_FCneuron_41 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(40),
		 neuron_mac_2 => layer_1_neurons_mac_2(40),
		 neuron_mac_3 => layer_1_neurons_mac_3(40),
		 neuron_mac_v => layer_1_neurons_mac(40));
LAYER_1_NEU_42_1: layer1_FCneuron_42
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(41));
LAYER_1_NEU_42_2: layer1_FCneuron_42
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(41));
LAYER_1_NEU_42_3: layer1_FCneuron_42
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(41));
VOT_LAYER_1_NEU_42 : VOT_layer1_FCneuron_42 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(41),
		 neuron_mac_2 => layer_1_neurons_mac_2(41),
		 neuron_mac_3 => layer_1_neurons_mac_3(41),
		 neuron_mac_v => layer_1_neurons_mac(41));
LAYER_1_NEU_43_1: layer1_FCneuron_43
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(42));
LAYER_1_NEU_43_2: layer1_FCneuron_43
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(42));
LAYER_1_NEU_43_3: layer1_FCneuron_43
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(42));
VOT_LAYER_1_NEU_43 : VOT_layer1_FCneuron_43 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(42),
		 neuron_mac_2 => layer_1_neurons_mac_2(42),
		 neuron_mac_3 => layer_1_neurons_mac_3(42),
		 neuron_mac_v => layer_1_neurons_mac(42));
LAYER_1_NEU_44_1: layer1_FCneuron_44
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(43));
LAYER_1_NEU_44_2: layer1_FCneuron_44
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(43));
LAYER_1_NEU_44_3: layer1_FCneuron_44
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(43));
VOT_LAYER_1_NEU_44 : VOT_layer1_FCneuron_44 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(43),
		 neuron_mac_2 => layer_1_neurons_mac_2(43),
		 neuron_mac_3 => layer_1_neurons_mac_3(43),
		 neuron_mac_v => layer_1_neurons_mac(43));
LAYER_1_NEU_45_1: layer1_FCneuron_45
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(44));
LAYER_1_NEU_45_2: layer1_FCneuron_45
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(44));
LAYER_1_NEU_45_3: layer1_FCneuron_45
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(44));
VOT_LAYER_1_NEU_45 : VOT_layer1_FCneuron_45 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(44),
		 neuron_mac_2 => layer_1_neurons_mac_2(44),
		 neuron_mac_3 => layer_1_neurons_mac_3(44),
		 neuron_mac_v => layer_1_neurons_mac(44));
LAYER_1_NEU_46_1: layer1_FCneuron_46
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(45));
LAYER_1_NEU_46_2: layer1_FCneuron_46
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(45));
LAYER_1_NEU_46_3: layer1_FCneuron_46
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(45));
VOT_LAYER_1_NEU_46 : VOT_layer1_FCneuron_46 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(45),
		 neuron_mac_2 => layer_1_neurons_mac_2(45),
		 neuron_mac_3 => layer_1_neurons_mac_3(45),
		 neuron_mac_v => layer_1_neurons_mac(45));
LAYER_1_NEU_47_1: layer1_FCneuron_47
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(46));
LAYER_1_NEU_47_2: layer1_FCneuron_47
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(46));
LAYER_1_NEU_47_3: layer1_FCneuron_47
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(46));
VOT_LAYER_1_NEU_47 : VOT_layer1_FCneuron_47 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(46),
		 neuron_mac_2 => layer_1_neurons_mac_2(46),
		 neuron_mac_3 => layer_1_neurons_mac_3(46),
		 neuron_mac_v => layer_1_neurons_mac(46));
LAYER_1_NEU_48_1: layer1_FCneuron_48
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(47));
LAYER_1_NEU_48_2: layer1_FCneuron_48
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(47));
LAYER_1_NEU_48_3: layer1_FCneuron_48
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(47));
VOT_LAYER_1_NEU_48 : VOT_layer1_FCneuron_48 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(47),
		 neuron_mac_2 => layer_1_neurons_mac_2(47),
		 neuron_mac_3 => layer_1_neurons_mac_3(47),
		 neuron_mac_v => layer_1_neurons_mac(47));
LAYER_1_NEU_49_1: layer1_FCneuron_49
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(48));
LAYER_1_NEU_49_2: layer1_FCneuron_49
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(48));
LAYER_1_NEU_49_3: layer1_FCneuron_49
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(48));
VOT_LAYER_1_NEU_49 : VOT_layer1_FCneuron_49 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(48),
		 neuron_mac_2 => layer_1_neurons_mac_2(48),
		 neuron_mac_3 => layer_1_neurons_mac_3(48),
		 neuron_mac_v => layer_1_neurons_mac(48));
LAYER_1_NEU_50_1: layer1_FCneuron_50
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(49));
LAYER_1_NEU_50_2: layer1_FCneuron_50
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(49));
LAYER_1_NEU_50_3: layer1_FCneuron_50
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(49));
VOT_LAYER_1_NEU_50 : VOT_layer1_FCneuron_50 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(49),
		 neuron_mac_2 => layer_1_neurons_mac_2(49),
		 neuron_mac_3 => layer_1_neurons_mac_3(49),
		 neuron_mac_v => layer_1_neurons_mac(49));
LAYER_1_NEU_51_1: layer1_FCneuron_51
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(50));
LAYER_1_NEU_51_2: layer1_FCneuron_51
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(50));
LAYER_1_NEU_51_3: layer1_FCneuron_51
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(50));
VOT_LAYER_1_NEU_51 : VOT_layer1_FCneuron_51 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(50),
		 neuron_mac_2 => layer_1_neurons_mac_2(50),
		 neuron_mac_3 => layer_1_neurons_mac_3(50),
		 neuron_mac_v => layer_1_neurons_mac(50));
LAYER_1_NEU_52_1: layer1_FCneuron_52
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(51));
LAYER_1_NEU_52_2: layer1_FCneuron_52
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(51));
LAYER_1_NEU_52_3: layer1_FCneuron_52
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(51));
VOT_LAYER_1_NEU_52 : VOT_layer1_FCneuron_52 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(51),
		 neuron_mac_2 => layer_1_neurons_mac_2(51),
		 neuron_mac_3 => layer_1_neurons_mac_3(51),
		 neuron_mac_v => layer_1_neurons_mac(51));
LAYER_1_NEU_53_1: layer1_FCneuron_53
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(52));
LAYER_1_NEU_53_2: layer1_FCneuron_53
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(52));
LAYER_1_NEU_53_3: layer1_FCneuron_53
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(52));
VOT_LAYER_1_NEU_53 : VOT_layer1_FCneuron_53 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(52),
		 neuron_mac_2 => layer_1_neurons_mac_2(52),
		 neuron_mac_3 => layer_1_neurons_mac_3(52),
		 neuron_mac_v => layer_1_neurons_mac(52));
LAYER_1_NEU_54_1: layer1_FCneuron_54
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(53));
LAYER_1_NEU_54_2: layer1_FCneuron_54
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(53));
LAYER_1_NEU_54_3: layer1_FCneuron_54
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(53));
VOT_LAYER_1_NEU_54 : VOT_layer1_FCneuron_54 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(53),
		 neuron_mac_2 => layer_1_neurons_mac_2(53),
		 neuron_mac_3 => layer_1_neurons_mac_3(53),
		 neuron_mac_v => layer_1_neurons_mac(53));
LAYER_1_NEU_55_1: layer1_FCneuron_55
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(54));
LAYER_1_NEU_55_2: layer1_FCneuron_55
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(54));
LAYER_1_NEU_55_3: layer1_FCneuron_55
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(54));
VOT_LAYER_1_NEU_55 : VOT_layer1_FCneuron_55 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(54),
		 neuron_mac_2 => layer_1_neurons_mac_2(54),
		 neuron_mac_3 => layer_1_neurons_mac_3(54),
		 neuron_mac_v => layer_1_neurons_mac(54));
LAYER_1_NEU_56_1: layer1_FCneuron_56
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(55));
LAYER_1_NEU_56_2: layer1_FCneuron_56
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(55));
LAYER_1_NEU_56_3: layer1_FCneuron_56
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(55));
VOT_LAYER_1_NEU_56 : VOT_layer1_FCneuron_56 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(55),
		 neuron_mac_2 => layer_1_neurons_mac_2(55),
		 neuron_mac_3 => layer_1_neurons_mac_3(55),
		 neuron_mac_v => layer_1_neurons_mac(55));
LAYER_1_NEU_57_1: layer1_FCneuron_57
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(56));
LAYER_1_NEU_57_2: layer1_FCneuron_57
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(56));
LAYER_1_NEU_57_3: layer1_FCneuron_57
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(56));
VOT_LAYER_1_NEU_57 : VOT_layer1_FCneuron_57 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(56),
		 neuron_mac_2 => layer_1_neurons_mac_2(56),
		 neuron_mac_3 => layer_1_neurons_mac_3(56),
		 neuron_mac_v => layer_1_neurons_mac(56));
LAYER_1_NEU_58_1: layer1_FCneuron_58
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(57));
LAYER_1_NEU_58_2: layer1_FCneuron_58
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(57));
LAYER_1_NEU_58_3: layer1_FCneuron_58
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(57));
VOT_LAYER_1_NEU_58 : VOT_layer1_FCneuron_58 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(57),
		 neuron_mac_2 => layer_1_neurons_mac_2(57),
		 neuron_mac_3 => layer_1_neurons_mac_3(57),
		 neuron_mac_v => layer_1_neurons_mac(57));
LAYER_1_NEU_59_1: layer1_FCneuron_59
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(58));
LAYER_1_NEU_59_2: layer1_FCneuron_59
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(58));
LAYER_1_NEU_59_3: layer1_FCneuron_59
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(58));
VOT_LAYER_1_NEU_59 : VOT_layer1_FCneuron_59 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(58),
		 neuron_mac_2 => layer_1_neurons_mac_2(58),
		 neuron_mac_3 => layer_1_neurons_mac_3(58),
		 neuron_mac_v => layer_1_neurons_mac(58));
LAYER_1_NEU_60_1: layer1_FCneuron_60
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(59));
LAYER_1_NEU_60_2: layer1_FCneuron_60
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(59));
LAYER_1_NEU_60_3: layer1_FCneuron_60
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(59));
VOT_LAYER_1_NEU_60 : VOT_layer1_FCneuron_60 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(59),
		 neuron_mac_2 => layer_1_neurons_mac_2(59),
		 neuron_mac_3 => layer_1_neurons_mac_3(59),
		 neuron_mac_v => layer_1_neurons_mac(59));
LAYER_1_NEU_61_1: layer1_FCneuron_61
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(60));
LAYER_1_NEU_61_2: layer1_FCneuron_61
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(60));
LAYER_1_NEU_61_3: layer1_FCneuron_61
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(60));
VOT_LAYER_1_NEU_61 : VOT_layer1_FCneuron_61 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(60),
		 neuron_mac_2 => layer_1_neurons_mac_2(60),
		 neuron_mac_3 => layer_1_neurons_mac_3(60),
		 neuron_mac_v => layer_1_neurons_mac(60));
LAYER_1_NEU_62_1: layer1_FCneuron_62
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(61));
LAYER_1_NEU_62_2: layer1_FCneuron_62
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(61));
LAYER_1_NEU_62_3: layer1_FCneuron_62
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(61));
VOT_LAYER_1_NEU_62 : VOT_layer1_FCneuron_62 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(61),
		 neuron_mac_2 => layer_1_neurons_mac_2(61),
		 neuron_mac_3 => layer_1_neurons_mac_3(61),
		 neuron_mac_v => layer_1_neurons_mac(61));
LAYER_1_NEU_63_1: layer1_FCneuron_63
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(62));
LAYER_1_NEU_63_2: layer1_FCneuron_63
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(62));
LAYER_1_NEU_63_3: layer1_FCneuron_63
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(62));
VOT_LAYER_1_NEU_63 : VOT_layer1_FCneuron_63 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(62),
		 neuron_mac_2 => layer_1_neurons_mac_2(62),
		 neuron_mac_3 => layer_1_neurons_mac_3(62),
		 neuron_mac_v => layer_1_neurons_mac(62));
LAYER_1_NEU_64_1: layer1_FCneuron_64
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(63));
LAYER_1_NEU_64_2: layer1_FCneuron_64
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(63));
LAYER_1_NEU_64_3: layer1_FCneuron_64
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(63));
VOT_LAYER_1_NEU_64 : VOT_layer1_FCneuron_64 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(63),
		 neuron_mac_2 => layer_1_neurons_mac_2(63),
		 neuron_mac_3 => layer_1_neurons_mac_3(63),
		 neuron_mac_v => layer_1_neurons_mac(63));
LAYER_1_NEU_65_1: layer1_FCneuron_65
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(64));
LAYER_1_NEU_65_2: layer1_FCneuron_65
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(64));
LAYER_1_NEU_65_3: layer1_FCneuron_65
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(64));
VOT_LAYER_1_NEU_65 : VOT_layer1_FCneuron_65 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(64),
		 neuron_mac_2 => layer_1_neurons_mac_2(64),
		 neuron_mac_3 => layer_1_neurons_mac_3(64),
		 neuron_mac_v => layer_1_neurons_mac(64));
LAYER_1_NEU_66_1: layer1_FCneuron_66
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(65));
LAYER_1_NEU_66_2: layer1_FCneuron_66
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(65));
LAYER_1_NEU_66_3: layer1_FCneuron_66
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(65));
VOT_LAYER_1_NEU_66 : VOT_layer1_FCneuron_66 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(65),
		 neuron_mac_2 => layer_1_neurons_mac_2(65),
		 neuron_mac_3 => layer_1_neurons_mac_3(65),
		 neuron_mac_v => layer_1_neurons_mac(65));
LAYER_1_NEU_67_1: layer1_FCneuron_67
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(66));
LAYER_1_NEU_67_2: layer1_FCneuron_67
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(66));
LAYER_1_NEU_67_3: layer1_FCneuron_67
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(66));
VOT_LAYER_1_NEU_67 : VOT_layer1_FCneuron_67 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(66),
		 neuron_mac_2 => layer_1_neurons_mac_2(66),
		 neuron_mac_3 => layer_1_neurons_mac_3(66),
		 neuron_mac_v => layer_1_neurons_mac(66));
LAYER_1_NEU_68_1: layer1_FCneuron_68
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(67));
LAYER_1_NEU_68_2: layer1_FCneuron_68
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(67));
LAYER_1_NEU_68_3: layer1_FCneuron_68
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(67));
VOT_LAYER_1_NEU_68 : VOT_layer1_FCneuron_68 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(67),
		 neuron_mac_2 => layer_1_neurons_mac_2(67),
		 neuron_mac_3 => layer_1_neurons_mac_3(67),
		 neuron_mac_v => layer_1_neurons_mac(67));
LAYER_1_NEU_69_1: layer1_FCneuron_69
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(68));
LAYER_1_NEU_69_2: layer1_FCneuron_69
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(68));
LAYER_1_NEU_69_3: layer1_FCneuron_69
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(68));
VOT_LAYER_1_NEU_69 : VOT_layer1_FCneuron_69 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(68),
		 neuron_mac_2 => layer_1_neurons_mac_2(68),
		 neuron_mac_3 => layer_1_neurons_mac_3(68),
		 neuron_mac_v => layer_1_neurons_mac(68));
LAYER_1_NEU_70_1: layer1_FCneuron_70
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(69));
LAYER_1_NEU_70_2: layer1_FCneuron_70
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(69));
LAYER_1_NEU_70_3: layer1_FCneuron_70
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(69));
VOT_LAYER_1_NEU_70 : VOT_layer1_FCneuron_70 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(69),
		 neuron_mac_2 => layer_1_neurons_mac_2(69),
		 neuron_mac_3 => layer_1_neurons_mac_3(69),
		 neuron_mac_v => layer_1_neurons_mac(69));
LAYER_1_NEU_71_1: layer1_FCneuron_71
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(70));
LAYER_1_NEU_71_2: layer1_FCneuron_71
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(70));
LAYER_1_NEU_71_3: layer1_FCneuron_71
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(70));
VOT_LAYER_1_NEU_71 : VOT_layer1_FCneuron_71 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(70),
		 neuron_mac_2 => layer_1_neurons_mac_2(70),
		 neuron_mac_3 => layer_1_neurons_mac_3(70),
		 neuron_mac_v => layer_1_neurons_mac(70));
LAYER_1_NEU_72_1: layer1_FCneuron_72
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(71));
LAYER_1_NEU_72_2: layer1_FCneuron_72
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(71));
LAYER_1_NEU_72_3: layer1_FCneuron_72
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(71));
VOT_LAYER_1_NEU_72 : VOT_layer1_FCneuron_72 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(71),
		 neuron_mac_2 => layer_1_neurons_mac_2(71),
		 neuron_mac_3 => layer_1_neurons_mac_3(71),
		 neuron_mac_v => layer_1_neurons_mac(71));
LAYER_1_NEU_73_1: layer1_FCneuron_73
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(72));
LAYER_1_NEU_73_2: layer1_FCneuron_73
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(72));
LAYER_1_NEU_73_3: layer1_FCneuron_73
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(72));
VOT_LAYER_1_NEU_73 : VOT_layer1_FCneuron_73 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(72),
		 neuron_mac_2 => layer_1_neurons_mac_2(72),
		 neuron_mac_3 => layer_1_neurons_mac_3(72),
		 neuron_mac_v => layer_1_neurons_mac(72));
LAYER_1_NEU_74_1: layer1_FCneuron_74
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(73));
LAYER_1_NEU_74_2: layer1_FCneuron_74
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(73));
LAYER_1_NEU_74_3: layer1_FCneuron_74
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(73));
VOT_LAYER_1_NEU_74 : VOT_layer1_FCneuron_74 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(73),
		 neuron_mac_2 => layer_1_neurons_mac_2(73),
		 neuron_mac_3 => layer_1_neurons_mac_3(73),
		 neuron_mac_v => layer_1_neurons_mac(73));
LAYER_1_NEU_75_1: layer1_FCneuron_75
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(74));
LAYER_1_NEU_75_2: layer1_FCneuron_75
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(74));
LAYER_1_NEU_75_3: layer1_FCneuron_75
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(74));
VOT_LAYER_1_NEU_75 : VOT_layer1_FCneuron_75 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(74),
		 neuron_mac_2 => layer_1_neurons_mac_2(74),
		 neuron_mac_3 => layer_1_neurons_mac_3(74),
		 neuron_mac_v => layer_1_neurons_mac(74));
LAYER_1_NEU_76_1: layer1_FCneuron_76
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(75));
LAYER_1_NEU_76_2: layer1_FCneuron_76
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(75));
LAYER_1_NEU_76_3: layer1_FCneuron_76
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(75));
VOT_LAYER_1_NEU_76 : VOT_layer1_FCneuron_76 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(75),
		 neuron_mac_2 => layer_1_neurons_mac_2(75),
		 neuron_mac_3 => layer_1_neurons_mac_3(75),
		 neuron_mac_v => layer_1_neurons_mac(75));
LAYER_1_NEU_77_1: layer1_FCneuron_77
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(76));
LAYER_1_NEU_77_2: layer1_FCneuron_77
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(76));
LAYER_1_NEU_77_3: layer1_FCneuron_77
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(76));
VOT_LAYER_1_NEU_77 : VOT_layer1_FCneuron_77 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(76),
		 neuron_mac_2 => layer_1_neurons_mac_2(76),
		 neuron_mac_3 => layer_1_neurons_mac_3(76),
		 neuron_mac_v => layer_1_neurons_mac(76));
LAYER_1_NEU_78_1: layer1_FCneuron_78
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(77));
LAYER_1_NEU_78_2: layer1_FCneuron_78
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(77));
LAYER_1_NEU_78_3: layer1_FCneuron_78
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(77));
VOT_LAYER_1_NEU_78 : VOT_layer1_FCneuron_78 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(77),
		 neuron_mac_2 => layer_1_neurons_mac_2(77),
		 neuron_mac_3 => layer_1_neurons_mac_3(77),
		 neuron_mac_v => layer_1_neurons_mac(77));
LAYER_1_NEU_79_1: layer1_FCneuron_79
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(78));
LAYER_1_NEU_79_2: layer1_FCneuron_79
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(78));
LAYER_1_NEU_79_3: layer1_FCneuron_79
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(78));
VOT_LAYER_1_NEU_79 : VOT_layer1_FCneuron_79 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(78),
		 neuron_mac_2 => layer_1_neurons_mac_2(78),
		 neuron_mac_3 => layer_1_neurons_mac_3(78),
		 neuron_mac_v => layer_1_neurons_mac(78));
LAYER_1_NEU_80_1: layer1_FCneuron_80
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(79));
LAYER_1_NEU_80_2: layer1_FCneuron_80
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(79));
LAYER_1_NEU_80_3: layer1_FCneuron_80
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(79));
VOT_LAYER_1_NEU_80 : VOT_layer1_FCneuron_80 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(79),
		 neuron_mac_2 => layer_1_neurons_mac_2(79),
		 neuron_mac_3 => layer_1_neurons_mac_3(79),
		 neuron_mac_v => layer_1_neurons_mac(79));
LAYER_1_NEU_81_1: layer1_FCneuron_81
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(80));
LAYER_1_NEU_81_2: layer1_FCneuron_81
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(80));
LAYER_1_NEU_81_3: layer1_FCneuron_81
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(80));
VOT_LAYER_1_NEU_81 : VOT_layer1_FCneuron_81 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(80),
		 neuron_mac_2 => layer_1_neurons_mac_2(80),
		 neuron_mac_3 => layer_1_neurons_mac_3(80),
		 neuron_mac_v => layer_1_neurons_mac(80));
LAYER_1_NEU_82_1: layer1_FCneuron_82
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(81));
LAYER_1_NEU_82_2: layer1_FCneuron_82
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(81));
LAYER_1_NEU_82_3: layer1_FCneuron_82
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(81));
VOT_LAYER_1_NEU_82 : VOT_layer1_FCneuron_82 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(81),
		 neuron_mac_2 => layer_1_neurons_mac_2(81),
		 neuron_mac_3 => layer_1_neurons_mac_3(81),
		 neuron_mac_v => layer_1_neurons_mac(81));
LAYER_1_NEU_83_1: layer1_FCneuron_83
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(82));
LAYER_1_NEU_83_2: layer1_FCneuron_83
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(82));
LAYER_1_NEU_83_3: layer1_FCneuron_83
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(82));
VOT_LAYER_1_NEU_83 : VOT_layer1_FCneuron_83 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(82),
		 neuron_mac_2 => layer_1_neurons_mac_2(82),
		 neuron_mac_3 => layer_1_neurons_mac_3(82),
		 neuron_mac_v => layer_1_neurons_mac(82));
LAYER_1_NEU_84_1: layer1_FCneuron_84
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(83));
LAYER_1_NEU_84_2: layer1_FCneuron_84
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(83));
LAYER_1_NEU_84_3: layer1_FCneuron_84
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(83));
VOT_LAYER_1_NEU_84 : VOT_layer1_FCneuron_84 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(83),
		 neuron_mac_2 => layer_1_neurons_mac_2(83),
		 neuron_mac_3 => layer_1_neurons_mac_3(83),
		 neuron_mac_v => layer_1_neurons_mac(83));
LAYER_1_NEU_85_1: layer1_FCneuron_85
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(84));
LAYER_1_NEU_85_2: layer1_FCneuron_85
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(84));
LAYER_1_NEU_85_3: layer1_FCneuron_85
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(84));
VOT_LAYER_1_NEU_85 : VOT_layer1_FCneuron_85 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(84),
		 neuron_mac_2 => layer_1_neurons_mac_2(84),
		 neuron_mac_3 => layer_1_neurons_mac_3(84),
		 neuron_mac_v => layer_1_neurons_mac(84));
LAYER_1_NEU_86_1: layer1_FCneuron_86
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(85));
LAYER_1_NEU_86_2: layer1_FCneuron_86
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(85));
LAYER_1_NEU_86_3: layer1_FCneuron_86
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(85));
VOT_LAYER_1_NEU_86 : VOT_layer1_FCneuron_86 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(85),
		 neuron_mac_2 => layer_1_neurons_mac_2(85),
		 neuron_mac_3 => layer_1_neurons_mac_3(85),
		 neuron_mac_v => layer_1_neurons_mac(85));
LAYER_1_NEU_87_1: layer1_FCneuron_87
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(86));
LAYER_1_NEU_87_2: layer1_FCneuron_87
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(86));
LAYER_1_NEU_87_3: layer1_FCneuron_87
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(86));
VOT_LAYER_1_NEU_87 : VOT_layer1_FCneuron_87 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(86),
		 neuron_mac_2 => layer_1_neurons_mac_2(86),
		 neuron_mac_3 => layer_1_neurons_mac_3(86),
		 neuron_mac_v => layer_1_neurons_mac(86));
LAYER_1_NEU_88_1: layer1_FCneuron_88
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(87));
LAYER_1_NEU_88_2: layer1_FCneuron_88
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(87));
LAYER_1_NEU_88_3: layer1_FCneuron_88
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(87));
VOT_LAYER_1_NEU_88 : VOT_layer1_FCneuron_88 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(87),
		 neuron_mac_2 => layer_1_neurons_mac_2(87),
		 neuron_mac_3 => layer_1_neurons_mac_3(87),
		 neuron_mac_v => layer_1_neurons_mac(87));
LAYER_1_NEU_89_1: layer1_FCneuron_89
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(88));
LAYER_1_NEU_89_2: layer1_FCneuron_89
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(88));
LAYER_1_NEU_89_3: layer1_FCneuron_89
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(88));
VOT_LAYER_1_NEU_89 : VOT_layer1_FCneuron_89 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(88),
		 neuron_mac_2 => layer_1_neurons_mac_2(88),
		 neuron_mac_3 => layer_1_neurons_mac_3(88),
		 neuron_mac_v => layer_1_neurons_mac(88));
LAYER_1_NEU_90_1: layer1_FCneuron_90
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(89));
LAYER_1_NEU_90_2: layer1_FCneuron_90
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(89));
LAYER_1_NEU_90_3: layer1_FCneuron_90
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(89));
VOT_LAYER_1_NEU_90 : VOT_layer1_FCneuron_90 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(89),
		 neuron_mac_2 => layer_1_neurons_mac_2(89),
		 neuron_mac_3 => layer_1_neurons_mac_3(89),
		 neuron_mac_v => layer_1_neurons_mac(89));
LAYER_1_NEU_91_1: layer1_FCneuron_91
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(90));
LAYER_1_NEU_91_2: layer1_FCneuron_91
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(90));
LAYER_1_NEU_91_3: layer1_FCneuron_91
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(90));
VOT_LAYER_1_NEU_91 : VOT_layer1_FCneuron_91 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(90),
		 neuron_mac_2 => layer_1_neurons_mac_2(90),
		 neuron_mac_3 => layer_1_neurons_mac_3(90),
		 neuron_mac_v => layer_1_neurons_mac(90));
LAYER_1_NEU_92_1: layer1_FCneuron_92
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(91));
LAYER_1_NEU_92_2: layer1_FCneuron_92
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(91));
LAYER_1_NEU_92_3: layer1_FCneuron_92
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(91));
VOT_LAYER_1_NEU_92 : VOT_layer1_FCneuron_92 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(91),
		 neuron_mac_2 => layer_1_neurons_mac_2(91),
		 neuron_mac_3 => layer_1_neurons_mac_3(91),
		 neuron_mac_v => layer_1_neurons_mac(91));
LAYER_1_NEU_93_1: layer1_FCneuron_93
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(92));
LAYER_1_NEU_93_2: layer1_FCneuron_93
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(92));
LAYER_1_NEU_93_3: layer1_FCneuron_93
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(92));
VOT_LAYER_1_NEU_93 : VOT_layer1_FCneuron_93 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(92),
		 neuron_mac_2 => layer_1_neurons_mac_2(92),
		 neuron_mac_3 => layer_1_neurons_mac_3(92),
		 neuron_mac_v => layer_1_neurons_mac(92));
LAYER_1_NEU_94_1: layer1_FCneuron_94
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(93));
LAYER_1_NEU_94_2: layer1_FCneuron_94
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(93));
LAYER_1_NEU_94_3: layer1_FCneuron_94
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(93));
VOT_LAYER_1_NEU_94 : VOT_layer1_FCneuron_94 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(93),
		 neuron_mac_2 => layer_1_neurons_mac_2(93),
		 neuron_mac_3 => layer_1_neurons_mac_3(93),
		 neuron_mac_v => layer_1_neurons_mac(93));
LAYER_1_NEU_95_1: layer1_FCneuron_95
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(94));
LAYER_1_NEU_95_2: layer1_FCneuron_95
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(94));
LAYER_1_NEU_95_3: layer1_FCneuron_95
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(94));
VOT_LAYER_1_NEU_95 : VOT_layer1_FCneuron_95 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(94),
		 neuron_mac_2 => layer_1_neurons_mac_2(94),
		 neuron_mac_3 => layer_1_neurons_mac_3(94),
		 neuron_mac_v => layer_1_neurons_mac(94));
LAYER_1_NEU_96_1: layer1_FCneuron_96
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(95));
LAYER_1_NEU_96_2: layer1_FCneuron_96
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(95));
LAYER_1_NEU_96_3: layer1_FCneuron_96
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(95));
VOT_LAYER_1_NEU_96 : VOT_layer1_FCneuron_96 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(95),
		 neuron_mac_2 => layer_1_neurons_mac_2(95),
		 neuron_mac_3 => layer_1_neurons_mac_3(95),
		 neuron_mac_v => layer_1_neurons_mac(95));
LAYER_1_NEU_97_1: layer1_FCneuron_97
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(96));
LAYER_1_NEU_97_2: layer1_FCneuron_97
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(96));
LAYER_1_NEU_97_3: layer1_FCneuron_97
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(96));
VOT_LAYER_1_NEU_97 : VOT_layer1_FCneuron_97 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(96),
		 neuron_mac_2 => layer_1_neurons_mac_2(96),
		 neuron_mac_3 => layer_1_neurons_mac_3(96),
		 neuron_mac_v => layer_1_neurons_mac(96));
LAYER_1_NEU_98_1: layer1_FCneuron_98
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(97));
LAYER_1_NEU_98_2: layer1_FCneuron_98
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(97));
LAYER_1_NEU_98_3: layer1_FCneuron_98
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(97));
VOT_LAYER_1_NEU_98 : VOT_layer1_FCneuron_98 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(97),
		 neuron_mac_2 => layer_1_neurons_mac_2(97),
		 neuron_mac_3 => layer_1_neurons_mac_3(97),
		 neuron_mac_v => layer_1_neurons_mac(97));
LAYER_1_NEU_99_1: layer1_FCneuron_99
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(98));
LAYER_1_NEU_99_2: layer1_FCneuron_99
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(98));
LAYER_1_NEU_99_3: layer1_FCneuron_99
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(98));
VOT_LAYER_1_NEU_99 : VOT_layer1_FCneuron_99 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(98),
		 neuron_mac_2 => layer_1_neurons_mac_2(98),
		 neuron_mac_3 => layer_1_neurons_mac_3(98),
		 neuron_mac_v => layer_1_neurons_mac(98));
LAYER_1_NEU_100_1: layer1_FCneuron_100
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(99));
LAYER_1_NEU_100_2: layer1_FCneuron_100
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(99));
LAYER_1_NEU_100_3: layer1_FCneuron_100
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(99));
VOT_LAYER_1_NEU_100 : VOT_layer1_FCneuron_100 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(99),
		 neuron_mac_2 => layer_1_neurons_mac_2(99),
		 neuron_mac_3 => layer_1_neurons_mac_3(99),
		 neuron_mac_v => layer_1_neurons_mac(99));
LAYER_1_NEU_101_1: layer1_FCneuron_101
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(100));
LAYER_1_NEU_101_2: layer1_FCneuron_101
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(100));
LAYER_1_NEU_101_3: layer1_FCneuron_101
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(100));
VOT_LAYER_1_NEU_101 : VOT_layer1_FCneuron_101 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(100),
		 neuron_mac_2 => layer_1_neurons_mac_2(100),
		 neuron_mac_3 => layer_1_neurons_mac_3(100),
		 neuron_mac_v => layer_1_neurons_mac(100));
LAYER_1_NEU_102_1: layer1_FCneuron_102
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(101));
LAYER_1_NEU_102_2: layer1_FCneuron_102
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(101));
LAYER_1_NEU_102_3: layer1_FCneuron_102
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(101));
VOT_LAYER_1_NEU_102 : VOT_layer1_FCneuron_102 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(101),
		 neuron_mac_2 => layer_1_neurons_mac_2(101),
		 neuron_mac_3 => layer_1_neurons_mac_3(101),
		 neuron_mac_v => layer_1_neurons_mac(101));
LAYER_1_NEU_103_1: layer1_FCneuron_103
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(102));
LAYER_1_NEU_103_2: layer1_FCneuron_103
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(102));
LAYER_1_NEU_103_3: layer1_FCneuron_103
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(102));
VOT_LAYER_1_NEU_103 : VOT_layer1_FCneuron_103 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(102),
		 neuron_mac_2 => layer_1_neurons_mac_2(102),
		 neuron_mac_3 => layer_1_neurons_mac_3(102),
		 neuron_mac_v => layer_1_neurons_mac(102));
LAYER_1_NEU_104_1: layer1_FCneuron_104
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(103));
LAYER_1_NEU_104_2: layer1_FCneuron_104
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(103));
LAYER_1_NEU_104_3: layer1_FCneuron_104
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(103));
VOT_LAYER_1_NEU_104 : VOT_layer1_FCneuron_104 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(103),
		 neuron_mac_2 => layer_1_neurons_mac_2(103),
		 neuron_mac_3 => layer_1_neurons_mac_3(103),
		 neuron_mac_v => layer_1_neurons_mac(103));
LAYER_1_NEU_105_1: layer1_FCneuron_105
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(104));
LAYER_1_NEU_105_2: layer1_FCneuron_105
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(104));
LAYER_1_NEU_105_3: layer1_FCneuron_105
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(104));
VOT_LAYER_1_NEU_105 : VOT_layer1_FCneuron_105 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(104),
		 neuron_mac_2 => layer_1_neurons_mac_2(104),
		 neuron_mac_3 => layer_1_neurons_mac_3(104),
		 neuron_mac_v => layer_1_neurons_mac(104));
LAYER_1_NEU_106_1: layer1_FCneuron_106
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(105));
LAYER_1_NEU_106_2: layer1_FCneuron_106
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(105));
LAYER_1_NEU_106_3: layer1_FCneuron_106
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(105));
VOT_LAYER_1_NEU_106 : VOT_layer1_FCneuron_106 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(105),
		 neuron_mac_2 => layer_1_neurons_mac_2(105),
		 neuron_mac_3 => layer_1_neurons_mac_3(105),
		 neuron_mac_v => layer_1_neurons_mac(105));
LAYER_1_NEU_107_1: layer1_FCneuron_107
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(106));
LAYER_1_NEU_107_2: layer1_FCneuron_107
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(106));
LAYER_1_NEU_107_3: layer1_FCneuron_107
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(106));
VOT_LAYER_1_NEU_107 : VOT_layer1_FCneuron_107 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(106),
		 neuron_mac_2 => layer_1_neurons_mac_2(106),
		 neuron_mac_3 => layer_1_neurons_mac_3(106),
		 neuron_mac_v => layer_1_neurons_mac(106));
LAYER_1_NEU_108_1: layer1_FCneuron_108
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(107));
LAYER_1_NEU_108_2: layer1_FCneuron_108
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(107));
LAYER_1_NEU_108_3: layer1_FCneuron_108
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(107));
VOT_LAYER_1_NEU_108 : VOT_layer1_FCneuron_108 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(107),
		 neuron_mac_2 => layer_1_neurons_mac_2(107),
		 neuron_mac_3 => layer_1_neurons_mac_3(107),
		 neuron_mac_v => layer_1_neurons_mac(107));
LAYER_1_NEU_109_1: layer1_FCneuron_109
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(108));
LAYER_1_NEU_109_2: layer1_FCneuron_109
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(108));
LAYER_1_NEU_109_3: layer1_FCneuron_109
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(108));
VOT_LAYER_1_NEU_109 : VOT_layer1_FCneuron_109 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(108),
		 neuron_mac_2 => layer_1_neurons_mac_2(108),
		 neuron_mac_3 => layer_1_neurons_mac_3(108),
		 neuron_mac_v => layer_1_neurons_mac(108));
LAYER_1_NEU_110_1: layer1_FCneuron_110
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(109));
LAYER_1_NEU_110_2: layer1_FCneuron_110
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(109));
LAYER_1_NEU_110_3: layer1_FCneuron_110
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(109));
VOT_LAYER_1_NEU_110 : VOT_layer1_FCneuron_110 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(109),
		 neuron_mac_2 => layer_1_neurons_mac_2(109),
		 neuron_mac_3 => layer_1_neurons_mac_3(109),
		 neuron_mac_v => layer_1_neurons_mac(109));
LAYER_1_NEU_111_1: layer1_FCneuron_111
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(110));
LAYER_1_NEU_111_2: layer1_FCneuron_111
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(110));
LAYER_1_NEU_111_3: layer1_FCneuron_111
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(110));
VOT_LAYER_1_NEU_111 : VOT_layer1_FCneuron_111 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(110),
		 neuron_mac_2 => layer_1_neurons_mac_2(110),
		 neuron_mac_3 => layer_1_neurons_mac_3(110),
		 neuron_mac_v => layer_1_neurons_mac(110));
LAYER_1_NEU_112_1: layer1_FCneuron_112
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(111));
LAYER_1_NEU_112_2: layer1_FCneuron_112
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(111));
LAYER_1_NEU_112_3: layer1_FCneuron_112
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(111));
VOT_LAYER_1_NEU_112 : VOT_layer1_FCneuron_112 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(111),
		 neuron_mac_2 => layer_1_neurons_mac_2(111),
		 neuron_mac_3 => layer_1_neurons_mac_3(111),
		 neuron_mac_v => layer_1_neurons_mac(111));
LAYER_1_NEU_113_1: layer1_FCneuron_113
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(112));
LAYER_1_NEU_113_2: layer1_FCneuron_113
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(112));
LAYER_1_NEU_113_3: layer1_FCneuron_113
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(112));
VOT_LAYER_1_NEU_113 : VOT_layer1_FCneuron_113 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(112),
		 neuron_mac_2 => layer_1_neurons_mac_2(112),
		 neuron_mac_3 => layer_1_neurons_mac_3(112),
		 neuron_mac_v => layer_1_neurons_mac(112));
LAYER_1_NEU_114_1: layer1_FCneuron_114
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(113));
LAYER_1_NEU_114_2: layer1_FCneuron_114
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(113));
LAYER_1_NEU_114_3: layer1_FCneuron_114
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(113));
VOT_LAYER_1_NEU_114 : VOT_layer1_FCneuron_114 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(113),
		 neuron_mac_2 => layer_1_neurons_mac_2(113),
		 neuron_mac_3 => layer_1_neurons_mac_3(113),
		 neuron_mac_v => layer_1_neurons_mac(113));
LAYER_1_NEU_115_1: layer1_FCneuron_115
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(114));
LAYER_1_NEU_115_2: layer1_FCneuron_115
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(114));
LAYER_1_NEU_115_3: layer1_FCneuron_115
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(114));
VOT_LAYER_1_NEU_115 : VOT_layer1_FCneuron_115 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(114),
		 neuron_mac_2 => layer_1_neurons_mac_2(114),
		 neuron_mac_3 => layer_1_neurons_mac_3(114),
		 neuron_mac_v => layer_1_neurons_mac(114));
LAYER_1_NEU_116_1: layer1_FCneuron_116
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(115));
LAYER_1_NEU_116_2: layer1_FCneuron_116
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(115));
LAYER_1_NEU_116_3: layer1_FCneuron_116
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(115));
VOT_LAYER_1_NEU_116 : VOT_layer1_FCneuron_116 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(115),
		 neuron_mac_2 => layer_1_neurons_mac_2(115),
		 neuron_mac_3 => layer_1_neurons_mac_3(115),
		 neuron_mac_v => layer_1_neurons_mac(115));
LAYER_1_NEU_117_1: layer1_FCneuron_117
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(116));
LAYER_1_NEU_117_2: layer1_FCneuron_117
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(116));
LAYER_1_NEU_117_3: layer1_FCneuron_117
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(116));
VOT_LAYER_1_NEU_117 : VOT_layer1_FCneuron_117 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(116),
		 neuron_mac_2 => layer_1_neurons_mac_2(116),
		 neuron_mac_3 => layer_1_neurons_mac_3(116),
		 neuron_mac_v => layer_1_neurons_mac(116));
LAYER_1_NEU_118_1: layer1_FCneuron_118
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(117));
LAYER_1_NEU_118_2: layer1_FCneuron_118
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(117));
LAYER_1_NEU_118_3: layer1_FCneuron_118
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(117));
VOT_LAYER_1_NEU_118 : VOT_layer1_FCneuron_118 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(117),
		 neuron_mac_2 => layer_1_neurons_mac_2(117),
		 neuron_mac_3 => layer_1_neurons_mac_3(117),
		 neuron_mac_v => layer_1_neurons_mac(117));
LAYER_1_NEU_119_1: layer1_FCneuron_119
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(118));
LAYER_1_NEU_119_2: layer1_FCneuron_119
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(118));
LAYER_1_NEU_119_3: layer1_FCneuron_119
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(118));
VOT_LAYER_1_NEU_119 : VOT_layer1_FCneuron_119 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(118),
		 neuron_mac_2 => layer_1_neurons_mac_2(118),
		 neuron_mac_3 => layer_1_neurons_mac_3(118),
		 neuron_mac_v => layer_1_neurons_mac(118));
LAYER_1_NEU_120_1: layer1_FCneuron_120
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_1(119));
LAYER_1_NEU_120_2: layer1_FCneuron_120
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_2(119));
LAYER_1_NEU_120_3: layer1_FCneuron_120
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => data_inL1,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_1_neurons_mac_3(119));
VOT_LAYER_1_NEU_120 : VOT_layer1_FCneuron_120 
port map ( 
		 neuron_mac_1 => layer_1_neurons_mac_1(119),
		 neuron_mac_2 => layer_1_neurons_mac_2(119),
		 neuron_mac_3 => layer_1_neurons_mac_3(119),
		 neuron_mac_v => layer_1_neurons_mac(119));
-- Register of the output data from the neurons
--LAYER_1_REG: Register_FCL1 
--port map ( clk => clk, 
--           rst => rst,
--           data_in => layer_1_neurons_mac, 
--           next_pipeline_step => next_pipeline_step,
--           data_out => data_out_register_L1);  
LAYER_1_REG_1: Register_FCL1 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_1_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L1_1);  

LAYER_1_REG_2: Register_FCL1 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_1_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L1_2);  

LAYER_1_REG_3: Register_FCL1 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_1_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L1_3);  

VOT_LAYER_1_REG: VOT_Register_FCL1 
port map (  
       data_out_1 => data_out_register_L1_1,
       data_out_2 => data_out_register_L1_2,
       data_out_3 => data_out_register_L1_3,
       data_out_v => data_out_register_L1);
       
 -- Assignment of value to the max and min signals for layer 1--
mac_max_L1(weight_size_L2fc + fractional_size_L2fc + n_extra_bits + 1 downto w_fractional_size_L2fc + fractional_size_L2fc + 1) <= (others => '0');
mac_max_L1(w_fractional_size_L2fc + fractional_size_L2fc downto w_fractional_size_L2fc ) <= (others => '1');
mac_max_L1(w_fractional_size_L2fc - 1 downto 0) <= (others => '0');

mac_min_L1(weight_size_L2fc + fractional_size_L2fc + n_extra_bits + 1 downto w_fractional_size_L2fc + fractional_size_L2fc + 1) <= (others => '1');
mac_min_L1( w_fractional_size_L2fc + fractional_size_L2fc downto 0 ) <= (others => '0');

 ctrl_muxL1 <= rom_addr_Fc(log2c(number_of_outputs_L1fc) - 1 downto 0 );
LAYER_1_MUX: Mux_FCL1 
port map ( data_in => data_out_register_L1, 
           ctrl => ctrl_muxL1, 
           mac_max => mac_max_L1,
           mac_min => mac_min_L1,
           data_out => data_out_multiplexer_L1); 
--Sigmoid_functionFCL1 : sigmoidFCL1
--   port map(
--   data_in => data_out_multiplexer_L1,
--   data_out => data_in_L2);
Sigmoid_functionFCL1_1 : sigmoidFCL1
   port map(
   data_in => data_out_multiplexer_L1,
   data_out => data_in_L2_1);
Sigmoid_functionFCL1_2 : sigmoidFCL1
   port map(
   data_in => data_out_multiplexer_L1,
   data_out => data_in_L2_2);
Sigmoid_functionFCL1_3 : sigmoidFCL1
   port map(
   data_in => data_out_multiplexer_L1,
   data_out => data_in_L2_3);
VOT_Sigmoid_functionFCL1 : VOT_sigmoidFCL1 
   port map(
		data_out_1 => data_in_L2_1,
		data_out_2 => data_in_L2_2,
		data_out_3 => data_in_L2_3,
		data_out_v => data_in_L2);
--PAR2SER_L2: PAR2SER
--generic map (input_size => input_size_L2fc)
--port map ( clk => clk,
--           rst => rst,
--           data_in => data_in_L2,
--           en_neuron => en_neuron,
--           bit_select => bit_select,
--           bit_out => bit_selected_L2);
PAR2SER_L2_1: PAR2SER
generic map (input_size => input_size_L2fc)
port map ( clk => clk,
           rst => rst,
           data_in => data_in_L2,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L2_1);

PAR2SER_L2_2: PAR2SER
generic map (input_size => input_size_L2fc)
port map ( clk => clk,
           rst => rst,
           data_in => data_in_L2,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L2_2);

PAR2SER_L2_3: PAR2SER
generic map (input_size => input_size_L2fc)
port map ( clk => clk,
           rst => rst,
           data_in => data_in_L2,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L2_3);

VOT_PAR2SER_L2: VOT_PAR2SER 
port map ( 
		 serial_out_1 => bit_selected_L2_1,
		 serial_out_2 => bit_selected_L2_2,
		 serial_out_3 => bit_selected_L2_3,
		 serial_out_v => bit_selected_L2);
-- Layer 1 Neurons instantiation
--LAYER_2_NEU_1: layer2_FCneuron_1
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(0));
--LAYER_2_NEU_2: layer2_FCneuron_2
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(1));
--LAYER_2_NEU_3: layer2_FCneuron_3
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(2));
--LAYER_2_NEU_4: layer2_FCneuron_4
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(3));
--LAYER_2_NEU_5: layer2_FCneuron_5
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(4));
--LAYER_2_NEU_6: layer2_FCneuron_6
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(5));
--LAYER_2_NEU_7: layer2_FCneuron_7
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(6));
--LAYER_2_NEU_8: layer2_FCneuron_8
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(7));
--LAYER_2_NEU_9: layer2_FCneuron_9
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(8));
--LAYER_2_NEU_10: layer2_FCneuron_10
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(9));
--LAYER_2_NEU_11: layer2_FCneuron_11
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(10));
--LAYER_2_NEU_12: layer2_FCneuron_12
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(11));
--LAYER_2_NEU_13: layer2_FCneuron_13
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(12));
--LAYER_2_NEU_14: layer2_FCneuron_14
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(13));
--LAYER_2_NEU_15: layer2_FCneuron_15
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(14));
--LAYER_2_NEU_16: layer2_FCneuron_16
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(15));
--LAYER_2_NEU_17: layer2_FCneuron_17
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(16));
--LAYER_2_NEU_18: layer2_FCneuron_18
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(17));
--LAYER_2_NEU_19: layer2_FCneuron_19
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(18));
--LAYER_2_NEU_20: layer2_FCneuron_20
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(19));
--LAYER_2_NEU_21: layer2_FCneuron_21
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(20));
--LAYER_2_NEU_22: layer2_FCneuron_22
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(21));
--LAYER_2_NEU_23: layer2_FCneuron_23
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(22));
--LAYER_2_NEU_24: layer2_FCneuron_24
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(23));
--LAYER_2_NEU_25: layer2_FCneuron_25
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(24));
--LAYER_2_NEU_26: layer2_FCneuron_26
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(25));
--LAYER_2_NEU_27: layer2_FCneuron_27
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(26));
--LAYER_2_NEU_28: layer2_FCneuron_28
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(27));
--LAYER_2_NEU_29: layer2_FCneuron_29
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(28));
--LAYER_2_NEU_30: layer2_FCneuron_30
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(29));
--LAYER_2_NEU_31: layer2_FCneuron_31
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(30));
--LAYER_2_NEU_32: layer2_FCneuron_32
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(31));
--LAYER_2_NEU_33: layer2_FCneuron_33
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(32));
--LAYER_2_NEU_34: layer2_FCneuron_34
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(33));
--LAYER_2_NEU_35: layer2_FCneuron_35
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(34));
--LAYER_2_NEU_36: layer2_FCneuron_36
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(35));
--LAYER_2_NEU_37: layer2_FCneuron_37
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(36));
--LAYER_2_NEU_38: layer2_FCneuron_38
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(37));
--LAYER_2_NEU_39: layer2_FCneuron_39
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(38));
--LAYER_2_NEU_40: layer2_FCneuron_40
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(39));
--LAYER_2_NEU_41: layer2_FCneuron_41
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(40));
--LAYER_2_NEU_42: layer2_FCneuron_42
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(41));
--LAYER_2_NEU_43: layer2_FCneuron_43
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(42));
--LAYER_2_NEU_44: layer2_FCneuron_44
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(43));
--LAYER_2_NEU_45: layer2_FCneuron_45
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(44));
--LAYER_2_NEU_46: layer2_FCneuron_46
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(45));
--LAYER_2_NEU_47: layer2_FCneuron_47
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(46));
--LAYER_2_NEU_48: layer2_FCneuron_48
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(47));
--LAYER_2_NEU_49: layer2_FCneuron_49
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(48));
--LAYER_2_NEU_50: layer2_FCneuron_50
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(49));
--LAYER_2_NEU_51: layer2_FCneuron_51
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(50));
--LAYER_2_NEU_52: layer2_FCneuron_52
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(51));
--LAYER_2_NEU_53: layer2_FCneuron_53
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(52));
--LAYER_2_NEU_54: layer2_FCneuron_54
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(53));
--LAYER_2_NEU_55: layer2_FCneuron_55
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(54));
--LAYER_2_NEU_56: layer2_FCneuron_56
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(55));
--LAYER_2_NEU_57: layer2_FCneuron_57
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(56));
--LAYER_2_NEU_58: layer2_FCneuron_58
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(57));
--LAYER_2_NEU_59: layer2_FCneuron_59
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(58));
--LAYER_2_NEU_60: layer2_FCneuron_60
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(59));
--LAYER_2_NEU_61: layer2_FCneuron_61
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(60));
--LAYER_2_NEU_62: layer2_FCneuron_62
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(61));
--LAYER_2_NEU_63: layer2_FCneuron_63
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(62));
--LAYER_2_NEU_64: layer2_FCneuron_64
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(63));
--LAYER_2_NEU_65: layer2_FCneuron_65
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(64));
--LAYER_2_NEU_66: layer2_FCneuron_66
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(65));
--LAYER_2_NEU_67: layer2_FCneuron_67
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(66));
--LAYER_2_NEU_68: layer2_FCneuron_68
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(67));
--LAYER_2_NEU_69: layer2_FCneuron_69
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(68));
--LAYER_2_NEU_70: layer2_FCneuron_70
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(69));
--LAYER_2_NEU_71: layer2_FCneuron_71
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(70));
--LAYER_2_NEU_72: layer2_FCneuron_72
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(71));
--LAYER_2_NEU_73: layer2_FCneuron_73
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(72));
--LAYER_2_NEU_74: layer2_FCneuron_74
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(73));
--LAYER_2_NEU_75: layer2_FCneuron_75
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(74));
--LAYER_2_NEU_76: layer2_FCneuron_76
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(75));
--LAYER_2_NEU_77: layer2_FCneuron_77
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(76));
--LAYER_2_NEU_78: layer2_FCneuron_78
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(77));
--LAYER_2_NEU_79: layer2_FCneuron_79
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(78));
--LAYER_2_NEU_80: layer2_FCneuron_80
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(79));
--LAYER_2_NEU_81: layer2_FCneuron_81
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(80));
--LAYER_2_NEU_82: layer2_FCneuron_82
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(81));
--LAYER_2_NEU_83: layer2_FCneuron_83
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(82));
--LAYER_2_NEU_84: layer2_FCneuron_84
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L2,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_2_neurons_mac(83));
LAYER_2_NEU_1_1: layer2_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(0));
LAYER_2_NEU_1_2: layer2_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(0));
LAYER_2_NEU_1_3: layer2_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(0));
VOT_LAYER_2_NEU_1 : VOT_layer2_FCneuron_1 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(0),
		 neuron_mac_2 => layer_2_neurons_mac_2(0),
		 neuron_mac_3 => layer_2_neurons_mac_3(0),
		 neuron_mac_v => layer_2_neurons_mac(0));
LAYER_2_NEU_2_1: layer2_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(1));
LAYER_2_NEU_2_2: layer2_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(1));
LAYER_2_NEU_2_3: layer2_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(1));
VOT_LAYER_2_NEU_2 : VOT_layer2_FCneuron_2 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(1),
		 neuron_mac_2 => layer_2_neurons_mac_2(1),
		 neuron_mac_3 => layer_2_neurons_mac_3(1),
		 neuron_mac_v => layer_2_neurons_mac(1));
LAYER_2_NEU_3_1: layer2_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(2));
LAYER_2_NEU_3_2: layer2_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(2));
LAYER_2_NEU_3_3: layer2_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(2));
VOT_LAYER_2_NEU_3 : VOT_layer2_FCneuron_3 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(2),
		 neuron_mac_2 => layer_2_neurons_mac_2(2),
		 neuron_mac_3 => layer_2_neurons_mac_3(2),
		 neuron_mac_v => layer_2_neurons_mac(2));
LAYER_2_NEU_4_1: layer2_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(3));
LAYER_2_NEU_4_2: layer2_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(3));
LAYER_2_NEU_4_3: layer2_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(3));
VOT_LAYER_2_NEU_4 : VOT_layer2_FCneuron_4 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(3),
		 neuron_mac_2 => layer_2_neurons_mac_2(3),
		 neuron_mac_3 => layer_2_neurons_mac_3(3),
		 neuron_mac_v => layer_2_neurons_mac(3));
LAYER_2_NEU_5_1: layer2_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(4));
LAYER_2_NEU_5_2: layer2_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(4));
LAYER_2_NEU_5_3: layer2_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(4));
VOT_LAYER_2_NEU_5 : VOT_layer2_FCneuron_5 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(4),
		 neuron_mac_2 => layer_2_neurons_mac_2(4),
		 neuron_mac_3 => layer_2_neurons_mac_3(4),
		 neuron_mac_v => layer_2_neurons_mac(4));
LAYER_2_NEU_6_1: layer2_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(5));
LAYER_2_NEU_6_2: layer2_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(5));
LAYER_2_NEU_6_3: layer2_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(5));
VOT_LAYER_2_NEU_6 : VOT_layer2_FCneuron_6 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(5),
		 neuron_mac_2 => layer_2_neurons_mac_2(5),
		 neuron_mac_3 => layer_2_neurons_mac_3(5),
		 neuron_mac_v => layer_2_neurons_mac(5));
LAYER_2_NEU_7_1: layer2_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(6));
LAYER_2_NEU_7_2: layer2_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(6));
LAYER_2_NEU_7_3: layer2_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(6));
VOT_LAYER_2_NEU_7 : VOT_layer2_FCneuron_7 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(6),
		 neuron_mac_2 => layer_2_neurons_mac_2(6),
		 neuron_mac_3 => layer_2_neurons_mac_3(6),
		 neuron_mac_v => layer_2_neurons_mac(6));
LAYER_2_NEU_8_1: layer2_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(7));
LAYER_2_NEU_8_2: layer2_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(7));
LAYER_2_NEU_8_3: layer2_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(7));
VOT_LAYER_2_NEU_8 : VOT_layer2_FCneuron_8 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(7),
		 neuron_mac_2 => layer_2_neurons_mac_2(7),
		 neuron_mac_3 => layer_2_neurons_mac_3(7),
		 neuron_mac_v => layer_2_neurons_mac(7));
LAYER_2_NEU_9_1: layer2_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(8));
LAYER_2_NEU_9_2: layer2_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(8));
LAYER_2_NEU_9_3: layer2_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(8));
VOT_LAYER_2_NEU_9 : VOT_layer2_FCneuron_9 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(8),
		 neuron_mac_2 => layer_2_neurons_mac_2(8),
		 neuron_mac_3 => layer_2_neurons_mac_3(8),
		 neuron_mac_v => layer_2_neurons_mac(8));
LAYER_2_NEU_10_1: layer2_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(9));
LAYER_2_NEU_10_2: layer2_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(9));
LAYER_2_NEU_10_3: layer2_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(9));
VOT_LAYER_2_NEU_10 : VOT_layer2_FCneuron_10 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(9),
		 neuron_mac_2 => layer_2_neurons_mac_2(9),
		 neuron_mac_3 => layer_2_neurons_mac_3(9),
		 neuron_mac_v => layer_2_neurons_mac(9));
LAYER_2_NEU_11_1: layer2_FCneuron_11
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(10));
LAYER_2_NEU_11_2: layer2_FCneuron_11
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(10));
LAYER_2_NEU_11_3: layer2_FCneuron_11
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(10));
VOT_LAYER_2_NEU_11 : VOT_layer2_FCneuron_11 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(10),
		 neuron_mac_2 => layer_2_neurons_mac_2(10),
		 neuron_mac_3 => layer_2_neurons_mac_3(10),
		 neuron_mac_v => layer_2_neurons_mac(10));
LAYER_2_NEU_12_1: layer2_FCneuron_12
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(11));
LAYER_2_NEU_12_2: layer2_FCneuron_12
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(11));
LAYER_2_NEU_12_3: layer2_FCneuron_12
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(11));
VOT_LAYER_2_NEU_12 : VOT_layer2_FCneuron_12 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(11),
		 neuron_mac_2 => layer_2_neurons_mac_2(11),
		 neuron_mac_3 => layer_2_neurons_mac_3(11),
		 neuron_mac_v => layer_2_neurons_mac(11));
LAYER_2_NEU_13_1: layer2_FCneuron_13
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(12));
LAYER_2_NEU_13_2: layer2_FCneuron_13
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(12));
LAYER_2_NEU_13_3: layer2_FCneuron_13
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(12));
VOT_LAYER_2_NEU_13 : VOT_layer2_FCneuron_13 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(12),
		 neuron_mac_2 => layer_2_neurons_mac_2(12),
		 neuron_mac_3 => layer_2_neurons_mac_3(12),
		 neuron_mac_v => layer_2_neurons_mac(12));
LAYER_2_NEU_14_1: layer2_FCneuron_14
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(13));
LAYER_2_NEU_14_2: layer2_FCneuron_14
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(13));
LAYER_2_NEU_14_3: layer2_FCneuron_14
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(13));
VOT_LAYER_2_NEU_14 : VOT_layer2_FCneuron_14 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(13),
		 neuron_mac_2 => layer_2_neurons_mac_2(13),
		 neuron_mac_3 => layer_2_neurons_mac_3(13),
		 neuron_mac_v => layer_2_neurons_mac(13));
LAYER_2_NEU_15_1: layer2_FCneuron_15
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(14));
LAYER_2_NEU_15_2: layer2_FCneuron_15
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(14));
LAYER_2_NEU_15_3: layer2_FCneuron_15
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(14));
VOT_LAYER_2_NEU_15 : VOT_layer2_FCneuron_15 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(14),
		 neuron_mac_2 => layer_2_neurons_mac_2(14),
		 neuron_mac_3 => layer_2_neurons_mac_3(14),
		 neuron_mac_v => layer_2_neurons_mac(14));
LAYER_2_NEU_16_1: layer2_FCneuron_16
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(15));
LAYER_2_NEU_16_2: layer2_FCneuron_16
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(15));
LAYER_2_NEU_16_3: layer2_FCneuron_16
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(15));
VOT_LAYER_2_NEU_16 : VOT_layer2_FCneuron_16 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(15),
		 neuron_mac_2 => layer_2_neurons_mac_2(15),
		 neuron_mac_3 => layer_2_neurons_mac_3(15),
		 neuron_mac_v => layer_2_neurons_mac(15));
LAYER_2_NEU_17_1: layer2_FCneuron_17
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(16));
LAYER_2_NEU_17_2: layer2_FCneuron_17
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(16));
LAYER_2_NEU_17_3: layer2_FCneuron_17
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(16));
VOT_LAYER_2_NEU_17 : VOT_layer2_FCneuron_17 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(16),
		 neuron_mac_2 => layer_2_neurons_mac_2(16),
		 neuron_mac_3 => layer_2_neurons_mac_3(16),
		 neuron_mac_v => layer_2_neurons_mac(16));
LAYER_2_NEU_18_1: layer2_FCneuron_18
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(17));
LAYER_2_NEU_18_2: layer2_FCneuron_18
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(17));
LAYER_2_NEU_18_3: layer2_FCneuron_18
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(17));
VOT_LAYER_2_NEU_18 : VOT_layer2_FCneuron_18 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(17),
		 neuron_mac_2 => layer_2_neurons_mac_2(17),
		 neuron_mac_3 => layer_2_neurons_mac_3(17),
		 neuron_mac_v => layer_2_neurons_mac(17));
LAYER_2_NEU_19_1: layer2_FCneuron_19
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(18));
LAYER_2_NEU_19_2: layer2_FCneuron_19
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(18));
LAYER_2_NEU_19_3: layer2_FCneuron_19
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(18));
VOT_LAYER_2_NEU_19 : VOT_layer2_FCneuron_19 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(18),
		 neuron_mac_2 => layer_2_neurons_mac_2(18),
		 neuron_mac_3 => layer_2_neurons_mac_3(18),
		 neuron_mac_v => layer_2_neurons_mac(18));
LAYER_2_NEU_20_1: layer2_FCneuron_20
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(19));
LAYER_2_NEU_20_2: layer2_FCneuron_20
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(19));
LAYER_2_NEU_20_3: layer2_FCneuron_20
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(19));
VOT_LAYER_2_NEU_20 : VOT_layer2_FCneuron_20 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(19),
		 neuron_mac_2 => layer_2_neurons_mac_2(19),
		 neuron_mac_3 => layer_2_neurons_mac_3(19),
		 neuron_mac_v => layer_2_neurons_mac(19));
LAYER_2_NEU_21_1: layer2_FCneuron_21
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(20));
LAYER_2_NEU_21_2: layer2_FCneuron_21
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(20));
LAYER_2_NEU_21_3: layer2_FCneuron_21
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(20));
VOT_LAYER_2_NEU_21 : VOT_layer2_FCneuron_21 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(20),
		 neuron_mac_2 => layer_2_neurons_mac_2(20),
		 neuron_mac_3 => layer_2_neurons_mac_3(20),
		 neuron_mac_v => layer_2_neurons_mac(20));
LAYER_2_NEU_22_1: layer2_FCneuron_22
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(21));
LAYER_2_NEU_22_2: layer2_FCneuron_22
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(21));
LAYER_2_NEU_22_3: layer2_FCneuron_22
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(21));
VOT_LAYER_2_NEU_22 : VOT_layer2_FCneuron_22 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(21),
		 neuron_mac_2 => layer_2_neurons_mac_2(21),
		 neuron_mac_3 => layer_2_neurons_mac_3(21),
		 neuron_mac_v => layer_2_neurons_mac(21));
LAYER_2_NEU_23_1: layer2_FCneuron_23
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(22));
LAYER_2_NEU_23_2: layer2_FCneuron_23
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(22));
LAYER_2_NEU_23_3: layer2_FCneuron_23
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(22));
VOT_LAYER_2_NEU_23 : VOT_layer2_FCneuron_23 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(22),
		 neuron_mac_2 => layer_2_neurons_mac_2(22),
		 neuron_mac_3 => layer_2_neurons_mac_3(22),
		 neuron_mac_v => layer_2_neurons_mac(22));
LAYER_2_NEU_24_1: layer2_FCneuron_24
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(23));
LAYER_2_NEU_24_2: layer2_FCneuron_24
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(23));
LAYER_2_NEU_24_3: layer2_FCneuron_24
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(23));
VOT_LAYER_2_NEU_24 : VOT_layer2_FCneuron_24 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(23),
		 neuron_mac_2 => layer_2_neurons_mac_2(23),
		 neuron_mac_3 => layer_2_neurons_mac_3(23),
		 neuron_mac_v => layer_2_neurons_mac(23));
LAYER_2_NEU_25_1: layer2_FCneuron_25
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(24));
LAYER_2_NEU_25_2: layer2_FCneuron_25
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(24));
LAYER_2_NEU_25_3: layer2_FCneuron_25
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(24));
VOT_LAYER_2_NEU_25 : VOT_layer2_FCneuron_25 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(24),
		 neuron_mac_2 => layer_2_neurons_mac_2(24),
		 neuron_mac_3 => layer_2_neurons_mac_3(24),
		 neuron_mac_v => layer_2_neurons_mac(24));
LAYER_2_NEU_26_1: layer2_FCneuron_26
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(25));
LAYER_2_NEU_26_2: layer2_FCneuron_26
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(25));
LAYER_2_NEU_26_3: layer2_FCneuron_26
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(25));
VOT_LAYER_2_NEU_26 : VOT_layer2_FCneuron_26 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(25),
		 neuron_mac_2 => layer_2_neurons_mac_2(25),
		 neuron_mac_3 => layer_2_neurons_mac_3(25),
		 neuron_mac_v => layer_2_neurons_mac(25));
LAYER_2_NEU_27_1: layer2_FCneuron_27
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(26));
LAYER_2_NEU_27_2: layer2_FCneuron_27
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(26));
LAYER_2_NEU_27_3: layer2_FCneuron_27
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(26));
VOT_LAYER_2_NEU_27 : VOT_layer2_FCneuron_27 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(26),
		 neuron_mac_2 => layer_2_neurons_mac_2(26),
		 neuron_mac_3 => layer_2_neurons_mac_3(26),
		 neuron_mac_v => layer_2_neurons_mac(26));
LAYER_2_NEU_28_1: layer2_FCneuron_28
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(27));
LAYER_2_NEU_28_2: layer2_FCneuron_28
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(27));
LAYER_2_NEU_28_3: layer2_FCneuron_28
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(27));
VOT_LAYER_2_NEU_28 : VOT_layer2_FCneuron_28 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(27),
		 neuron_mac_2 => layer_2_neurons_mac_2(27),
		 neuron_mac_3 => layer_2_neurons_mac_3(27),
		 neuron_mac_v => layer_2_neurons_mac(27));
LAYER_2_NEU_29_1: layer2_FCneuron_29
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(28));
LAYER_2_NEU_29_2: layer2_FCneuron_29
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(28));
LAYER_2_NEU_29_3: layer2_FCneuron_29
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(28));
VOT_LAYER_2_NEU_29 : VOT_layer2_FCneuron_29 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(28),
		 neuron_mac_2 => layer_2_neurons_mac_2(28),
		 neuron_mac_3 => layer_2_neurons_mac_3(28),
		 neuron_mac_v => layer_2_neurons_mac(28));
LAYER_2_NEU_30_1: layer2_FCneuron_30
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(29));
LAYER_2_NEU_30_2: layer2_FCneuron_30
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(29));
LAYER_2_NEU_30_3: layer2_FCneuron_30
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(29));
VOT_LAYER_2_NEU_30 : VOT_layer2_FCneuron_30 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(29),
		 neuron_mac_2 => layer_2_neurons_mac_2(29),
		 neuron_mac_3 => layer_2_neurons_mac_3(29),
		 neuron_mac_v => layer_2_neurons_mac(29));
LAYER_2_NEU_31_1: layer2_FCneuron_31
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(30));
LAYER_2_NEU_31_2: layer2_FCneuron_31
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(30));
LAYER_2_NEU_31_3: layer2_FCneuron_31
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(30));
VOT_LAYER_2_NEU_31 : VOT_layer2_FCneuron_31 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(30),
		 neuron_mac_2 => layer_2_neurons_mac_2(30),
		 neuron_mac_3 => layer_2_neurons_mac_3(30),
		 neuron_mac_v => layer_2_neurons_mac(30));
LAYER_2_NEU_32_1: layer2_FCneuron_32
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(31));
LAYER_2_NEU_32_2: layer2_FCneuron_32
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(31));
LAYER_2_NEU_32_3: layer2_FCneuron_32
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(31));
VOT_LAYER_2_NEU_32 : VOT_layer2_FCneuron_32 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(31),
		 neuron_mac_2 => layer_2_neurons_mac_2(31),
		 neuron_mac_3 => layer_2_neurons_mac_3(31),
		 neuron_mac_v => layer_2_neurons_mac(31));
LAYER_2_NEU_33_1: layer2_FCneuron_33
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(32));
LAYER_2_NEU_33_2: layer2_FCneuron_33
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(32));
LAYER_2_NEU_33_3: layer2_FCneuron_33
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(32));
VOT_LAYER_2_NEU_33 : VOT_layer2_FCneuron_33 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(32),
		 neuron_mac_2 => layer_2_neurons_mac_2(32),
		 neuron_mac_3 => layer_2_neurons_mac_3(32),
		 neuron_mac_v => layer_2_neurons_mac(32));
LAYER_2_NEU_34_1: layer2_FCneuron_34
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(33));
LAYER_2_NEU_34_2: layer2_FCneuron_34
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(33));
LAYER_2_NEU_34_3: layer2_FCneuron_34
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(33));
VOT_LAYER_2_NEU_34 : VOT_layer2_FCneuron_34 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(33),
		 neuron_mac_2 => layer_2_neurons_mac_2(33),
		 neuron_mac_3 => layer_2_neurons_mac_3(33),
		 neuron_mac_v => layer_2_neurons_mac(33));
LAYER_2_NEU_35_1: layer2_FCneuron_35
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(34));
LAYER_2_NEU_35_2: layer2_FCneuron_35
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(34));
LAYER_2_NEU_35_3: layer2_FCneuron_35
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(34));
VOT_LAYER_2_NEU_35 : VOT_layer2_FCneuron_35 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(34),
		 neuron_mac_2 => layer_2_neurons_mac_2(34),
		 neuron_mac_3 => layer_2_neurons_mac_3(34),
		 neuron_mac_v => layer_2_neurons_mac(34));
LAYER_2_NEU_36_1: layer2_FCneuron_36
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(35));
LAYER_2_NEU_36_2: layer2_FCneuron_36
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(35));
LAYER_2_NEU_36_3: layer2_FCneuron_36
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(35));
VOT_LAYER_2_NEU_36 : VOT_layer2_FCneuron_36 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(35),
		 neuron_mac_2 => layer_2_neurons_mac_2(35),
		 neuron_mac_3 => layer_2_neurons_mac_3(35),
		 neuron_mac_v => layer_2_neurons_mac(35));
LAYER_2_NEU_37_1: layer2_FCneuron_37
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(36));
LAYER_2_NEU_37_2: layer2_FCneuron_37
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(36));
LAYER_2_NEU_37_3: layer2_FCneuron_37
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(36));
VOT_LAYER_2_NEU_37 : VOT_layer2_FCneuron_37 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(36),
		 neuron_mac_2 => layer_2_neurons_mac_2(36),
		 neuron_mac_3 => layer_2_neurons_mac_3(36),
		 neuron_mac_v => layer_2_neurons_mac(36));
LAYER_2_NEU_38_1: layer2_FCneuron_38
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(37));
LAYER_2_NEU_38_2: layer2_FCneuron_38
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(37));
LAYER_2_NEU_38_3: layer2_FCneuron_38
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(37));
VOT_LAYER_2_NEU_38 : VOT_layer2_FCneuron_38 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(37),
		 neuron_mac_2 => layer_2_neurons_mac_2(37),
		 neuron_mac_3 => layer_2_neurons_mac_3(37),
		 neuron_mac_v => layer_2_neurons_mac(37));
LAYER_2_NEU_39_1: layer2_FCneuron_39
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(38));
LAYER_2_NEU_39_2: layer2_FCneuron_39
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(38));
LAYER_2_NEU_39_3: layer2_FCneuron_39
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(38));
VOT_LAYER_2_NEU_39 : VOT_layer2_FCneuron_39 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(38),
		 neuron_mac_2 => layer_2_neurons_mac_2(38),
		 neuron_mac_3 => layer_2_neurons_mac_3(38),
		 neuron_mac_v => layer_2_neurons_mac(38));
LAYER_2_NEU_40_1: layer2_FCneuron_40
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(39));
LAYER_2_NEU_40_2: layer2_FCneuron_40
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(39));
LAYER_2_NEU_40_3: layer2_FCneuron_40
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(39));
VOT_LAYER_2_NEU_40 : VOT_layer2_FCneuron_40 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(39),
		 neuron_mac_2 => layer_2_neurons_mac_2(39),
		 neuron_mac_3 => layer_2_neurons_mac_3(39),
		 neuron_mac_v => layer_2_neurons_mac(39));
LAYER_2_NEU_41_1: layer2_FCneuron_41
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(40));
LAYER_2_NEU_41_2: layer2_FCneuron_41
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(40));
LAYER_2_NEU_41_3: layer2_FCneuron_41
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(40));
VOT_LAYER_2_NEU_41 : VOT_layer2_FCneuron_41 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(40),
		 neuron_mac_2 => layer_2_neurons_mac_2(40),
		 neuron_mac_3 => layer_2_neurons_mac_3(40),
		 neuron_mac_v => layer_2_neurons_mac(40));
LAYER_2_NEU_42_1: layer2_FCneuron_42
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(41));
LAYER_2_NEU_42_2: layer2_FCneuron_42
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(41));
LAYER_2_NEU_42_3: layer2_FCneuron_42
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(41));
VOT_LAYER_2_NEU_42 : VOT_layer2_FCneuron_42 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(41),
		 neuron_mac_2 => layer_2_neurons_mac_2(41),
		 neuron_mac_3 => layer_2_neurons_mac_3(41),
		 neuron_mac_v => layer_2_neurons_mac(41));
LAYER_2_NEU_43_1: layer2_FCneuron_43
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(42));
LAYER_2_NEU_43_2: layer2_FCneuron_43
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(42));
LAYER_2_NEU_43_3: layer2_FCneuron_43
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(42));
VOT_LAYER_2_NEU_43 : VOT_layer2_FCneuron_43 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(42),
		 neuron_mac_2 => layer_2_neurons_mac_2(42),
		 neuron_mac_3 => layer_2_neurons_mac_3(42),
		 neuron_mac_v => layer_2_neurons_mac(42));
LAYER_2_NEU_44_1: layer2_FCneuron_44
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(43));
LAYER_2_NEU_44_2: layer2_FCneuron_44
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(43));
LAYER_2_NEU_44_3: layer2_FCneuron_44
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(43));
VOT_LAYER_2_NEU_44 : VOT_layer2_FCneuron_44 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(43),
		 neuron_mac_2 => layer_2_neurons_mac_2(43),
		 neuron_mac_3 => layer_2_neurons_mac_3(43),
		 neuron_mac_v => layer_2_neurons_mac(43));
LAYER_2_NEU_45_1: layer2_FCneuron_45
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(44));
LAYER_2_NEU_45_2: layer2_FCneuron_45
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(44));
LAYER_2_NEU_45_3: layer2_FCneuron_45
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(44));
VOT_LAYER_2_NEU_45 : VOT_layer2_FCneuron_45 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(44),
		 neuron_mac_2 => layer_2_neurons_mac_2(44),
		 neuron_mac_3 => layer_2_neurons_mac_3(44),
		 neuron_mac_v => layer_2_neurons_mac(44));
LAYER_2_NEU_46_1: layer2_FCneuron_46
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(45));
LAYER_2_NEU_46_2: layer2_FCneuron_46
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(45));
LAYER_2_NEU_46_3: layer2_FCneuron_46
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(45));
VOT_LAYER_2_NEU_46 : VOT_layer2_FCneuron_46 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(45),
		 neuron_mac_2 => layer_2_neurons_mac_2(45),
		 neuron_mac_3 => layer_2_neurons_mac_3(45),
		 neuron_mac_v => layer_2_neurons_mac(45));
LAYER_2_NEU_47_1: layer2_FCneuron_47
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(46));
LAYER_2_NEU_47_2: layer2_FCneuron_47
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(46));
LAYER_2_NEU_47_3: layer2_FCneuron_47
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(46));
VOT_LAYER_2_NEU_47 : VOT_layer2_FCneuron_47 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(46),
		 neuron_mac_2 => layer_2_neurons_mac_2(46),
		 neuron_mac_3 => layer_2_neurons_mac_3(46),
		 neuron_mac_v => layer_2_neurons_mac(46));
LAYER_2_NEU_48_1: layer2_FCneuron_48
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(47));
LAYER_2_NEU_48_2: layer2_FCneuron_48
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(47));
LAYER_2_NEU_48_3: layer2_FCneuron_48
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(47));
VOT_LAYER_2_NEU_48 : VOT_layer2_FCneuron_48 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(47),
		 neuron_mac_2 => layer_2_neurons_mac_2(47),
		 neuron_mac_3 => layer_2_neurons_mac_3(47),
		 neuron_mac_v => layer_2_neurons_mac(47));
LAYER_2_NEU_49_1: layer2_FCneuron_49
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(48));
LAYER_2_NEU_49_2: layer2_FCneuron_49
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(48));
LAYER_2_NEU_49_3: layer2_FCneuron_49
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(48));
VOT_LAYER_2_NEU_49 : VOT_layer2_FCneuron_49 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(48),
		 neuron_mac_2 => layer_2_neurons_mac_2(48),
		 neuron_mac_3 => layer_2_neurons_mac_3(48),
		 neuron_mac_v => layer_2_neurons_mac(48));
LAYER_2_NEU_50_1: layer2_FCneuron_50
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(49));
LAYER_2_NEU_50_2: layer2_FCneuron_50
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(49));
LAYER_2_NEU_50_3: layer2_FCneuron_50
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(49));
VOT_LAYER_2_NEU_50 : VOT_layer2_FCneuron_50 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(49),
		 neuron_mac_2 => layer_2_neurons_mac_2(49),
		 neuron_mac_3 => layer_2_neurons_mac_3(49),
		 neuron_mac_v => layer_2_neurons_mac(49));
LAYER_2_NEU_51_1: layer2_FCneuron_51
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(50));
LAYER_2_NEU_51_2: layer2_FCneuron_51
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(50));
LAYER_2_NEU_51_3: layer2_FCneuron_51
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(50));
VOT_LAYER_2_NEU_51 : VOT_layer2_FCneuron_51 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(50),
		 neuron_mac_2 => layer_2_neurons_mac_2(50),
		 neuron_mac_3 => layer_2_neurons_mac_3(50),
		 neuron_mac_v => layer_2_neurons_mac(50));
LAYER_2_NEU_52_1: layer2_FCneuron_52
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(51));
LAYER_2_NEU_52_2: layer2_FCneuron_52
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(51));
LAYER_2_NEU_52_3: layer2_FCneuron_52
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(51));
VOT_LAYER_2_NEU_52 : VOT_layer2_FCneuron_52 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(51),
		 neuron_mac_2 => layer_2_neurons_mac_2(51),
		 neuron_mac_3 => layer_2_neurons_mac_3(51),
		 neuron_mac_v => layer_2_neurons_mac(51));
LAYER_2_NEU_53_1: layer2_FCneuron_53
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(52));
LAYER_2_NEU_53_2: layer2_FCneuron_53
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(52));
LAYER_2_NEU_53_3: layer2_FCneuron_53
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(52));
VOT_LAYER_2_NEU_53 : VOT_layer2_FCneuron_53 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(52),
		 neuron_mac_2 => layer_2_neurons_mac_2(52),
		 neuron_mac_3 => layer_2_neurons_mac_3(52),
		 neuron_mac_v => layer_2_neurons_mac(52));
LAYER_2_NEU_54_1: layer2_FCneuron_54
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(53));
LAYER_2_NEU_54_2: layer2_FCneuron_54
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(53));
LAYER_2_NEU_54_3: layer2_FCneuron_54
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(53));
VOT_LAYER_2_NEU_54 : VOT_layer2_FCneuron_54 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(53),
		 neuron_mac_2 => layer_2_neurons_mac_2(53),
		 neuron_mac_3 => layer_2_neurons_mac_3(53),
		 neuron_mac_v => layer_2_neurons_mac(53));
LAYER_2_NEU_55_1: layer2_FCneuron_55
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(54));
LAYER_2_NEU_55_2: layer2_FCneuron_55
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(54));
LAYER_2_NEU_55_3: layer2_FCneuron_55
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(54));
VOT_LAYER_2_NEU_55 : VOT_layer2_FCneuron_55 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(54),
		 neuron_mac_2 => layer_2_neurons_mac_2(54),
		 neuron_mac_3 => layer_2_neurons_mac_3(54),
		 neuron_mac_v => layer_2_neurons_mac(54));
LAYER_2_NEU_56_1: layer2_FCneuron_56
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(55));
LAYER_2_NEU_56_2: layer2_FCneuron_56
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(55));
LAYER_2_NEU_56_3: layer2_FCneuron_56
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(55));
VOT_LAYER_2_NEU_56 : VOT_layer2_FCneuron_56 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(55),
		 neuron_mac_2 => layer_2_neurons_mac_2(55),
		 neuron_mac_3 => layer_2_neurons_mac_3(55),
		 neuron_mac_v => layer_2_neurons_mac(55));
LAYER_2_NEU_57_1: layer2_FCneuron_57
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(56));
LAYER_2_NEU_57_2: layer2_FCneuron_57
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(56));
LAYER_2_NEU_57_3: layer2_FCneuron_57
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(56));
VOT_LAYER_2_NEU_57 : VOT_layer2_FCneuron_57 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(56),
		 neuron_mac_2 => layer_2_neurons_mac_2(56),
		 neuron_mac_3 => layer_2_neurons_mac_3(56),
		 neuron_mac_v => layer_2_neurons_mac(56));
LAYER_2_NEU_58_1: layer2_FCneuron_58
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(57));
LAYER_2_NEU_58_2: layer2_FCneuron_58
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(57));
LAYER_2_NEU_58_3: layer2_FCneuron_58
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(57));
VOT_LAYER_2_NEU_58 : VOT_layer2_FCneuron_58 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(57),
		 neuron_mac_2 => layer_2_neurons_mac_2(57),
		 neuron_mac_3 => layer_2_neurons_mac_3(57),
		 neuron_mac_v => layer_2_neurons_mac(57));
LAYER_2_NEU_59_1: layer2_FCneuron_59
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(58));
LAYER_2_NEU_59_2: layer2_FCneuron_59
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(58));
LAYER_2_NEU_59_3: layer2_FCneuron_59
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(58));
VOT_LAYER_2_NEU_59 : VOT_layer2_FCneuron_59 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(58),
		 neuron_mac_2 => layer_2_neurons_mac_2(58),
		 neuron_mac_3 => layer_2_neurons_mac_3(58),
		 neuron_mac_v => layer_2_neurons_mac(58));
LAYER_2_NEU_60_1: layer2_FCneuron_60
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(59));
LAYER_2_NEU_60_2: layer2_FCneuron_60
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(59));
LAYER_2_NEU_60_3: layer2_FCneuron_60
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(59));
VOT_LAYER_2_NEU_60 : VOT_layer2_FCneuron_60 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(59),
		 neuron_mac_2 => layer_2_neurons_mac_2(59),
		 neuron_mac_3 => layer_2_neurons_mac_3(59),
		 neuron_mac_v => layer_2_neurons_mac(59));
LAYER_2_NEU_61_1: layer2_FCneuron_61
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(60));
LAYER_2_NEU_61_2: layer2_FCneuron_61
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(60));
LAYER_2_NEU_61_3: layer2_FCneuron_61
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(60));
VOT_LAYER_2_NEU_61 : VOT_layer2_FCneuron_61 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(60),
		 neuron_mac_2 => layer_2_neurons_mac_2(60),
		 neuron_mac_3 => layer_2_neurons_mac_3(60),
		 neuron_mac_v => layer_2_neurons_mac(60));
LAYER_2_NEU_62_1: layer2_FCneuron_62
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(61));
LAYER_2_NEU_62_2: layer2_FCneuron_62
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(61));
LAYER_2_NEU_62_3: layer2_FCneuron_62
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(61));
VOT_LAYER_2_NEU_62 : VOT_layer2_FCneuron_62 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(61),
		 neuron_mac_2 => layer_2_neurons_mac_2(61),
		 neuron_mac_3 => layer_2_neurons_mac_3(61),
		 neuron_mac_v => layer_2_neurons_mac(61));
LAYER_2_NEU_63_1: layer2_FCneuron_63
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(62));
LAYER_2_NEU_63_2: layer2_FCneuron_63
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(62));
LAYER_2_NEU_63_3: layer2_FCneuron_63
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(62));
VOT_LAYER_2_NEU_63 : VOT_layer2_FCneuron_63 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(62),
		 neuron_mac_2 => layer_2_neurons_mac_2(62),
		 neuron_mac_3 => layer_2_neurons_mac_3(62),
		 neuron_mac_v => layer_2_neurons_mac(62));
LAYER_2_NEU_64_1: layer2_FCneuron_64
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(63));
LAYER_2_NEU_64_2: layer2_FCneuron_64
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(63));
LAYER_2_NEU_64_3: layer2_FCneuron_64
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(63));
VOT_LAYER_2_NEU_64 : VOT_layer2_FCneuron_64 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(63),
		 neuron_mac_2 => layer_2_neurons_mac_2(63),
		 neuron_mac_3 => layer_2_neurons_mac_3(63),
		 neuron_mac_v => layer_2_neurons_mac(63));
LAYER_2_NEU_65_1: layer2_FCneuron_65
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(64));
LAYER_2_NEU_65_2: layer2_FCneuron_65
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(64));
LAYER_2_NEU_65_3: layer2_FCneuron_65
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(64));
VOT_LAYER_2_NEU_65 : VOT_layer2_FCneuron_65 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(64),
		 neuron_mac_2 => layer_2_neurons_mac_2(64),
		 neuron_mac_3 => layer_2_neurons_mac_3(64),
		 neuron_mac_v => layer_2_neurons_mac(64));
LAYER_2_NEU_66_1: layer2_FCneuron_66
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(65));
LAYER_2_NEU_66_2: layer2_FCneuron_66
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(65));
LAYER_2_NEU_66_3: layer2_FCneuron_66
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(65));
VOT_LAYER_2_NEU_66 : VOT_layer2_FCneuron_66 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(65),
		 neuron_mac_2 => layer_2_neurons_mac_2(65),
		 neuron_mac_3 => layer_2_neurons_mac_3(65),
		 neuron_mac_v => layer_2_neurons_mac(65));
LAYER_2_NEU_67_1: layer2_FCneuron_67
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(66));
LAYER_2_NEU_67_2: layer2_FCneuron_67
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(66));
LAYER_2_NEU_67_3: layer2_FCneuron_67
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(66));
VOT_LAYER_2_NEU_67 : VOT_layer2_FCneuron_67 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(66),
		 neuron_mac_2 => layer_2_neurons_mac_2(66),
		 neuron_mac_3 => layer_2_neurons_mac_3(66),
		 neuron_mac_v => layer_2_neurons_mac(66));
LAYER_2_NEU_68_1: layer2_FCneuron_68
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(67));
LAYER_2_NEU_68_2: layer2_FCneuron_68
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(67));
LAYER_2_NEU_68_3: layer2_FCneuron_68
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(67));
VOT_LAYER_2_NEU_68 : VOT_layer2_FCneuron_68 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(67),
		 neuron_mac_2 => layer_2_neurons_mac_2(67),
		 neuron_mac_3 => layer_2_neurons_mac_3(67),
		 neuron_mac_v => layer_2_neurons_mac(67));
LAYER_2_NEU_69_1: layer2_FCneuron_69
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(68));
LAYER_2_NEU_69_2: layer2_FCneuron_69
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(68));
LAYER_2_NEU_69_3: layer2_FCneuron_69
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(68));
VOT_LAYER_2_NEU_69 : VOT_layer2_FCneuron_69 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(68),
		 neuron_mac_2 => layer_2_neurons_mac_2(68),
		 neuron_mac_3 => layer_2_neurons_mac_3(68),
		 neuron_mac_v => layer_2_neurons_mac(68));
LAYER_2_NEU_70_1: layer2_FCneuron_70
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(69));
LAYER_2_NEU_70_2: layer2_FCneuron_70
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(69));
LAYER_2_NEU_70_3: layer2_FCneuron_70
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(69));
VOT_LAYER_2_NEU_70 : VOT_layer2_FCneuron_70 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(69),
		 neuron_mac_2 => layer_2_neurons_mac_2(69),
		 neuron_mac_3 => layer_2_neurons_mac_3(69),
		 neuron_mac_v => layer_2_neurons_mac(69));
LAYER_2_NEU_71_1: layer2_FCneuron_71
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(70));
LAYER_2_NEU_71_2: layer2_FCneuron_71
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(70));
LAYER_2_NEU_71_3: layer2_FCneuron_71
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(70));
VOT_LAYER_2_NEU_71 : VOT_layer2_FCneuron_71 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(70),
		 neuron_mac_2 => layer_2_neurons_mac_2(70),
		 neuron_mac_3 => layer_2_neurons_mac_3(70),
		 neuron_mac_v => layer_2_neurons_mac(70));
LAYER_2_NEU_72_1: layer2_FCneuron_72
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(71));
LAYER_2_NEU_72_2: layer2_FCneuron_72
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(71));
LAYER_2_NEU_72_3: layer2_FCneuron_72
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(71));
VOT_LAYER_2_NEU_72 : VOT_layer2_FCneuron_72 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(71),
		 neuron_mac_2 => layer_2_neurons_mac_2(71),
		 neuron_mac_3 => layer_2_neurons_mac_3(71),
		 neuron_mac_v => layer_2_neurons_mac(71));
LAYER_2_NEU_73_1: layer2_FCneuron_73
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(72));
LAYER_2_NEU_73_2: layer2_FCneuron_73
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(72));
LAYER_2_NEU_73_3: layer2_FCneuron_73
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(72));
VOT_LAYER_2_NEU_73 : VOT_layer2_FCneuron_73 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(72),
		 neuron_mac_2 => layer_2_neurons_mac_2(72),
		 neuron_mac_3 => layer_2_neurons_mac_3(72),
		 neuron_mac_v => layer_2_neurons_mac(72));
LAYER_2_NEU_74_1: layer2_FCneuron_74
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(73));
LAYER_2_NEU_74_2: layer2_FCneuron_74
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(73));
LAYER_2_NEU_74_3: layer2_FCneuron_74
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(73));
VOT_LAYER_2_NEU_74 : VOT_layer2_FCneuron_74 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(73),
		 neuron_mac_2 => layer_2_neurons_mac_2(73),
		 neuron_mac_3 => layer_2_neurons_mac_3(73),
		 neuron_mac_v => layer_2_neurons_mac(73));
LAYER_2_NEU_75_1: layer2_FCneuron_75
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(74));
LAYER_2_NEU_75_2: layer2_FCneuron_75
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(74));
LAYER_2_NEU_75_3: layer2_FCneuron_75
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(74));
VOT_LAYER_2_NEU_75 : VOT_layer2_FCneuron_75 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(74),
		 neuron_mac_2 => layer_2_neurons_mac_2(74),
		 neuron_mac_3 => layer_2_neurons_mac_3(74),
		 neuron_mac_v => layer_2_neurons_mac(74));
LAYER_2_NEU_76_1: layer2_FCneuron_76
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(75));
LAYER_2_NEU_76_2: layer2_FCneuron_76
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(75));
LAYER_2_NEU_76_3: layer2_FCneuron_76
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(75));
VOT_LAYER_2_NEU_76 : VOT_layer2_FCneuron_76 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(75),
		 neuron_mac_2 => layer_2_neurons_mac_2(75),
		 neuron_mac_3 => layer_2_neurons_mac_3(75),
		 neuron_mac_v => layer_2_neurons_mac(75));
LAYER_2_NEU_77_1: layer2_FCneuron_77
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(76));
LAYER_2_NEU_77_2: layer2_FCneuron_77
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(76));
LAYER_2_NEU_77_3: layer2_FCneuron_77
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(76));
VOT_LAYER_2_NEU_77 : VOT_layer2_FCneuron_77 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(76),
		 neuron_mac_2 => layer_2_neurons_mac_2(76),
		 neuron_mac_3 => layer_2_neurons_mac_3(76),
		 neuron_mac_v => layer_2_neurons_mac(76));
LAYER_2_NEU_78_1: layer2_FCneuron_78
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(77));
LAYER_2_NEU_78_2: layer2_FCneuron_78
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(77));
LAYER_2_NEU_78_3: layer2_FCneuron_78
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(77));
VOT_LAYER_2_NEU_78 : VOT_layer2_FCneuron_78 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(77),
		 neuron_mac_2 => layer_2_neurons_mac_2(77),
		 neuron_mac_3 => layer_2_neurons_mac_3(77),
		 neuron_mac_v => layer_2_neurons_mac(77));
LAYER_2_NEU_79_1: layer2_FCneuron_79
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(78));
LAYER_2_NEU_79_2: layer2_FCneuron_79
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(78));
LAYER_2_NEU_79_3: layer2_FCneuron_79
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(78));
VOT_LAYER_2_NEU_79 : VOT_layer2_FCneuron_79 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(78),
		 neuron_mac_2 => layer_2_neurons_mac_2(78),
		 neuron_mac_3 => layer_2_neurons_mac_3(78),
		 neuron_mac_v => layer_2_neurons_mac(78));
LAYER_2_NEU_80_1: layer2_FCneuron_80
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(79));
LAYER_2_NEU_80_2: layer2_FCneuron_80
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(79));
LAYER_2_NEU_80_3: layer2_FCneuron_80
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(79));
VOT_LAYER_2_NEU_80 : VOT_layer2_FCneuron_80 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(79),
		 neuron_mac_2 => layer_2_neurons_mac_2(79),
		 neuron_mac_3 => layer_2_neurons_mac_3(79),
		 neuron_mac_v => layer_2_neurons_mac(79));
LAYER_2_NEU_81_1: layer2_FCneuron_81
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(80));
LAYER_2_NEU_81_2: layer2_FCneuron_81
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(80));
LAYER_2_NEU_81_3: layer2_FCneuron_81
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(80));
VOT_LAYER_2_NEU_81 : VOT_layer2_FCneuron_81 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(80),
		 neuron_mac_2 => layer_2_neurons_mac_2(80),
		 neuron_mac_3 => layer_2_neurons_mac_3(80),
		 neuron_mac_v => layer_2_neurons_mac(80));
LAYER_2_NEU_82_1: layer2_FCneuron_82
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(81));
LAYER_2_NEU_82_2: layer2_FCneuron_82
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(81));
LAYER_2_NEU_82_3: layer2_FCneuron_82
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(81));
VOT_LAYER_2_NEU_82 : VOT_layer2_FCneuron_82 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(81),
		 neuron_mac_2 => layer_2_neurons_mac_2(81),
		 neuron_mac_3 => layer_2_neurons_mac_3(81),
		 neuron_mac_v => layer_2_neurons_mac(81));
LAYER_2_NEU_83_1: layer2_FCneuron_83
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(82));
LAYER_2_NEU_83_2: layer2_FCneuron_83
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(82));
LAYER_2_NEU_83_3: layer2_FCneuron_83
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(82));
VOT_LAYER_2_NEU_83 : VOT_layer2_FCneuron_83 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(82),
		 neuron_mac_2 => layer_2_neurons_mac_2(82),
		 neuron_mac_3 => layer_2_neurons_mac_3(82),
		 neuron_mac_v => layer_2_neurons_mac(82));
LAYER_2_NEU_84_1: layer2_FCneuron_84
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_1(83));
LAYER_2_NEU_84_2: layer2_FCneuron_84
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_2(83));
LAYER_2_NEU_84_3: layer2_FCneuron_84
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L2,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_2_neurons_mac_3(83));
VOT_LAYER_2_NEU_84 : VOT_layer2_FCneuron_84 
port map ( 
		 neuron_mac_1 => layer_2_neurons_mac_1(83),
		 neuron_mac_2 => layer_2_neurons_mac_2(83),
		 neuron_mac_3 => layer_2_neurons_mac_3(83),
		 neuron_mac_v => layer_2_neurons_mac(83));
-- Register of the output data from the neurons
--LAYER_2_REG: Register_FCL2 
--port map ( clk => clk, 
--           rst => rst,
--           data_in => layer_2_neurons_mac, 
--           next_pipeline_step => next_pipeline_step,
--           data_out => data_out_register_L2);  
        LAYER_2_REG_1: Register_FCL2 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_2_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L2_1);  
LAYER_2_REG_2: Register_FCL2 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_2_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L2_2);  
LAYER_2_REG_3: Register_FCL2 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_2_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L2_3);  
VOT_LAYER_2_REG: VOT_Register_FCL2 
port map (  
       data_out_1 => data_out_register_L2_1,
       data_out_2 => data_out_register_L2_2,
       data_out_3 => data_out_register_L2_3,
       data_out_v => data_out_register_L2);
                                     
 -- Assignment of value to the max and min signals for layer 1--
mac_max_L2(weight_size_L3fc + fractional_size_L2fc + n_extra_bits + 1 downto w_fractional_size_L3fc + fractional_size_L3fc + 1) <= (others => '0');
mac_max_L2(w_fractional_size_L3fc + fractional_size_L3fc downto w_fractional_size_L3fc ) <= (others => '1');
mac_max_L2(w_fractional_size_L3fc - 1 downto 0) <= (others => '0');

mac_min_L2(weight_size_L3fc + fractional_size_L3fc + n_extra_bits + 1 downto w_fractional_size_L3fc + fractional_size_L3fc + 1) <= (others => '1');
mac_min_L2( w_fractional_size_L3fc + fractional_size_L3fc downto 0 ) <= (others => '0');

 ctrl_muxL2  <= rom_addr_Fc(log2c(number_of_outputs_L2fc) - 1 downto 0 );
LAYER_2_MUX: Mux_FCL2 
port map ( data_in => data_out_register_L2, 
           ctrl => ctrl_muxL2, 
           mac_max => mac_max_L2,
           mac_min => mac_min_L2,
           data_out => data_out_multiplexer_L2); 
--Sigmoid_functionFCL2 : sigmoidFCL2
--   port map(
--   data_in => data_out_multiplexer_L2,
--   data_out => data_in_L3); 
Sigmoid_functionFCL2_1 : sigmoidFCL2
   port map(
   data_in => data_out_multiplexer_L2,
   data_out => data_in_L3_1);
Sigmoid_functionFCL2_2 : sigmoidFCL2
   port map(
   data_in => data_out_multiplexer_L2,
   data_out => data_in_L3_2);
Sigmoid_functionFCL2_3 : sigmoidFCL2
   port map(
   data_in => data_out_multiplexer_L2,
   data_out => data_in_L3_3);
VOT_Sigmoid_functionFCL2 : VOT_sigmoidFCL2 
   port map(
		data_out_1 => data_in_L3_1,
		data_out_2 => data_in_L3_2,
		data_out_3 => data_in_L3_3,
		data_out_v => data_in_L3);
--PAR2SER_L3: PAR2SER
--generic map (input_size => input_size_L3fc)
--port map ( clk => clk,
--           rst => rst,
--           data_in => data_in_L3,
--           en_neuron => en_neuron,
--           bit_select => bit_select,
--           bit_out => bit_selected_L3);
    PAR2SER_L3_1: PAR2SER
generic map (input_size => input_size_L3fc)
port map ( clk => clk,
           rst => rst,
           data_in => data_in_L3,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L3_1);

PAR2SER_L3_2: PAR2SER
generic map (input_size => input_size_L3fc)
port map ( clk => clk,
           rst => rst,
           data_in => data_in_L3,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L3_2);

PAR2SER_L3_3: PAR2SER
generic map (input_size => input_size_L3fc)
port map ( clk => clk,
           rst => rst,
           data_in => data_in_L3,
           en_neuron => en_neuron,
           bit_select => bit_select,
           bit_out => bit_selected_L3_3);

VOT_PAR2SER_L3: VOT_PAR2SER 
port map ( 
		 serial_out_1 => bit_selected_L3_1,
		 serial_out_2 => bit_selected_L3_2,
		 serial_out_3 => bit_selected_L3_3,
		 serial_out_v => bit_selected_L3);
		 
-- Layer 1 Neurons instantiation
--LAYER_3_NEU_1: layer3_FCneuron_1
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(0));
--LAYER_3_NEU_2: layer3_FCneuron_2
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(1));
--LAYER_3_NEU_3: layer3_FCneuron_3
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(2));
--LAYER_3_NEU_4: layer3_FCneuron_4
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(3));
--LAYER_3_NEU_5: layer3_FCneuron_5
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(4));
--LAYER_3_NEU_6: layer3_FCneuron_6
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(5));
--LAYER_3_NEU_7: layer3_FCneuron_7
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(6));
--LAYER_3_NEU_8: layer3_FCneuron_8
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(7));
--LAYER_3_NEU_9: layer3_FCneuron_9
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(8));
--LAYER_3_NEU_10: layer3_FCneuron_10
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_L3,
--           bit_select => bit_select,
--           rom_addr => rom_addr_FC,
--           neuron_mac => layer_3_neurons_mac(9));
---- Register of the output data from the neurons
----LAYER_3_REG: Register_FCL3 
----port map ( clk => clk, 
----           rst => rst,
----           data_in => layer_3_neurons_mac, 
----           next_pipeline_step => next_pipeline_step,
----           data_out => data_out_register_L3);  
--LAYER_3_REG_1: Register_FCL3 
--port map ( clk => clk, 
--           rst => rst,
--           data_in => layer_3_neurons_mac, 
--           next_pipeline_step => next_pipeline_step,
--           data_out => data_out_register_L3_1);  
--LAYER_3_REG_2: Register_FCL3 
--port map ( clk => clk, 
--           rst => rst,
--           data_in => layer_3_neurons_mac, 
--           next_pipeline_step => next_pipeline_step,
--           data_out => data_out_register_L3_2);  
--LAYER_3_REG_3: Register_FCL3 
--port map ( clk => clk, 
--           rst => rst,
--           data_in => layer_3_neurons_mac, 
--           next_pipeline_step => next_pipeline_step,
--           data_out => data_out_register_L3_3);  
--VOT_LAYER_3_REG: VOT_Register_FCL3 
--port map (  
--       data_out_1 => data_out_register_L3_1,
--       data_out_2 => data_out_register_L3_2,
--       data_out_3 => data_out_register_L3_3,
--       data_out_v => data_out_register_L3);    
LAYER_3_NEU_1_1: layer3_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(0));
LAYER_3_NEU_1_2: layer3_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(0));
LAYER_3_NEU_1_3: layer3_FCneuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(0));
VOT_LAYER_3_NEU_1 : VOT_layer3_FCneuron_1 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(0),
		 neuron_mac_2 => layer_3_neurons_mac_2(0),
		 neuron_mac_3 => layer_3_neurons_mac_3(0),
		 neuron_mac_v => layer_3_neurons_mac(0));
LAYER_3_NEU_2_1: layer3_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(1));
LAYER_3_NEU_2_2: layer3_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(1));
LAYER_3_NEU_2_3: layer3_FCneuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(1));
VOT_LAYER_3_NEU_2 : VOT_layer3_FCneuron_2 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(1),
		 neuron_mac_2 => layer_3_neurons_mac_2(1),
		 neuron_mac_3 => layer_3_neurons_mac_3(1),
		 neuron_mac_v => layer_3_neurons_mac(1));
LAYER_3_NEU_3_1: layer3_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(2));
LAYER_3_NEU_3_2: layer3_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(2));
LAYER_3_NEU_3_3: layer3_FCneuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(2));
VOT_LAYER_3_NEU_3 : VOT_layer3_FCneuron_3 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(2),
		 neuron_mac_2 => layer_3_neurons_mac_2(2),
		 neuron_mac_3 => layer_3_neurons_mac_3(2),
		 neuron_mac_v => layer_3_neurons_mac(2));
LAYER_3_NEU_4_1: layer3_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(3));
LAYER_3_NEU_4_2: layer3_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(3));
LAYER_3_NEU_4_3: layer3_FCneuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(3));
VOT_LAYER_3_NEU_4 : VOT_layer3_FCneuron_4 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(3),
		 neuron_mac_2 => layer_3_neurons_mac_2(3),
		 neuron_mac_3 => layer_3_neurons_mac_3(3),
		 neuron_mac_v => layer_3_neurons_mac(3));
LAYER_3_NEU_5_1: layer3_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(4));
LAYER_3_NEU_5_2: layer3_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(4));
LAYER_3_NEU_5_3: layer3_FCneuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(4));
VOT_LAYER_3_NEU_5 : VOT_layer3_FCneuron_5 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(4),
		 neuron_mac_2 => layer_3_neurons_mac_2(4),
		 neuron_mac_3 => layer_3_neurons_mac_3(4),
		 neuron_mac_v => layer_3_neurons_mac(4));
LAYER_3_NEU_6_1: layer3_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(5));
LAYER_3_NEU_6_2: layer3_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(5));
LAYER_3_NEU_6_3: layer3_FCneuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(5));
VOT_LAYER_3_NEU_6 : VOT_layer3_FCneuron_6 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(5),
		 neuron_mac_2 => layer_3_neurons_mac_2(5),
		 neuron_mac_3 => layer_3_neurons_mac_3(5),
		 neuron_mac_v => layer_3_neurons_mac(5));
LAYER_3_NEU_7_1: layer3_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(6));
LAYER_3_NEU_7_2: layer3_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(6));
LAYER_3_NEU_7_3: layer3_FCneuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(6));
VOT_LAYER_3_NEU_7 : VOT_layer3_FCneuron_7 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(6),
		 neuron_mac_2 => layer_3_neurons_mac_2(6),
		 neuron_mac_3 => layer_3_neurons_mac_3(6),
		 neuron_mac_v => layer_3_neurons_mac(6));
LAYER_3_NEU_8_1: layer3_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(7));
LAYER_3_NEU_8_2: layer3_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(7));
LAYER_3_NEU_8_3: layer3_FCneuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(7));
VOT_LAYER_3_NEU_8 : VOT_layer3_FCneuron_8 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(7),
		 neuron_mac_2 => layer_3_neurons_mac_2(7),
		 neuron_mac_3 => layer_3_neurons_mac_3(7),
		 neuron_mac_v => layer_3_neurons_mac(7));
LAYER_3_NEU_9_1: layer3_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(8));
LAYER_3_NEU_9_2: layer3_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(8));
LAYER_3_NEU_9_3: layer3_FCneuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(8));
VOT_LAYER_3_NEU_9 : VOT_layer3_FCneuron_9 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(8),
		 neuron_mac_2 => layer_3_neurons_mac_2(8),
		 neuron_mac_3 => layer_3_neurons_mac_3(8),
		 neuron_mac_v => layer_3_neurons_mac(8));
LAYER_3_NEU_10_1: layer3_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_1(9));
LAYER_3_NEU_10_2: layer3_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_2(9));
LAYER_3_NEU_10_3: layer3_FCneuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_L3,
           bit_select => bit_select,
           rom_addr => rom_addr_FC,
           neuron_mac => layer_3_neurons_mac_3(9));
VOT_LAYER_3_NEU_10 : VOT_layer3_FCneuron_10 
port map ( 
		 neuron_mac_1 => layer_3_neurons_mac_1(9),
		 neuron_mac_2 => layer_3_neurons_mac_2(9),
		 neuron_mac_3 => layer_3_neurons_mac_3(9),
		 neuron_mac_v => layer_3_neurons_mac(9));
		 
		 LAYER_3_REG_1: Register_FCL3 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_3_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L3_1);  
LAYER_3_REG_2: Register_FCL3 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_3_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L3_2);  
LAYER_3_REG_3: Register_FCL3 
port map ( clk => clk, 
           rst => rst,
           data_in => layer_3_neurons_mac, 
           next_pipeline_step => next_pipeline_step,
           data_out => data_out_register_L3_3);  
VOT_LAYER_3_REG: VOT_Register_FCL3 
port map (  
       data_out_1 => data_out_register_L3_1,
       data_out_2 => data_out_register_L3_2,
       data_out_3 => data_out_register_L3_3,
       data_out_v => data_out_register_L3);
                                         
 -- Assignment of value to the max and min signals for layer 1--
--mac_max_L3(weight_size_L3fc + fractional_size_L3fc + n_extra_bits + 1 downto w_fractional_size_L3fc + fractional_size_L3fc + 1) <= (others => '0');
--mac_max_L3(w_fractional_size_L3fc + fractional_size_L3fc downto w_fractional_size_L3fc ) <= (others => '1');
--mac_max_L3(w_fractional_size_L3fc - 1 downto 0) <= (others => '0');
mac_max_L3 <= "0000111111000000000";
mac_min_L3(weight_size_L3fc + fractional_size_L3fc + n_extra_bits + 1 downto w_fractional_size_L3fc + fractional_size_L3fc + 1) <= (others => '0');
mac_min_L3( w_fractional_size_L3fc + fractional_size_L3fc downto 0 ) <= (others => '0');

 ctrl_muxL3  <= rom_addr_Fc(log2c(number_of_outputs_L3fc) - 1 downto 0 );
LAYER_3_MUX: Mux_FCL3 
port map ( data_in => data_out_register_L3, 
           ctrl => rom_addr_Sm, 
           mac_max => mac_max_L3,
           mac_min => mac_min_L3,
           data_out => data_out_multiplexer_L3); 
data_in_L4 <= data_out_multiplexer_L3;

------------SOFTMAX IMPLEMENTATION--------------------
--First step is to perform the exponential of each input
--EXP : exponential
--port map ( data_in => data_in_L4,
--           data_out => data_out_exponential);
EXP_1 : exponential
port map ( data_in => data_in_L4,
           data_out => data_out_exponential_1);
EXP_2 : exponential
port map ( data_in => data_in_L4,
           data_out => data_out_exponential_2);
EXP_3 : exponential
port map ( data_in => data_in_L4,
           data_out => data_out_exponential_3);
VOT_EXP : VOT_exponential 
   port map(
        data_out_1 => data_out_exponential_1,
        data_out_2 => data_out_exponential_2,
        data_out_3 => data_out_exponential_3,
        data_out_v => data_out_exponential);
--Register_softmax_exp : Reg_softmax_2
--    port map (
--        clk => clk,
--        rst => rst,
--        data_in => data_out_exponential,
--        reg_Sm => exp_Sm,
--        data_out => data_in_sum
--    );
Register_softmax_exp_1 : Reg_softmax_2
    port map (
        clk => clk,
        rst => rst,
        data_in => data_out_exponential,
        reg_Sm => exp_Sm,
        data_out => data_in_sum_1
    );
Register_softmax_exp_2 : Reg_softmax_2
    port map (
        clk => clk,
        rst => rst,
        data_in => data_out_exponential,
        reg_Sm => exp_Sm,
        data_out => data_in_sum_2
    );
Register_softmax_exp_3 : Reg_softmax_2
    port map (
        clk => clk,
        rst => rst,
        data_in => data_out_exponential,
        reg_Sm => exp_Sm,
        data_out => data_in_sum_3
    );
VOT_Register_softmax_exp : VOT_Reg_softmax_2 
    port map (
       data_out_1 => data_in_sum_1,
       data_out_2 => data_in_sum_2,
       data_out_3 => data_in_sum_3,
       data_out_v => data_in_sum); 
--Then we sum each of the results and inverse the result
--BIT_MUX_SUM_SM: PAR2SER
--    port map (
--        clk => clk,
--        rst => rst,
--        data_in => data_in_sum,
--        bit_select => bit_select,
--        en_neuron => en_neuron,
--        bit_out => bit_selected_sum
--    );
BIT_MUX_SUM_SM_1: PAR2SER
    port map (
        clk => clk,
        rst => rst,
        data_in => data_in_sum,
        bit_select => bit_select,
        en_neuron => en_neuron,
        bit_out => bit_selected_sum_1
    );
BIT_MUX_SUM_SM_2: PAR2SER
    port map (
        clk => clk,
        rst => rst,
        data_in => data_in_sum,
        bit_select => bit_select,
        en_neuron => en_neuron,
        bit_out => bit_selected_sum_2
    );
BIT_MUX_SUM_SM_3: PAR2SER
    port map (
        clk => clk,
        rst => rst,
        data_in => data_in_sum,
        bit_select => bit_select,
        en_neuron => en_neuron,
        bit_out => bit_selected_sum_3
    );
VOT_BIT_MUX_SUM_SM: VOT_PAR2SER 
port map ( 
		 serial_out_1 => bit_selected_sum_1,
		 serial_out_2 => bit_selected_sum_2,
		 serial_out_3 => bit_selected_sum_3,
		 serial_out_v => bit_selected_sum);
--SUM_EXP: sum
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => next_pipeline_step,
--           data_in_bit => bit_selected_sum,
--           bit_select => bit_select,
--           neuron_mac => sum_expo); 
SUM_EXP_1: sum
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_sum,
           bit_select => bit_select,
           neuron_mac => sum_expo_1);
SUM_EXP_2: sum
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_sum,
           bit_select => bit_select,
           neuron_mac => sum_expo_2);
SUM_EXP_3: sum
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => next_pipeline_step,
           data_in_bit => bit_selected_sum,
           bit_select => bit_select,
           neuron_mac => sum_expo_3);
VOT_SUM_EXP : VOT_sum 
port map (  
        neuron_mac_1 => sum_expo_1,
        neuron_mac_2 => sum_expo_2,
        neuron_mac_3 => sum_expo_3,
        neuron_mac_v => sum_expo);
--INV : inverse
--port map ( data_in => sum_expo,
--           data_out => inverse_result); 
INV_1 : inverse
port map ( data_in => sum_expo,
           data_out => inverse_result_1);
INV_2 : inverse
port map ( data_in => sum_expo,
           data_out => inverse_result_2);
INV_3 : inverse
port map ( data_in => sum_expo,
           data_out => inverse_result_3);
VOT_INV : VOT_inverse
    port map (
       data_out_1 => inverse_result_1,
       data_out_2 => inverse_result_2,
       data_out_3 => inverse_result_3,
       data_out_v => inverse_result);
       
--Finally, we multiply the inverse by each of the exponentials
--Register_softmax2 : Reg_softmax_2
--port map(
--    clk => clk,
--    rst => rst,
--    data_in => inverse_result,
--    reg_Sm => inv_Sm,
--    data_out => data_inverse_reg
--);
Register_softmax2_1 : Reg_softmax_2
port map(
    clk => clk,
    rst => rst,
    data_in => inverse_result,
    reg_Sm => inv_Sm,
    data_out => data_inverse_reg_1);
Register_softmax2_2 : Reg_softmax_2
port map(
    clk => clk,
    rst => rst,
    data_in => inverse_result,
    reg_Sm => inv_Sm,
    data_out => data_inverse_reg_2);
Register_softmax2_3 : Reg_softmax_2
port map(
    clk => clk,
    rst => rst,
    data_in => inverse_result,
    reg_Sm => inv_Sm,
    data_out => data_inverse_reg_3);
VOT_Register_softmax2 : VOT_Reg_softmax_2 
    port map (
       data_out_1 => data_inverse_reg_1,
       data_out_2 => data_inverse_reg_2,
       data_out_3 => data_inverse_reg_3,
       data_out_v => data_inverse_reg);
--Register_softmax1 : Reg_softmax_1
--port map(
--    clk => clk,
--    rst => rst,
--    data_in => data_out_exponential,
--    index => unsigned(rom_addr_Sm),
--    data_out => data_in_softmax
--); 
Register_softmax1_1 : Reg_softmax_1
port map(
    clk => clk,
    rst => rst,
    data_in => data_out_exponential,
    index => unsigned(rom_addr_Sm),
    data_out => data_in_softmax_1);
Register_softmax1_2 : Reg_softmax_1
port map(
    clk => clk,
    rst => rst,
    data_in => data_out_exponential,
    index => unsigned(rom_addr_Sm),
    data_out => data_in_softmax_2);
Register_softmax1_3 : Reg_softmax_1
port map(
    clk => clk,
    rst => rst,
    data_in => data_out_exponential,
    index => unsigned(rom_addr_Sm),
    data_out => data_in_softmax_3);
VOT_Register_softmax1 : VOT_Reg_softmax_1 
port map(
       data_out_1 => data_in_softmax_1,
       data_out_2 => data_in_softmax_2,
       data_out_3 => data_in_softmax_3,
       data_out_v => data_in_softmax);
--BIT_MUX_SM: PAR2SER
--port map ( clk => clk,
--           rst => rst,
--           data_in => data_inverse_reg,
--           bit_select => bit_select,
--           en_neuron => en_neuron,
--           bit_out => bit_selected_softmax);
BIT_MUX_SM_1: PAR2SER
port map ( clk => clk,
           rst => rst,
           data_in => data_inverse_reg,
           bit_select => bit_select,
           en_neuron => en_neuron,
           bit_out => bit_selected_softmax_1);
BIT_MUX_SM_2: PAR2SER
port map ( clk => clk,
           rst => rst,
           data_in => data_inverse_reg,
           bit_select => bit_select,
           en_neuron => en_neuron,
           bit_out => bit_selected_softmax_2);
BIT_MUX_SM_3: PAR2SER
port map ( clk => clk,
           rst => rst,
           data_in => data_inverse_reg,
           bit_select => bit_select,
           en_neuron => en_neuron,
           bit_out => bit_selected_softmax_3);
VOT_BIT_MUX_SM : VOT_PAR2SER 
port map ( 
		 serial_out_1 => bit_selected_softmax_1,
		 serial_out_2 => bit_selected_softmax_2,
		 serial_out_3 => bit_selected_softmax_3,
		 serial_out_v => bit_selected_softmax);
		 
--LAYER_OUT_NEU_1: layer_out_neuron_1
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(0)),
--           neuron_mac => layer_out_neurons_mac(0));
--LAYER_OUT_NEU_2: layer_out_neuron_2
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(1)),
--           neuron_mac => layer_out_neurons_mac(1));
--LAYER_OUT_NEU_3: layer_out_neuron_3
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(2)),
--           neuron_mac => layer_out_neurons_mac(2));
--LAYER_OUT_NEU_4: layer_out_neuron_4
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(3)),
--           neuron_mac => layer_out_neurons_mac(3));
--LAYER_OUT_NEU_5: layer_out_neuron_5
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(4)),
--           neuron_mac => layer_out_neurons_mac(4));
--LAYER_OUT_NEU_6: layer_out_neuron_6
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(5)),
--           neuron_mac => layer_out_neurons_mac(5));
--LAYER_OUT_NEU_7: layer_out_neuron_7
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(6)),
--           neuron_mac => layer_out_neurons_mac(6));
--LAYER_OUT_NEU_8: layer_out_neuron_8
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(7)),
--           neuron_mac => layer_out_neurons_mac(7));
--LAYER_OUT_NEU_9: layer_out_neuron_9
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(8)),
--           neuron_mac => layer_out_neurons_mac(8));
--LAYER_OUT_NEU_10: layer_out_neuron_10
--port map ( clk => clk,
--           rst => rst,
--           next_pipeline_step => sum_finish,
--           data_in_bit => bit_selected_softmax,
--           bit_select => bit_select,
--           weight => signed(data_in_softmax(9)),
--           neuron_mac => layer_out_neurons_mac(9));
LAYER_OUT_NEU_1_1: layer_out_neuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(0)),
           neuron_mac => layer_out_neurons_mac_1(0));
LAYER_OUT_NEU_1_2: layer_out_neuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(0)),
           neuron_mac => layer_out_neurons_mac_2(0));
LAYER_OUT_NEU_1_3: layer_out_neuron_1
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(0)),
           neuron_mac => layer_out_neurons_mac_3(0));
VOT_LAYER_OUT_NEU_1 : VOT_layer_out_neuron_1 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(0), 
		 neuron_mac_2 => layer_out_neurons_mac_2(0), 
		 neuron_mac_3 => layer_out_neurons_mac_3(0), 
		 neuron_mac_v => layer_out_neurons_mac(0));
LAYER_OUT_NEU_2_1: layer_out_neuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(1)),
           neuron_mac => layer_out_neurons_mac_1(1));
LAYER_OUT_NEU_2_2: layer_out_neuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(1)),
           neuron_mac => layer_out_neurons_mac_2(1));
LAYER_OUT_NEU_2_3: layer_out_neuron_2
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(1)),
           neuron_mac => layer_out_neurons_mac_3(1));
VOT_LAYER_OUT_NEU_2 : VOT_layer_out_neuron_2 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(1), 
		 neuron_mac_2 => layer_out_neurons_mac_2(1), 
		 neuron_mac_3 => layer_out_neurons_mac_3(1), 
		 neuron_mac_v => layer_out_neurons_mac(1));
LAYER_OUT_NEU_3_1: layer_out_neuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(2)),
           neuron_mac => layer_out_neurons_mac_1(2));
LAYER_OUT_NEU_3_2: layer_out_neuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(2)),
           neuron_mac => layer_out_neurons_mac_2(2));
LAYER_OUT_NEU_3_3: layer_out_neuron_3
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(2)),
           neuron_mac => layer_out_neurons_mac_3(2));
VOT_LAYER_OUT_NEU_3 : VOT_layer_out_neuron_3 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(2), 
		 neuron_mac_2 => layer_out_neurons_mac_2(2), 
		 neuron_mac_3 => layer_out_neurons_mac_3(2), 
		 neuron_mac_v => layer_out_neurons_mac(2));
LAYER_OUT_NEU_4_1: layer_out_neuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(3)),
           neuron_mac => layer_out_neurons_mac_1(3));
LAYER_OUT_NEU_4_2: layer_out_neuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(3)),
           neuron_mac => layer_out_neurons_mac_2(3));
LAYER_OUT_NEU_4_3: layer_out_neuron_4
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(3)),
           neuron_mac => layer_out_neurons_mac_3(3));
VOT_LAYER_OUT_NEU_4 : VOT_layer_out_neuron_4 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(3), 
		 neuron_mac_2 => layer_out_neurons_mac_2(3), 
		 neuron_mac_3 => layer_out_neurons_mac_3(3), 
		 neuron_mac_v => layer_out_neurons_mac(3));
LAYER_OUT_NEU_5_1: layer_out_neuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(4)),
           neuron_mac => layer_out_neurons_mac_1(4));
LAYER_OUT_NEU_5_2: layer_out_neuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(4)),
           neuron_mac => layer_out_neurons_mac_2(4));
LAYER_OUT_NEU_5_3: layer_out_neuron_5
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(4)),
           neuron_mac => layer_out_neurons_mac_3(4));
VOT_LAYER_OUT_NEU_5 : VOT_layer_out_neuron_5 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(4), 
		 neuron_mac_2 => layer_out_neurons_mac_2(4), 
		 neuron_mac_3 => layer_out_neurons_mac_3(4), 
		 neuron_mac_v => layer_out_neurons_mac(4));
LAYER_OUT_NEU_6_1: layer_out_neuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(5)),
           neuron_mac => layer_out_neurons_mac_1(5));
LAYER_OUT_NEU_6_2: layer_out_neuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(5)),
           neuron_mac => layer_out_neurons_mac_2(5));
LAYER_OUT_NEU_6_3: layer_out_neuron_6
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(5)),
           neuron_mac => layer_out_neurons_mac_3(5));
VOT_LAYER_OUT_NEU_6 : VOT_layer_out_neuron_6 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(5), 
		 neuron_mac_2 => layer_out_neurons_mac_2(5), 
		 neuron_mac_3 => layer_out_neurons_mac_3(5), 
		 neuron_mac_v => layer_out_neurons_mac(5));
LAYER_OUT_NEU_7_1: layer_out_neuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(6)),
           neuron_mac => layer_out_neurons_mac_1(6));
LAYER_OUT_NEU_7_2: layer_out_neuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(6)),
           neuron_mac => layer_out_neurons_mac_2(6));
LAYER_OUT_NEU_7_3: layer_out_neuron_7
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(6)),
           neuron_mac => layer_out_neurons_mac_3(6));
VOT_LAYER_OUT_NEU_7 : VOT_layer_out_neuron_7 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(6), 
		 neuron_mac_2 => layer_out_neurons_mac_2(6), 
		 neuron_mac_3 => layer_out_neurons_mac_3(6), 
		 neuron_mac_v => layer_out_neurons_mac(6));
LAYER_OUT_NEU_8_1: layer_out_neuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(7)),
           neuron_mac => layer_out_neurons_mac_1(7));
LAYER_OUT_NEU_8_2: layer_out_neuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(7)),
           neuron_mac => layer_out_neurons_mac_2(7));
LAYER_OUT_NEU_8_3: layer_out_neuron_8
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(7)),
           neuron_mac => layer_out_neurons_mac_3(7));
VOT_LAYER_OUT_NEU_8 : VOT_layer_out_neuron_8 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(7), 
		 neuron_mac_2 => layer_out_neurons_mac_2(7), 
		 neuron_mac_3 => layer_out_neurons_mac_3(7), 
		 neuron_mac_v => layer_out_neurons_mac(7));
LAYER_OUT_NEU_9_1: layer_out_neuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(8)),
           neuron_mac => layer_out_neurons_mac_1(8));
LAYER_OUT_NEU_9_2: layer_out_neuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(8)),
           neuron_mac => layer_out_neurons_mac_2(8));
LAYER_OUT_NEU_9_3: layer_out_neuron_9
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(8)),
           neuron_mac => layer_out_neurons_mac_3(8));
VOT_LAYER_OUT_NEU_9 : VOT_layer_out_neuron_9 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(8), 
		 neuron_mac_2 => layer_out_neurons_mac_2(8), 
		 neuron_mac_3 => layer_out_neurons_mac_3(8), 
		 neuron_mac_v => layer_out_neurons_mac(8));
LAYER_OUT_NEU_10_1: layer_out_neuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(9)),
           neuron_mac => layer_out_neurons_mac_1(9));
LAYER_OUT_NEU_10_2: layer_out_neuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(9)),
           neuron_mac => layer_out_neurons_mac_2(9));
LAYER_OUT_NEU_10_3: layer_out_neuron_10
port map ( clk => clk,
           rst => rst,
           next_pipeline_step => sum_finish,
           data_in_bit => bit_selected_softmax,
           bit_select => bit_select,
           weight => signed(data_in_softmax(9)),
           neuron_mac => layer_out_neurons_mac_3(9));
VOT_LAYER_OUT_NEU_10 : VOT_layer_out_neuron_10 
port map ( 
		 neuron_mac_1 => layer_out_neurons_mac_1(9), 
		 neuron_mac_2 => layer_out_neurons_mac_2(9), 
		 neuron_mac_3 => layer_out_neurons_mac_3(9), 
		 neuron_mac_v => layer_out_neurons_mac(9));
--We compute the maximum value of the outputs of the softmax as the result of the entire network
--LAST_LAYER_REG: Register_FCLast
--port map ( data_in => layer_out_neurons_mac,
--           clk => clk,
--           rst => rst,
--           next_pipeline_step => enable_lastlayer,
--           start_threshold => start_th,
--           data_out => data_out_register_L_out); 
LAST_LAYER_REG_1: Register_FCLast
port map ( data_in => layer_out_neurons_mac,
           clk => clk,
           rst => rst,
           next_pipeline_step => enable_lastlayer,
           start_threshold => start_th_1,
           data_out => data_out_register_L_out_1);
LAST_LAYER_REG_2: Register_FCLast
port map ( data_in => layer_out_neurons_mac,
           clk => clk,
           rst => rst,
           next_pipeline_step => enable_lastlayer,
           start_threshold => start_th_2,
           data_out => data_out_register_L_out_2);
LAST_LAYER_REG_3: Register_FCLast
port map ( data_in => layer_out_neurons_mac,
           clk => clk,
           rst => rst,
           next_pipeline_step => enable_lastlayer,
           start_threshold => start_th_3,
           data_out => data_out_register_L_out_3);
VOT_LAST_LAYER_REG: VOT_Register_FCLast 
port map(
		 start_threshold_1 => start_th_1,
		 data_out_1 => data_out_register_L_out_1,
		 start_threshold_2 => start_th_2,
		 data_out_2 => data_out_register_L_out_2,
		 start_threshold_3 => start_th_3,
		 data_out_3 => data_out_register_L_out_3,
		 start_threshold => start_th,
		 data_out => data_out_register_L_out);
--THRSHLD: entity work.threshold(Behavioral)
--    port map (
--        clk => clk,
--        rst => rst,
--        start => start_th,
--        finish => finish,
--        y_in => data_out_register_L_out,
--        y_out => y);
--output_sm <= data_out_register_L_out;
THRSHLD_1: entity work.threshold(Behavioral)
    port map (
        clk => clk,
        rst => rst,
        start => start_th,
        finish => finish_1,
        y_in => data_out_register_L_out,
        y_out => y_1);
THRSHLD_2: entity work.threshold(Behavioral)
    port map (
        clk => clk,
        rst => rst,
        start => start_th,
        finish => finish_2,
        y_in => data_out_register_L_out,
        y_out => y_2);
THRSHLD_3: entity work.threshold(Behavioral)
    port map (
        clk => clk,
        rst => rst,
        start => start_th,
        finish => finish_3,
        y_in => data_out_register_L_out,
        y_out => y_3);
VOT_THRSHLD : VOT_threshold 
    port map (
	      y_out_1 => y_1,
	      finish_1 => finish_1,
	      y_out_2 => y_2,
	      finish_2 => finish_2,
	      y_out_3 => y_3,
	      finish_3 => finish_3,
	      y_out => y,
	      finish => finish);
end Behavioral;

