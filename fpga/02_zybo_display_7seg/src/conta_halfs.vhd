----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: conta_halfs - Behavioral
-- Project Name: Practica 1
-- Description: Half-second timebase generator for LED blinking (Real Time)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity conta_halfs is
    Port (
        clk     : in  STD_LOGIC;             -- Master system clock
        rst     : in  STD_LOGIC;             -- Asynchronous reset
        en      : in  STD_LOGIC;             -- Count enable signal
        fcuenta : out unsigned(0 downto 0)   -- Alternating output toggling every 0.5s
    );
end conta_halfs;

architecture Behavioral of conta_halfs is
    -- 62,500,000 clock cycles for an accurate 0.5-second period
    constant C_FIN_CUENTA : integer := 125000000/2 - 1;
    
    signal contador : integer range 0 to C_FIN_CUENTA := 0;
    signal sel      : unsigned(0 downto 0) := "0";
begin

    process(clk, rst)
    begin
        if rst = '1' OR en = '0' then
            contador <= 0;
            sel      <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                if contador = C_FIN_CUENTA then
                    contador <= 0;
                    sel      <= not sel;
                else
                    contador <= contador + 1;
                end if;
            end if;
        end if;
    end process;
    
    fcuenta <= sel;

end Behavioral;