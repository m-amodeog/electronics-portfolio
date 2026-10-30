----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: flipflpT - Behavioral
-- Project Name: Practica 1
-- Description: T flip-flop with asynchronous reset
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflpT is
    Port ( 
        t   : in  STD_LOGIC; -- Toggle control input (trigger pulse)
        clk : in  STD_LOGIC; -- Master system clock
        rst : in  STD_LOGIC; -- Asynchronous active-high reset
        q   : out STD_LOGIC  -- Registered output state
    );
end flipflpT;

architecture Behavioral of flipflpT is

    signal q_ant : STD_LOGIC := '0'; -- Internal state register

begin

    -- Synchronous sequential process for T flip-flop operation with async reset
    process(clk, rst)
    begin
        if rst = '1' then
            q_ant <= '0';
        elsif rising_edge(clk) then
            if t = '1' then
                q_ant <= not q_ant; -- Toggle stored state on clock edge when T='1'
            end if;
        end if;
    end process;

    -- Concurrent output assignment
    q <= q_ant;

end Behavioral;