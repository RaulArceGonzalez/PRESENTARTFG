--------------------------FC NEURON MODULE------------------------------------
-- This module performs the MAAC operation which consists of the addition of each multiplication of a signal by its corresponding weight.
-- It is performed by adding a 1 each time the input pulse indicates that the signal is not zero. 
---INPUTS
-- data_in : each bit of the input data.
-- rom_addr : indicates which weight to operate with, corresponding to the input_data
-- next_pipeline_step : notifies when all the input data has been processed and moves on to the next set of data.
-- bit select : indicates which bit of the input data we are receiving at each moment.
---OUTPUTS
-- neuron_mac : the output is the accumulation of the input signals multiplied by the respective weights.
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY layer1_FCneuron_47 IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		data_in_bit : IN STD_LOGIC;
		next_pipeline_step : IN STD_LOGIC;
		bit_select : IN unsigned (log2c(input_size_L1fc) - 1 DOWNTO 0);
		rom_addr : IN STD_LOGIC_VECTOR (log2c(number_of_layers3) + log2c(result_size) - 1 DOWNTO 0);
		neuron_mac : OUT STD_LOGIC_VECTOR (input_size_L1fc + weight_size_L1fc + n_extra_bits - 1 DOWNTO 0));
END layer1_FCneuron_47;

