----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: conta_bcd - Behavioral
-- Project Name: Practica 1
-- Description: Bidirectional modulo-10 BCD counter (0 to 9)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity conta_bcd is
    Port (
        clk     : in  STD_LOGIC;              -- Master system clock
        rst     : in  STD_LOGIC;              -- Asynchronous reset
        en      : in  STD_LOGIC;              -- Count enable signal
        dir     : in  STD_LOGIC;              -- Direction control (0: up, 1: down)
        fcuenta : out STD_LOGIC;              -- Terminal count pulse (carry/borrow)
        cuenta  : out unsigned (3 downto 0)   -- Current 4-bit BCD count output
    );
end conta_bcd;

architecture Behavioral of conta_bcd is

    signal cuenta_o       : unsigned (3 downto 0); -- Internal register for current count value
    signal fcuenta_o      : STD_LOGIC;             -- Internal terminal count pulse signal
    constant C_MAX_CUENTA : natural := 9;          -- Maximum counter limit (9)

begin

    -- Synchronous sequential process to update the counter on clock edge or reset
    process (clk, rst)
    begin
        if rst = '1' then
            cuenta_o <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                if dir = '0' then 
                    -- Up-counting mode (0 to 9)
                    if cuenta_o = C_MAX_CUENTA then
                        cuenta_o <= (others => '0');
                    else
                        cuenta_o <= cuenta_o + 1;
                    end if;
                else 
                    -- Down-counting mode (9 to 0)
                    if cuenta_o = 0 then
                        cuenta_o <= to_unsigned(C_MAX_CUENTA, 4);
                    else
                        cuenta_o <= cuenta_o - 1;
                    end if;
                end if;  
            end if;
        end if;
    end process;

    -- Concurrent statement: detects terminal count depending on active direction
    fcuenta_o <= '1' when ((dir = '0' and cuenta_o = C_MAX_CUENTA) or (dir = '1' and cuenta_o = 0)) else '0';

    -- Concurrent output assignments
    cuenta  <= cuenta_o;
    fcuenta <= fcuenta_o and en;

end Behavioral;