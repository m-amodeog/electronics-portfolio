----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: top_practica1_avanzada2 - Structural
-- Project Name: Practica 1
-- Description: Complete structural top-level design for Advanced Counter 2
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_practica1_avanzada2 is
    Port (
        clk     : in  STD_LOGIC;             -- Master system clock (125 MHz)
        rst     : in  STD_LOGIC;             -- System asynchronous reset
        btn0    : in  STD_LOGIC;             -- Push button input to pause/resume counting
        segs    : out unsigned (6 downto 0); -- 7-segment display output bus (A-G)
        cat     : out unsigned (0 downto 0); -- Active anode/cathode select line for multiplexing
        nled    : out unsigned (0 downto 0); -- Control output for blinking RGB LED
        leds    : out unsigned (3 downto 0); -- Output for 4 tenths-of-a-second indicator LEDs
        SWT0    : in  STD_LOGIC;             -- Direction switch (0: up, 1: down)
        SWT1    : in  STD_LOGIC              -- Master light kill-switch (1: forces LEDs off)
    );
end top_practica1_avanzada2;

architecture Structural of top_practica1_avanzada2 is

    -- Internal interconnection signal declarations
    signal s1U           : STD_LOGIC;             -- Terminal count indicator from units counter
    signal sED           : STD_LOGIC;             -- Enable signal for tens counter
    signal cUnid         : unsigned(3 downto 0);  -- Current BCD count value for units
    signal cDece         : unsigned(3 downto 0);  -- Current BCD count value for tens
    signal c1milis       : unsigned(0 downto 0);  -- Multiplexing frequency select signal
    signal s1Seg         : STD_LOGIC;             -- 1-second calibrated tick pulse
    signal sEU           : STD_LOGIC;             -- Enable signal for units counter
    signal led           : unsigned (0 downto 0); -- Internal half-second blink counter state
    signal q             : STD_LOGIC;             -- Stored run/pause state (T flip-flop output)
    signal salidaDecimas : STD_LOGIC;             -- Tenths-of-a-second tick pulse
    signal salidaLeds    : unsigned (3 downto 0); -- Binary value of tenths to display on LEDs
    signal sFd_btn0      : STD_LOGIC;             -- Single-cycle synchronized pulse from btn0
    signal outMUX        : unsigned (3 downto 0); -- Multiplexed BCD value routed to display decoder

begin

    -- Edge detector instantiation for button input synchronization
    Inst_DetFlanco: entity work.det_flanco
        port map (
            clk => clk,
            rst => rst,
            btn => btn0,
            sFd => sFd_btn0
        );

    -- T flip-flop instantiation to toggle and store the run/pause state
    Inst_FlipFlopT: entity work.flipflpT
        port map (
            clk => clk,
            rst => rst,
            t   => sFd_btn0,
            q   => q
        );
        
    -- Frequency divider instantiation for tenths-of-a-second timebase
    Inst_Conta_Decimas: entity work.cuentaDecimas
        port map (
            clk     => clk,
            rst     => rst,
            en      => q,
            fcuenta => salidaDecimas    
        );

    -- BCD counter instantiation to track and display tenths on LEDs
    Inst_ContaLEDS: entity work.conta_BCD
        port map (
            clk     => clk,
            rst     => rst,
            en      => salidaDecimas,
            cuenta  => salidaLeds,
            dir     => SWT0,
            fcuenta => open
        );
        
    -- Concurrent assignment: routes count to LEDs or forces them off when SWT1 is '1'
    leds <= salidaLeds when SWT1 = '0' else "0000";

    -- Master 1-second frequency divider instantiation
    Inst_Conta_1seg: entity work.conta_1s
        port map (
            clk     => clk,
            rst     => rst,
            en      => q,
            fcuenta => s1Seg
        );
        
    -- Concurrent assignment: enables units count only when unpaused and 1s tick arrives
    sEU <= q and s1Seg;
    
    -- Half-second frequency divider instantiation for visual LED blinking
    Inst_Conta_halfs: entity work.conta_halfs
        port map (
            clk     => clk,
            rst     => rst,
            en      => q,
            fcuenta => led   
        );
        
    -- Concurrent assignment: drives RGB LED with inverted logic, forces off if SWT1 is '1'
    nled <= not(led) when SWT1 = '0' else "0";
  
    -- Modulo-10 BCD units counter instantiation (0 to 9)
    Inst_ContaUnidades: entity work.conta_BCD
        port map (
            clk     => clk,
            rst     => rst,
            en      => sEU,
            dir     => SWT0,
            cuenta  => cUnid,
            fcuenta => s1U
        );
        
    -- Concurrent assignment: enables tens increment only when units reach terminal count
    sED <= sEU and s1U;
 
    -- Modulo-6 BCD tens counter instantiation (0 to 5)
    Inst_ContaDecenas: entity work.conta_BCD1
        port map (
            clk     => clk,
            rst     => rst,
            en      => sED,
            dir     => SWT0,
            cuenta  => cDece,
            fcuenta => open
        );

    -- Fast refresh timer instantiation (approx. 1 kHz) for display multiplexing
    Inst_ContaMilis: entity work.conta_milis
        port map (
            clk     => clk,
            rst     => rst,
            en      => '1',
            c1milis => c1milis,
            fcuenta => open
        );

    -- Display multiplexer: alternates units or tens data according to refresh cycle
    outMUX <= cUnid when c1milis = "0" else cDece;

    -- BCD to 7-segment decoder instantiation
    Inst_BCD7Seg: entity work.bcd_7seg
        port map (
            bcd  => outMUX,
            segs => segs
        );

    -- Concurrent assignment: routes refresh signal to physical digit select pin
    cat <= c1milis; 

end Structural;