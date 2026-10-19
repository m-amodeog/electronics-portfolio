----------------------------------------------------------------------------------
-- Module Name: conta_milis - Behavioral
-- Description: 1 ms time base generator and display digit multiplexer selector
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity conta_milis is
    Port (
        clk     : in  STD_LOGIC;              -- Master clock (125 MHz)
        rst     : in  STD_LOGIC;              -- Asynchronous active-high reset
        en      : in  STD_LOGIC;              -- Timer enable
        c1milis : out unsigned(0 downto 0);   -- Active digit selector
        fcuenta : out STD_LOGIC               -- 1 ms terminal count tick
    );
end conta_milis;

architecture Behavioral of conta_milis is

    -- 125 MHz / 1000 Hz = 125,000 cycles (count 0 to 124,999)
    constant C_FIN_CUENTA : integer := 125000 - 1;

    signal contador : integer range 0 to C_FIN_CUENTA := 0;
    signal sel      : unsigned(0 downto 0) := "0";
    signal tick     : STD_LOGIC := '0';

begin

    process(clk, rst)
    begin
        if rst = '1' then
            contador <= 0;
            sel      <= (others => '0');
            tick     <= '0';
        elsif rising_edge(clk) then
            tick <= '0';
            if en = '1' then
                if contador = C_FIN_CUENTA then
                    contador <= 0;
                    sel      <= not sel;  -- Toggle between digit 0 and digit 1
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