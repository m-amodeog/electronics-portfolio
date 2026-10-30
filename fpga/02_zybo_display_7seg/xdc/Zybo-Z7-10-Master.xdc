##----------------------------------------------------------------------------------
## Company: Universidad Rey Juan Carlos
## Engineer: Marco Antonio Amodeo Galan
## 
## Create Date: 26.10.2026
## File Name: constraints.xdc
## Project Name: Practica 1
## Description: Physical pin assignments and timing constraints for Zybo Z7
##----------------------------------------------------------------------------------

## Clock signal (125 MHz system clock)
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }]

## Push buttons and user controls
set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { rst }]   ;# Button 0 (System Reset)
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { btn0 }]  ;# Button 1 (Run/Pause toggle)

## Slide switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { SWT0 }]  ;# Switch 0 (Count direction: 0 up, 1 down)
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { SWT1 }]  ;# Switch 1 (Master lights kill-switch)

## Individual and RGB LEDs
set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS33 } [get_ports { nled[0] }] ;# RGB LED 6 (Blinking indicator)
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { leds[0] }] ;# User LED 0 (Tenths bit 0)
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { leds[1] }] ;# User LED 1 (Tenths bit 1)
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { leds[2] }] ;# User LED 2 (Tenths bit 2)
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { leds[3] }] ;# User LED 3 (Tenths bit 3)

## 7-Segment Display Pins (Pmod SSD interface)
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { segs[6] }] ;# Segment A
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { segs[5] }] ;# Segment B
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { segs[4] }] ;# Segment C
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { segs[3] }] ;# Segment D
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { segs[2] }] ;# Segment E
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { segs[1] }] ;# Segment F
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { segs[0] }] ;# Segment G
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { cat[0] }]  ;# Active cathode/anode select line