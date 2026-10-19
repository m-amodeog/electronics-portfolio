##################################################################################
## Target Board:  Digilent Zybo Z7-10 (XC7Z010-1CLG400C)
## Project Name:  Dual-Digit Multiplexed 7-Segment Display Controller
## File Name:     Zybo-Z7-10-Master.xdc
## Description:   Physical pin constraints and primary clock definition
##################################################################################

# ==============================================================================
# Primary Clock (125 MHz onboard oscillator)
# ==============================================================================
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }]

# ==============================================================================
# User Inputs (Reset and Count Trigger)
# ==============================================================================
# Asynchronous Master Reset (BTN1)
set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { rst }]

# Count Trigger: Option A - Pushbutton (BTN0)
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { btn0 }]

# Count Trigger: Option B - Slide Switch (SW0)
# (Comment line K18 and uncomment line G15 if you prefer using the switch)
# set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { btn0 }]

# ==============================================================================
# Digilent Pmod SSD (Dual 7-Segment Display Interface)
# ==============================================================================
# Pmod Header JC (SSD Connector J1: Segments A to D)
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { segs[6] }]; # JC1 -> Segment A
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports { segs[5] }]; # JC2 -> Segment B
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { segs[4] }]; # JC3 -> Segment C
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { segs[3] }]; # JC4 -> Segment D

# Pmod Header JD (SSD Connector J2: Segments E to G and Digit