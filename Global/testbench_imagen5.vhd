----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.06.2024 10:10:14
-- Design Name: 
-- Module Name: testbench_imagen5 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.tfg_irene_package.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench_imagen5 is
--  Port ();
end testbench_imagen5;


architecture Behavioral of testbench_imagen5 is
component neural_network is
    Port ( clk : in std_logic;
            rst : in std_logic;
            en_riscv : out std_logic;
            an : out std_logic_vector(7 downto 0);
            seg : out std_logic_vector(6 downto 0);
            y : out std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0);
            finish : out std_logic);
end component;
signal finish, reset_aux, en_riscv, clk : STD_LOGIC := '0';
SIGNAL an : std_logic_vector(7 downto 0);
signal seg : std_logic_vector(6 downto 0);
signal y : std_logic_vector(log2c(number_of_outputs_L4fc) - 1 downto 0);
--declaracion señale auxiliares de salida

--deficinion del periodo de reloj
signal clk_period : time := 10 ns; 
begin
uut_neural: neural_network
    PORT MAP (
            clk => clk,
            rst => reset_aux,
            en_riscv => en_riscv,
            an => an,
            seg => seg,
            y => y,
            finish => finish);

clk_process: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

reset_process: process
begin
    reset_aux <= '0';
    wait for clk_period*2;
    reset_aux <= '1';
    wait;
end process;


end Behavioral;
