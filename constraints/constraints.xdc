## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 }        [get_ports { Clock100MHz }];    #IO_L12P_T1_MRCC_35      Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5}   [get_ports { Clock100MHz }];

## Heater and Buzzer
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 }        [get_ports { Buzzer }];         #IO_L10N_T1_D15_14       Sch=ck_ioa

## ADC
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 }        [get_ports { ADC_CLK  }];       #IO_L17N_T2_A13_D29_14   Sch=ck_io[11]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 }        [get_ports { ADC_CS   }];       #IO_L12N_T1_MRCC_14      Sch=ck_io[12]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 }        [get_ports { ADC_DOUT }];       #IO_L7N_T1_D10_14        Sch=ck_io[38]

# SWITCH
set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 }        [get_ports { SW_zero }];        #IO_L12N_T1_MRCC_16      Sch=sw[0]