ARCHITECTURE Behavioral OF layer1_FCneuron_47 IS

	SIGNAL mac_out_next, mac_out_reg : signed (input_size_L1fc + weight_size_L1fc + n_extra_bits - 1 DOWNTO 0) := "0000000000000000000"; --We add extra bits for precision.
	SIGNAL mux_out3 : signed (input_size_L1fc + weight_size_L1fc + n_extra_bits - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL weight, aux_weight : signed (weight_size_L1fc - 1 DOWNTO 0);
	SIGNAL mux_out1, mux_out2, extended_weight, shifted_weight_next, shifted_weight_reg : signed (weight_size_L1fc + input_size_L1fc - 2 DOWNTO 0);
	-- Only need to shift (input_size-1) times - e.g. 7 shifts if input_size = 8, hence the "-2".

BEGIN

	-- Register --
	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF (rst = '0') THEN
				mac_out_reg <= "0000000000000000000";
				shifted_weight_reg <= (OTHERS => '0');
			ELSE
				mac_out_reg <= mac_out_next;
				shifted_weight_reg <= shifted_weight_next;
			END IF;
		END IF;
	END PROCESS;

	-- Weight extension
	extended_weight <= resize(weight, weight_size_L1fc + input_size_L1fc - 1); -- As we shift the signals (input_size - 1 we need to resize it accordingly (weight_size + input_size - 1).

	-- Shift block --
	mux_out1 <= extended_weight WHEN (bit_select = "000") ELSE
		shifted_weight_reg;

	shifted_weight_next <= mux_out1(weight_size_L1fc + input_size_L1fc - n_extra_bits DOWNTO 0) & '0'; -- Logic Shift Left

	-- Addition block
	PROCESS (data_in_bit, mux_out1) --If the input bit is 1 we add the shifted weight to the accumulated result.  
	BEGIN
		IF (data_in_bit = '1') THEN
			mux_out2 <= mux_out1;
		ELSE
			mux_out2 <= (OTHERS => '0');
		END IF;
	END PROCESS;
	mux_out3 <= resize(mux_out2, input_size_L1fc + weight_size_L1fc + n_extra_bits);

	PROCESS (next_pipeline_step, mac_out_reg, mac_out_next, mux_out3) --if next_pipeline_step = '1' it means that the MAAC operation is finished and we reset the result to the bias_term (offset) else we accumulate the result of the multiplications.
	BEGIN
		IF (next_pipeline_step = '1') THEN
			mac_out_next <= "0000000000000000000"; --We add the bias_term as an offset at the beggining of each operation.
		ELSE
			mac_out_next <= mac_out_reg + mux_out3;
		END IF;
	END PROCESS;
	neuron_mac <= STD_LOGIC_VECTOR(mac_out_reg);
	-- ROM --
	WITH rom_addr SELECT weight <=

		"00000000" WHEN "000000000", -- Weight 0  
		"00000000" WHEN "000000001", -- Weight 1  
		"11111110" WHEN "000000010", -- Weight 2  
		"00000010" WHEN "000000011", -- Weight 3  
		"00000010" WHEN "000000100", -- Weight 4  
		"00000001" WHEN "000000101", -- Weight 5  
		"00000010" WHEN "000000110", -- Weight 6  
		"00000001" WHEN "000000111", -- Weight 7  
		"00000110" WHEN "000001000", -- Weight 8  
		"00000000" WHEN "000001001", -- Weight 9  
		"00000010" WHEN "000001010", -- Weight 10  
		"00000011" WHEN "000001011", -- Weight 11  
		"00000010" WHEN "000001100", -- Weight 12  
		"00000001" WHEN "000001101", -- Weight 13  
		"00000011" WHEN "000001110", -- Weight 14  
		"00000100" WHEN "000001111", -- Weight 15  
		"11111100" WHEN "000010000", -- Weight 16  
		"11111001" WHEN "000010001", -- Weight 17  
		"00000000" WHEN "000010010", -- Weight 18  
		"00000100" WHEN "000010011", -- Weight 19  
		"11111100" WHEN "000010100", -- Weight 20  
		"11111110" WHEN "000010101", -- Weight 21  
		"00000110" WHEN "000010110", -- Weight 22  
		"11111011" WHEN "000010111", -- Weight 23  
		"00001001" WHEN "000011000", -- Weight 24  
		"11111110" WHEN "000011001", -- Weight 25  
		"00000011" WHEN "000011010", -- Weight 26  
		"00000000" WHEN "000011011", -- Weight 27  
		"00000000" WHEN "000011100", -- Weight 28  
		"00000011" WHEN "000011101", -- Weight 29  
		"00001000" WHEN "000011110", -- Weight 30  
		"00000101" WHEN "000011111", -- Weight 31  
		"00000001" WHEN "000100000", -- Weight 32  
		"11111111" WHEN "000100001", -- Weight 33  
		"00000001" WHEN "000100010", -- Weight 34  
		"00000111" WHEN "000100011", -- Weight 35  
		"11110100" WHEN "000100100", -- Weight 36  
		"11110101" WHEN "000100101", -- Weight 37  
		"00001010" WHEN "000100110", -- Weight 38  
		"11111110" WHEN "000100111", -- Weight 39  
		"00000000" WHEN "000101000", -- Weight 40  
		"00000001" WHEN "000101001", -- Weight 41  
		"00000000" WHEN "000101010", -- Weight 42  
		"00000001" WHEN "000101011", -- Weight 43  
		"11111111" WHEN "000101100", -- Weight 44  
		"00000011" WHEN "000101101", -- Weight 45  
		"00000110" WHEN "000101110", -- Weight 46  
		"00000101" WHEN "000101111", -- Weight 47  
		"00000010" WHEN "000110000", -- Weight 48  
		"11111101" WHEN "000110001", -- Weight 49  
		"11111101" WHEN "000110010", -- Weight 50  
		"11111101" WHEN "000110011", -- Weight 51  
		"11111100" WHEN "000110100", -- Weight 52  
		"11110000" WHEN "000110101", -- Weight 53  
		"00001000" WHEN "000110110", -- Weight 54  
		"00000100" WHEN "000110111", -- Weight 55  
		"11110111" WHEN "000111000", -- Weight 56  
		"00000001" WHEN "000111001", -- Weight 57  
		"11111011" WHEN "000111010", -- Weight 58  
		"11110001" WHEN "000111011", -- Weight 59  
		"00000000" WHEN "000111100", -- Weight 60  
		"11110011" WHEN "000111101", -- Weight 61  
		"00000111" WHEN "000111110", -- Weight 62  
		"00000001" WHEN "000111111", -- Weight 63  
		"11111111" WHEN "001000000", -- Weight 64  
		"11111111" WHEN "001000001", -- Weight 65  
		"11111001" WHEN "001000010", -- Weight 66  
		"11111110" WHEN "001000011", -- Weight 67  
		"00000011" WHEN "001000100", -- Weight 68  
		"11111001" WHEN "001000101", -- Weight 69  
		"00000001" WHEN "001000110", -- Weight 70  
		"00000000" WHEN "001000111", -- Weight 71  
		"11111100" WHEN "001001000", -- Weight 72  
		"11111011" WHEN "001001001", -- Weight 73  
		"11110111" WHEN "001001010", -- Weight 74  
		"11110011" WHEN "001001011", -- Weight 75  
		"00000010" WHEN "001001100", -- Weight 76  
		"11110111" WHEN "001001101", -- Weight 77  
		"00000100" WHEN "001001110", -- Weight 78  
		"11111111" WHEN "001001111", -- Weight 79  
		"00000101" WHEN "001010000", -- Weight 80  
		"00000000" WHEN "001010001", -- Weight 81  
		"00000011" WHEN "001010010", -- Weight 82  
		"00000000" WHEN "001010011", -- Weight 83  
		"00000000" WHEN "001010100", -- Weight 84  
		"00000000" WHEN "001010101", -- Weight 85  
		"00000000" WHEN "001010110", -- Weight 86  
		"11111010" WHEN "001010111", -- Weight 87  
		"00000101" WHEN "001011000", -- Weight 88  
		"00001010" WHEN "001011001", -- Weight 89  
		"00000101" WHEN "001011010", -- Weight 90  
		"00000011" WHEN "001011011", -- Weight 91  
		"11110110" WHEN "001011100", -- Weight 92  
		"00000010" WHEN "001011101", -- Weight 93  
		"00000011" WHEN "001011110", -- Weight 94  
		"11111010" WHEN "001011111", -- Weight 95  
		"11111111" WHEN "001100000", -- Weight 96  
		"11110111" WHEN "001100001", -- Weight 97  
		"00000101" WHEN "001100010", -- Weight 98  
		"00000000" WHEN "001100011", -- Weight 99  
		"11111001" WHEN "001100100", -- Weight 100  
		"00000001" WHEN "001100101", -- Weight 101  
		"00001011" WHEN "001100110", -- Weight 102  
		"11111001" WHEN "001100111", -- Weight 103  
		"00001011" WHEN "001101000", -- Weight 104  
		"00000101" WHEN "001101001", -- Weight 105  
		"00000101" WHEN "001101010", -- Weight 106  
		"00000000" WHEN "001101011", -- Weight 107  
		"11111011" WHEN "001101100", -- Weight 108  
		"00000110" WHEN "001101101", -- Weight 109  
		"00001011" WHEN "001101110", -- Weight 110  
		"00001100" WHEN "001101111", -- Weight 111  
		"11111100" WHEN "001110000", -- Weight 112  
		"11111011" WHEN "001110001", -- Weight 113  
		"00001000" WHEN "001110010", -- Weight 114  
		"00001001" WHEN "001110011", -- Weight 115  
		"11110101" WHEN "001110100", -- Weight 116  
		"11110111" WHEN "001110101", -- Weight 117  
		"00001101" WHEN "001110110", -- Weight 118  
		"00001011" WHEN "001110111", -- Weight 119  
		"11111111" WHEN "001111000", -- Weight 120  
		"00000010" WHEN "001111001", -- Weight 121  
		"11111100" WHEN "001111010", -- Weight 122  
		"11111001" WHEN "001111011", -- Weight 123  
		"00001100" WHEN "001111100", -- Weight 124  
		"00000001" WHEN "001111101", -- Weight 125  
		"00000101" WHEN "001111110", -- Weight 126  
		"00001001" WHEN "001111111", -- Weight 127  
		"00000101" WHEN "010000000", -- Weight 128  
		"11111100" WHEN "010000001", -- Weight 129  
		"00000111" WHEN "010000010", -- Weight 130  
		"00000011" WHEN "010000011", -- Weight 131  
		"00000011" WHEN "010000100", -- Weight 132  
		"11110101" WHEN "010000101", -- Weight 133  
		"00000000" WHEN "010000110", -- Weight 134  
		"00001010" WHEN "010000111", -- Weight 135  
		"11101111" WHEN "010001000", -- Weight 136  
		"00000000" WHEN "010001001", -- Weight 137  
		"11111000" WHEN "010001010", -- Weight 138  
		"11110000" WHEN "010001011", -- Weight 139  
		"00001011" WHEN "010001100", -- Weight 140  
		"11111011" WHEN "010001101", -- Weight 141  
		"00000111" WHEN "010001110", -- Weight 142  
		"00000001" WHEN "010001111", -- Weight 143  
		"00000000" WHEN "010010000", -- Weight 144  
		"00000000" WHEN "010010001", -- Weight 145  
		"11111100" WHEN "010010010", -- Weight 146  
		"11111101" WHEN "010010011", -- Weight 147  
		"00000100" WHEN "010010100", -- Weight 148  
		"00000000" WHEN "010010101", -- Weight 149  
		"11110110" WHEN "010010110", -- Weight 150  
		"00000001" WHEN "010010111", -- Weight 151  
		"11101100" WHEN "010011000", -- Weight 152  
		"11111111" WHEN "010011001", -- Weight 153  
		"11110111" WHEN "010011010", -- Weight 154  
		"11110100" WHEN "010011011", -- Weight 155  
		"00000000" WHEN "010011100", -- Weight 156  
		"11111011" WHEN "010011101", -- Weight 157  
		"11111110" WHEN "010011110", -- Weight 158  
		"11110100" WHEN "010011111", -- Weight 159  
		"00000000" WHEN "010100000", -- Weight 160  
		"11111111" WHEN "010100001", -- Weight 161  
		"11111011" WHEN "010100010", -- Weight 162  
		"00000001" WHEN "010100011", -- Weight 163  
		"00000010" WHEN "010100100", -- Weight 164  
		"00000000" WHEN "010100101", -- Weight 165  
		"00000000" WHEN "010100110", -- Weight 166  
		"00000000" WHEN "010100111", -- Weight 167  
		"00000000" WHEN "010101000", -- Weight 168  
		"11111110" WHEN "010101001", -- Weight 169  
		"00000010" WHEN "010101010", -- Weight 170  
		"00000010" WHEN "010101011", -- Weight 171  
		"11111111" WHEN "010101100", -- Weight 172  
		"11111111" WHEN "010101101", -- Weight 173  
		"00000001" WHEN "010101110", -- Weight 174  
		"00000001" WHEN "010101111", -- Weight 175  
		"00000000" WHEN "010110000", -- Weight 176  
		"11110101" WHEN "010110001", -- Weight 177  
		"11111111" WHEN "010110010", -- Weight 178  
		"00000000" WHEN "010110011", -- Weight 179  
		"11111111" WHEN "010110100", -- Weight 180  
		"11111100" WHEN "010110101", -- Weight 181  
		"00000000" WHEN "010110110", -- Weight 182  
		"00000000" WHEN "010110111", -- Weight 183  
		"11111101" WHEN "010111000", -- Weight 184  
		"11111010" WHEN "010111001", -- Weight 185  
		"11111100" WHEN "010111010", -- Weight 186  
		"11111111" WHEN "010111011", -- Weight 187  
		"00000000" WHEN "010111100", -- Weight 188  
		"11110110" WHEN "010111101", -- Weight 189  
		"00000011" WHEN "010111110", -- Weight 190  
		"00000000" WHEN "010111111", -- Weight 191  
		"00000001" WHEN "011000000", -- Weight 192  
		"00000100" WHEN "011000001", -- Weight 193  
		"00000011" WHEN "011000010", -- Weight 194  
		"00000000" WHEN "011000011", -- Weight 195  
		"00000010" WHEN "011000100", -- Weight 196  
		"00000011" WHEN "011000101", -- Weight 197  
		"00000001" WHEN "011000110", -- Weight 198  
		"00000011" WHEN "011000111", -- Weight 199  
		"00000001" WHEN "011001000", -- Weight 200  
		"00000000" WHEN "011001001", -- Weight 201  
		"00000000" WHEN "011001010", -- Weight 202  
		"11111110" WHEN "011001011", -- Weight 203  
		"00000000" WHEN "011001100", -- Weight 204  
		"11111101" WHEN "011001101", -- Weight 205  
		"11111110" WHEN "011001110", -- Weight 206  
		"00000011" WHEN "011001111", -- Weight 207  
		"11111001" WHEN "011010000", -- Weight 208  
		"00000010" WHEN "011010001", -- Weight 209  
		"11111101" WHEN "011010010", -- Weight 210  
		"00001000" WHEN "011010011", -- Weight 211  
		"00000111" WHEN "011010100", -- Weight 212  
		"00000110" WHEN "011010101", -- Weight 213  
		"11110110" WHEN "011010110", -- Weight 214  
		"11111000" WHEN "011010111", -- Weight 215  
		"00000100" WHEN "011011000", -- Weight 216  
		"11111001" WHEN "011011001", -- Weight 217  
		"00001000" WHEN "011011010", -- Weight 218  
		"00000111" WHEN "011011011", -- Weight 219  
		"11111100" WHEN "011011100", -- Weight 220  
		"00001100" WHEN "011011101", -- Weight 221  
		"11111100" WHEN "011011110", -- Weight 222  
		"11111010" WHEN "011011111", -- Weight 223  
		"11111111" WHEN "011100000", -- Weight 224  
		"11111110" WHEN "011100001", -- Weight 225  
		"11111101" WHEN "011100010", -- Weight 226  
		"00000010" WHEN "011100011", -- Weight 227  
		"00000100" WHEN "011100100", -- Weight 228  
		"00001011" WHEN "011100101", -- Weight 229  
		"11111000" WHEN "011100110", -- Weight 230  
		"11111000" WHEN "011100111", -- Weight 231  
		"00000011" WHEN "011101000", -- Weight 232  
		"11111010" WHEN "011101001", -- Weight 233  
		"00000011" WHEN "011101010", -- Weight 234  
		"00000111" WHEN "011101011", -- Weight 235  
		"11111010" WHEN "011101100", -- Weight 236  
		"00001001" WHEN "011101101", -- Weight 237  
		"11111001" WHEN "011101110", -- Weight 238  
		"11110111" WHEN "011101111", -- Weight 239  
		"11111100" WHEN "011110000", -- Weight 240  
		"11111111" WHEN "011110001", -- Weight 241  
		"11111011" WHEN "011110010", -- Weight 242  
		"00000000" WHEN "011110011", -- Weight 243  
		"00000011" WHEN "011110100", -- Weight 244  
		"00000100" WHEN "011110101", -- Weight 245  
		"11111100" WHEN "011110110", -- Weight 246  
		"00000000" WHEN "011110111", -- Weight 247  
		"11111111" WHEN "011111000", -- Weight 248  
		"11111101" WHEN "011111001", -- Weight 249  
		"00000001" WHEN "011111010", -- Weight 250  
		"00000010" WHEN "011111011", -- Weight 251  
		"11111111" WHEN "011111100", -- Weight 252  
		"00000001" WHEN "011111101", -- Weight 253  
		"00000000" WHEN "011111110", -- Weight 254  
		"11111100" WHEN "011111111", -- Weight 255  
		"11111111" WHEN "100000000", -- Weight 256  
		"11110110" WHEN "100000001", -- Weight 257  
		"00000010" WHEN "100000010", -- Weight 258  
		"00000000" WHEN "100000011", -- Weight 259  
		"11111110" WHEN "100000100", -- Weight 260  
		"11111111" WHEN "100000101", -- Weight 261  
		"00000001" WHEN "100000110", -- Weight 262  
		"11110101" WHEN "100000111", -- Weight 263  
		"00000000" WHEN "100001000", -- Weight 264  
		"00000001" WHEN "100001001", -- Weight 265  
		"00000000" WHEN "100001010", -- Weight 266  
		"11111100" WHEN "100001011", -- Weight 267  
		"11111010" WHEN "100001100", -- Weight 268  
		"00000101" WHEN "100001101", -- Weight 269  
		"00000000" WHEN "100001110", -- Weight 270  
		"11111100" WHEN "100001111", -- Weight 271  
		"00000000" WHEN "100010000", -- Weight 272  
		"00000011" WHEN "100010001", -- Weight 273  
		"00000000" WHEN "100010010", -- Weight 274  
		"00000000" WHEN "100010011", -- Weight 275  
		"00000011" WHEN "100010100", -- Weight 276  
		"00000100" WHEN "100010101", -- Weight 277  
		"11111111" WHEN "100010110", -- Weight 278  
		"11111010" WHEN "100010111", -- Weight 279  
		"00000000" WHEN "100011000", -- Weight 280  
		"00000001" WHEN "100011001", -- Weight 281  
		"00001000" WHEN "100011010", -- Weight 282  
		"00000101" WHEN "100011011", -- Weight 283  
		"11111000" WHEN "100011100", -- Weight 284  
		"00000110" WHEN "100011101", -- Weight 285  
		"00000000" WHEN "100011110", -- Weight 286  
		"00000010" WHEN "100011111", -- Weight 287  
		"00000101" WHEN "100100000", -- Weight 288  
		"00000101" WHEN "100100001", -- Weight 289  
		"11111110" WHEN "100100010", -- Weight 290  
		"00000011" WHEN "100100011", -- Weight 291  
		"00000000" WHEN "100100100", -- Weight 292  
		"00000001" WHEN "100100101", -- Weight 293  
		"11110101" WHEN "100100110", -- Weight 294  
		"11111010" WHEN "100100111", -- Weight 295  
		"11111111" WHEN "100101000", -- Weight 296  
		"11111010" WHEN "100101001", -- Weight 297  
		"00001010" WHEN "100101010", -- Weight 298  
		"00000100" WHEN "100101011", -- Weight 299  
		"11110011" WHEN "100101100", -- Weight 300  
		"11111110" WHEN "100101101", -- Weight 301  
		"11111101" WHEN "100101110", -- Weight 302  
		"11111100" WHEN "100101111", -- Weight 303  
		"00000001" WHEN "100110000", -- Weight 304  
		"11111011" WHEN "100110001", -- Weight 305  
		"11111100" WHEN "100110010", -- Weight 306  
		"00000011" WHEN "100110011", -- Weight 307  
		"00000000" WHEN "100110100", -- Weight 308  
		"00000010" WHEN "100110101", -- Weight 309  
		"00000011" WHEN "100110110", -- Weight 310  
		"11111111" WHEN "100110111", -- Weight 311  
		"00000110" WHEN "100111000", -- Weight 312  
		"00000000" WHEN "100111001", -- Weight 313  
		"00001010" WHEN "100111010", -- Weight 314  
		"11111111" WHEN "100111011", -- Weight 315  
		"00000000" WHEN "100111100", -- Weight 316  
		"11111011" WHEN "100111101", -- Weight 317  
		"00000010" WHEN "100111110", -- Weight 318  
		"00000000" WHEN "100111111", -- Weight 319  
		"00000010" WHEN "101000000", -- Weight 320  
		"00000000" WHEN "101000001", -- Weight 321  
		"00000001" WHEN "101000010", -- Weight 322  
		"00000011" WHEN "101000011", -- Weight 323  
		"00000000" WHEN "101000100", -- Weight 324  
		"00000101" WHEN "101000101", -- Weight 325  
		"11111100" WHEN "101000110", -- Weight 326  
		"11111100" WHEN "101000111", -- Weight 327  
		"00000000" WHEN "101001000", -- Weight 328  
		"00000010" WHEN "101001001", -- Weight 329  
		"00000110" WHEN "101001010", -- Weight 330  
		"00000001" WHEN "101001011", -- Weight 331  
		"00000000" WHEN "101001100", -- Weight 332  
		"00000000" WHEN "101001101", -- Weight 333  
		"00000001" WHEN "101001110", -- Weight 334  
		"00000011" WHEN "101001111", -- Weight 335  
		"00000011" WHEN "101010000", -- Weight 336  
		"00000000" WHEN "101010001", -- Weight 337  
		"00000001" WHEN "101010010", -- Weight 338  
		"00000111" WHEN "101010011", -- Weight 339  
		"00000011" WHEN "101010100", -- Weight 340  
		"00000011" WHEN "101010101", -- Weight 341  
		"11111110" WHEN "101010110", -- Weight 342  
		"11111011" WHEN "101010111", -- Weight 343  
		"00000000" WHEN "101011000", -- Weight 344  
		"00000001" WHEN "101011001", -- Weight 345  
		"00000110" WHEN "101011010", -- Weight 346  
		"11111101" WHEN "101011011", -- Weight 347  
		"11111111" WHEN "101011100", -- Weight 348  
		"00000011" WHEN "101011101", -- Weight 349  
		"00000100" WHEN "101011110", -- Weight 350  
		"00000000" WHEN "101011111", -- Weight 351  
		"00000100" WHEN "101100000", -- Weight 352  
		"00000000" WHEN "101100001", -- Weight 353  
		"11111111" WHEN "101100010", -- Weight 354  
		"00000110" WHEN "101100011", -- Weight 355  
		"00000110" WHEN "101100100", -- Weight 356  
		"00000010" WHEN "101100101", -- Weight 357  
		"11111100" WHEN "101100110", -- Weight 358  
		"00000001" WHEN "101100111", -- Weight 359  
		"11111011" WHEN "101101000", -- Weight 360  
		"11111011" WHEN "101101001", -- Weight 361  
		"00000011" WHEN "101101010", -- Weight 362  
		"11110111" WHEN "101101011", -- Weight 363  
		"00000100" WHEN "101101100", -- Weight 364  
		"11111111" WHEN "101101101", -- Weight 365  
		"00000100" WHEN "101101110", -- Weight 366  
		"00000011" WHEN "101101111", -- Weight 367  
		"00000100" WHEN "101110000", -- Weight 368  
		"11111100" WHEN "101110001", -- Weight 369  
		"11111100" WHEN "101110010", -- Weight 370  
		"00000001" WHEN "101110011", -- Weight 371  
		"00000000" WHEN "101110100", -- Weight 372  
		"00000001" WHEN "101110101", -- Weight 373  
		"11111010" WHEN "101110110", -- Weight 374  
		"00001001" WHEN "101110111", -- Weight 375  
		"11111101" WHEN "101111000", -- Weight 376  
		"11111111" WHEN "101111001", -- Weight 377  
		"11111101" WHEN "101111010", -- Weight 378  
		"11110101" WHEN "101111011", -- Weight 379  
		"00000111" WHEN "101111100", -- Weight 380  
		"11111000" WHEN "101111101", -- Weight 381  
		"00000000" WHEN "101111110", -- Weight 382  
		"00000000" WHEN "101111111", -- Weight 383  
		"00000000" WHEN "110000000", -- Weight 384  
		"11111100" WHEN "110000001", -- Weight 385  
		"00000011" WHEN "110000010", -- Weight 386  
		"11111011" WHEN "110000011", -- Weight 387  
		"11111101" WHEN "110000100", -- Weight 388  
		"11111101" WHEN "110000101", -- Weight 389  
		"00000100" WHEN "110000110", -- Weight 390  
		"00001000" WHEN "110000111", -- Weight 391  
		"00000010" WHEN "110001000", -- Weight 392  
		"00001010" WHEN "110001001", -- Weight 393  
		"11111001" WHEN "110001010", -- Weight 394  
		"11111011" WHEN "110001011", -- Weight 395  
		"00000111" WHEN "110001100", -- Weight 396  
		"11111001" WHEN "110001101", -- Weight 397  
		"11111111" WHEN "110001110", -- Weight 398  
		"00000010" WHEN "110001111", -- Weight 399  
		"00000000" WHEN OTHERS;
END Behavioral;