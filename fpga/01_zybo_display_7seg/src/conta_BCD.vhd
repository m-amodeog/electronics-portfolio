----------------------------------------------------------------------------------
-- Module Name: conta_bcd - Behavioral
-- Description: Modulo-10 decimal counter (0 to 9) with carry-out and enable
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity conta_bcd is
    Port (
        clk     : in  STD_LOGIC;              -- Master clock
        rst     : in  STD_LOGIC;              -- Asynchronous active-high reset
        en      : in  STD_LOGIC;              -- Count enable input
        fcuenta : out STD_LOGIC;              -- Terminal count carry pulse
        cuenta  : out unsigned (3 downto 0)   -- 4-bit BCD output value (0 to 9)
    );
end conta_bcd;

architecture Behavioral of conta_bcd is

    signal cuenta_o       : unsigned (3 downto 0);
    signal fcuenta_o      : STD_LOGIC;
    constant C_MAX_CUENTA : natural := 9;

begin

    -- Sequential counter register with asynchronous reset
    process (clk, rst)
    begin
        if rst = '1' then
            cuenta_o <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                if fcuenta_o = '1' then
                    cuenta_o <= (others => '0');
                else
                    cuenta_o <= cuenta_o + 1;
                end if;
            end if;
        end if;
    end process;

    -- Terminal count detection (modulo 10)
    fcuenta_o <= '1' when cuenta_o = C_MAX_CUENTA else '0';

    -- Output drive
    cuenta  <= cuenta_o;
    fcuenta <= fcuenta_o and en;

end Behavioral;