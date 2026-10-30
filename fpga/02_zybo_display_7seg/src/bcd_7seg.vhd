----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: bcd_7seg - Behavioral
-- Project Name: Practica 1
-- Description: Combinational BCD (4-bit) to 7-segment decoder
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_7seg is
    Port (
        bcd  : in  unsigned (3 downto 0); -- Input BCD digit (0 to 9)
        segs : out unsigned (6 downto 0)  -- Segment outputs abcdefg (active-high)
    );
end bcd_7seg;

architecture Behavioral of bcd_7seg is
begin

    -- Combinational process using a case statement to decode each BCD digit
    process(bcd)
    begin
        case bcd is
            when "0000" => segs <= "1111110"; -- Display number 0
            when "0001" => segs <= "0110000"; -- Display number 1
            when "0010" => segs <= "1101101"; -- Display number 2
            when "0011" => segs <= "1111001"; -- Display number 3
            when "0100" => segs <= "0110011"; -- Display number 4
            when "0101" => segs <= "1011011"; -- Display number 5
            when "0110" => segs <= "1011111"; -- Display number 6
            when "0111" => segs <= "1110000"; -- Display number 7
            when "1000" => segs <= "1111111"; -- Display number 8
            when "1001" => segs <= "1111011"; -- Display number 9
            when others => segs <= "0000000"; -- Safe default: segments off for invalid codes
        end case;
    end process;

end Behavioral;