library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VOT_Register_FCLast is
    Port ( 
		 start_threshold_1 : in std_logic;
		 data_out_1 : in vector_sm_signed(0 to number_of_outputs_L4fc-1);
		 start_threshold_2 : in std_logic;
		 data_out_2 : in vector_sm_signed(0 to number_of_outputs_L4fc-1);
		 start_threshold_3 : in std_logic;
		 data_out_3 : in vector_sm_signed(0 to number_of_outputs_L4fc-1);
		 start_threshold : out std_logic;
		 data_out : out vector_sm_signed(0 to number_of_outputs_L4fc-1));
   end VOT_Register_FCLast;

architecture Behavioral of VOT_Register_FCLast is
begin

data_out(0) <= (data_out_1(0) and data_out_2(0)) or (data_out_1(0) and data_out_3(0)) or (data_out_2(0) and data_out_3(0));
data_out(1) <= (data_out_1(1) and data_out_2(1)) or (data_out_1(1) and data_out_3(1)) or (data_out_2(1) and data_out_3(1));
data_out(2) <= (data_out_1(2) and data_out_2(2)) or (data_out_1(2) and data_out_3(2)) or (data_out_2(2) and data_out_3(2));
data_out(3) <= (data_out_1(3) and data_out_2(3)) or (data_out_1(3) and data_out_3(3)) or (data_out_2(3) and data_out_3(3));
data_out(4) <= (data_out_1(4) and data_out_2(4)) or (data_out_1(4) and data_out_3(4)) or (data_out_2(4) and data_out_3(4));
data_out(5) <= (data_out_1(5) and data_out_2(5)) or (data_out_1(5) and data_out_3(5)) or (data_out_2(5) and data_out_3(5));
data_out(6) <= (data_out_1(6) and data_out_2(6)) or (data_out_1(6) and data_out_3(6)) or (data_out_2(6) and data_out_3(6));
data_out(7) <= (data_out_1(7) and data_out_2(7)) or (data_out_1(7) and data_out_3(7)) or (data_out_2(7) and data_out_3(7));
data_out(8) <= (data_out_1(8) and data_out_2(8)) or (data_out_1(8) and data_out_3(8)) or (data_out_2(8) and data_out_3(8));
data_out(9) <= (data_out_1(9) and data_out_2(9)) or (data_out_1(9) and data_out_3(9)) or (data_out_2(9) and data_out_3(9));
start_threshold <= (start_threshold_1 and start_threshold_2) or (start_threshold_1 and start_threshold_3) or (start_threshold_2 and start_threshold_3);
end Behavioral;
