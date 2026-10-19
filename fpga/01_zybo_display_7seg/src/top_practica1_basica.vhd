----------------------------------------------------------------------------------
-- Module Name: top_practica1_basica - Structural
-- Description: Top-level structural wrapper for multiplexed 2-digit BCD counter
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_practica1_basica is
    Port (
        clk  : in  STD_LOGIC;               -- Onboard clock (125 MHz)
        rst  : in  STD_LOGIC;               -- Pushbutton reset (BTN1)
        btn0 : in  STD_LOGIC;               -- Input trigger (BTN0 / SW0)
        segs : out unsigned (6 downto 0);   -- Anode segments to Pmod SSD (A to G)
        cat  : out unsigned (0 downto 0)    -- Cathode select line to Pmod SSD
    );
end top_practica1_basica;

architecture Structural of top_practica1_basica is

    -- Internal interconnection signals
    signal sFd     : STD_LOGIC;              -- Synchronized single-cycle edge pulse
    signal s1U     : STD_LOGIC;              -- Units terminal count carry
    signal sED     : STD_LOGIC;              -- Tens stage count enable
    signal cUnid   : unsigned(3 downto 0);   -- Units BCD register output
    signal cDece   : unsigned(3 downto 0);   -- Tens BCD register output
    signal c1milis : unsigned(0 downto 0);   -- Display multiplexing select line
    signal outMUX  : unsigned(3 downto 0);   -- Selected BCD digit sent to decoder

begin

    -- 1. Synchronous edge detector for button/switch input
    Inst_DetFlanco: entity work.det_flanco
        port map (
            clk => clk,
            rst => rst,
            btn => btn0,
            sFd => sFd
        );

    -- 2. Units modulo-10 BCD counter
    Inst_ContaUnidades: entity work.conta_bcd
        port map (
            clk     => clk,
            rst     => rst,
            en      => sFd,
            fcuenta => s1U,
            cuenta  => cUnid
        );

    -- Cascaded enable: increment tens only when units reach 9 and input pulses
    sED <= sFd and s1U;

    -- 3. Tens modulo-10 BCD counter
    Inst_ContaDecenas: entity work.conta_bcd
        port map (
            clk     => clk,
            rst     => rst,
            en      => sED,
            fcuenta => open,
            cuenta  => cDece
        );

    -- 4. 1 kHz refresh rate generator for display time-division multiplexing
    Inst_ContaMilis: entity work.conta_milis
        port map (
            clk     => clk,
            rst     => rst,
            en      => '1',
            c1milis => c1milis,
            fcuenta => open
        );

    -- 5. Data multiplexer: switches between units and tens based on active digit
    outMUX <= cUnid when c1milis = "0" else cDece;

    -- 6. Combinational BCD to 7-segment decoder
    Inst_BCD7Seg: entity work.bcd_7seg
        port map (
            bcd  => outMUX,
            segs => segs
        );

    -- 7. Common cathode drive
    cat <= c1milis;

end Structural;