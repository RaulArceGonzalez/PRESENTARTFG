library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity VOT_Reg_softmax_1 is
 Port ( 
       data_out_1 : in vector_sm(number_of_outputs_L4fc - 1 downto 0);
       data_out_2 : in vector_sm(number_of_outputs_L4fc - 1 downto 0);
       data_out_3 : in vector_sm(number_of_outputs_L4fc - 1 downto 0);
       data_out_v : out vector_sm(number_of_outputs_L4fc - 1 downto 0));
end VOT_Reg_softmax_1;

architecture Behavioral of VOT_Reg_softmax_1 is
    begin
data_out_v(0) <= (data_out_1(0) and data_out_2(0)) or (data_out_1(0) and data_out_3(0)) or (data_out_2(0) and data_out_3(0));
data_out_v(1) <= (data_out_1(1) and data_out_2(1)) or (data_out_1(1) and data_out_3(1)) or (data_out_2(1) and data_out_3(1));
data_out_v(2) <= (data_out_1(2) and data_out_2(2)) or (data_out_1(2) and data_out_3(2)) or (data_out_2(2) and data_out_3(2));
data_out_v(3) <= (data_out_1(3) and data_out_2(3)) or (data_out_1(3) and data_out_3(3)) or (data_out_2(3) and data_out_3(3));
data_out_v(4) <= (data_out_1(4) and data_out_2(4)) or (data_out_1(4) and data_out_3(4)) or (data_out_2(4) and data_out_3(4));
data_out_v(5) <= (data_out_1(5) and data_out_2(5)) or (data_out_1(5) and data_out_3(5)) or (data_out_2(5) and data_out_3(5));
data_out_v(6) <= (data_out_1(6) and data_out_2(6)) or (data_out_1(6) and data_out_3(6)) or (data_out_2(6) and data_out_3(6));
data_out_v(7) <= (data_out_1(7) and data_out_2(7)) or (data_out_1(7) and data_out_3(7)) or (data_out_2(7) and data_out_3(7));
data_out_v(8) <= (data_out_1(8) and data_out_2(8)) or (data_out_1(8) and data_out_3(8)) or (data_out_2(8) and data_out_3(8));
data_out_v(9) <= (data_out_1(9) and data_out_2(9)) or (data_out_1(9) and data_out_3(9)) or (data_out_2(9) and data_out_3(9));
end Behavioral;
