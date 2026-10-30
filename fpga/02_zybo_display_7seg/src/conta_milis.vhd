----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: conta_milis - Behavioral
-- Project Name: Practica 1
-- Description: Timebase generator for 7-segment display multiplexing (Real Time)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity conta_milis is
    Port (
        clk     : in  STD_LOGIC;             -- Input clock
        rst     : in  STD_LOGIC;             -- Reset signal
        en      : in  STD_LOGIC;             -- Enable signal
        c1milis : out unsigned(0 downto 0);  -- Digit select control signal
        fcuenta : out STD_LOGIC              -- Overflow tick pulse
    );
end conta_milis;

architecture Behavioral of conta_milis is
    -- 125,000 cycles for an approximate 1 kHz refresh rate
    constant C_FIN_CUENTA : integer := 125000 - 1; 
    
    signal contador : integer range 0 to C_FIN_CUENTA := 0;
    signal sel      : unsigned(0 downto 0) := "0";
    signal tick     : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            tick <= '0';
            if en = '1' then
                if contador = C_FIN_CUENTA then
                    contador <= 0;
                    sel      <= not sel;
                    tick     <= '1';
                else
                    contador <= contador + 1;
                end if;
            end if;
        end if;
    end process;
    
    c1milis <= sel;
    fcuenta <= tick;

end Behavioral;