----------------------------------------------------------------------------------
-- Module Name: det_flanco - Behavioral
-- Description: Rising edge detector using a 2-stage shift register
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity det_flanco is
    Port (
        clk : in  STD_LOGIC;  -- Master clock (125 MHz)
        rst : in  STD_LOGIC;  -- Asynchronous active-high reset
        btn : in  STD_LOGIC;  -- Asynchronous button input
        sFd : out STD_LOGIC   -- Single-cycle edge detection pulse
    );
end det_flanco;

architecture Behavioral of det_flanco is

    signal q1 : STD_LOGIC := '0';
    signal q2 : STD_LOGIC := '0';

begin

    -- Two-flip-flop synchronizer and delay chain
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

    -- Edge detection logic: active when current sample is high and previous is low
    sFd <= q1 and (not q2);

end Behavioral;