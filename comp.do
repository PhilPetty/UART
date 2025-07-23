
# compile do-file for system

vmap work work

#compile the simulation model files 
#vcom +cover -lint ../model/clkRst.vhd
#vcom +cover -lint ../model/tdeUsbBench.vhd
vcom +cover -lint C:/Users/ppetty2/Documents/UART_VHDL_Files/model/tb_UART_sample_01.vhd

#compile logic files
vcom +cover -lint C:/Users/ppetty2/Documents/UART_VHDL_Files/logic/rstDualRankSync.vhd
vcom +cover -lint C:/Users/ppetty2/Documents/UART_VHDL_Files/logic/dualRankSync.vhd
vcom +cover -lint C:/Users/ppetty2/Documents/UART_VHDL_Files/logic/Rx_UART_sample_01.vhd
vcom +cover -lint C:/Users/ppetty2/Documents/UART_VHDL_Files/logic/tx_UART_sample_01.vhd
vcom +cover -lint C:/Users/ppetty2/Documents/UART_VHDL_Files/logic/UART_display.vhd
#vcom +cover -lint ../logic/tecSPI.vhd
#vcom +cover -lint ../logic/uartTx.vhd
#vcom +cover -lint ../logic/uartRx.vhd
#vcom +cover -lint ../logic/pktRx.vhd
#vcom +cover -lint ../logic/pktTx.vhd

vsim -novopt -t 1ns work.tb_UART_sample
do wave.do
run 100 ms
