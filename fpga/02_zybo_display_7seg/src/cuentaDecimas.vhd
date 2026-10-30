----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: cuentaDecimas - Behavioral
-- Project Name: Practica 1
-- Description: Tenths-of-a-second pulse generator (125 MHz - Real Time)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cuentaDecimas is
    Port (
        clk     : in  STD_LOGIC; -- Master system clock
        rst     : in  STD_LOGIC; -- Asynchronous reset
        en      : in  STD_LOGIC; -- Count enable signal
        fcuenta : out STD_LOGIC  -- Output pulse asserted every 0.1 seconds
    );
end cuentaDecimas;

architecture Behavioral of cuentaDecimas is
    -- 12,500,000 clock cycles required for an exact 0.1-second interval
    constant C_FIN_CUENTA : integer := 125000000/10 - 1;
    
    signal contador : integer range 0 to C_FIN_CUENTA := 0;
    signal tick     : STD_LOGIC := '0';
begin

    -- Synchronous sequential process for the 0.1-second frequency divider
    process(clk, rst)
    begin
        if rst = '1' then
            contador <= 0;
            tick     <= '0';
        elsif rising_edge(clk) then
            tick <= '0';
            if en = '1' then
                if contador = C_FIN_CUENTA then
                    contador <= 0;
                    tick     <= '1';
                else
                    contador <= contador + 1;
                end if;
            end if;
        end if;
    end process;

    -- Concurrent output assignment
    fcuenta <= tick;

end Behavioral;