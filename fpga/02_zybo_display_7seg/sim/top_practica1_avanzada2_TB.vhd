----------------------------------------------------------------------------------
-- Company: Universidad Rey Juan Carlos
-- Engineer: Marco Antonio Amodeo Galan
-- 
-- Create Date: 26.10.2026
-- Module Name: top_practica1_avanzada2_TB - Behavioral
-- Project Name: Practica 1
-- Description: Advanced 2 Testbench (Complete verification of underflow, pause, and SWT1)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_practica1_avanzada2_TB is
-- Testbenches do not have input/output ports (Empty entity)
end top_practica1_avanzada2_TB;

architecture Behavioral of top_practica1_avanzada2_TB is

    -- Internal testbench signal declarations to drive the UUT
    signal clk     : STD_LOGIC := '0';             -- Master test clock signal
    signal rst     : STD_LOGIC := '0';             -- Test reset signal
    signal SWT0    : STD_LOGIC := '0';             -- Count direction switch (0: up, 1: down)
    signal SWT1    : STD_LOGIC := '0';             -- Master light kill-switch
    signal btn0    : STD_LOGIC := '0';             -- Push button to toggle run/pause
    signal leds    : unsigned(3 downto 0);         -- Observed output port: Tenths-of-a-second LEDs
    signal nled    : unsigned(0 downto 0);         -- Observed output port: Blinking RGB LED
    signal segs    : unsigned(6 downto 0);         -- Observed output port: 7-segment display bus (A-G)
    signal cat     : unsigned(0 downto 0);         -- Observed output port: Digit cathode selector

    -- Clock period constant for simulation (8 ns corresponds to 125 MHz)
    constant CLK_PERIOD : time := 8 ns;

begin

    -- Unit Under Test (UUT) instantiation connecting all top-level ports
    UUT: entity work.top_practica1_avanzada2
        port map (
            clk  => clk,
            rst  => rst,
            btn0 => btn0,
            segs => segs,
            cat  => cat,
            nled => nled,
            leds => leds,
            SWT0 => SWT0,
            SWT1 => SWT1
        );

    -- Continuous clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Sequential stimulus process to verify system functionality
    stim_proc: process
    begin
        -- Case 1: Initial reset assertion and configuration in down-counting mode
        rst  <= '1';
        SWT0 <= '1'; -- Direction configured to down-counting mode
        SWT1 <= '0'; -- Lights enabled by default
        btn0 <= '0';
        wait for 100 ns;

        -- Case 2: Reset deassertion (system starts at base state 00)
        rst <= '0';
        wait for 100 ns;

        -- Case 3: Button press simulation on btn0 to start counting
        -- Starting at 00 in down-counting mode verifies underflow wrap-around to 59
        btn0 <= '1';
        wait for 40 ns;
        btn0 <= '0';
        
        -- Extended wait to observe the decrement sequence: 00 -> 59 -> 58 -> 57...
        wait for 800 ns; 

        -- Case 4: Dynamic direction switch to up-counting mode (SWT0 = '0')
        SWT0 <= '0';
        -- Visual verification in simulation showing digits incrementing again
        wait for 500 ns; 

        -- Case 5: Verification of master lights-off feature via SWT1
        SWT1 <= '1'; 
        -- Lights (leds and nled) must turn off completely while 7-segments continue counting
        wait for 400 ns; 
        
        -- Restore lights by clearing SWT1
        SWT1 <= '0';
        wait for 300 ns;

        -- Case 6: System pause verification via a second press on btn0
        btn0 <= '1';
        wait for 40 ns;
        btn0 <= '0';
        wait for 300 ns; -- Verify that counting pauses and retains current state

        -- Case 7: Verification of a warm reset while running
        rst <= '1';
        wait for 80 ns;
        rst <= '0';

        -- End of simulation sequence
        wait;
    end process;

end Behavioral;