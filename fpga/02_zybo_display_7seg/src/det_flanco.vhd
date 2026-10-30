----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: det_flanco - Behavioral
-- Project Name: Practica 1
-- Description: Rising edge detector implemented via a 2-stage shift register
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity det_flanco is
    Port (
        clk : in  STD_LOGIC; -- Master system clock
        rst : in  STD_LOGIC; -- Asynchronous reset
        btn : in  STD_LOGIC; -- Asynchronous/noisy physical input (push button)
        sFd : out STD_LOGIC  -- Clean single-cycle pulse output
    );
end det_flanco;

architecture Behavioral of det_flanco is

    signal q1 : STD_LOGIC := '0'; -- First sampling stage (synchronizer)
    signal q2 : STD_LOGIC := '0'; -- Second stage (previous state register)

begin

    -- Synchronous sequential process implementing 2-stage edge-detection pipeline
    process(clk, rst)
    begin
        if rst = '1' then
            q1 <= '0';
            q2 <= '0';
        elsif rising_edge(clk) then
            q1 <= btn;
            q2 <= q1;
        end if;
    end process;

    -- Concurrent combinational assignment: edge detection logic (current high, previous low)
    sFd <= q1 and (not q2);

end Behavioral;