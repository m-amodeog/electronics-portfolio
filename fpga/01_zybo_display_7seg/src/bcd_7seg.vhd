----------------------------------------------------------------------------------
-- Module Name: bcd_7seg - Behavioral
-- Description: Combinational 4-bit BCD to active-high 7-segment decoder
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_7seg is
    Port (
        bcd  : in  unsigned (3 downto 0);  -- Input BCD digit (0 to 9)
        segs : out unsigned (6 downto 0)   -- Segment outputs abcdefg (active-high)
    );
end bcd_7seg;

architecture Behavioral of bcd_7seg is
begin

    -- Segment bus bit order:
    -- segs(6)=a, segs(5)=b, segs(4)=c, segs(3)=d, segs(2)=e, segs(1)=f, segs(0)=g
    process(bcd)
    begin
        case bcd is
            when "0000" => segs <= "1111110"; -- 0
            when "0001" => segs <= "0110000"; -- 1
            when "0010" => segs <= "1101101"; -- 2
            when "0011" => segs <= "1111001"; -- 3
            when "0100" => segs <= "0110011"; -- 4
            when "0101" => segs <= "1011011"; -- 5
            when "0110" => segs <= "1011111"; -- 6
            when "0111" => segs <= "1110000"; -- 7
            when "1000" => segs <= "1111111"; -- 8
            when "1001" => segs <= "1111011"; -- 9
            when others => segs <= "0000000"; -- Blank display
        end case;
    end process;

end Behavioral;