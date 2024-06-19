LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
PACKAGE tfg_irene_package IS
	FUNCTION log2c (n : INTEGER) RETURN INTEGER;
	--================ NEURAL NETWORK PARAMETERS ================-
	--INPUT DATA

	CONSTANT address_limit : INTEGER := 784; --Size of the input image
	CONSTANT input_row_size : INTEGER := 28; --Size of the input image
	CONSTANT input_column_size : INTEGER := 28; --Size of the input image
	CONSTANT n_extra_bits : INTEGER := 3; --Number of extra bits used for precision in the MAAC operations
	--================ CNN PARAMETERS ================-
	CONSTANT layers_cnn : INTEGER := 3; --Number of layers of the convolutional part of the network
	--LAYER 1

	CONSTANT input_sizeL1 : INTEGER := 8; --Number of bits of the input data
	CONSTANT number_of_layers1 : INTEGER := 1; --Number of layers of the input matrix
	CONSTANT number_of_inputs : INTEGER := input_column_size * input_row_size * number_of_layers1; --Number of inputs of the layer
	TYPE vector_data_in IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_sizeL1 - 1 DOWNTO 0);
	TYPE vector_address IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(log2c(number_of_inputs) - 1 DOWNTO 0);
	--Conv1
	CONSTANT parallel_data : INTEGER := 2; --Number of data that are calcullated in paralel in the first layer
	CONSTANT number_of_neurons1 : INTEGER := 6; --Number of neurons in layer 1
	CONSTANT weight_sizeL1 : INTEGER := 7; --Number of bits of the weight
	CONSTANT fractional_size_L1 : INTEGER := 6; --Number of bits of the fractional size of the input data
	CONSTANT w_fractional_sizeL1 : INTEGER := 5; --Number of bits of the fractional part of the weight
	CONSTANT conv1_row : INTEGER := 5; --Size of the row of the filter
	CONSTANT conv1_column : INTEGER := 5; --Size of the column of the filter
	CONSTANT conv1_stride : INTEGER := 1; --Stride of the filter
	CONSTANT conv1_padding : INTEGER := 2; --Padding of the filter
	CONSTANT conv1_size : INTEGER := conv1_row * conv1_column; --Size of the filter
	CONSTANT mult1 : INTEGER := conv1_size * number_of_layers1; --Number of multiplications in each filter sweep
	CONSTANT row_size1 : INTEGER := input_row_size; --Size of the row of the input matrix to the layer
	CONSTANT column_size1 : INTEGER := input_column_size; --Size of the column of the input matrix to the layer
	CONSTANT column_limit1 : INTEGER := column_size1 + (2 * conv1_padding); --Maximum size of the column with padding
	CONSTANT row_limit1 : INTEGER := row_size1 + (2 * conv1_padding); --Maximum size of the row with padding
	CONSTANT n_cycles : INTEGER := 5; --Number of cycles that it taked to acces the memory (two input data)
	CONSTANT count1_max : INTEGER := input_sizeL1 - n_cycles;
	CONSTANT output_col_layer1 : INTEGER := (column_size1 + (2 * conv1_padding) - conv1_column)/conv1_stride + 1; --Size of the column of the input matrix of the layer 1; 
	CONSTANT output_row_layer1 : INTEGER := (row_size1 + (2 * conv1_padding) - conv1_row)/conv1_stride + 1; --Size of the row of the input matrix of the layer 1; 
	TYPE vector_reluL1 IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_sizeL1 + weight_sizeL1 + n_extra_bits - 1 DOWNTO 0);

	--LAYER 2

	CONSTANT input_sizeL2 : INTEGER := 8; --Number of bits of the input size in the layer
	CONSTANT fractional_size_L2 : INTEGER := 6; --Number of bits in the integer part of the input data
	CONSTANT weight_sizeL2 : INTEGER := 7; --Number of bits of the weight in the layer
	CONSTANT w_fractional_sizeL2 : INTEGER := 5; --Number of bits in the fractional size of the weights
	CONSTANT number_of_layers2 : INTEGER := 6; --Number of layers of the input matrix
	--Pool2
	--I AM APPLYING PARALLELISM, SO THE SIZE IS DIVIDED BY TWO, IF IT IS ODD I HAVE TO CHANGE IT.
	CONSTANT pool2_column : INTEGER := 2; --Column size of the pool filter
	CONSTANT pool2_row : INTEGER := 2; --Row size of the pool filter
	CONSTANT pool2_stride : INTEGER := 2; --Stride of the pool filter
	CONSTANT pool2_size : INTEGER := (pool2_column * pool2_row)/2; --Size of the pool filter(It is divided by two because the process is parallelised
	CONSTANT row_size2 : INTEGER := (output_row_layer1 - pool2_row)/pool2_stride + 1; --Row size of the input matrix
	CONSTANT column_size2 : INTEGER := (output_col_layer1 - pool2_row)/pool2_stride + 1; --Column size of the input matrix
	CONSTANT number_of_inputs2 : INTEGER := column_size2 * row_size2 * number_of_layers2; --Number of inputs in the third layer
	--Conv2
	CONSTANT conv2_row : INTEGER := 5; --Size of the row of the filter
	CONSTANT conv2_column : INTEGER := 5; --Size of the column of the filter
	CONSTANT conv2_stride : INTEGER := 1; --Stride of the filter
	CONSTANT conv2_padding : INTEGER := 0; --Padding of the filter
	CONSTANT conv2_size : INTEGER := conv2_row * conv2_column; --Size of the filter
	CONSTANT mult2 : INTEGER := conv2_size; --Number of multiplications in each filter sweep (withouth taking ito account the layers of the matrix)
	CONSTANT padding_rows2 : INTEGER := row_size2 + conv2_padding; --Size of the rows of the input matriz + padding
	CONSTANT padding_columns2 : INTEGER := column_size2 + conv2_padding; --Size of the columns of the input matriz + padding
	CONSTANT column_limit2 : INTEGER := column_size2 + (2 * conv2_padding); --Maximum column size
	CONSTANT row_limit2 : INTEGER := row_size2 + (2 * conv2_padding); --Maximum row size
	CONSTANT output_col_layer2 : INTEGER := (column_size2 + (2 * conv2_padding) - conv2_column)/conv2_stride + 1; --Size of the column of the input matrix of the layer 2; 
	CONSTANT output_row_layer2 : INTEGER := (row_size2 + (2 * conv2_padding) - conv2_row)/conv2_stride + 1; --Size of the row of the input matrix of the layer 2; 
	TYPE vector_reluL2 IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_sizeL2 + weight_sizeL2 + n_extra_bits - 1 DOWNTO 0);

	--LAYER 3 
	CONSTANT input_sizeL3 : INTEGER := 8; --Number of bits of the input size in the layer
	CONSTANT fractional_sizeL3 : INTEGER := 6; --Number of bits in the integer part of the input data
	CONSTANT number_of_layers3 : INTEGER := 16; --Number of layers of the input matrix
	--Pool3
	CONSTANT pool3_column : INTEGER := 2; --Column size of the pool filter
	CONSTANT pool3_row : INTEGER := 2; --Row size of the pool filter
	CONSTANT pool3_stride : INTEGER := 2; --Stride of the pool filter
	CONSTANT pool3_size : INTEGER := pool3_column * pool3_row; --Size of the pool filter(It is divided by two because the process is parallelised
	CONSTANT row_size3 : INTEGER := (output_row_layer2 - pool3_row)/pool3_stride + 1; --Row size of the input matrix
	CONSTANT column_size3 : INTEGER := (output_col_layer2 - pool3_row)/pool3_stride + 1; --Column size of the input matrix
	CONSTANT number_of_inputs3 : INTEGER := column_size3 * row_size3 * number_of_layers3; --Number of inputs in the third layer
	CONSTANT result_size : INTEGER := row_size3 * column_size3;

	--Interfaces Parameters

	CONSTANT stride1_et1 : INTEGER := conv1_stride;
	CONSTANT stride2_et1 : INTEGER := stride1_et1 * pool2_stride;
	CONSTANT stride3_et1 : INTEGER := stride2_et1 * conv2_stride;
	CONSTANT stride4_et1 : INTEGER := stride3_et1 * pool3_stride;
	CONSTANT stride1_et2 : INTEGER := conv2_stride;
	CONSTANT stride2_et2 : INTEGER := stride1_et2 * pool3_stride;
	--LOOPS FOR INTERFACE1
	--Columns
	CONSTANT loop_columns1_1 : INTEGER := 1;
	CONSTANT loop_columns1_2 : INTEGER := (conv1_column - 1);
	CONSTANT loop_columns1_3 : INTEGER := loop_columns1_2 - stride1_et1;
	CONSTANT loop_columns1_4 : INTEGER := loop_columns1_2 + (stride1_et1 * (pool2_column - 1 - stride1_et1));
	CONSTANT loop_columns1_5 : INTEGER := loop_columns1_4 - stride2_et1;
	CONSTANT loop_columns1_6 : INTEGER := loop_columns1_4 + (stride2_et1 * (conv2_column - 1));
	CONSTANT loop_columns1_7 : INTEGER := loop_columns1_6 - stride3_et1;
	CONSTANT loop_columns1_8 : INTEGER := loop_columns1_6 + (stride3_et1 * (pool3_column - 1));
	CONSTANT loop_columns1_9 : INTEGER := loop_columns1_8 - stride4_et1;
	--Rows
	CONSTANT loop_rows1_1 : INTEGER := 1;
	CONSTANT loop_rows1_2 : INTEGER := (conv1_row - 1);
	CONSTANT loop_rows1_3 : INTEGER := loop_rows1_2 - stride1_et1;
	CONSTANT loop_rows1_4 : INTEGER := loop_rows1_2 + (stride1_et1 * (pool2_row - 1));
	CONSTANT loop_rows1_5 : INTEGER := loop_rows1_4 - stride2_et1;
	CONSTANT loop_rows1_6 : INTEGER := loop_rows1_4 + (stride2_et1 * (conv2_row - 1));
	CONSTANT loop_rows1_7 : INTEGER := loop_rows1_6 - stride3_et1;
	CONSTANT loop_rows1_8 : INTEGER := loop_rows1_6 + (stride3_et1 * (pool3_row - 1));
	CONSTANT loop_rows1_9 : INTEGER := loop_rows1_8 - stride4_et1;
	--LOOPS FOR INTERFACE2
	--Columns
	CONSTANT loop_columns2_1 : INTEGER := 1;
	CONSTANT loop_columns2_2 : INTEGER := (conv2_column - 1);
	CONSTANT loop_columns2_3 : INTEGER := loop_columns2_2 - stride1_et2;
	CONSTANT loop_columns2_4 : INTEGER := loop_columns2_2 + (stride1_et2 * (pool3_column - 1));
	CONSTANT loop_columns2_5 : INTEGER := loop_columns2_4 - stride2_et2;
	--Rows
	CONSTANT loop_rows2_1 : INTEGER := 1;
	CONSTANT loop_rows2_2 : INTEGER := (conv2_row - 1);
	CONSTANT loop_rows2_3 : INTEGER := loop_rows2_2 - stride1_et2;
	CONSTANT loop_rows2_4 : INTEGER := loop_rows2_2 + (stride1_et2 * (pool3_row - 1));
	CONSTANT loop_rows2_5 : INTEGER := loop_rows2_4 - stride2_et2;
	CONSTANT bits_sum1_et1 : INTEGER := log2c(conv2_padding) + stride2_et1;

	--================ FC PARAMETERS ================-
	CONSTANT layers_fc : INTEGER := 4; -- Numbers of FC layers 
	CONSTANT biggest_ROM_size : INTEGER := 400; -- Maximum input data (coming from the FC)
	CONSTANT log2_biggest_ROM_size : INTEGER := log2c(biggest_ROM_size);

	CONSTANT number_of_neurons_L1fc : INTEGER := 120; -- Number of neurons in the layer
	CONSTANT input_size_L1fc : INTEGER := 8; -- Number of bits of the input data of the FC
	CONSTANT weight_size_L1fc : INTEGER := 8; -- Number of bits of the weight of the layer.
	CONSTANT fractional_size_L1fc : INTEGER := 6; -- Number of bits of the fractional part of the input data
	CONSTANT w_fractional_size_L1fc : INTEGER := 6; -- Number of bits of the fractional part of the weight
	CONSTANT integer_size_L1fc : INTEGER := input_size_L1fc - fractional_size_L1fc; -- Number of bits of the integer part of the input data
	CONSTANT w_integer_size_L1fc : INTEGER := weight_size_L1fc - w_fractional_size_L1fc; -- Number of bits of the integerpart of the weight
	CONSTANT number_of_inputs_L1fc : INTEGER := 400; -- Number of inputs of the layer
	CONSTANT number_of_outputs_L1fc : INTEGER := 120; --Number of outputs of the layer
	TYPE vector_L1fc IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_size_L1fc - 1 DOWNTO 0);
	TYPE vector_L1fc_signed IS ARRAY (NATURAL RANGE <>) OF signed(input_size_L1fc - 1 DOWNTO 0);
	TYPE vector_L1fc_activations IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_size_L1fc + weight_size_L1fc + n_extra_bits - 1 DOWNTO 0);
	CONSTANT number_of_neurons_L2fc : INTEGER := 84; -- Number of neurons in the layer
	CONSTANT input_size_L2fc : INTEGER := 8; -- Number of bits of the input data of the FC
	CONSTANT weight_size_L2fc : INTEGER := 8; -- Number of bits of the weight of the layer.
	CONSTANT fractional_size_L2fc : INTEGER := 6; -- Number of bits of the fractional part of the input data
	CONSTANT w_fractional_size_L2fc : INTEGER := 6; -- Number of bits of the fractional part of the weight
	CONSTANT integer_size_L2fc : INTEGER := input_size_L2fc - fractional_size_L2fc; -- Number of bits of the integer part of the input data
	CONSTANT w_integer_size_L2fc : INTEGER := weight_size_L2fc - w_fractional_size_L2fc; -- Number of bits of the integerpart of the weight
	CONSTANT number_of_inputs_L2fc : INTEGER := 120; -- Number of inputs of the layer
	CONSTANT number_of_outputs_L2fc : INTEGER := 84; --Number of outputs of the layer
	TYPE vector_L2fc IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_size_L2fc - 1 DOWNTO 0);
	TYPE vector_L2fc_signed IS ARRAY (NATURAL RANGE <>) OF signed(input_size_L2fc - 1 DOWNTO 0);
	TYPE vector_L2fc_activations IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_size_L2fc + weight_size_L2fc + n_extra_bits - 1 DOWNTO 0);
	CONSTANT number_of_neurons_L3fc : INTEGER := 10; -- Number of neurons in the layer
	CONSTANT input_size_L3fc : INTEGER := 8; -- Number of bits of the input data of the FC
	CONSTANT weight_size_L3fc : INTEGER := 8; -- Number of bits of the weight of the layer.
	CONSTANT fractional_size_L3fc : INTEGER := 6; -- Number of bits of the fractional part of the input data
	CONSTANT w_fractional_size_L3fc : INTEGER := 6; -- Number of bits of the fractional part of the weight
	CONSTANT integer_size_L3fc : INTEGER := input_size_L3fc - fractional_size_L3fc; -- Number of bits of the integer part of the input data
	CONSTANT w_integer_size_L3fc : INTEGER := weight_size_L3fc - w_fractional_size_L3fc; -- Number of bits of the integerpart of the weight
	CONSTANT number_of_inputs_L3fc : INTEGER := 84; -- Number of inputs of the layer
	CONSTANT number_of_outputs_L3fc : INTEGER := 10; --Number of outputs of the layer
	TYPE vector_L3fc IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_size_L3fc - 1 DOWNTO 0);
	TYPE vector_L3fc_signed IS ARRAY (NATURAL RANGE <>) OF signed(input_size_L3fc - 1 DOWNTO 0);
	TYPE vector_L3fc_activations IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_size_L3fc + weight_size_L3fc + n_extra_bits - 1 DOWNTO 0);

	--Softmax layer

	CONSTANT number_of_inputs_L4fc : INTEGER := 10; -- Number of inputs of the softmax layer
	CONSTANT input_size_L4fc : INTEGER := 8; -- Number of bits of the input data to the softmax layer
	CONSTANT weight_size_L4fc : INTEGER := 8; -- Number of bits of the weights of the softmax layer
	CONSTANT fractional_size_L4fc : INTEGER := 4; -- Number of bits of the fractional part of the input data
	CONSTANT integer_size_L4fc : INTEGER := input_size_L4fc - fractional_size_L4fc; -- Number of bits of the integer part of the input data
	CONSTANT w_fractional_size_L4fc : INTEGER := 6; -- Number of bits for the fractional part of the weight
	CONSTANT integer_size_sum : INTEGER := 5; -- Number of bits of the sum 
	CONSTANT fractional_size_sum : INTEGER := 3; -- Number of bits of the fractional part of the sum
	CONSTANT number_of_outputs_L4fc : INTEGER := 10; -- Number of outputs of the softmax layer
	TYPE vector_sm IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(input_size_L4fc - 1 DOWNTO 0);
	TYPE vector_sm_signed IS ARRAY (NATURAL RANGE <>) OF signed(input_size_L4fc - 1 DOWNTO 0);
	TYPE output_t IS ARRAY (0 TO 9) OF STD_LOGIC_VECTOR (31 DOWNTO 0);

END PACKAGE tfg_irene_package;
PACKAGE BODY tfg_irene_package IS
	FUNCTION log2c(n : INTEGER) RETURN INTEGER IS
		VARIABLE m, p : INTEGER;
	BEGIN
		m := 0;
		p := 1;
		WHILE p < n LOOP
			m := m + 1;
			p := p * 2;
		END LOOP;
		RETURN m;
	END log2c;
END PACKAGE BODY;