LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.tfg_irene_package.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY LED IS
    PORT (
        clk : IN STD_LOGIC;
        y : IN unsigned(log2c(number_of_outputs_L4fc) - 1 DOWNTO 0);
        an : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        seg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END LED;
ARCHITECTURE Behavioral OF LED IS
    SIGNAL seg1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL c_reg, c_next : unsigned(11 DOWNTO 0) := (OTHERS => '0');
BEGIN

    WITH y SELECT
        seg1 <= "1000000" WHEN "0000",
        "1111001" WHEN "0001",
        "0100100" WHEN "0010",
        "0110000" WHEN "0011",
        "0011001" WHEN "0100",
        "0010010" WHEN "0101",
        "0000010" WHEN "0110",
        "1111000" WHEN "0111",
        "0000000" WHEN "1000",
        "0010000" WHEN "1001",
        "0111111" WHEN OTHERS;
    an <= "01111111";
    seg <= seg1;

END Behavioral;