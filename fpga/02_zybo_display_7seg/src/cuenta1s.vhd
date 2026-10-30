----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: conta_1s - Behavioral
-- Project Name: Practica 1
-- Description: 1-second pulse generator for a 125 MHz clock domain (Real Time)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity conta_1s is
    Port (
        clk     : in  STD_LOGIC; -- Master system clock (125 MHz)
        rst     : in  STD_LOGIC; -- Asynchronous active-high reset
        en      : in  STD_LOGIC; -- Clock enable signal
        fcuenta : out STD_LOGIC  -- Output tick pulse asserted every 1 second
    );
end conta_1s;

architecture Behavioral of conta_1s is

    -- 125,000,000 clock cycles required to generate an exact 1-second pulse
    constant C_FIN_CUENTA : integer := 125000000 - 1;
    
    signal contador : integer range 0 to C_FIN_CUENTA := 0; -- Cycle counter register
    signal tick     : STD_LOGIC := '0';                     -- Internal registered tick pulse

begin

    -- Synchronous process for the 1-second frequency divider
    process(clk, rst)
    begin
        if rst = '1' then
            contador <= 0;
            tick     <= '0';
        elsif rising_edge(clk) then
            tick <= '0'; -- Pulse lasts for exactly one clock cycle
            if en = '1' then
                if contador = C_FIN_CUENTA then
                    contador <= 0;
                    tick     <= '1'; -- Assert tick upon terminal count
                else
                    contador <= contador + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- Concurrent output assignment
    fcuenta <= tick;

end Behavioral;